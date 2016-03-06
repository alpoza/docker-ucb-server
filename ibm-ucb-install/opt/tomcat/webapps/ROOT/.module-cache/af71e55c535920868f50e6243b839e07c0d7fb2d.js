/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var AgentDirLocks = React.createClass({displayName: "AgentDirLocks",
    render: function() {
        var workDirs = this.props.workDirs;
        var hasSystemAdmin = this.props.hasSystemAdmin;
            return (
               React.createElement("table", {className: "data-table"}, 
                    React.createElement("caption", null, i18n("AgentDirectoryLocks")), 
                    React.createElement(WorkDirTableHeader, null), 
                    React.createElement(WorkDirTableBody, {workDirs: workDirs, hasSystemAdmin: hasSystemAdmin})
               )
            );
    }
});

var WorkDirTableHeader = React.createClass({displayName: "WorkDirTableHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
              React.createElement("tr", null, 
                React.createElement("th", {scope: "col", align: "left", valign: "middle"}, i18n("Agent")), 
                React.createElement("th", {scope: "col", align: "left"}, i18n("Directory")), 
                React.createElement("th", {scope: "col", align: "left", width: "10%"}, i18n("Process"), " / ", i18n("Job")), 
                React.createElement("th", {scope: "col", align: "left", width: "10%"}, i18n("Actions"))
              )
            )
        );
    }
});

var WorkDirTableBody = React.createClass({displayName: "WorkDirTableBody",
    render: function() {
        var workDirs = this.props.workDirs;
        var hasSystemAdmin = this.props.hasSystemAdmin;
        if (workDirs.length === 0) {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "4", className: "align-left"}, i18n("NoAgentDirectoryLocks"))
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                   
                       workDirs.map(function(workDir) {
                            return (
                                React.createElement(Row, {workDir: workDir, hasSystemAdmin: hasSystemAdmin})
                            )
                        })
                    
                )
            );
        }
    }
});

var Row = React.createClass({displayName: "Row",
    render: function() {
        var workDir = this.props.workDir;
        var hasSystemAdmin = this.props.hasSystemAdmin;
        var urlId;
        var revokeUrlId;
        if (hasSystemAdmin && workDir.agentName != null) {
            revokeUrlId = baseRevokeUrl + "?agent_id="+ workDir.agentId +"&directory="+workDir.workDir;
        }

        if (workDir.isJobAcquired) {
            urlId = baseJobTraceUrl + workDir.acquirerId
        }
        else {
            urlId = baseWorkflowUrl + workDir.acquirerId;
        }
        return React.createElement(RowData, {urlId: urlId, workDir: workDir, revokeUrlId: revokeUrlId})
    }
});

var RowData = React.createClass({displayName: "RowData",
    render: function() {
        var urlId = this.props.urlId;
        var workDir = this.props.workDir;
        var revokeUrlId = this.props.revokeUrlId;
        var revokeRow;
        if (revokeUrlId) {
            revokeRow = React.createElement(RowRevokeData, {workDir: workDir, revokeUrlId: revokeUrlId})
        }
        return (
            React.createElement("tr", {className: "odd"}, 
                React.createElement("td", null, workDir.agentName), 
                React.createElement("td", {className: "nowrap"}, workDir.workDir), 
                React.createElement("td", {className: "align-center"}, 
                    React.createElement("a", {href: urlId}, 
                        React.createElement("img", {src: jobImgUrl}), 
                         workDir.acquirerId
                    )
                ), 
                revokeRow
            )
        );
    }
});

var RowRevokeData = React.createClass({displayName: "RowRevokeData",
    render: function() {
        var workDir = this.props.workDir;
        var revokeUrlId = this.props.revokeUrlId;
        if (this.props.revokeUrlId === undefined) {
            return (
                React.createElement("td", {className: "align-center-width"}
                )
            );
        }
        else {
             return (
                React.createElement("td", {className: "align-center-width"}, 
                    React.createElement("a", {title: i18n('Revoke'), onClick: this.confirmLink, href: revokeUrlId}, 
                        i18n('Revoke')
                    )
                 )
            );
        }
    },
    confirmLink: function() {
        var workDir = this.props.workDir;
        var agentLockDir = workDir.agentName +":"+ workDir.workDir;
        return basicConfirm(i18n('RemoveDirectoryLockConfirm', agentLockDir));
    }
});

