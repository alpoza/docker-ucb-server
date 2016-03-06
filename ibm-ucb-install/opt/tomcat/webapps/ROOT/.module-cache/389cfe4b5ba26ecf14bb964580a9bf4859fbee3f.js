/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var DependencyConfigurationTable = React.createClass({displayName: "DependencyConfigurationTable",
    render: function() {
        var dependencies = this.props.dependencies;
        var inaccessibleDependencyCount = this.props.inaccessibleDependencyCount;
        return (
            React.createElement("table", {className: "data-table"}, 
                React.createElement(DependencyConfigurationTableHeader, null), 
                React.createElement(DependencyConfigurationTableBody, {dependencies: dependencies, inaccessibleDependencyCount: inaccessibleDependencyCount})
            )
        );
    }
});

var DependencyConfigurationTableHeader = React.createClass({displayName: "DependencyConfigurationTableHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
                React.createElement("th", {className: "align-center", width: "40%"}, i18n("Name")), 
                React.createElement("th", {className: "align-center nowrap", width: "12%"}, i18n("Status")), 
                React.createElement("th", {className: "align-center nowrap", width: "16%"}, i18n("Stamp")), 
                React.createElement("th", {className: "align-center nowrap", width: "12%"}, i18n("Label")), 
                React.createElement("th", {className: "align-center nowrap", width: "20%"}, i18n("Trigger"))
          )
        );
    }
});

var DependencyConfigurationTableBody = React.createClass({displayName: "DependencyConfigurationTableBody",
    render: function() {
        var dependencies = this.props.dependencies;
        var inaccessibleDependencyCount = this.props.inaccessibleDependencyCount;
        if (dependencies.length !== 0) {
            return (
                 React.createElement("tbody", null, 
                    
                        dependencies.map(function(dependency) {
                            return (
                                React.createElement(DependencyConfigurationTableRow, {dependency: dependency})
                            )
                        }), 
                    
                    React.createElement(InaccessibleDependencyRow, {inaccessibleDependencyCount: inaccessibleDependencyCount})
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "5"}, i18n("NoDependenciesConfigured"))
                    )
                )
            );
        }
    }
});

var DependencyConfigurationTableRow = React.createClass({displayName: "DependencyConfigurationTableRow",
    render: function() {
        var dependency = this.props.dependency;
        return (
            React.createElement("tr", null, 
                React.createElement("td", {className: "align-left nowrap", height: "1", width: "20%"}, 
                    React.createElement(DependencyConfigurationNameCol, {dependency: dependency})
                ), 
                React.createElement("td", {className: "align-center"}, 
                   dependency.status, " "
                ), 
                React.createElement("td", {className: "align-center"}, 
                    React.createElement(DependencyConfigurationStampLabelCol, {values: dependency.stamps})
                ), 
                React.createElement("td", {className: "align-center"}, 
                    React.createElement(DependencyConfigurationStampLabelCol, {values: dependency.labels})
                ), 
                React.createElement("td", {className: "nowrap"}, dependency.dependencyTrigger.triggerDescription)
            )
        );
    }
});

var DependencyConfigurationNameCol = React.createClass({displayName: "DependencyConfigurationNameCol",
    render: function() {
        var dependency = this.props.dependency;
        if (dependency.isAnthillProject) {
            if (dependency.projectId && dependency.workflowId) {
                var projectDependencyUrlId = projectDependencyUrl + dependency.projectId;
                var workflowDependencyUrlId = workflowDependencyUrl + dependency.workflowId;
                return (
                React.createElement("div", null, 
                     React.createElement("a", {href: projectDependencyUrlId}, dependency.projectName), 
                     "-", 
                     React.createElement("a", {href: workflowDependencyUrlId}, dependency.buildProfileName)
                )
                );
            }
            else if (!dependency.projectId && dependency.workflowId) {
                var workflowDependencyUrlId = workflowDependencyUrl + dependency.workflowId;
                return (
                React.createElement("div", null, 
                     dependency.projectName, 
                     "-", 
                     React.createElement("a", {href: workflowDependencyUrlId}, dependency.buildProfileName)
                )
                );
            }
            else if (dependency.projectId && !dependency.workflowId) {
                var projectDependencyUrlId = projectDependencyUrl + dependency.projectId;
                return (
                React.createElement("div", null, 
                     React.createElement("a", {href: projectDependencyUrlId}, dependency.projectName), 
                     "-", 
                     dependency.buildProfileName
                )
                );
            }
            else {
                return (
                React.createElement("div", null, 
                    dependency.projectName, 
                     "-", 
                    dependency.buildProfileName
                )
                );
            }
        }
        else {
            return (
                React.createElement("div", null, "dependency.name")
            );
        }
    }
});

var DependencyConfigurationStampLabelCol = React.createClass({displayName: "DependencyConfigurationStampLabelCol",
    render: function() {
        var values = this.props.values;
        return (
            React.createElement("div", null, 
                
                    values.map(function(value, i) {
                        if (i == 0) {
                            var valueShow = "\"" + value + "\"";
                            return (
                                React.createElement("div", null, 
                                    valueShow
                                )
                            );
                        }
                        else {
                            var valueShow =  "\"" + value + "\"";
                            return (
                                React.createElement("div", null, 
                                    i18n("Or"), " ", valueShow
                                )
                            );
                        }
                    })
                 
            )
        );
    }
});

var InaccessibleDependencyRow =  React.createClass({displayName: "InaccessibleDependencyRow",
    render: function() {
        var inaccessibleDependencyCount = this.props.inaccessibleDependencyCount;
        if (inaccessibleDependencyCount <= 0) {
            return null;
        }
         else if (inaccessibleDependencyCount == 1) {
             return (
                React.createElement("tr", null, 
                    React.createElement("td", {colSpan: "5"}, 
                        i18n("SingleInaccessibleDependencyMessage", inaccessibleDependencyCount)
                    )
                )
             );
         }
        else {
            return (
               React.createElement("tr", null, 
                    React.createElement("td", {colSpan: "5"}, 
                        i18n("MultipleInaccessibleDependenciesMessage", inaccessibleDependencyCount)
                    )
                )
            );
        }
    }
});
