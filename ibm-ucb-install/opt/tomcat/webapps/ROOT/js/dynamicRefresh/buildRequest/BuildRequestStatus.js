/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildRequestStatus = React.createClass({displayName: "BuildRequestStatus",
    render: function() {
        var result = this.props.result;
        var status = result.status;
        if (!status) {
            status = i18n('N/A');
        }
        var statusColor = result.statusColor;
        var statusSecondColor = result.statusSecondColor;
         var mergedUrl = mergedBuildRequestUrl;
        return (
            React.createElement("div", {style: {backgroundColor:statusColor, color:statusSecondColor, padding: '3px'}}, 
                i18n(status), 
                React.createElement(StatusUrl, {result: result})
            )
        );
    }
});

var StatusUrl = React.createClass({displayName: "StatusUrl",
    render: function(){
        var result = this.props.result;
        var url, message;
        if (result.mergedIntoAnotherRequest) {
            url = mergedBuildRequestUrl;
            message = i18n('ViewMergedBuildRequest');
        }
        if ((result.status == 'Created New Build Life') || (result.buildLifeId != null && result.status == 'Started Workflow')) {
            url = buildLifeUrl;
            message = i18n('ViewBuildLife');
        }
        if (!result.buildLifeId && result.status == 'Started Workflow') {
            url = workflowCaseUrl;
            message = i18n('ViewCreatedProcess');
        }
        if (url && message) {
            return (
                React.createElement("a", {href: url}, 
                    " ", 
                    React.createElement("img", {border: "0", className: "vertical-align-bottom", src: statusImgUrl, title: message, alt: message})
                )
            );
        }
        else {
            return (
                React.createElement("div", null)
            );
        }
    }
});
