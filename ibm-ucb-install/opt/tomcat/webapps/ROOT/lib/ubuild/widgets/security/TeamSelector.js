/*global define, require */
define([
        "dijit/_TemplatedMixin",
        "dijit/_Widget",
        "dijit/form/Button",
        "dijit/form/Select",
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/on",
        "js/webext/widgets/Alert",
        "js/webext/widgets/RestSelect"
        ],
function(
        _TemplatedMixin,
        _Widget,
        Button,
        Select,
        array,
        declare,
        xhr,
        domClass,
        domConstruct,
        on,
        Alert,
        RestSelect
) {
    /**
     *
     */
    return declare('ubuild.widgets.security.TeamSelector',  [_Widget, _TemplatedMixin], {
        teamsUrl: null,
        resourceRolesUrl: null,

        templateString:
            '<div class="roleSelector">' +
            '  <div data-dojo-attach-point="teamsAttach" class="versionSelectorComponent"></div>' +
            '  <div data-dojo-attach-point="showTeamAttach" class="showTeam inlineBlock"></div>' +
            '  <div data-dojo-attach-point="teamFormAttach" class="teamForm"> ' +
            '    <div data-dojo-attach-point="closeAttach"></div>' +
            '    <div style="display:table;">' +
            '      <div style="display:table-row;">' +
            '        <div data-dojo-attach-point="addTeamLabelAttach" style="display:table-cell; vertical-align:middle;"></div>' +
            '        <div data-dojo-attach-point="teamListAttach" id="teams" class="teamSelector"></div>' +
            '      </div>' +
            '      <div style="display:table-row;">' +
            '        <div data-dojo-attach-point="innerAttach" style="display:table-cell; vertical-align:middle;"></div>' +
            '        <div data-dojo-attach-point="resourceRoleAttach" class="teamSelector"></div>' +
            '      </div>' +
            '    </div>' +
            '    <div data-dojo-attach-point="buttonAttach" style="margin-left: 48px;"> ' +
            '      <div data-dojo-attach-point="addButtonAttach" style="display: inline-block" ></div>' +
            '      <div data-dojo-attach-point="cancelButtonAttach" style="display: inline-block" ></div>' +
            '    </div> ' +
            '  </div> ' +
            '</div>',

        /**
         *
         */
        postCreate: function() {
            var self = this;
            this.hide(this.teamFormAttach);

            if(!self.isReadOnly()) {
                var showTeamButton = new Button({
                    showLabel: false,
                    onClick: function() {
                        //show team form
                        self.show(self.teamFormAttach);
                    },
                    style: "width:18px",
                    className: "showTeamButton"
                });
                showTeamButton.placeAt(this.showTeamAttach);

                var hideTeamButton = new Button({
                    label: i18n("Cancel"),
                    onClick: function() {
                        //hide team form
                        self.hide(self.teamFormAttach);
                    },
                    className: "hideTeamButton"
                });
                domClass.add(hideTeamButton.domNode, "idxButtonCompact");
                hideTeamButton.placeAt(self.cancelButtonAttach);

                var addButton = new Button({
                    label: i18n("Add"),
                    onClick: function(){
                        if (!self.teams[0]) {
                            self.teamsAttach.innerHTML = "";
                        }
                        if (self.teamSelect.value !== "") {
                            self.addTeamWithResourceRole(self.selectedTeamLabel, self.selectedResourceRoleLabel,
                                                        self.selectedTeamId, self.selectedResourceRoleId, false);
                        }
                    }
                });
                domClass.add(addButton.domNode, "idxButtonCompact idxButtonSpecial");
                addButton.placeAt(self.addButtonAttach);

                var teamLabel = domConstruct.create("div", {
                    innerHTML: i18n("TeamWithColon"),
                    style: "margin:10px;"
                });

                var roleLabel = domConstruct.create("div", {
                    innerHTML: i18n("RoleWithColon"),
                    style: "margin:10px;"
                });

                domConstruct.place(teamLabel, this.addTeamLabelAttach);
                domConstruct.place(roleLabel, this.innerAttach);

                var removeTeamFormLink = domConstruct.create("img", {
                    "src": bootstrap.imagesUrl + "/icon_closegray.png",
                    "style": "float:right;",
                    "class": "linkPointer",
                    "onclick": function() {
                        self.hide(self.teamFormAttach);
                    }
                }, this.closeAttach);

                self.addTeamSelect();
                self.addResourceRoleSelect();
            }
            self.displayTeams();
        },

        /**
         * Display the Team Select
         */
        addTeamSelect: function() {
            var self = this;

            self.teamSelect = new RestSelect({
                restUrl: self.teamsUrl,
                getLabel: function (entry) {
                    return entry.name;
                },
                getValue: function (entry) {
                    return entry.id;
                },
                onChange: function (value, entry) {
                    if (value) {
                        self.selectedTeamId = value;
                        self.selectedTeamLabel = entry.name;
                    }
                },
//                isValid: function (entry) {
//                    return entry.teamId !== "20000000000000000000000100000000";
//                },
                allowNone: false
            });
            self.teamSelect.placeAt(self.teamListAttach);
        },

        /**
         * Display the Type Select
         */
        addResourceRoleSelect: function() {
            var self = this;

            self.resourceRoleSelect = new RestSelect({
                restUrl: self.resourceRolesUrl,
                getLabel: function (entry) {
                    return entry.name;
                },
                getValue: function (entry) {
                    return entry.id;
                },
                onChange: function (value, entry) {
                    if (value) {
                        self.selectedResourceRoleId = value;
                        self.selectedResourceRoleLabel = entry.name;
                    }
                    else {
                        self.selectedResourceRoleId = null;
                        self.selectedResourceRoleLabel = null;
                    }
                }
            });
            self.resourceRoleSelect.placeAt(self.resourceRoleAttach);
        },

        /**
         * Add a mapping and display it.
         */
        addTeamWithResourceRole: function(teamLabel, resourceRoleLabel, teamId, resourceRoleId, preloading) {
            var self = this;
            var displayName = teamLabel;
            if (resourceRoleLabel) {
                displayName += i18n("(as %s)", resourceRoleLabel);
            }
            var mappingExists = false;
            if (!preloading) {
                array.forEach(self.teams, function(team) {
                    if (self.matchResourceRoleIds(team.resourceRoleId, self.selectedResourceRoleId)
                            && team.teamId === self.selectedTeamId) {
                        mappingExists = true;
                    }
                });
            }

            if (mappingExists === false) {
                var mappingId = teamId +"|"+ resourceRoleId;
                var mappingBox = domConstruct.create("div", {
//                    "class": "inlineBlock",
                    "id": mappingId,
                    "style": {
//                        "backgroundColor": "#cccccc",
                        "padding": "2px 3px",
                        "border": "1px solid white",
                        "position": "relative",
                        "top": "3px",
                        "marginBottom": "4px"
                    },
                    "innerHTML": displayName.escape()
                });

                if(!self.isReadOnly()) {
                    var removeLink = domConstruct.create("img", {
                        "src": bootstrap.imagesUrl + "/icon_close.png",
                        "style": {
                            "position": "relative",
                            "top": "2px",
                            "left": "4px",
                            "marginRight": "4px"
                        },
                        "class": "linkPointer"
                    }, mappingBox);

                    on(removeLink, "click", function() {
                        self.teams = array.filter(self.teams, function(team) {
                            return (!self.matchResourceRoleIds(team.resourceRoleId, resourceRoleId)
                                    || team.teamId !== teamId);
                        });
                        domConstruct.destroy(mappingId);
                    });
                }

                if (!preloading) {
                    self.teams.push({
                        "resourceRoleId": resourceRoleId,
                        "teamId": teamId
                    });
                }

                domConstruct.place(mappingBox, self.teamsAttach);
            }
            else {
                Alert({
                    message: i18n("TeamSubtypeMappingError")
                });
            }
        },

        /**
         * Display currently added teams
         */
        displayTeams: function() {
            var self = this;
            if (this.teams) {
                array.forEach(self.teams, function(entry) {
                    self.addTeamWithResourceRole(entry.teamLabel,
                                                 entry.resourceRoleLabel,
                                                 entry.teamId,
                                                 entry.resourceRoleId,
                                                 true);
                });
            } else {
                self.teamsAttach.innerHTML = i18n("TeamsNone");
                self.teams = [];
            }
        },

        /**
         * Check if readOnly is set
         */
        isReadOnly : function() {
            var self = this;
            var result = false;

            if (self.readOnly) {
                result = true;
            }

            return result;
        },

        /**
         * Add hidden attribute to a dom node
         */
        hide: function(item) {
            if (item) {
                domClass.add(item, "hidden");
            }
        },

        /**
         * Remove hidden attribute from a dom node
         */
        show: function(item) {
            if (item) {
                domClass.remove(item, "hidden");
            }
        },

        /**
         * Check two resourceRoles for equality
         */
        matchResourceRoleIds: function(id1, id2) {
            var result = false;
            //if both are either null or undefined they are considered equal
            if ((id1 === id2) || (!id1 && !id2)) {
                result = true;
            }
            return result;
        }
    });
});
