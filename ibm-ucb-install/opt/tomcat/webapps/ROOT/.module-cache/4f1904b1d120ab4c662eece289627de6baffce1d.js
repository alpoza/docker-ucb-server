var BuildLife = React.createClass({displayName: "BuildLife",
    render: function() {
        var workflowCases = this.props.workflowCases;
        var buildLifeCaseList = workflowCases.length;
        return (
            React.createElement("div", null, 
            
                workflowCases.map(function (workflowCase) {
                    var wcDivId = "blwc_" + workflowCase.id;
                    var wcClientSessionKey = clientSessionKeyPrefix + wcDivId;
                    var isOriginating = workflowCase.isOriginating;
                    var isExpanded = (workflowCase.endDate == ''|| workflowCase.status == '' || !workflowCase.statusDone || buildLifeCaseList == 1);
                    isExpanded = (isExpanded || clientSession[wcClientSessionKey]);
                    var data = {
                        "workflowCase": workflowCase,
                        "isExpanded": isExpanded,
                        "wcDivId": wcDivId
                    };
                    return (
                        React.createElement("div", {id: wcDivId, className: "bl_workflow_case_bg" + ((isOriginating)?" bl_workflow_case_originating" : "")}, 
                            React.createElement(BuildLifeTitle, {workflowCase: workflowCase}), 
                            React.createElement("table", {className: "data-table"}, 
                                React.createElement(BuildLifeTableHeader, {workflowCaseId: workflowCase.id}), 
                                React.createElement(Workflow, {data: data}), 
                                
                                    workflowCase.jobTraceArray.map(function(jobTrace) {
                                        var jtDivId = wcDivId + "_job_" + jobTrace.id;
                                        var jtClientSessionKey = clientSessionKeyPrefix + jtDivId;
                                        var isJobExpanded = clientSession[jtClientSessionKey] || !jobTrace.done;
                                        var steps = jobTrace.stepTraceArray.map(function(step){
                                                        return (
                                                            React.createElement(StepTrace, {jtDivId: jtDivId, isExpanded: isExpanded, isJobExpanded: isJobExpanded, step: step})
                                                        );
                                                    });
                                        return ([
                                            React.createElement(JobTraceTablebody, {jobTrace: jobTrace, isExpanded: isExpanded, wcDivId: wcDivId}),
                                            steps
                                        ]);
                                    })
                                
                            )
                        )
                    );
                }), 
            
            React.createElement("div", {style: {"clear": "both"}})
            )
        );
    }
});

var BuildLifeTitle = React.createClass({displayName: "BuildLifeTitle",
    render: function () {
        var workflowCase = this.props.workflowCase;
        var wcDivId = "blwc_" + workflowCase.id;
        var isOriginating = workflowCase.isOriginating;
        var imgUrl = iconWorkflow;
        if (isOriginating) {
            imgUrl = iconOrigProcess;
        }
        var viewRequestUrl = viewRequestUrlId + "?buildRequestId=" + encodeURI(workflowCase.requestId);

        return (
            React.createElement("div", {className: "large-text", style: {"padding-bottom": "10px"}}, 
                React.createElement("img", {src: imgUrl, alt: ""}), 
                workflowCase.name, 
                React.createElement("span", {className: "small-text paddingLeft"}, 
                "(", 
                    i18n('RequestByMessage', workflowCase.requestRequestSource, workflowCase.requestUserName), ",", 
                    React.createElement(BuildConfigContent, {workflowCase: workflowCase}), 
                    React.createElement("a", {href: viewRequestUrl, title: i18n('ViewRequest')}, 
                        React.createElement("img", {src: iconMagnifyUrl, title: i18n('ViewRequest'), alt: i18n('ViewRequest'), border: "0"}), 
                        i18n('ViewRequest')
                    ), 
                    React.createElement(RequestContext, {workflowCase: workflowCase}), 
                    React.createElement(WorkflowConfigContent, {workflowCase: workflowCase}), 
                 ")"
                 ), 
                 React.createElement(PriorityContent, {workflowCase: workflowCase})
             )
        );
    }
});

