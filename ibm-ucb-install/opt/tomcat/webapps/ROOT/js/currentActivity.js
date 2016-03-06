/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var viewWorkflowUrl = 'undefined';
var abortWorkflowUrl = 'undefined';
var suspendWorkflowUrl = 'undefined';
var resumeWorkflowUrl = 'undefined';
var prioritizeWorkflowUrl = 'undefined';
var viewJobUrl = 'undefined';
var savedFilterUrl = 'undefined';

var iconViewUrl = 'undefined';
var iconPlusUrl = 'undefined';
var iconMinusUrl = 'undefined';
var iconWorkflowUrl = 'undefined';
var iconJobUrl = 'undefined';
var iconAbortUrl = 'undefined';
var iconSuspendUrl = 'undefined';
var iconResumeUrl = 'undefined';
var iconPrioritizeUrl = 'undefined';
var iconWorkflowRemove = 'undefined';
var iconExpandAllUrl = 'undefined';
var setPropertyUrl = 'undefined';
var saveFilterUrl = 'undefined';
var deleteFilterUrl = 'undefined';

function createCurrentActivity(groupBy) {

    var dom = YAHOO.util.Dom,
        event = YAHOO.util.Event;

    var _this = this;

    // This is the set of workflow id's which have an expand/collapse setting different from the expand/collapse-all setting
    // We track this so that when a user changes the expand/collapse-all state, we will clear all the individual overrides.
    this.currentActivityWorkflowOverrideIds = [];
    this.workflowExpansionCache = {};
    this.groups = [];
    this.groupCollapsedCache = {};
    this.resetGroups = true;
    this.currentGroupName = null;
    this.currentGroupBy = groupBy;
    this.dataTable = null;
    this.dataSource = null;
    this.dataSourceUrl = null;

    this.clientSession = null;
    this.nonDefaultWorkflowIds = new Hash(); // used to track which properties to clear when expand/collapse-all action is invoked

    this.allRowExpandedKey = 'currentActivityAllRowsExpanded';
    this.singleRowExpandedKeyPrefix = 'currentActivitySingleWorkflow:';
    this.allRowsExpanded = false;
    this.isExpandAll = true;

    /**
    * Initializes the groups for the current data set.
    * @method initGroups
    * @private
    */
    this.initGroups = function() {
        if (_this.currentGroupBy) {
            this.currentGroupName = null;
            if (!this.resetGroups) {
                // Insert each group in the array
                var i;
                for (i = 0; i < this.groups.length; i++) {
                    this.groups[i].group = this.insertGroup(this.groups[i].name, this.groups[i].row);
                }

                this.resetGroups = true;
            }
        }
    };

    /**
    * Updates the width of all groups to match the data table.
    * @method resizeGroups
    * @private
    */
    this.resizeGroups = function() {
        // Insert each group in the array
        var i;
        for (i = 0; i < this.groups.length; i++) {
            this.setGroupWidth(this.groups[i].group, this.groups[i].row);
        }
    };

    /**
    * Sets the width of a group to the parent row width.
    * @method resizeGroups
    * @param group {Object} To group to set width to.
    * @param row {Object} To row to get width from.
    * @private
    */
    this.setGroupWidth = function(group, row) {
        group.style.width = (dom.getRegion(row).width - 1) + "px";
    };

    /**
    * Inserts a group before the specified row.
    * @method insertGroup
    * @param name {String} The name of the group.
    * @param beforeRow {Object} To row to insert the group.
    * @private
    */
    this.insertGroup = function(name, row) {
        var group = new Element('div');
        var collapsed = _this.groupCollapsedCache[name];
        var firstTd = $(row).down('td');
        var secondTd = firstTd.next();

        // Row is expanded by default
        if (collapsed) {
            group.className = "group group-collapsed";
        }
        else {
            group.className = "group group-expanded";
        }

        if (dom.hasClass(row, "yui-dt-first")) {
            // If this is the first row in the table, transfer the class to the group
            dom.removeClass(row, "yui-dt-first");
            dom.addClass(group, "group-first");
        }

        // Add a liner as per standard YUI cells
        var liner = new Element('div');
        liner.className = "liner";

        // Add icon
        var icon = new Element('div', {
            style : "margin-left: " + ((firstTd.getWidth() - 28) / 2) + "px;"
        });
        icon.addClassName("icon");
        icon.observe('click', function(e) { _this.toggleGroupVisibility(e); });
        liner.insert(icon);

        // Add checkbox
        var checkboxDiv = new Element('div', {
            style : "margin-left: " + (firstTd.getWidth() - 5) + "px; " +  // substract padding and border
                    "width: " + (secondTd.getWidth() - 2) + "px;" // substract 2 borders
        });
        checkboxDiv.addClassName('grpCheckboxDiv');
        var inputElement = new Element('input', { type: 'checkbox', name: 'groupCheckbox', value: name, title: i18n('GroupSelectUnselect') });
        inputElement.addClassName('checkbox');
        inputElement.observe('click', function(e) { _this.selectGroupRowsForAction(e); });
        checkboxDiv.insert(inputElement);
        liner.insert(checkboxDiv);

        // Add label
        var label = new Element("div", {
            style : "margin-left: " + (firstTd.getWidth() + secondTd.getWidth()) + "px;"
        });
        label.innerHTML = String(name).escapeHTML();
        label.className = "label";
        liner.insert(label);
        group.insert(liner);

        // Set the width of the group
        this.setGroupWidth(group, row);

        // Insert the group
        var cell = row.cells[0];
        var childNode = $(cell.childNodes[0]);
        childNode.insert({ before: group });

        return group;
    };

    /**
    * Toggles the visibility of the group specified in the event.
    * @method toggleGroupVisibility
    * @param e {Event} The event fired from clicking the group.
    * @private
    */
    this.toggleGroupVisibility = function(e) {
        var group = dom.getAncestorByClassName(event.getTarget(e), "group");
        var row = $(dom.getAncestorByTagName(group, "tr"));
        var visibleState;
        var record = _this.dataTable.getRecord(row);

        // Change the class of the group
        if (dom.hasClass(group, "group-expanded")) {
            visibleState = false;
            dom.replaceClass(group, "group-expanded", "group-collapsed");
        }
        else {
            visibleState = true;
            dom.replaceClass(group, "group-collapsed", "group-expanded");
        }

        // Change the class of the first row
        if (!visibleState) {
            dom.replaceClass(row, "group-first-row", "group-first-row-collapsed");
            _this.groupCollapsedCache[record.getData(groupBy)] = true;
        }
        else {
            dom.replaceClass(row, "group-first-row-collapsed", "group-first-row");
            _this.groupCollapsedCache[record.getData(groupBy)] = false;
        }

        // Hide all subsequent rows in the group
        row = dom.getNextSibling(row);

        while (row && !dom.hasClass(row, "group-first-row") &&
            !dom.hasClass(row, "group-first-row-collapsed")) {
            if (visibleState) {
                if (dom.hasClass(row, "current-activity-job")) {
                    // check the expanded cache
                    record = _this.dataTable.getRecord(row);
                    if (_this.workflowExpansionCache[record.getData("id")]) {
                        row.show();
                    }
                }
                else {
                    row.show();
                }
            }
            else {
                row.hide();
            }

            row = dom.getNextSibling(row);
        }
    };

    /**
    * A YUI DataTable custom row formatter. The row formatter must be applied to the DataTable
    * via the formatRow configuration property.
    */
    this.rowFormatter = function(tr, record) {
        if (_this.currentGroupBy) {
            if (_this.resetGroups) {
                _this.groups = [];
                _this.currentGroupName = null;
                _this.resetGroups = false;
            }

            var groupName = record.getData(groupBy);
            var collapsed = _this.groupCollapsedCache[groupName];

            if (groupName != _this.currentGroupName) {
                _this.groups.push({ name: groupName, row: tr, group: null });
                dom.addClass(tr, "group-first-row");

                if (collapsed) {
                    dom.replaceClass(tr, "group-first-row", "group-first-row-collapsed");
                }
                else {
                    dom.replaceClass(tr, "group-first-row-collapsed", "group-first-row");
                }
            }
            else {
                if (collapsed) {
                    dom.addClass(tr, "group-row-collapsed");
                }
                else {
                    dom.removeClass(tr, "group-row-collapsed");
                }
            }

            _this.currentGroupName = groupName;
        }

        return true;
    };

    this.isJobRecord = function(record) {
        return record.getData("jobTraceId");
    };

    this.validateActions = function() {
        var numberSelected = 0;
        var abortAllowed = true;
        var suspendAllowed = true;
        var resumeAllowed = true;
        var prioritizeAllowed = true;
        $$('input:checked[name="workflowCaseId"]').each(function(checkbox) {

            // mark that at least one checkbox is checked
            numberSelected++;

            var row = checkbox.up('tr');
            var record = _this.dataTable.getRecord(row);

            var status = record.getData('status');
            if (abortAllowed &&
                (!record.getData('canAbort') ||
                 (status != 'Running' && status != 'Waiting on Agents' && status != 'Queued')
                )
               ) {
                abortAllowed = false;
            }
            if (suspendAllowed &&
                (!record.getData('canSuspendResume') || status != 'Running')) {
                suspendAllowed = false;
            }
            if (resumeAllowed &&
                (!record.getData('canSuspendResume') || status != 'Suspended')) {
                resumeAllowed = false;
            }
            if (prioritizeAllowed &&
                (!record.getData('canPrioritize') || record.getData('priority') == 'High' ||
                 (status != 'Running' && status != 'Waiting on Agents' && status != 'Queued')
                )
               ) {
                prioritizeAllowed = false;
            }
        });

        $('abortLink').hide();
        if (numberSelected > 0 && abortAllowed) {
            // enable abort
            $('abortLink').show();
        }

        if (numberSelected > 0 && suspendAllowed) {
            // enable suspend
            $('suspendLink').show();
        }
        else {
            // disable suspend
            $('suspendLink').hide();
        }

        if (numberSelected > 0 && resumeAllowed) {
            // enable resume
            $('resumeLink').show();
        }
        else {
            // disable resume
            $('resumeLink').hide();
        }

        if (numberSelected > 0 && prioritizeAllowed) {
            // enable prioritize
            $('prioritizeLink').show();
        }
        else {
            // disable prioritize
            $('prioritizeLink').hide();
        }

        if (numberSelected == 1) {
            $('selectedWorkflowsMessage').update(i18n("ProcessSelected", numberSelected));
        }
        else {
            $('selectedWorkflowsMessage').update(i18n("ProcessesSelected", numberSelected));
        }
    };

    this.checkWorkflow = function(record) {
        var checked = record.getData('checked');
        record.setData('checked', !checked);
        _this.validateActions();
    };

    this.getSelectedWorkflowIds = function() {
        var selectedWorkflowIds = [];
        $$('input:checked[name="workflowCaseId"]').each(function(checkbox) {
            selectedWorkflowIds.push(checkbox.value);
        });
        return selectedWorkflowIds;
    };

    var noWrapFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        if (typeof oData === 'undefined' || oData === null) {
            oData = "";
        }
        elLiner.innerHTML = String(oData).escapeHTML();
    };

    var centerNoWrapFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner,"text-align", "center");
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        if (typeof oData === 'undefined' || oData === null) {
            oData = "";
        }
        elLiner.innerHTML = String(oData).escapeHTML();
    };

    var rightNoWrapFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner,"text-align", "right");
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        if (typeof oData === 'undefined' || oData === null) {
            oData = "";
        }
        elLiner.innerHTML = String(oData).escapeHTML();
    };

    var expansionFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner, "text-align", "center");
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        elLiner.update();

        if (!_this.isJobRecord(record)) {

            if (_this.allRowsExpanded) {
                _this.workflowExpansionCache[record.getData("id")] = true;
            }

            if (_this.workflowExpansionCache[record.getData("id")]) {
                elLiner.insert(
                    new Element('a', { title: i18n('ShowHideJobs'), style: 'cursor: pointer;' })
                        .insert(new Element('img', { src: iconMinusUrl, border: '0' }))
                        .observe('click', function(event) { _this.toggleWorkflow(this); })
                );
            }
            else {
                elLiner.insert(
                    new Element('a', { title: i18n('ShowHideJobs'), style: 'cursor: pointer;' })
                        .insert(new Element('img', { src: iconPlusUrl, border: '0' }))
                        .observe('click', function(event) { _this.toggleWorkflow(this); })
                );
            }
        }
    };

    var checkboxFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        YAHOO.util.Dom.setStyle(elLiner,"text-align", "center");
        elLiner.update();
        if (!_this.isJobRecord(record)) {
            var workflowId = record.getData('id');
            var checked = record.getData('checked');
            if (workflowId) {
                var inputElement = new Element('input', { type: 'checkbox', name: 'workflowCaseId', value: oData, title: i18n('ProcessSelectUnselect') });
                inputElement.addClassName('checkbox');
                inputElement.observe('click', function(event) { _this.checkWorkflow(record); });
                if (checked) {
                    inputElement.checked = true;
                }
                elLiner.insert(inputElement);
            }
        }
    };

    var viewFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        YAHOO.util.Dom.setStyle(elLiner,"text-align", "center");
        elLiner.update();
        if (_this.isJobRecord(record)) {
            // job row
            var jobId = record.getData('jobTraceId');
            elLiner.insert(
                new Element('a', { title: i18n('ViewJob'), style: 'cursor: pointer; padding: 0px 3px;',
                    href: viewJobUrl + jobId })
                    .insert(new Element('img', { src: iconViewUrl, border: '0' }))
            );
        }
        else {
            // workflow row
            var status = record.getData('status');
            var workflowName = record.getData('workflowName');
            var workflowId = record.getData('id');
            if (workflowId) {
                elLiner.insert(
                    new Element('a', { title: i18n('ViewProcess'), style: 'cursor: pointer; padding: 0px 3px;',
                        href: viewWorkflowUrl + workflowId })
                        .insert(new Element('img', { src: iconViewUrl, border: '0' }))
                );
            }
        }
    };

    var nameFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        elLiner.update(oData);
    };

    var statusFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        YAHOO.util.Dom.setStyle(elLiner.parentNode,"background-color", record.getData("statusColor"));
        YAHOO.util.Dom.setStyle(elLiner,"text-align", "center");
        if (typeof oData === 'undefined' || oData === null) {
            oData = "";
        }
        elLiner.innerHTML = String(oData).escapeHTML();
    };

    var buildLifeFormatter = function(elLiner, record, oColumn, oData) {
        elLiner = $(elLiner);
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        if (!_this.isJobRecord(record)) {
            var stamp = record.getData("stamp");
            if (stamp) {
                elLiner.innerHTML = String(stamp).escapeHTML();
            }
            else {
                elLiner.innerHTML = String(oData).escapeHTML();
            }
        }
        else {
            elLiner.innerHTML = "";
        }
    };

    this.toggleWorkflow = function(link) {
        link = $(link);
        var row = $(link.up('tr'));
        var record = _this.dataTable.getRecord(row);
        var id = record.getData('id');
        var expanded = null;
        if (_this.workflowExpansionCache[id]) {
            // close it
            _this.allRowsExpanded = false;
            row.down('img').src = iconPlusUrl;
            _this.workflowExpansionCache[id] = null;
            _this.postProcessRows();
            expanded = false;
        }
        else {
            // expand it
            row.down('img').src = iconMinusUrl;
            _this.workflowExpansionCache[id] = true;
            _this.postProcessRows();
            expanded = true;
        }

        // update the expand/collapse state for the row on server
        if (_this.clientSession) {
            var rowExpandKey = _this.singleRowExpandedKeyPrefix + id;
            if (expanded == _this.isExpandAll) {
                _this.nonDefaultWorkflowIds.set(id, 'override');
                _this.clientSession.setProperty(rowExpandKey, expanded ? 'true' : 'false');
            }
            else {
                _this.nonDefaultWorkflowIds.unset(id);
                _this.clientSession.removeProperty(rowExpandKey);
            }
        }
    };

    this.toggleAllRows = function() {
        if (_this.isExpandAll) {
            _this.allRowsExpanded = true;
            var records = _this.dataTable.getRecordSet().getRecords();
            var i;
            for (i=0; i<records.length; i++) {
                _this.workflowExpansionCache[records[i].getData('id')] = true;
            }
            $('expandAllLink').down('img').src = iconMinusUrl;
            $$('tr.current-activity-workflow').each(
                function(row) {
                    row.down('img').src = iconMinusUrl;
                }
            );
        }
        else {
            _this.allRowsExpanded = false;
            _this.workflowExpansionCache = [];
            $('expandAllLink').down('img').src = iconPlusUrl;
            $$('tr.current-activity-workflow').each(
                function(row) {
                    row.down('img').src = iconPlusUrl;
                }
            );
        }
        if (_this.clientSession) {
            if (_this.isExpandAll) {
                _this.clientSession.setProperty(_this.allRowExpandedKey, 'true');
            }
            else {
                _this.clientSession.removeProperty(_this.allRowExpandedKey);
            }

            // reset all per-workflow override settings
            var workflowProps = _this.nonDefaultWorkflowIds.keys().collect(function(id) {
                return '' + _this.singleRowExpandedKeyPrefix + id;
            });
            _this.clientSession.removeProperty(workflowProps);
            _this._nonDefaultWorkflowIds = new Hash(); // clear the hash
        }
        _this.postProcessRows();
        _this.isExpandAll = !_this.isExpandAll;
    };

    this.selectAllRowsForAction = function() {
        if ($('selectAllRowsForAction').checked) {
            $$('input[name="workflowCaseId"]').each(function(checkbox) {
                checkbox.checked = true;
                var row = checkbox.up("tr");
                var record = _this.dataTable.getRecord(row);
                record.setData("checked", true);
            });
        }
        else {
            $$('input[name="workflowCaseId"]').each(function(checkbox) {
                checkbox.checked = false;
                var row = checkbox.up("tr");
                var record = _this.dataTable.getRecord(row);
                record.setData("checked", false);
            });
        }
        _this.validateActions();
    };

    this.selectGroupRowsForAction = function(e) {
        var input = $(event.getTarget(e));
        var row = input.up('tr');
        var checkbox = row.down('input[name="workflowCaseId"]');

        checkbox.checked = input.checked;
        var record = _this.dataTable.getRecord(row);
        record.setData("checked", input.checked);

        row = row.next();

        while (row && !row.hasClassName("group-first-row") && !row.hasClassName("group-first-row-collapsed")) {
            if (!row.hasClassName("current-activity-job")) {
                checkbox = row.down('input[name="workflowCaseId"]');
                checkbox.checked = input.checked;
                var record = _this.dataTable.getRecord(row);
                record.setData("checked", input.checked);
            }
            row = row.next();
        }

        _this.validateActions();
    };

    this.projectNameSort = function(record1, record2, desc) {
        return _this.commonSort(record1, record2, desc, 'projectName');
    };

    this.workflowNameSort = function(record1, record2, desc) {
        return _this.commonSort(record1, record2, desc, 'workflowName');
    };

    this.envNameSort = function(record1, record2, desc) {
        return _this.commonSort(record1, record2, desc, 'envName');
    };

    this.buildLifeSort = function(record1, record2, desc) {
        return _this.commonSort(record1, record2, desc, 'stamp', 'buildLifeId');
    };

    this.startDateSort = function(record1, record2, desc) {
        return _this.commonSort(record1, record2, desc, 'startDateMS');
    };

    this.durationSort = function(record1, record2, desc) {
        return _this.commonSort(record1, record2, desc, 'duration');
    };

    this.statusSort = function(record1, record2, desc) {
        return _this.commonSort(record1, record2, desc, 'status');
    };

    this.commonSort = function(record1, record2, desc, dataName, secondaryDataName) {
        // Deal with empty values
        if (!YAHOO.lang.isValue(record1)) {
            return (!YAHOO.lang.isValue(record2)) ? 0 : 1;
        }
        else if (!YAHOO.lang.isValue(record2)) {
            return -1;
        }

        _this.resetGroups = false; // re-draw the groups after rows are re-rendered

        // short-circuit if just one of the rows compared is a miscellaneous job
        if (record1.getData("groupId") != i18n('MiscellaneousJobs') || record2.getData("groupId") != i18n('MiscellaneousJobs')) {
            if (record1.getData("groupId") == i18n('MiscellaneousJobs')) { return 1; };
            if (record2.getData("groupId") == i18n('MiscellaneousJobs')) { return -1; };
        }

        var comp = YAHOO.util.Sort.compare;
        var compResult = 0;
        if (_this.currentGroupBy) {
            compResult = comp(record1.getData("groupId"), record2.getData("groupId"), desc);
            if (compResult == 0) {
                // groups are the same, compare id to keep workflow jobs together
                compResult = comp(record1.getData("id"), record2.getData("id"), desc);
                /* never sort jobs
                // if both are job rows, sort them by their 1st name field
                if (compResult == 0 && _this.isJobRecord(record1) && _this.isJobRecord(record2)) {
                    compResult = comp(record1.getData("name1"), record2.getData("name1"), desc);
                }
                else
                */
                if (compResult != 0) {
                    var data1 = record1.getData(dataName);
                    if (!data1 && secondaryDataName) {
                        data1 = record1.getData(secondaryDataName);
                    }
                    var data2 = record2.getData(dataName);
                    if (!data2 && secondaryDataName) {
                        data2 = record2.getData(secondaryDataName);
                    }
                    compResult = comp(data1, data2, desc);
                }
                else {
                    compResult = 0;
                }
            }
        }
        else {
            // there are no groups, compare by data field
            var data1 = record1.getData(dataName);
            if (!data1 && secondaryDataName) {
                data1 = record1.getData(secondaryDataName);
            }
            var data2 = record2.getData(dataName);
            if (!data2 && secondaryDataName) {
                data2 = record2.getData(secondaryDataName);
            }
            compResult = comp(data1, data2, desc);
            /* never sort jobs
            if (compResult == 0 && _this.isJobRecord(record1) && _this.isJobRecord(record2)) {
                compResult = comp(record1.getData("name1"), record2.getData("name1"), desc);
            }
            */
        }

        return compResult;
    };

    this.postProcessRows = function() {
        var table = $(_this.dataTable.getTableEl());
        var lastGroupName = null;
        var lastWorkflowRowClass = "yui-dt-odd-workflow";
        var lastJobRowClass = "yui-dt-odd-job";
        table.select('tbody.yui-dt-data tr').each(
            function(row) {
                row = $(row);
                var record = _this.dataTable.getRecord(row);

                if (_this.isJobRecord(record)) {
                    row.removeClassName(lastJobRowClass);
                    if (lastJobRowClass == "yui-dt-odd-job") {
                        lastJobRowClass = "yui-dt-even-job";
                    }
                    else {
                        lastJobRowClass = "yui-dt-odd-job";
                    }
                    row.addClassName(lastJobRowClass);
                    row.addClassName("current-activity-job");
                    if (!_this.allRowsExpanded && !_this.workflowExpansionCache[record.getData("id")]) {
                        row.hide();
                    }
                    else {
                        row.show();
                    }
                }
                else {
                    if (_this.currentGroupBy) {
                        var groupName = record.getData(groupBy);
                        if (groupName != lastGroupName) {
                            lastWorkflowRowClass = "yui-dt-odd-workflow";
                        }
                        lastGroupName = groupName;
                    }

                    row.addClassName("current-activity-workflow");
                    row.removeClassName(lastWorkflowRowClass);
                    if (lastWorkflowRowClass == "yui-dt-odd-workflow") {
                        lastWorkflowRowClass = "yui-dt-even-workflow";
                    }
                    else {
                        lastWorkflowRowClass = "yui-dt-odd-workflow";
                    }
                    lastJobRowClass = "yui-dt-odd-job";
                    if (record.getData('priority') == 'High') {
                        row.addClassName(lastWorkflowRowClass + '-priority');
                    }
                    else {
                        row.addClassName(lastWorkflowRowClass);
                    }
                }
            }
        );

        _this.initGroups();
    };

    this.createTable = function(currentActivityWorkflowOverrideIds, allRowsExpanded, isExpandAll) {
       _this.dataSourceUrl = loadUrl + "?search=true";
       _this.currentActivityWorkflowOverrideIds = currentActivityWorkflowOverrideIds;
       _this.allRowsExpanded = allRowsExpanded;
       _this.isExpandAll = isExpandAll;

       if ($('currentGroupBy').value) {
           _this.dataSourceUrl = _this.dataSourceUrl + '&groupBy=' + $('currentGroupBy').value;
       }
       $$('input[name="currentFilterBy"]').each(
           function (input) {
               _this.dataSourceUrl = _this.dataSourceUrl + "&filterBy=" + input.value;
           }
       );

       _this.dataSource = new YAHOO.util.DataSource(_this.dataSourceUrl);
       _this.dataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;
       _this.dataSource.responseSchema = {
           resultsList:'response.results',
           fields:[
               {key:"groupId"},
               {key:"id", parser:YAHOO.util.DataSource.parseNumber},
               {key:"buildLifeId", parser:YAHOO.util.DataSource.parseNumber},
               {key:"projectId", parser:YAHOO.util.DataSource.parseNumber},
               {key:"projectName"},
               {key:"workflowId", parser:YAHOO.util.DataSource.parseNumber},
               {key:"workflowName"},
               {key:"envId", parser:YAHOO.util.DataSource.parseNumber},
               {key:"envName"},
               {key:"status"},
               {key:"statusColor"},
               {key:"stamp"},
               {key:"priority"},
               {key:"startDate"},
               {key:"startDateMS"},
               {key:"duration"},
               {key:"canAbort", parser:YAHOO.util.DataSource.parseBoolean},
               {key:"canSuspendResume", parser:YAHOO.util.DataSource.parseBoolean},
               {key:"canPrioritize", parser:YAHOO.util.DataSource.parseBoolean},
               {key:"jobTraceId", parser:YAHOO.util.DataSource.parseNumber},
               {key:"name1"},
               {key:"name2"},
               {key:"name3"},
               {key:"name4"},
               {key:"name5"},
               {key:"name6"}
           ]
       };

       _this.currentActivityWorkflowOverrideIds.each(function(id) {
           _this.nonDefaultWorkflowIds.set(id, 'override');
           _this.workflowExpansionCache[id] = true;
       });

       var myColumnDefs = [
          {key:"id", label:"<a id='expandAllLink' onclick='toggleAllRows();' style='cursor: pointer;' title='" + i18n("ShowHideAllJobs") + "'><img src='" + iconExpandAllUrl + "' border='0'/></a>",
              formatter: expansionFormatter },
          {key:"id", label:"<input type='checkbox' class='checkbox' id='selectAllRowsForAction' name='selectAllRowsForAction' title='" + i18n("WorkflowsSelectUnselectAll") + "' onclick='selectAllRowsForAction();'/>",
              formatter: checkboxFormatter, resizeable: false },
          {key:"id", label:"<div>" + i18n("View") + "</div>",
              formatter: viewFormatter, resizeable: false },
          {key:"name1", label:"<div style='margin: 0 20px 0 20px'>" + i18n("Project") + " / " + i18n("Job") + "</div>",
              formatter: nameFormatter, sortable: true, resizeable: false,
              sortOptions:{ sortFunction: this.projectNameSort }},
          {key:"name2", label:"<div style='margin: 0 20px 0 20px'>" + i18n("Process") + " / " + i18n("Step") + "</div>",
              formatter: noWrapFormatter, sortable: true, resizeable: false,
              sortOptions:{ sortFunction: this.workflowNameSort }},
          {key:"name3", label:"<div style='margin: 0 20px 0 20px'>" + i18n("Agent") + "</div>",
              formatter: noWrapFormatter, sortable: true, resizeable: false,
              sortOptions:{ sortFunction: this.envNameSort }},
          {key:"buildLifeId", label:"<div style='margin: 0 20px 0 20px'>" + i18n("Stamp") + " / " + i18n("Build") + "</div>",
              formatter: buildLifeFormatter, sortable: true, resizeable: false,
              sortOptions:{ sortFunction: this.buildLifeSort }},
          {key:"name4", label:"<div style='margin: 0 20px 0 20px'>" + i18n("StartTime") + "</div>",
              formatter: centerNoWrapFormatter, sortable: true, resizeable: false,
              sortOptions:{ sortFunction: this.startDateSort }},
          {key:"name5", label:"<div style='margin: 0 20px 0 20px'>" + i18n("Duration") + "</div>",
              formatter: rightNoWrapFormatter, sortable: true, resizeable: false,
              sortOptions:{ sortFunction: this.durationSort }},
          {key:"name6", label:"<div style='margin: 0 20px 0 20px'>" + i18n("Status") + "</div>",
              formatter: statusFormatter, sortable: true, resizeable: false,
              sortOptions:{ sortFunction: this.statusSort }}
       ];

       var captionHtml = i18n("CurrentActivity");
       captionHtml += "&nbsp;&nbsp;&nbsp;<span id='selectedWorkflowsMessage' class='small-text'> " + i18n("ProcessesSelected", 0) + "</span>&nbsp;&nbsp;&nbsp;";
       captionHtml += "<a id='abortLink' title='" + i18n("Abort") + "' onclick='abortWorkflow();' style='cursor: pointer; display: none; padding: 0px 3px;'><img src='" + iconAbortUrl + "' border='0'/></a>";
       captionHtml += "<a id='suspendLink' title='" + i18n("Suspend") + "' onclick='suspendWorkflow();' style='cursor: pointer; display: none; padding: 0px 3px;'><img src='" + iconSuspendUrl + "' border='0'/></a>";
       captionHtml += "<a id='resumeLink' title='" + i18n("Resume") + "' onclick='resumeWorkflow();' style='cursor: pointer; display: none; padding: 0px 3px;'><img src='" + iconResumeUrl + "' border='0'/></a>";
       captionHtml += "<a id='prioritizeLink' title='" + i18n("Prioritize") + "' onclick='prioritizeWorkflow();' style='cursor: pointer; display: none; padding: 0px 3px;'><img src='" + iconPrioritizeUrl + "' border='0'/></a>";

       var tableConfigs = {
           caption: captionHtml,
           initialLoad: false,
           dynamicData: false,
           formatRow: _this.rowFormatter,
           MSG_EMPTY: i18n("No records found."),
           MSG_LOADING: i18n('LoadingEllipsis')
       };

       _this.dataTable = new YAHOO.widget.DataTable("current-activity", myColumnDefs, _this.dataSource, tableConfigs);

       _this.dataTable.subscribe("sortedByChange", _this.postProcessRows); /* Not required but prevents flickering */
       _this.dataTable.subscribe("postRenderEvent", _this.postProcessRows);

       // Update group widths when columns are resized
       _this.dataTable.subscribe("columnSetWidthEvent", function() { _this.resizeGroups(); });

       _this.dataTable.getTableEl().id = "current-activity-table";

       _this.clientSession = new UC_CLIENT_SESSION( { 'clientSessionSetPropUrl': setPropertyUrl });
    };

    /**
     * Called every time data is loaded from the DataSource (JSON from the server)
     */
    this.onDataReturnSetRows = function(oRequest , oResponse , oPayload) {
        _this.dataTable.onDataReturnReplaceRows(oRequest , oResponse , oPayload);

        // read the sort before sorting by group to retain the original values
        var sortedBy = _this.dataTable.getState().sortedBy;

        // first sort by the group to group things together after data load
        if (_this.currentGroupBy) {
            if (_this.currentGroupBy == "Context") {
                // no column for context
            }
            else if (_this.currentGroupBy == "Project") {
                _this.dataTable.sortColumn(_this.dataTable.getColumn("name1"));
            }
            else if (_this.currentGroupBy == "Stamp") {
                _this.dataTable.sortColumn(_this.dataTable.getColumn("buildLifeId"));
            }
        }

        // sort by the original sorting if applicable
        if (sortedBy) {
            _this.dataTable.sortColumn(_this.dataTable.getColumn(sortedBy.key), sortedBy.dir);
        }
    };

    this.loadTable = function() {
        var callback = {
            success: _this.onDataReturnSetRows,
            failure: _this.loadDataFailure,
            scope: _this.dataTable,
            argument: _this.dataTable.getState()
        };

        _this.dataSourceUrl = loadUrl + "?filterName=" + $('filterName').value;

        if ($('currentGroupBy').value) {
            _this.dataSourceUrl = _this.dataSourceUrl + '&groupBy=' + $('currentGroupBy').value;
        }
        $$('input[name="currentFilterBy"]').each(
            function (input) {
                _this.dataSourceUrl = _this.dataSourceUrl + "&filterBy=" + input.value;
            }
        );

        _this.currentGroupBy = $('currentGroupBy').value;

        _this.dataSource.liveData = _this.dataSourceUrl;
        _this.dataSource.sendRequest('', callback);

        $('selectAllRowsForAction').checked = false;
    };

    this.loadDataFailure = function() {
        alert(i18n("CurrentActivityLoadingTableError"));
    };
}

