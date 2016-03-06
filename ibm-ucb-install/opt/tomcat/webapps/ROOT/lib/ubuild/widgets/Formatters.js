/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global i18n, define */

define(["dojo/_base/array",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/dom-style"
        ],
function(array,
        domClass,
        domConstruct,
        domStyle) {
    return {
        
        /**
         *
         */
        resourceLinkFormatter: function(item) {
            var result = document.createElement("div");
            if (item) {
                domConstruct.place(this.getResourceIcon(item), result);

                var readOnly = item.security && !item.security.read;
                if (item.role && item.role.name === "Agent Placeholder") {
                    readOnly = true;
                }
                
                if (readOnly) {
                    domConstruct.create("span", {
                        innerHTML: item.name.escape()
                    }, result);
                }
                else {
                    var resourceLink = document.createElement("a");
                    resourceLink.innerHTML = item.name.escape();
                    resourceLink.href = "#resource/" + item.id;
                    result.appendChild(resourceLink);
                }
            }
    
            if (item.agent || item.agentPool) {
                domConstruct.place(this.resourceParentFormatter(item), result);
            }

            return result;
        }
    };
});