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
        "dojo/dom",
        "dojo/dom-construct",
        "dojo/dom-class",
        "dojo/on",
        "dijit/form/Button",
        "ubuild/security/team/EditTeam",
        "ubuild/security/team/SecuredObjects",
        "js/webext/widgets/GenericConfirm",
        "js/webext/widgets/TwoPaneListManager"

    ],
function(
    array,
    declare,
    xhr,
    dom,
    domConstruct,
    domClass,
    on,
    Button,
    EditTeam,
    SecuredObjects,
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
            this.inherited(arguments);
            this.rightPanel = false;
            this.showList();
            this.removeOverflow();
        },

        /**
         *
         */
        showList: function(selectedId) {
            var _this = this;
            this.defaultSelectionId = selectedId;

            xhr.get({
                url: bootstrap.restUrl + "/team",
                handleAs: "json",
                load: function(data) {
                    var numberOfEntries = 0;
                    array.forEach(data, function(entry) {
                        if (_this.canViewTeam(entry)) {
                            numberOfEntries++;

                            var teamDiv = domConstruct.create("div", {
                                style: {position: "relative"}
                            });

                            var optionsContainer = domConstruct.create("div", {
                                className: "twoPaneActionIcons"
                            }, teamDiv);

                            if (entry.isDeletable && _this.user.isSecurityAdmin) {
                                var deleteLink = domConstruct.create("div", {
                                    className: "inlineBlock vAlignMiddle cursorPointer margin2Left iconMinus"
                                }, optionsContainer);
                                deleteLink.onclick = function (event) {
                                    util.cancelBubble(event);
                                    _this.confirmDelete(entry);
                                };
                            }

                            //need to force the position of the name after the options container for proper display
                            domConstruct.place(domConstruct.create("div", {
                                className: "twoPaneEntryLabel",
                                innerHTML: entry.name.escape()
                            }), optionsContainer, "after");

                            _this.addEntry({
                                id: entry.id,
                                domNode: teamDiv,
                                action: function () {
                                    _this.selectEntry(entry);
                                }
                            });
                        }
                    });
                    if (_this.user.isSecurityAdmin){
                        var newTeamDiv = domConstruct.create("div");

                        domConstruct.create("div", {
                            className: "vAlignMiddle inlineBlock iconPlus"
                        }, newTeamDiv);

                        domConstruct.create("div", {
                            innerHTML: i18n("Create New Team"),
                            className: "vAlignMiddle inlineBlock margin5Left"
                        }, newTeamDiv);

                        _this.addEntry({
                            id: null,
                            domNode: newTeamDiv,
                            action: function() {
                                _this.selectNewTeam();
                                domClass.add(_this.domNode, "create-new-team");
                            }
                        });
                    }

                    if (numberOfEntries === 0){
                        domConstruct.create("div", {
                            className: "containerLabel",
                            innerHTML: i18n("You are currently not in any teams")
                        }, _this.detailAttach);
                    }
                }
            });
        },

        /**
         *
         */
        refresh: function(newId) {
            var selectedId = newId;
            if (this.selectedEntry && this.selectedEntry.id){
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
            var _this = this;

            if (domClass.contains(this.domNode, "create-new-team")){
                domClass.remove(this.domNode, "create-new-team");
            }

            domConstruct.create("div", {
                className: "containerLabel",
                innerHTML: i18n(entry.name).escape(),
                style: {padding: "10px"}
            }, this.detailAttach);

            xhr.get({
                url: bootstrap.restUrl + "/team/" + entry.id,
                handleAs: "json",
                load: function(data) {
                    var editForm = new EditTeam({
                        team: data,
                        user: _this.user,
                        showRightPanel: _this.rightPanel,
                        callback: function(success, rightPanel) {
                            _this.rightPanel = rightPanel;
                            if (success) {
                                _this.refresh();
                            }
                        }
                    });
                    editForm.placeAt(_this.detailAttach);
                    _this.registerDetailWidget(editForm);
                    _this.showTeamObjects(entry);
                }
            });
        },

        /**
         *
         */
        selectNewTeam: function() {
            var _this = this;

            domConstruct.create("div", {
                className: "containerLabel",
                innerHTML: i18n("Create New Team"),
                style: {padding: "10px"}
            }, this.detailAttach);

            var newTeamForm = new EditTeam({
                user: _this.user,
                callback: function(success, newId) {
                    if (success) {
                        _this.refresh(newId);
                    }
                }
            });
            newTeamForm.placeAt(this.detailAttach);
            this.registerDetailWidget(newTeamForm);
        },

        /**
         *
         */
        confirmDelete: function(entry) {
            var _this = this;

            var deleteConfirm = new GenericConfirm({
                message: i18n("Are you sure you want to delete team %s?", i18n(entry.name)),
                action: function() {
                    xhr.del({
                        url: bootstrap.restUrl + "/team/" + entry.id,
                        handleAs: "json",
                        load: function(data) {
                            _this.refresh();
                        }
                    });
                }
            });
        },

        /**
         *
         */
        showTeamObjects: function(entry) {
            var _this = this;
            var headerRule = domConstruct.create("div", {className: "team-object-mapping-divider"});
            this.detailAttach.appendChild(headerRule);
            var header = domConstruct.create("div", {
                innerHTML: i18n("TeamObjectMappings"),
                "class": "containerLabel", style: {"padding": "10px"}
            });
            this.detailAttach.appendChild(header);
            this.securedObjects = new SecuredObjects({
                team: entry.id,
                formatters: self.formatters,
                canEdit: _this.user.isTeamResourcesManager
            });
            this.securedObjects.placeAt(this.detailAttach);
            this.registerDetailWidget(this.securedObjects);
        },

        /**
         * When showing the right panel, it causes pane to overflow and has weird behavior when
         * scrolling. All an overflow-visible class to show entire page instead of overflowing page
         * with scrollbars.
         */
        removeOverflow: function(){
            var contentPane = dom.byId("_webext_content");
            if (contentPane){
                domClass.add(contentPane, "overflow-visible");
            }
        },

        /**
         *
         */
        canViewTeam: function(team) {
            var self = this;
            var canView = false;

            if (self.user.isSecurityAdmin) {
                canView = true;
            }
            else {
                array.forEach(self.user.teams, function(userTeam) {
                    if (userTeam.id === team.id) {
                        canView = true;
                    }
                });
            }

            return canView;
        }
    });
});
