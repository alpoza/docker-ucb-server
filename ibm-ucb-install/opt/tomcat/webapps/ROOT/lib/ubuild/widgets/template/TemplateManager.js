/*global define, require */
define([
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/dom",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/json",
        "dijit/form/Button",
        "dijit/form/Textarea",
        "dijit/form/TextBox",
        "js/webext/widgets/ColumnForm",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/GenericConfirm",
        "js/webext/widgets/Link",
        "js/webext/widgets/TwoPaneListManager",
        "ubuild/security/TeamSelector",
        "ubuild/template/buildProcess/BuildProcessTemplate",
        "ubuild/template/project/ProjectTemplate"
        ],
function(
        array,
        declare,
        xhr,
        dom,
        domClass,
        domConstruct,
        JSON,
        Button,
        TextArea,
        TextBox,
        ColumnForm,
        Dialog,
        GenericConfirm,
        Link,
        TwoPaneListManager,
        TeamSelector,
        BuildProcessTemplate,
        ProjectTemplate
) {
    /**
     *
     */
    return declare("ubuild.widgets.template.TemplateManager", [TwoPaneListManager], {
        initialInfoDialog: null,
        newTemplateId: null,
        url: null,
        securityUrl: null,
        canCreate: false,
        canEdit: false,
        canView: false,
        
        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;
            
            self.showList();
        },
        
        /**
         * 
         */
        showList: function(selectedId) {
            var self = this;
            self.defaultSelectionId = selectedId;

            xhr.get({
                url: self.url,
                handleAs: "json",
                load: function(data) {
                    var numberOfEntries = 0;
                    
                    array.forEach(data, function(entry) {
                        if (self.canView) { // if we end up doing different security for each template then look at teams
                            numberOfEntries++;
                            
                            var templateDiv = domConstruct.create("div", {
                                style: {position: "relative"}
                            });
                            
                            var optionsContainer = domConstruct.create("div", {
                                className: "twoPaneActionIcons"
                            }, templateDiv);
                            
                            domConstruct.create("div", {
                                className: "twoPaneEntryLabel",
                                innerHTML: entry.name.escape()
                            }, templateDiv);
                            
                            if (self.canCreate) {
                                var deleteLink = domConstruct.create("div", {
                                    className: "inlineBlock vAlignMiddle cursorPointer margin2Left iconMinus"
                                }, optionsContainer);
                                deleteLink.onclick = function(event) {
                                    util.cancelBubble(event);
                                    self.confirmDelete(entry);
                                };
                            }
                            
                            self.addEntry({
                                id: entry.id,
                                domNode: templateDiv,
                                action: function() {
                                    self.selectEntry(entry, entry.id == self.newTemplateId);
                                }
                            });
                        }
                    });
                    self.newTemplateId = null;
                    
                    if (self.canCreate) {
                        var newTemplateDiv = domConstruct.create("div");
                        
                        domConstruct.create("div", {
                            className: "vAlignMiddle inlineBlock iconPlus",
                        }, newTemplateDiv);
                        domConstruct.create("div", {
                            innerHTML: i18n("ProjectTemplateCreateNew"),
                            className: "vAlignMiddle inlineBlock margin5Left"
                        }, newTemplateDiv);
                        
                        self.addEntry({
                            id: null,
                            domNode: newTemplateDiv,
                            action: function() {
                                self.selectNewTemplate();
                                domClass.add(self.domNode, "create-new-template");
                            }
                        });
                    }
                    
                    if (numberOfEntries === 0) {
                        domConstruct.create("div", {
                            className: "containerNode",
                            innterHTML: i18n("ProjectTemplatesNonePermissionsError")
                        }, self.detailAttach);
                    }
                    
                }
            });
        },
        
        /**
         * 
         */
        refresh: function(newId) {
            var self = this;
            var selectedId = newId;
            if (self.selectedEntry && self.selectedEntry.id) {
                selectedId = self.selectedEntry.id;
            }
            
            self.clearDetail();
            self.clearList();
            self.showList(selectedId);
        },
        
        /**
         * Clear out the detail pane and put this component's information there.
         */
        selectEntry: function(entry, isNew) {
            var self = this;
            
            xhr.get({
                url: self.url + "/" + entry.id,
                handleAs: "json",
                load: function(data) {
                    switch (self.type) {
                        case "buildProcess":
                            self.createBuildProcessTemplate(data);
                            break;
                        default :
                            self.createProjectTemplate(data, isNew);
                            break;
                    }
                }
            });
        },
        
        /**
         * 
         */
        selectNewTemplate: function() {
            var self = this;
            
            self.initialInfoDialog = new Dialog({
                title: i18n("ProjectTemplateCreateProjectTemplate"),
            });
            self.initialInfoDialog.set("content", self.createInitialInfoFields());
            self.initialInfoDialog.show();
        },
        
        /**
         * 
         */
        createInitialInfoFields: function() {
            var self = this;
            
            var containerDiv = domConstruct.create("div", {
                style: { "width": "600px" }
            });
            
            nameDescriptionColumnForm = new ColumnForm({
                submitUrl: bootstrap.restUrl + "/templates",
                submitMethod: "POST",
                postSubmit: function(data) {
                    self.newTemplateId = data.id;
                    self.createProjectTemplate(data, true);
                    self.teamSelector.destroy();
                    self.initialInfoDialog.destroy();
                },
                onCancel: function() {
                    self.initialInfoDialog.destroy();
                    nameDescriptionColumnForm.destroy();
                    self.refresh();
                },
                addData: function(data) {
                    data["build-pre-process"] = [];
                    data["properties"] = [];
                    data["teams"] = self.teamSelector.teams;
                }
            });
            nameDescriptionColumnForm.placeAt(containerDiv);
            
            nameDescriptionColumnForm.addField({
                name: "name",
                label: i18n("Name"),
                type: "Text",
                required: true
            });
            nameDescriptionColumnForm.addField({
                name: "description",
                label: i18n("Description"),
                type: "Text Area"
            });
            self.teamSelector = new TeamSelector({
                teamsUrl: bootstrap.restUrl + "/team",
                resourceRolesUrl: bootstrap.restUrl + "/resourceType/00000000-0000-0000-0000-000000000021/resourceRoles"
            });
            nameDescriptionColumnForm.addField({
                name: "teams",
                label: i18n("Teams"),
                widget: self.teamSelector
            });
            
            return containerDiv;
        },
        
        /**
         * 
         */
        confirmDelete: function(entry) {
            var self = this;
            
            var deleteConfirm = new GenericConfirm({
                message: i18n("TemplateDeleteConfirmation", entry.name),
                action: function() {
                    xhr.del({
                        url: self.url + "/" + entry.id,
                        handleAs: "json",
                        load: function(data) {
                            self.refresh();
                        }
                    });
                }
            });
        },
        
        /**
         * 
         */
        createProjectTemplate: function(template, isNew) {
            var self = this;
            var projectTemplate = new ProjectTemplate({
                template: template,
                url: self.url,
                securityUrl: self.securityUrl,
                parent: self,
                canCreate: self.canCreate,
                canEdit: self.canEdit,
                canView: self.canView,
                isNew: isNew
            });
            projectTemplate.placeAt(self.detailAttach);
            self.registerDetailWidget(projectTemplate);
            
            if (template.id == self.newTemplateId) {
                self.refresh(template.id);
            }
        },
        
        createBuildProcessTemplate: function(template) {
            var self = this;
            var buildProcessTemplate = new BuildProcessTemplate({
                template: template,
                url: self.url,
                canCreate: self.canCreate,
                canEdit: self.canEdit,
                canView: self.canView
            });
            buildProcessTemplate.placeAt(self.detailAttach);
            self.registerDetailWidget(buildProcessTemplate);
        }
        
//        /**
//         * 
//         */
//        selectDefault: function() {
//            var self = this;
//            self.refresh(self.defaultSelectionId);
//        }
        
    });
});