/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

renderCurrentActivitySchedules = function() {
    var self = this;
    var restUrl = currentActivitySchedulesRestUrl;
    jQuery.get(restUrl, function(result) {
        setTimeout(function() {
            self.renderCurrentActivitySchedules();
        }, 5000);

        React.render(React.createElement(SchedulesTable, {schedules: result.schedules}), document.getElementById("schedulesTable"));
    }.bind(this));
};


var SchedulesTable = React.createClass({displayName: "SchedulesTable",
    render: function() {
        var schedules = this.props.schedules;
            return (
               React.createElement("table", {className: "data-table"}, 
                    React.createElement(SchedulesTableHeader, null), 
                    React.createElement(SchedulesTableBody, {schedules: schedules})
               )
            );
    }
});

var SchedulesTableHeader = React.createClass({displayName: "SchedulesTableHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
              React.createElement("tr", null, 
                React.createElement("th", {scope: "col", align: "left", valign: "middle", width: "10%"}, i18n("Schedule")), 
                React.createElement("th", {scope: "col", align: "left", valign: "middle"}, i18n("Type")), 
                React.createElement("th", {scope: "col", align: "left", valign: "middle"}, i18n("Active")), 
                React.createElement("th", {scope: "col", align: "left", valign: "middle"}, i18n("NextOccurence")), 
                React.createElement("th", {scope: "col", align: "left", valign: "middle"}, i18n("ScheduledActions"))
              )
            )
        );
    }
});

var SchedulesTableBody = React.createClass({displayName: "SchedulesTableBody",
    render: function() {
        var schedules = this.props.schedules;
        if (schedules.length === 0) {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "5", className: "align-left"}, i18n("NoSchedules"))
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                   
                       schedules.map(function(schedule) {
                            return (
                                React.createElement(Row, {schedule: schedule})
                            )
                        })
                    
                )
            );
        }
    }
});


var Row = React.createClass({displayName: "Row",
    render: function() {
        var schedule = this.props.schedule;

        if (schedule.scheduleActive) {
            return (
                React.createElement("tr", {className: "odd"}, 
                    React.createElement("td", {className: "align-left-height"}, schedule.scheduleName), 
                    React.createElement("td", {className: "align-left-height"}, schedule.scheduleType), 
                    React.createElement("td", {className: "align-left-height"}, i18n('Yes')), 
                    React.createElement("td", {className: "align-left-height"}, schedule.scheduleNextRunDateTime), 
                    React.createElement("td", {className: "align-left-height"}, schedule.schedulables)
                )
             );
        }
        else {
            return (
                React.createElement("tr", {className: "odd"}, 
                    React.createElement("td", {className: "align-left-height"}, schedule.scheduleName), 
                    React.createElement("td", {className: "align-left-height"}, schedule.scheduleType), 
                    React.createElement("td", {className: "align-left-height"}, i18n('No')), 
                    React.createElement("td", {className: "align-left-height"}, schedule.scheduleNextRunDateTime), 
                    React.createElement("td", {className: "align-left-height"}, schedule.schedulables)
                )
             );
        }
    }
});

