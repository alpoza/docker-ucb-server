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
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/_base/array",
        "dojo/dom-construct",
        "dojo/on",
        "ubuild/security/resourceRole/ResourceRoleList",
        "js/webext/widgets/GenericConfirm",
        "js/webext/widgets/PopDown",
        "js/webext/widgets/TwoPaneListManager"
        ],
function(
        declare,
        xhr,
        array,
        domConstruct,
        on,
        ResourceRoleList,
        GenericConfirm,
        PopDown,
        TwoPaneListManager
) {
    /**
     *
     */
    return declare('ubuild/widgets/security/resourceRole/ResourceRoleManager',  [TwoPaneListManager], {
        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;
            
            xhr.get({
                url: bootstrap.restUrl + "/resourceType",
                handleAs: "json",
                load: function(data) {
                    array.forEach(data, function(entry) {
                        self.addEntry({
                            id: entry.id,
                            label: i18n(entry.name),
                            action: function() {
                                self.showResourceRoles(entry);
                            }
                        });
                    });
                }
            });
        },
        
        /**
         * 
         */
        showResourceRoles: function(type) {
            var self = this;
            
            var heading = document.createElement("div");
            heading.className = "containerLabel";
            heading.style.padding = "10px";
            heading.innerHTML = i18n("%s Types", i18n(type.name.escape()));
            self.detailAttach.appendChild(heading);

            var resourceRoleList = new ResourceRoleList({resourceType: type});
            resourceRoleList.placeAt(self.detailAttach);
            
            self.registerDetailWidget(resourceRoleList);
        }
    });
});
