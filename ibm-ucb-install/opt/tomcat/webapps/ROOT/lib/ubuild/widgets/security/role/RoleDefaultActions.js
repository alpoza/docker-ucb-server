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
        "dijit/form/CheckBox",
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/xhr",
        "dojo/json",
        "js/util/blocker/_BlockerMixin",
        "js/webext/widgets/Alert",
        "js/webext/widgets/FieldList"
        ],
function(
        _TemplatedMixin,
        _Widget,
        CheckBox,
        array,
        declare,
        xhr,
        JSON,
        _BlockerMixin,
        Alert,
        FieldList
) {
    /**
     *
     */
    return declare([_Widget, _TemplatedMixin, _BlockerMixin], {
        templateString:
            '<div class="roleDefaultActions">'+
                '<div data-dojo-attach-point="actionsAttach"></div>'+
            '</div>',

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;
            
            this.fieldList = new FieldList();
            this.fieldList.placeAt(this.actionsAttach);
            
            xhr.get({
                url: bootstrap.restUrl + "/role/" + self.role.id + "/actionMappings",
                handleAs: "json",
                load: function(actionMappings) {
                    self.role.actions = actionMappings;

                    xhr.get({
                        url: bootstrap.restUrl + "/resourceType/" + self.resourceType.name + "/actions",
                        handleAs: "json",
                        load: function(actions) {
                            self.showCheckboxes(actions);
                        }
                    });
                }
            });
        },
        
        /**
         * 
         */
        showCheckboxes: function(actions) {
            var self = this;
            
            array.forEach(actions, function(action) {
                var hasAction = false;
                array.forEach(self.role.actions, function(roleAction) {
                    if (roleAction.action.name === action.name) {
                        hasAction = true;
                    }
                });
                
                var check = new CheckBox({
                    label: action.name,
                    checked: hasAction,
                    onChange: function(value) {
                        var putData = {
                            resourceType: self.resourceType.name,
                            action: action.name
                        };
                        
                        self.block();

                        if (value) {
                            xhr.post({
                                url: bootstrap.restUrl + "/role/" + self.role.id + "/actionMappings",
                                handleAs: "json",
                                putData: JSON.stringify(putData),
                                load: function(data) {
                                    self.unblock();
                                },
                                error: function(data) {
                                    self.unblock();
                                    var alert = new Alert({
                                        message: data.responseText
                                    });
                                }
                            });
                        }
                        else {
                            xhr.del({
                                url: bootstrap.restUrl + "/role/" + self.role.id + "/actionMappings",
                                handleAs: "json",
                                putData: JSON.stringify(putData),
                                load: function(data) {
                                    self.unblock();
                                },
                                error: function(data) {
                                    self.unblock();
                                    var alert = new Alert({
                                        message: data.responseText
                                    });
                                }
                            });
                        }
                    }
                });
                self.fieldList.insertField(check, null, action.description);
            });
        },

        /**
         * 
         */
        destroy: function() {
            this.inherited(arguments);
            this.fieldList.destroy();
        }
    });
});