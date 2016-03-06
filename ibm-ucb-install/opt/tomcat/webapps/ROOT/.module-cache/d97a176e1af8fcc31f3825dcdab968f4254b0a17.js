/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildRequestErrors = React.createClass({displayName: "BuildRequestErrors",
    render: function() {
        var errors = this.props.errors;
            if (errors.jobUrl) {
                return (
                    React.createElement("table", {className: "error-table"}, 
                        React.createElement("tr", null, 
                            React.createElement("td", null, 
                                React.createElement("div", {className: "errors"}, 
                                    React.createElement("div", {className: "errors_header"}, i18n("ErrorsWithColon")), 
                                    React.createElement(ErrorsBody, {errors: errors})
                                )
                            )
                        )
                    )
                );
            }
            else {
                return null;
            }
    }
});

var ErrorsBody = React.createClass({displayName: "ErrorsBody",
    render: function() {
        var errors = this.props.errors;
        return (
            React.createElement("div", {className: "errors_body"}, 
                React.createElement("img", {src: errorImgUrl, alt: "-"}), 
                React.createElement("b", null, React.createElement("a", {href: errors.jobUrl.replace(/\\/g,'/'), title: i18n('ViewJob')}, errors.jobName), " ", i18n("Failed")), 
                React.createElement(JobError, {logErrors: errors.logError}), 
                
                    errors.stepErrors.map(function(error) {
                        return (
                            React.createElement(OutputError, {error: error})
                        )
                    })
                
            )
        );
    }
});

var JobError = React.createClass({displayName: "JobError",
    render: function() {
        var logErrors = this.props.logErrors;
        if (logErrors) {
            return (
                React.createElement("pre", {className: "errors_output"}, logErrors)
            );
        }
        else {
            return null;
        }
    }
});

var OutputError = React.createClass({displayName: "OutputError",
    render: function() {
        var error = this.props.error;
        return (
            React.createElement("div", {className: "errors_section"}, 
                React.createElement("img", {src: errorImgUrl, alt: "-"}), 
                React.createElement("b", null, error.stepName, " ", i18n("Failed")), 
                React.createElement(OutputSection, {error: error}), 
                React.createElement(ErrorSection, {error: error})
            )
        );
    }
});

var OutputSection = React.createClass({displayName: "OutputSection",
    render: function() {
        var error = this.props.error;
        if (error.outputErrors) {
            var outputUrl = error.outputUrl.escape();
            return (
                React.createElement("div", null, 
                    React.createElement("div", {className: "errors_section"}, 
                        React.createElement("img", {src: errorImgUrl, alt: "-"}), " ", 
                            React.createElement("a", {href: "javascript:showPopup(escape(outputUrl.replace(/\\\\/g,'/')), windowWidth() - 100, windowHeight() - 100);", 
                            title: i18n('ViewCommandOutput')}, i18n("ViewOutputLog"))
                    ), 
                    React.createElement("pre", {className: "errors_output"}, error.outputErrors)
                )
            );
        }
        else {
            return null;
        }
    }
});

var ErrorSection = React.createClass({displayName: "ErrorSection",
    render: function() {
        var error = this.props.error;
        if (error.errorErrors) {
            var errorUrl = error.errorUrl.escape();
            return (
                React.createElement("div", null, 
                    React.createElement("div", {className: "errors_section"}, 
                        React.createElement("img", {src: errorImgUrl, alt: "-"}), " ", 
                        React.createElement("a", {href: "#", onClick: function(){showPopup(errorUrl, windowWidth() - 100, windowHeight() - 100); return false;}, 
                       title: i18n('ViewCommandLog')}, i18n("ViewErrorLog"))
                    ), 
                    React.createElement("pre", {className: "errors_output"}, error.errorErrors)
                )
            );
        }
        else {
            return null;
        }
    }
});