var currentActivity = null;
//var myLogReader = new YAHOO.widget.LogReader();

function setCurrentFilterGroupBy() {
    $('currentGroupBy').value = $('groupBy').value;
    $('currentGroupByDiv').update(i18n($('groupBy').value));
    $('groupBy').selectedIndex = 0;
}

function addCurrentFilterFilterBy() {
    if ($('filterBy').selectedIndex > 0 && $('filterValue').value.length > 0) {
        $('currentFilterByDiv').insert(
            new Element('input', { type: 'hidden', name: 'currentFilterBy', value: $('filterBy').value + ':' + $('filterValue').value })
        );

        var msg = i18n("FilterObjectIsValue", $('filterBy').value, $('filterValue').value);
        $('currentFilterByDiv').insert(
            new Element('span').insert(msg).insert(new Element('br'))
        );
        $('filterBy').selectedIndex = 0;
        $('filterValue').value = "";
    }
    else {
        alert(i18n("FilterByValueSelect"));
    }
}

function clearFilterBuilder() {
    $('groupBy').selectedIndex = 0;
    $('filterBy').selectedIndex = 0;
    $('filterValue').value = '';
}

function clearCurrentFilter() {
    $('filterId').value = '';
    $('filterName').value = '';
    $('currentGroupBy').value = '';
    $('currentGroupByDiv').update();
    $('currentFilterByDiv').update();
}

