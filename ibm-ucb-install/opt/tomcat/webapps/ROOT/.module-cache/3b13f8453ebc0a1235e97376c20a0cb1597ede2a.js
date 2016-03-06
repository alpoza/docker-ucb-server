/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var Workflow = React.createClass({displayName: "Workflow",
    render: function() {
        var data = this.props.data;
        var workflowCase = data.workflowCase;
        var isExpanded = data.isExpanded;
        var toggleImgUrl = iconPlusUrl;
        if (isExpanded || (workflowCase.jobTraceArray.length === 0)) {
            toggleImgUrl = iconMinusUrl;
        }
        return (
            React.createElement("tbody", {className: "workflow_row"}, 
                React.createElement("tr", {className: "bl_workflow_row" + (workflowCase.priorityHigh ? " priority" : "")}, 
                    React.createElement("td", {className: "align-left"}, 
                        React.createElement("a", {id: "toggleWorkflowJobs_" + workflowCase.id, href: "#", onClick: function(){toggleWorkflowJobs(document.getElementById("toggleWorkflowJobs_" + workflowCase.id)); return false;}, title: i18n('ShowHideJobs')}, 
                            React.createElement("img", {src: toggleImgUrl, title: i18n('ShowHideJobs'), alt: i18n('ShowHideJobs'), border: "0"})
                        ), 
                        workflowCase.name
                    ), 
                    React.createElement("td", {className: "align-center"}), 
                    React.createElement("td", {className: "align-center"}, workflowCase.startDate), 
                    React.createElement("td", {className: "align-center"}, (workflowCase.startDate != '') ? workflowCase.duration : ''), 
                    React.createElement("td", {className: "align-center", style: {backgroundColor: workflowCase.statusColor, color: workflowCase.statusSecondaryColor}}, i18n(workflowCase.statusName)), 
                    React.createElement("td", {className: "align-left"}, 
                        React.createElement(WorkflowLogContent, {workflowCase: workflowCase}), 
                        React.createElement(BuildLifeConfirmContent, {workflowCase: workflowCase}), 
                        React.createElement(PrioritizeConfirmContent, {workflowCase: workflowCase}), 
                        React.createElement(ProcessDeleteConfirmContent, {workflowCase: workflowCase}), 
                        React.createElement(RestartWorkflowContent, {workflowCase: workflowCase})
                    )
                )
            )
        );
    }
});

var WorkflowLogContent = React.createClass({displayName: "WorkflowLogContent",
    render: function() {
        var workflowCase = this.props.workflowCase;
        if (workflowCase.workflowLogNotEmpty) {
            var viewWorkflowLogUrl = viewLogUrlId + "?log_name=" + encodeURI(workflowCase.workflowLogName) + "&pathSeparator=" + encodeURI(workflowCase.pathSeparator);
            var data = {
                "showPopUpUrl": viewWorkflowLogUrl,
                "dialogWidth": windowWidth() - 100,
                "dialogHeight": windowHeight() - 100,
                "title": i18n('ShowLog'),
                "imgSrc": viewWorkflowLogIconUrl
            };
            return (
                React.createElement(ShowPopupLink, {data: data})
            );
        }
        else {
            return (
                React.createElement("img", {src: viewWorkflowLogDisabledIconUrl, alt: i18n('NoLog'), title: i18n('NoLog'), border: "0"})
            );
        }
    }
});

