/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

renderBuildRequest = function() {
    var self = this;
    var restUrl = buildRequestRestUrl;
    jQuery.get(restUrl, function(result) {
        if (!result.isComplete) {
            setTimeout(function() {
                self.renderBuildRequest();
            }, 5000);
        }
        React.render(React.createElement(BuildRequestStatus, {result: result}), document.getElementById("buildRequestStatus"));
        React.render(React.createElement(BuildRequestProperty, {properties: result.properties}), document.getElementById("buildRequestProperty"));
        if (result.jobTrace.stepTraceArray && result.jobTrace.stepTraceArray.length !== 0) {
            React.render(React.createElement(BuildRequestSteps, {steps: result.jobTrace.stepTraceArray}), document.getElementById("buildRequestSteps"));
            React.render(React.createElement(BuildRequestErrors, {errors: result.jobTrace.errorArray}), document.getElementById("buildRequestErrors"));
        }
    }.bind(this));
};
