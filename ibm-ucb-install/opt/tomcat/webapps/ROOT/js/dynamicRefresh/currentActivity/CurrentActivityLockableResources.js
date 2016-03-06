/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

renderCurrentActivityLockableResource = function() {
    var self = this;
    var restUrl = currentActivityLockableResourcesRestUrl;
    jQuery.get(restUrl, function(result) {
        setTimeout(function() {
            self.renderCurrentActivityLockableResource();
        }, 5000);
        React.render(React.createElement(LockableResourcesTable, {lockableResources: result.lockableResources}),
            document.getElementById("lockableResourcesTable"));
    }.bind(this));
};


var LockableResourcesTable = React.createClass({displayName: "LockableResourcesTable",
    render: function() {
        var lockableResources = this.props.lockableResources;
        return (
            React.createElement("table", {className: "data-table"}, 
                React.createElement(LockableResourcesTableHeader, null), 
                React.createElement(LockableResourcesTableBody, {lockableResources: lockableResources})
            )
        );
    }
});

var LockableResourcesTableHeader = React.createClass({displayName: "LockableResourcesTableHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
              React.createElement("tr", null, 
                React.createElement("th", {scope: "col", align: "left", valign: "middle"}, i18n("Name")), 
                React.createElement("th", {scope: "col", align: "left"}, i18n("Description")), 
                React.createElement("th", {scope: "col", align: "left", width: "10%"}, i18n("LockableResourcesLocksUsed")), 
                React.createElement("th", {scope: "col", align: "left"}, i18n("InUseBy"))
              )
            )
        );
    }
});

var LockableResourcesTableBody = React.createClass({displayName: "LockableResourcesTableBody",
    render: function() {
        var lockableResources = this.props.lockableResources;
        if (lockableResources.length === 0) {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "4", className: "align-left"}, i18n("LockableResourcesNoResourcesActive"))
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                   
                       lockableResources.map(function(lockableResource) {
                            return (
                                React.createElement(Row, {lockableResource: lockableResource})
                            )
                        })
                    
                )
            );
        }
    }
});


var Row = React.createClass({displayName: "Row",
    render: function() {
        var lockableRes = this.props.lockableResource;
        return (
            React.createElement("tr", {className: "odd"}, 
                React.createElement("td", {className: "align-left-height"}, lockableRes.lockableResName), 
                React.createElement("td", {className: "align-left-height"}, lockableRes.lockableResDesc), 
                React.createElement("td", {className: "align-left-height"}, lockableRes.lockableResUseStatus), 
                React.createElement(RowInUsedByData, {inUsedBy: lockableRes.lockableResInUseBy})
            )
        );
    }
});



var RowInUsedByData = React.createClass({displayName: "RowInUsedByData",
    render: function() {
        var inUsedBy = this.props.inUsedBy;
        var usedByArray = [];

        for (var i=0 ; i < inUsedBy.length ; i++) {
            var item = inUsedBy[i];
            var usedBy = item.name;
            console.log("name1:"+item.name);
            console.log("canView1:"+item.canViewWorkflow);

            if (i !== 0) {
                usedByArray.push(" | ");
            }

            if (item.canViewWorkflow) {
                var workflowUrlId = baseWorkflowUrl + item.id;
                usedByArray.push(React.createElement(RowInUsedByDataContext, {workflowUrlId: workflowUrlId, usedBy: usedBy}));
             }
             else {
                 usedByArray.push(React.createElement(RowInUsedByDataContext, {usedBy: usedBy}));
             }
        }

        return (
            React.createElement("td", {className: "align-left-height"}, usedByArray)
        );
    }
});

var RowInUsedByDataContext = React.createClass({displayName: "RowInUsedByDataContext",
    render: function() {
        var workflowUrlId = this.props.workflowUrlId;
        var usedBy = this.props.usedBy;
        if (workflowUrlId) {
           return (
               React.createElement("a", {href: workflowUrlId}, usedBy)
           );
        }
        else {
            return (
                React.createElement("a", null, usedBy)
            );
        }
    }
});
