/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var LatestStatusTable = React.createClass({displayName: "LatestStatusTable",
    render: function() {
        var activities = this.props.activities;
        return (
            React.createElement("table", {className: "data-table"}, 
                React.createElement(LatestStatusTableHeader, null), 
                React.createElement(LatestStatusTableBody, {activities: activities})
            )
        );
    }
});

var LatestStatusTableHeader = React.createClass({displayName: "LatestStatusTableHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
              React.createElement("th", {className: "align-left"}, i18n("Status")), 
              React.createElement("th", {className: "align-center"}, i18n("Build")), 
              React.createElement("th", {className: "align-left"}, i18n("Stamp")), 
              React.createElement("th", {className: "align-center"}, i18n("Job")), 
              React.createElement("th", {className: "align-left"}, i18n("Date"))
          )
        );
    }
});

var LatestStatusTableBody = React.createClass({displayName: "LatestStatusTableBody",
    render: function() {
        var activities = this.props.activities;
        if (activities.length !== 0) {
            return (
                 React.createElement("tbody", null, 
                    
                        activities.map(function(activity) {
                            return (
                                React.createElement(LatestStatusTableRow, {activity: activity})
                            )
                        })
                    
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "5", className: "align-left"}, i18n("LatestStatusesNoStatusesAssigned"))
                    )
                )
            );
        }
    }
});

var LatestStatusTableRow = React.createClass({displayName: "LatestStatusTableRow",
    render: function() {
        var activity = this.props.activity;
        var jobTraceUrlId = jobTraceUrl + activity.jobTraceId;
        var buildLifeUrlId = buildLifeUrl + activity.buildLifeId;
        var statusHistoryUrlName = statusHistoryUrl + activity.statusId;

        var isDarkColor = isDarkColorFunc(activity.statusColor);
        var textColor = "";
        if(isDarkColor) {
            textColor = "#FFFFFF";
        }

        return (
            React.createElement("tr", null, 
              React.createElement("td", {className: "align-left nowrap", style: {backgroundColor:activity.statusColor}}, 
                React.createElement("a", {style: {color:textColor}, href: statusHistoryUrlName}, i18n(activity.statusName))
              ), 
              React.createElement("td", {className: "align-center nowrap", style: {backgroundColor:activity.statusColor}}, 
                  React.createElement("a", {style: {color:textColor}, href: buildLifeUrlId}, activity.buildLifeId)
              ), 
              React.createElement("td", {className: "align-center nowrap"}, 
                  activity.latestStamp
              ), 
              React.createElement("td", {className: "align-center nowrap"}, 
                  React.createElement("a", {href: jobTraceUrlId}, activity.jobTraceId)
              ), 
              React.createElement("td", {className: "align-center nowrap"}, 
                  activity.dateAssigned
              )
           )
        );
    }
});
