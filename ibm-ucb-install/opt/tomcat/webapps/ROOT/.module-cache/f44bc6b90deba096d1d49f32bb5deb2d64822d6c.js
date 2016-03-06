/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */
renderProcessDashboard = function() {
    renderRecentActivity();
    refreshLatestStatus();
    refreshDependencyConfiguration();
};

renderRecentActivity = function() {
    var self = this;

    // When we click the Refresh button, we should also refresh other tables just in case something completed since
    // the last build we see on the dashboard
    refreshLatestStatus();
    refreshDependencyConfiguration();
    refreshSuccessReport();

    var fromProcess = true;
    jQuery.get(recentProcessActivityRestUrl, function(result) {
        if (!result.isComplete) {
            // Make a new request 5 seconds after receiving the response
            setTimeout(function() {
                self.renderRecentActivity();
            }, 5000);
         }
         else {
            jQuery("#refreshRow").show();
            refreshLatestStatus();
            refreshDependencyConfiguration();
            refreshSuccessReport();
         }
         React.render(React.createElement(RecentActivityTable, {isComplete: result.isComplete, activities: result.activities, fromProcess: fromProcess}), document.getElementById("processRecentActivityTable"));
    }.bind(this));
};

refreshLatestStatus = function() {
    if (!isLatestStatusLoading) {
        isLatestStatusLoading = true;
        jQuery.get(processLatestStatusRestUrl, function(result) {
            React.render(React.createElement(LatestStatusTable, {activities: result}), document.getElementById("processLatestStatusTable"));
            isLatestStatusLoading = false;
        }.bind(this));
    }
};

refreshDependencyConfiguration = function() {
    if (!isDependencyConfigurationLoading) {
        isDependencyConfigurationLoading = true;
        jQuery.get(processDependencyRestUrl, function(result) {
            React.render(React.createElement(DependencyConfigurationTable, {dependencies: result.dependencies, inaccessibleDependencyCount: result.inaccessibleDependencyCount}), document.getElementById("processDependencyConfigurationTable"));
            isDependencyConfigurationLoading = false;
        }.bind(this));
    }
};

refreshSuccessReport = function() {
    if (!isSuccessReportLoading) {
        isSuccessReportLoading = true;
        var time = document.getElementById("successReportNumber").value;
        var typeElement = document.getElementById("successReportType");
        var typeIndex = typeElement.selectedIndex;
        var type = typeElement.options[typeIndex].value;
        var successReportUrl = successReportRestUrl + "?time=" + time + "&type=" + type;
        jQuery.get(successReportUrl, function(result) {
            updateSuccessReportBox(result);
            isSuccessReportLoading = false;
        }.bind(this));
    }
};
