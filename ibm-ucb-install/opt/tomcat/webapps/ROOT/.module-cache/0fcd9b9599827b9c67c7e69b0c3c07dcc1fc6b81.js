/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildlifeError = React.createClass({displayName: "BuildlifeError",
    render: function() {
        var errors = this.props.errors;
            return (
                React.createElement("table", {className: "fixedTable"}, 
                    React.createElement("tr", null, 
                        React.createElement("td", {className: "padding0"}, 
                            React.createElement("div", {className: "errors"}, 
                                React.createElement("div", {className: "errors_header"}, i18n("ErrorsWithColon")), 
                                React.createElement(ErrorBody, {errors: errors})
                            )
                        )
                    )
                )
            );
    }
});

var ErrorBody = React.createClass({displayName: "ErrorBody",
    render: function() {
        var errors = this.props.errors;
        return (
            React.createElement("div", {className: "errors_body"}, 
                React.createElement("img", {src: iconErrorArrow, alt: "-"}), 
                React.createElement("span", {className: "bold"}, 
                    React.createElement("a", {href: errors.workflowUrl, title: i18n('ViewProcess')}, errors.workflowName), 
                    " ", i18n("Failed"), " "
                ), 
                React.createElement(LogErrors, {logErrors: errors.logErrors}), 
                
                    errors.jobTraceErrors.map(function(jobTraceError){
                        return (
                            React.createElement(JobTraceErrorRow, {jobTraceError: jobTraceError})
                        );
                    })
                
            )
        );
    }
});

var JobTraceErrorRow = React.createClass({displayName: "JobTraceErrorRow",
    render: function() {
        var jobTraceError = this.props.jobTraceError;

        return (
            React.createElement("div", {className: "errors_section"}, 
                React.createElement("img", {src: iconErrorArrow, alt: "-"}), 
                React.createElement("span", {className: "bold"}, 
                    React.createElement("a", {href: jobTraceError.jobUrl, title: i18n('ViewJob')}, jobTraceError.jobName), 
                    " ", i18n("Failed")
                ), 
                React.createElement(LogErrors, {logErrors: jobTraceError.logErrors}), 
                
                    jobTraceError.stepErrors.map(function(stepTraceError){
                        return (
                            React.createElement(StepTraceErrorRow, {stepTraceError: stepTraceError})
                        );
                    })
                
            )
        );
    }
});

var StepTraceErrorRow = React.createClass({displayName: "StepTraceErrorRow",
    render: function() {
        var stepTraceError = this.props.stepTraceError;
        return (
            React.createElement("div", {className: "errors_section"}, 
                React.createElement("img", {src: iconErrorArrow, alt: "-"}), 
                React.createElement("span", {className: "bold"}, i18n("StepFailed", stepTraceError.stepName)), 
                React.createElement(OutputErrors, {stepTraceError: stepTraceError}), 
                React.createElement(ErrorErrors, {stepTraceError: stepTraceError})
            )
        );
    }
});

var LogErrors = React.createClass({displayName: "LogErrors",
    render: function() {
        var logErrors = this.props.logErrors;
        if (logErrors) {
            return (
                React.createElement("div", {className: "errors_output"}, logErrors)
            );
        }
        else {
            return (React.createElement("div", null));
        }
    }
});

var OutputErrors = React.createClass({displayName: "OutputErrors",
    render: function() {
        var stepTraceError = this.props.stepTraceError;
        if (stepTraceError.outputErrors) {
            var stepTraceOutputUrl = stepTraceError.outputUrl.escape();
            return (
                React.createElement("div", null, 
                    React.createElement("div", {className: "errors_section"}, 
                        React.createElement("img", {src: iconErrorArrow, alt: "-"}), 
                        React.createElement("a", {href: "#", onClick: function(){showPopup(stepTraceOutputUrl, windowWidth() - 100, windowHeight() - 100); return false;}, title: i18n('ViewCommandOutput')}, 
                            i18n("ViewOutputLog")
                        )
                    ), 
                    React.createElement("pre", {className: "errors_output"}, stepTraceError.outputErrors)
                )
            );
        }
        else {
            return (React.createElement("div", null));
        }
    }
});

var ErrorErrors = React.createClass({displayName: "ErrorErrors",
    render: function() {
        var stepTraceError = this.props.stepTraceError;
        if (stepTraceError.errorErrors) {
            var stepTraceErrorUrl = stepTraceError.errorUrl.escape();
            return (
                React.createElement("div", null, 
                    React.createElement("div", {className: "errors_section"}, 
                        React.createElement("img", {src: iconErrorArrow, alt: "-"}), 
                        React.createElement("a", {href: "#", onClick: function(){showPopup(stepTraceErrorUrl, windowWidth() - 100, windowHeight() - 100); return false;}, title: i18n('ViewCommandLog')}, 
                            i18n("ViewErrorLog")
                        )
                    ), 
                    React.createElement("pre", {className: "errors_output"}, stepTraceError.errorErrors)
                )
            );
        }
        else {
            return (React.createElement("div", null));
        }
    }
});
