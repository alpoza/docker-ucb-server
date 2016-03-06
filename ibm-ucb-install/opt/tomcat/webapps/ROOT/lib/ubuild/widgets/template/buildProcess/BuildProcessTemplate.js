/*global define, require */
define([
        "dijit/_TemplatedMixin",
        "dijit/_Widget",
        "dijit/_WidgetsInTemplateMixin",
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
        "dojo/mouse",
        "dojo/on",
        "dojo/query",
        "js/webext/widgets/ColumnForm",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/table/TreeTable"
        ],
function(
        _TemplatedMixin,
        _Widget,
        _WidgetsInTemplateMixin,
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
        mouse,
        on,
        query,
        ColumnForm,
        Dialog,
        TreeTable
) {
    return declare("ubuild.widgets.template.BuildProcessTemplate", [_Widget, _TemplatedMixin, _WidgetsInTemplateMixin], {
        icons: {},

        templateString:
            '<div class="edit-buildProcessTemplate">' +
              '<div data-dojo-attach-point="headerAttach"></div>' +
              '<div data-dojo-attach-point="resourcesAttach"></div>' +
              '<div data-dojo-attach-point="frameAttach"></div>' +
              '<div data-dojo-attach-point="propertyHeaderAttach"></div>' +
              '<div data-dojo-attach-point="propertyGridAttach"></div>' +
              '<div data-dojo-attach-point="artifactHeaderAttach"></div>' +
              '<div data-dojo-attach-point="artifactGridAttach"></div>' +
            '</div>',

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;
            self.existingValues = self.template || {};

            self.showForm();
        },

        /**
         * Builds the form for the template.
         */
        showForm: function() {
            var self = this;

            if (self.template) {
                self.createHeader();
                self.createResources();
                self.createWorkflowDefinition();
                self.createPropertiesTable();
                self.createArtifactTable();
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

            domConstruct.create("div", {
                className: "containerLabel containerLabelTemplates inline",
                innerHTML: self.template.name.escape(),
                style: {
                    "display": "inline-block"
                }
            }, titleDiv);

            self.icons.edit = domConstruct.create("image", {
                src: "/images/icon_pencil_edit.gif",
                alt: i18n("Edit"),
                title: i18n("Edit"),
                height: "14px",
                width: "14px",
                onclick: function() {
                    self.setEditMode();
                },
                style: {
                    "cursor": "pointer",
                    "display": "inline-block",
                    "padding": "0px 4px 0px 8px"
                }
            }, titleDiv);

            self.icons.usage = domConstruct.create("image", {
                src: "/images/icon_magnifyglass.gif",
                alt: i18n("Usage"),
                title: i18n("Usage"),
                height: "14px",
                width: "14px",
                onclick: function() {
                    self.displayUsage();
                },
                style: {
                    "cursor": "pointer",
                    "display": "inline-block",
                    "padding-left": "3px"
                }
            }, titleDiv);

            self.icons.security = domConstruct.create("image", {
                src: "/images/icon_shield.gif",
                alt: i18n("Security"),
                title: i18n("Security"),
                height: "14px",
                width: "14px",
                onclick: function() {
                    self.displaySecurity();
                },
                style: {
                    "cursor": "pointer",
                    "display": "inline-block",
                    "padding-left": "5px"
                }
            }, titleDiv);

            self.cancelButton = domConstruct.create("input", {
                type: "button",
                value: i18n("Cancel"),
                className: "button",
                onclick: function() {
                    self.setViewMode();
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
                    self.setViewMode();
                },
                style: {
                    "display": "none",
                    "float": "right",
                    "margin-top": "7px",
                    "width": "80px"
                }
            }, titleDiv);

            domConstruct.create("div", {
                innerHTML: self.template.description,
                className: "containerLabelDescription"
            }, self.headerAttach);
        },

        /**
         *
         */
        createResources: function() {
            var self = this;

            var rowResource = domConstruct.create("div", {
                className: "fieldRow"
            }, self.resourcesAttach);
            domConstruct.create("div", {
                innerHTML: '<span class="bold">' + i18n("ResourcesToLock") + '</span>',
                style: {
                    "display": "inline-block",
                    "padding-right": "10px"
                }
            }, rowResource)
            array.forEach(self.template.resources, function(resource) {
                domConstruct.create("a", {
                    innerHTML: resource.name,
                    onclick: function() {
                        self.displayResource(resource);
                    },
                    style: {
                        "display": "inline-block",
                        "padding-right": "5px"
                    }
                }, rowResource)
            });
           domConstruct.create("a", {
                href: "#",
                title: i18n("AddResource"),
                innerHTML: '<img border="0" src="/images/icon_add.gif"' +
                                            'title="' + i18n("AddResource") + '" ' +
                                            'alt="' + i18n("AddResource") + '" ' +
                                            'style="padding-right:3px;">' +
                                            i18n("AddResource"),
                onclick: function() {
                    self.addResource();
                }
            }, rowResource)
        },

        /**
         *
         */
        createWorkflowDefinition: function() {
            var self = this;

            var iframe = domConstruct.create("iframe", {
                "src": "../tasks/admin/library/workflow/WorkflowDefinitionTasks/viewWorkflowDefinition?workflowDefId=" + self.template.definitionId,
                style: {
                    "height": "366px",
                    "width": "100%"
                }
            }, self.frameAttach);
        },

        /**
         *
         */
        createPropertiesTable: function() {
            var self = this;

            var propertiesHeader = domConstruct.create("div", {
                style: {
                    "display": "inline-block",
                    "width": "100%"
                }
            }, self.propertyHeaderAttach);
            domConstruct.create("div", {
                innerHTML: i18n("Properties"),
                className: "miniHeader",
                style: {
                    "display": "inline-block"
                }
            }, propertiesHeader);
            self.createPropertyButton = domConstruct.create("input", {
                type: "button",
                value: i18n("NewProperty"),
                className: "button",
                onclick: function() {
                    self.createProperty();
                },
                style: {
                    "display": "inline-block",
                    "float": "right",
                    "margin-right": "24px"
                }
            }, propertiesHeader);

            var gridRestUrl = self.url + "/" + self.template.id + "/properties";
            var gridLayout = [{
                name: i18n("Name"),
                field: "name",
                orderField: "name",
                filterField: "name",
                filterType: "text",
                getRawValue: function(item) {
                    return item.name;
                }
            },{
                name: i18n("Type"),
                field: "display-type",
                orderField: "display-type",
                filterField: "display-type",
                filterType: "text",
                getRawValue: function(item) {
                    return item.get("display-type");
                }
            },{
                name: i18n("Required"),
                field: "required",
                orderField: "required",
                filterField: "required",
                filterType: "text",
                getRawValue: function(item) {
                    return item.required;
                }
            },{
                name: i18n("DefaultValue"),
                field: "default-value",
                orderField: "default-value",
                filterField: "default-value",
                filterType: "text",
                getRawValue: function(item) {
                    return item.get("default-value");
                }
            },{
                name: i18n("Description"),
                field: "description",
                orderField: "description",
                filterField: "description",
                filterType: "text",
                getRawValue: function(item) {
                    return item.description;
                }
            }];

            setTimeout(function() {
                self.grid = new TreeTable({
                    url: gridRestUrl,
                    serverSideProcessing: false,
                    columns: gridLayout,
                    tableConfigKey: "propertiesList",
                    hideExpandCollapse: true,
                    hideFooterLinks: true,
                    hidePagination: true,
                    onRowSelect: function(item, row) {
                        self.displayProperty(item);
                    },
                    style: {
                        "padding-top": "10px",
                        "padding-left": "6px",
                        "width": "99%"
                    }
                }, self.propertyGridAttach);
            }, 0);
        },

        /**
         *
         */
        createArtifactTable: function() {
            var self = this;

            var artifactsHeader = domConstruct.create("div", {
                style: {
                    "display": "inline-block",
                    "width": "100%"
                }
            }, self.artifactHeaderAttach);
            domConstruct.create("div", {
                innerHTML: i18n("Artifacts"),
                className: "miniHeader",
                style: {
                    "display": "inline-block"
                }
            }, artifactsHeader);
            self.createArtifactButton = domConstruct.create("input", {
                type: "button",
                value: i18n("NewArtifactConfig"),
                className: "button",
                onclick: function() {
                    self.createArtifact();
                },
                style: {
                    "display": "inline-block",
                    "float": "right",
                    "margin-right": "24px"
                }
            }, artifactsHeader);

            var gridRestUrl = self.url + "/" + self.template.id + "/artifacts";
            var gridLayout = [{
                name: i18n("ArtifactSet"),
                field: "name",
                orderField: "name",
                filterField: "name",
                filterType: "text",
                getRawValue: function(item) {
                    return item.name;
                }
            },{
                name: i18n("BaseDirectory"),
                field: "baseDirectory",
                orderField: "baseDirectory",
                filterField: "baseDirectory",
                filterType: "text",
                getRawValue: function(item) {
                    return item.baseDirectory;
                }
            },{
                name: i18n("Include"),
                field: "include",
                orderField: "include",
                filterField: "include",
                filterType: "text",
                getRawValue: function(item) {
                    return item.include;
                }
            },{
                name: i18n("Exclude"),
                field: "exclude",
                orderField: "exclude",
                filterField: "exclude",
                filterType: "text",
                getRawValue: function(item) {
                    return item.exclude;
                }
            }];

            setTimeout(function() {
                self.grid = new TreeTable({
                    url: gridRestUrl,
                    serverSideProcessing: false,
                    columns: gridLayout,
                    tableConfigKey: "artifactsList",
                    hideExpandCollapse: true,
                    hideFooterLinks: true,
                    hidePagination: true,
                    onRowSelect: function(item, row) {
                        self.displayArtifact(item);
                    },
                    style: {
                        "padding-top": "10px",
                        "padding-left": "6px",
                        "width": "99%"
                    }
                }, self.artifactGridAttach);
            }, 0);
        },

        /**
         *
         */
        addResource: function() {
            var self = this;

            new Dialog({
                title: "Pick a Reource to Add"
            }).show();
        },

        /**
         *
         */
        createArtifact: function() {
            var self = this;

            new Dialog({
                title: "New Artifact",
                content: "data data data"
            }).show();
        },

        /**
         *
         */
        createProperty: function() {
            var self = this;

            new Dialog({
                title: "New Property",
                content: "data data data"
            }).show();
        },

        /**
         *
         */
        displayArtifact: function(artifact) {
            var self = this;

            new Dialog({
                title: artifact.name,
                content: "You clicked on an artifact"
            }).show();
        },

        /**
         *
         */
        displayProperty: function(property) {
            var self = this;

            new Dialog({
                title: property.name,
                content: "You clicked on a property"
            }).show();
        },

        /**
         *
         */
        displayResource: function(resource) {
            var self = this;

            new Dialog({
                title: resource.name,
                content: "Id: " + resource.id + "<br/>" +
                         "Description: " + resource.description
            }).show();
        },

        /**
         *
         */
        displaySecurity: function() {
            var self = this;

            new Dialog({
                title: "Security",
                content: "You would now be viewing all of the security associated with this template."
            }).show();
        },

        /**
         *
         */
        displayUsage: function() {
            var self = this;

            new Dialog({
                title: "Usage",
                content: "This is everywhere this build process template is used."
            }).show();
        },

        /**
         *
         */
        setEditMode: function() {
            var self = this;

            domStyle.set(self.icons.edit, "display", "none");
            domStyle.set(self.icons.security, "display", "none");
            domStyle.set(self.icons.usage, "display", "none");

            domStyle.set(self.saveButton, "display", "inline-block");
            domStyle.set(self.cancelButton, "display", "inline-block");
        },

        /**
         *
         */
        setViewMode: function() {
            var self = this;

            domStyle.set(self.icons.edit, "display", "inline-block");
            domStyle.set(self.icons.security, "display", "inline-block");
            domStyle.set(self.icons.usage, "display", "inline-block");

            domStyle.set(self.saveButton, "display", "none");
            domStyle.set(self.cancelButton, "display", "none");
        }

    });
});
