/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildLifeActions = React.createClass({displayName: "BuildLifeActions",
    render: function() {
        if (!this.props.isComplete) {
            return (
               React.createElement("div", {className: "secondary_process_row"}, 
                    React.createElement(ActionContent, null), 
                    React.createElement(Prioritize, null)
               )
            );
        }
        else {
            var showAddStamp = canAddStamp && isActive && !isArchived && !isPreflight;
            var showAddStatus = canAddStatus && isActive && !isArchived && !isPreflight;
            var showInactivate = isActive && !isPreflight && canDelete;
            var showDelete = canDelete || isPreflight;
            var showArchive = canDelete && !isArchived && isActive && !isPreflight;
            var showUnarchive = canWrite && isArchived;
            if (showAddStamp || showAddStatus || showInactivate || showDelete || showArchive || showUnarchive){
                return (
                    React.createElement("div", {className: "secondary_process_row"}, 
                        React.createElement(ShowAddActions, {showAddStamp: showAddStamp, showAddStatus: showAddStatus}), 
                        React.createElement(ShowInactivateContent, {showInactivate: showInactivate}), 
                        React.createElement(ShowDeleteContent, {showDelete: showDelete}), 
                        React.createElement(ShowArchiveContent, {showArchive: showArchive}), 
                        React.createElement(ShowUnarchiveContent, {showUnarchive: showUnarchive})
                    )
                );
            }
            else {
                return (
                    React.createElement("div", null)
                );
            }
        }
    }
});

var ActionContent = React.createClass({displayName: "ActionContent",
    render: function() {
        return (
            React.createElement("div", null, 
                React.createElement(AbortContent, null), 
                React.createElement(SuspendRunningContent, null)
            )
        );

    }
});

