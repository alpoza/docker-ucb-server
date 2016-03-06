/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var StepTrace = React.createClass({displayName: "StepTrace",
    render: function() {
        var step = this.props.step;
        var jtDivId = this.props.jtDivId;
        var stDivId = jtDivId + "_step_" + step.stepLoopIndex;
        var stClientSessionKey = clientSessionKeyPrefix + stDivId;
        var isStepDone = (step.endDate != '');
        var isStepExpanded = (!isStepDone || !step.statusSuccess || clientSession[stClientSessionKey]);
        var rowClass = "step-hidden";
        if (isStepExpanded) {
            rowClass = "step-visible";
        }
        var rowStyle = {"display": "none"};
        var isExpanded = this.props.isExpanded;
        var isJobExpanded = this.props.isJobExpanded;
        if (isExpanded && isJobExpanded) {
            rowStyle = {};
        }
        var stepHeader = (step.stepLoopIndex + 1 ) + "." + step.name;
        return (
            React.createElement("tbody", {id: stDivId, className: rowClass, style: rowStyle}, 
                React.createElement("tr", {className: "sub_row_" + step.stepEoNext}, 
                    React.createElement("td", {className: "align-left nowrap"}, 
                        React.createElement("span", {className: "paddingLeft30"}, 
                            React.createElement("img", {src: spacerImage, height: "1", width: "12"}), 
                            stepHeader, 
                            React.createElement("td", {className: "align-left"}, " "), 
                            React.createElement("td", {className: "align-center nowrap"}, step.offset), 
                            React.createElement("td", {className: "align-center nowrap"}, step.duration), 
                            React.createElement("td", {className: "align-center nowrap", style: {backgroundColor: step.statusColor,color: step.statusSecondaryColor}}, i18n(step.statusName)), 
                            React.createElement("td", {className: "align-left"}, 
                                
                                    step.stepLogFileInfoList.map(function(logFileInfo){
                                        var logName = logFileInfo.logName;
                                        var logPath = logFileInfo.logPath;
                                        var index = logFileInfo.index;
                                        var pathSeparator = logFileInfo.pathSeparator;
                                        var viewLogUrl = viewLogUrlId + "?log_name=" + encodeURI(logPath) + "&pathSeparator=" + encodeURI(pathSeparator);
                                        var label = i18n('View') + " " + logName;
                                        return (
                                            React.createElement("span", null, 
                                                (index > 0) ? "  " : "", 
                                                React.createElement("a", {href: "#", onClick: function(){showLogViewer(viewLogUrl); return false;}, title: label}, 
                                                    React.createElement("img", {src: logName == 'output' ? outputImage : logImage, title: label, alt: label, border: "0"})
                                                )
                                            )
                                            );
                                    })
                                
                            )
                        )
                    )
                )
            )
        );
    }
});
