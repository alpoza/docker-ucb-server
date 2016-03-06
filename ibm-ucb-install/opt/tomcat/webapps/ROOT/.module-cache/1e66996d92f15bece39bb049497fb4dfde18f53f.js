/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

renderRecentActivity = function() {
    var self = this;
    var fromProcess = true;
    jQuery.get(secondaryProcessActivityRestUrl, function(result) {
        if (!result.isComplete) {
            // Make a new request 5 seconds after receiving the response
            setTimeout(function() {
                self.renderRecentActivity();
            }, 5000);
         }
         else {
            jQuery("#refreshRow").show();
         }
         React.render(React.createElement(RecentActivityTable, {isComplete: result.isComplete, activities: result.activities, fromProcess: fromProcess}), document.getElementById("SecondaryProcessRecentActivityTable"));
    }.bind(this));
};
