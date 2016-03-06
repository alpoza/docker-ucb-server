/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/**
 *  The javascript controller for Multiselect HTML forms input
 */
var UC_MultiselectInput = Class.create({

      /**
       * Initializer method.
       *
       * @param section the html element containing ul.selected-values, .autocomplete-display, and input.autocomplete[type="text"]
       * @param options the options for the mutli-select of strucutre {'label':*, 'value':*}
       * @param defaultSelectedValues a set of values (found in options list) which should be selected by default
       * @param name the name of the input
       */
      initialize: function(name, section, options, defaultSelectedValues) {
          var self = this;

          // primary elements
          self.name = name;
          self.section = $(section);
          self.options = options;
          self.defaultSelectedValues = defaultSelectedValues;

          // derived elements
          self.selectedValuesElement = self.section.down('.selected-values').update('');      // selected values list
          self.autoCompleteTextInput = self.section.down('.autocomplete[type="text"]');       // the typing field
          self.autoCompleteDisplay   = self.section.down('.autocomplete-display').update(''); // the suggestion box
          self.form = $(self.autoCompleteTextInput.form);                                // the text-box form (used for form#reset)

          // comprehensive list of suggestions

          // use this to populate the selectedValuesElement
          self.reset();

          // set up the auto-complete control
          self.configureAutoComplete();

          // select all text current in the input when brought to focus
          self.autoCompleteTextInput.observe('focus', function(it){this.select()});

          // set up the reset listener to revert selected values when needed
          self.form.observe('reset', function(){ self.reset(); });
      },

      /**
       * Get the option object from self#options with the matching option#value.
       * @param value
       */
      getOption: function(value) {
          var self = this;
          return self.options.find(function(it){return it.value === value});
      },

      /**
       * Select the given value (if not already selected)
       * @param value a value
       */
      selectValue: function(value) {
          var self = this;

          // check if already selected
          var isSelected = !!(self.selectedValuesElement.down('input[type="hidden"][value="'+value+'"]'));

          // if not already selected, insert it and mark form dirty
          if (!isSelected) {
              var option = self.getOption(value);
              self.selectedValuesElement.insert(self.createLIElement(option.label, option.value));
              if (self.form && self.form.setDirty) {
                  self.form.setDirty();
              }
          }
      },

      /**
       * Un-select the given value (if selected).
       * @param value a value
       */
      unselectValue: function(value) {
          var self = this;
          var selectedOption = self.selectedValuesElement.down('input[type="hidden"][value="'+value+'"]');
          if (selectedOption) {
              selectedOption.remove();
              if (self.form && self.form.setDirty) {
                  self.form.setDirty();
              }
          }
      },

      /**
       * Reset this control back to its default state.
       */
      reset: function() {
          var self = this;

          self.selectedValuesElement.update('');
          self.options.each(function(option) {
              if (self.defaultSelectedValues.indexOf(option.value) !== -1) {
                  self.selectedValuesElement.insert(self.createLIElement(option.label, option.value));
              }
          });
      },

      /**
       * Create a LI Element corresponding to the given label and value
       */
      createLIElement: function(optionLabel, optionValue) {
          var self = this;
          var form = self.form; // TODO

          return new Element('li')
              .insert(new Element('img', {'border':0, 'src': self.options.imgUrl + '/symbol_X.gif', 'title':'remove'})
                  .setStyle({'cursor':'pointer'})
                  .observe('click', function(){
                      $(this).up('li').remove();
                      if (form && form.setDirty) {
                          form.setDirty();
                      }
                  }))
              .insert(new Element('span', {'title':optionValue}).update(optionLabel.escapeHTML()))
              .insert(new Element('input', {'type':'hidden', 'name':self.name, 'value':optionValue}));
      },

      /**
       * Create and configure the YUI autocomplete text box.
       */
      configureAutoComplete: function(){
          var self = this;

          /**
           * Highlight the selected snippet occuring at matchindex within the full string
           * @param full
           * @param snippet
           * @param matchindex
           */
          var highlightMatch = function(full, snippet, matchindex) {
              return full.substring(0, matchindex).escapeHTML() +
                  "<span class='bold'>" + full.substr(matchindex, snippet.length).escapeHTML() + "</span>" +
                  full.substring(matchindex + snippet.length).escapeHTML();
          };

          /**
           * return subset #values which matches the sQeury
           * @param sQuery
           */
          var matchValues = function(sQuery) {
              var matches = new Array();

              // Case insensitive matching
              sQuery = decodeURIComponent(sQuery);
              var query = sQuery.toLowerCase();
              var matchFromStart = query.length === 0 || query.charAt(0) !== '*';
              if (!matchFromStart) {
                  query = query.substring(1);
              }

              // Match against each label of each option
              if (query || !matchFromStart) {
                  self.options.each(function(value){
                      var matchIndex = value.label.toLowerCase().indexOf(query);
                      if (matchFromStart ? matchIndex === 0 : matchIndex > -1) {
                          matches.push(value);
                      }
                  });
              }

              if (matches.length === 0) {
                  return matches.push({'label':'', 'value':''});
              }

              return matches;
          };

          var dataSource = new YAHOO.util.FunctionDataSource(matchValues);
          dataSource.responseSchema = { 'fields':["label", "value"] }

          // Instantiate the AutoComplete
          var autoComplete = new YAHOO.widget.AutoComplete(self.autoCompleteTextInput, self.autoCompleteDisplay, dataSource,
                  {
                      'forceSelection': false,
                      'typeAhead': false, // setting to true messes with the '*' wildcard
                      'queryDelay': 0.5,
                      'minQueryLength': 0, // allow length 0 so we can return our '-- Any --' Field
                      'maxResultsDisplayed': 500
                  }
          );
          autoComplete.resultTypeList = false;

          // Custom formatter to highlight the matching letters
          autoComplete.formatResult = function(oResultData, sQuery, sResultMatch) {
              var query = sQuery.toLowerCase();
              var label = oResultData.label;
              if (query.length > 0 && query.charAt(0) === '*') {
                  query = query.substring(1);
              }
              var labelMatchIndex = label.toLowerCase().indexOf(query);
              return highlightMatch(label, query, labelMatchIndex);
          };

          // Define an event handler to populate a hidden form field when an item gets selected
          var itemSelectionHandler = function(sType, aArgs) {
              var myAC = aArgs[0]; // reference back to the AC instance
              var elLI = aArgs[1]; // reference to the selected LI element
              var oData = aArgs[2]; // object literal of selected item's result data

              // update selected items list
              self.selectValue(oData.value);

              // clear text input
              self.autoCompleteTextInput.value = '';
          };
          autoComplete.itemSelectEvent.subscribe(itemSelectionHandler);
      }
});