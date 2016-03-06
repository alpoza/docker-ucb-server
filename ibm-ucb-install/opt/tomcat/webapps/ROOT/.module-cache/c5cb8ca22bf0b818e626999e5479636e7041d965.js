/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildlifeStamp = React.createClass({displayName: "BuildlifeStamp",
    render: function() {
        var stamps = this.props.stamps;
            return (
               React.createElement("table", {className: "data-table"}, 
                    React.createElement(StampHeader, null), 
                    React.createElement(StampBody, {stamps: stamps})
               )
            );
    }
});

var StampHeader = React.createClass({displayName: "StampHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
              React.createElement("tr", null, 
                React.createElement("th", {width: "35%"}, i18n("StampValue")), 
                React.createElement("th", {width: "65%"}, i18n("Origin"))
              )
            )
        );
    }
});

var StampBody = React.createClass({displayName: "StampBody",
    render: function() {
        var stamps = this.props.stamps;
        if (stamps.length === 0) {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "2", className: "align-left"}, i18n("BuildLifeNoStampsAssigned"))
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                   
                        stamps.map(function(stamp) {
                            return (
                                React.createElement(StampRow, {stamp: stamp})
                            )
                        })
                    
                )
            );
        }
    }
});

var StampRow = React.createClass({displayName: "StampRow",
    render: function() {
        var stamp = this.props.stamp;
        if (stamp.originClass === 'BuildLifeStampOriginJobTrace') {
        var detailsUrl = detailsUrlId + "?job_trace_id=" + stamp.jobTraceId;
            return (
                React.createElement("tr", {className: "odd"}, 
                    React.createElement("td", null, stamp.stampValue), 
                    React.createElement("td", null, 
                        stamp.workflowName, " - ", stamp.jobTraceName, 
                        "(", React.createElement("a", {href: detailsUrl}, stamp.jobTraceId), ")"
                    )
                )
            );
        }
        else if (stamp.originClass === 'BuildLifeStampOriginUser') {
            return (
                React.createElement("tr", {className: "odd"}, 
                    React.createElement("td", null, stamp.stampValue), 
                    React.createElement("td", null, 
                        i18n("StatusOrigin", stamp.userName, stamp.stampDate)
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tr", {className: "odd"}, 
                    React.createElement("td", null, stamp.stampValue), 
                    React.createElement("td", null)
                )
            );
        }
    }
});
