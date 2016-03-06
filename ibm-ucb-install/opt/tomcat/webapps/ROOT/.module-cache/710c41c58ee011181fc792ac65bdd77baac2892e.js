/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var JobTraceTablebody = React.createClass({displayName: "JobTraceTablebody",
    render: function () {
        var jobTrace = this.props.jobTrace;
        var isExpanded = this.props.isExpanded;
        var wcDivId = this.props.wcDivId;
        var rowClass = "";
        var rowStyle = {};
        var statusName = jobTrace.statusName;
        if (statusName && statusName.toLowerCase().indexOf('not needed') >= 0) {
            rowClass = "status-not-needed";
            rowStyle = {"display": "none"};
            $('statusNotNeededToggleButton').show();
        }
        if (!isExpanded) {
            rowStyle = {"display": "none"};
        }
        var jtDivId = wcDivId + "_job_" + jobTrace.id;
        var jtClientSessionKey = clientSessionKeyPrefix + jtDivId;
        var isJobExpanded = clientSession[jtClientSessionKey] || !jobTrace.done;
        var detailsUrl = detailsUrlId + "?job_trace_id=" + jobTrace.id;

        return (
            React.createElement("tbody", {id: jtDivId, className: rowClass, style: rowStyle}, 
                React.createElement("tr", {className: "bl_workflow_row_tr even"}, 
                    React.createElement("td", {className: "align-left"}, 
                        React.createElement("span", {className: "paddingLeft15"}, 
                            React.createElement("a", {id: "toggleJobSteps_" + jtDivId, href: "#", onClick: function(){toggleJobSteps(document.getElementById("toggleJobSteps_" + jtDivId)); return false;}, title: i18n('ShowHideSteps')}, 
                                React.createElement("img", {src: isJobExpanded ? iconMinusUrl : iconPlusUrl, title: i18n('ShowHideSteps'), alt: i18n('ShowHideSteps'), border: "0"})
                            ), 
                            React.createElement("a", {href: detailsUrl, title: i18n('ViewJob')}, jobTrace.name)
                        )
                    ), 
                    React.createElement("td", {className: "align-center"}, jobTrace.agentName), 
                    React.createElement("td", {className: "align-center"}, 
                        jobTrace.offset
                    ), 
                    React.createElement("td", {className: "align-center"}, jobTrace.duration), 
                    React.createElement("td", {className: "align-center", style: {backgroundColor: jobTrace.statusColor, color: jobTrace.statusSecondaryColor}}, i18n(jobTrace.statusName)), 
                    React.createElement("td", {className: "align-left"}, 
                        React.createElement("span", null, 
                            React.createElement(JobLogContent, {jobTrace: jobTrace}), 
                            React.createElement(SpacerImg, null), 
                            React.createElement("a", {href: detailsUrl, title: i18n('ViewJob')}, 
                                React.createElement("img", {src: iconMagnifyUrl, alt: i18n('ViewJob'), width: "16", height: "16", style: {"border": 0}})
                            )
                        )
                    )
                )
           )
        );
    }
});

var JobLogContent = React.createClass({displayName: "JobLogContent",
    render: function() {
        var jobTrace = this.props.jobTrace;
        if (jobTrace.jobLogNotEmpty) {
            var viewJobLogUrl = viewLogUrlId + "?log_name=" + encodeURI(jobTrace.jobLogName) + "&pathSeparator=" + encodeURI(jobTrace.pathSeparator);
            var data = {
                "showPopUpUrl": viewJobLogUrl,
                "dialogWidth": windowWidth() - 100,
                "dialogHeight": windowHeight() - 100,
                "title": i18n('ShowLog'),
                "imgSrc": viewJobLogIconUrl
            };
            return (
                React.createElement(ShowPopupLink, {data: data})
            );
        }
        else {
            return (
                React.createElement("img", {src: viewJobLogDisabledIconUrl, alt: i18n('NoLog'), title: i18n('NoLog'), border: "0"})
            );
        }
    }
});
