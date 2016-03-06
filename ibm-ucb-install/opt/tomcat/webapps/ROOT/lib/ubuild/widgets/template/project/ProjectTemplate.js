/*global define, require */
define([
        "dijit/_TemplatedMixin",
        "dijit/_Widget",
        "dijit/_WidgetsInTemplateMixin",
        "dijit/form/RadioButton",
        "dijit/form/Textarea",
        "dijit/form/TextBox",
        "dijit/layout/ContentPane",
        "dijit/TitlePane",
        "dijit/Tooltip",
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/dnd/Target",
        "dojo/dom-attr",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/dom-geometry",
        "dojo/dom-style",
        "dojo/json",
        "dojo/mouse",
        "dojo/on",
        "dojo/query",
        "js/webext/widgets/ColumnForm",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/Link",
        "js/webext/widgets/RestSelect",
        "js/webext/widgets/table/TreeTable",
        "ubuild/table/ProjectTemplateUsageTable",
        "ubuild/template/project/PropertyPopup"
        ],
function(
        _TemplatedMixin,
        _Widget,
        _WidgetsInTemplateMixin,
        RadioButton,
        TextArea,
        TextBox,
        ContentPane,
        TitlePane,
        Tooltip,
        array,
        declare,
        xhr,
        dndTarget,
        domAttr,
        domClass,
        domConstruct,
        domGeo,
        domStyle,
        JSON,
        mouse,
        on,
        query,
        ColumnForm,
        Dialog,
        Link,
        RestSelect,
        TreeTable,
        TemplateUsageTable,
        PropertyPopup
) {
    return declare("ubuild.widgets.template.ProjectTemplate", [_Widget, _TemplatedMixin, _WidgetsInTemplateMixin], {
        isNew: null,
        nameDescriptionAttach: null,
        formAttach: null,
        fieldsAttach: null,
        propertyHeaderAttach: null,
        propertyGridAttach: null,

        templateString:
            '<div class="edit-projectTemplate">' +
              '<div data-dojo-attach-point="headerAttach"></div>' +
              '<div data-dojo-attach-point="accordionAttach"></div>' +
            '</div>',

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;

            self.nameDescriptionAttach = domConstruct.create("div");
            self.fieldsAttach = domConstruct.create("div");
            self.formAttach = domConstruct.create("div", {}, self.fieldsAttach);
            self.propertyHeaderAttach = domConstruct.create("div");
            self.propertyGridAttach = domConstruct.create("div", {}, self.propertyHeaderAttach);

            self.showForm();

            var contentPane1 = new TitlePane({
                title: i18n("Main"),
                content: self.nameDescriptionAttach,
                open: false
            });
            var contentPane2 = new TitlePane({
                title: i18n("BuildPreProcessing"),
                content: self.fieldsAttach,
                open: self.isNew
            });
            var contentPane3 = new TitlePane({
                title: i18n("Properties"),
                content: self.propertyHeaderAttach,
                open: true
            });

            contentPane1.placeAt(self.accordionAttach);
            contentPane2.placeAt(self.accordionAttach);
            contentPane3.placeAt(self.accordionAttach);

//            setTimeout(function() {
                contentPane1.startup();
                contentPane2.startup();
                contentPane3.startup();
//            }, 0);

            if (self.isNew) {
                self.setEditMode();
            }
        },

        /**
         * Builds the form for the template.
         */
        showForm: function() {
            var self = this;

            if (self.template) {
                self.createHeader();
                self.createNameDescriptionArea();
                self.createProjectTemplate();
                self.createPropertiesTable();
            }
        },

        /**
         *
         */
        createHeader: function() {
            var self = this;

            var titleDiv = domConstruct.create("div", {
                style: {
                    "display": "inline-block",
                    "width": "100%"
                }
            }, self.headerAttach);

            self.headerName = domConstruct.create("div", {
                className: "containerLabel containerLabelTemplates inline",
                innerHTML: self.template.name.escape(),
                style: {
                    "display": "inline-block"
                }
            }, titleDiv);

            self.editIconLink = new Link({
                iconClass: "templateEditIcon",
                alt: i18n("Edit"),
                title: i18n("Edit"),
                onClick: function() {
                    self.setEditMode();
                }
            }).placeAt(titleDiv);

            self.usageIconLink = new Link({
                iconClass: "templateUsageIcon",
                alt: i18n("Usage"),
                title: i18n("Usage"),
                onClick: function() {
                    self.displayUsage();
                }
            }).placeAt(titleDiv);

            self.securityIconLink = new Link({
                iconClass: "templateSecurityIcon",
                alt: i18n("Security"),
                title: i18n("Security"),
                onClick: function() {
                    showPopup(self.securityUrl + "?resourceId=" + self.template.resourceId, 800, 600);
                }
            }).placeAt(titleDiv);

            self.cancelButton = domConstruct.create("input", {
                type: "button",
                value: i18n("Cancel"),
                className: "button",
                onclick: function() {
                    self.cancelTemplate();
                },
                style: {
                    "display": "none",
                    "float": "right",
                    "margin-top": "7px",
                    "width": "80px"
                }
            }, titleDiv);

            self.saveButton = domConstruct.create("input", {
                type: "button",
                value: i18n("Save"),
                className: "button",
                onclick: function() {
                    self.saveTemplate();
                },
                style: {
                    "display": "none",
                    "float": "right",
                    "margin-top": "7px",
                    "width": "80px"
                }
            }, titleDiv);

            self.headerDescription = domConstruct.create("div", {
                innerHTML: self.template.description,
                className: "containerLabelDescription"
            }, self.headerAttach);
        },

        /**
         *
         */
        createNameDescriptionArea: function() {
            var self = this;

            var rowName = domConstruct.create("div", {
                className: "fieldRow"
            }, self.nameDescriptionAttach);
            domConstruct.create("div", {
                innerHTML: i18n("Name") + '<span class="required">*</span>',
                className: "fieldColumn15 bold"
            }, rowName);
            self.nameText = new TextBox({
                value: self.template.name,
                disabled: true,
                style: {
                    "display": "inline-block",
                    "vertical-align": "middle",
                    "width": "22%"
                }
            });
            self.nameText.placeAt(rowName);

            var rowDescription = domConstruct.create("div", {
                className: "fieldRowSecondary"
            }, self.nameDescriptionAttach);
            domConstruct.create("div", {
                innerHTML: i18n('Description'),
                className: "fieldColumn15 bold"
            }, rowDescription);
            self.descriptionTextArea = new TextArea({
                value: self.template.description,
                disabled: true,
                style: {
                    "display": "inline-block",
                    "vertical-align": "middle",
                    "width": "22%"
                }
            });
            self.descriptionTextArea.placeAt(rowDescription);
        },

        /**
         *
         */
        createProjectTemplate: function() {
            var self = this;

            domConstruct.create("div", {
                innerHTML: i18n("SourceChangeQuietPeriod"),
                className: "miniHeader"
            }, self.formAttach);

            // Time Period Field //////////////////////////////////////////////////////////////////
            var row1 = domConstruct.create("div", {
                className: "fieldRow"
            });
            domConstruct.create("div", {
                innerHTML: i18n("BuildPreProcessTimePeriod") + '<span class="required">*</span>',
                className: "fieldColumn15 bold"
            }, row1);
            self.timePeriodText = new TextBox({
                value: self.template["build-pre-process"]["quiet-period"],
                disabled: true,
                style: {
                    "display": "inline-block",
                    "vertical-align": "middle",
                    "width": "22%"
                }
            });
            self.timePeriodText.placeAt(row1);
            domConstruct.create("div", {
                innerHTML: "<span class='inlinehelp'>" + i18n("BuildPreProcessTimePeriodDesc") + "</span>",
                className: "fieldColumn60"
            }, row1);
            domConstruct.place(row1, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////

            domConstruct.create("div", {
                innerHTML: i18n("RepositoryTriggerMergePeriod"),
                className: "miniHeader"
            }, self.fieldsAttach);

            // Merge Period Field /////////////////////////////////////////////////////////////////
            var row2 = domConstruct.create("div", {
                className: "fieldRow"
            });
            domConstruct.create("div", {
                innerHTML: i18n("BuildPreProcessMergePeriod") + '<span class="required">*</span>',
                className: "fieldColumn15 bold"
            }, row2);
            self.mergePeriodText = new TextBox({
                value: self.template["build-pre-process"]["merge-period"],
                disabled: true,
                style: {
                    "display": "inline-block",
                    "vertical-align": "middle",
                    "width": "22%"
                }
            });
            self.mergePeriodText.placeAt(row2);
            domConstruct.create("div", {
                innerHTML: "<span class='inlinehelp'>" + i18n("BuildPreProcessMergePeriodDesc") + "</span>",
                className: "fieldColumn60"
            }, row2);
            domConstruct.place(row2, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////

            domConstruct.create("div", {
                innerHTML: i18n("SourceDependencyChangeDetection"),
                className: "miniHeader"
            }, self.fieldsAttach);

            // Agent Pool Field Selection /////////////////////////////////////////////////////////
            var row5 = domConstruct.create("div", {
                className: "fieldRow"
            });
            domConstruct.create("div", {
                innerHTML: i18n("AgentPool") + '<span class="required">*</span>',
                className: "fieldColumn15 bold"
            }, row5);
            var agentSelectionDiv = domConstruct.create("div", {
                className: "fieldColumn20"
            }, row5);
            self.agentSelectionRadio = new RadioButton({
                name: "agentPool",
                checked: self.template["build-pre-process"]["agent-pool"] !== null,
                disabled: true,
                style: {
                    "display": "inline-block",
                    "position": "relative",
                    "top": "1px"
                }
            });
            self.agentSelectionRadio.placeAt(agentSelectionDiv);
            domConstruct.create("div", {
                innerHTML: i18n("Selection"),
                style: {
                    "display": "inline-block",
                    "padding-left": "3px",
                    "position": "relative",
                    "top": "3px"
                }
            }, agentSelectionDiv);
            var agentSelectionHelp = domConstruct.create("div", {
                className: "labelsAndValues-helpCell inlineBlock",
                style: {
                    "float": "right",
                    "position": "relative",
                    "top": "2px"
                }
            }, agentSelectionDiv);
            new Tooltip({
                connectId: [agentSelectionHelp],
                label: i18n("TagAgentPoolSelectorSelectionDesc"),
                showDelay: 100,
                position: ["after", "above", "below", "before"]
            });
            self.agentSelectionRestSelect = new RestSelect({
                restUrl: bootstrap.restUrl + "/agentPools",
                getLabel: function(item) {
                    return item.name;
                },
                getValue: function(item) {
                    return item.name;
                },
                value: (self.template["build-pre-process"]["agent-pool"] !== null ? self.template["build-pre-process"]["agent-pool"] : ""),
                disabled: true,
                style: {
                    "display": "inline-block",
                    "float": "right",
                    "vertical-align": "middle",
                    "width": "60%"
                },
                noIllegalValues: true
//                allowNone: false
            });
            self.agentSelectionRestSelect.placeAt(agentSelectionDiv);
            domConstruct.create("div", {
                innerHTML: "<span class='inlinehelp'>" + i18n("BuildPreProcessAgentPoolDesc") + "</span>",
                className: "fieldColumn60"
            }, row5);
            domConstruct.place(row5, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////

            // Agent Pool Field Script ////////////////////////////////////////////////////////////
            var row6 = domConstruct.create("div", {
                className: "fieldRowSecondary"
            });
            domConstruct.create("div", {
                innerHTML: '',
                className: "fieldColumn15"
            }, row6);
            var agentScriptDiv = domConstruct.create("div", {
                className: "fieldColumn20"
            }, row6);
            self.agentScriptRadio = new RadioButton({
                name: "agentPool",
                checked: self.template["build-pre-process"]["agent-pool"] === null,
                disabled: true,
                style: {
                    "display": "inline-block",
                    "position": "relative",
                    "top": "1px"
                }
            });
            self.agentScriptRadio.placeAt(agentScriptDiv);
            domConstruct.create("div", {
                innerHTML: i18n("Script"),
                style: {
                    "display": "inline-block",
                    "padding-left": "3px",
                    "position": "relative",
                    "top": "3px"
                }
            }, agentScriptDiv);
            var agentScriptHelp = domConstruct.create("div", {
                className: "labelsAndValues-helpCell inlineBlock",
                style: {
                    "float": "right",
                    "position": "relative",
                    "top": "2px"
                }
            }, agentScriptDiv);
            new Tooltip({
                connectId: [agentScriptHelp],
                label: i18n("TagAgentPoolSelectorPropertyDesc"),
                showDelay: 100,
                position: ["after", "above", "below", "before"]
            });
            self.agentScriptText = new TextBox({
                value: self.template["build-pre-process"]["agent-pool-prop"],
                disabled: true,
                style: {
                    "display": "inline-block",
                    "float": "right",
                    "vertical-align": "middle",
                    "width": "60%"
                }
            });
            self.agentScriptText.placeAt(agentScriptDiv);
            domConstruct.place(row6, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////////

            // Build Criteria Field w/ Label //////////////////////////////////////////////////////////
            var row3 = domConstruct.create("div", {
                className: "fieldRow"
            });
            domConstruct.create("div", {
                innerHTML: i18n("BuildLifeCriteria"),
                className: "fieldColumn15 bold"
            }, row3);
            var withLabelDiv = domConstruct.create("div", {
                className: "fieldColumn20"
            }, row3);
            domConstruct.create("div", {
                innerHTML: i18n("WithLabel"),
                className: "fieldInnerLeft"
            }, withLabelDiv);
            var criteriaLabelHelp = domConstruct.create("div", {
                className: "labelsAndValues-helpCell inlineBlock",
                style: {
                    "float": "right",
                    "position": "relative",
                    "top": "2px"
                }
            }, withLabelDiv);
            new Tooltip({
                connectId: [criteriaLabelHelp],
                label: i18n("BuildPreProcessCriteriaDesc2"),
                showDelay: 100,
                position: ["after", "above", "below", "before"]
            });
//            self.addLabelIcon = domConstruct.create("image", {
//                src: "/images/icon_add.gif",
//                alt: "Add Label",
//                title: "Add Label",
//                height: "18px",
//                width: "18px",
//                onclick: function() {
////                    self.setEditMode();
//                    new TextBox({
//                        value: "",
//                        style: {
//                            "left": domGeo.position(self.buildCriteriaLabelText, true).x + "px",
//                            "padding-bottom": "5px",
//                            "position": "relative",
//                            "width": "187px"
//                        }
//                    }, self.additionLabelsRow)
//                },
//                style: {
//                    "cursor": "pointer",
//                    "display": "inline-block",
//                    "float": "right",
//                    "padding": "3px 0px 0px 2px"
//                }
//            }, withLabelDiv);
            self.buildCriteriaLabelText = new TextBox({
                value: self.template["build-pre-process"]["label-values"],
                disabled: true,
                style: {
                    "display": "inline-block",
                    "float": "right",
                    "vertical-align": "middle",
                    "width": "60%"
                }
            });
            self.buildCriteriaLabelText.placeAt(withLabelDiv);
            domConstruct.create("div", {
                innerHTML: "<span class='inlinehelp'>" + i18n("BuildPreProcessCriteriaDesc1") + "</span>",
                className: "fieldColumn60"
            }, row3);
            domConstruct.place(row3, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////

            // Extra Build Criteria Labels go here ////////////////////////////////////////////////
            self.additionLabelsRow = domConstruct.create("div", {
                className: "fieldRowSecondary"
            }, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////

            // Build Criteria Field w/ Stamp //////////////////////////////////////////////////////
            var row4 = domConstruct.create("div", {
                className: "fieldRowSecondary"
            });
            domConstruct.create("div", {
                innerHTML: '',
                className: "fieldColumn15"
            }, row4);
            var withStampDiv = domConstruct.create("div", {
                className: "fieldColumn20"
            }, row4);
            domConstruct.create("div", {
                innerHTML: i18n("WithStamp"),
                className: "fieldInnerLeft"
            }, withStampDiv);
            var criteriaStampHelp = domConstruct.create("div", {
                className: "labelsAndValues-helpCell inlineBlock",
                style: {
                    "float": "right",
                    "position": "relative",
                    "top": "2px"
                }
            }, withStampDiv);
            new Tooltip({
                connectId: [criteriaStampHelp],
                label: i18n("BuildPreProcessCriteriaDesc3"),
                showDelay: 100,
                position: ["after", "above", "below", "before"]
            });
//            self.addStampIcon = domConstruct.create("image", {
//                src: "/images/icon_add.gif",
//                alt: "Add Stamp",
//                title: "Add Stamp",
//                height: "18px",
//                width: "18px",
//                onclick: function() {
////                    self.setEditMode();
//                },
//                style: {
//                    "cursor": "pointer",
//                    "display": "inline-block",
//                    "float": "right",
//                    "padding": "3px 0px 0px 2px"
//                }
//            }, withStampDiv);
            self.buildCriteriaStampText = new TextBox({
                value: self.template["build-pre-process"]["stamp-values"],
                disabled: true,
                style: {
                    "display": "inline-block",
                    "float": "right",
                    "vertical-align": "middle",
                    "width": "60%"
                }
            });
            self.buildCriteriaStampText.placeAt(withStampDiv);
            domConstruct.place(row4, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////

            // Should Cleanup Field ///////////////////////////////////////////////////////////////
            var row7 = domConstruct.create("div", {
                className: "fieldRow"
            });
            domConstruct.create("div", {
                innerHTML: i18n("BuildPreProcessShouldCleanup"),
                className: "fieldColumn15 bold"
            }, row7);
            var yesNoDiv = domConstruct.create("div", {
                className: "fieldColumn20"
            }, row7);
            self.cleanupYesRadio = new RadioButton({
                name: "cleanup",
                checked: self.template["build-pre-process"]["shouldCleanup"],
                disabled: true,
                style: {
                    "display": "inline-block",
                    "position": "relative",
                    "top": "1px"
                }
            });
            self.cleanupYesRadio.placeAt(yesNoDiv);
            domConstruct.create("div", {
                innerHTML: i18n("Yes"),
                style: {
                    "display": "inline-block",
                    "padding-right": "15px",
                    "position": "relative",
                    "top": "3px"
                }
            }, yesNoDiv);
            self.cleanupNoRadio = new RadioButton({
                name: "cleanup",
                checked: !self.template["build-pre-process"]["shouldCleanup"],
                disabled: true,
                style: {
                    "display": "inline-block",
                    "position": "relative",
                    "top": "1px"
                }
            });
            self.cleanupNoRadio.placeAt(yesNoDiv);
            domConstruct.create("div", {
                innerHTML: i18n("No"),
                style: {
                    "display": "inline-block",
                    "position": "relative",
                    "top": "3px"
                }
            }, yesNoDiv);
            domConstruct.create("div", {
                innerHTML: "<span class='inlinehelp'>" + i18n("BuildPreProcessShouldCleanupDesc") + "</span>",
                className: "fieldColumn60"
            }, row7);
            domConstruct.place(row7, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////

            // Step Pre-Condition Script Field ////////////////////////////////////////////////////
            var row8 = domConstruct.create("div", {
                className: "fieldRow"
            });
            domConstruct.create("div", {
                innerHTML: i18n("StepPreConditionScript"),
                className: "fieldColumn15 bold"
            }, row8);
            self.preConditionScriptRestSelect = new RestSelect({
                restUrl: bootstrap.restUrl + "/stepPreConditionScripts",
                getLabel: function(item) {
                    return item.name;
                },
                getValue: function(item) {
                    return item.name;
                },
                value: self.template["build-pre-process"]["pre-condition-script"],
                noIllegalValues: true,
                disabled: true,
                style: {
                    "display": "inline-block",
                    "vertical-align": "middle",
                    "width": "22%"
                }
            });
            self.preConditionScriptRestSelect.placeAt(row8);
            domConstruct.create("div", {
                innerHTML: "<span class='inlinehelp'>" + i18n("BuildPreProcessStepScriptDesc") + "</span>",
                className: "fieldColumn60"
            }, row8);
            domConstruct.place(row8, self.fieldsAttach);
            ///////////////////////////////////////////////////////////////////////////////////////
        },

        /**
         *
         */
        createPropertiesTable: function() {
            var self = this;

            self.createPropertyButton = domConstruct.create("input", {
                type: "button",
                value: i18n("PropertyCreate"),
                className: "button",
                onclick: function() {
                    self.createProperty();
                },
                style: {
                    "display": (self.canEdit ? "inline-block" : "none")
                }
            }, self.propertyHeaderAttach);

            var gridRestUrl = bootstrap.restUrl + "/templates/" + self.template.id + "/properties";
            var gridLayout = [{
                name: i18n("Name"),
                field: "name",
                orderField: "name",
                getRawValue: function(item) {
                    return item.name;
                },
                style: { "width": "15%" }
            },{
                name: i18n("Type"),
                field: "display-type",
                orderField: "display-type",
                getRawValue: function(item) {
                    return item["display-type"];
                },
                formatter: function(row, result, cellDom) {
                    var res;
                    if (row.valueType == "scripted") {
                        res = row["display-type"] + " (Scripted)";
                    }
                    else if (row.valueType == "jobExecution") {
                        res = row["display-type"] + " (Job Execution)";
                    }
                    else {
                        res = result;
                    }
                    return res;
                },
                style: { "width": "15%" }
            },{
                name: i18n("Required"),
                field: "required",
                orderField: "required",
                getRawValue: function(item) {
                    return item.required;
                },
                style: { "width": "5%" }
            },{
                name: i18n("DefaultValue"),
                field: "default-value",
                orderField: "default-value",
                getRawValue: function(item) {
                    return item["default-value"];
                },
                formatter: function(row, result, cellDom) {
                    var res;
                    if (row.valueType == "scripted") {
                        res = "<scripted default value>";
                    }
                    else {
                        res = row["default-value"];
                    }
                    return res;
                },
                style: { "width": "25%" }
            },{
                name: i18n("Description"),
                field: "description",
                orderField: "description",
                getRawValue: function(item) {
                    return item.description;
                },
                style: { "width": "40%" }
            }];

            setTimeout(function() {
                self.grid = new TreeTable({
                    url: gridRestUrl,
                    columns: gridLayout,
                    draggable: true,
                    hideExpandCollapse: true,
                    hideFooterLinks: true,
                    hidePagination: true,
                    serverSideProcessing: false,
                    tableConfigKey: "propertiesList",
                    onRowSelect: function(item, row) {
                        self.displayProperty(item);
                    },
                    onDrop: function(sources, target, copy) {
                        var index = 0;
                        var sourceIndex;
                        var targetIndex;
                        array.forEach(self.template.properties, function(property) {
                            if (property.name == sources[0].name) {
                                sourceIndex = index;
                            }
                            else if (property.name == target.name) {
                                targetIndex = index;
                            }
                            index++;
                        });
                        var prop = self.template.properties.splice(sourceIndex, 1);
                        self.template.properties.splice(targetIndex, 0, prop[0]);
                        xhr.put({
                            url: bootstrap.restUrl + "/templates/" + self.template.id,
                            putData: JSON.stringify(self.template),
                            contentType: "application/json",
                            handleAs: "json",
                            load: function(data) {
                                self.grid.refresh();
                            }
                        });
                    },
                    style: {
                        "padding-top": "10px",
                        "width": "100%"
                    }
                }, self.propertyGridAttach);
            }, 0);
        },

        /**
         *
         */
        createProperty: function() {
            var self = this;

            var propertyPopup = new PropertyPopup({
                parent: self,
                property: self.property,
                templateId: self.template.id,
                canEdit: self.canEdit,
                isNew: true
            }).show();
        },

        /**
         *
         */
        displayProperty: function(property) {
            var self = this;

            new PropertyPopup({
                parent: self,
                property: property,
                templateId: self.template.id,
                canEdit: self.canEdit,
                isNew: false
            }).show();
        },

        /**
         *
         */
        displayUsage: function() {
            var self = this;

            var usageAttach = domConstruct.create("div");
            new Dialog({
                title: i18n("Usage"),
                content: usageAttach
            }).show();

            var usageTable = new TemplateUsageTable({
                tasksUrl: "/tasks/project/ProjectTasks",
                templateId: self.template.id,
                style: {
                    width: "1000px"
                }
            });
            usageTable.placeAt(usageAttach);
        },

        /**
         *
         */
        saveTemplate: function() {
            var self = this;

            var errors = self.runValidation();
            if (errors.length == 0) {
                var dataJSON = {
                    "name": self.nameText.get("value"),
                    "description": self.descriptionTextArea.get("value"),
                    "build-pre-process": [{
                        "name": "quiet-period",
                        "value": self.timePeriodText.get("value")
                    },{
                        "name": "merge-period",
                        "value": self.mergePeriodText.get("value")
                    },{
                        "name": "label-values",
                        "value": self.buildCriteriaLabelText.get("value")
                    },{
                        "name": "stamp-values",
                        "value": self.buildCriteriaStampText.get("value")
                    },{
                        "name": "agent-pool",
                        "value": (self.agentSelectionRadio.get("checked") ? self.agentSelectionRestSelect.get("value") : null)
                    },{
                        "name": "shouldCleanup",
                        "value": self.cleanupYesRadio.get("checked")
                    },{
                        "name": "pre-condition-script",
                        "value": self.preConditionScriptRestSelect.get("value")
                    },{
                        "name": "agent-pool-prop",
                        "value": (self.agentScriptRadio.get("checked") ? self.agentScriptText.get("value") : null)
                    }],
                    "properties": self.template.properties
                };

                xhr.put({
                    url: bootstrap.restUrl + "/templates/" + self.template.id,
                    putData: JSON.stringify(dataJSON),
                    contentType: "application/json",
                    handleAs: "json",
                    load: function(data) {
                        self.template = data;
                        self.headerName.innerHTML = self.template.name;
                        self.headerDescription.innerHTML = self.template.description;

                        if (self.agentSelectionRadio.checked) {
                            self.agentScriptText.set("value", "");
                        }
                        else {
                            self.agentSelectionRestSelect.setValue("");
                        }

//                        self.parent.refresh(); only if name change
                        self.setViewMode();
                    }
                });
            }
            else {
                new Dialog({
                    title: i18n("Errors"),
                    content: self.formatErrors(errors)
                }).show();
            }
        },

        /**
         *
         */
        cancelTemplate: function() {
            var self = this;

            if (!self.isNew) {
                self.nameText.set("value", self.template.name);
                self.descriptionTextArea.set("value", self.template.description);
                self.timePeriodText.set("value", self.template["build-pre-process"]["quiet-period"]);
                self.mergePeriodText.set("value", self.template["build-pre-process"]["merge-period"]);
                self.buildCriteriaLabelText.set("value", self.template["build-pre-process"]["label-values"]);
                self.buildCriteriaStampText.set("value", self.template["build-pre-process"]["stampe-values"]);
                self.agentSelectionRadio.set("checked", self.template["build-pre-process"]["agent-pool"] !== null);
                self.agentScriptRadio.set("checked", self.template["build-pre-process"]["agent-pool"] === null);
                self.agentSelectionRestSelect.set("value", self.template["build-pre-process"]["agent-pool"]);
                self.cleanupYesRadio.set("checked", self.template["build-pre-process"]["shouldCleanup"] !== null);
                self.cleanupNoRadio.set("checked", self.template["build-pre-process"]["shouldCleanup"] === null);
                self.preConditionScriptRestSelect.set("value", self.template["build-pre-process"]["pre-condition-script"]);
                self.agentScriptText.set("value", self.template["build-pre-process"]["agent-pool-prop"]);

                self.setViewMode();
            }
        },

        /**
         *
         */
        runValidation: function() {
            var self = this;
            var errors = [];

            var name = self.nameText.get("value");
            var description = self.descriptionTextArea.get("value");
            var timePeriod = self.timePeriodText.get("value");
            var mergePeriod = self.mergePeriodText.get("value");
            var buildCriteriaLabel = self.buildCriteriaLabelText.get("value");
            var buildCriterialStamp = self.buildCriteriaStampText.get("value");
            var agentPoolIsSelect = self.agentSelectionRadio.get("checked");
            var agentPool = (agentPoolIsSelect ? self.agentSelectionRestSelect.get("value") : null);
            var agentPoolScript = (agentPoolIsSelect ? null : self.agentScriptText.get("value"));
            var shouldCleanup = self.cleanupYesRadio.get("checked");
            var preConditionScript = self.preConditionScriptRestSelect.get("value");

            var errors = [];
            if (name == null || name == "") {
                errors.push(i18n("NameIsRequiredError"));
            }
            if (description.length > 256) {
                errors.push(i18n("DescriptionLengthError"));
            }
            if (timePeriod == null || timePeriod == "") {
                errors.push(i18n("TimePeriodRequiredError"));
            }
            if (mergePeriod == null || mergePeriod == "") {
                errors.push(i18n("MergePeriodRequiredError"));
            }
            if (agentPoolIsSelect) {
                if (agentPool == null || agentPool == "") {
                    errors.push(i18n("AgentPollRequiredError"));
                }
            }
            else {
                if (agentPoolScript == null || agentPoolScript == "") {
                    errors.push(i18n("AgentpoolScriptRequiredError"));
                }
            }

            return errors;
        },

        /**
         *
         */
        formatErrors: function(errors) {
            var self = this;

            var errorsDiv = domConstruct.create("div");

            array.forEach(errors, function(error) {
                domConstruct.create("div", {
                    innerHTML: error
                }, errorsDiv);
            });

            return errorsDiv;
        },

        /**
         *
         */
        setEditMode: function() {
            var self = this;

            self.nameText.setDisabled(false);
            self.descriptionTextArea.setDisabled(false);
            self.timePeriodText.setDisabled(false);
            self.mergePeriodText.setDisabled(false);
            self.agentSelectionRadio.setDisabled(false);
            self.agentScriptRadio.setDisabled(false);
            self.agentScriptText.setDisabled(false);
            self.buildCriteriaLabelText.setDisabled(false);
            self.buildCriteriaStampText.setDisabled(false);
            self.cleanupYesRadio.setDisabled(false);
            self.cleanupNoRadio.setDisabled(false);

            self.agentSelectionRestSelect.set("disabled", false);
            self.preConditionScriptRestSelect.set("disabled", false);

            domStyle.set(self.editIconLink.domNode, "display", "none");
            domStyle.set(self.securityIconLink.domNode, "display", "none");
            domStyle.set(self.usageIconLink.domNode, "display", "none");

            domStyle.set(self.saveButton, "display", "inline-block");
            domStyle.set(self.cancelButton, "display", "inline-block");
        },

        /**
         *
         */
        setViewMode: function() {
            var self = this;

            self.nameText.setDisabled(true);
            self.descriptionTextArea.setDisabled(true);
            self.timePeriodText.setDisabled(true);
            self.mergePeriodText.setDisabled(true);
            self.agentSelectionRadio.setDisabled(true);
            self.agentScriptRadio.setDisabled(true);
            self.agentScriptText.setDisabled(true);
            self.buildCriteriaLabelText.setDisabled(true);
            self.buildCriteriaStampText.setDisabled(true);
            self.cleanupYesRadio.setDisabled(true);
            self.cleanupNoRadio.setDisabled(true);

            self.agentSelectionRestSelect.set("disabled", true);
            self.preConditionScriptRestSelect.set("disabled", true);

            domStyle.set(self.editIconLink.domNode, "display", "inline-block");
            domStyle.set(self.securityIconLink.domNode, "display", "inline-block");
            domStyle.set(self.usageIconLink.domNode, "display", "inline-block");

            domStyle.set(self.saveButton, "display", "none");
            domStyle.set(self.cancelButton, "display", "none");
        }

    });
});
