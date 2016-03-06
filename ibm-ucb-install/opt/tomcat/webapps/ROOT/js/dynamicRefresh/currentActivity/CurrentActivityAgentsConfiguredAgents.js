/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

renderCurrentActivityAgents = function() {
    renderConfiguredAgents();
    renderAgentDirLocks();
};

renderConfiguredAgents = function() {
    var pageIndex = $("activityPageIndex").value;
    var self = this;
    var agentsPaginatedRestUrl = agentsRestUrl + pageIndex;
    jQuery.get(agentsPaginatedRestUrl, function(result) {
        setTimeout(function() {
            self.renderConfiguredAgents();
        }, 5000);

        React.render(React.createElement(ConfigAgents, {agents: result}), document.getElementById("configuredAgents"));
    }.bind(this));
};

renderAgentDirLocks = function() {
    jQuery.get(currentActivityAgentDirLockRestUrl, function(result) {
        setTimeout(function() {
            self.renderAgentDirLocks();
        }, 5000);

        React.render(React.createElement(AgentDirLocks, {workDirs: result.workDirs, hasSystemAdmin: result.hasSystemAdmin}), document.getElementById("agentDirLocks"));
    }.bind(this));
};

var ConfigAgents = React.createClass({displayName: "ConfigAgents",
    render: function() {
        var agents = this.props.agents;
            return (
               React.createElement("table", {className: "data-table"}, 
                    React.createElement(ConfigAgentsTableHeader, null), 
                    React.createElement(ConfigAgentsTableBody, {agents: agents})
               )
            );
    }
});


var ConfigAgentsTableHeader = React.createClass({displayName: "ConfigAgentsTableHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
              React.createElement("tr", null, 
                React.createElement("th", {scope: "col", align: "left"}, i18n("Name")), 
                React.createElement("th", {scope: "col", align: "left"}, i18n("Description")), 
                React.createElement("th", {scope: "col", align: "left"}, i18n("ActiveJobs"), " "), 
                React.createElement("th", {scope: "col", align: "left"}, i18n("AgentThroughputMetric")), 
                React.createElement("th", {scope: "col", align: "left"}, i18n("Version")), 
                React.createElement("th", {scope: "col", align: "left"}, i18n("Status"))
              )
            )
        );
    }
});

var ConfigAgentsTableBody = React.createClass({displayName: "ConfigAgentsTableBody",
    render: function() {
        var agents = this.props.agents;
        if (agents.length === 0) {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "6", className: "align-left"}, i18n("No records found."))
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                   
                       agents.map(function(agent) {
                            return (
                                React.createElement(ConfigAgentRow, {agent: agent})
                            )
                        })
                    
                )
            );
        }
    }
});

var ConfigAgentRow = React.createClass({displayName: "ConfigAgentRow",
    render: function() {
        var agent = this.props.agent;
        var agentStatus = React.createElement(AgentStatusRowData, {status: agent.status});
        var activeJobs = agent.activeJobs ? agent.activeJobs : 0;
        var version = agent.version !== 'N/A' ? agent.version : i18n("N/A");
        return (
             React.createElement("tr", {className: "odd"}, 
                React.createElement("td", {className: "nowrap"}, agent.name), 
                React.createElement("td", null, agent.description), 
                React.createElement("td", {className: "align-center-nowrap"}, activeJobs, "/", agent.maxJobs), 
                React.createElement("td", {className: "align-center-nowrap"}, agent.throughput), 
                React.createElement("td", {className: "align-center-nowrap"}, version), 
                agentStatus
            )
        );
    }
});




var AgentStatusRowData = React.createClass({displayName: "AgentStatusRowData",
    render: function() {
        var status = this.props.status;
        //this color is for other case
        var color = "#ff8000";

        if (status == "Online") {
             color = "#8dd889";
        }
        else if (status == "Offline") {
            color = "#c86f6f";
        }
        else if (status == "Upgrading" || status == "Restarting") {
            color = "#f4e48f";
        }
        else if (status =="Queued For Upgrade" || status == "Queued For Restart") {
            color = "#0033ff";
        }

        return (
            React.createElement("td", {className: "align-center-nowrap", style: {"background-color": color}}, 
                i18n(status)
            )
         );
    }
});



