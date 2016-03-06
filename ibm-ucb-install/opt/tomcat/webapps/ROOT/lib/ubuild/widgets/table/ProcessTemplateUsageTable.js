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
        "js/webext/widgets/Alert",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/GenericConfirm",
        "js/webext/widgets/Table"
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
        Alert,
        Dialog,
        GenericConfirm,
        Table
) {
    /**
     * A template usage table widget with pagination, sorting, and custom formatting. Uses an actual
     * HTML table for display.
     *
     * Pagination, sorting, and filtering are supported by REST services. REST
     * services built to perform these operations must return an object of the format
     * (the totalRecords value is optional):
     *  {
     *      totalRecords: ##,
     *      records: [
     *          {record}, ...
     *      ]
     *  }
     *
     * Supported properties:
     *  tasksUrl / String                   The URL for the WorkflowTasks class. Required.
     *  templateID / Long                   The id for the Template. Required.
     */

    return declare('js.ubuild.widgets.table.TemplateUsageTable', [_Widget, _TemplatedMixin], {
        templateString:
            '<div class="templateUsageTable">'+
                '<div data-dojo-attach-point="templateUsageGrid"></div>'+
            '</div>',
        tasksUrl: undefined,
        templateId: undefined,

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;

            this.linkTemplate = domConstruct.create("a", { "class": "actions-link" });
            var gridRestUrl = bootstrap.restUrl + "/processTemplates/" + self.templateId + "/processes";

            var gridLayout = [{
                    name: i18n("Process"),
                    orderField: "name",
                    field: "name",
                    formatter: this.resourceFormatter,
                    style: { width: "30%" },
                    filterField: "name",
                    filterType: "text",
                    parentWidget: this
                },
                {
                    name: i18n("Description"),
                    field: "description",
                    filterField: "description",
                    filterType: "text",
                    style: { width: "70%" }
                }];

            this.grid = new Table({
                "url": gridRestUrl,
                "orderField": "name",
                "noDataMessage": i18n("ProcessesNotFound"),
                "hidePagination": false,
                "hideExpandCollapse": true,
                "alwaysShowFilters": true,
                "columns": gridLayout,
                "pageOptions": [20, 30, 50],
                "rowsPerPage": 20,
                "alwaysShowFilters": true
            });
            this.own(this.grid);
            this.grid.placeAt(this.templateUsageGrid);
        },

        resourceFormatter: function(item) {
            var self = this.parentWidget;

            var result = domConstruct.create("div");
            var viewLink = self.createViewLink(result, item);
            viewLink.innerHTML = item.name;
            result.appendChild(viewLink);

            return result;
        },

        viewProcess: function(target) {
            var self = this;
            window.top.location = self.tasksUrl + "/viewDashboard?workflowId=" + target.id;
        },

        createViewLink: function(parent, item) {
            var self = this;
            var viewLink = self.linkTemplate.cloneNode(true);
            parent.appendChild(viewLink);
            var viewListener = on(viewLink, "click", function() {
                self.viewProcess(item);
            });
            this.own(viewListener);

            return viewLink;
        }
    });
});