function currentActivityAjaxPost(url, params, successFunction, failureFunction, errorMessage) {
    new Ajax.Request(url, {
        'method': 'post',
        'asynchronous': false,
        'parameters': params,
        'onSuccess': function(resp) {
            var responseJSON = resp.responseJSON;
            if (responseJSON) {
                var result = responseJSON.response.success;
                if (result == true) {
                    if (successFunction) {
                        successFunction(responseJSON);
                    }
                } else {
                    if (responseJSON.response.message) {
                        errorAlert(resp, responseJSON.response.message);
                    } else {
                        errorAlert(resp, errorMessage);
                    }
                    if (failureFunction) {
                        failureFunction(responseJSON);
                    }
                }
            }
            else {
                errorAlert(resp, errorMessage);
            }
        },
        'onFailure':   function(resp)  { errorAlert(resp, errorMessage); },
        'onException': function(req,e) { throw e;}
    });
}

function errorAlert(resp, errorMessage) {
    if (resp.responseText.indexOf("Login") >= 0) {
        alert(i18n("DashboardSessionExpiredError"));
    } else {
        $('actionResultMessage').addClassName("error");
        $('actionResultMessage').update(
            new Element("pre")
                .insert(errorMessage)
                .insert(new Element("br"))
                .insert(
                    new Element("a", { style: 'cursor: pointer;' })
                        .insert("clear message")
                        .observe('click', function(event) { clearError(); })
                )
        );
        $('actionResultMessage').show();
        //alert(errorMessage);
    }
}

