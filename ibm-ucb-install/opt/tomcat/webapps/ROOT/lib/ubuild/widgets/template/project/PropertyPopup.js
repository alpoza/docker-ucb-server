/* global define, require */
define(["dijit/_TemplatedMixin",
        "dijit/_Widget",
        "dijit/form/Button",
        "dijit/layout/ContentPane",
        "dijit/Tooltip",
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/dom-construct",
        "js/webext/widgets/ColumnForm",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/RestSelect"
        ],
function (
        _TemplatedMixin,
        _Widget,
        Button,
        ContentPane,
        Tooltip,
        array,
        declare,
        xhr,
        domConstruct,
        ColumnForm,
        Dialog,
        RestSelect
) {
    return declare("ubuild.widgets.template.project.PropertyPopup", [_Widget, _TemplatedMixin], {
        parent: null,
        property: null,
        form: {},
        property: {},
        defaultValue: null,
        displayType: null,
        valueType: null,
        fields: [
            "pluginType",
            "required",
            "defaultAgentPool",
            "defaultValueCheckbox",
            "propertyGroup",
            "allowedValues",
            "defaultValues",
            "defaultValueText",
            "defaultValueTextSecure",
            "defaultValueTextArea",
            "changeExistingValues",
            "allowedValuesScript",
            "sourcePropertyNames",
            "defaultValueScript",
            "agentPool",
            "job"
        ],

        /**
         *
         */
        templateString:
            '<div class=project-template-popup>' +
              '<div data-dojo-attach-point="propertyPopup"></div>' +
            '</div>',

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;

            self.popup = new Dialog({
                title: !!self.property ? self.property.name : i18n("PropertyCreateNew")
            }, self.propertyPopup);

            if (!self.property) {
                self.initalizeNewProperty();
            }
            self.defaultValue = self.property["default-value"];
            self.displayType = self.property["display-type"];
            self.valueType = self.property.valueType;

            self.createForm();
            self.form.placeAt(self.popup.containerNode);
            self.popup.own(self.form);

            self.updateFields();
        },


        /**
         *
         */
        show: function() {
            var self = this;
            self.popup.show();
        },

        /**
         *
         */
        initalizeNewProperty: function() {
            var self = this;

            self.property = {
                "display-type": "Text",
                "valueType": "defined",
                "name": "",
                "description": "",
                "label": ""
            }
            array.forEach(self.fields, function(field) {
                self.property[field] = "";
            });
        },

        /**
         *
         */
        createForm: function() {
            var self = this;

            self.form = new ColumnForm({
                submitUrl: bootstrap.restUrl + "/templates/" + self.templateId + "/properties",
                submitMethod: self.property ? "PUT" : "POST",  // need to double check this
                readOnly: !self.canEdit,
                showButtons: self.canEdit,
                postSubmit: function(data) {
                    self.parent.grid.refresh();
                    self.popup.destroy();
                },
                onCancel: function() {
                    self.popup.destroy();
                },
                validateFields: function(data) {
                    var results = [];

                    array.forEach(self.form.fieldsArray, function(field) {
                        if (field.name == 'name') {
                            if (data[field.name].length > 4000) {
                                results.push(i18n("NameLengthLongError"));
                            }
                        }
                        if (field.name == 'description') {
                            if (data[field.name].length > 256) {
                                results.push(i18n("DescriptionLengthError"));
                            }
                        }
                    });

                    return results;
                },
                addData: function(data) {
//                    data["default-value"] = self.defaultValue;
                    data["display-type"] = self.displayType;
                    array.forEach(self.fields, function(field) {
                        if (!data[field]) {
                            data[field] = "";
                        }
                    });
                }
            });
            self.own(self.form);

            if (!self.isNew) {
                var deleteButton = new Button({
                    label: i18n("Delete"),
                    onClick: function() {
                        xhr.del({
                            url: bootstrap.restUrl + "/templates/" + self.templateId + "/property/" + self.property.name,
                            handleAs: "json",
                            load: function(data) {
                                self.parent.grid.refresh();
                                self.popup.destroy();
                            }
                        });
                    }
                });
                deleteButton.placeAt(self.form.buttonsAttach);
            }

            self.form.addField({
                name: "isNew",
                type: "Invisible",
                value: self.isNew
            });

            if (!!self.property) {
                self.form.addField({
                    name: "oldName",
                    type: "Invisible",
                    value: self.property.name
                });
            }

            self.form.addField({
                name: "name",
                label: i18n("Name"),
                required: true,
                type: "Text",
                value: self.property.name,
                description: i18n("PropertyNameDesc")
            });

            self.form.addField({
                name: "label",
                label: i18n("Label"),
                required: false,
                type: "Text",
                value: self.property.label,
                description: i18n("PropertyLabelDesc")
            });

            self.form.addField({
                name: "description",
                label: i18n("Description"),
                required: false,
                type: "Text Area",
                value: self.property.description,
            });

            self.form.addField({
                name: "displayType",
                label: i18n("PropertyDisplayType"),
                required: true,
                type: "Select",
                allowedValues: [{
                    label: i18n("Agent Pool"),
                    value: "Agent Pool"
                },{
                    label: i18n("Checkbox"),
                    value: "Checkbox"
                },{
                    label: i18n("Integration Plugin"),
                    value: "Integration Plugin"
                },{
                    label: i18n("Multi-Select"),
                    value: "Multi-Select"
                },{
                    label: i18n("Select"),
                    value: "Select"
                },{
                    label: i18n("Text"),
                    value: "Text"
                },{
                    label: i18n("Text (secure)"),
                    value: "Text (secure)"
                },{
                    label: i18n("Text Area"),
                    value: "Text Area"
                }],
                value: self.displayType,
                description: '<span class="bold">' + i18n("Agent Pool") + '</span> - ' + i18n("PropertyAgentPoolTypeDesc") + '<br/>' +
                             '<span class="bold">' + i18n("Checkbox") + '</span> - ' + i18n("PropertyCheckboxDesc") + '<br/>' +
                             '<span class="bold">' + i18n("Integration Plugin") + '</span> - ' + i18n("PropertyIntegrationPluginDesc") + '<br/>' +
                             '<span class="bold">' + i18n("Multi-Select") + '</span> - ' + i18n("PropertyMultiSelectDesc") + '<br/>' +
                             '<span class="bold">' + i18n("Select") + '</span> - ' + i18n("PropertySelectDesc") + '<br/>' +
                             '<span class="bold">' + i18n("Text") + '</span> -' + i18n("PropertyTextDesc") + '<br/>' +
                             '<span class="bold">' + i18n("Text (secure)") + '</span> - ' + i18n("PropertyTextSecureDesc") + '<br/>' +
                             '<span class="bold">' + i18n("Text Area") + '</span> - ' + i18n("PropertyTextAreaDesc"),
                onChange: function(value) {
                    self.updateDisplayType(value);
                }
            });

            self.form.addField({
                name: "_pluginType",
                type: "Invisible"
            });

            self.form.addField({
                name: "valueType",
                label: i18n("Value"),
                type: "Radio",
                allowedValues: [{
                    label: "Defined",
                    value: "defined"
                },{
                    label: "Scripted",
                    value: "scripted"
                },{
                    label: "Job Execution",
                    value: "jobExecution"
                }],
                value: self.property.valueType,
                description: i18n("PropertyDefinedDesc") + '<br/>' +
                             i18n("PropertyScriptedDesc") + '<br/>' +
                             i18n("PropertyJobExecutionDesc"),
                onChange: function(value) {
                    self.updateValueType(value);
                }
            });

            self.form.addField({
                name: "_required",
                type: "Invisible"
            });

            self.form.addField({
                name: "_defaultAgentPool",
                type: "Invisible"
            });

            self.form.addField({
                name: "_defaultValueCheckbox",
                type: "Invisible"
            });

            self.form.addField({
                name: "_propertyGroup",
                type: "Invisible"
            });

            self.form.addField({
                name: "_allowedValues",
                type: "Invisible"
            });

            self.form.addField({
                name: "_defaultValues",
                type: "Invisible"
            });

            self.form.addField({
                name: "_defaultValueText",
                type: "Invisible"
            });

            self.form.addField({
                name: "_defaultValueTextSecure",
                type: "Invisible"
            });

            self.form.addField({
                name: "_defaultValueTextArea",
                type: "Invisible"
            });

            self.form.addField({
                name: "_changeExistingValues",
                type: "Invisible"
            });

            self.form.addField({
                name: "_allowedValuesScript",
                type: "Invisible"
            });

            self.form.addField({
                name: "_sourcePropertyNames",
                type: "Invisible"
            });

            self.form.addField({
                name: "_defaultValueScript",
                type: "Invisible"
            });

            self.form.addField({
                name: "_agentPool",
                type: "Invisible"
            });

            self.form.addField({
                name: "_job",
                type: "Invisible"
            });
        },

        /**
         *
         */
        updateDisplayType: function(type) {
            var self = this;
            if (type == "Agent Pool" || type == "Integration Plugin" || self.displayType == "Text (secure)") {
                self.defaultValue = "";
            }
            self.displayType = type;
            self.updateFields();
        },

        /**
         *
         */
        updateValueType: function(value) {
            var self = this;
            self.valueType = value;
            self.updateFields();
        },

        /**
         *
         */
        updateFields: function() {
            var self = this;

            if (self.valueType == "defined") {
                switch(self.displayType) {
                case "Agent Pool":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    if (!self.form.hasField("defaultAgentPool")) { self.createDefaultAgentPoolField(); }
                    if (!self.isNew && !self.form.hasField("changeExistingValues")) { self.createChangeExistingValuesField(); }
                    self.deleteAllFieldsBut(["required", "defaultAgentPool", "changeExistingValues"]);
                    break;
                case "Checkbox":
                    if (!self.form.hasField("defaultValueCheckbox")) { self.createDefaultValueCheckboxField(); }
                    if (!self.isNew && !self.form.hasField("changeExistingValues")) { self.createChangeExistingValuesField(); }
                    self.deleteAllFieldsBut(["defaultValueCheckbox", "changeExistingValues"]);
                    break;
                case "Integration Plugin":
                    if (!self.form.hasField("pluginType")) { self.createPluginTypeField(); }
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
//                    if (!self.form.hasField("propertyGroup")) { self.createPropertyGroupField(); }
                    self.deleteAllFieldsBut(["pluginType", "required", "propertyGroup"]);
                    break;
                case "Multi-Select":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    if (!self.form.hasField("allowedValues")) { self.createAllowedValuesField(); }
                    if (!self.form.hasField("defaultValues")) { self.createDefaultValuesField(); }
                    if (!self.isNew && !self.form.hasField("changeExistingValues")) { self.createChangeExistingValuesField(); }
                    self.deleteAllFieldsBut(["required", "allowedValues", "defaultValues", "changeExistingValues"]);
                    break;
                case "Select":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    if (!self.form.hasField("allowedValues")) { self.createAllowedValuesField(); }
                    if (!self.form.hasField("defaultValueText")) { self.createDefaultValueTextField(); }
                    if (!self.isNew && !self.form.hasField("changeExistingValues")) { self.createChangeExistingValuesField(); }
                    self.deleteAllFieldsBut(["required", "allowedValues", "defaultValueText", "changeExistingValues"]);
                    break;
                case "Text":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    if (!self.form.hasField("defaultValueText")) { self.createDefaultValueTextField(); }
                    if (!self.isNew && !self.form.hasField("changeExistingValues")) { self.createChangeExistingValuesField(); }
                    self.deleteAllFieldsBut(["required", "defaultValueText", "changeExistingValues"]);
                    break;
                case "Text (secure)":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    if (!self.form.hasField("defaultValueTextSecure")) { self.createDefaultValueTextSecureField(); }
                    if (!self.isNew && !self.form.hasField("changeExistingValues")) { self.createChangeExistingValuesField(); }
                    self.deleteAllFieldsBut(["required", "defaultValueTextSecure", "changeExistingValues"]);
                    break;
                case "Text Area":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    if (!self.form.hasField("defaultValueTextArea")) { self.createDefaultValueTextAreaField(); }
                    if (!self.isNew && !self.form.hasField("changeExistingValues")) { self.createChangeExistingValuesField(); }
                    self.deleteAllFieldsBut(["required", "defaultValueTextArea", "changeExistingValues"]);
                    break;
                }
            }
            else if (self.valueType == "scripted") {
                switch(self.displayType) {
                case "Agent Pool":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
//                    if (self.property && !self.form.hasField("sourcePropertyNames")) { self.createSourcePropertyNamesField                    if (!self.form.hasField("defaultValueScript")) { self.createDefaultValueScriptField(); }
                    self.deleteAllFieldsBut(["required", "sourcePropertyNames", "defaultValueScript"]);
                    break;
                case "Checkbox":
//                    if (self.property && !self.form.hasField("sourcePropertyNames")) { self.createSourcePropertyNamesField(); }
                    if (!self.form.hasField("defaultValueScript")) { self.createDefaultValueScriptField(); }
                    self.deleteAllFieldsBut(["sourcePropertyNames", "defaultValueScript"]);
                    break;
                case "Integration Plugin":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
//                    if (self.property && !self.form.hasField("sourcePropertyNames")) { self.createSourcePropertyNamesField(); }
                    if (!self.form.hasField("defaultValueScript")) { self.createDefaultValueScriptField(); }
                    self.deleteAllFieldsBut(["required", "sourcePropertyNames", "defaultValueScript"]);
                    break;
                case "Multi-Select":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    if (!self.form.hasField("allowedValuesScript")) { self.createAllowedValuesScriptField(); }
//                    if (self.property && !self.form.hasField("sourcePropertyNames")) { self.createSourcePropertyNamesField(); }
                    if (!self.form.hasField("defaultValueScript")) { self.createDefaultValueScriptField(); }
                    self.deleteAllFieldsBut(["required", "allowedValuesScript", "sourcePropertyNames", "defaultValueScript"]);
                    break;
                case "Select":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    if (!self.form.hasField("allowedValuesScript")) { self.createAllowedValuesScriptField(); }
//                    if (self.property && !self.form.hasField("sourcePropertyNames")) { self.createSourcePropertyNamesField(); }
                    if (!self.form.hasField("defaultValueScript")) { self.createDefaultValueScriptField(); }
                    self.deleteAllFieldsBut(["required", "allowedValuesScript", "sourcePropertyNames", "defaultValueScript"]);
                    break;
                case "Text":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
//                    if (self.property && !self.form.hasField("sourcePropertyNames")) { self.createSourcePropertyNamesField(); }
                    if (!self.form.hasField("defaultValueScript")) { self.createDefaultValueScriptField(); }
                    self.deleteAllFieldsBut(["required", "sourcePropertyNames", "defaultValueScript"]);
                    break;
                case "Text (secure)":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
//                    if (self.property && !self.form.hasField("sourcePropertyNames")) { self.createSourcePropertyNamesField(); }
                    if (!self.form.hasField("defaultValueScript")) { self.createDefaultValueScriptField(); }
                    self.deleteAllFieldsBut(["required", "sourcePropertyNames", "defaultValueScript"]);
                    break;
                case "Text Area":
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
//                    if (self.property && !self.form.hasField("sourcePropertyNames")) { self.createSourcePropertyNamesField(); }
                    if (!self.form.hasField("defaultValueScript")) { self.createDefaultValueScriptField(); }
                    self.deleteAllFieldsBut(["required", "sourcePropertyNames", "defaultValueScript"]);
                    break;
                }
            }
            else if (self.valueType == "jobExecution") {
                if (!self.form.hasField("agentPool")) { self.createAgentPoolField(); }
                if (!self.form.hasField("job")) { self.createJobField(); }

                if (self.displayType !== "Checkbox") {
                    if (!self.form.hasField("required")) { self.createValueRequiredField(); }
                    self.deleteAllFieldsBut(["required", "agentPool", "job"]);
                }
                else {
                    self.deleteAllFieldsBut(["agentPool", "job"]);
                }
            }
        },

        deleteAllFieldsBut: function(keepers) {
            var self = this;

            array.forEach(self.fields, function(field) {
                if (array.indexOf(keepers, field) === -1) {
                    if (self.form.hasField(field)) {
                        self.form.removeField(field);
                    }
                }
            });
        },


        // Below are the just methods for creating the different fields ///////////////////////////////////////////////
        /**
         *
         */
        createPluginTypeField: function() {
            var self = this;

            self.pluginTypeSelect = new RestSelect({
                restUrl: bootstrap.restUrl + "/plugins",
                value: self.property.pluginType,
                isValid: function(item) {
                    return (item.type == "AutomationPlugin" && item.propSheetDefs.length > 0);
                },
                getLabel: function(item) {
                    return item.name;
                },
                getValue: function(item) {
                    return item.id;
                },
                allowNone: false,
                noIllegalValues: true,
                onChange: function(value) {
                    if (self.form.hasField("propertyGroup")) {
                        self.form.removeField("propertyGroup");
                    }
                    self.createPropertyGroupField(value);
                }
            });

            self.form.addField({
                name: "pluginType",
                label: i18n("PluginType"),
                required: true,
                widget: self.pluginTypeSelect,
                description: i18n("PropertyPluginTypeDesc"),
            }, "_pluginType", "before");
        },

        /**
         *
         */
        createPropertyGroupField: function(pluginTypeId) {
            var self = this;

            var propertyGroupSelect = new RestSelect({
                restUrl: bootstrap.restUrl + "/plugins/" + pluginTypeId + "/integrations",
                value: self.defaultValue,
                getLabel: function(item) {
                    return item.propSheetName;
                },
                getValue: function(item) {
                    return item.propSheetId;
                },
                allowNone: true,
                noIllegalValues: true
            });

            var pgroup = self.form.addField({
                name: "propertyGroup",
                label: self.pluginTypeSelect._getDisplayedValueAttr(),
                required: false,
                widget: propertyGroupSelect,
                description: i18n("PropertyPropertyGroupDesc")
            }, "_propertyGroup", "before");
        },

        /**
         *
         */
        createValueRequiredField: function() {
            var self = this;
            self.form.addField({
                name: "required",
                label: i18n("PropertyValueRequired"),
                type: "Checkbox",
                value: self.property.required,
                description: i18n("PropertyValueRequiredDesc")
            }, "_required", "before");
        },

        /**
         *
         */
        createDefaultAgentPoolField: function() {
            var self = this;

            var agentPoolSelect = new RestSelect({
                restUrl: bootstrap.restUrl + "/agentPools",
                value: self.defaultValue,  // may lead to some confusion when switching from another display type
                getLabel: function(item) {
                    return item.name;
                },
                getValue: function(item) {
                    return item.id;
                },
                allowNone: true,
                noIllegalValues: true
            });

            self.form.addField({
                name: "defaultAgentPool",
                label: i18n("AgentPool"),
                widget: agentPoolSelect,
                description: i18n("PropertyAgentPoolDefaultDesc")
            }, "_defaultAgentPool", "before");
        },

        /**
         *
         */
        createDefaultValueCheckboxField: function() {
            var self = this;
            self.form.addField({
                name: "defaultValueCheckbox",
                label: i18n("DefaultValue"),
                type: "Checkbox",
                value: self.defaultValue,
                description: i18n("PropertyDefaultValueDesc")
            }, "_defaultValueCheckbox", "before");
        },

        /**
         *
         */
        createAllowedValuesField: function() {
            var self = this;
            self.form.addField({
                name: "allowedValues",
                label: i18n("AllowedValues"),
                required: true,
                type: "Text Area",
                value: self.property["allowed-values"],
                description: i18n("PropertyAllowedValuesDesc")
            }, "_allowedValues", "before");
        },

        /**
         *
         */
        createDefaultValuesField: function() {
            var self = this;
            self.form.addField({
                name: "defaultValues",
                label: i18n("DefaultValues"),
                type: "Text",
                value: self.defaultValue,
                description: i18n("PropertyDefaultValueDescMulti")
            }, "_defaultValues", "before");
        },

        /**
         *
         */
        createDefaultValueTextField: function() {
            var self = this;
            self.form.addField({
                name: "defaultValueText",
                label: i18n("DefaultValue"),
                type: "Text",
                value: self.defaultValue,
                description: i18n("PropertyDefaultValueDesc")
            }, "_defaultValueText", "before");
        },

        /**
         *
         */
        createDefaultValueTextSecureField: function() {
            var self = this;
            self.form.addField({
              name: "defaultValueTextSecure",
              label: i18n("DefaultValue"),
              type: "Secure",
              value: self.defaultValue,
              description: i18n("PropertyDefaultValueDesc")
          }, "_defaultValueTextSecure", "before");
        },

        /**
         *
         */
        createDefaultValueTextAreaField: function() {
            var self = this;
            self.form.addField({
                name: "defaultValueTextArea",
                label: i18n("DefaultValue"),
                type: "Text Area",
                value: self.defaultValue,
                description: i18n("PropertyDefaultValueDesc")
            }, "_defaultValueTextArea", "before");
        },

        /**
         *
         */
        createChangeExistingValuesField: function() {
            var self = this;
            self.form.addField({
                name: "changeExistingValues",
                label: i18n("PropertyChangeExistingValues"),
                type: "Checkbox",
                value: false,
                description: i18n("PropertyChangeExistingValuesDesc")
            }, "_changeExistingValues", "last");
        },

        /**
         *
         */
        createAllowedValuesScriptField: function() {
            var self = this;
            self.form.addField({
                name: "allowedValuesScript",
                label: i18n("PropertyAllowedValuesScript"),
                type: "Text Area",
                required: true,
                value: self.property["allowed-values"],
                description: i18n("PropertyAllowedValuesScriptDesc")
            }, "_allowedValuesScript", "before");
        },

        /**
         *
         */
        createSourcePropertyNamesField: function() {
            var self = this;
            self.form.addField({
                name: "sourcePropertyNames",
                label: i18n("PropertySourcePropertyNames"),
                type: "Text Area",
                value: "",
                description: i18n("PropertySourcePropertyNamesDesc")
            }, "_sourcePropertyNames", "before");
        },

        /**
         *
         */
        createDefaultValueScriptField: function() {
            var self = this;
            self.form.addField({
                name: "defaultValueScript",
                label: i18n("PropertyDefaultValueScript"),
                type: "Text Area",
                value: self.defaultValue,
                description: i18n("PropertyBeanshellScriptDesc1") + "<br/>&nbsp;&nbsp;&nbsp;&nbsp;" +
                             i18n("PropertyBeanshellScriptDesc2") + "<br/>&nbsp;&nbsp;&nbsp;&nbsp;" +
                             i18n("PropertyBeanshellScriptDesc3") + "<br/>&nbsp;&nbsp;&nbsp;&nbsp;" +
                             i18n("PropertyBeanshellScriptDesc4") + "<br/>&nbsp;&nbsp;&nbsp;&nbsp;" +
                             i18n("PropertyBeanshellScriptDesc5") + "<br/>&nbsp;&nbsp;&nbsp;&nbsp;" +
                             i18n("PropertyBeanshellScriptDesc6")
            }, "_defaultValueScript", "before");
        },

        /**
         *
         */
        createAgentPoolField: function() {
            var self = this;

            var agentPoolSelect2 = new RestSelect({
                restUrl: bootstrap.restUrl + "/agentPools",
                value: self.property.agentPool,
                getLabel: function(item) {
                    return item.name;
                },
                getValue: function(item) {
                    return item.id;
                },
                allowNone: false,
                noIllegalValues: true
            });
            self.form.addField({
                name: "agentPool",
                label: i18n("AgentPool"),
                required: true,
                widget: agentPoolSelect2,
                description: i18n("PropertyAgentPoolDesc")
            }, "_agentPool", "before");
        },

        /**
         *
         */
        createJobField: function() {
            var self = this;

            var jobSelect = new RestSelect({
                restUrl: bootstrap.restUrl + "/jobs",
                value: self.property.job,
                getLabel: function(item) {
                    return item.name;
                },
                getValue: function(item) {
                    return item.id;
                },
                allowNone: false,
                noIllegalValues: true
            })
            self.form.addField({
                name: "job",
                label: i18n("Job"),
                required: true,
                widget: jobSelect,
                description: i18n("PropertyWorkflowJobDesc")
            }, "_job", "before");
        }

    });
});
