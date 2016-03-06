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
    "dojo/dom-construct",
    "dojo/query",
    "dojo/NodeList-traverse",
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "js/webext/widgets/Link",
    "ubuild/criteria_builder/Rule"],
    function(declare, array, domConstruct, query, nodeListTraverse, Widget, TemplatedMixin, Link, Rule) {
        return declare("ubuild/widgets/criteria_builder/Group", [Widget, TemplatedMixin], {
            parent: null,
            json: null,
            logic: "AND",
            ruleTypeOptions: null,
            ruleConditionOptions: null,
            rules: null,
            disabled: false,
            
            templateString:
                "<div class='group' data-dojo-attach-point='group'>" +
                    "<div class='rule' data-dojo-attach-point='ruleAttach'></div>" +
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
                _this.rules = [];
                _this.initJSON();
                _this.createButtons();
                var ruleList = _this.json.rules;
                array.forEach(ruleList, function(json) {
                    _this.addRule({"json":json});
                });
            },
            
            createButtons: function() {
                var _this = this;
                var removeGroupButton = new Link({
                    "iconClass": "delete_group_button"
                });
                removeGroupButton.on("click", function() {
                    _this.parent.removeGroup(_this);
                });
                _this.own(removeGroupButton);
                
                if (!_this.disabled) {
                    removeGroupButton.placeAt(_this.group);
                }
            },
            
            addRule: function(params) {
                var _this = this;
                var rule = null;
                var json = null;
                
                if (params) {
                    rule = params.rule;
                    json = params.json || null;
                }
                
                var location = !rule ? "last" : "after";
                var parentNode = !rule ? _this.ruleAttach : rule.domNode;
                
                var ruleWidget = new Rule({"json": json, "ruleTypeOptions": _this.ruleTypeOptions,
                    "ruleConditionOptions": _this.ruleConditionOptions, "parent": _this, "disabled": _this.disabled});
                _this.own(ruleWidget);
                domConstruct.place(ruleWidget.domNode, parentNode, location);
                if (array.indexOf(_this.rules, ruleWidget) === -1) {
                    var index = _this.rules.length;
                    if (location === "after") {
                        index = array.indexOf(_this.rules, rule) + 1;
                    }
                    _this.rules.splice(index, 0, ruleWidget);
                }
                
                if (_this.rules.length > 1) {
                    var andDiv = domConstruct.create("div", {"class": "label", "innerHTML": "<p>" + i18n("And").toUpperCase() + "</p>"});
                    domConstruct.place(andDiv, ruleWidget.domNode, "before");
                }
            },
            
            removeRule: function(rule) {
                var _this = this;
                var index = array.indexOf(_this.rules, rule);
                if (index !== -1) {
                    _this.rules.splice(index, 1);
                }
                
                var andDiv = query(rule.domNode).prev();
                if (andDiv.length === 0) {
                    andDiv = query(rule.domNode).next();
                }
                domConstruct.destroy(andDiv[0]);
                
                if (_this.rules.length === 0) {
                    var groupDiv = query(rule.domNode).parent().parent()[0];
                    var orDiv = query(groupDiv).prev();
                    if (orDiv.length === 0) {
                        orDiv = query(groupDiv).next();
                    }
                    domConstruct.destroy(orDiv[0]);
                    domConstruct.destroy(groupDiv);
                }
                
                domConstruct.destroy(rule.domNode);
            },
            
            initJSON: function() {
                var _this = this;
                if (_this.json === null) {
                    _this.json = {
                        "logic": "AND",
                        "groups": [],
                        "rules": []
                    };
                    
                    _this.addRule();
                }
            }
        });
    }
);