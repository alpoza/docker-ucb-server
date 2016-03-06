/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global define, require */

define([
        "dijit/_TemplatedMixin",
        "dijit/_Widget",
        "dijit/form/Button",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/on",
        "dojox/html/entities",
        "js/webext/widgets/Alert",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/GenericConfirm",
        "js/webext/widgets/table/TreeTable"
        ],
function(
        _TemplatedMixin,
        _Widget,
        Button,
        declare,
        xhr,
        domClass,
        domConstruct,
        on,
        entities,
        Alert,
        Dialog,
        GenericConfirm,
        TreeTable
) {
    /**
     * A build life source analytic findings table widget with pagination, sorting, and custom formatting.
     * Uses an actual HTML table for display.
     *
     * Pagination, sorting, and filtering are supported by REST services. REST
     * services built to perform these operations must return an object of the format (the totalRecords value is optional):
     *  {
     *      totalRecords: ##,
     *      records: [
     *          {record}, ...
     *      ]
     *  }
     *
     * Supported properties:
     *  url / String                   The URL to the reports findings. Required.
     */
    
    return declare('js.ubuild.widgets.table.SourceAnalyticFindingsTable', [_Widget, _TemplatedMixin], {
        templateString: 
            '<div class="sourceAnalyticFindingTable">'+
                '<div data-dojo-attach-point="sourceAnalyticFindingsGrid"></div>'+
            '</div>',
        displayId: false,
        displayStatus: false,

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;
            
            var columns = [];
            
            if (self.displayId) {
                columns.push({
                    name: i18n("ID"),
                    field: "id",
                    orderField: "id",
                    filterField: "id",
                    filterType: "text"
                });
            }
            
            columns.push({ 
                name: i18n("File"),
                field: "file",
                orderField: "file",
                filterField: "file",
                filterType: "text",
                formatter: this.fileFormatter
            });
            if (self.displayStatus) {
                columns.push({
                    name: i18n("Status"),
                    field: "status",
                    orderField: "status",
                    filterField: "status",
                    filterType: "text"
                });
            }
            columns.push({
                name: i18n("Name") + " (" + i18n("HoverForDescription") + ")",
                field: "name",
                orderField: "name",
                filterField: "name",
                filterType: "text",
                formatter: this.nameFormatter
            });
            columns.push({
                name: i18n("Severity"),
                field: "severity",
                orderField: "severity",
                filterField: "severity",
                filterType: "text"
            });

            this.grid = new TreeTable({
                "url": self.url,
                "orderField": "file",
                "hideExpandCollapse": true,
                "hidePagination": false,
                "columns": columns,
                "pageOptions": [25, 50, 100, 250],
                "rowsPerPage": 25,
                "serverSideProcessing": false
            });
            this.grid.placeAt(this.sourceAnalyticFindingsGrid);
        },
        
        /**
         * 
         */
        fileFormatter: function(item) {
            var self = this.parentWidget;
            var result = domConstruct.create("div");
            var content = entities.encode(item.file);
            if (item.line) {
                content += ", " + i18n("LineNumber", item.line);
            }
            result.innerHTML = content;
            return result;
        },
        
        /**
         * 
         */
        nameFormatter: function(item) {
            var self = this.parentWidget;
            var result = domConstruct.create("div");
            if (item.description) {
                result.setAttribute("title", item.description);
            }
            var content = entities.encode(item.name);
            result.innerHTML = content;
            return result;
        }
    });
});