var Prioritize = React.createClass({displayName: "Prioritize",
    render: function() {
        if (prioritizationPermission && isRunning && !isPriority){
            var prioritizeUrl = prioritizeUrlId + "?workflow_case_id=" + encodeURI(originatingCaseId);
            var data = {
                "hrefUrl": prioritizeUrl,
                "confirmI18n": i18n('BuildLifePrioritizeConfirm'),
                "hrefTitle": i18n('Prioritize')
            };
            return(
                React.createElement("div", {className: "bl_action_label"}, 
                    React.createElement(BasicConfirmLink, {data: data})
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

var AbortContent = React.createClass({displayName: "AbortContent",
    render: function() {
        if (isRunning || isSuspended || isQueued) {
            var abortUrl = abortUrlId + "?workflow_case_id=" + encodeURI(originatingCaseId);
            var data = {
                "hrefUrl": abortUrl,
                "confirmI18n": i18n('BuildLifeAbortConfirm'),
                "hrefTitle": i18n('Abort')
            };
            return (
                React.createElement("div", {className: "bl_action_label"}, 
                    React.createElement(BasicConfirmLink, {data: data})
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

var SuspendRunningContent = React.createClass({displayName: "SuspendRunningContent",
    render: function() {
        if (isSuspended) {
            var resumeUrl = resumeUrlId + "?workflow_case_id=" + encodeURI(originatingCaseId);
            var data = {
                "hrefUrl": resumeUrl,
                "confirmI18n": i18n('BuildLifeResumeConfirm'),
                "hrefTitle": i18n('Resume')
            };
            return(
                React.createElement("div", {className: "bl_action_label"}, 
                    React.createElement(BasicConfirmLink, {data: data})
                )
            );
        }
        else if (isRunning) {
            var suspendUrl = suspendUrlId + "?workflow_case_id=" + encodeURI(originatingCaseId);
            var data = {
                "hrefUrl": suspendUrl,
                "confirmI18n": i18n('BuildLifeSuspendConfirm'),
                "hrefTitle": i18n('Suspend')
            };
            return(
                React.createElement("div", {className: "bl_action_label"}, 
                    React.createElement(BasicConfirmLink, {data: data})
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

var ShowAddActions = React.createClass({displayName: "ShowAddActions",
    render: function() {
        var showAddStamp = this.props.showAddStamp;
        var showAddStatus = this.props.showAddStatus;

        var divider = "";
        var addStatusContent = "";
        var addStampContent = "";

        if (showAddStamp) {
            addStampContent = React.createElement(ShowAddStampContent, {showAddStamp: showAddStamp})
        }

        if (showAddStatus) {
            if (showAddStamp) {
                divider = React.createElement("a", null, " | ");
            }
            addStatusContent = React.createElement(ShowAddStatusContent, {showAddStatus: showAddStatus})
        }

        return (
            React.createElement("div", {className: "bl_action_label"}, 
                addStampContent, 
                divider, 
                addStatusContent
            )
        );
    }
});

var ShowAddStampContent = React.createClass({displayName: "ShowAddStampContent",
    render: function() {
        var showAddStamp = this.props.showAddStamp;
        if (showAddStamp) {
            var addStampUrl = addStampUrlId + "?buildLifeId=" + encodeURI(buildLifeId);
            var assignLabelUrl = assignLabelUrlId + "?buildLifeId=" + encodeURI(buildLifeId);
            var dataStamp = {
                "showPopUpUrl": addStampUrl,
                "dialogWidth": 800,
                "dialogHeight": 640,
                "title": i18n('AddStampHelp'),
                "text": i18n('AddStamp')
            };
            var dataLabel = {
                "showPopUpUrl": assignLabelUrl,
                "dialogWidth": 800,
                "dialogHeight": 640,
                "title": i18n('BuildLifeAssignLabelHelp'),
                "text": i18n('Assign Label')
            };
            return(
                React.createElement("span", null, 
                    React.createElement(ShowPopupLinkNoImg, {data: dataStamp}), 
                    React.createElement("a", null, " | "), 
                    React.createElement(ShowPopupLinkNoImg, {data: dataLabel})
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

var ShowAddStatusContent = React.createClass({displayName: "ShowAddStatusContent",
    render: function() {
        var showAddStatus = this.props.showAddStatus;
        if (showAddStatus) {
            var addStatusUrl = addManualStatusUrlId + "?buildLifeId=" + encodeURI(buildLifeId);
            var data = {
                "showPopUpUrl": addStatusUrl,
                "dialogWidth": 800,
                "dialogHeight": 640,
                "title": i18n('AddStatusHelp'),
                "text": i18n('AddStatus')
            };
            return(
                React.createElement(ShowPopupLinkNoImg, {data: data})
            );
        }
        else {
            return (
                React.createElement("div", null)
            );
        }
    }
});

var ShowInactivateContent = React.createClass({displayName: "ShowInactivateContent",
    render: function() {
        var showInactivate = this.props.showInactivate;
        if (showInactivate) {
            var inactivateUrl = inactivateUrlId + "?buildLifeId=" + encodeURI(buildLifeId);
            var data = {
                "hrefUrl": inactivateUrl,
                "confirmI18n": i18n('BuildLifeInactivateConfirm'),
                "hrefTitle": i18n('Inactivate')
            };
            return(
                React.createElement("div", {className: "bl_action_label"}, 
                    React.createElement(BasicConfirmLink, {data: data})
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

var ShowDeleteContent = React.createClass({displayName: "ShowDeleteContent",
    render: function() {
        var showDelete = this.props.showDelete;
        if (showDelete) {
            var deleteUrl = deleteUrlId + "?buildLifeId=" + encodeURI(buildLifeId);
            var data = {
                "hrefUrl": deleteUrl,
                "confirmI18n": i18n('BuildLifeDeleteConfirm'),
                "hrefTitle": i18n('Delete')
            };
            return(
                React.createElement("div", {className: "bl_action_label"}, 
                    React.createElement(BasicConfirmLink, {data: data})
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

var ShowArchiveContent = React.createClass({displayName: "ShowArchiveContent",
    render: function() {
        var showArchive = this.props.showArchive;
        if (showArchive) {
            var archiveUrl = archiveUrlId + "?buildLifeId=" + encodeURI(buildLifeId);
            var data = {
                "hrefUrl": archiveUrl,
                "confirmI18n": i18n('BuildLifeArchiveConfirm'),
                "hrefTitle": i18n('Archive')
            };
            return(
                React.createElement("div", {className: "bl_action_label"}, 
                    React.createElement(BasicConfirmLink, {data: data})
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

var ShowUnarchiveContent = React.createClass({displayName: "ShowUnarchiveContent",
    render: function() {
        var showUnarchive = this.props.showUnarchive;
        if (showUnarchive) {
            var unarchiveUrl = unarchiveUrlId + "?buildLifeId=" + encodeURI(buildLifeId);
            var data = {
                "hrefUrl": unarchiveUrl,
                "confirmI18n": i18n('BuildLifeUnarchiveConfirm'),
                "hrefTitle": i18n('Unarchive')
            };
            return(
                React.createElement("div", {className: "bl_action_label"}, 
                    React.createElement(BasicConfirmLink, {data: data})
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