var BuildLifeTableHeader = React.createClass({displayName: "BuildLifeTableHeader",
    render: function() {
        var workflowCaseId = this.props.workflowCaseId;
        var wcDivId = "blwc_" + workflowCaseId;
        return (
            React.createElement("thead", null, 
                React.createElement("tr", {className: "bl_workflowCase_title_bar"}, 
                    React.createElement("th", {style: {"width": "28%"}}, 
                        React.createElement("div", {style: {"float": "left"}}, 
                            React.createElement("a", {id: "toggleWorkflowAll_" + wcDivId, href: "#", onClick: function(){toggleWorkflowAll(document.getElementById("toggleWorkflowAll_" + wcDivId)); return false;}, title: i18n('ShowHideAll')}, 
                                React.createElement("img", {src: iconPlusUrl, title: i18n('ShowHideAll'), alt: i18n('ShowHideAll'), border: "0"})
                            )
                        ), 
                        i18n("Process"), " / ", i18n("Job"), " / ", i18n("Step")
                    ), 
                     React.createElement("th", {style: {"width": "20%"}}, i18n("Agent")), 
                     React.createElement("th", {style: {"width": "20%"}}, i18n("Start"), " / ", i18n("Offset")), 
                     React.createElement("th", {style: {"width": "10%"}}, i18n("Duration")), 
                     React.createElement("th", {style: {"width": "10%"}}, i18n("Status")), 
                     React.createElement("th", {style: {"width": "12%"}}, i18n("Actions"))
                 )
             )
        );
    }
});

var BuildConfigContent = React.createClass({displayName: "BuildConfigContent",
    render: function() {
        var workflowCase = this.props.workflowCase;
        if (workflowCase.requestBuildConfigurationId) {
            var viewBuildConfigUrl = viewBuildConfigUrlId + "?workflowId=" + encodeURI(workflowCase.workflowId) + "&buildConfigurationId=" + encodeURI(workflowCase.requestBuildConfigurationId);
            return (
                React.createElement("span", null, 
                    i18n("UsingBuildConfiguration"), 
                    React.createElement("a", {href: viewBuildConfigUrl, label: workflowCase.requestBuildConfigurationName}, 
                        workflowCase.requestBuildConfigurationName
                    )
                )
            );
        }
        else {
            return (React.createElement("span", null));
        }
    }
});

var RequestContext = React.createClass({displayName: "RequestContext",
    render: function() {
        var workflowCase = this.props.workflowCase;
        if (!workflowCase.isOperation) {
            var viewRequestContextUrl = viewRequestContextUrlId + "?buildRequestId=" + encodeURI(workflowCase.requestId);
            var data = {
                "hrefUrl": viewRequestContextUrl,
                "title": i18n('ViewContext'),
                "imgSrc": iconMagnifyUrl
            };
            return (
                React.createElement(CommaSpan, {data: data})
            );
        }
        else {
            return (React.createElement("span", null));
        }
    }
});

var WorkflowConfigContent = React.createClass({displayName: "WorkflowConfigContent",
    render: function() {
        var workflowCase = this.props.workflowCase;
        if (workflowCase.canWrite) {
            var viewWorkflowUrl = viewWorkflowUrlId + "?workflowId=" + encodeURI(workflowCase.workflowId);
            var data = {
                "hrefUrl": viewWorkflowUrl,
                "title": i18n('ViewConfiguration'),
                "imgSrc": iconMagnifyUrl
            };
            return (
                React.createElement(CommaSpan, {data: data})
            );
        }
        else {
            return (React.createElement("span", null));
        }
    }
});

var PriorityContent = React.createClass({displayName: "PriorityContent",
    render: function() {
        var workflowCase = this.props.workflowCase;
        if (workflowCase.priorityHigh) {
            return (
                React.createElement("span", {className: "small-text bold"}, 
                "(", 
                    React.createElement("img", {src: iconPriorityUrl}), 
                    i18n('HighPriority'), 
                ")"
                )
            );
        }
        else {
            return (React.createElement("span", null));
        }
    }
});

renderBuildLife = function() {
    var self = this;
    jQuery.get(buildLifeRestUrl, function(result) {
        if (!result.isComplete) {
            setTimeout(function() {
                self.renderBuildLife();
            }, 5000);
        }
        React.render(React.createElement(BuildLife, {workflowCases: result.workflowCases}), document.getElementById('buildLifeContent'));
        React.render(React.createElement(BuildlifeStatus, {statuses: result.statuses}), document.getElementById('buildLifeStatus'));
        React.render(React.createElement(BuildlifeStamp, {stamps: result.stamps}), document.getElementById('buildLifeStamp'));
        React.render(React.createElement(BuildlifeLabel, {labels: result.labels}), document.getElementById('buildLifeLabel'));
        React.render(React.createElement(BuildlifeProperty, {properties: result.properties}), document.getElementById('buildLifeProperty'));
        React.render(React.createElement(BuildLifeActions, {isComplete: result.isComplete}), document.getElementById('secondaryProcessRow'));
        if (result.errors) {
            React.render(React.createElement(BuildlifeError, {errors: result.errors}), document.getElementById('buildLifeError'));
        }
    }.bind(this));
};