function clearError() {
    $('actionResultMessage').hide();
    $('actionResultMessage').update();
    $('actionResultMessage').removeClassName("error");
}

function saveCurrentFilter() {
    if (!$('filterName').value) {
        alert(i18n("FilterNameRequired"));
        return false;
    }
    var url = saveFilterUrl + '?search=true';
    var params = { filterName: $('filterName').value, groupBy: $('currentGroupBy').value };

    $$('input[name="currentFilterBy"]').each(
        function(filterBy) {
            url += "&filterBy=" + filterBy.value;
        }
    );

    currentActivityAjaxPost(url, params, function(responseJSON) { filterSaved(responseJSON); }, null, i18n('FilterSavedFailed'));
}

function filterSaved(responseJSON) {
    // add the link to the saved filter
    var filterId = responseJSON.response.filter.id;
    var filterName = responseJSON.response.filter.name;

    $('filterId').value = filterId;
    $('current-activity-saved-filters').insert(new Element('tr', { id: 'savedFilter-' + filterId })
        .insert(new Element('td', { style: 'padding-left: 10px;' })
            .insert(new Element('a', { href: savedFilterUrl + '?filterId=' + filterId, title: i18n('ReloadAndApplyFilter') })
                .insert(String(filterName).escapeHTML())
            )
        )
        .insert(new Element('td')
            .insert(new Element('a', { href: '#', title: i18n('DeleteFilter') })
                .insert(new Element('img', { src: iconAbortUrl, border: '0' }))
                .observe('click', function(event) { if (confirmDelete(filterName)) { deleteSavedFilter(filterId); } })
            )
        )
    );
}

