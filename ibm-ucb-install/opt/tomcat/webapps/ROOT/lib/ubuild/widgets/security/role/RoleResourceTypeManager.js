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
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/dom-construct",
        "js/webext/widgets/TwoPaneListManager",
        "js/webext/widgets/PopDown",
        "ubuild/security/role/RoleDefaultActions",
        "ubuild/security/role/RoleResourceTypeGrid"
        ],
function(
        array,
        declare,
        xhr,
        domConstruct,
        TwoPaneListManager,
        PopDown,
        RoleDefaultActions,
        RoleResourceTypeGrid
) {
    /**
     *
     */
    return declare("ubuild/widgets/security/role/RoleResourceTypeManager", [TwoPaneListManager], {
        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;
            
            this.showList();
        },
        
        /**
         * 
         */
        showList: function(selectedId) {
            var self = this;

            this.defaultSelectionId = selectedId;

            xhr.get({
                url: bootstrap.restUrl + "/resourceType",
                handleAs: "json",
                load: function(data) {
                    var totalEntries = data.length;
                    
                    array.forEach(data, function(entry) {
                        var itemDiv = document.createElement("div", {
                            style: {
                                position: "relative"
                            }
                        });
                        //itemDiv.style.position = "relative";
                        
                        var itemDivLabel = document.createElement("div");
                        itemDivLabel.className = "twoPaneEntryLabel";
                        itemDivLabel.innerHTML = entry.name.escape();
                        itemDiv.appendChild(itemDivLabel);
                        
                        self.addEntry({
                            id: entry.id,
                            label: i18n(entry.name),
                            domNode: itemDiv,
                            action: function() {
                                self.selectEntry(entry);
                            }
                        });
                    });
                }
            });
        },
        
        /**
         * 
         */
        refresh: function(newId) {
            var selectedId = newId || this.selectedEntry.id;
            
            this.clearDetail();
            this.clearList();
            this.showList(selectedId);
        },
        
        /**
         * Clear out the detail pane and put this component's information there.
         */
        selectEntry: function(entry) {
            var self = this;

            domConstruct.create("h2", {
                innerHTML: i18n("Permissions Granted to Role Members"),
                className: "widgetHeader"
            }, self.detailAttach);
            
            if (entry.name === "Web UI" || entry.name === "Server Configuration") {
                var roleDefaults = new RoleDefaultActions({
                    role: self.role,
                    resourceType: entry
                });
                roleDefaults.placeAt(this.detailAttach);
                self.registerDetailWidget(roleDefaults);
            }
            else {
                var roleTypeGrid = new RoleResourceTypeGrid({
                    role: self.role,
                    resourceType: entry
                });
                roleTypeGrid.placeAt(this.detailAttach);
                self.registerDetailWidget(roleTypeGrid);
            }
        }
    });
});