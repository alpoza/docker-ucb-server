/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/**
 * This Object contains public methods for creating a standard Anthill Data
 * Table which can be used for selecting a number of rows and performing an
 * action on the ids from that row.
 * 
 * @param configs
 *                A configuration object which contains. selCountDiv The id of a
 *                div in which to generate count of rows that have been
 *                selected. filter fieldId The id of the Filter Input
 *                autoCompleteId The id of the div to render the autocomplete
 *                in.
 */
var AnthillDataTable = function(element, columnDefs, dataSource, configs) {
    var _this = this;
    var ignoreNextPageChange = false;

    /**
     * Clear the selCountDiv
     */
    var clearSelectedCountDiv = function() {
        var div = YAHOO.util.Dom.get(configs.selCountDiv);
        if (div) {
            div.innerHTML = ""
        }
    }

    /**
     * Generate the HTML to insert into the selCountDiv
     */
    var updateSelectedCountDiv = function() {
        var text = null;
        if (this.selectedRows.length > 0) {
            text = "<b>&nbsp;x&nbsp;</b>" + this.selectedRows.length;
        } else {
            text = "";
        }
        var div = YAHOO.util.Dom.get(configs.selCountDiv);
        if (div) {
            div.innerHTML = text;
        }
    }

    /**
     * This method can be used to select/unselect a given id.
     * 
     * @param id
     *                The id to select/unselect
     * @param checked
     *                Whether the id should be selected or unselected
     * @param selectedRows
     *                The list of Selected Rows which we will be adding to or
     *                removing from.
     */
    var updateSelectedRows = function(id, checked, selectedRows) {
        var index = selectedRows.indexOf(id);
        if (checked) {
            if (index <= -1) {
            selectedRows.push(id);
            }
        }
        else {
            if (index > -1) {
            selectedRows.splice(index, 1);
            }
        }
    }

    /**
     * This method gets called whenever a row is selected. This method
     * determines which row was selected and updates the in memory list. It will
     * also update the Selected Row Count Div if applicable.
     */
    var updateDataRecord = function(oArgs) {
        var dataTable = this;
        var elCheckbox = oArgs.target;
        var record = dataTable.getRecord(elCheckbox);

        YAHOO.log("updating record");
        var id = parseInt(record.getData('id'));

        YAHOO.log("id:" + id);
        updateSelectedRows(id, elCheckbox.checked, dataTable.selectedRows);

        if (dataTable.updateSelectedCountDiv) {
            dataTable.updateSelectedCountDiv();
        }

        YAHOO.log("selectedAgents:" + dataTable.selectedRows.join(','));
    }

    /**
     * This method toggles the selection of all rows that are visible on the
     * current page.
     * 
     * @param checked
     *                Whether we are selectring or unselecting all of the
     *                currently displayed rows.
     */
    var toggleSelectAll = function(checked) {
        YAHOO.log("In The Toggle Select Add Method!");
        var table = this;
        var paginator = table.get("paginator");
        var startIndex = paginator.getStartIndex();
        var totalRecords = paginator.getTotalRecords();
        var rowsPerPage = paginator.getRowsPerPage();
        YAHOO.log("startIndex:" + startIndex);
        YAHOO.log("totalRecords:" + totalRecords);
        YAHOO.log("rowsPerPage:" + rowsPerPage);
        var records = table.getRecordSet().getRecords();
        YAHOO.log("row lengths:" + records.length);
        for (i = startIndex; i < startIndex + rowsPerPage && i < totalRecords; i++) {
                var record = records[i];
                var id = parseInt(record.getData('id'));
                YAHOO.log("id:" + id);
                updateSelectedRows(id, checked, table.selectedRows);
        }

        table.render();

        if (checked === false) {
            if (table.clearSelectedCountDiv) {
                table.clearSelectedCountDiv();
            }
        }
        else {
            if (table.updateSelectedCountDiv) {
                table.updateSelectedCountDiv();
            }
        }
    }

    /**
     * This is a callback function used by the AutoComplete Filter for
     * retrieving refined results from the server.
     * 
     * @param query
     *                The query String to send to the server.
     */
    var updateTable = function(query) {
        dataTable.selectedRows = new Array();
        dataTable.updateSelectedCountDiv();
        var generateQuery = dataTable.get('generateRequest');

        // reset table state before request
        dataTable.set("sortedBy", null);
        var paginator = dataTable.get('paginator');
        paginator.setStartIndex(0);
        paginator.setPage(1, true);
        var state = dataTable.getState();
        var request = generateQuery(state, dataTable, true);

        var callback = {
            success : dataTable.onDataReturnSetRows,
            failure : dataTable.onDataReturnSetRows,
            scope : dataTable,
            argument : dataTable.getState()
        };

        dataSource.sendRequest(request, callback);
    }

    /**
     * This method posts to the specified url an array of "ids" which are
     * currenty selected. Upon successful return we call the passed in successFn
     * passing it the result we received from the Url.
     * 
     * @param url
     *                The url to POST to.
     * @param successFn
     *                The Function to call on successful return from the Server.
     */
    var performAction = function(url, successFn) {
        var dataTable = this;
        if (dataTable.selectedRows.length > 0) {

            var postData = 'ids=' + dataTable.selectedRows.join('&ids=');

            var handleSuccess = function(o) {
                if (o.responseText !== undefined) {
                    var result = YAHOO.lang.JSON.parse(o.responseText);

                    successFn(result);

                    if (dataTable.afterSuccessfulPerform) {
                        dataTable.afterSuccessfulPerform();
                    }

                    if (dataTable.sendUpdateRequest) {
                        dataTable.sendUpdateRequest();
                    }
                }
            }

            var handleFailure = function(o) {
                alert(i18n("CommunicationWithServerError"));
            }

            var callback = {
                success : handleSuccess,
                failure : handleFailure
            };

            var request = YAHOO.util.Connect.asyncRequest('POST', url, callback, postData);

            dataTable.selectedRows = new Array();

            if (dataTable.resetSelections) {
                dataTable.resetSelections();
            }

            if (dataTable.clearSelectedCountDiv) {
                dataTable.clearSelectedCountDiv();
            }
        }
        else {
            alert(i18n("RowsNoneSelected"));
        }
    }

    /**
     * This method checks to see if we have any filters applied to this table.
     * If we do then it will generate the default query String and append a
     * filter parameter to it.
     */
    var generateFilter = function(oState, oSelf, clear) {
        if (configs.filter) {
            var filterStr = null;
            var filterInput = YAHOO.util.Dom.get(configs.filter.fieldId);
            if (filterInput) {
                filterStr = filterInput.value;
            }

            return defaultGenerateFilter(oState, oSelf, clear) + ((filterStr !== null) ? "&filter=" + encodeURIComponent(filterStr) : "");
        }
        else {
            return defaultGenerateFilter(oState, oSelf, clear)
        }
    }

    /**
     * This method will send a request to the Tables DataSource to update the
     * table with new data reflecting the table state and any applied filters.
     */
    var sendUpdateRequest = function() {
        var dataSource = this.getDataSource();
        var generateQuery = this.get('generateRequest');
        var callback = {
            success : this.onDataReturnSetRows,
            failure : this.onDataReturnSetRows,
            scope : this,
            argument : this.getState()
        };
        dataSource.sendRequest(generateQuery(this.getState(), this), callback);
    };

    var renderSelections = function(selections) {
        YAHOO.log("selections:" + selections);
        this.selectedRows = selections;

        // we need to ignore the next pageChange event or else our selections
        // will get reset.
        ignoreNextPageChange = true;

        this.render();
    };

    if (configs.filter) {
        var oACDS = new YAHOO.util.FunctionDataSource(updateTable);
        oACDS.queryMatchContains = true;
        var autoCompelete = new YAHOO.widget.AutoComplete(
            configs.filter.fieldId, configs.filter.autoCompleteId, oACDS);
        autoCompelete.minQueryLength = 0;
        autoCompelete.queryDelay = .5;
    }

    var dataTable = new YAHOO.widget.DataTable(element, columnDefs, dataSource, configs);
    YAHOO.util.Dom.addClass(dataTable.getTableEl(), 'data-table');
    dataTable.selectedRows = new Array();

    dataTable.subscribe("checkboxClickEvent", updateDataRecord);
    dataTable.toggleSelectAll = toggleSelectAll;

    dataTable.handleDataReturnPayload = _this.dataReturnPayloadHandler;

    var resetSelections = function() {
        if (!ignoreNextPageChange) {
            YAHOO.util.Dom.get('selectAll').checked = false;
            dataTable.selectedRows = new Array();
            dataTable.clearSelectedCountDiv();
        }
        ignoreNextPageChange = false;
    }
    configs.paginator.subscribe("pageChange", resetSelections);

    dataTable.resetSelections = resetSelections;
    dataTable.renderSelections = renderSelections;

    dataTable.updateSelectedCountDiv = updateSelectedCountDiv;

    dataTable.clearSelectedCountDiv = clearSelectedCountDiv;

    var defaultGenerateFilter = dataTable.get('generateRequest');

    dataTable.set('generateRequest', generateFilter);
    dataTable.generateFilter = generateFilter;

    dataTable.sendUpdateRequest = sendUpdateRequest;

    dataTable.performAction = performAction;
    dataTable.updateTable = updateTable;

    return {
        dataTable : dataTable
    };
}

AnthillDataTable.prototype = new AgentDataTableHolder();