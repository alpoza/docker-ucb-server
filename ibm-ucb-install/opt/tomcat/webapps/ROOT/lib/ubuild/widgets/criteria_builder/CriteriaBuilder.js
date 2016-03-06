/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global define*/
define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "dojo/_base/fx",
    "dojo/dom-construct",
    "dojo/request/xhr",
    "dojo/query",
    "dojo/NodeList-traverse",
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "dijit/form/Button",
    "ubuild/criteria_builder/Group"],
    function(declare, array, fx, domConstruct, xhr, query, nodeListTraverse, Widget, TemplatedMixin, Button, Group) {
        return declare("ubuild/widgets/criteria_builder/Master", [Widget, TemplatedMixin], {
            json: null,
            logic: "OR",
            postUrl: null,
            ruleTypeOptions: null,
            ruleConditionOptions: null,
            groups: null,
            disabled: false,
            
            templateString:
                "<div class='criteria-builder claro'>" +
                    "<div data-dojo-attach-point='statusMessageAttach'></div>" +
                    "<div data-dojo-attach-point='masterGroup'>" +
                        "<div class='groups' data-dojo-attach-point='groupAttach'></div>" +
                        "<div class='submit_buttons' data-dojo-attach-point='groupControls'></div>" +
                    "</div>" +
                "</div>",
                
            postCreate: function() {
                this.inherited(arguments);
                var _this = this;
                _this.init();
            },
            
            update: function() {
                
            },
            
            init: function() {
                var _this = this;
                _this.groups = [];
                _this.initJSON();
                var groupList = _this.json.group.groups;
                array.forEach(groupList, function(json) {
                    _this.addGroup({"json":json});
                });
                
                _this.createButtons();
            },
            
            createButtons: function() {
                var _this = this;
                var addGroup = new Button({"label": i18n("AddOr")});
                var save = new Button({"label": i18n("Save")});
                
                addGroup.on("click", function() {
                    _this.addGroup();
                });
                save.on("click", function() {
                    _this.save();
                });
                _this.own(addGroup);
                _this.own(save);
                
                if (!_this.disabled) {
                    addGroup.placeAt(_this.groupControls);
                    save.placeAt(_this.groupControls);
                }
            },
            
            addGroup: function(params) {
                var _this = this;
                var json = null;
                if (params) {
                    json = params.json;
                }
                
                var groupWidget = new Group({"json": json, "ruleTypeOptions" :_this.ruleTypeOptions,
                    "ruleConditionOptions": _this.ruleConditionOptions, "parent": _this, "disabled": _this.disabled});
                _this.own(groupWidget);
                domConstruct.place(groupWidget.domNode, _this.groupAttach);
                if (array.indexOf(_this.groups, groupWidget) === -1) {
                    _this.groups.push(groupWidget);
                }
                
                if (_this.groups.length > 1) {
                    var orDiv = domConstruct.create("div", {"class": "label", "innerHTML": "<p>" + i18n("Or").toUpperCase() + "</p>"});
                    domConstruct.place(orDiv, groupWidget.domNode, "before");
                }
            },
            
            removeGroup: function(group) {
                var _this = this;
                var index = array.indexOf(_this.groups, group);
                if (index !== -1) {
                    _this.groups.splice(index, 1);
                }
                
                var orDiv = query(group.domNode).prev();
                if (orDiv.length === 0) {
                    orDiv = query(group.domNode).next();
                }
                domConstruct.destroy(orDiv[0]);
                domConstruct.destroy(group.domNode);
            },
            
            initJSON: function() {
                var _this = this;
                if (_this.json === null) {
                    _this.json = {
                        "group": [{
                            "logic": "OR",
                            "groups": [],
                            "rules": []
                        }]
                    };
                }
                
                if (_this.json.group.groups.length === 0) {
                    _this.addGroup();
                }
            },
            
            save: function() {
                var _this = this;
                var groupsJSON = [];
                var rulesJSON = [];
                
                dojo.forEach(_this.groups, function(group) {
                    dojo.forEach(group.rules, function(rule) {
                        rulesJSON.push(rule.json);
                    });
                    
                    if (rulesJSON.length > 0) {
                        group.json.rules = rulesJSON;
                        groupsJSON.push(group.json);
                        rulesJSON = [];
                    }
                });
                
                _this.json.group.groups = groupsJSON;
                
                var jsonString = dojo.toJson(_this.json);
                _this.updateServerObjects(jsonString);
            },
            
            updateServerObjects: function(json) {
                var _this = this;
                
                var success = function(data) {
                    window.location.reload();
//                    var statusDiv = domConstruct.create("div", {"class": "statusMessage", "innerHTML": "Agent pool saved successfully."});
//                    domConstruct.place(statusDiv, _this.statusMessageAttach);
//                    dojo.fadeOut({
//                        "duration": 3000,
//                        "node": statusDiv,
//                        "onEnd": dojo.destroy
//                    }).play();
                };
                
                var error = function(data) {
                    var statusDiv = domConstruct.create("div", {"class": "error", "innerHTML": data.response.text});
                    domConstruct.place(statusDiv, _this.statusMessageAttach);
                    dojo.fadeOut({
                      "delay": 3000,
                      "duration": 2000,
                      "node": statusDiv,
                      "onEnd": dojo.destroy
                  }).play();
                };
                
                xhr(_this.postUrl, {
                    method: "PUT",
                    headers: { "Content-Type": "application/json" },
                    handleAs: "text/html",
                    data: json
                }).then(success, error);
            }
        });
    }
);