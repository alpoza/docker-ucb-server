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
    "dojo/dom-class",
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "dijit/form/TextBox",
    "dijit/form/Select",
    "js/webext/widgets/Link"],
    function(declare, array, domClass, Widget, TemplatedMixin, TextBox, Select, Link) {
        return declare("ubuild/widgets/criteria_builder/Rule", [Widget, TemplatedMixin], {
            parent: null,
            json: null,
            ruleTypeOptions: null,
            ruleConditionOptions: null,
            disabled: false,
            
            templateString:
                "<div data-dojo-attach-point='rule'>" +
                    "<div class='buttons' data-dojo-attach-point='ruleControls'></div>" +
                    "<div class='rules inlineBlock' data-dojo-attach-point='ruleInput'>" +
                      "<span class='ruleTypeSelector inlineBlock' data-dojo-attach-point='typeSelector'></span>" +
                      "<span class='propertyNameField inlineBlock' data-dojo-attach-point='propertyNameField'></span>" +
                      "<span class='conditionSelector inlineBlock' data-dojo-attach-point='conditionSelector'></span>" +
                      "<span class='conditionValueField inlineBlock' data-dojo-attach-point='conditionValueField'></span>" +
                    "</div>" +
                "</div>",
                
            postCreate: function() {
                this.inherited(arguments);
                var _this = this;
                _this.init();
            },
            
            init: function() {
                var _this = this;
                _this.initJSON();
                _this.createFields();
                _this.createButtons();
            },
            
            createFields: function() {
                var _this = this;
                
                var propertyNameField = new TextBox({
                    "class": "ruleItem hidden",
                    "value": _this.json.propName
                });
                
                var ruleTypeSelect = new Select({
                    "class": "ruleItem",
                    "name": "typeSelect",
                    "options": _this.ruleTypeOptions,
                    "value": _this.json.type
                });
                
                var ruleConditionSelect = new Select({
                    "class": "ruleItem",
                    "name": "conditionSelect",
                    "options": _this.ruleConditionOptions[ruleTypeSelect.get("value")],
                    "value": _this.json.condition
                });
                
                var conditionValueField = new TextBox({
                    "class": "ruleItem",
                    "value": _this.json.conditionValue
                });
                
                
                propertyNameField.on("change", function(value) {
                    _this.json.propName = value;
                });
                _this.own(propertyNameField);
                
                conditionValueField.on("change", function(value) {
                   _this.json.conditionValue = value; 
                });
                _this.own(conditionValueField);
                
                ruleTypeSelect.on("change", function(value) {
                    var originalValue = ruleConditionSelect.get("value");
                    var options = _this.ruleConditionOptions[value];
                    ruleConditionSelect.set("options", options);
                    var originalValueStillApplies = false;
                    array.forEach(options, function(option) {
                        if (originalValue === option.value) {
                            originalValueStillApplies = true;
                        }
                    });
                    if (!originalValueStillApplies) {
                        ruleConditionSelect.set("value", options[0]);
                    }
                    
                    _this.json.type = value;
                    _this.toggleField(propertyNameField, value !== "PROPERTY");
                });
                _this.own(ruleTypeSelect);
                
                ruleConditionSelect.on("change", function(value) {
                    _this.json.condition = value;
                    _this.toggleField(conditionValueField, value === "EXISTS" || value === "DOES_NOT_EXIST");
                });
                _this.own(ruleConditionSelect);
                
                if (_this.disabled) {
                    ruleTypeSelect.set("disabled", "disabled");
                    ruleConditionSelect.set("disabled", "disabled");
                    conditionValueField.set("disabled", "disabled");
                    propertyNameField.set("disabled", "disabled");
                }
                
                // When loading an existing property rule, the onChange does not fire automatically, so we force it to do so here
                ruleTypeSelect.onChange(_this.json.type);
                ruleConditionSelect.onChange(_this.json.condition);
                
                ruleTypeSelect.placeAt(_this.typeSelector);
                ruleConditionSelect.placeAt(_this.conditionSelector);
                conditionValueField.placeAt(_this.conditionValueField);
                propertyNameField.placeAt(_this.propertyNameField);
            },
            
            createButtons: function() {
                var _this = this;
                var plusButton = new Link({"iconClass": "add_rule_button"});
                var minusButton = new Link({"iconClass": "delete_rule_button"});
                
                plusButton.on("click", function() {
                    _this.parent.addRule({"rule": _this});
                });
                minusButton.on("click", function() {
                    _this.parent.removeRule(_this);
                });
                _this.own(plusButton);
                _this.own(minusButton);
                
                if (!_this.disabled) {
                    plusButton.placeAt(_this.ruleControls);
                    minusButton.placeAt(_this.ruleControls);
                }
            },
            
            toggleField: function(field, hide) {
                domClass.toggle(field.domNode, "hidden", hide);
            },
            
            initJSON: function() {
                var _this = this;
                var defaultType = _this.ruleTypeOptions[0].value;
                var defaultCondition = _this.ruleConditionOptions[defaultType][0].value;
                if (_this.json === null) {
                    _this.json = {
                        "type": defaultType,
                        "propName": null,
                        "condition": defaultCondition,
                        "conditionValue": null
                    };
                }
            }
        });
    }
);