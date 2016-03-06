/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* IBM UrbanCode Deploy
* IBM UrbanCode Release
* IBM AnthillPro
* (c) Copyright IBM Corporation 2002, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global define */
define([
        "dojo/_base/declare",
        "dijit/_WidgetBase",
        "dijit/_TemplatedMixin",
        "dijit/form/TimeTextBox",
        "dijit/form/DateTextBox"
        ],
function(
        declare,
        _WidgetBase,
        _TemplatedMixin,
        TimeTextBox,
        DateTextBox
) {
    /**
     * A combined TimeTextBox & DateTextBox widget
     */
    return declare([_WidgetBase, _TemplatedMixin],
        {
            templateString:
                '<div class="dateTimePicker">'+
                '    <div dojoAttachPoint="dateAttach"></div>'+
                '    <div dojoAttachPoint="timeAttach"></div>'+
                '</div>',

            /**
             * default to a false value, since timeTextBox handles
             * disabled: undefined, and no definition of disabled differently.
             */
            disabled: false,

            postCreate : function () {
                this.inherited(arguments);

                this.showWidget();
            },

            coerceToDate : function (dateValue) {
                // We might get an Epoch Value as a string.
                // Try Epoch, then try string
                var newDate = Number(dateValue);
                if (isNaN(newDate)) {
                    return new Date(dateValue);
                }
                return new Date(newDate);
            },

            showWidget: function() {
                var _this = this;

                this.date = new DateTextBox({
                    value: this.coerceToDate(this.value),
                    disabled: this.disabled,
                    datePackage: this.datePackage,
                    onChange: function() {
                        _this.onChange(_this.get("value"));
                    }
                }, this.dateAttach);
                this.date.domNode.style.width = "110px";
                this.date.domNode.className += " date-box-picker";
                this.time = new TimeTextBox({
                    value: this.coerceToDate(this.value),
                    disabled: this.disabled,
                    onChange: function() {
                        _this.onChange(_this.get("value"));
                    }
                }, this.timeAttach);
                this.time.domNode.className += " time-box-picker";
            },

            onChange: function() {
                // no-op by default
            },

            _getValueAttr: function() {
                var date = this.date.get("value");
                var time = this.time.get("value");
                var dateTime = null;
                if(date && time) {
                    dateTime = util.combineDateAndTime(date, time).valueOf();
                }
                else if (date) {
                    dateTime = date.valueOf();
                }
                else if (time) {
                    var now = new Date();
                    var midnight = new Date(now.getFullYear(), now.getMonth(),now.getDate(), 0, 0, 0, 0);
                    dateTime = util.combineDateAndTime(midnight, time).valueOf();
                }
                return dateTime;
            },

            _setValueAttr: function(value) {
                this.value = value;
                if (this.date) {
                    this.date.set("value", new Date(value));
                }
                if (this.time) {
                    this.time.set("value", new Date(value));
                }
            },

            destroy : function () {
                this.date.destroy();
                this.time.destroy();
                this.inherited(arguments);
            }
        }
    );
});
