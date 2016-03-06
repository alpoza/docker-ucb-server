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
        "dojo/_base/xhr",
        "ubuild/rightPanel/RightPanel",
        "ubuild/resource/EditResource",
        "dojo/dom-class",
        "dojo/dom-style",
        "dojo/dom-construct",
        "dojo/dom-geometry",
        "dojo/on",
        "dijit/form/CheckBox",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/ColumnForm",
        "js/webext/widgets/table/TreeTable"
        ],
        function(
            declare,
            baseXhr,
            RightPanel,
            EditResource,
            domClass,
            domStyle,
            domConstruct,
            geo,
            on,
            CheckBox,
            Dialog,
            ColumnForm,
            TreeTable
        ){
    /**
     * Resource Right Panel
     * 
     * Widget for displaying a hovering side panel on the right side of the window with a table.
     * 
     * Use: new ResourceRightPanel(options{});
     * 
     * options: {
     *  header: (string) The header title of the right panel.
     *  subheader: (string) The subheader or description text of the right panel.
     *  width: (integer) The width of the right panel. Default is 500px;
     *  titleContent: (domNode) Any additional domNode to add to the header.
     *  content: (domNode) The content to display in the right panel.
     *  defaultSpeed: (integer) The default speed for the animation show/hide. Default is 180.
     *  slowSpeed: (integer) The slowest speed for the animation show/hide. Default is 1000.
     *  url: REST url to load data into the table.
     *  showCheckbox: Show an options checkbox to use as a flag for drop events. Default: true. Can also use a string to change the checkbox label.
     *  getColumns: Function that returns the columns to display for the table.
     *  onDrop: function to run when item is drop. (Enables drag and drop if defined)
     * }
     */
    return declare('ubuild.widgets.resource.ResourceRightPanel',  [RightPanel], {
        
        url: null,
        showCheckbox: true,
        
        postCreate: function() {
            this.inherited(arguments);
            this.loadTable();
            this._buildPanel();
            if (this.attachPoint){
                this.placeAt(this.attachPoint);
            }
        },
        
        /**
         * Returns the columns for the table to use.
         */
        getColumns: function(){
            // no-op by default
        },
        
        /**
         * Refreshes the contents of the table.
         */
        refresh: function(){
            if (this.table){
                this.table.refresh();
            }
        },
        
        /**
         * Builds and loads a table provided a url.
         */
        loadTable: function(){
            var _this = this;
            if (this.url){
                this.table = new TreeTable({
                    url: _this.url,
                    serverSideProcessing: false,
                    orderField: "name",
                    sortType: "desc",
                    noDataMessage: _this.noDataMessage || i18n("No resources found"),
                    tableConfigKey: "rightPanelList",
                    selectorField: "id",
                    columns: _this.getColumns(),
                    hideExpandCollapse: true,
                    hidePagination: false,
                    selectable: false,
                    draggable: _this.onDrop ? true : false,
                    onDrop: function(sources, target, node){
                        // This function and the on drop function (in ResourceTree.js) run at the same time.
                        // which sets the target needed for the item being dropped.
                        setTimeout(function(){
                            _this.onDrop(sources, target, node);
                        }, 100);
                    },
                    onDisplayTable: function(){
                        _this.table.dndContainer.checkAcceptance = function(){
                            return false;
                        };
                    }
                });
                this.content = this.table.domNode;
            }
            if (this.showCheckbox){
                this.showOptionsBox();
            }
        },
        
        /**
         * Additional checkBox in the right panel.
         */
        showOptionsBox: function(){
            var _this = this;
            // Building the options check box to use as a flag to determine if options dialog is shown on item drop.
            this.titleContent = domConstruct.create("div", {
                className: "show-drop-options"
            });
            this.checkBox = new CheckBox({
                name: "dropOptions",
                checked: false
            });
            this.checkBox.placeAt(this.titleContent);
            var label = (typeof this.showCheckbox === "string") ? this.showCheckbox : i18n("DndShowOptions");
            var optionsCheckboxLabel = domConstruct.create("label", {
                "for": _this.checkBox.id,
                innerHTML: label
            });
            domConstruct.place(optionsCheckboxLabel, this.titleContent);
        },
        
        /**
         * Function called when item is dropped from the table in the right panel.
         */
        onDrop: function(sources, target, node){
            // no-op by default
        },
        
        /**
         * Helper function in building status columns.
         */
        statusFormatter: function(item, value, cell) {
            var resultDiv = document.createElement("div");
            resultDiv.style.textAlign = "center";
            
            if (item.status === "ONLINE") {
                resultDiv.innerHTML = i18n("Online");
                cell.style.backgroundColor = "#8DD889";
            }
            else if (item.status === "CONNECTED") {
                resultDiv.innerHTML = i18n("Connected");
                cell.style.backgroundColor = "#C8C86F";
            }
            else {
                resultDiv.innerHTML = i18n("Offline");
                cell.style.backgroundColor = "#C86F6F";
            }
            return resultDiv;
        },

        /**
         * When dropping onto a resource, save data on drop or show a edit resource dialog.
         *  @param type: data name of resource being saved.
         *  @param parent: the parent element of the resource being saved.
         *  @param value: the data of the resource being saved.
         *  @param showDialog: Show a dialog when dropping on a resource.
         */
        submitData: function(type, parent, value, showDialog, refresh){
            var _this = this;
            // Shows a dialog if item is dropped onto a resource.
            if (showDialog){
                var newResourceDialog = new Dialog({
                    title: i18n("Create New Resource"),
                    closable: true,
                    draggable:true
                });
                // A refresh function to call after resource has been successfully added.
                var onSubmit = function(){
                    newResourceDialog.hide();
                    newResourceDialog.destroy();
                    _this.parent.grid.refresh();
                    _this.table.refresh();
                };
                var newResourceForm = new EditResource({
                    parent: parent,
                    type: type,
                    callback: function() {
                        onSubmit();
                    },
                    selectedValue: value
                });
                newResourceForm.placeAt(newResourceDialog.containerNode);
                newResourceDialog.show();
            }
            else {
                var form = new ColumnForm({
                    submitUrl: bootstrap.restUrl + "resource/resource",
                    readOnly: _this.readOnly,
                    postSubmit: function(data) {
                        if (_this.parent && _this.parent.grid) {
                            _this.table.refresh();
                            // Somehow, the table doesn't refresh instantly, so adding a slight timeout.
                            // If data doesn't show after drop, user can click the refresh button;
                            setTimeout(function() {
                                _this.parent.grid.refresh();
                                _this.parent.grid.expand(parent);
                            }, 100);
                        }
                    },
                    addData: function(data) {
                        if (parent) {
                            data.parentId = parent.id;
                        }
                    },
                    onCancel: function() {
                        if (_this.callback !== undefined) {
                            _this.callback();
                        }
                    }
                });
                form.addField({
                    name: "name",
                    value: value.name,
                    type: "Invisible"
                });
                form.addField({
                    name: type + "Id",
                    value: value.id,
                    type: "Invisible"
                });
                form.submitForm();
            }
        }
    });
});