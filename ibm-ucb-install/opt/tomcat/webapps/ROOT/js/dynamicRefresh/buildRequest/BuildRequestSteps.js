/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildRequestSteps = React.createClass({displayName: "BuildRequestSteps",
    render: function() {
            var steps = this.props.steps;
            return (
                React.createElement("div", {className: "table_wrapper"}, 
                    React.createElement("table", {className: "data-table"}, 
                        React.createElement(StepHeader, null), 
                        
                        steps.map(function(step, i) {
                           return React.createElement(StepRow, {step: step, stepIndex: i})
                        })
                        
                    )
                )
            );
    }
});

var StepHeader = React.createClass({displayName: "StepHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
                React.createElement("tr", null, 
                    React.createElement("th", {className: "align-left"}, i18n("Step")), 
                    React.createElement("th", {className: "align-center", width: "15%"}, i18n("Agent")), 
                    React.createElement("th", {className: "align-center", width: "15%"}, i18n("Status")), 
                    React.createElement("th", {className: "align-center", width: "15%"}, i18n("StartOffset")), 
                    React.createElement("th", {className: "align-center", width: "15%"}, i18n("Duration")), 
                    React.createElement("th", {className: "align-center", width: "8%"}, i18n("Actions"))
                )
            )
        );
    }
});

var StepRow = React.createClass({displayName: "StepRow",
    render: function() {
        var step = this.props.step;
        var i = this.props.stepIndex;
        var rowId = 'step:' + i;
        var stepName = (i + 1) + ". " + step.name;
        return (
            React.createElement("tbody", null, 
                React.createElement("tr", {backgroundColor: "#ffffff", id: rowId}, 
                    React.createElement("td", {className: "align-left nowrap"}, 
                        React.createElement("img", {src: spacerImage, height: "1", width: "16"}), " ", stepName
                    ), 
                    React.createElement("td", {className: "align-left nowrap"}, step.agent), 
                    React.createElement("td", {className: "align-left nowrap", style: {backgroundColor:step.statusColor, color:step.statusSecondaryColor}}, 
                        step.statusName
                    ), 
                    React.createElement("td", {className: "align-left nowrap"}, step.offset), 
                    React.createElement("td", {className: "align-left nowrap"}, step.duration), 
                    React.createElement("td", {className: "align-left nowrap"}, 
                        
                            step.stepLogFileInfoList.map(function(stepLog, i){
                                return React.createElement(StepLog, {stepLog: stepLog, logIndex: i})
                            })
                        
                    )
               )
           )
       );
    }
});

var StepLog = React.createClass({displayName: "StepLog",
    render: function() {
        var stepLog = this.props.stepLog;
        var i = this.props.logIndex;
        var url = viewLogUrl + "?log_name=" + escape(stepLog.logPath) + "&pathSeparator=" + escape(stepLog.pathSeparator);
        var alt, imgSrc;
        var spaceWidth = 0;
        if (i > 0) {
            spaceWidth = 8;
        }
        if (stepLog.logName == 'output') {
            alt = i18n('Output');
            imgSrc = outputImage;
        }
        else {
            alt = i18n('Log');
            imgSrc = logImage;
        }
        return (
            React.createElement("a", {href: "#", title: i18n('ViewWithParam', stepLog.logName), onClick: function(){showPopup(url, windowWidth() - 100, windowHeight() - 100); return false;}}, 
                React.createElement("img", {src: spacerImage, height: "1", width: spaceWidth}), 
                React.createElement("img", {alt: alt, src: imgSrc, border: "0"})
            )
        );
    }
});
