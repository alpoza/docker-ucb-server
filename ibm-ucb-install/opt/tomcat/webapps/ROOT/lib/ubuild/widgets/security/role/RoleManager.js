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
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "ubuild/security/role/EditRole",
        "ubuild/security/role/RoleResourceTypeManager",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/GenericConfirm",
        "js/webext/widgets/TwoPaneListManager"
        ],
function(
        array,
        declare,
        xhr,
        EditRole,
        RoleResourceTypeManager,
        Dialog,
        GenericConfirm,
        TwoPaneListManager
) {
    /**
     *
     */
    return declare([TwoPaneListManager], {
        /**
         *
         */
        postCreate: function() {
            this.overrideListWidth = "190px";
            this.inherited(arguments);
            var self = this;

            self.showList("NONE");
        },

        /**
         *
         */
        showList: function(selectedId) {
            var self = this;
            self.defaultSelectionId = selectedId;

            xhr.get({
                url: bootstrap.restUrl + "/role",
                handleAs: "json",
                load: function(data) {
                    var totalEntries = data.length;
                    var ctr = 0;

                    array.forEach(data, function(entry) {
                        ctr++;

                        if (ctr === 1) {
                            self.defaultSelectionId = entry.id;
                        }

                        var roleDiv = document.createElement("div");
                        roleDiv.style.position = "relative";

                        var optionsContainer = document.createElement("div");
                        optionsContainer.className = "twoPaneActionIcons";
                        roleDiv.appendChild(optionsContainer);

                        var roleDivLabel = document.createElement("div");
                        roleDivLabel.className = "twoPaneEntryLabel";
                        roleDivLabel.innerHTML = entry.name.escape();
                        roleDiv.appendChild(roleDivLabel);

                        var editLink = document.createElement("div");
                        editLink.className = "inlineBlock vAlignMiddle cursorPointer margin2Left iconPencil";
                        editLink.onclick = function(event) {
                            util.cancelBubble(event);
                            self.showEditRole(entry);
                        };
                        optionsContainer.appendChild(editLink);

                        if (entry.isDeletable) {
                            var deleteLink = document.createElement("div");
                            deleteLink.className = "inlineBlock vAlignMiddle cursorPointer margin2Left iconMinus";
                            deleteLink.onclick = function(event) {
                                util.cancelBubble(event);
                                self.confirmDelete(entry);
                            };
                            optionsContainer.appendChild(deleteLink);
                        }

                        self.addEntry({
                            id: entry.id,
                            domNode: roleDiv,
                            action: function() {
                                self.selectEntry(entry);
                            }
                        });
                    });

                    var newRoleDiv = document.createElement("div");
                    var newRoleIcon = document.createElement("div");
                    newRoleIcon.className = "vAlignMiddle inlineBlock iconPlus";
                    newRoleDiv.appendChild(newRoleIcon);

                    var newRoleLabel = document.createElement("div");
                    newRoleLabel.innerHTML = i18n("Create New Role");
                    newRoleLabel.className = "vAlignMiddle inlineBlock margin5Left";
                    newRoleDiv.appendChild(newRoleLabel);


                    self.addEntry({
                        id: null,
                        domNode: newRoleDiv,
                        action: function() {
                            self.showEditRole();
                        }
                    });
                }
            });
        },

        /**
         *
         */
        refresh: function(newId) {
            var selectedId = newId;
            if (!newId && this.selectedEntry) {
                selectedId = this.selectedEntry.id;
            }

            this.clearDetail();
            this.clearList();
            this.showList(selectedId);
        },

        /**
         * Clear out the detail pane and put this component's information there.
         */
        selectEntry: function(entry) {
            var self = this;

            var typeManager = new RoleResourceTypeManager({
                role: entry,
                overrideListWidth: "165px"
            });
            typeManager.placeAt(this.detailAttach);
            this.registerDetailWidget(typeManager);
        },

        /**
         *
         */
        showEditRole: function(role) {
            var self = this;

            var roleDialog = new Dialog({
                title: !!role ? i18n("Edit Role") : i18n("Create New User Role"),
                closable: true,
                draggable: true
            });

            var roleForm = new EditRole({
                role: role,
                callback: function(success, newId) {
                    if (success) {
                        roleDialog.hide();
                        roleDialog.destroy();
                        self.refresh(newId);
                    }
                }
            });

            roleForm.placeAt(roleDialog.containerNode);
            roleDialog.show();

            if (!role) {
                this.clearSelection();
            }
        },

        /**
         *
         */
        confirmDelete: function(entry) {
            var self = this;

            var deleteConfirm = new GenericConfirm({
                message: i18n("Are you sure you want to delete role %s?", entry.name),
                action: function() {
                    xhr.del({
                        url: bootstrap.restUrl + "/role/" + entry.id,
                        handleAs: "json",
                        load: function(data) {
                            self.refresh();
                        }
                    });
                }
            });
        },

        /**
         *
         */
        selectDefault: function() {
            var self = this;
            self.refresh(self.defaultSelectionId);
        }

    });
});
