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
        "dijit/form/CheckBox",
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/json",
        "js/webext/widgets/Alert",
        "js/webext/widgets/table/TreeTable",
        "js/webext/widgets/Dialog",
        "ubuild/security/resourceRole/EditResourceRole"
        ],
function(
        _TemplatedMixin,
        _Widget,
        Button,
        CheckBox,
        array,
        declare,
        xhr,
        JSON,
        Alert,
        TreeTable,
        Dialog,
        EditResourceRole
) {
    /**
     *
     */
    return declare("ubuild/widgets/security/role/RoleResourceTypeGrid", [_Widget, _TemplatedMixin], {
        templateString:
            '<div class="roleList">'+
                '<div data-dojo-attach-point="buttonAttach"></div>'+
                '<div data-dojo-attach-point="gridAttach"></div>'+
            '</div>',

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;

            xhr.get({
                url: bootstrap.restUrl + "/role/" + self.role.id + "/actionMappings",
                handleAs: "json",
                load: function(actionMappings) {
                    self.role.actions = actionMappings;

                    xhr.get({
                        url: bootstrap.restUrl + "/resourceType/" + self.resourceType.name + "/actions",
                        handleAs: "json",
                        load: function(actions) {
                            self.showGrid(actions);
                        }
                    });
                }
            });
        },

        /**
         *
         */
        showGrid: function(actions) {
            var self = this;

            var gridRestUrl = bootstrap.restUrl + "/resourceType/" + self.resourceType.name + "/resourceRoles";
            var gridLayout = [{
                name: i18n("Type"),
                style: {"white-space": "nowrap"},
                field: "name",
                orderField: "name",
                getRawValue: function(item) {
                    return item.name;
                }
            }];

            array.forEach(actions, function(action) {
                var displayName = action.name;
                if (action.name.indexOf("View ") === 0) {
                    displayName = i18n("View");
                }
                if (action.name.indexOf("Edit ") === 0) {
                    displayName = i18n("Edit");
                }
                if (action.name.indexOf("Execute ") === 0) {
                    displayName = i18n("Execute");
                }
                if (action.name.indexOf("Create ") === 0) {
                    displayName = i18n("Create");
                }
                gridLayout.push({
                    name: i18n(displayName),
                    style: {"white-space": "nowrap"},
                    formatter: function(item, value, cell) {
                        var hasAction = false;
                        array.forEach(self.role.actions, function(roleAction) {
                            if (roleAction.action.name === action.name) {
                                // If this roleAction mapping matches the given action for this
                                // column, and the roleAction mapping is for the same resource role
                                // as this row (or both are for no resource role), check the box
                                if (!roleAction.resourceRole && !item.id) {
                                    hasAction = true;
                                }
                                else if (roleAction.resourceRole) {
                                    if (roleAction.resourceRole.id === item.id) {
                                        hasAction = true;
                                    }
                                }
                            }
                        });

                        var check = new CheckBox({
                            checked: (hasAction || !self.role.isDeletable),
                            disabled: !self.role.isDeletable,
                            onChange: function(value) {
                                var putData = {
                                        resourceRole: item.id,
                                        action: action.id
                                    };

                                self.grid.block();
                                if (value) {
                                    xhr.post({
                                        url: bootstrap.restUrl + "/role/" + self.role.id + "/actionMappings",
                                        handleAs: "json",
                                        putData: JSON.stringify(putData),
                                        load: function(data) {
                                            self.grid.unblock();
                                        },
                                        error: function(data) {
                                            self.grid.unblock();
                                            var alert = new Alert({
                                                message: data.responseText
                                            });
                                        }
                                    });
                                }
                                else {
                                    xhr.del({
                                        url: bootstrap.restUrl + "/role/" + self.role.id + "/actionMappings",
                                        handleAs: "json",
                                        putData: JSON.stringify(putData),
                                        load: function(data) {
                                            self.grid.unblock();
                                        },
                                        error: function(data) {
                                            self.grid.unblock();
                                            var alert = new Alert({
                                                message: data.responseText
                                            });
                                        }
                                    });
                                }
                            }
                        });
                        return check;
                    }
                });
            });

            self.grid = new TreeTable({
                url: gridRestUrl,
                serverSideProcessing: false,
                columns: gridLayout,
                noDataMessage: i18n("No types have been created yet."),
                hidePagination: false,
                hideExpandCollapse: true
            }, self.gridAttach);
            //self.grid.placeAt(self.gridAttach);

            self.grid.oldShowTable = self.grid.showTable;
            self.grid.showTable = function(data) {
                var name = "Standard " + self.resourceType.name;
                var d = data.slice(0);
                d.splice(0, 0, {
                    name: i18n(name),
                    isStandard: true
                });
                self.grid.oldShowTable(d);
            };
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
        showEditResourceRoleDialog: function(resourceRole) {
            var self = this;

            var resourceRoleDialog = new Dialog({
                title: i18n("Create New Type"),
                closable: true,
                draggable: true
            });

            var resourceRoleForm = new EditResourceRole({
                resourceType: self.resourceType,
                resourceRole: resourceRole,
                callback: function() {
                    resourceRoleDialog.hide();
                    resourceRoleDialog.destroy();
                    self.grid.refresh();
                }
            });
            resourceRoleForm.placeAt(resourceRoleDialog.containerNode);
            resourceRoleDialog.show();
        }
    });
});