function deleteSavedFilter(filterIdValue) {
    var params = { filterId: filterIdValue };

    currentActivityAjaxPost(deleteFilterUrl, params, function(responseJSON) { filterDeleted(filterIdValue); }, i18n('FilterDeleteFailed'));
}

function filterDeleted(filterId) {
    var savedFilterRow = $('savedFilter-' + filterId);
    savedFilterRow.remove();

    if ($('filterId').value == filterId) {
        $('filterId').value = "";
    }
}

function toggleAllRows() {
    currentActivity.toggleAllRows();
}

function selectAllRowsForAction() {
    currentActivity.selectAllRowsForAction();
}

function abortWorkflow() {
    if (basicConfirm(i18n("WorkflowAbortConfirmation", $('selectedWorkflowsMessage').innerHTML))) {
        var selectedWorkflowIds = currentActivity.getSelectedWorkflowIds();
        var url = abortWorkflowUrl + selectedWorkflowIds.join(",");
        currentActivityAjaxPost(url, null, function(responseJSON) { currentActivity.loadTable(); },
            function(responseJSON) { currentActivity.loadTable(); }, i18n('ProcessesAbortFailed'));
    }
}

function suspendWorkflow() {
    if (basicConfirm(i18n("ProcessesSuspendConfirmation", $('selectedWorkflowsMessage').innerHTML))) {
        var selectedWorkflowIds = currentActivity.getSelectedWorkflowIds();
        var url = suspendWorkflowUrl + selectedWorkflowIds.join(",");
        currentActivityAjaxPost(url, null, function(responseJSON) { currentActivity.loadTable(); },
            function(responseJSON) { currentActivity.loadTable(); }, i18n('ProcessesSuspendFailed'));
    }
}

function resumeWorkflow() {
    if (basicConfirm(i18n("ProcessesResumeConfirmation", $('selectedWorkflowsMessage').innerHTML))) {
        var selectedWorkflowIds = currentActivity.getSelectedWorkflowIds();
        var url = resumeWorkflowUrl + selectedWorkflowIds.join(",");
        currentActivityAjaxPost(url, null, function(responseJSON) { currentActivity.loadTable(); },
            function(responseJSON) { currentActivity.loadTable(); }, i18n('ProcessesResumeFailed'));
    }
}

function prioritizeWorkflow() {
    if (basicConfirm(i18n("ProcessesPrioritizeConfirmation", $('selectedWorkflowsMessage').innerHTML))) {
        var selectedWorkflowIds = currentActivity.getSelectedWorkflowIds();
        var url = prioritizeWorkflowUrl + selectedWorkflowIds.join(",");
        currentActivityAjaxPost(url, null,function(responseJSON) { currentActivity.loadTable(); },
            function(responseJSON) { currentActivity.loadTable(); }, i18n('ProcessesPrioritizeFailed'));
    }
}
