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
        "js/webext/widgets/Table",
        "js/util/ie/goTo"
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
        Table,
        goTo
) {
    /**
     * A project templates table widget with pagination, sorting, and custom formatting. Uses an actual
     * HTML table for display.
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
     *  tasksUrl / String                   The URL for the WorkflowTemplateTasks class. Required.
     */

    return declare('js.ubuild.widgets.table.WorkflowTemplatesTable', [_Widget, _TemplatedMixin], {
        templateString:
            '<div class="workflowTemplatesTable">'+
                '<div data-dojo-attach-point="workflowTemplatesTableAttachPoint"></div>'+
            '</div>',
        tasksUrl: undefined,

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;

            this.editImageTemplate = domConstruct.create("img", {
                "border": "0",
                "src": bootstrap.imagesUrl + "/icon_pencil_edit.gif",
                "title": i18n("Edit"),
                "alt": i18n("Edit")
            });

            this.usageImageTemplate = domConstruct.create("img", {
                "border": "0",
                "src": bootstrap.imagesUrl + "/icon_magnifyglass.gif",
                "title": i18n("Usage"),
                "alt": i18n("Usage")
            });

            this.copyImageTemplate = domConstruct.create("img", {
                "border": "0",
                "src": bootstrap.imagesUrl + "/icon_copy_project.gif",
                "title": i18n("CopyVerb"),
                "alt": i18n("CopyVerb")
            });

            this.deleteImageTemplate = domConstruct.create("img", {
                "border": "0",
                "src": bootstrap.imagesUrl + "/icon_delete.gif",
                "title": i18n("Delete"),
                "alt": i18n("Delete")
            });

            this.deleteDisabledImageTemplate = domConstruct.create("img", {
                "border": "0",
                "src": bootstrap.imagesUrl + "/icon_delete_disabled.gif",
                "title": i18n("DeleteDisabled"),
                "alt": i18n("DeleteDisabled")
            });

            this.linkTemplate = domConstruct.create("a", { "class": "actions-link" });

            var gridRestUrl = bootstrap.restUrl + "/processTemplates";
            var gridLayout = [{
                    name: i18n("Name"),
                    field: "name",
                    orderField: "name",
                    formatter: this.nameFormatter,
                    style: { width: "20%" },
                    filterField: "name",
                    filterType: "text",
                    parentWidget: this
                },
                {
                    name: i18n("Type"),
                    field: "type",
                    formatter: this.typeFormatter,
                    filterField: "type",
                    filterType: "select",
                    filterOptions: [
                                     {
                                         "label": i18n('Build'),
                                         "value": "BUILD"
                                     },
                                     {
                                         "label": i18n('Secondary'),
                                         "value": "SECONDARY"
                                     }
                                   ],
                    style: { width: "15%" }
                },
                {
                    name: i18n("Description"),
                    field: "description",
                    orderField: "description",
                    filterField: "description",
                    filterType: "text",
                    style: { width: "55%" }
                },
                {
                    name: i18n("Actions"),
                    formatter: this.actionsFormatter,
                    style: { width: "10%" },
                    parentWidget: this
                }];

            this.grid = new Table({
                "url": gridRestUrl,
                "orderField": "name",
                "noDataMessage": i18n("No records found."),
                "hideExpandCollapse": true,
                "hidePagination": false,
                "columns": gridLayout,
                "pageOptions": [25, 50, 100, 250],
                "rowsPerPage": 25,
                "alwaysShowFilters": true
            });
            this.grid.placeAt(this.workflowTemplatesTableAttachPoint);
        },

        /**
         *
         */
        actionsFormatter: function(item) {
            var self = this.parentWidget;
            var result = domConstruct.create("div");

            var editLink = self.createEditLink(result, item);
            var editImage = self.editImageTemplate.cloneNode(true);
            editLink.appendChild(editImage);

            if (item.security.canEdit) {
                var usageLink = self.linkTemplate.cloneNode(true);
                var usageImage = self.usageImageTemplate.cloneNode(true);
                usageLink.appendChild(usageImage);
                result.appendChild(usageLink);

                on(usageLink, "click", function() {
                    self.viewUsage(item);
                });

                var copyLink = self.linkTemplate.cloneNode(true);
                var copyImage = self.copyImageTemplate.cloneNode(true);
                copyLink.appendChild(copyImage);
                result.appendChild(copyLink);

                on(copyLink, "click", function() {
                    self.copyTemplate(item);
                });

                var deleteLink = self.linkTemplate.cloneNode(true);
                var deleteImage;
                if (item.security.canDelete) {
                    deleteImage = self.deleteImageTemplate.cloneNode(true);
                    on(deleteLink, "click", function() {
                        self.confirmDelete(item);
                    });
                }
                else {
                    deleteImage = self.deleteDisabledImageTemplate.cloneNode(true);
                }

                deleteLink.appendChild(deleteImage);
                result.appendChild(deleteLink);
            }

            return result;
        },

        /**
         *
         */
        nameFormatter: function(item) {
            var self = this.parentWidget;
            var result = domConstruct.create("div");
            var viewLink = self.createEditLink(result, item);
            viewLink.innerHTML = entities.encode(item.name);
            result.appendChild(viewLink);
            return result;
        },

        /**
         *
         */
        typeFormatter: function(item) {
            var result = domConstruct.create("div");
            result.innerHTML = entities.encode(i18n(item.type));
            return result;
        },

        /**
         *
         */
        viewTemplate: function(target) {
            var self = this;
            goTo(self.tasksUrl + "/viewWorkflowTemplate?workflowTemplateId=" + target.id);
        },

        viewUsage: function(target) {
            var self = this;
            showPopup(self.tasksUrl + "/usageWorkflowTemplate?workflowTemplateId=" + target.id, 800, 400);
        },

        copyTemplate: function(target) {
            var self = this;
            showPopup(self.tasksUrl + "/copyWorkflowTemplate?workflowTemplateId=" + target.id, 800, 400);
        },

        /**
         *
         */
        createEditLink: function(parent, item) {
            var self = this;
            var viewLink = self.linkTemplate.cloneNode(true);
            viewLink.href = self.tasksUrl + "/viewWorkflowTemplate?workflowTemplateId=" + item.id;
            parent.appendChild(viewLink);
//            on(viewLink, "click", function() {
//                self.viewTemplate(item);
//            });
            return viewLink;
        },

        /**
         *
         */
        confirmDelete: function(target) {
            var self = this;
            var confirm = new GenericConfirm({
                message: i18n("DeleteConfirm", target.name),
                action: function() {
                    self.grid.block();
                    xhr.del({
                        url: bootstrap.restUrl + "/processTemplates/" + target.id,
                        handleAs: "json",
                        load: function(data) {
                            self.grid.unblock();
                            self.grid.refresh();
                        }
                    });
                }
            });
        }
    });
});
