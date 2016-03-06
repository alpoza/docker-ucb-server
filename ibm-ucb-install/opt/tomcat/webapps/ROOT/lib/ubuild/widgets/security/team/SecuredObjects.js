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
        "dijit/form/Select",
        "dijit/form/Button",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/_base/array",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/on",
        "js/webext/widgets/table/TreeTable",
        "js/webext/widgets/DialogMultiSelect",
        "js/webext/widgets/form/MenuButton",
        "js/webext/widgets/RestSelect",
        "js/webext/widgets/ColumnForm",
        "js/webext/widgets/Alert",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/GenericConfirm"
        ],
function(
        _TemplatedMixin,
        _Widget,
        Select,
        Button,
        declare,
        xhr,
        array,
        domClass,
        domConstruct,
        on,
        TreeTable,
        DialogMultiSelect,
        MenuButton,
        RestSelect,
        ColumnForm,
        Alert,
        Dialog,
        GenericConfirm
) {
    /**
     *
     */
    return declare([_Widget, _TemplatedMixin], {
        templateString:
            '<div>' +
                '<div data-dojo-attach-point="toolbarAttach">' +
                    '<div data-dojo-attach-point="viewBox" class="object-view-box inline-block">' +
                        '<b><div data-dojo-attach-point="objectLabel" style="margin-bottom: 5px;"></div></b>' +
                        '<div data-dojo-attach-point="secureResourceTypeAttach" class="inlineBlock"  style="margin-left: -5px;"></div>' +
                    '</div>' +
                    '<div data-dojo-attach-point="addBox" class="object-view-box inline-block" style="margin-left: 25px;">' +
                        '<b><div data-dojo-attach-point="addLabel" style="margin-bottom: 5px;"></div></b>' +
                        '<b><div data-dojo-attach-point="typeLabel" class="inlineBlock" style="margin-right: 10px;"></div></b>' +
                        '<div data-dojo-attach-point="typeSelectAttach" class="inlineBlock" style="margin: 0 4px -9px 0;"></div>' +
                        '<div data-dojo-attach-point="addSecureResourceAttach" class="inlineBlock"></div>' +
                    '</div>' +
                '</div>' +
                '<div data-dojo-attach-point="tableAttach"></div>' +
            '</div>',

        canEdit: false,

        /**
         *
         */
        postCreate: function() {
            this._loadPermissions();
            this._loadMappings();
        },

        /**
         * Sets the permissions.
         */
        _loadPermissions: function(){
        },

        /**
         * Loads the data for the mapping table.
         */
        _loadMappings: function(){
            var self = this;
            this.addLabel.innerHTML = i18n("Add Object Mapping") + " ";
            this.typeLabel.innerHTML = i18n("TypeWithColon") + " ";
            this.objectLabel.innerHTML = i18n("ViewWithColon") + " ";
            xhr.get({
                url: bootstrap.restUrl + "/resourceType",
                handleAs: "json",
                load: function(data) {
                    var options = [];
                    data = array.filter(data, function(item) {
                        return (item.name !== "Web UI" && item.name !== "Server Configuration");
                    });
                    var mappingType = util.getCookie("teamResourceMapping");
                    if (!mappingType){
                        mappingType = data[0].name;
                    }
                    self.resourceType = mappingType;
                    array.forEach(data, function(item) {
                        options.push({
                            label: i18n(item.name),
                            onClick: function() {
                                util.setCookie("teamResourceMapping", item.name);
                                self.secureResourceType.set('label', i18n(item.name));
                                self.resourceType = item.name;
                                self.addSecureResource.url = bootstrap.restUrl + "/team/"
                                            + self.team + "/unmappedResources/" + self.resourceType;
                                self.refreshTable();
                                self.refreshTypeSelect();
                                self.addSecureResource._setValueAttr();
                            }
                        });
                    });
                    self.secureResourceType = new MenuButton({
                        label: i18n(mappingType),
                        options: options
                    });
                    self.secureResourceType.placeAt(self.secureResourceTypeAttach);
                    self.showTable();
                    self.showForm();
                }
             });
        },

        showTable: function() {

            var self = this;
            var gridLayout = [{
                name: i18n("Name"),
                field: "name",
                formatter: function(item, result, domNode) {
                    if (item.name) {

                        if (item.path) {
                            result = self.formatters.resourceLinkFormatter(item);
                        }
                        else {
                          result = item.name;
                        }
                    }
                    else {
                        result = item.resource.name;
                    }
                    return result;
                },
                orderField: "name",
                filterField: "name",
                filterType: "text",
                getRawValue: function(item) {
                    var result = "";
                    if (item.name) {
                        result = item.name;
                    }
                    else {
                        result = item.resource.name;
                    }
                    return result;
                }
            },{
                name: i18n("Types"),
                field: "types",
                formatter: function(item, result, domNode) {
                    var returnValue = "";
                    if (item.resourceRoles) {
                        array.forEach(item.resourceRoles, function(role) {
                            if (role !== null) {
                                returnValue += role.name;
                            }
                            else {
                                var type = "Standard " + self.resourceType;
                                returnValue += i18n(type);
                            }
                            returnValue += ", ";
                        });
                        //strip the last ", " from the string.
                        returnValue = returnValue.substring(0, returnValue.length - 2);
                    }
                    return returnValue;
                }
            }];

            this.table = new TreeTable({
                url: bootstrap.restUrl + "/team/" + self.team + "/resourceMappings/" + self.resourceType,
                columns: gridLayout,
                serverSideProcessing: false,
                orderField: "name",
                tableConfigKey: "securedObjectsList",
                selectable: self.canEdit,
                isSelectable: function(item){
                    return true;
                },
                getTreeNodeId: function(data, parent){
                    var id = data.id;
                    if (data.resource && data.resource.id){
                        id = data.resource.id;
                    }
                    return id;
                },
                hideExpandCollapse: true
            });
            this.table.placeAt(this.tableAttach);
            domConstruct.place(this.toolbarAttach, this.table.aboveTreeOptions);

            if (this.canEdit){
                var actionsButton = new MenuButton({
                    options: [{
                        label: i18n("Remove From Team"),
                        onClick: function(evt){
                            self.removeSelectedItems(self.table.getSelectedItems());
                        }
                    }],
                    label: i18n("Actions...")
                });
                actionsButton.placeAt(this.addSecureResourceAttach);

                var onSelectChange = function() {
                    var selectCount = self.table.getSelectedItems().length;
                    if (selectCount === 0) {
                        actionsButton.set("label", i18n("Actions..."));
                        actionsButton.set("disabled", true);
                    }
                    else {
                        actionsButton.set("label", i18n("Actions... (%s)", selectCount));
                        actionsButton.set("disabled", false);
                    }
                };
                this.table.on("selectItem", onSelectChange);
                this.table.on("deselectItem", onSelectChange);
                this.table.on("displayTable", onSelectChange);
            }
        },

        getChildren: function(children){
            var self = this;
            var results = [];
            array.forEach(children, function(item){
                if (item.children){
                    var childrenId = self.getChildren(item.children);
                    array.forEach(childrenId, function(childId){
                        results.push(childId);
                    });
                }
                    var id = "";
                    if (item.resource){
                        id = item.resource.id;
                    }
                    else if (item.id){
                        id = item.id;
                    }
                    results.push(id);

            });
            return results;
        },

        removeSelectedItems: function(items){
            var self = this;
            var dataArray = [];
            var dataObject = {};
            array.forEach(items, function(item){
                var id = "";
                if (item.resource){
                    id = item.resource.id;
                }
                else if (item.id){
                    id = item.id;
                }
                if (item.children){
                    var childrenId = self.getChildren(item.children);
                    array.forEach(childrenId, function(childId){
                        if (!dataObject[childId]){
                            dataObject[childId] = true;
                            dataArray.push(childId);
                        }
                    });
                }
                // Prevent duplicates from removing a parent element and children.
                if (!dataObject[id]){
                    dataObject[id] = true;
                    dataArray.push(id);
                }
            });
            var data = {resources: dataArray};
            if (!items.length) {
                var alert = new Alert({
                    message: i18n("Please select at least one resource to remove.")
                });
                alert.startup();
            }
            else {
                var confirm = new GenericConfirm({
                    message: i18n("Are you sure you want to remove the selected objects from this team?"),
                    action: function() {
                        xhr.del({
                            url: bootstrap.restUrl + "/team/" + self.team + "/batchResourceMappings",
                            headers: { "Content-Type": "application/json" },
                            putData: JSON.stringify(data),
                            load: function() {
                                self.table.refresh();
                                self.table.setCheckboxState(false);
                            },
                            error: function(error) {
                                var errorDialog = new Dialog({
                                    title: i18n("Error removing object"),
                                    content: error.responseText,
                                    closable: true,
                                    draggable: true
                                });
                                self.table.unblock();
                                self.table.refresh();
                                errorDialog.show();
                            }
                        });
                    }
                });
            }
        },

        showForm: function() {
            var self = this;
            this.form = new ColumnForm({
                submitUrl: bootstrap.restUrl + "/team/" + self.team + "/batchResourceMappings",
                cancelLabel: null,
                showButtons: false,
                addData: function(data) {
                    data.resources = data.resources.split(",");
                    data.resourceRole = self.typeSelect.get("value");
                    if (data.resourceRole === "standard") {
                        data.resourceRole = null;
                    }
                },
                postSubmit: function() {
                    self.table.refresh();
                    self.addSecureResource._setValueAttr();
                }
            });

            this.addSecureResource = new DialogMultiSelect({
                url: bootstrap.restUrl + "/team/" + self.team + "/unmappedResources/" + self.resourceType,
                getLabel: function(item) {
                    return item.name;
                },
                getValue: function(item) {
                    return item.id;
                },
                onClose: function() {
                    self.form.submitForm();
                },
                noSelectionsLabel: i18n("None Selected")
            });
            this.form.addField({
                name: "resources",
                widget: self.addSecureResource
            });

            this.typeSelect = new Select();
            this.typeSelect.on("change", function(){
                self.addSecureResource.url = bootstrap.restUrl + "/team/" + self.team + "/unmappedResources/" + self.resourceType;
                + self.team + "/unmappedResources/" + self.resourceType;
                if (self.typeSelect.value !== "standard") {
                    self.addSecureResource.url += "/" + self.typeSelect.value;
                }
            });
            this.typeSelect.placeAt(this.typeSelectAttach);

            this.addButton = new Button( {
                label: i18n("Add"),
                onClick: function() {
                    self.addSecureResource.fieldAttach.onclick();
                }
            });
            domClass.add(this.addButton.domNode, "idxButtonSpecial idxButtonCompact");
            if (this.canEdit){
                domConstruct.place(this.addButton.domNode, this.addSecureResourceAttach, "first");
            }

            this.refreshTypeSelect();

        },

        refreshTable: function() {
            this.table.url = bootstrap.restUrl + "/team/" + this.team + "/resourceMappings/" + this.resourceType;
            this.table.refresh();
        },

        /**
         *
         */
        destroy: function() {
            this.inherited(arguments);
            this.table.destroy();
        },

        refreshTypeSelect: function() {
            var self = this;
            xhr.get({
                url: bootstrap.restUrl + "/resourceType/" + self.resourceType + "/resourceRoles",
                handleAs: "json",
                load: function(data) {
                    var label = "Standard " + self.resourceType;
                    var oldOptions = self.typeSelect.getOptions();
                    array.forEach(oldOptions, function(item) {
                        self.typeSelect.removeOption(item.value);
                    });
                    self.typeSelect.addOption({
                        "value": "standard",
                        "label": i18n(label)
                    });
                    array.forEach(data, function(item) {
                        self.typeSelect.addOption({
                            "value": item.id,
                            "label": item.name
                        });
                    });
                }
            });

        }
    });
});
