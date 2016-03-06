/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global YAHOO*/

/**
 *
 * TODO
 *   this still requires some very specific mark-up to be on the page as well as element and variable names see addServerGroups.jsp for example
 *   instance must be assigned to variable addRemoveTableFormController
 *
 * @param options
 * @returns
 */
var AddRemoveTableFormController = function(options) {

    //
    // This data/structures should ideally all come from the options parameter
    //

    var backUrl = options.backUrl || null;
    var itemsInCollectionUrl = options.itemsInCollectionUrl || null;
    var addItemsUrl = options.addItemsUrl || null;
    this.imgUrl = options.imgUrl || null;

    var itemIdAttribute = options.itemIdAttribute || null;
    var resultInputId = options.resultInputId || null;

    var itemEnabled = options.itemEnabled || function (oRecord) {return true};

    var tableResponseSchema = options.tableResponseSchema || null;
    var columnDefs = options.columnDefs || null;
    var emptyMessage = options.emptyMessage || null;
    var loadingMessage = options.loadingMessage || null;

    //
    // End User data
    //


    this.addItemDataTable = null;
    this.itemsInCollectionDataTable = null;
    this.addItemsDataSource = null;
    this.addItemsAutoComplete = null;

    var paginationRowsPerPage = [25, 50, 100, 200];

    var newCheckboxFormatter = function(elLiner, oRecord, oColumn, oData) {
        var checked = false;
        if (oRecord.getData("check")) {
            checked = true;
        }
        if (itemEnabled(oRecord)) {
            YAHOO.widget.DataTable.formatCheckbox(elLiner, oRecord, oColumn, checked);
        }
    };

    var updateDataRecord = function(oArgs) {
        var elCheckbox = oArgs.target;
        var record = this.getRecord(elCheckbox);
        record.setData("check", elCheckbox.checked);
    };

    this.initializeAddItemTable = function() {
        var j = 0;
        var that = this;
        this.addItemDataSource = new YAHOO.util.DataSource(addItemsUrl);

        this.addItemDataSource.responseSchema = tableResponseSchema;

        var addItemsColumnDefs =  columnDefs.slice(0);
        addItemsColumnDefs.splice(0,0,
            {
                "key":"Select",
                "label":"<div style='text-align:left'><input id='addItemsSelAll' class='yui-dt-checkbox' type='checkbox' onclick='addRemoveTableFormController.toggleSelectAllItems(this, addRemoveTableFormController.addItemDataTable)'></div>",
                "formatter": newCheckboxFormatter,
                "className":"selectCol"
            }
        );

        var paginator = new YAHOO.widget.Paginator({
            rowsPerPage:25,
            template:YAHOO.widget.Paginator.TEMPLATE_ROWS_PER_PAGE,
            containers:"add-items-paging",
            pageLinks:12,
            rowsPerPageOptions:paginationRowsPerPage
        });

        var resetCheckbox = function() {
            YAHOO.util.Dom.get("addItemSelAll").checked = false;
        };
        paginator.subscribe("pageChange", resetCheckbox);

        var addItemDataTableConfig = {
            height:"18em",
            paginator:paginator,
            MSG_EMPTY: emptyMessage,
            MSG_LOADING: loadingMessage
        };
        this.addItemDataTable = new YAHOO.widget.DataTable("add-items-table", addItemsColumnDefs, this.addItemDataSource, addItemDataTableConfig);
        this.addItemDataTable.handleDataReturnPayload = function(oRequest, oResponse, oPayload) {
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
        this.addItemDataTable.subscribe("checkboxClickEvent", updateDataRecord);

        var queryItems = function(query) {
            YAHOO.log("query:" + query);
            that.addItemDataSource.sendRequest('&query=' + query, that.addItemDataTable.onDataReturnInitializeTable, that.addItemDataTable);
        };

        var oACDS = new YAHOO.util.FunctionDataSource(queryItems);
        oACDS.queryMatchContains = true;
        this.addItemAutoComplete = new YAHOO.widget.AutoComplete("query_input","dt_ac_container", oACDS);
        this.addItemAutoComplete.minQueryLength = 0;
        this.addItemAutoComplete.queryDelay = 0.5;
    };

    this.initializeItemsInCollectionTable = function() {
        var j = 0;
        var myDatSource = null;

        this.myDataSource = new YAHOO.util.DataSource(itemsInCollectionUrl);

        this.myDataSource.responseSchema = tableResponseSchema;


        var itemsInCollectionColumnDefs =  columnDefs.slice(0);
        itemsInCollectionColumnDefs.splice(0,0,
            { key:"Select", label:"<div style='text-align:left'><input id='itemsInCollectionSelAll' class='yui-dt-checkbox' type='checkbox' onclick='addRemoveTableFormController.toggleSelectAllItems(this, addRemoveTableFormController.itemsInCollectionDataTable)'></div>", formatter: newCheckboxFormatter, className:"selectCol"}
        );

        var paginator = new YAHOO.widget.Paginator({
            rowsPerPage:25,
            template:YAHOO.widget.Paginator.TEMPLATE_ROWS_PER_PAGE,
            containers:"items-in-collection-paging",
            pageLinks:12,
            rowsPerPageOptions:paginationRowsPerPage
        });

        var resetCheckbox = function() {
            YAHOO.util.Dom.get("itemsInCollectionSelAll").checked = false;
        };
        paginator.subscribe("pageChange", resetCheckbox);

        var itemsInCollectionTableConfigs = {
            height:"18em",
            paginator:paginator,
            MSG_EMPTY: emptyMessage,
            MSG_LOADING: loadingMessage
        };

        this.itemsInCollectionDataTable = new YAHOO.widget.DataTable("items-in-collection-table", itemsInCollectionColumnDefs, this.myDataSource, itemsInCollectionTableConfigs);
        this.itemsInCollectionDataTable.subscribe("checkboxClickEvent", updateDataRecord);
    };

    this.addSelectedItems = function() {
        var addItemsSet = this.addItemDataTable.getRecordSet();
        var itemRecords = addItemsSet.getRecords();
        var i;
        for (i = 0; i < itemRecords.length; i++) {
            var record = itemRecords[i];
            if (record.getData("check")) {
                record.setData("check", false);
                var recordIndex = addItemsSet.getRecordIndex(record);
                this.itemsInCollectionDataTable.addRow(record.getData());
                this.addItemDataTable.deleteRow(recordIndex);
                i--;
            }
        }
        YAHOO.util.Dom.get("addItemsSelAll").checked = false;
    };

    this.removeSelectedItems = function() {
        var itemsInCollectionRecordSet = this.itemsInCollectionDataTable.getRecordSet();
        var itemRecords = itemsInCollectionRecordSet.getRecords();
        var i;
        for (i = 0; i < itemRecords.length; i++) {
            var record = itemRecords[i];
            if (record.getData("check")) {
                record.setData("check", false);
                var recordIndex = itemsInCollectionRecordSet.getRecordIndex(record);
                this.addItemDataTable.addRow(record.getData());
                this.itemsInCollectionDataTable.deleteRow(recordIndex);
                i--;
            }
        }
        YAHOO.util.Dom.get("itemsInCollectionSelAll").checked = false;
    };

    this.toggleSelectAllItems = function(elCheck, table) {
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
        var i;
        for (i = startIndex; i < startIndex + rowsPerPage && i < totalRecords; i++) {
            var record = records[i];
            if (itemEnabled(record)) {
                record.setData("check", elCheck.checked);
            }
        }
        table.render();
    };

    this.preSaveAction = function() {
        var recordsInEnv = this.itemsInCollectionDataTable.getRecordSet().getRecords();

        var recordIds = [];

        var i;
        for (i = 0; i < recordsInEnv.length; i++) {
            recordIds[i] = recordsInEnv[i].getData(itemIdAttribute);
        }

        var recordIdStr = recordIds.join(",");
        YAHOO.util.Dom.get(resultInputId).value = recordIdStr;
    };

    this.cancelTable = function() {
        parent.location = backUrl;
    };
};
