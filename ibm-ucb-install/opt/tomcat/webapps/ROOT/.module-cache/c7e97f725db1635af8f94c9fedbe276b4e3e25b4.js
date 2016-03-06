/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */
/*
 * This class expects the following variables to be defined:
 * processUrl - The base URL of the build process that the build process id can be appended to.
 * buildLifeUrl - The base URL of the build life that the build life id can be appended to.
 * showTimeSinceBuild - An option that specifies if the panels should show the time since the last
 *                      build or the duration of the last build
 */

var ModalTrigger = ReactBootstrap.ModalTrigger;
var Button = ReactBootstrap.Button;

var Radiator = React.createClass({displayName: "Radiator",
    getInitialState: function() {
        return {
            visibleProcesses: [],
            allProcesses: []
        };
    },
    tick: function() {
        var self = this;
        $.get(this.props.url, function(result) {
            if (this.isMounted()) {
                // Make a new request 5 seconds after receiving the response
                setTimeout(function() {
                    self.tick();
                }, 5000);

                var prunedProcesses = this.pruneProcesses(result);
                this.setState({
                    visibleProcesses: prunedProcesses,
                    allProcesses: result
                });
            }
        }.bind(this));
    },
    pruneProcesses: function(processList) {
        var prunedProcesses = [];
        processList.forEach(function(process) {
            if (process.latestBuild.status || (process.currentBuilds.length && process.currentBuilds[0].status)) {
                prunedProcesses.push(process);
            }
        });
        return prunedProcesses;
    },
    componentDidMount: function() {
        this.tick();
    },
    render: function() {
        return (
            React.createElement("div", null, 
                React.createElement(ProcessList, {list: this.state.visibleProcesses}), 
                React.createElement(ModalTrigger, {modal: React.createElement(SettingModal, {allProcesses: this.state.allProcesses})}, 
                    React.createElement(Button, {className: "settingBtn"})
                )
            )
        );
    }
});

renderRadiator = function() {
    var urlFilter = radiatorRestUrl + "?processList=" + urlProcessList + "&sortOrder=" + sortOrder;
    React.render(React.createElement(Radiator, {url: urlFilter}), document.getElementById('radiator'));
};
