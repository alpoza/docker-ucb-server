/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var EnvironmentForm = function(viewServerGroupUrl) {
    this.addAgentsTable = null;
    this.agentsInEnvironment = null;
    this.addAgentsDataSource = null;
    this.addAgentsAutoComplete = null;
    paginationRowsPerPage = [25, 50, 100, 200];

    tableResponseSchema = {
      resultsList: "items",
      fields: [
        {key:"AgentId"},
        {key:"Name"},
        {key:"Description"}
      ],
      metaFields:{
          totalRecords: 'totalRecords'
      }
    };

    newCheckboxFormatter = function(elLiner, oRecord, oColumn, oData) {
        if (oRecord.getData("check")) {
            oData = true;
        }
        YAHOO.widget.DataTable.formatCheckbox(elLiner, oRecord, oColumn, oData);
    };

    updateDataRecord = function(oArgs) {
        var elCheckbox = oArgs.target;
        var record = this.getRecord(elCheckbox);
        record.setData("check", elCheckbox.checked);
    };

    this.initializeAddAgentsTable = function(useScrolling, dataSourceUrl) {
        var that = this;
        this.addAgentsDataSource = new YAHOO.util.DataSource(dataSourceUrl);

        this.addAgentsDataSource.responseSchema = tableResponseSchema;

        var columnDefs =  [
            { key:"Select", label:"<div style='text-align:left'><input id='addAgentsSelAll' class='yui-dt-checkbox' type='checkbox' onclick='environmentForm.toggleSelectAll(this, environmentForm.addAgentsTable)'></div>", formatter: newCheckboxFormatter, className:"selectCol"},
            { key:"Name", label:i18n("Name"), className:"nameCol", formatter:this.noWrapFormatter},
            { key:"Description", label:i18n("Description"), className:"descCol", formatter:this.descriptionFormatter}
        ];

        var paginator = new YAHOO.widget.Paginator({
            rowsPerPage:25,
            template:YAHOO.widget.Paginator.TEMPLATE_ROWS_PER_PAGE,
            containers:"add-agents-paging",
            pageLinks:12,
            rowsPerPageOptions:paginationRowsPerPage
        });

        var resetCheckbox = function() {
            YAHOO.util.Dom.get("addAgentsSelAll").checked = false;
        };

        paginator.subscribe("pageChange", resetCheckbox);

        var addAgentsTableConfigs = {
            height:"18em",
            paginator:paginator,
            MSG_EMPTY: i18n("No records found."),
            MSG_LOADING: i18n("LoadingEllipsis")
        };

        this.addAgentsTable = new YAHOO.widget.DataTable("add-agents-table", columnDefs, this.addAgentsDataSource, addAgentsTableConfigs);
        this.addAgentsTable.handleDataReturnPayload = function(oRequest, oResponse, oPayload) {
            YAHOO.log("handleDataReturnPayload");
            YAHOO.log("request:" + YAHOO.lang.dump(oRequest));
            YAHOO.log("response:" + YAHOO.lang.dump(oResponse));
            YAHOO.log("payload:" + YAHOO.lang.dump(oPayload));
            YAHOO.log("totalRecords:" + oResponse.meta.totalRecords);
            if (oPayload) {
               oPayload.totalRecords = oResponse.meta.totalRecords;
            }
            else {
                oPayload = {totalRecords: oResponse.meta.totalRecords};
            }
            return oPayload;
        };

        this.addAgentsTable.subscribe("checkboxClickEvent", updateDataRecord);

        var queryAgents = function(query) {
            YAHOO.log("query:" + query);
            that.addAgentsDataSource.sendRequest('&query=' + query, that.addAgentsTable.onDataReturnInitializeTable, that.addAgentsTable);
        };

        var oACDS = new YAHOO.util.FunctionDataSource(queryAgents);
        oACDS.queryMatchContains = true;
        this.addAgentsAutoComplete = new YAHOO.widget.AutoComplete("query_input","dt_ac_container", oACDS);
        this.addAgentsAutoComplete.minQueryLength = 0;
        this.addAgentsAutoComplete.queryDelay = .5;
    };

    this.initializeAgentsInEnvironmentTable = function(useScrolling, dataSourceUrl) {
        var myDatSource = null;

        this.myDataSource = new YAHOO.util.DataSource(dataSourceUrl);

        this.myDataSource.responseSchema = tableResponseSchema;

        var columnDefs =  [
            { key:"Select", label:"<div style='text-align:left'><input id='agentsInEnvSelAll' class='yui-dt-checkbox' type='checkbox' onclick='environmentForm.toggleSelectAll(this, environmentForm.agentsInEnvironment)'></div>", formatter: newCheckboxFormatter, className:"selectCol"},
            { key:"Name", label:i18n("Name"), className:"nameCol", formatter:this.noWrapFormatter},
            { key:"Description", label:i18n("Description"), className:"descCol", formatter:this.descriptionFormatter}
        ];

        var paginator = new YAHOO.widget.Paginator({
            rowsPerPage:25,
            template:YAHOO.widget.Paginator.TEMPLATE_ROWS_PER_PAGE,
            containers:"agents-in-env-paging",
            pageLinks:12,
            rowsPerPageOptions:paginationRowsPerPage
        });

        var resetCheckbox = function() {
            YAHOO.util.Dom.get("agentsInEnvSelAll").checked = false;
        };

        paginator.subscribe("pageChange", resetCheckbox);

        var agentsInEnvironmentTableConfigs = {
            height:"18em",
            paginator:paginator,
            MSG_EMPTY: i18n("No records found."),
            MSG_LOADING: i18n("LoadingEllipsis")
        };

        this.agentsInEnvironment = new YAHOO.widget.DataTable("agents-in-env-table", columnDefs, this.myDataSource, agentsInEnvironmentTableConfigs);
        this.agentsInEnvironment.subscribe("checkboxClickEvent", updateDataRecord);
    };

    this.addSelectedAgents = function() {
        var addAgentsRecordSet = this.addAgentsTable.getRecordSet();
        var agentRecords = addAgentsRecordSet.getRecords();
        for (i = 0; i < agentRecords.length; i++) {
            var record = agentRecords[i];
            if (record.getData("check")) {
                record.setData("check", false);
                var recordIndex = addAgentsRecordSet.getRecordIndex(record);
                this.agentsInEnvironment.addRow(record.getData());
                this.addAgentsTable.deleteRow(recordIndex);
                i--;
            }
        }
        YAHOO.util.Dom.get("addAgentsSelAll").checked = false;
        this.agentsInEnvironment.sortColumn(this.agentsInEnvironment.getColumn("Name"), YAHOO.widget.DataTable.CLASS_ASC);
    };

    this.removeSelectedAgents = function() {
        var agentsInEnvRecordSet = this.agentsInEnvironment.getRecordSet();
        var agentRecords = agentsInEnvRecordSet.getRecords();
        for (i = 0; i < agentRecords.length; i++) {
            var record = agentRecords[i];
            if (record.getData("check")) {
                record.setData("check", false);
                var recordIndex = agentsInEnvRecordSet.getRecordIndex(record);
                this.addAgentsTable.addRow(record.getData());
                this.agentsInEnvironment.deleteRow(recordIndex);
                i--;
            }
        }
        YAHOO.util.Dom.get("agentsInEnvSelAll").checked = false;
        this.addAgentsTable.sortColumn(this.addAgentsTable.getColumn("Name"), YAHOO.widget.DataTable.CLASS_ASC);
    };

    this.toggleSelectAll = function(elCheck, table) {
        YAHOO.log("In The Toggle Select Add Method!");
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
            record.setData("check", elCheck.checked);
        }
        table.render();
    };

    this.preSaveAction = function() {
        var recordsInEnv = this.agentsInEnvironment.getRecordSet().getRecords();

        var recordIds = new Array();

        for (i = 0; i < recordsInEnv.length; i++) {
            recordIds[i] = recordsInEnv[i].getData("AgentId");
        }

        var recordIdStr = recordIds.join(",");
        YAHOO.util.Dom.get("agentIds").value = recordIdStr;
    };

    this.cancelAgentsTable = function() {
        parent.location = viewServerGroupUrl;
    }
};

EnvironmentForm.prototype = new AgentDataTableHolder();
