/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var RecentActivityTable = React.createClass({displayName: "RecentActivityTable",
    render: function() {
        var isComplete = this.props.isComplete;
        var activities = this.props.activities;
        var fromProcess = this.props.fromProcess;
        return (
            React.createElement("table", {className: "data-table"}, 
                React.createElement(RecentActivityTableHeader, null), 
                React.createElement(RecentActivityTableBody, {isComplete: isComplete, activities: activities, fromProcess: fromProcess})
            )
        );
    }
});

var RecentActivityTableHeader = React.createClass({displayName: "RecentActivityTableHeader",
    render: function() {
        return (
        React.createElement("thead", null, 
            React.createElement("th", {className: "align-left"}, i18n("Build")), 
            React.createElement("th", {className: "align-left"}, i18n("Process")), 
            React.createElement("th", {className: "align-left"}, i18n("LatestStamp")), 
            React.createElement("th", {className: "align-left"}, i18n("Status")), 
            React.createElement("th", {className: "align-left"}, i18n("Date")), 
            React.createElement("th", {className: "align-left"}, i18n("Duration"))
        )
        );
    }
});

var RecentActivityTableBody = React.createClass({displayName: "RecentActivityTableBody",
    render: function() {
        var isComplete = this.props.isComplete;
        var activities = this.props.activities;
        var fromProcess = this.props.fromProcess;
        if (activities.length !== 0) {
            return (
                React.createElement("tbody", null, 
                    
                        activities.map(function(activity) {
                            return (
                                React.createElement(RecentActivityTableRow, {activity: activity, fromProcess: fromProcess})
                            )
                        }), 
                    
                    React.createElement(RefreshRow, {isComplete: isComplete})
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "6"}, i18n("NoActivity"))
                    )
                )
            );
        }
    }
});

var RecentActivityTableRow = React.createClass({displayName: "RecentActivityTableRow",
    render: function() {
        var activity = this.props.activity;
        var fromProcess = this.props.fromProcess;
        var buildLifeUrlId = buildLifeUrl + activity.buildLifeId;
        var processUrlId = processUrl + activity.processId;
        var latestStamp = activity.latestStamp;
        if (!latestStamp) {
            latestStamp = i18n('N/A');
        }
        return (
            React.createElement("tr", null, 
                React.createElement("td", {className: "align-center"}, React.createElement("a", {href: buildLifeUrlId}, activity.buildLifeId)), 
                React.createElement(ProcessColumn, {fromProcess: fromProcess, processUrlId: processUrlId, activity: activity}), 
                React.createElement("td", {className: "align-center"}, latestStamp), 
                React.createElement("td", {className: "align-center", style: {backgroundColor: activity.statusColor, color: activity.statusSecondaryColor}}, 
                    i18n(activity.statusName)
                ), 
                React.createElement("td", {className: "align-center"}, 
                    activity.endDate
                ), 
                React.createElement("td", {className: "align-center"}, activity.duration)
           )
        );
    }
});

var ProcessColumn = React.createClass({displayName: "ProcessColumn",
    render: function() {
        var fromProcess = this.props.fromProcess;
        var processUrlId = this.props.processUrlId;
        var activity = this.props.activity;
        if (fromProcess && thisProcessId === activity.processId) {
            return (
                React.createElement("td", {className: "align-center"}, activity.processName)
            );
        }
        else {
            return (
                React.createElement("td", {className: "align-center"}, React.createElement("a", {href: processUrlId}, activity.processName))
            );
        }
    }
});

var RefreshRow = React.createClass({displayName: "RefreshRow",
    render: function() {
        var isComplete = this.props.isComplete;
        if (isComplete) {
            return (
                React.createElement("tr", {id: "refreshRow"}, 
                    React.createElement("td", {colSpan: "7", className: "align-center"}, 
                        React.createElement("a", {href: "#", onClick: this.refresh}, i18n('Refresh'))
                    )
                )
             );
        }
        else {
            return (
                React.createElement("tr", {id: "refreshRow"})
            );
        }
    },
    refresh : function() {
        jQuery("#refreshRow").hide();
        renderRecentActivity();
    }
});
