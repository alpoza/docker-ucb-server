/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/

/**
 *  This Class is for our UserProfile DateTime Format inputs. 
 *  It assumes html structure like <select/><div><checkbox><\/div> where the checkbox is whether to use a 
 *  24hr clock or not and the select has values of styles like MM/dd/YY
 */
var UCDateTimeInput = Class.create({

    /**
     * Constructor
     */
    initialize: function(selectFormat) {
        this.selectFormat = $(selectFormat);
        this.use24Div = this.selectFormat.next();
        this.use24Checkbox = this.use24Div.down();

        this.updateDisplay();
      
        var t = this; // local variable for event closures to reference so that methods work correctly
        Element.observe(this.selectFormat, 'change', function(event) { t.updateDisplay(event); } );
        Element.observe(this.use24Checkbox, 'click', function(event) { t.updateDisplay(event); } );
    },

    /**
     * Update the visibility of the use24 checkbox and the labels to match the currently selected options
     */
    updateDisplay: function(event) {

        // if 'default' is selected hide the use24time option
        if (this.selectFormat.selectedIndex==0) {
            this.use24Div.hide();
              //this.use24Checkbox.checked=false;
        }
        else {
            this.use24Div.show();
        }

        // update all select values to use AM/PM or not based upon checked state
        var use24 = this.use24Checkbox.checked;
        this.selectFormat.select('option').each(function(option) {
            var currentValue = option.value;
            if (currentValue != '') {
                var newLabel = currentValue + (use24 ? " HH:mm" : " hh:mm a");
                option.update(newLabel);
            }
        });
    }
});