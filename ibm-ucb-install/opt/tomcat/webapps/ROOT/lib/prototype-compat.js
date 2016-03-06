/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/


/**
 * Remove prototype globals that confuse other libraries such as Dojo or YUI2
 */
(function(){
    var removeProperty;

    /**
     * Remove a property from an object and its prototype chain
     */
    removeProperty = function(it, propName) {
        if (it) {
            // best way to remove a property is to `delete` it from the object
            if (it.hasOwnProperty) {
                if (it.hasOwnProperty(propName)) {
                    delete it[propName];
                }
            }
            else {
                // IE7 doesn't have hasOwnProperty on document and prevents delete calls on document attributes
                // This feels like a hack, but looks like the only solution
                if (Object.prototype.hasOwnProperty.call(it,propName)) {
                    it[propName] = undefined;
                }
            }

            // go up the chain searching for property to remove
            removeProperty(it.prototype, propName);
        }
    };

    // these prototype methods conflict with dojo drag-and-drop support
    var removeOn = function(it) {
        removeProperty(it, 'on');
    };
    removeOn(window.Element.Methods);
    removeOn(window.HTMLElement);
    removeOn(window.Element);
    removeOn(window.document);
    removeOn(window.document.body);
    removeOn(window.Event);

    // these prototype methods conflict with YUI. Datatable.js expects this to be YAHOO.util.Selector
    removeProperty(window, 'Selector');
}());