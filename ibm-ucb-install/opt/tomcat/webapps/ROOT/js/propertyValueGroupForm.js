/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
  /**
   *  The javascript controller for PropertyValueGroup HTML forms
   */
  var UC_PVGForm = Class.create({

      /**
       * Initializer method.
       *
       * Options can contain:
       *   'onCancelNew' - a function which is executed when a user clicks cancel on a form where the
       * parameter isNew is 'true'.
       *   'onSaveSuccess' - a function which is executed when the data is successfully saved.
       *
       */
      initialize: function(form, options) {
          this._form = $(form);
          this._prepareForm();

          this._onCancelNew   = (options && options['onCancelNew']);
          this._onSaveSuccess = (options && options['onSaveSuccess']);
      },

      /**
       * Start editing the form (toggle buttons to Save/Cancel, from Done)
       */
      startEditing: function() {
          this._form.down('.editButtons').show();
          this._form.down('.doneButtons').hide();
      },

      /**
       * Cancel editing the form.  If new object, redirect page to list view,
       *  otherwise just revert form and switch buttons to Done from Save/Cancel.
       */
      cancel: function() {

          var isNew = this._form.serialize(true)['isNew'] != null;

          if (isNew) {
              if (this._onCancelNew) {
                  this._onCancelNew();
              }
              else {
                  // TODO remove this and instead just require the onCancelNew callback
                  parent.hidePopup();
              }
          }
          else {
              this._form.reset();
              this._form.removeClassName('changed');
              this._form.select('.confirmPasswordSection').each(function(div){div.hide()});
              this._updateErrors(null);
              this._form.down('.editButtons').hide();
              this._form.down('.doneButtons').show();
          }
      },

      /**
       * Do local-validation and if valid submit data via AJAX for further server-validation and handling
       */
      save: function() {

          if (!(this._form.down('.editButtons').visible())) {
              return;
          }

          //
          // CLIENT-SIDE VALIDATE
          //

          var valid = this.validateForm();
          if (!valid) {
              return;
          }

          //
          // SUBMIT AND PROCESS RESPONSE
          //

          var t = this;

          this._form.request({
              method: 'post',
              onSuccess: function(resp) {
                  if (resp.responseJSON) {
                      if (resp.responseJSON.error) {// errors were found!!
                          t._updateErrors(resp.responseJSON);
                      }
                      else {
                          alert(i18n('UnknownResponseFromServer'))
                      }
                  }
                  else {
                      if (t._onSaveSuccess) {
                          t._onSaveSuccess();
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
                  }
              },
              onFailure:   function(resp){ alert(i18n('PropertiesSavingError')); },
              onException: function(req,e){ throw e;} // so errors show in ErrorConsole
          });
      },

      /**
       *  Client-Side validation of form.  Attaches any resultant field-errors.
       *  Similar validation is perfomed on server-side as well.
       *
       *  @return true if the form passes client-side validation, false otherwise
       */
      validateForm: function() {
          var t = this;
          var formErrors = {message:i18n("CorrectErrors"), fields: new Array()};

          // Required fields
          this._form.select('input.required','textarea.required','select.required').each(function(field){
              var type = field.type || field.tagName; // get type or tagename if type is undefined
              if (t._getFieldValue(field) == null) {
                  formErrors.fields.push({fieldName: field.name, message: i18n('EnterAValue')});
              }
          });

          // Check password confirm fields
          this._form.select('input.hasConfirm').each(function(field){

              var value = t._getFieldValue(field);

              var confirmField = field.next('.confirmPasswordSection').down('input');
              var confirmValue = t._getFieldValue(confirmField);

              if (value == field.defaultValue && confirmValue == null) {
                  // this is OK, we maintain existing non-null password
              }
              else if (value != confirmValue) {
                  formErrors.fields.push({fieldName: field.name, message: i18n('ValueConfirmationError')});
              }
          });

          //
          // Result
          //

          if (formErrors.fields.length > 0) {
              this._updateErrors(formErrors);
              return false;
          }
          else {
              this._updateErrors(null);
              return true;
          }
      },

      //
      // Private methods, these should never be called directly
      //

      /**
       * Attaches a change listener to each input of the given form. (which trigger the startEditing method)
       */
      _prepareForm: function() {
          var t = this;

          // listen for submit
          //this._form.action = this._savePVGroupUrl;
          this._form.observe('submit', function(event){ event.stop(); t.save();});

          // listen for cancel button
          var cancelButton = this._form.down('input[value="Cancel"]');
          cancelButton.observe('click', function(event){event.stop(); t.cancel();});

          // listen for modifications to inputs
          this._form.select('input', 'select', 'textarea').each(function(input){
              if (input.hasClassName('ignoreDirty')) {
                  return;
              }

              var type = input.type || input.tagName;

              if (type == 'text' || type == 'textarea' || type == 'password') {
                  Element.observe(input, 'keyup', function(event) {
                      var changed = (input.value != input.defaultValue);
                      if (changed) {
                          t._formChanged();
                      }

                      if (changed && type == 'password') {
                          var confirmSection = input.next('.confirmPasswordSection')
                          if (confirmSection) {
                              confirmSection.show(); // show the confirm section if present
                          }
                      }
                  });
              }
              else if (type.startsWith('select')) {
                Element.observe(input, 'change', function(event) {
                    var changed = (input.selectedIndex != input.defaultSelectedIndex);
                    if (changed) {
                        t._formChanged();
                    }
                });
              }
              else if (type == 'checkbox' || type=='radio') {
                  Element.observe(input, 'click', function(event) {
                      var changed = (input.checked != input.defaultChecked);
                      if (changed) {
                          t._formChanged();
                      }
                  });
              }
              else {
                  // alert('unrecognized field '+input.name+' of type '+type)
              }
          });

          // hide confirmation inputs
          this._form.select('.confirmPasswordSection').each(function(section){section.hide();});

          this._form.setDirty = function(){t.startEditing()};
      },

      _formChanged: function() {
          if (!this._form.hasClassName('changed')) {
              this._form.addClassName('changed');
              this.startEditing();
          }
      },

      /**
       * Attach the given FormErrors to given form. It will clear any previous errors prior to attaching new messages.
       */
      _updateErrors: function(formErrors) {
          var form = this._form;

          // remove previous errors
          form.select('span.error').each(function(err){err.remove()});
          form.down('.formError').hide();

          if (formErrors) {
              // attach new errors
              formErrors.fields.each(function(field) {
                  var fieldName = field.fieldName;
                  var message = field.message;

                  var input = form.down("*[name='"+fieldName+"']"); // input or select element with the field name
                  input.up().insert({top:new Element('span', {'class':'error'}).update(message.escapeHTML()+'<br/>')});
              });

              if (formErrors.message) {
                  // update and show the general form error element
                  var generalErrorMsg = form.down('.formError');
                  generalErrorMsg.update(formErrors.message).show();
              }
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
      }
});
