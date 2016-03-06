/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/**
 *
 * This Class assumes that the current page have a sibling url 'updateDerivedPropertiesAjax'.
 * @see com.urbancode.ubuild.web.project.WorkflowPropertyTaskHelper for an  implementation helper
 */
var UC_WORKFLOW_PROPS = Class.create({

    /**
     * Constructor
     */
    initialize: function(form, options) {
        this._form         = $(form);
        this._input2derivedinputs = new Hash();

        this.FIELD_CONTAINER_SELECTOR = 'tr';
        this.UPDATE_DERIVED_PROPERTY_VALUES_URL = 'updateDerivedPropertiesAjax';

        this.attachEventListeners();
    },

    /**
     * Locate all source inputs for derived values and attach event listeners to those to detect when we need to
     * update derived values.
     */
    attachEventListeners: function() {
        var self = this;
        this._form.select('.derivedSourceProperty select').each(function(input){
            input.observe('change', function(){self.updateDerived(new Array(input.name));})
        });
        this._form.select('.derivedSourceProperty input[type="checkbox"]').each(function(input){
            input.observe('click', function(){self.updateDerived(new Array(input.name));})
        });
    },

    /**
     * 1) Take a collection of property names
     * 2) Post that list and the current form state to server
     * 3) Process result from server to update visibility and/or content of returned property field names.
     *
     * @param updatedFieldNames the collection of property names which have had their form values changed
     */
    updateDerived: function(updatedFieldNames) {
        var self = this;

        // does this work for multiple values, or do we need to do something like comma-separated updatedFieldNames?
        var params = self._form.serialize({'hash':true});
        params['updatedPropName'] = updatedFieldNames;

        new Ajax.Request(self.UPDATE_DERIVED_PROPERTY_VALUES_URL, {
            'asynchronous': true,
            'method':       'post',
            'parameters':   params,
            'onSuccess': function(response){
                var json = response.responseJSON;
                if (json) {
                    var selectValues = json.fieldStates;
                    self.updateForm(selectValues);
                }
                else {
                    alert(response.responseText); // TODO
                }
            },
            'onFailure': function(response){
                var alertMessage = response.statusText || response.responseText
                alert(alertMessage);
            },
            'onException': function(request,t){throw t;} // propagate any exceptions to JS-console
        });
    },

    /**
     *
     * An entry in the map with a null or empty value indicates that the corresponding field should be hidden.
     * An entry in the map with a collection of string values indicates the field should be visible and what is the set
     * of allowed values.
     *
     * @param name2allowedValues a hash of property names to the set of allowed values for those fields
     */
    updateForm: function(name2allowedValues) {
        var self = this;
        name2allowedValues = $H(name2allowedValues);

        name2allowedValues.each(function(pair) {
            var input = self.findFormElement(pair.key);
            if (input == undefined) {
                alert(i18n('PropertyInputNotFoundForName', pair.key));
            }
            else {
                var type = input.tagName.toUpperCase();
                if (type == 'INPUT' ) {
                    type = input.type.toUpperCase();
                }

                if (type == 'SELECT') {
                    self.updateSelectState(input, pair.value);
                }
                else if (type == 'TEXT' || type == 'TEXTAREA') { // TODO secure?
                    self.updateTextualFieldState(input, pair.value);
                }
                else if (type == 'CHECKBOX') {
                    self.updateCheckboxFieldState(input, pair.value);
                }
                else {
                    alert(i18n('UnknownFieldType', type));
                }
            }
        });
    },

    /**
     *
     * @param selectElement the select/multi-select element to update
     * @param state a collection of the allowed values for this element (null indicates the select element is not a valid field)
     */
    updateSelectState: function(selectElement, state) {
        var self = this;
        var newAllowedValues = $A(state); // $A(null) returns empty Array
        var container = selectElement.up(self.FIELD_CONTAINER_SELECTOR);

        var enabled = newAllowedValues.size() > 0;

        // collect currently selected values
        var selectedOptions = $A(selectElement.options).findAll(function(opt){return opt.selected });
        var selectedValues = selectedOptions.collect(function(it){return it.value});

        // Create list of new Option elements
        var newOptions = new Array();
        var nothingSelected = true;
        newAllowedValues.each(function(value){
           var option = new Element("option", {'value':value}).update(value);
           if (selectedValues.find(function(it){return value == it}) !== undefined) {
               option.selected=true;
               option.defaultSelected=true;
               nothingSelected = false;
           }
           newOptions.push(option);
        });
        if (!selectElement.multiple) {
            // insert the empty-selection with appropriate label if needed
            var required = selectElement.hasClassName('required');
            if (nothingSelected || !required) {
                var makeSelectOption = new Element("option", {'value':''});
                if (required) {
                    makeSelectOption.update('-- ' + i18n('MakeSelection') + ' --');
                }
                else {
                    makeSelectOption.update('-- ' + i18n('None') + ' --');
                }
                makeSelectOption.selected = nothingSelected;
                newOptions.reverse().push(makeSelectOption)
                newOptions.reverse();
            }
        }

        // remove excess options then append/replace new options to element
        for (i = newOptions.size(); i < selectElement.options.length; i++) {
            selectElement.remove(i);
        }
        newOptions.each(function(option, index){selectElement.options[index] = option});

        // enabled+show/disable+hide input as needed
        if (enabled) {
           container.show();
           selectElement.disabled = false;
        }
        else {
           container.hide();
           selectElement.disabled = true;
        }
    },

    /**
     *
     * @param textElement a text, textarea, or secure input element
     * @param state is a string or null (null hides/disables the input)
     */
    updateTextualFieldState: function(textElement, state) {
        var self = this;
        var container = textElement.up(self.FIELD_CONTAINER_SELECTOR);

        if (state != null) {
            if (textElement.defaultValue == textElement.value) {
                textElement.value = state;
            }
            textElement.defaultValue = state;
            textElement.disabled = false;
            container.show();
        }
        else {
            textElement.value = '';
            textElement.defaultValue = '';
            textElement.disabled = true;
            container.hide();
        }
    },

    /**
     *
     * @param checkboxElement a checkbox input element
     * @param state is a boolean or null (null hides/disables the input)
     */
    updateCheckboxFieldState: function(checkboxElement, state) {
        var self = this;
        var container = checkboxElement.up(self.FIELD_CONTAINER_SELECTOR);

        if (state != null) {
            if (checkboxElement.defaultChecked == checkboxElement.checked) {
                checkboxElement.checked = state;
            }
            checkboxElement.defaultChecked = state;
            checkboxElement.disabled = false;
            container.show();
        }
        else {
            checkboxElement.checked = false;
            checkboxElement.defaultChecked = false;
            checkboxElement.disabled = true;
            container.hide();
        }
    },

    /**
     * Utility to locate the form element with the given name within the form.
     * @param the name of a property
     * @return the form element corresponding to the property (null if can not be located)
     */
    findFormElement: function(name) {
        var self = this;
        return self._form.down('*[name="property:'+name+'"]'); // TODO escape special chars in pair.key
    }
});