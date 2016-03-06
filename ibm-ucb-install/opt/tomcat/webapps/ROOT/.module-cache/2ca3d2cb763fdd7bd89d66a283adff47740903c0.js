/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var MyActivity = React.createClass({displayName: "MyActivity",
    render: function() {
        var activities = this.props.activities;
        var isComplete = this.props.isComplete;
        return (
            React.createElement("div", null, 
                React.createElement(MyActivityTable, {activities: activities, isComplete: isComplete})
            )
        );
    }
});

var MyActivityTable = React.createClass({displayName: "MyActivityTable",
    render: function() {
        var activities = this.props.activities;
        var isComplete = this.props.isComplete;
        if (activities.length == 0) {
            return (
                React.createElement("table", {className: "data-table"}, 
                    React.createElement(Header, null), 
                    React.createElement("tbody", null, 
                        React.createElement("tr", null, React.createElement("td", {colSpan: "7", className: "align-left"}, React.createElement("em", null, i18n("NoActivity")))), 
                        React.createElement(RefreshRow, {isComplete: isComplete})
                    )
               )
            );
        }
        else {
            return (
                React.createElement("table", {className: "data-table"}, 
                    React.createElement(Header, null), 
                    React.createElement("tbody", null, 
                    
                        activities.map(function(activity) {
                            return (
                                React.createElement(Row, {activity: activity})
                            )
                        }), 
                    
                    React.createElement(RefreshRow, {isComplete: isComplete})
                    )
               )
            );
        }
    }
});

var Header = React.createClass({displayName: "Header",
    render: function() {
        return (
            React.createElement("thead", null, 
                React.createElement("tr", null, 
                    React.createElement("th", {className: "align-center", width: "4%"}, " "), 
                    React.createElement("th", {className: "align-left", width: "6%"}, i18n("ID")), 
                    React.createElement("th", {className: "align-left"}, i18n("Project")), 
                    React.createElement("th", {className: "align-left"}, i18n("Process")), 
                    React.createElement("th", {className: "align-center"}, i18n("Status")), 
                    React.createElement("th", {className: "align-center"}, i18n("Stamp")), 
                    React.createElement("th", {className: "align-center", width: "10%"}, i18n("Date"))
                )
           )
        );
    }
});

var Row = React.createClass({displayName: "Row",
    render: function() {
        var activity = this.props.activity;
        return (
            React.createElement("tr", {className: "even"}, 
               React.createElement(IconColumn, {activity: activity}), 
               React.createElement(IdColumn, {activity: activity}), 
               React.createElement(Columns, {activity: activity})
           )
        );
    }
});

var IconColumn = React.createClass({displayName: "IconColumn",
    render: function() {
        var activity = this.props.activity;
        var url = activity.requestUrl;
        var title = i18n('ViewRequest');
        var icon = requestImg;
        var iconText = activity.requestId;
        if (activity.buildLifeId != null) {
            url = activity.buildLifeUrl;
            title = i18n('ViewBuildLife');
            icon = buildLifeImg;
            iconText = activity.buildLifeId;
        }
        else if (activity.workflowCaseId != null) {
            url = activity.workflowCaseUrl;
            title = i18n('ViewOperation');
            icon = workflowImg;
            iconText = activity.workflowCaseId;
        }
        return (
            React.createElement("td", {className: "align-right nowrap", width: "4%"}, 
                React.createElement("a", {href: url, title: title}, 
                    React.createElement("img", {border: "0", src: icon, title: iconText, alt: iconText})
                )
            )
        );
    }
});

var IdColumn = React.createClass({displayName: "IdColumn",
    render: function() {
        var activity = this.props.activity;
        var url = activity.requestUrl;
        var title = i18n('ViewRequest');
        var linkText = activity.requestId;
        if (activity.buildLifeId != null) {
            url = activity.buildLifeUrl;
            title = i18n('ViewBuildLife');
            linkText = activity.buildLifeId;
        }
        else if (activity.workflowCaseId != null) {
            url = activity.workflowCaseUrl;
            title = i18n('ViewOperation');
            linkText = activity.workflowCaseId;
        }
        return (
            React.createElement("td", {className: "align-left nowrap", width: "6%"}, 
                React.createElement("a", {href: url, title: title}, 
                    linkText
                )
            )
        );
    }
});

var Columns = React.createClass({displayName: "Columns",
    render: function() {
        var activity = this.props.activity;
        var statusColor = "#f6f4d8";
        var stamp = i18n('N/A');
        var startDate = i18n('N/A');
        var statusName = i18n('Running');
        if (activity.statusColor) {
            statusColor = activity.statusColor;
        }
        if (activity.stamp) {
            stamp = activity.stamp;
        }
        if (activity.startDate) {
            startDate = activity.startDate;
        }
        if (activity.statusName) {
            statusName = i18n(activity.statusName);
        }
        return (
            React.createElement("div", null, 
                React.createElement("td", {className: "align-left"}, 
                    React.createElement("a", {href: activity.projectUrl, title: i18n('ViewProjectDashboard')}, 
                        activity.project
                    )
                ), 
                React.createElement("td", {className: "align-left"}, 
                    React.createElement("a", {href: activity.workflowUrl, title: i18n('ViewProcessDashboard')}, 
                        activity.workflow
                    )
                ), 
                React.createElement("td", {className: "align-center nowrap", style: {backgroundColor:statusColor}}, 
                     statusName
                ), 
                React.createElement("td", {className: "align-center"}, 
                    stamp
                ), 
                React.createElement("td", {className: "align-center nowrap"}, 
                    startDate
                )
           )
        );
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
        renderMyActivity();
    }
});

renderMyActivity = function() {
    var pageIndex = $("activityPageIndex").value;
    var restUrl = myActivityRestUrl + pageIndex;
    var self = this;
    jQuery.get(restUrl, function(result) {
        if (!result.isComplete) {
            // Make a new request 5 seconds after receiving the response
            setTimeout(function() {
                self.renderMyActivity();
            }, 5000);
        }
        else {
            jQuery("#refreshRow").show();
        }
        React.render(React.createElement(MyActivity, {activities: result.activities, isComplete: result.isComplete}), document.getElementById("myActivityTable"));
    }.bind(this));
};
