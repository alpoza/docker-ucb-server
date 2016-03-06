/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/**
 *  This Class is for our Custom Property Forms.
 */
var UC_CustomPropertyForm = Class.create({

    /**
     * Constructor
     * @param form the UCPropertyForm element to attach to
     * @param options a map containing various configuration flags.
     *         maxNameLength:       the maximum length for property names (default 255)
     *         maxValueLength:      the maximum length for property values (default 4000)
     */
    // Possible fields are:
    //     A name
    //     B description
    //     C secure
    //     D value
    //
    initialize: function(form, options) {
        var self = this; // local variable for event closures to reference so that methods work correctly
        options = options || {}; // ensure empty set of options for default

        this._form = $(form);
        this._newPropCounter = 0;

        this._iconDel = options.imgUrl + '/icon_delete.gif';

        // attach javascript handlers to all inputs/controls
        this._attachPropertyListeners(this._form);
        this._form.observe('submit', function(event){ self.save(); event.stop(); } );
        this._form.down('input[name="Cancel"]').observe('click', function(event){ self.cancel(); event.stop(); } );

        // automatically clear save message if present
        var saveMessage = this._form.down('.saveMessage');
        if (saveMessage) {
            setTimeout(function(){saveMessage.remove();}, 5000);
        }

        this._maxNameLength  = options['maxNameLength']  || 255;
        this._maxValueLength = options['maxValueLength'] || 4000;
        this._maxDescriptionLength = options['maxDescriptionLength'] || 4000;
    },

    /**
     * Changes which tab is the "current" tab
     */
    changeTab: function(tab) {
        tab = $(tab);
        var tabList = tab.up();

        var tabIndex = tab.previousSiblings().length;
        var tabContent = this._form.down('.properties-section', tabIndex);

        // change selected tab
        tabList.childElements().each(function(tmpTab){ tmpTab.removeClassName('current'); });
        tab.addClassName('current');

        // change displayed content
        this._form.select('.properties-section').each(function(section){ section.hide(); });
        tabContent.show();
    },

    /**
     * Generate a property row for a new property
     */
    _addPropertyRow: function (propertySection, append, propName, isSecureDefault) {
        this._formChanged();
        var self = this;
        this._newPropCounter--;
        propertySection = $(propertySection);

        // some strange BUG preventing propertySection.down('tbody') from working on project page (FF3.5, Safari4, possibly others)
        var table = propertySection.down().next();
        var tbody = table.down().next();

        var newRow = new Element('tr').addClassName('newProperty');

        var nameParam        = 'prop-name:'+(this._newPropCounter);
        var descParam        = 'prop-desc:'+(this._newPropCounter);
        var secureParam      = 'prop-secure:'+(this._newPropCounter);
        var valueParam       = 'prop-value:'+(this._newPropCounter);

        // NAME CELL
        var nameCell = new Element('td');
        nameCellAttributes = {name: nameParam, size: 20};
        if (append) {
            nameCellAttributes.type = 'text';
            nameCellAttributes['class'] = 'input';
        } else {
            nameCellAttributes.type = 'hidden';
            nameCellAttributes.value = propName;
        }
        nameCell.insert(new Element('input', nameCellAttributes));
        newRow.insert(nameCell);

        // VALUE CELL
        var valueCell = new Element('td');
        if (isSecureDefault) {
            valueCell.insert(
                    new Element('div')
                    .update(i18n('SecureWithColon') + ' ')
                    .insert(new Element('input', {type:'checkbox', checked: true, name:secureParam, value:'true', style:'border:none'}).addClassName('checkbox'))
                    );
            valueCell.insert(new Element('input', {type: 'password', name:valueParam, size:30}).addClassName('input').addClassName('hasConfirm'));
            valueCell.insert(
                    new Element('div', {style:'padding-top: 5px;'})
                    .addClassName('confirmPasswordSection')
                    .insert(new Element('span', {style:'font-size: smaller'}).update(i18n('Confirm') + '<br/>'))
                    .insert(new Element('input', {type:'password', size:30, autocomplete:'off', name:(valueParam+'Confirm')}).addClassName('input'))
                    );
            newRow.insert(valueCell);
        } else {
            valueCell.insert(
                    new Element('div')
                    .update(i18n('SecureWithColon') + ' ')
                    .insert(new Element('input', {type:'checkbox', name:secureParam, value:'true', style:'border:none'}).addClassName('checkbox'))
                    );
            valueCell.insert(new Element('textarea', {name:valueParam, rows:1, cols:30}).addClassName('input'));
            valueCell.insert(
                    new Element('div', {style:'padding-top: 5px;'})
                    .addClassName('confirmPasswordSection')
                    .insert(new Element('span', {style:'font-size: smaller'}).update(i18n('Confirm') + '<br/>'))
                    .insert(new Element('input', {type:'password', size:30, autocomplete:'off', name:(valueParam+'Confirm')}).addClassName('input'))
                    .hide()
                    );
        }

        newRow.insert(valueCell);

        // DESCRIPTION CELL
        var fieldDisplayLength = 30;
        var descriptionCell = new Element('td');
        descriptionCell.insert(new Element('textarea', {name:descParam, rows:1, cols: fieldDisplayLength}).addClassName('input'));
        newRow.insert(descriptionCell);

        // ACTIONS CELL
        var actionCell = new Element('td', {align:'center'});
        var removeLink = new Element('a', {title: i18n('Remove'), href:'#'});
        removeLink.insert(new Element('img', {alt:'', style:'border:none', src:this._iconDel}));
        actionCell.insert(removeLink);
        removeLink.className = 'removeButton';
        newRow.insert(actionCell);

        return {
            newRow: newRow,
            tbody: tbody
        };
    },


    /**
     * Adds a new custom property to the specified property section
     */
    addProperty: function (propertySection) {
        var self = this;
        var result = self._addPropertyRow(propertySection, true);

        var tbody = $(result['tbody']);
        var newRow = $(result['newRow']);

        tbody.insert({bottom:newRow});

        // must be done after row is added to DOM.
        this._attachPropertyListeners(newRow);

        this._updateNoPropsRow(tbody);
    },


    /**
     * Remove and mark-for-deletion the specified property row
     */
    removeProperty: function(propRow) {
        var self = this;
        this._formChanged();
        var tbody = propRow.up();

        if (propRow.hasClassName('newProperty')) {
            // row is new
            propRow.remove();
        } else  {
            // row is an existing property
            //hide entire row
            propRow.hide();

            var valueInput = propRow.down('*[name^="prop-value:"]');
            var propSuffix = self._substringAfter(valueInput.name, ':');
            valueInput.value = '';
            valueInput.insert({after:new Element('input', {'name':'prop-del:'+propSuffix, 'value':'true'})});
            propRow.addClassName('deletedProperty');
        }
        this._updateNoPropsRow(tbody);
    },

    /**
     * Cancel all changes made to the form and revert back to its original state
     */
    cancel: function(){
        var self = this;
        self._form.select('tr.newProperty').each(function(row) {row.remove();});
        self._form.select('tr.deletedProperty').each(function(row) {
            row.removeClassName('deletedProperty').show();
        });
        self._form.select('input[name^="prop-del:"]').each(function(input){input.remove();});
        self._form.reset();
        self._form.select('.confirmPasswordSection').each(function(confirmSection){confirmSection.hide();});

        self._updateErrors(null);

        // reset noprops rows for each section
        self._form.select('.no-props').each(function(noProps){self._updateNoPropsRow(noProps.up('tbody'));});

        self._form.removeClassName('changed');
        self._form.down('.editButtons').hide();
        self._form.down('.doneButtons').show();
    },

    /**
     * Submit the form.  First perform validation and then Post changes to the server only if no errors were detected.
     */
    save: function(){
        var self = this;

        var formErrors = {message:i18n("CorrectErrors"), fields: new Array()};
        var valid = true;

        // CLIENT-SIDE VALIDATE
        if (!this._validateForm()) {
           return;
        }

        var selectedTab = self._form.down('.current');
        var selectedTabId = selectedTab == null ? '' : selectedTab.id;

        // POST TO SERVER
        this._form.request({
            parameters: {'selectedTabId':selectedTabId},
            onSuccess: function(resp) {
                // Maybe we should use json for both errors and success (use an hasErrors field or something to distinguish)
                if (resp.responseJSON) { // errors were found!!
                    self._updateErrors(resp.responseJSON);
                }
                else {
                    var contentType = resp.getHeader('Content-Type').split(';')[0];
                    switch (contentType.toLowerCase()) {
                        case 'text/javascript':
                            // successfully saved!!
                            // do nothing, prototype evaluates javascript automatically
                            break;
                        case 'text/plain':
                            // successfully saved!!
                            goTo(resp.responseText);
                            break;
                        default:
                            alert(i18n('UnknownResponseFromServerWithContent', contentType, resp.responseText));
                    }
                }
            },
            onFailure:   function(resp)  { alert(i18n('PropertiesSavingError')); },
            onException: function(req,e) { throw e;}
        });
    },

    //
    // Private API
    //  these methods are only called from other methods here, they are never used as event-handlers
    //  or invoked directly
    //

    /**
     * @return true if the form is believed to be valid, false otherwise (and attaches any error messages)
     */
    _validateForm: function() {
      var self = this;

      var formErrors = {message:i18n("CorrectErrors"), fields: new Array()};

      // 1) new custom props have names

      this._form.select('input[type="text"][name^="prop-name:"]').each(function(field){
        var noValue = (field.value == null || field.value == '');
        if (noValue) {
          formErrors.fields.push({fieldName: field.name, message:i18n('EnterName')});
        }
        else if (field.value.length > self._maxNameLength) {
          formErrors.fields.push({fieldName: field.name, message:i18n('NameFieldMaxNameLength', self._maxNameLength)});
        }
      });

      // 2) custom props have values (otherwise they should be deleted)

      this._form.select('*[name^="prop-value:"]').each(function(field){
        if (field.value.length > self._maxValueLength) {
            formErrors.fields.push({fieldName: field.name, message:i18n('NameFieldMaxValueLength', self._maxValueLength)});
        }
      });

      // 3) Check password confirmation fields

      this._form.select('input.hasConfirm').each(function(field){

          var value = self._getFieldValue(field);

          var confirmValue = null;
          var confirmSection = field.next('.confirmPasswordSection');
          if (confirmSection) {
              var confirmField = confirmSection.down('input');
              confirmValue = self._getFieldValue(confirmField);
          }

          if (value == field.defaultValue && confirmValue == null) {
              // this is OK, we maintain existing non-null password
          }
          else if (value != confirmValue) {
              formErrors.fields.push({fieldName: field.name, message:i18n('ValueConfirmationError')});
          }
      });

      // TODO 4) non-empty property names are unique (empty are caught by #1)

      // 5) custom props can have descriptions
      this._form.select('*[name^="prop-desc:"').each(function(field){
        if (field.value.length > self._maxDescriptionLength) {
          formErrors.fields.push({fieldName: field.name, message:i18n('DescriptionFieldMaxLength', self._maxDescriptionLength)});
            }
      });

      // Respond

      if (formErrors.fields.length > 0) {
        this._updateErrors(formErrors);
      }
      return formErrors.fields.length == 0;
    },

    /**
     * Updates the visibility of the no-props row for the given tbody
     */
    _updateNoPropsRow: function(tbody) {
        // determine if we need to show the "no properties" row
        var visibleRows = 0;
        tbody.childElements().each(function(row){
            if (!row.hasClassName('no-props') && !row.hasClassName('deletedProperty')) {
                visibleRows++;
            }
        });
        var noPropsRow = tbody.down('.no-props');

        if(visibleRows === 0) {
            noPropsRow.show();
        }
        else {
            noPropsRow.hide();
        }
    },

    /**
     * Attaches a change listener to each input of the given form. (which trigger the startEditing method)
     * Can only be called on elements already attached to the current document
     */
    _attachPropertyListeners: function(element) {
        element = $(element);

        var self = this;

        // attach change-tab listeners (if present)
        var changeTabClickEventHandler = function(event){ self.changeTab(event.findElement('li')); event.stop(); };
        element.select('.tabs li a').each(function(tabLink) {tabLink.observe('click', changeTabClickEventHandler);});

        // attach add-property links/buttons
        var addPropertyLinks = element.select('input[name="AddProperty"]');
        var addPropertyClickEventHandler = function(event){ self.addProperty(event.findElement('.properties-section'));  event.stop(); };
        addPropertyLinks.each(function(link){link.observe('click', addPropertyClickEventHandler);});

        // listeners for remove-property links
        var removeLinks =  element.select('a.removeButton').reverse(); // reverse list so that #pop operations are in original order
        var removeClickEventHandler = function(event){ self.removeProperty(event.findElement('tr')); event.stop(); };
        self.__chainCalls(function(link){link.observe('click', removeClickEventHandler);}, removeLinks);
        //removeLinks.each(function(link){link.observe('click', removeClickEventHandler);});

        // listeners for modifications to inputs
        var inputs = element.select('input', 'select', 'textarea').reverse(); // reverse list so that #pop operations are in original order
        self.__chainCalls(function(input){self._attachFormInputListeners(input);}, inputs);
        //inputs.each(function(input){self._attachFormInputListeners(input)});
    },

    /**
     * Attach the appropriate modification event listener to the given form element.
     * @param a form element (input[password,text,checkbox,radio], select, textarea)
     */
    _attachFormInputListeners: function(input) {
        var self = this;
        var type = input.type || input.tagName;

        if (type === 'text' || type === 'textarea' || type === 'password') {
            input.observe('keyup', function(event) {
                var changed = (input.value !== input.defaultValue);
                if (changed) {
                    self._formChanged();
                }

                if (changed && input.hasClassName('hasConfirm')) {
                    self._showPasswordConfirm(input);
                }

                self._expandTextArea(input);
            });

            self._expandTextArea(input);
        }
        else if (type.startsWith('select')) {
          input.observe('change', function(event) {
              var changed = (input.selectedIndex != input.defaultSelectedIndex);
              if (changed) {
                  self._formChanged();
              }
          });
        }
        else if (type == 'checkbox' || type=='radio') {
            input.observe('click', function(event) {
                var changed = (input.checked != input.defaultChecked);
                if (changed) {
                    self._formChanged();
                }

                if (input.name.startsWith('prop-secure:')) {
                    var valueInput = input.up('td').down('textarea[name^="prop-value:"], input[name^="prop-value:"]');

                    // IE can not change input.type attribute once inserted into DOM, so we have to replace the input

                    var valueType = valueInput.type || valueInput.tagName;
                    if (input.checked && valueType == 'textarea') {
                        var newValueInput = new Element('input', {type:'password', name:valueInput.name, size:30});
                        newValueInput.addClassName('input');
                        newValueInput.addClassName('hasConfirm');
                        newValueInput.value = valueInput.value;
                        valueInput.replace(newValueInput);
                        self._attachFormInputListeners(newValueInput);
                        self._showPasswordConfirm(newValueInput);
                    }
                    else if (!input.checked && valueType == 'password' ) {
                        var newValueInput = new Element('textarea', {name:valueInput.name, rows: 1, cols:30}).addClassName('input');
                        newValueInput.value = valueInput.value;
                        valueInput.replace(newValueInput);
                        self._attachFormInputListeners(newValueInput);
                        self._hidePasswordConfirm(newValueInput);
                    }
                }
            });
        }
        //else {
            // alert('unrecognized field '+input.name+' of type '+type)
        //}

    },

    /**
     * Show the password confirm filed for the given password field.
     * BUG: This also contains some work-around code for IE8 (on Win7RC) not re-rendering sibling cells correctly.
     */
    _showPasswordConfirm: function(pwdField) {
        var confirmSection = pwdField.up('td').down('.confirmPasswordSection');
        if (confirmSection) {
            confirmSection.show(); // show the confirm section if present
        }
        else {
            var confirmName = pwdField.name + 'Confirm';
            var confirmSize = pwdField.size;
            pwdField.insert({'after':
                new Element('div', {'style':'padding-top: 5px;'}).addClassName('confirmPasswordSection')
                    .insert(new Element('span', {'style':'font-size: smaller;'}).update(i18n('Confirm') + '<br/>'))
                    .insert(new Element('input', {'type':'password', 'name':confirmName, 'size':confirmSize}).addClassName('input'))
            });
        }

        // do something to trigger re-rendering of row in IE8
        pwdField.up('tr').select('td').each(function(cell){
            var stub = new Element('span').update('&nbsp;');
            cell.insert(stub);
            stub.remove();
        });
    },

    /**
     * Hide the password confirm filed for the given password field.
     * BUG: This also contains some work-around code for IE8 (on Win7RC) not re-rendering sibling cells correctly.
     */
    _hidePasswordConfirm: function(pwdField) {
        var confirmSection = pwdField.up('td').down('.confirmPasswordSection');
        if (confirmSection) {
            confirmSection.down('input').value = '';
            confirmSection.hide(); // hide the confirm section if present

            // do something to trigger re-rendering of row in IE8
            pwdField.up('tr').select('td').each(function(cell){
                var stub = new Element('span').update('&nbsp;');
                cell.insert(stub);
                stub.remove();
            });
        }
    },

    /**
     * If the given element is a textarea input, then its hieght wil be increased such that all content fits
     * within the input (maximum of 50 rows)
     */
    _expandTextArea: function(txtArea) {
        var type = txtArea.type || txtArea.tagName;
        var maxRows = 50;
        if (type === 'textarea') {
            while (txtArea.scrollHeight > txtArea.offsetHeight &&
                txtArea.rows < maxRows) {
                if (txtArea.rows < maxRows) {
                    txtArea.rows = txtArea.rows + 1;
                }
            }
            // for IE6
            if (txtArea.rows < maxRows) {
                $(txtArea).setStyle({'overflow': 'hidden'});
            }
            else {
                $(txtArea).setStyle({'overflow': 'auto'});
            }
        }
    },

    /**
     * Mark the form as having been changed and swap out the save/cancel and done buttons if not already done
     */
    _formChanged: function() {
        if (!this._form.hasClassName('changed')) {
            this._form.addClassName('changed');
            this._form.down('.editButtons').show();
            this._form.down('.doneButtons').hide();
        }
    },

    /**
     * Attach the given FormErrors to given form. It will clear any previous errors prior to attaching new messages.
     */
    _updateErrors: function(formErrors) {
        var form = this._form;

        // clear error marker for child tabs (if present)
        this._form.select('.tabs li a.error').each(function(err){err.removeClassName('error');});

        // remove previous errors
        form.select('span.error').each(function(err){err.remove();});
        form.down('.formError').hide();

        if (formErrors) {
            // update and show the general form error element
            if (formErrors.message) {
                var generalErrorMsg = form.down('.formError');
                generalErrorMsg.update(formErrors.message).show();
            }

            // attach new errors
            formErrors.fields.each(function(field) {
                var fieldName = field.fieldName;
                var message = field.message;

                var input = form.down("*[name='"+fieldName+"']"); // input or select element with the field name
                input.up().insert({top:new Element('span').addClassName('error').update(message.escapeHTML()+'<br/>')});

                // update error mark for corresponding child tab (if present)
                var section = input.up('.properties-section');
                var tabIndex = section.previousSiblings().length;
                var tab = form.down('.tabs li', tabIndex);
                if (tab) {
                    tab.down().addClassName('error'); // same BUG with down('a') (FF3.5, Safari4, possibly others)
                }
            });
        }
    },

    /**
     *  Extracts the entered/selected value from various form-elements
     */
    _getFieldValue: function(field) {
        var type = field.type || field.tagName; // get type or tag-name if type is undefined
        var value = null;

        if (type == 'text' || type == 'textarea' || type == 'password') {
            value = field.value;
        }
        else if (type.startsWith('select')) {
            var selectedIndex = field.selectedIndex;
            value = selectedIndex == null ? null :field.options[selectedIndex].value;
        }
        else if (type == 'checkbox') {
            value = (field.checked ? field.value : null);
        }
        else if (type == 'radio') {
            // TODO ?? like checkbox, but how deal with interaction of multiple radio buttons...
        }
        else {
            // file-input, image-input, etc
        }
        return value == '' ? null : value;
    },

    /**
     * @param value the value
     * @param delimiter the delimiter
     * @return the content of value following the first occurance of delimiter
     */
    _substringAfter: function(value, delimiter) {
        return value.substring(value.indexOf(delimiter)+delimiter.length);
    },

    /**
     *
     */
    __chainCalls: function(func, inputsArray) {
        var self = this;
        var form = this._form;
        var formError = form.down('.formError');
        var i = 0;
        while ( (i++ < 100) && (inputsArray.length > 0)) {
            var input = inputsArray.pop();
            func(input);
        }
        if (inputsArray.length) {
            setTimeout(function(){self.__chainCalls(func, inputsArray);}, 10);
        }
    }
});
