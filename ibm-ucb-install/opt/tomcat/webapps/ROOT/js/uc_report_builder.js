/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var UC_REPORT_BUILDER = Class.create({

    /**
     * Constructor
     */
    initialize: function(options) {
        this.imagesUrl = options.imagesUrl;
        this.queryUrl = options.queryUrl;
        this.tablesUrl = options.tablesUrl;
        this.dimensionsUrl = options.dimensionsUrl;
        this.tablesAndDimensionsUrl = options.tablesAndDimensionsUrl;
        this.reportsUrl = options.reportsUrl;

        this.nextQueryId = 1; // base query is 0
        this.tableMap = [];
        this.dimensionMap = [];
        this.queryMap = [];
        this.reportMap = [];
        this.queryCoordinates = [];
        this.modalQueryId;
        this.modalCriteriaIndex;

        this.reportId = null;
        this.reportName = null;
        this.reportRunning = false;
        this.outputConfig;

        this.viewingManualQuery = false;

        this.lastQueryRun = '';
        this.currentResults = null;

        this.paramNamePrefix = options.paramNamePrefix ? options.paramNamePrefix : '';
    },

    findColumnByName: function(table, columnName) {
        var matchingColumn;
        jQuery.each(table.columns, function(index, column) {
            if (column.name === columnName) {
                matchingColumn = column;
                return;
            }
        });
        return matchingColumn;
    },

    // ----------------------------------------------------
    // Data access methods
    // ----------------------------------------------------
    getAllSavedReports: function(doneCallback) {
        var self = this;
        var ajaxGetReports = jQuery.ajax({
            url : self.reportsUrl,
            type : 'GET',
            accepts : {
                text : 'application/json'
            },
            contentType : 'application/json',
            dataType : "json"
        });
        ajaxGetReports.done(doneCallback);
        ajaxGetReports.fail(function(jqXHR, textStatus) {
            alert(i18n("ReportsFailedToGetSaved") + " " + textStatus);
        });
    },

    getSavedReport: function(reportName, doneCallback) {
        var self = this;
        var ajaxGetReports = jQuery.ajax({
            url : self.reportsUrl + '/' + encodeURIComponent(reportName),
            type : 'GET',
            accepts : {
                text : 'application/json'
            },
            contentType : 'application/json',
            dataType : "json"
        });
        ajaxGetReports.done(function(report) {
            if (!report.query.criteria) {
                report.query.criteria = [];
            }
            self.queryMap = [];
            self.queryMap[0] = report.query;
            self.reportId = report.id;
            self.reportName = report.name;
            self.outputConfig = report.output;
            var reportDesc = report.description ? report.description : "";
            jQuery('#translatedName').text(i18n(report.name));
            if (reportDesc) {
                jQuery('#translatedDesc').text(i18n(reportDesc));
            }
            jQuery('input[name=reportName]').val(report.name);
            jQuery('textarea[name=reportDesc]').val(reportDesc);
            self.drawQuery();
            doneCallback(report);
        });
        ajaxGetReports.fail(function(jqXHR, textStatus) {
            alert(i18n("ReportsFailedToGetSaved") + " " + textStatus);
        });
    },

    deleteSavedReport: function(reportName, doneCallback) {
        var self = this;
        var ajaxDeleteReport = jQuery.ajax({
            url : self.reportsUrl + '/' + encodeURIComponent(reportName),
            type : 'DELETE',
            accepts : {
                text : 'application/json'
            },
            contentType : 'application/json',
            dataType : "json"
        });
        ajaxDeleteReport.done(doneCallback);
        ajaxDeleteReport.fail(function(jqXHR, textStatus) {
            alert(i18n("ReportsFailedToGetSaved") + " " + textStatus);
        });
    },

    getAllTables: function() {
        var self = this;
        var ajaxGetTables = jQuery.ajax({
            async : false,
            url : self.tablesUrl,
            type : 'GET',
            accepts : {
                text : 'application/json'
            },
            contentType : 'application/json',
            dataType : "json"
        });
        ajaxGetTables.done(function(tables) {
            jQuery.each(tables, function(index, table) {
                self.getTable(table.name);
            });
        });
        ajaxGetTables.fail(function(jqXHR, textStatus) {
            alert(i18n("ReportingFailedGettingTables") + " " + textStatus);
        });
    },

    getAllDimensions: function() {
        var self = this;
        var ajaxGetDimensions = jQuery.ajax({
            async : false,
            url : self.dimensionsUrl,
            type : 'GET',
            accepts : {
                text : 'application/json'
            },
            contentType : 'application/json',
            dataType : "json"
        });
        ajaxGetDimensions.done(function(dimensions) {
            jQuery.each(dimensions, function(index, dimension) {
                self.getDimension(dimension.name);
            });
        });
        ajaxGetDimensions.fail(function(jqXHR, textStatus) {
            alert(i18n("ReportingFailedGettingDimensions") + " " + textStatus);
        });
    },

    getTable: function(tableName, callback) {
        var self = this;
        var request = jQuery.ajax({
            async : false,
            url : self.tablesUrl + '/' + encodeURIComponent(tableName) + '/expanded',
            type : 'GET',
            dataType : "json"
        });
        request.done(function(msg) {
            self.tableMap[msg.name] = msg;
            if (callback) {
                callback(msg);
            }
        });
        request.fail(function(jqXHR, textStatus) {
            alert(i18n("TableFailedGetting") + " " + textStatus);
        });
    },

    getDimension: function(dimensionName, callback) {
        var self = this;
        var request = jQuery.ajax({
            async : false,
            url : self.dimensionsUrl + '/' + encodeURIComponent(dimensionName) + '/expanded',
            type : 'GET',
            dataType : "json"
        });
        request.done(function(msg) {
            self.dimensionMap[msg.name] = msg;
            if (callback) {
                callback(msg);
            }
        });
        request.fail(function(jqXHR, textStatus) {
            alert(i18n("DimensionFailedGetting") + " " + textStatus);
        });
    },

    // ----------------------------------------------------
    // Detail methods
    // ----------------------------------------------------
    openColumnsPopup: function(queryId) {
        var self = this;
        self.modalQueryId = queryId;
        var query = self.queryMap[queryId];
        var tableName = query.table ? query.table : query.dimension;
        var table = query.table ? self.tableMap[tableName] : self.dimensionMap[tableName];

        jQuery('#columnsTable').html(i18n(table.display_name));
        jQuery('#reportColumns tbody tr').remove();
        jQuery('#includedReportColumns tbody tr').remove();

        if (!query.columns || query.columns.length == 0) {
            jQuery.each(table.columns, function(index, column) {
                self.renderIncludedColumn(column);
            });
        }
        else {
            jQuery.each(table.columns, function(index, column) {
                if (!self.findColumnByName(query, column.name)) {
                    self.renderColumn(column);
                }
            });

            // set aliases and functions
            jQuery.each(query.columns, function(index, column) {
                if (self.isCompoundColumn(column)) {
                    self.includeCompoundColumn(column.name, column.alias, column['function']);
                }
                else {
                    self.renderIncludedColumn(column);
                }

                if (column.alias) {
                    jQuery('#includedReportColumns input[name="alias|' + column.name + '"]').val(column.alias);
                }
                if (column['function']) {
                    jQuery('#includedReportColumns select[name="funct|' + column.name + '"]').val(column['function']);
                }
            });
        }
        jQuery('#includedReportColumns tbody').sortable({
            containment: "parent",
            handle: ".dndHandle",
            items: "> tr",
            tolerance: "pointer"
        });
        self.displayModal('#columnsContainer'); //, 800);
    },

    updateColumns: function() {
        var self = this;
        var query = self.queryMap[self.modalQueryId];
        query.columns = [];
        jQuery.each(jQuery('#includedReportColumns input'), function(index, input) {
            if (input.getAttribute("type") === 'hidden') {
                var columnAlias = jQuery('#includedReportColumns input[name="alias|' + input.name + '"]').val();
                var columnFunction = jQuery('#includedReportColumns select[name="funct|' + input.name + '"]').val();
                var column = { name : input.name };
                if (columnAlias) {
                    column.alias = columnAlias;
                }
                if (columnFunction) {
                    column['function'] = columnFunction;
                }
                query.columns.push(column);
            }
            else if (input.getAttribute("type") === 'text' && input.getAttribute("name") === 'compound_column') {
                var columnName = jQuery(input).val();
                if (columnName) {
                    var column = { name : columnName };
                    var columnAlias = jQuery(input).parent().parent().find('input[name="compound_column_alias"]').val();
                    var columnFunction = jQuery(input).parent().parent().find('select[name="compound_column_funct"]').val();
                    if (columnAlias) {
                        column.alias = columnAlias;
                    }
                    if (columnFunction) {
                        column['function'] = columnFunction;
                    }
                    query.columns.push(column);
                }
            }
        });
        self.closeModals();
        jQuery('#query' + self.modalQueryId + ' .table_columns').html(i18n('IncludingXColumns', query.columns.length));
    },

    includeAllColumns: function() {
        var self = this;
        jQuery('#reportColumns tbody tr a').click();
    },

    removeAllColumns: function() {
        var self = this;
        jQuery('#includedReportColumns tbody tr a').click();
    },

    includeColumn: function(link, columnName) {
        var self = this;
        if (link) {
            var row = jQuery(link).parent().parent();
            row.remove();
        }
        var query = self.queryMap[self.modalQueryId];
        var tableName = query.table ? query.table : query.dimension;
        var table = query.table ? self.tableMap[tableName] : self.dimensionMap[tableName];
        var column = self.findColumnByName(table, columnName);
        self.renderIncludedColumn(column);
    },

    isCompoundColumn: function(column) {
        return column.name.indexOf(' ') > 0 || column.name.indexOf('+') > 0;
    },

    includeCompoundColumn: function(columnName, columnAlias, columnFunct) {
        var self = this;
        var html = '<tr>' +
            '<td class="dndHandle"><img src="' + self.imagesUrl + '/icon_grabber.gif"/></td>' +
              '<td><input type="text" name="compound_column" size="60"';
        html += '/></td>' +
            '<td><input type="text" name="compound_column_alias" class="columnAlias" size="20"/></td>' +
            '<td><select name="compound_column_funct" class="columnFunction"> ' +
            '<option value="">--</option>' +
            '<option value="AVG">' + i18n("Average") + '</option>' +
            '<option value="COUNT">' + i18n("Count") + '</option>' +
            '<option value="COUNT_DISTINCT">' + i18n("CountDistinct") + '</option>' +
            '<option value="DISTINCT">' + i18n("Distinct") + '</option>' +
            '<option value="MAX">' + i18n("Max") + '</option>' +
            '<option value="SUM">' + i18n("Sum") + '</option>' +
            '<option value="MIN">' + i18n("Min") + '</option>' +
            '</select></td>' +
            '<td nowrap="nowrap"><a href="#" onclick="reportBuilder.removeColumn(this); return false;"><img src="' +
            self.imagesUrl + '/reporting/close.png"/></a></td>' +
            '</tr>';
        jQuery('#includedReportColumns tbody').append(html);
        jQuery('#includedReportColumns tbody input[name="compound_column"]').last().val(columnName);
        if (columnAlias) {
            jQuery('#includedReportColumns tbody input[name="compound_column_alias"]').last().val(columnAlias);
        }
        if (columnFunct) {
            jQuery('#includedReportColumns tbody select[name="compound_column_funct"]').last().val(columnFunct);
        }
    },

    renderIncludedColumn: function(column) {
        var self = this;
        var columnName = column.name;
        var columnDesc = column.description ? column.description : '';
        var html = '<tr title="' + columnDesc + '">' +
            '<td class="dndHandle"><img src="' + self.imagesUrl + '/icon_grabber.gif"/></td>' +
              '<td><input type="hidden" name="' + columnName + '"/>' + columnName + '</td>' +
            '<td><input type="text" name="alias|' + columnName + '" class="columnAlias" size="20"/></td>' +
            '<td><select name="funct|' + columnName + '" class="columnFunction"> ' +
            '<option value="">--</option>' +
            '<option value="AVG">' + i18n("Average") + '</option>' +
            '<option value="COUNT">' + i18n("Count") + '</option>' +
            '<option value="COUNT_DISTINCT">' + i18n("CountDistinct") + '</option>' +
            '<option value="DISTINCT">' + i18n("Distinct") + '</option>' +
            '<option value="MAX">' + i18n("Max") + '</option>' +
            '<option value="SUM">' + i18n("Sum") + '</option>' +
            '<option value="MIN">' + i18n("Min") + '</option>' +
            '</select></td>' +
            '<td nowrap="nowrap"><a href="#" onclick="reportBuilder.removeColumn(this, \'' + columnName +
              '\'); return false;"><img src="' + self.imagesUrl + '/reporting/close.png"/></a></td>' +
            '</tr>';
        jQuery('#includedReportColumns tbody').append(html);
    },

    removeColumn: function(link, columnName) {
        var self = this;
        if (link) {
            var row = jQuery(link).parent().parent();
            row.remove();
        }
        if (columnName) {
            var query = self.queryMap[self.modalQueryId];
            var tableName = query.table ? query.table : query.dimension;
            var table = query.table ? self.tableMap[tableName] : self.dimensionMap[tableName];
            var column = self.findColumnByName(table, columnName);
            self.renderColumn(column);
        }
    },

    renderColumn: function(column) {
        var self = this;
        var columnName = column.name;
        var columnDesc = column.description ? column.description : '';
        var html = '<tr title="' + columnDesc + '">' +
            '<td><span id="' + columnName + '">' + columnName + '</span></td>' +
            '<td><a href="#" onclick="reportBuilder.includeColumn(this, \'' + columnName +
            '\'); return false;"><img src="' + self.imagesUrl + '/icon_add.gif"/></a></td>' +
            '</tr>';
        jQuery('#reportColumns tbody').append(html);
    },

    // ----------------------------------------------------
    // Filter methods
    // ----------------------------------------------------
    openFilterPopup: function(queryId, criteriaIndex) {
        var self = this;
        self.modalCriteriaIndex = -1;
        self.modalQueryId = queryId;
        var query = self.queryMap[queryId];
        var tableName = query.table ? query.table : query.dimension;
        var table = query.table ? self.tableMap[query.table] : self.dimensionMap[query.dimension];

        var filterColumn = jQuery('#filterColumn');
        var options = filterColumn.prop('options');
        jQuery('option', filterColumn).remove();

        // filter on all columns not just the ones in the query
        var columns = table.columns;
        jQuery.each(columns, function(index, column) {
            var option = new Option(column.display_name, column.name);
            option.title = column.description;
            options[options.length] = option;
        });
        if (query.columns) {
            jQuery.each(query.columns, function(index, column) {
                if (self.isCompoundColumn(column)) {
                    var displayName = column.alias ? column.alias : column.name;
                    var option = new Option(column.name, column.name);
                    option.title = displayName;
                    options[options.length] = option;
                }
            });
        }

        if (criteriaIndex) {
            self.modalCriteriaIndex = criteriaIndex;
            var criteria = query.criteria[criteriaIndex];
            jQuery('#filterColumn').val(criteria.column);
            jQuery('#filterType').val(criteria.type);
            if (criteria.paramName) {
                jQuery('input[name=filterValueType][value=param]').prop('checked',true);
                jQuery('#filterParamLabel').val(criteria.paramName);
                jQuery('#filterParamType').val(criteria.paramType);
            }
            else if (criteria.value || criteria.values) {
                if (criteria.type == 'in') {
                    jQuery('#filterValues').val(criteria.values.join('\n'));
                }
                else {
                    jQuery('#filterValue').val(criteria.value);
                }
                jQuery('input[name=filterValueType][value=enter]').prop('checked',true);
            }
        }

        self.displayModal('#filterContainer');
        self.filterColumnSelected();
        self.filterTypeChanged();
    },

    filterColumnSelected: function() {
        var self = this;
        var columnSelect = jQuery('#filterColumn')[0];
        var selectedOption = columnSelect.options[columnSelect.selectedIndex];
        jQuery('#filterColumnDesc').html(i18n(selectedOption.title));
        self.filterValueTypeChanged();
    },

    filterTypeChanged: function() {
        var self = this;
        var typeSelected = jQuery("select[name=filterType]").val();
        if (typeSelected == 'is_null' || typeSelected == 'not_null') {
            jQuery('.filterValueConfig').hide();
        }
        else {
            jQuery('#filterValueTypeDiv').show();
            self.filterValueTypeChanged();
        }
    },

    filterValueTypeChanged: function() {
        var self = this;
        var typeSelected = jQuery("select[name=filterType]").val();
        var valueTypeSelected = jQuery("input[name=filterValueType]:checked").val();
        if (valueTypeSelected == 'enter') {
            jQuery('#filterSelectValueDiv').hide();
            jQuery('#filterSelectValuesDiv').hide();
            jQuery('#filterParamValueDiv').hide();
            if (typeSelected == 'in') {
                jQuery('#filterEnterValueDiv').hide();
                jQuery('#filterEnterValuesDiv').show();
            }
            else {
                jQuery('#filterEnterValuesDiv').hide();
                jQuery('#filterEnterValueDiv').show();
            }
        }
        else if (valueTypeSelected == 'select') {
            var query = self.queryMap[self.modalQueryId];
            var selectedColumn = jQuery('#filterColumn').val();
            jQuery('#filterEnterValueDiv').hide();
            jQuery('#filterEnterValuesDiv').hide();
            jQuery('#filterParamValueDiv').hide();
            if (typeSelected == 'in') {
                jQuery('#filterSelectValueDiv').hide();
                jQuery('#filterSelectValuesDiv').show();
                self.drawUniqueValuesToSelect('#filterSelectValues', query, selectedColumn, undefined);
            }
            else {
                jQuery('#filterSelectValuesDiv').hide();
                jQuery('#filterSelectValueDiv').show();
                self.drawUniqueValuesToSelect('#filterSelectValue', query, selectedColumn, undefined);
            }
        }
        else if (valueTypeSelected == 'param') {
            jQuery('#filterEnterValueDiv').hide();
            jQuery('#filterEnterValuesDiv').hide();
            jQuery('#filterSelectValueDiv').hide();
            jQuery('#filterSelectValuesDiv').hide();
            jQuery('#filterParamValueDiv').show();
        }
        else { // nothing selected
            jQuery('#filterEnterValueDiv').hide();
            jQuery('#filterEnterValuesDiv').hide();
            jQuery('#filterSelectValueDiv').hide();
            jQuery('#filterSelectValuesDiv').hide();
            jQuery('#filterParamValueDiv').hide();
        }
    },

    addFilter: function() {
        var self = this;
        var selectedColumn = jQuery('#filterColumn').val();
        var selectedType = jQuery('#filterType').val();
        var selectedValueType = jQuery('input[name=filterValueType]:checked').val();
        var selectedValue;
        var selectedValues;
        var selectedParamLabel;
        var selectedParamType;
        if (selectedType != 'is_null' && selectedType != 'not_null') {
            if (selectedValueType == 'enter') {
                if (selectedType == 'in') {
                    selectedValues = jQuery('#filterValues').val().split("\n");
                }
                else {
                    selectedValue = jQuery('#filterValue').val();
                }
            }
            else if (selectedValueType == 'select') {
                if (selectedType == 'in') {
                    selectedValues = jQuery('#filterSelectValues').val();
                }
                else {
                    selectedValue = jQuery('#filterSelectValue').val();
                }
            }
            else if (selectedValueType == 'param') {
                selectedParamLabel = jQuery('#filterParamLabel').val();
                if (!selectedParamLabel) {
                    alert(i18n("LabelRequiredParameterFilterValue"));
                    return;
                }
                // TODO validate there are no conflicts with existing labels
                selectedParamType = jQuery('#filterParamType').val();
                if (!selectedParamType) {
                    alert(i18n("InputRequiredParameterFilter"));
                    return;
                }
                // selectedValue should be null
            }
        }
        var query = self.queryMap[self.modalQueryId];
        var criteria = {
            type : selectedType,
            column : selectedColumn
        };
        if (selectedValue) {
            criteria.value = selectedValue;
        }
        if (selectedValues) {
            criteria.values = selectedValues;
        }
        if (selectedParamLabel) {
            criteria.paramName = selectedParamLabel;
        }
        if (selectedParamType) {
            criteria.paramType = selectedParamType;
        }
        self.closeModals();
        var drawParameters = selectedValueType == 'param';
        if (self.modalCriteriaIndex >= 0) {
            if (query.criteria[self.modalCriteriaIndex].paramName) {
                drawParameters = true;
            }
            query.criteria[self.modalCriteriaIndex] = criteria;
            self.redrawFilters(self.modalQueryId);
        }
        else {
            query.criteria.push(criteria);
            self.redrawFilters(self.modalQueryId);
        }

        if (drawParameters) {
            self.drawParameters(query);
        }
    },

    removeFilter: function(queryId, criteriaIndex) {
        var self = this;
        var query = self.queryMap[queryId];
        var redrawParameters = query.criteria[criteriaIndex].paramName
        query.criteria.splice(criteriaIndex, 1);
        self.redrawFilters(queryId);
        if (redrawParameters) {
            self.drawParameters(query);
        }
    },

    redrawFilters: function(queryId) {
        var self = this;
        var query = self.queryMap[queryId];
        jQuery('#query' + queryId + ' .table_filters').html('');
        self.drawFilters(queryId, query.criteria);
    },

    drawFilters: function(queryId, criteria) {
        var self = this;
        var html = "<table><tbody>";
        jQuery.each(criteria, function(criteriaIndex, criteria) {
            if (criteria) {
                html += self.drawFilter(queryId, criteriaIndex, criteria);
            }
        });
        html += "</tbody></table>";
        var filterSelector = '#query' + queryId + ' .table_filters';
        jQuery(filterSelector).append(html);
        jQuery(filterSelector + ' tbody').sortable({
            containment: "parent",
            handle: ".dndHandle",
            items: "> tr",
            tolerance: "pointer",
            out: function(event, ui) {
                var query = self.queryMap[queryId];
                var paramOrder = jQuery(this).sortable('toArray');
                self.updateParameterOrdering(query, paramOrder);
                self.drawParameters(query);
                self.redrawFilters(queryId);
            }
        });
    },

    updateParameterOrdering: function(query, paramOrder) {
        jQuery.each(paramOrder, function(index, param) {
            var name = param.split('_')[0];
            var oldIndex = param.split('_')[1];
            // Get the old parameter that shares an index with this current parameter for comparison
            var criteria = query.criteria[index]
            if (name != criteria.paramName) {
                // The new ordering does not have the parameter in the correct spot, remove it from the spot it is in
                // and place it in the index that the user has moved it to
                var criteria = query.criteria.splice(oldIndex, 1)[0];
                query.criteria.splice(index, 0, criteria);
            }
        });
    },

    drawFilter: function(queryId, criteriaIndex, criteria) {
        var self = this;
        var html = '<tr id="' + criteria.paramName + '_' + criteriaIndex + '"><td class="dndHandle"><img src="' +
            self.imagesUrl + '/icon_grabber.gif"/><td><td>' + criteria.column + ' ' + i18n(criteria.type) + ' ';
        if (criteria.paramName) {
            html += '{' + criteria.paramName + '}';
        }
        else if (criteria.value) {
            html += criteria.value + ' ';
        }
        else if (criteria.values) {
            html += criteria.values + ' ';
        }
        html += ' &nbsp;<a href="#editFilter" title="' + i18n('Edit') + '" onclick="reportBuilder.openFilterPopup(\'' +
            queryId + '\', \'' + criteriaIndex + '\'); return false;"><img src="' + self.imagesUrl +
            '/icon_pencil_edit_disabled.gif"></a>' + ' &nbsp;<a href="#removeFilter" title="' +
            i18n('Remove') + '" onclick="reportBuilder.removeFilter(\'' + queryId + '\', \'' + criteriaIndex +
            '\'); return false;"><img src="' + self.imagesUrl + '/reporting/close.png"></a></td></tr>';
        return html;
    },

    drawOutputConfig: function() {
        var self = this;
        var html = '';
        if (self.outputConfig) {
            html += i18n('Output') + ': ' + self.outputConfig.type;
        }
        jQuery('.table_output_config').html(html);
    },

    drawParameters: function(query) {
        var self = this;
        var existingParams = [];
        var existingParamValues = [];
        if (query.criteria) {
            jQuery.each(query.criteria, function(criteriaIndex, criteria) {
                if (criteria.paramName) {
                    existingParams.push(criteria.paramName);
                }
            });
        }
        jQuery.each(existingParams, function(existingParamIndex, existingParam) {
            existingParamValues[existingParam] = jQuery('#param_' + existingParam.replace(' ', '_')).val();
        });
        var paramHtml = '<table><tbody>';
        if (query.criteria) {
            jQuery.each(query.criteria, function(criteriaIndex, criteria) {
                var criteriaType = criteria.type;
                var paramName = criteria.paramName;
                if (paramName) {
                    var inputName = self.paramNamePrefix + paramName;
                    paramHtml += '<tr><td width="10%" nowrap="nowrap">';
                    paramHtml += '<label>' + paramName + ': <span class="required-text">*</span></label></td><td>';
                    var paramId = "param_" + paramName.replace(' ', '_');
                    var paramValue = existingParamValues[paramName];
                    if (!paramValue) {
                        paramValue = '';
                    }
                    if (criteria.paramType == 'select') {
                        paramHtml += '<select id="' + paramId + '" name="' + inputName + '"';
                        if (criteriaType == 'in') {
                            paramHtml += ' multiple="true"'
                        }
                        paramHtml += ' onchange="reportBuilder.parametersOnChange(0,' + criteriaIndex +')"></select>';
                    }
                    else if (criteriaType == 'in') {
                        paramHtml += '<textarea id="' + paramId + '" name="' + inputName +
                            '" cols="40" rows="5" title="' + i18n('EnterEachValueOnANewLine') + '">' + paramValue +
                            '</textarea>';
                    }
                    else { // criteria.paramType == 'enter'
                        paramHtml += '<input type="text" id="' + paramId + '" name="' + inputName + '" value="' +
                            paramValue + '"/>';
                    }
                    paramHtml += '</td></tr>';
                }
            });
        }
        paramHtml += '</tbody></table>';
        var paramContainer = jQuery('#paramContainer');
        paramContainer.html('');
        paramContainer.html(paramHtml);
        self.parametersOnChange(0, -1);
    },

    parametersOnChange: function(queryId, index) {
        var self = this;
        var query = self.queryMap[queryId];
        if (query.criteria) {
            jQuery.each(query.criteria, function(criteriaIndex, criteria) {
                if (criteriaIndex > index) {
                    var paramName = criteria.paramName;
                    if (paramName) {
                        var paramSelector = "#param_" + paramName.replace(' ', '_');
                        if (criteria.paramType == 'select') {
                            self.drawUniqueValuesToSelect(paramSelector, query, criteria.column, criteriaIndex);
                        }
                    }
                }
            });
        }
    },

    drawUniqueValuesToSelect: function(selectSelector, query, columnName, index) {
        var self = this;
        var tableName = query.table ? query.table : query.dimension;
        var resultColumnName = "DISTINCT(" + columnName.replace(/\./g, "_") + ")";
        var criteria = [];
        var defaultOption = '-- ' + i18n("MakeSelection") + ' --';

        jQuery.each(query.criteria, function(criterionIndex, criterion) {
            // We only want to use values from parameters defined before this one
            if (criterionIndex < index) {
                var tmpCriteria = jQuery.extend(true, {}, criterion);
                if (criterion.paramType == 'select') {
                    var paramSelector = "#param_" + criterion.paramName.replace(' ', '_');
                    if (criterion.type == 'equals') {
                        tmpCriteria.value = jQuery(paramSelector).val();
                        if (!!tmpCriteria.value) {
                            criteria.push(tmpCriteria);
                        }
                    }
                    else if (criterion.type == 'in') {
                        tmpCriteria.values = jQuery(paramSelector).val();
                        if (!!tmpCriteria.values && tmpCriteria.values.length > 0) {
                            criteria.push(tmpCriteria);
                        }
                    }
                }
                else {
                    criteria.push(tmpCriteria);
                }
            }

        });

        self.getUniqueValues(query.table, tableName, columnName, criteria, function(msg) {
            var selectElement = jQuery(selectSelector);
            var options
            if (selectElement.prop) {
                options = selectElement.prop('options');
            }
            else {
                options = selectElement.attr('options');
            }
            jQuery('option', selectElement).remove();

            options[0] = new Option(defaultOption, defaultOption);
            jQuery.each(msg.results, function(index, value) {
                var option = new Option(value, value);
                options[options.length] = option;
            });
            self.setParamValue(selectSelector, options[0].value);
        });
    },

    setParamValue: function(paramName, paramValue) {
        var paramSelector = "#param_" + paramName.replace(' ', '_');
        jQuery(paramSelector).val(paramValue);
    },

    // ----------------------------------------------------
    // Join methods
    // ----------------------------------------------------
    openJoinPopup: function(queryId) {
        var self = this;
        self.modalQueryId = queryId;
        var query = self.queryMap[queryId];
        var tableName = query.table ? query.table : query.dimension;
        var table = query.table ? self.tableMap[query.table] : self.dimensionMap[query.dimension];

        // set the name of the source table in the popup
        var tableLabel = jQuery('#joinTable').html(i18n(table.display_name));

        // remove existing options from the join table select
        var joinTableSelect = jQuery('#joinTableSelect');
        if (joinTableSelect.prop) {
            var options = joinTableSelect.prop('options');
        }
        else {
            var options = joinTableSelect.attr('options');
        }
        jQuery('option', joinTableSelect).remove();

        // query the related tables
        var request = jQuery.ajax({
            url : (query.table ? self.tablesUrl + '/' : self.dimensionsUrl + '/') + tableName + '/related',
            type : 'GET',
            dataType : "json"
        });
        request.done(function(msg) {
            jQuery.each(msg, function(index, relation) {
                var relationValue = relation.related_table + ' on ' + relation.column + ' = ' + relation.related_column;
                var relatedTranslationKey = relation.display_name + " on %1 = %2";
                var relationName = i18n(relatedTranslationKey, relation.column, relation.related_column);
                options[options.length] = new Option(relationName, relationValue);
            });
        });
        request.fail(function(jqXHR, textStatus) {
            alert(i18n('RequestFailed') + ': ' + textStatus);
        });

        self.displayModal('#joinContainer');
    },

    addJoin: function() {
        var self = this;
        var alias = jQuery('#joinAlias').val();
        var selectedJoin = jQuery('#joinTableSelect').val();
        var columnStart = selectedJoin.indexOf(' on ') + ' on '.length;
        var columnEnd = selectedJoin.indexOf('=') - 1;
        var column = selectedJoin.substr(columnStart, columnEnd - columnStart);
        var selectedJoinTable = selectedJoin.substr(0, selectedJoin.indexOf(' on '));
        var selectedJoinColumn = selectedJoin.substr(selectedJoin.indexOf('=') + 2);
        var parentCoordinates = self.queryCoordinates[self.modalQueryId];
        var table = self.tableMap[selectedJoinTable];
        if (self.joinTable(table, parentCoordinates.x + 1, parentCoordinates.y, alias, column, selectedJoinColumn)) {
            self.closeModals();
        }
    },

    joinTable: function(table, x, y, alias, column, selectedJoinColumn) {
        var self = this;
        if (!alias) {
            alert(i18n("AliasRequiredInJoin"));
            return false;
        }

        var queryId = self.nextQueryId++;
        var query = {
            table : table.name,
            queryId : queryId,
            criteria : []
        };
        self.queryMap[queryId] = query;

        var parentQuery = self.queryMap[self.modalQueryId];
        if (!parentQuery.joins) {
            parentQuery.joins = [];
        }
        var join = {
            alias : alias,
            column : column,
            query : query,
            join_query_column : selectedJoinColumn
        };
        parentQuery.joins.push(join);
        self.drawQuery();
        return true;
    },

    removeJoin: function(joinQueryId) {
        var self = this;
        delete self.queryMap[joinQueryId];
        delete self.queryCoordinates[joinQueryId];
        jQuery.each(self.queryMap, function(queryIndex, query) {
            if (query && query.joins) {
                var joins = query.joins;
                jQuery.each(joins, function(joinIndex, join) {
                    if (join && join.query.queryId == joinQueryId) {
                        joins.splice(joinIndex, 1);
                        return false;
                    }
                });
            }
        });
        self.drawQuery();
    },

    // ----------------------------------------------------
    // Order Config methods
    // ----------------------------------------------------
    openOrderPopup: function(queryId) {
        var self = this;
        self.modalQueryId = queryId;
        var query = self.queryMap[queryId];
        var tableName = query.table ? query.table : query.dimension;
        var table = query.table ? self.tableMap[query.table] : self.dimensionMap[query.dimension];

        jQuery('#order h1').html(i18n(table.display_name));
        jQuery('#orderTable tbody tr').remove();

        if (query.order_by) {
            jQuery.each(query.order_by, function(orderIndex, order_by) {
                var columnName = order_by.column;
                var direction = order_by.direction ? order_by.direction : 'ASC';
                self.addOrdering();
                // set select values
                jQuery('#orderTable tbody select[name="orderingColumn"]').last().val(columnName);
                jQuery('#orderTable tbody select[name="orderingDirection"]').last().val(columnName);
            });
        }
        jQuery('#orderContainer tbody').sortable({
            containment: "parent",
            handle: ".dndHandle",
            items: "> tr",
            tolerance: "pointer"
        });
        self.displayModal('#orderContainer', 400, 200);
    },

    updateOrdering: function() {
        var self = this;
        var query = self.queryMap[self.modalQueryId];
        query.order_by = [];
        jQuery.each(jQuery('#orderTable select[name="orderingColumn"]'), function(index, select) {
            var columnName = jQuery(select).val();
            var direction = jQuery(select).parent().parent().find('select[name="orderingDirection"]').val();
            var ordering = {
                column : columnName,
                direction : direction
            };
            query.order_by.push(ordering);
        });
        self.closeModals();
        jQuery('#query' + self.modalQueryId + ' .table_ordering')
            .html(i18n('OrderingByXColumns', query.order_by.length));
    },

    addOrdering: function() {
        var self = this;
        var query = self.queryMap[self.modalQueryId];
        var tableName = query.table ? query.table : query.dimension;
        var table = query.table ? self.tableMap[query.table] : self.dimensionMap[query.dimension];
        var html = '<tr>' +
            '<td class="dndHandle"><img src="' + self.imagesUrl + '/icon_grabber.gif"/></td>' +
            '<td><select name="orderingColumn"></select></td>' +
            '<td><select name="orderingDirection">' +
            '<option value="ASC">' + i18n('Ascending') + '</option>' +
            '<option value="DESC">' + i18n('Descending') + '</option>' +
            '</select></td>' +
            '<td nowrap="nowrap"><a href="#" onclick="reportBuilder.removeOrdering(this); return false;">' +
            '<img src="' + self.imagesUrl + '/reporting/close.png"/></a></td>' +
            '</tr>';
        jQuery('#orderTable tbody').append(html);

        // add select options
        var orderingColumnSelect = jQuery('#orderTable tbody select[name="orderingColumn"]').last();
        var orderingColumnOptions = orderingColumnSelect.prop('options');
        var columns = query.columns && query.columns.length > 0 ? query.columns : table.columns;
        jQuery.each(columns, function(columnIndex, column) {
            var columnName = column.name;
            if (column['function']) {
                columnName = column['function'] + '(' + columnName + ')';
            }
            // server does not accept aliases right now
//            if (column.alias) {
//                columnName = column.alias;
//            }
            orderingColumnOptions[orderingColumnOptions.length] = new Option(columnName, columnName);
        });
    },

    removeOrdering: function(link) {
        var self = this;
        jQuery(link).parent().parent().remove();
    },

    // ----------------------------------------------------
    // Output Config methods
    // ----------------------------------------------------
    openOutputConfigPopup: function(queryId) {
        var self = this;
        self.modalQueryId = queryId;
        var query = self.queryMap[queryId];
        var tableName = query.table ? query.table : query.dimension;
        var table = query.table ? self.tableMap[query.table] : self.dimensionMap[query.dimension];

        var seriesColumnSelect = jQuery('select[name="chartSeriesColumn"]');
        var dataColumnSelect = jQuery('select[name="chartDataColumn"]');
        var seriesCategoryColumnSelect = jQuery('select[name="chartSeriesCategoryColumn"]');
        if (seriesColumnSelect.prop) {
            var seriesOptions = seriesColumnSelect.prop('options');
            var dataOptions = dataColumnSelect.prop('options');
            var dataCategoryOptions = seriesCategoryColumnSelect.prop('options');
        }
        else {
            var seriesOptions = seriesColumnSelect.attr('options');
            var dataOptions = dataColumnSelect.attr('options');
            var dataCategoryOptions = seriesCategoryColumnSelect.attr('options');
        }
        jQuery('option', seriesColumnSelect).remove();
        jQuery('option', dataColumnSelect).remove();
        jQuery('option', seriesCategoryColumnSelect).remove();
        dataCategoryOptions[dataCategoryOptions.length] = new Option("- " + i18n('None') + " -", "");

        var columns = query.columns && query.columns.length > 0 ? query.columns : table.columns;
        jQuery.each(columns, function(columnIndex, column) {
            var columnName = column.name;
            if (column['function']) {
                columnName = column['function'] + '(' + columnName + ')';
            }
            if (column.alias) {
                columnName = column.alias;
            }
            seriesOptions[seriesOptions.length] = new Option(columnName, columnName);
            dataOptions[dataOptions.length] = new Option(columnName, columnName);
            dataCategoryOptions[dataOptions.length] = new Option(columnName, columnName);
        });

        if (self.outputConfig) {
            jQuery('select[name="outputType"]').val(self.outputConfig.type);
            // all output types have the same inputs
            jQuery('input[name="chartSeriesName"]').val(self.outputConfig.seriesName);
            jQuery('select[name="chartSeriesColumn"]').val(self.outputConfig.seriesColumn);
            jQuery('input[name="chartDataName"]').val(self.outputConfig.dataName);
            jQuery('select[name="chartDataColumn"]').val(self.outputConfig.dataColumn);
            if (self.outputConfig.seriesCategoryColumn) {
                jQuery('select[name="chartSeriesCategoryColumn"]').val(self.outputConfig.seriesCategoryColumn);
            }
        }
        self.displayModal('#outputConfigContainer');
    },

    saveOutputConfig: function() {
        var self = this;
        var outputType = jQuery('select[name="outputType"]').val();
        if (!outputType) {
            alert(i18n("OutputTypeRequired"));
            return;
        }
        // all output types have the same inputs
        var chartSeriesName = jQuery('input[name="chartSeriesName"]').val();
        if (!chartSeriesName) {
            alert(i18n("ChartsSeriesNameRequired"));
            return;
        }
        var chartSeriesColumn = jQuery('select[name="chartSeriesColumn"]').val();
        if (!chartSeriesColumn) {
            alert(i18n("ChartsSeriesColumnRequired"));
            return;
        }
        var chartDataName = jQuery('input[name="chartDataName"]').val();
        if (!chartDataName) {
            alert(i18n("ChartsDataNameRequired"));
            return;
        }
        var chartDataColumn = jQuery('select[name="chartDataColumn"]').val();
        if (!chartDataColumn) {
            alert(i18n("ChartsDataColumnRequired"));
            return;
        }
        var chartSeriesCategoryColumn = jQuery('select[name="chartSeriesCategoryColumn"]').val();
        self.outputConfig = undefined; // delete old settings
        self.outputConfig = {
            type : outputType,
            seriesName : chartSeriesName,
            seriesColumn : chartSeriesColumn,
            dataName : chartDataName,
            dataColumn : chartDataColumn
        };
        if (chartSeriesCategoryColumn) {
            self.outputConfig.seriesCategoryColumn = chartSeriesCategoryColumn
        }
        self.closeModals();
        self.drawOutputConfig();
    },

    removeOutputConfig: function() {
        var self = this;
        delete self.outputConfig;
        self.closeModals();
        self.drawOutputConfig();
    },

    // ----------------------------------------------------
    // Drawing methods
    // ----------------------------------------------------
    displayModal: function(modalSelector, minWidth, minHeight) {
        var self = this;

        // Add the masking div
        var fixedScreenDiv = document.createElement('div');
        var fixedScreen = jQuery(fixedScreenDiv);
        var maskingdivDiv = document.createElement('div');
        var maskingdiv = jQuery(maskingdivDiv);
        fixedScreen.attr('id', 'fixed-screen');
        maskingdiv.attr('id', 'maskingdiv');
        maskingdiv.hide();
        fixedScreen.append(maskingdiv);
        jQuery('body').append(fixedScreen);

        // transition effect
        maskingdiv.fadeIn(200);
        maskingdiv.fadeTo("slow", 0.8);

        // Get the window height and width
        var winH = jQuery(window).height();
        var winW = jQuery(window).width();

        // Set the popup window to center
        var div = jQuery(modalSelector + ' .modal');
        if (minWidth && minWidth > div.width()) {
            div.width(minWidth);
        }
        if (minHeight && minHeight > div.height()) {
            div.height(minHeight);
        }
        if (div.height() > winH - 100) {
            div.height(winH - 100);
        }
        if (div.width() > winW - 100) {
            div.width(winW - 100);
        }
        // subtract 17 because of a border of 2 and padding of 15.
        var top = Math.round((winH - div.height()) / 2 - 17);
        var left = Math.round((winW - div.width()) / 2 - 17);
        div.css('top', top);
        div.css('left', left);

        // transition effect
        div.fadeIn(100);

        jQuery(modalSelector + ' .close').click(function(e) {
            self.closeModals();
        });
    },

    closeModals: function() {
        jQuery('.modal').hide();

        // Remove the masking div
        var fixedScreen = jQuery('#fixed-screen');
        var maskingdiv = jQuery('#maskingdiv');
        maskingdiv.fadeOut(300);
        fixedScreen.remove();
    },

    drawQuery: function() {
        var self = this;
        jQuery('#tableLayout').html('<table class="report_display"></table>');
        self.drawSingleQuery(0, 0, 0, false);
        self.drawParameters(self.queryMap[0]);
        self.drawOutputConfig();
    },

    drawSingleQuery: function(queryId, x, y, displayRemove, joinAlias) {
        var self = this;
        var query = self.queryMap[queryId];
        if (query) {
            var tableName = query.table ? query.table : query.dimension;
            var table = query.table ? self.tableMap[query.table] : self.dimensionMap[query.dimension];
            self.drawTable(queryId, table, x, y, displayRemove, joinAlias);
            if (query.criteria) {
                self.drawFilters(queryId, query.criteria);
            }
            if (query.joins) {
                jQuery.each(query.joins, function(joinIndex, join) {
                    if (join) {
                        x++;
                        var joinedQuery = join.query;
                        var joinedTableName = joinedQuery.table;
                        var joinedTable = self.tableMap[joinedTableName];
                        if (!joinedQuery.queryId) {
                            joinedQuery.queryId = self.nextQueryId++;
                            self.queryMap[joinedQuery.queryId] = joinedQuery;
                        }
                        y = self.drawSingleQuery(joinedQuery.queryId, x, y, true, join.alias);
                        y++;
                    }
                });
            }
        }
        return y;
    },

    drawTable: function(tableQueryId, table, x, y, displayRemove, joinAlias) {
        var self = this;
        var domTable = jQuery('#tableLayout table')[0];
        while (domTable.rows.length < y + 1) {
            domTable.insertRow(-1);
        }
        var domRow = domTable.rows[y];
        while (domRow.cells.length < x + 1) {
            domRow.insertCell(-1);
        }
        var domCell = jQuery(domRow.cells[x]);

        self.queryCoordinates[tableQueryId] = {
            x : x,
            y : y
        };

        var query = self.queryMap[tableQueryId];
        var queryColumnText = query.columns && query.columns.length > 0 ?
            i18n('IncludingXColumns', query.columns.length) : i18n('IncludingAllColumns');
        var queryOrderingText = query.order_by && query.order_by.length > 0 ?
            i18n('OrderingByXColumns', query.order_by.length) : '';

        var queryHtml = '<div id="query' + tableQueryId + '" class="table"><div style="clear: both;"></div>';
        queryHtml += '<img src="' + self.imagesUrl + '/reporting/table.png" class="table_icon" />' +
            '<h1 class="table_title floating_left" title="' + table.description + '">' + i18n(table.display_name) + '</h1>';
        if (displayRemove) {
            queryHtml += '<a href="#" onclick="reportBuilder.removeJoin(\'' + tableQueryId + '\'); return false;">'
                    + '<img src="' + self.imagesUrl + '/reporting/close.png" class="joinRemove"/></a>';
        }
        if (joinAlias) {
            queryHtml += '<div style="clear: both;"></div>';
            queryHtml += '<img src="' + self.imagesUrl + '/reporting/join.png" class="table_icon" style="margin-top: 5px;"/>'
                    + '<h2 class="table_title floating_left">' + i18n("JoinedAs", joinAlias) + '</h2>';
        }
        queryHtml += '<div style="clear: both;"></div>' +
            '<div class="table_columns">' + queryColumnText + '</div>' +
            //'<div style="clear: both;"></div>' +
            '<div class="table_columns_link"><a href="#showColumns" name="modal" class="normal_link" ' +
            'onclick="reportBuilder.openColumnsPopup(\'' + tableQueryId + '\'); return false;">' + i18n('Columns') +
            '</a></div><div class="table_filters"></div>' +
            '<div class="table_ordering">' + queryOrderingText + '</div>';
        if (tableQueryId == 0) {
            queryHtml += '<div class="table_output_config"></div><br/>';
        }
        queryHtml += '<a href="#filter" class="button" onclick="reportBuilder.openFilterPopup(\'' + tableQueryId +
            '\'); return false;">' + i18n('Filter') + '</a> ';
        if (table.type == 'table') {
            queryHtml += '<a href="#join" class="button" onclick="reportBuilder.openJoinPopup(\'' + tableQueryId
                    + '\'); return false;">' + i18n('Join') + '</a>';
        }
        if (tableQueryId == 0) {
            // draw order and output configuration buttons
            queryHtml += '<a href="#order" class="button" onclick="reportBuilder.openOrderPopup(\'' +
                tableQueryId + '\'); return false;">' + i18n('Order') + '</a>';
            queryHtml += '<a href="#output" class="button" onclick="reportBuilder.openOutputConfigPopup(\'' +
                tableQueryId + '\'); return false;">' + i18n('Output') + '</a>';
        }
        queryHtml += '</div>';
        domCell.append(queryHtml);
    },

    drawQueryResults: function(queryResults) {
        var self = this;
        var domQueryResults = jQuery('#queryResults');
        if (queryResults.results.length == 0) {
            domQueryResults.html('<h2>' + i18n('NoResultsFound') + '</h2>');
        }
        else {
            domQueryResults.html('<table class="data-table"></table>');
            var domTable = jQuery('#queryResults table');
            var row = '<tr>';
            jQuery.each(queryResults.columns, function(columnIndex, columnName) {
                row += '<th>' + columnName + '</th>';
            });
            row += '</tr>';
            domTable.append(row);
            jQuery.each(queryResults.results, function(resultIndex, result) {
                row = '<tr>';
                jQuery.each(result, function(columnIndex, value) {
                    if (!value) {
                        value = '';
                    }
                    row += '<td>' + value.escapeHTML() + '</td>';
                });
                row += '</tr>';
                domTable.append(row);
            });
        }
    },

    // ----------------------------------------------------
    // Miscellaneous methods
    // ----------------------------------------------------
    getReport: function() {
        var self = this;
        var query;
        if (self.viewingManualQuery === true) {
            var reportString = jQuery('#manualQueryTextArea').val();
            var report = jQuery.parseJSON(reportString);
            jQuery('input[name=reportName]').val(report.name);
            jQuery('textarea[name=reportDesc]').val(report.description);
            query = report.query;
        }
        else {
            var queryString = JSON.stringify(self.queryMap[0], undefined, 2);
            query = jQuery.parseJSON(queryString);
        }

        var newReportName = jQuery('input[name=reportName]').val();
        var newReportDesc = jQuery('textarea[name=reportDesc]').val();
        var report = {
            name : newReportName,
            query : query
        };
        if (self.reportId) {
            report.id = self.reportId;
        }
        else {
            var newReportTeam = jQuery('select[name=teamSpaceId]').val();
            if (newReportTeam) {
                report.teamIds = newReportTeam;
            }
        }

        if (newReportDesc) {
            report.description = newReportDesc;
        }
        if (self.outputConfig) {
            report.output = self.outputConfig;
        }

        var reportDesc = report.description ? report.description : "";
        jQuery('#translatedName').text(i18n(report.name));
        if (reportDesc) {
            jQuery('#translatedDesc').text(i18n(reportDesc));
        }

        return report;
    },

    saveReport: function() {
        var self = this;

        var report = self.getReport();
        var newReportName = report.name;
        var reportJSONString = JSON.stringify(report, undefined, 2);

        if (self.reportId) {
            // update report
            var request = jQuery.ajax({
                url : self.reportsUrl + '/' + encodeURIComponent(self.reportName),
                type : 'PUT',
                accepts : {
                    text : 'application/json'
                },
                contentType : 'application/json',
                data : reportJSONString,
                dataType : "json"
            });
            request.done(function(msg) {
                self.reportName = newReportName;
                var resultHtml = '<span class="message">' + jQuery('<div/>').text(newReportName).html(); + ' ' + i18n("Updated") +'</span>';
                jQuery('#saveResultDiv').html(resultHtml).show().delay(2000).fadeOut(2000);
            });
            request.fail(function(jqXHR) {
                alert(i18n("ReportFailedToSave") + " " + jqXHR.responseText);
            });
        }
        else {
            // create report
            if (!jQuery("#teamSpaceId").val()) {
                alert(i18n("ReportTeamRequired"));
            }
            else if (!report.query) {
                alert(i18n("ReportTableRequired"));
            }
            else {

                var request = jQuery.ajax({
                    url : self.reportsUrl,
                    type : 'POST',
                    accepts : {
                        text : 'application/json'
                    },
                    contentType : 'application/json',
                    data : reportJSONString,
                    dataType : "json"
                });
                request.done(function(createdReport) {
                    self.reportId = createdReport.id;
                    self.reportName = createdReport.name;
                    jQuery('.reportCreateOnlyRow').remove();
                    var resultHtml = '<span class="message">' + i18n("CreatedObject", createdReport.name) + '</span>';
                    jQuery('#saveResultDiv').html(resultHtml).show().delay(2000).fadeOut(2000);
                });
                request.fail(function(jqXHR) {
                    alert(i18n("ReportFailedToSave") + " " + jqXHR.responseText);
                });
            }
        }
    },

    runReport: function() {
        var self = this;
        var query;
        if (self.viewingManualQuery === true) {
            var reportString = jQuery('#manualQueryTextArea').val();
            var report = jQuery.parseJSON(reportString);
            query = report.query;
        }
        else {
            var queryString = JSON.stringify(self.queryMap[0], undefined, 2);
            query = jQuery.parseJSON(queryString);
        }
        if (query) {
            if (!query.criteria) {
                query.criteria = [];
            }
            if (!query.table && !query.dimension) {
                alert(i18n("ReportSelectTable"));
                return;
            }
            var paramsComplete = true;
            jQuery.each(query.criteria, function(criteriaIndex, criteria) {
                var paramName = criteria.paramName;
                if (paramName) {
                    var paramSelector = "#param_" + paramName.replace(' ', '_');
                    var paramValue = jQuery(paramSelector).val();
                    if (!paramValue) {
                        alert(i18n("ParameterGivenRequired", paramName));
                        paramsComplete = false;
                        return;
                    }
                    if (criteria.type == 'in') {
                        if (criteria.paramType == 'enter') {
                            paramValue = paramValue.replace('\r', '').split('\n');
                        }
                        criteria.values = paramValue;
                    }
                    else {
                        criteria.value = paramValue;
                    }
                }
            });
            if (!paramsComplete) {
                return;
            }
            queryString = JSON.stringify(query, undefined, 2);
            lastQueryRun = queryString;
            self.reportRunning = true;
            jQuery('#downloadButtons').hide();
            jQuery('#queryResults').html('<div style="text-align: center;"><img src="' + self.imagesUrl + '/loading.gif"/></div>');
            self.displayModal('#reportResultsContainer', 2000, 2000);
            var request = jQuery.ajax({
                url : self.queryUrl,
                type : 'POST',
                accepts : {
                    text : 'application/json'
                },
                contentType : 'application/json',
                data : queryString,
                dataType : "json"
            });

            request.done(function(msg) {
                self.reportRunning = false;
                jQuery('#viewQueryButton').show();
                jQuery('#downloadButtons').show();
                jQuery('#csvQuery').val(queryString);
                if (self.outputConfig) {
                    var chartType = self.outputConfig.type;
                    chartType = chartType.substring(0, chartType.indexOf('_')).toLowerCase();
                    var reportGraph = new ReportGraph('queryResults', self.reportName, chartType,
                        self.outputConfig.seriesName, self.outputConfig.seriesColumn,
                        self.outputConfig.seriesCategoryColumn, self.outputConfig.dataName,
                        self.outputConfig.dataColumn);
                    reportGraph.renderGraph(msg);
                }
                else {
                    self.drawQueryResults(msg);
                }
                self.currentResults = msg;
            });

            request.fail(function(jqXHR, textStatus) {
                self.closeModals();
                self.reportRunning = false;
                alert(i18n("RequestFailed") + " " + textStatus);
            });
        }
    },

    toggleManualQuery: function() {
        var self = this;
        if (self.viewingManualQuery) {
            var reportString = jQuery('#manualQueryTextArea').val();
            try {
                var report = jQuery.parseJSON(reportString);
                var query = report.query;
                var output = report.output;
                if (!query.criteria) {
                    query.criteria = [];
                }
                self.queryMap[0] = query;
                self.outputConfig = output;
            }
            catch (exception) {
                alert(i18n("ReportingQueryInvalidJSON"));
                return;
            }
            self.drawQuery();

            jQuery('.manualQueryContainer').hide();
            jQuery('.report-container').show();
            jQuery('#manualQueryButton').val('Text');
            jQuery('#saveButton').show();
            self.viewingManualQuery = false;
        }
        else {
            var report = self.getReport();
            var newReportName = report.name;
            var reportJSONString = JSON.stringify(report, undefined, 2);
            jQuery('#manualQueryTextArea').val(reportJSONString);

            jQuery('.report-container').hide();
            jQuery('.manualQueryContainer').show();
            jQuery('#manualQueryButton').val(i18n('Graphical'));
            jQuery('#saveButton').hide();
            self.viewingManualQuery = true;
        }
    },

    newReport: function() {
        var self = this;
        jQuery('.manualQueryContainer').hide();
        jQuery('.report-container').show();
        var newReportHtml = '<table class="report_display"><tr><td><div class="table">' +
            '<h1 class="table_title">' + i18n('Tables') + '</h1>' +
            '<p>' + i18n('ReportingSelectTable') + '</p>' +
            '<p><select id="tableSelect" name="table"><option>-- ' + i18n('SelectTable') + ' --</option></select></p><br/><br/>' +
            '<p><input id="tableSelectButton" type="submit" name="Select" value="' + i18n('Select') + '" class="button"/></p>' +
            '</div></td></tr></table>';
        jQuery('#tableLayout').html(newReportHtml);

        jQuery('#tableSelectButton').click(function(e) {
            e.preventDefault();
            var selectedTable = jQuery('#tableSelect').val();
            if (selectedTable) {
                if (selectedTable.indexOf('table.') == 0) {
                    var table = self.tableMap[selectedTable.substr('table.'.length)];
                    var query = {
                        table : table.name,
                        queryId : 0,
                        criteria : []
                    };
                    self.queryMap[0] = query;
                    self.drawQuery();
                }
                else if (selectedTable.indexOf('dimension.') == 0) {
                    var dimension = self.dimensionMap[selectedTable.substr('dimension.'.length)];
                    var query = {
                        dimension : dimension.name,
                        queryId : 0,
                        criteria : []
                    };
                    self.queryMap[0] = query;
                    self.drawQuery();
                }
            }
        });

        var getTablesAndDimensionsAjaxRequest = jQuery.ajax({
            url : self.tablesAndDimensionsUrl,
            type : 'GET',
            accepts : {
                text : 'application/json'
            },
            contentType : 'application/json',
            dataType : "json"
        });

        getTablesAndDimensionsAjaxRequest.done(function(tables) {
            var tableSelect = jQuery('#tableSelect');
            if (tableSelect.prop) {
                var options = tableSelect.prop('options');
            }
            else {
                var options = tableSelect.attr('options');
            }
            jQuery.each(tables, function(index, table) {
                var option = new Option(i18n(table.display_name), table.type + "." + table.name);
                option.title = i18n(table.description);
                options[options.length] = option;
            });
        });
        getTablesAndDimensionsAjaxRequest.fail(function(jqXHR, textStatus) {
            alert(i18n("ReportingFailedGettingTablesFor") + " " + textStatus);
        });

    },

    getUniqueValues: function(isTable, tableName, columnName, criteria, callback) {
        var self = this;
        var query = {
            'criteria' : criteria,
            'columns' : [ {
                    'name' : columnName,
                    'function' : 'DISTINCT'
                }
            ],
            'order_by' : [ {
                    'column' : columnName,
                    'direction' : 'ASC'
                }
            ]
        };
        if (isTable) {
            query.table = tableName;
        }
        else {
            query.dimension = tableName;
        }
        var queryString = JSON.stringify(query, undefined, 2);
        var request = jQuery.ajax({
            url : self.queryUrl,
            type : 'POST',
            accepts : {
                text : 'application/json'
            },
            contentType : 'application/json',
            data : queryString,
            dataType : "json"
        });

        request.done(function(msg) {
            callback(msg);
        });

        request.fail(function(jqXHR, textStatus) {
            alert(i18n("RequestFailed") + " " + textStatus);
        });
    },

    showParameterPopup: function(query) {
        var self = this;
        self.drawParameters(query);
        self.displayModal('#paramModal', 400, 100);
    },

    isParameterized: function(query) {
        var hasParams = false;
        if (query.criteria) {
            jQuery.each(query.criteria, function(criteriaIndex, criteria) {
                var criteriaType = criteria.type;
                if (criteria.paramName) {
                    hasParams = true;
                    return;
                }
            });
        }
        return hasParams;
    },

    showImportReportPopup: function() {
        var self = this;
        self.displayModal('#reportImportContainer', 600, 500);
    },

    importReport: function(fileInput) {
        var self = this;
        var report;

        try {
            if (fileInput) {
                report = JSON.parse(fileInput);
            }
            else if (jQuery("#importArea").val()) {
                report = JSON.parse(jQuery("#importArea").val());
            }
            else {
                var resultHtml = '<span class="error">' + i18n("ReportEnterReportAsJSON") + '</span>';
                jQuery('#importErrorDiv').html(resultHtml).show().delay(2000).fadeOut(2000);
                return false;
            }
        }
        catch (e) {
            var resultHtml = '<span class="error">' + i18n("ImportReportError") + '</span>';
            jQuery('#importErrorDiv').html(resultHtml).show().delay(2000).fadeOut(2000);
            return false;
        }

        // create report
        self.getAllSavedReports(function(reports) {
            var checkNames = [];
            jQuery.each(reports, function(index, report) {
                checkNames.push(report.name);
            });

            var exists = jQuery.inArray(report.name, checkNames);
            if (exists > -1) {
                // report already exists with name
                var resultHtml = '<span class="error">' + i18n("ImportReportNameError") + '</span>';
                jQuery('#importErrorDiv').html(resultHtml).show().delay(2000).fadeOut(2000);
                return false;
            }
            else {
                if (!jQuery("#teamSpaceId").val()) {
                    var resultHtml = '<span class="error">' + i18n("ReportTeamRequired") + '</span>';
                    jQuery('#importErrorDiv').html(resultHtml).show().delay(2000).fadeOut(2000);
                }
                else {
                    var teamIds = jQuery("#teamSpaceId").val();
                    if (!jQuery.isArray(teamIds)) {
                        teamIds = jQuery.makeArray(teamIds);
                    }
                    report.teamIds = teamIds;
                    var reportJSONString = JSON.stringify(report, undefined, 2);

                    var request = jQuery.ajax({
                        url : self.reportsUrl,
                        type : 'POST',
                        accepts : {
                            text : 'application/json'
                        },
                        contentType : 'application/json',
                        data : reportJSONString,
                        dataType : "json"
                    });
                    request.done(function(createdReport) {
                        self.closeModals();
                        location.reload();
                    });
                    request.fail(function(jqXHR, textStatus) {
                        var resultHtml = '<span class="error">' + i18n("ImportReportError") + '</span>';
                        jQuery('#saveResultDiv').html(resultHtml).show().delay(2000).fadeOut(2000);
                    });
                }
            }
        });
    }
});
