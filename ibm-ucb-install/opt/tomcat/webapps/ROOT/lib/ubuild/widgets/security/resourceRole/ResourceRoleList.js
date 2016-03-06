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
        "dojo/dom-construct",
        "dojo/on",
        "js/webext/widgets/Alert",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/GenericConfirm",
        "js/webext/widgets/table/TreeTable",
        "ubuild/security/resourceRole/EditResourceRole"
        ],
function(
        _TemplatedMixin,
        _Widget,
        Button,
        declare,
        xhr,
        domConstruct,
        on,
        Alert,
        Dialog,
        GenericConfirm,
        TreeTable,
        EditResourceRole
) {
    /**
     *
     */
    return declare('ubuild.widgets.security.resourceRole.ResourceRoleList',  [_Widget, _TemplatedMixin], {
        grid: null,


        templateString:
            '<div class="resourceRoleList">'+
                '<div data-dojo-attach-point="buttonAttach"></div>'+
                '<div data-dojo-attach-point="gridAttach"></div>'+
            '</div>',

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;

            var gridRestUrl = bootstrap.restUrl + "/resourceType/" + self.resourceType.name + "/resourceRoles";
            var gridLayout = [{
                name: i18n("Type"),
                field: "name",
                orderField: "name",
                filterField: "name",
                filterType: "text",
                getRawValue: function(item) {
                    return item.name;
                }
            },{
                name: i18n("Description"),
                field: "description",
                orderField: "description",
                filterField: "description",
                filterType: "text",
                getRawValue: function(item) {
                    return item.description;
                }
            },{
                name: i18n("Actions"),
                formatter: this.actionsFormatter,
                parentWidget: this
            }];

            self.grid = new TreeTable({
                showTable: function(data) {
                    var name = "Standard " + self.resourceType.name;
                    var d = data.slice(0);
                    d.splice(0, 0, {
                        name: i18n(name),
                        isStandard: true
                    });
                    this.inherited("showTable", arguments, [d]);
                },
                url: gridRestUrl,
                serverSideProcessing: false,
                columns: gridLayout,
                tableConfigKey: "resourceRoleList",
                hidePagination: false,
                hideExpandCollapse: true
            }, self.gridAttach);

            var newResourceRoleButton = new Button({
                label: i18n("Create New Type"),
                showTitle: false,
                onClick: function() {
                    self.showEditResourceRoleDialog();
                },
                style: {"padding-bottom": "10px"}
            }, self.buttonAttach);
        },

        /**
         *
         */
        destroy: function() {
            this.inherited(arguments);
            if (this.grid) {
                this.grid.destroy();
            }
        },

        /**
         *
         */
        actionsFormatter: function(item) {
            var self = this.parentWidget;
            var result = document.createElement("div");

            if (!item.isStandard) {
                var editLink = domConstruct.create("a", {
                    innerHTML: i18n("Edit"),
                    'class': "actionsLink linkPointer",
                    onclick: function() {
                       self.showEditResourceRoleDialog(item);
                    }
                }, result);
                var deleteLink = domConstruct.create("a", {
                    innerHTML: i18n("Delete"),
                    'class': "actionsLink linkPointer",
                    onclick: function() {
                        self.confirmDeletion(item);
                    }
                }, result);
            }
            return result;
        },

        /**
         *
         */
        confirmDeletion: function(item) {
            var self = this;

            var confirm = new GenericConfirm({
                message: i18n("Are you sure you want to delete type '%s'?", item.name),
                action: function() {
                    xhr.del({
                        url: bootstrap.restUrl + "/resourceRole/" + item.id,
                        load: function() {
                            self.grid.refresh();
                        },
                        error: function(data) {
                            var deleteError = new Alert({
                                message: data.responseText
                            });
                        }
                    });
                }
            });
        },

        /**
         *
         */
        showEditResourceRoleDialog: function(item) {
            var self = this;

            var newResourceRoleDialog = new Dialog({
                title: i18n("Create New Type"),
                closable: true,
                draggable: true
            });

            var newResourceRoleForm = new EditResourceRole({
                resourceRole: item,
                resourceType: self.resourceType,
                callback: function() {
                    newResourceRoleDialog.hide();
                    newResourceRoleDialog.destroy();
                    self.grid.refresh();
                }
            });
            newResourceRoleForm.placeAt(newResourceRoleDialog.containerNode);
            newResourceRoleDialog.show();
        }
    });
});
