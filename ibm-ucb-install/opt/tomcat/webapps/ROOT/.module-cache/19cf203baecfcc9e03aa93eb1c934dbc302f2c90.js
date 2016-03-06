/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */
renderPorjectDashboard = function() {
    renderRecentActivity();
};

renderRecentActivity = function() {
    var self = this;

    // When we click the Refresh button, we should also refresh statuses and builds just in case something completed since
    // the last build we see on the dashboard
    self.refreshLatestStatus();
    self.refreshLatestBuilds();

    var fromProcess = false;
    jQuery.get(recentProjectActivityRestUrl, function(result) {
        // Make a new request 5 seconds after receiving the response
        setTimeout(function() {
            if (!result.isComplete) {
                self.renderPorjectDashboard();
            }
            else {
                jQuery("#refreshRow").show();
                self.refreshLatestStatus();

                // Data has to propagate through an event system, so the latest builds data is a race condition. Slow it down
                setTimeout(function() {
                    self.refreshLatestBuilds();
                }, 1000);
            }
        }, 5000);
        React.render(React.createElement(RecentActivityTable, {isComplete: result.isComplete, activities: result.recentActivities, fromProcess: fromProcess}), document.getElementById("projectRecentActivityTable"));
    }.bind(this));
};

refreshLatestStatus = function() {
    if (!isLatestStatusLoading) {
        isLatestStatusLoading = true;
        jQuery.get(latestStatusRestUrl, function(result) {
            isLatestStatusLoading = false;
            React.render(React.createElement(ProjectLatestStatusTable, {activities: result}), document.getElementById("latestStatusTable"));
        }.bind(this));
    }
};


// This seems to be really slow. This is a prime example of why we should shift to using web sockets to push rather than poll
refreshLatestBuilds = function() {
    if (!isLatestBuildsLoading) {
        isLatestBuildsLoading = true;
        jQuery.get(latestBuildsRestUrl, function(result) {
            isLatestBuildsLoading = false;
            React.render(React.createElement(ProjectLatestBuildsTable, {activities: result}), document.getElementById("latestBuildsTable"));
        }.bind(this));
    }
};
