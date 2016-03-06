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
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/dom-construct",
        "dojo/dom-class",
        "dojo/on",
        "dojo/query",
        "dojo/mouse",
        "dojo/dnd/Source",
        "ubuild/Popup",
        "js/webext/widgets/DialogMultiSelect"
    ],
function(
    _TemplatedMixin,
    _Widget,
    Button,
    array,
    declare,
    xhr,
    domConstruct,
    domClass,
    on,
    query,
    mouse,
    dndSource,
    Popup,
    DialogMultiSelect
) {
    return declare([_Widget, _TemplatedMixin], {

        /**
         * MemberSelector(options)
         *
         * options: {
         *    team: The team of the current user.
         *    role: The role of the current user
         *    header: The name of the role.
         *    parent: The widget using the member selector (EditTeam.js)
         *    parentForm: The form this widget is in (ColumnForm), to auto submit the form on changes.
         *    }
         */
        templateString:
            '<div class="team-member-selector">' +
                '<div class="selector-header-container" data-dojo-attach-point="headerContainerAttach">' +
                    '<div class="selector-header-expand linkPointer inline-block" data-dojo-attach-point="expandAttach"></div>' +
                    '<div class="selector-header inline-block" data-dojo-attach-point="headerAttach"></div>' +
                    '<div class="selector-button inline-block" data-dojo-attach-point="buttonAttach"></div>' +
                '</div>'+
                '<div class="selector-member-container" data-dojo-attach-point="containerAttach">' +
                    '<div class="selector-users" data-dojo-attach-point="usersAttach">' +
                        '<div class="selector-label inline-block" data-dojo-attach-point="userLabelAttach"></div>' +
                    '</div>' +
                    '<div class="selector-groups" data-dojo-attach-point="groupsAttach">' +
                        '<div class="selector-label inline-block" data-dojo-attach-point="groupLabelAttach"></div>' +
                    '</div>' +
                '</div>'+
                '<div class="selector-permission-container" data-dojo-attach-point="permissionAttach">' +
            '</div>',

        rowClass: "labelsAndValues-row team-role-row",

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);

            this._initializeData();
            this.showMembers();
            this._populateHeader();
            this._setUpDnd();
        },

        /**
         * Initializes global variables for this widget.
         */
        _initializeData: function(){
            this.userIds = [];
            this.groupIds = [];
            this.ids = {
                user: {},
                group: {}
            };
            this.usersToRemove = [];
            this.groupsToRemove = [];
            this.boxesToRemove = [];
            this.permissions = {};
            this.userPopups = {};
            this.groupPopups = {};
            this.edit = false;
        },

        /**
         * Builds the header of the team member selector.
         */
        _populateHeader: function(){
            if (this.header){
                this.headerAttach.innerHTML = this.header.escape();
            }

            if (this._canAddToRole()) {
                this._createDialog();
            }
            this.popuplateContainerLabels();
        },

        /**
         * Populate the user and group container labels.
         */
        popuplateContainerLabels: function(){
            this.userLabelAttach.innerHTML = i18n("Users");
            this.groupLabelAttach.innerHTML = i18n("Groups");
        },

        /**
         * Creates the dialog for adding users.
         */
        _createDialog: function(){
            var _this = this;
            this.memberSelect = new DialogMultiSelect({
                noSelectionsLabel: i18n("Add"),
                url: bootstrap.restUrl + "/team/" + _this.team.id + "/roleMappings/" + _this.role.id + "/validMembers",
                getLabel: function(item) {
                    return item.name;
                },
                getValue: function(item) {
                    return item.type+ "#" +item.id;
                }
            });
            _this.memberSelect.fieldAttach.style.padding = "3px 27px";
            // Add behavior to the DialogMultiSelect to style it as a regular button.
            domClass.add(this.memberSelect.domNode, "dijitButton idxButtonCompact member-select-button-compact");
            this.memberSelect.placeAt(_this.buttonAttach);

            on(this.memberSelect.domNode, mouse.enter, function(){
                domClass.add(_this.memberSelect.domNode, "dijitHover dijitButtonHover");
            });
            on(this.memberSelect.domNode, mouse.leave, function(){
                domClass.remove(_this.memberSelect.domNode, "dijitHover dijitButtonHover");
            });

            this.memberSelect.on("close", function() {
                var memberItems = _this.memberSelect.get("items");

                array.forEach(memberItems, function(memberItem) {
                    _this.showMember(memberItem, memberItem.type);
                });
                _this.memberSelect.set("value", "");
                _this.onChange();
            });
        },

        /**
         * Sets up the drag and drop functionality of the team member container.
         */
        _setUpDnd: function(){
            var _this = this;
            this.dnds = new dndSource(this.domNode, {
                onDropExternal: function(source, nodes, copy){
                    var mode = source.value;
                    var save = false;
                    // For each node, add it the corresponding array. If on edit mode, put it in the
                    // temporary array and user has the option to save or cancel the changes.
                    array.forEach(nodes, function(node){
                        var value = node.value;
                        var id = value ? value.id : null;
                        if (mode === "user" && !_this.ids.user[id]){
                            _this.showMember(value, mode);
                            save = true;
                        }
                        else if (mode === "group" && !_this.ids.group[id]){
                            _this.showMember(value, mode);
                            save = true;
                        }
                    });
                    // Save only if there was a mode and no matches (No Duplicates).
                    if (mode && save){
                        _this.onChange();
                    }
                }
            });
        },

        /**
         * Creates all the members to be displayed in the table.
         */
        showMembers: function() {
            var _this = this;
            array.forEach(_this.team.roleMappings, function(mapping) {
                if (mapping.role.id === _this.role.id) {
                    if (mapping.user) {
                        _this.showMember(mapping.user, "user");
                    }
                    else if (mapping.group) {
                        _this.showMember(mapping.group, "group");
                    }
                }
            });
        },

        /**
         * Creates a member block.
         *  @param member: Information of the member
         *  @param type: The type of the member (User or Group)
         */
        showMember: function(member, type) {
            var _this = this;

            var showBox = false;
            if (type === "user") {
                if (this.userIds.indexOf(member.id) === -1) {
                    showBox = true;
                    this.userIds.push(member.id);
                    this.ids.user[member.id] = true;
                }
            }
            else {
                if (this.groupIds.indexOf(member.id) === -1) {
                    showBox = true;
                    this.groupIds.push(member.id);
                    this.ids.group[member.id] = true;
                }
            }

            if (showBox) {
                var displayName = member.name;

                var memberBox = domConstruct.create("div", {
                    "class": "team-member-block inline-block member-box-" + member.id,
                    "innerHTML": displayName.escape()
                });
                on(memberBox, mouse.enter, function(){
                    var relatedBoxes = query(".member-box-" + member.id);
                    array.forEach(relatedBoxes, function(box){
                        domClass.add(box, "hover");
                    });
                    on(memberBox, mouse.leave, function(){
                        array.forEach(relatedBoxes, function(box){
                            domClass.remove(box, "hover");
                        });
                    });
                });

                if (type === "user") {
                    domConstruct.place(memberBox, _this.usersAttach);
                }
                else {
                    // Create group popup on first mouseover
                    if (!_this.groupPopups[member.id]){
                        _this.groupPopups[member.id] = on(memberBox, mouse.enter, function(){
                            _this._createGroupPopup(member.id, memberBox);
                        });
                    }
                    domConstruct.place(memberBox, _this.groupsAttach);
                }

                if (this._memberIsDeletable(member)) {
                    var removeLink = domConstruct.create("div", {
                        className: "inline-block linkPointer remove-team-member icon_delete_red",
                        title: i18n("RemoveItem", displayName.escape())
                    });
                    domConstruct.place(removeLink, memberBox, "first");
                    on(removeLink, "click", function() {
                        if (!_this.edit){
                            domConstruct.destroy(memberBox);
                            if (type === "user") {
                                util.removeFromArray(_this.userIds, member.id);
                            }
                            else {
                                util.removeFromArray(_this.groupIds, member.id);
                            }
                            _this.onChange();
                        }
                        else {
                            domClass.add(memberBox, "hidden");
                            _this.boxesToRemove.push(memberBox);
                            if (type === "user") {
                                _this.usersToRemove.push(member.id);
                            }
                            else {
                                _this.groupsToRemove.push(member.id);
                            }
                        }
                    });
                }
            }
        },

        /**
         * Creates a popup on group blocks to show members within that group
         *  @param groupId: The id of the group
         *  @param: attachPoint: The domNode to attach the popup to.
         */
        _createGroupPopup: function(groupId, attachPoint){
            var _this = this;
            if (this.groupPopups[groupId]){
                xhr.get({
                    url: bootstrap.restUrl + "/group/" + groupId + "/members",
                    handleAs: "json",
                    load: function(data) {
                        var popupContents = domConstruct.create("div");
                        domConstruct.create("div", {
                            className: "group-popup-title",
                            innerHTML: i18n("GroupMembers") + " (" + data.length + ")"
                        }, popupContents);
                        array.forEach(data, function(member){
                            var memberLine = domConstruct.create("div", {
                                className: "group-member-line"
                            }, popupContents);
                            domConstruct.create("div", {
                                className: "team-member-label",
                                innerHTML: member.displayName
                            }, memberLine);
                        });
                        var popup = new Popup({
                            attachPoint: attachPoint,
                            contents: popupContents
                        });
                        popup.externalShow();
                    }
                });
                this.groupPopups[groupId].remove();
            }
        },

        /**
         *
         */
        _getValueAttr: function() {
            var _this = this;

            var result = {
                userIds: _this.userIds,
                groupIds: _this.groupIds
            };

            return result;
        },

        /**
         *
         */
        _canAddToRole: function() {
            var _this = this;
            var canAdd = false;

            if (_this.user.isSecurityAdmin) {
                canAdd = true;
            }
            else if (_this.user.isTeamUserManager) {
                array.forEach(_this.user.teams, function(team) {
                    if (team.id === _this.team.id) {
                        array.forEach(team.roles, function(role) {
                            if (role.id === _this.role.id) {
                                canAdd = true;
                            }
                        });
                    }
                });
            }

            return canAdd;
        },

        /**
         *
         */
        _memberIsDeletable: function(member) {
            var _this = this;
            return (_this.user.isSecurityAdmin || _this.user.isTeamUserManager) &&
                   !(!_this.team.isDeletable && !_this.role.isDeletable && !member.isDeletable) &&
                   (_this.user.name !== member.name);
        },

        /**
         * Function to call when adding or deleting members from the team.
         */
        onChange: function(){
            if (this.parentForm && !this.edit){
                this.parentForm.submitForm();
            }
        }
    });
});
