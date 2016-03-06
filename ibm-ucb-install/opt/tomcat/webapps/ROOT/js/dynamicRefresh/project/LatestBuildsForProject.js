/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var ProjectLatestBuildsTable = React.createClass({displayName: "ProjectLatestBuildsTable",
    render: function() {
        var activities = this.props.activities;
        return (
            React.createElement("table", {className: "data-table"}, 
                React.createElement(ProjectLatestBuildsTableHeader, null), 
                React.createElement(ProjectLatestBuildsTableBody, {activities: activities})
            )
        );
    }
});

var ProjectLatestBuildsTableHeader = React.createClass({displayName: "ProjectLatestBuildsTableHeader",
    render: function() {
        return (
            React.createElement("tr", null, 
                React.createElement("th", null, i18n("BuildProcess")), 
                React.createElement("th", null, i18n("Status")), 
                React.createElement("th", null, i18n("Stamp")), 
                React.createElement("th", null, i18n("Date")), 
                React.createElement("th", null, i18n("Duration")), 
                React.createElement("th", null, i18n("Why")), 
                React.createElement("th", null, i18n("Tests")), 
                React.createElement("th", null, i18n("Issues")), 
                React.createElement("th", null, i18n("Changes"))
           )
        );
    }
});

var ProjectLatestBuildsTableBody = React.createClass({displayName: "ProjectLatestBuildsTableBody",
    render: function() {
        var activities = this.props.activities;
        if (activities.length !== 0) {
            return (
                 React.createElement("tbody", null, 
                    
                        activities.map(function(activity) {
                            return (
                                React.createElement(ProjectLatestBuildsTableRow, {activity: activity})
                            )
                        })
                    
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", {className: "rowClosed"}, 
                        React.createElement("td", {colSpan: "9", className: "align-left"}, i18n("NoActivity"))
                    )
                )
            );
        }
    }
});

var ProjectLatestBuildsTableRow = React.createClass({displayName: "ProjectLatestBuildsTableRow",
    render: function() {
        var activity = this.props.activity;
        var workflowUrlId = workflowUrl + activity.processId;
        var workflowImgUrl = imgUrl + "/icon_workflow.gif";
        if (activity.buildLifeId) {
            var errorsUrlId = errorUrl + activity.buildLifeId;
            var buildLifeUrlId = buildLifeUrl + activity.buildLifeId;
            return (
                React.createElement("tr", {className: "rowClosed"}, 
                    React.createElement("td", {className: "align-left nowrap"}, 
                        React.createElement("img", {src: workflowImgUrl, border: "0", alt: ""}), 
                        React.createElement("a", {href: workflowUrlId}, activity.processName)
                    ), 
                    React.createElement(ProjectLatestBuildsStatusCol, {activity: activity}), 
                    React.createElement(ProjectLatestBuildsStampCol, {activity: activity}), 
                    React.createElement("td", {className: "align-center"}, 
                        activity.endDate
                    ), 
                    React.createElement("td", {className: "align-center"}, 
                        activity.duration
                    ), 
                    React.createElement(ProjectLatestBuildsWhyCol, {activity: activity}), 
                    React.createElement("td", {className: "align-center"}, 
                        activity.testsPassed, " / ", activity.testsRun
                    ), 
                    React.createElement("td", {className: "align-center"}, 
                        activity.issues
                    ), 
                    React.createElement("td", {className: "align-center"}, 
                        activity.changes, " / ", activity.fileChanges
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tr", {className: "rowClosed"}, 
                    React.createElement("td", {className: "align-left nowrap"}, 
                        React.createElement("img", {src: workflowImgUrl, border: "0", alt: ""}), 
                        React.createElement("a", {href: workflowUrlId}, activity.processName)
                    ), 
                    React.createElement("td", {colSpan: "8", className: "align-left"}, i18n("NoBuilds"))
                )
            );
        }
    }
});

var ProjectLatestBuildsStatusCol = React.createClass({displayName: "ProjectLatestBuildsStatusCol",
    render: function() {
        var activity = this.props.activity;
        if (activity.status == 'Failed' || activity.status == 'Error') {
            return (
                React.createElement("td", {className: "align-center nowrap", style: {backgroundColor:activity.statusColor, color:activity.statusSecondaryColor}}, 
                    React.createElement("a", {href: "javascript:showPopup('{errorsUrl}', 800, 600); return false;", title: i18n('ClickToViewErrors')}, i18n(activity.status))
                )
            );
        }
        else {
            return (
                React.createElement("td", {className: "align-center nowrap", style: {backgroundColor:activity.statusColor, color:activity.statusSecondaryColor}}, 
                    i18n(activity.status)
                )
            );
        }
    }
});

var ProjectLatestBuildsStampCol = React.createClass({displayName: "ProjectLatestBuildsStampCol",
    render: function() {
        var activity = this.props.activity;
        var buildLifeUrlId = buildLifeUrl + activity.buildLifeId;
        var magnifyglassUrl = imgUrl + "/icon_magnifyglass.gif";
        if (activity.latestStamp) {
            return (
                React.createElement("td", {className: "align-center"}, 
                    React.createElement("a", {href: buildLifeUrlId, title: i18n('ViewBuildLife')}, 
                        activity.latestStamp
                    )
                )
            );
        }
        else {
            return (
                React.createElement("td", {className: "align-center"}, 
                    React.createElement("a", {href: buildLifeUrlId, title: i18n('ViewBuildLife')}, 
                        React.createElement("img", {src: magnifyglassUrl, border: "0"})
                    )
                )
            );
        }
    }
});

var ProjectLatestBuildsWhyCol = React.createClass({displayName: "ProjectLatestBuildsWhyCol",
    render: function() {
        var activity = this.props.activity;
        if (activity.requestSource == 'Manual') {
            return (
                React.createElement("td", {className: "align-center"}, 
                    React.createElement("a", {title: i18n('RequestedByUser', activity.requester)}, 
                        i18n(activity.requestSource)
                    )
                )
            );
        }
        else {
            return (
                React.createElement("td", {className: "align-center"}, 
                    i18n(activity.requestSource)
                )
            );
        }
    }
});
