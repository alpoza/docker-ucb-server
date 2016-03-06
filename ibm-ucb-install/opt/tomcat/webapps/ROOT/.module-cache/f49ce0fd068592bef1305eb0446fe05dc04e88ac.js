/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var ProjectLatestStatusTable = React.createClass({displayName: "ProjectLatestStatusTable",
    render: function() {
        var activities = this.props.activities;
        return (
            React.createElement("table", {className: "data-table"}, 
                React.createElement(ProjectLatestStatusTableHeader, null), 
                React.createElement(ProjectLatestStatusTableBody, {activities: activities})
            )
        );
    }
});

var ProjectLatestStatusTableHeader = React.createClass({displayName: "ProjectLatestStatusTableHeader",
    render: function() {
        return (
            React.createElement("tr", null, 
              React.createElement("th", {className: "align-left"}, i18n("Status")), 
              React.createElement("th", {className: "align-left"}, i18n("Process")), 
              React.createElement("th", {className: "align-left"}, i18n("Build")), 
              React.createElement("th", {className: "align-left"}, i18n("Stamp")), 
              React.createElement("th", {className: "align-left"}, i18n("Job")), 
              React.createElement("th", {className: "align-left"}, i18n("Date"))
          )
        );
    }
});

var ProjectLatestStatusTableBody = React.createClass({displayName: "ProjectLatestStatusTableBody",
    render: function() {
        var activities = this.props.activities;
        if (activities.length !== 0) {
            return (
                 React.createElement("tbody", null, 
                    
                        activities.map(function(activity) {
                            return (
                                React.createElement(ProjectLatestStatusTableRow, {activity: activity})
                            )
                        })
                    
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "6", className: "align-left"}, i18n("ProjectLatestStatusesNoStatusAssignments"))
                    )
                )
            );
        }
    }
});

var ProjectLatestStatusTableRow = React.createClass({displayName: "ProjectLatestStatusTableRow",
    render: function() {
        var activity = this.props.activity;
        var jobTraceUrlId = jobTraceUrl + activity.jobTraceId;
        var buildLifeUrlId = buildLifeUrl + activity.buildLifeId;
        var workflowUrlId = workflowUrl + activity.workflowId;
        var statusHistoryUrlId = statusHistoryUrl + activity.projectId + "&amp;search=true&amp;statusId=" + activity.statusId;
        var workflowName = activity.workflowName;
        if (!workflowName) {
            workflowName = i18n('N/A');
        }
        var latestStamp = activity.latestStamp;
        if (!latestStamp) {
            latestStamp = i18n('N/A');
        }
        var jobTraceId = activity.jobTraceId;
        if (!jobTraceId) {
            jobTraceId = i18n('N/A');
        }

        var isDarkColor = isDarkColorFunc(activity.statusColor);
        var textColor = "";
        if(isDarkColor) {
            textColor = "#FFFFFF";
        }

        if (activity.buildLifeId) {
            return (
                React.createElement("tr", null, 
                    React.createElement("td", {className: "align-left nowrap", style: {backgroundColor:activity.statusColor}}, 
                        React.createElement("a", {style: {color:textColor}, href: statusHistoryUrlId}, i18n(activity.statusName))
                    ), 
                    React.createElement("td", {className: "align-center nowrap"}, 
                        React.createElement("a", {href: workflowUrlId}, workflowName)
                    ), 
                    React.createElement("td", {className: "align-center nowrap", style: {backgroundColor:activity.statusColor}}, 
                        React.createElement("a", {style: {color:textColor}, href: buildLifeUrlId}, activity.buildLifeId)
                    ), 
                    React.createElement("td", {className: "align-center nowrap"}, latestStamp), 
                    React.createElement("td", {className: "align-center nowrap"}, 
                        React.createElement("a", {href: jobTraceUrlId}, jobTraceId)), 
                    React.createElement("td", {className: "align-center nowrap"}, 
                        activity.dateAssigned
                    )
                )
            );
        }
        else {
            return(
                React.createElement("tr", null, 
                    React.createElement("td", {className: "align-left nowrap", style: {backgroundColor:activity.statusColor}}, 
                        React.createElement("a", {href: statusHistoryUrlId}, activity.statusName)
                    ), 
                    React.createElement("td", {className: "align-center nowrap"}, i18n('N/A')), 
                    React.createElement("td", {className: "align-center nowrap"}, i18n('N/A')), 
                    React.createElement("td", {className: "align-center nowrap"}, i18n('N/A')), 
                    React.createElement("td", {className: "align-center nowrap"}, i18n('N/A')), 
                    React.createElement("td", {className: "align-center nowrap"}, i18n('N/A'))
                )
            );
        }
    }
});