var BuildLifeConfirmContent = React.createClass({displayName: "BuildLifeConfirmContent",
    render: function() {
        var workflowCase = this.props.workflowCase;
        var linkData = {};
        linkData.confirmI18n = i18n('BuildLifeAbortConfirm');
        linkData.hrefTitle = i18n('Abort');
        linkData.imgSrc = iconDeleteUrl;
        if (workflowCase.abortOrSuspendPermission && !workflowCase.isComplete && workflowCase.isSuspended) {
            var abortUrl = abortUrlId + "?workflow_case_id=" + encodeURI(workflowCase.id);
            linkData.hrefUrl = abortUrl;
            var resumeUrl = resumeUrlId + "?workflow_case_id=" + encodeURI(workflowCase.id);
            var data = {
                "hrefUrl": resumeUrl,
                "confirmI18n": i18n('BuildLifeResumeConfirm'),
                "hrefTitle": i18n('Resume'),
                "imgSrc": iconResumeUrl
            };
            return (
                React.createElement("span", null, 
                    React.createElement(BasicConfirmLink, {data: linkData}), 
                    React.createElement(BasicConfirmSpan, {data: data})
                )
            );
        }
        else if (workflowCase.abortOrSuspendPermission && !workflowCase.isComplete && workflowCase.isRunning) {
            var abortUrl = abortUrlId + "?workflow_case_id=" + encodeURI(workflowCase.id);
            linkData.hrefUrl = abortUrl;
            var suspendUrl = suspendUrlId + "?workflow_case_id=" + encodeURI(workflowCase.id);
            var data = {
                "hrefUrl": suspendUrl,
                "confirmI18n": i18n('BuildLifeSuspendConfirm'),
                "hrefTitle": i18n('Suspend'),
                "imgSrc": iconSuspendUrl
            };
            return (
                React.createElement("span", null, 
                    React.createElement(BasicConfirmLink, {data: linkData}), 
                    React.createElement(BasicConfirmSpan, {data: data})
                )
            );
        }
        else {
            return (React.createElement("span", null));
        }
    }
});

var PrioritizeConfirmContent = React.createClass({displayName: "PrioritizeConfirmContent",
    render: function() {
        var workflowCase = this.props.workflowCase;
        if (workflowCase.prioritizationPermission && !workflowCase.isComplete && !workflowCase.priorityHigh && (workflowCase.statusName != 'Suspended')) {
            var prioritizeUrl = prioritizeUrlId + "?workflow_case_id=" + encodeURI(workflowCase.id);
            var data = {
                "hrefUrl": prioritizeUrl,
                "confirmI18n": i18n('BuildLifePrioritizeConfirm'),
                "hrefTitle": i18n('Prioritize'),
                "imgSrc": iconPriorityUrl
            };
            return(
                React.createElement(BasicConfirmSpan, {data: data})
            );
        }
        else {
            return (React.createElement("span", null));
        }
    }
});

var ProcessDeleteConfirmContent = React.createClass({displayName: "ProcessDeleteConfirmContent",
    render: function() {
        var workflowCase = this.props.workflowCase;
        if (workflowCase.canExecute && workflowCase.statusDone) {
            if (workflowCase.canDelete && workflowCase.workflowBuildProfile == '') {
                var deleteWorkflowUrl = deleteWorkflowUrlId + "?workflow_case_id=" + encodeURI(workflowCase.id);
                var data = {
                    "hrefUrl": deleteWorkflowUrl,
                    "confirmI18n": i18n('BuildLifeProcessDeleteConfirm'),
                    "hrefTitle": i18n('Delete'),
                    "imgSrc": iconDeleteUrl
                };
                return (
                    React.createElement(BasicConfirmSpan, {data: data})
                );
            }
            else {
                return (
                    React.createElement(SpacerImg, null)
                );
            }
        }
        else {
            return (
                React.createElement(SpacerImg, null)
            );
        }
    }
});

var RestartWorkflowContent = React.createClass({displayName: "RestartWorkflowContent",
    render: function() {
        var workflowCase = this.props.workflowCase;
        if (workflowCase.canExecute && workflowCase.statusDone) {
            if (!workflowCase.isOperation && workflowCase.restartable) {
                var restartWorkflowUrl = restartWorkflowUrlId + "?workflow_case_id=" + encodeURI(workflowCase.id) + "&buildLifeId=" + encodeURI(buildLifeId);
                var data = {
                    "showPopUpUrl": restartWorkflowUrl,
                    "dialogWidth": 800,
                    "dialogHeight": 640,
                    "title": i18n('Restart'),
                    "imgSrc": iconRestartUrl
                };
                return (
                    React.createElement(ShowPopupSpan, {data: data})
                );
            }
            else {
                return (
                    React.createElement(SpacerImg, null)
                );
            }
        }
        else {
            return (
                React.createElement(SpacerImg, null)
            );
        }
    }
});
