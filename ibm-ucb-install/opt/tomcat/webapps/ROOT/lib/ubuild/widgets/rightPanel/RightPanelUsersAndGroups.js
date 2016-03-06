/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global define, require */
define(["dojo/_base/declare",
        "dojo/_base/array",
        "dojo/_base/xhr",
        "ubuild/rightPanel/RightPanel",
        "dojo/dom-class",
        "dojo/dom-style",
        "dojo/dom-construct",
        "dojo/on",
        "dojo/mouse",
        "dojo/query",
        "dijit/form/Button",
        "js/webext/widgets/table/TreeTable"
        ],
        function(
            declare,
            array,
            baseXhr,
            RightPanel,
            domClass,
            domStyle,
            domConstruct,
            on,
            mouse,
            query,
            Button,
            TreeTable
        ){
    /**
     * Right Panel Users And Groups
     * 
     * Widget for displaying a right panel of users and groups on the teams page.
     * 
     * Use: new RightPanelUsersAndGroups(options{});
     * 
     * options: {

     * }
     */
    return declare('ubuild/widgets/rightPanel/RightPanelUsersAndGroups',  [RightPanel], {
        
        postCreate: function() {
            this.inherited(arguments);
            var self = this;
            self.loadPermissions();
            self.setHeader();
            self.loadUserTable();
            self.loadGroupTable();
            self._buildPanel();
            if (self.attachPoint){
                self.placeAt(self.attachPoint);
            }
            self._buildShowButton();
            self.showHelp();
        },
        
        /**
         * Sets the header of the right panel.
         */
        setHeader: function(){
            var self = this;
            self.header = i18n("Users & Groups");
            self.subheader = i18n("Drag and drop users or groups into roles");
        },
        
        /**
         * Sets the permissions for the right panel.
         */
        loadPermissions: function(){
            var self = this;
            self.canModify = self.user.isSecurityAdmin || self.user.isTeamUserManager;
            if (!self.canModify){
                self.subheader = "";
            }
        },

        /**
         * Refreshes the contents of the table.
         */
        refresh: function(){
            var self = this;
            if (self.table){
                self.table.refresh();
            }
        },

        /**
         * Creates a menu button displaying the types of right panels to show.
         */
        _buildShowButton: function(){
            var self = this;
            var showLabel = self.canModify ? i18n("Add Users & Groups") : i18n("Show Users & Groups");
            var hideLabel = i18n("Hide Users & Groups");
            this.showButton = new Button({
                label: self.panelHidden ? showLabel : hideLabel,
                value: self.panelHidden ? true : false
            });
            domClass.add(this.showButton.domNode, "idxButtonCompact");
            on(this.showButton, "click", function(evt){
                if (self.showButton.value){
                    self.showButton.set("label", hideLabel);
                    self.showButton.set("value", false);
                    self.show(evt.shiftKey);
                }
                else {
                    self.showButton.set("label", showLabel);
                    self.showButton.set("value", true);
                    self.hide(evt.shiftKey);
                }
            });
            this.showButton.placeAt(this.buttonAttachPoint);
        },
        
        onHide: function(){
            var self = this;
            if (self.showButton){
                var showLabel = self.canModify ? i18n("Add Users & Groups") : i18n("Show Users & Groups");
                self.showButton.set("value", true);
                self.showButton.set("label", showLabel);
            }
            self.onHideExtra();
        },
        
        /**
         * Additional function to perform after the onHide function.
         */
        onHideExtra: function(){
            //no-op by default
        },
        
        showHelp: function(){
            var self = this;
            
            if (self.user.isSecurityAdmin) {
                var helpContainer = domConstruct.create("div", {
                    className: "dnd-hint-help"
                }, self.subtitleAttach);
                domConstruct.create("div", {
                    innerHTML: i18n("Drag items on handle"),
                    className: "inline-block description-text"
                }, helpContainer);
                domConstruct.create("div", {
                    innerHTML: "::",
                    className: "inline-block dnd-handle-text"
                }, helpContainer);
            }
        },
        
        /**
         * Builds and loads the user table.
         */
        loadUserTable: function(){
            var self = this;
            var gridRestUrl = bootstrap.restUrl + "/user";
            var gridLayout = [{
                name: i18n("User"),
                field: "name",
                orderField: "name",
                filterField: "name",
                filterType: "text",
                getRawValue: function(item) {
                    return item.name;
                }
            },{
                name: i18n("Name"),
                field: "actualName",
                orderField: "actualName",
                filterField: "actualName",
                filterType: "text",
                getRawValue: function(item) {
                    return item.actualName;
                }
            },{
                name: i18n("Email"),
                field: "email",
                orderField: "email",
                filterField: "email",
                filterType: "text",
                getRawValue: function(item) {
                    return item.email;
                },
                formatter: function(item, value, cell) {
                    var result = domConstruct.create("div", {
                        innerHTML: (value ? value : ""),
                        className: "user-email-cell"
                    });
                    return result;
                }
            }];

            this.users = new TreeTable({
                url: gridRestUrl,
                serverSideProcessing: false,
                columns: gridLayout,
                tableConfigKey: "authenticationRealmUserList",
                noDataMessage: i18n("No users have been created yet"),
                rowsPerPage: 10,
                pageOptions: [5, 10, 15, 20, 25, 50, 75, 100],
                draggable: self.canModify,
                selectable: self.canModify,
                hideFooterLinks: true,
                hidePagination: false,
                hideExpandCollapse: true,
                onDisplayTable: function(){
                    domClass.add(this.domNode, "right-panel-users");
                    if (self.canModify) {
                        this.dndContainer.copyOnly = true;
                        this.dndContainer.value = "user";
                        this.dndContainer.checkAcceptance = function() {
                            return false;
                        };
                        this.dndContainer.onDraggingOut = function() {
                            self.showMinimizeBubble();
                        };
                    }
                },
                applyRowStyle: function(item, row) {
                    row.value = item;
                    domClass.add(row, "member-box-" + item.id);
                    on(row, mouse.enter, function() {
                        var relatedBoxes = query(".member-box-" + item.id);
                        array.forEach(relatedBoxes, function(box) {
                            domClass.add(box, "hover");
                        });
                        on(row, mouse.leave, function(){
                            array.forEach(relatedBoxes, function(box) {
                                domClass.remove(box, "hover");
                            });
                        });
                    });
                },
                style: {"margin-top": "18px"}
            });
            domConstruct.place(this.users.domNode, this.contentAttach);
        },

        /**
         * Builds and loads the groups table.
         */
        loadGroupTable: function(){
            var self = this;
            var gridRestUrl = bootstrap.restUrl + "/group";
            var gridLayout = [{
                name: i18n("Group"),
                field: "name",
                orderField: "name",
                filterField: "name",
                filterType: "text",
                getRawValue: function(item) {
                    return item.name;
                }
            },{
                name: i18n("Authorization Realm"),
                formatter: function(item) {
                    return item.authorizationRealm.name;
                }
            }];

            this.groups = new TreeTable({
                url: gridRestUrl,
                serverSideProcessing: false,
                columns: gridLayout,
                tableConfigKey: "groupList",
                noDataMessage: i18n("No groups have been created yet."),
                rowsPerPage: 10,
                pageOptions: [5, 10, 15, 20, 25, 50, 75, 100],
                draggable: self.canModify,
                selectable: self.canModify,
                hideFooterLinks: true,
                hidePagination: false,
                hideExpandCollapse: true,
                onDisplayTable: function() {
                    domClass.add(this.domNode, "right-panel-groups");
                    if (self.canModify) {
                        this.dndContainer.copyOnly = true;
                        this.dndContainer.value = "group";
                        this.dndContainer.checkAcceptance = function() {
                            return false;
                        };
                    }
                },
                applyRowStyle: function(item, row) {
                    row.value = item;
                    domClass.add(row, "member-box-" + item.id);
                    on(row, mouse.enter, function() {
                        var relatedBoxes = query(".member-box-" + item.id);
                        array.forEach(relatedBoxes, function(box) {
                            domClass.add(box, "hover");
                        });
                        on(row, mouse.leave, function() {
                            array.forEach(relatedBoxes, function(box) {
                                domClass.remove(box, "hover");
                            });
                        });
                    });
                },
                style: {"margin-top": "15px"}
            });
            domConstruct.place(this.groups.domNode, this.contentAttach);
        },
        
        showMinimizeBubble: function(){
        }
    });
});
