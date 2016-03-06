var Grid = ReactBootstrap.Grid;
var Row = ReactBootstrap.Row;
var Panel = ReactBootstrap.Panel;
var Col = ReactBootstrap.Col;

var Duration = React.createClass({displayName: "Duration",
    render: function() {
        var data = this.props.data;
        var duration = data.duration;
        var timeSinceBuild;
        if (showTimeSinceBuild) {
            timeSinceBuild = data.timeSinceBuild;
        }
        var estimatedDuration = data.estimatedDuration;

        if (estimatedDuration) {
            return (
                React.createElement("div", {className: "radiator-build-times"}, 
                    React.createElement("span", {className: "elapsed"}, duration), 
                    " ", React.createElement("span", null, estimatedDuration)
                )
            )
        }
        else {
            return (
                React.createElement("div", {className: "radiator-build-times-table radiator-build-times"}, 
                    React.createElement("div", null, 
                        React.createElement("span", {className: "radiator-build-times-cell radiator-time-since-build"}, timeSinceBuild)
                    ), 
                    React.createElement("div", null, 
                        React.createElement("span", {className: "radiator-build-times-cell radiator-build-duration"}, duration)
                    )
                )
            )
        }
    }
});

var StatusMessage = React.createClass({displayName: "StatusMessage",
    render: function() {
        var message = this.props.message;
        if (message) {
            return (
                React.createElement("div", {className: "radiator-build-body"}, 
                    React.createElement("span", null, message)
                )
            )
        }
    }
});

var Process = React.createClass({displayName: "Process",
    render: function() {
        var process = this.props.process;
        var data;
        var name = process.name;
        var panelClass = "complete";
        var progressClasses = "radiator-build-progress";
        var progress = 0;
        var latestBuild = process.latestBuild;
        if (!!latestBuild && !!latestBuild.status) {
            panelClass = latestBuild.status.toLowerCase();
        }

        if (process.currentBuilds.length > 0) {
            progressClasses += " running";
            data = process.currentBuilds[0];
            progress = data.progress;
        }
        else {
            progressClasses += " hidden";
            data = process.latestBuild;
            panelClass = data.status.toLowerCase();
            if (data.error && data.error.claimedBy) {
                panelClass += " claimed";
            }
        }

        var buildLifeId = data.buildLifeId;
        var col = 3;
        var status = data.status.toLowerCase();
        if (status == "failed") {
            col = Math.ceil(12 / failureCol);
        }
        else if (status == "complete") {
            col = Math.ceil(12 / successCol);
        }
        else if (status == "running") {
            col = Math.ceil(12 / runningCol);
        }
        else if (status == "aborted") {
            col = Math.ceil(12 / abortedCol);
        }
        else if (status == "waiting_on_agents") {
            progressClasses += " hidden";
            panelClass = "waiting-on-agents";
            col = Math.ceil(12 / runningCol);
        }

        var error;
        if (data.error) {
            error = React.createElement(Error, {error: data.error, claimedBy: data.claimedBy, processId: data.processId, name: name});
        }

        var message;
        var currStep;
        if (data.current_step_names && data.current_step_names.length > 0) {
            currStep = React.createElement(CurrentStep, {currentStep: data.current_step_names});
        }
        else {
            var jobStatus;
            if (status == "aborted") {
                jobStatus = i18n("Aborted");
            }
            else if (status == "waiting_on_agents") {
                jobStatus = i18n("Waiting on Agents");
            }

            if (jobStatus) {
                message = React.createElement(StatusMessage, {message: jobStatus})
            }
        }

        return (
            React.createElement(Col, {xs: col}, 
                React.createElement(Panel, {className: panelClass}, 
                    React.createElement("div", {style: {width: progress + '%'}, className: progressClasses}, " "), 
                    React.createElement("div", {className: "radiator-build-info"}, 
                        React.createElement("h2", {className: "radiator-build-title"}, React.createElement("a", {target: "_blank", href: processUrl + data.processId}, name)), 
                        message, 
                        error, 
                        currStep
                    ), 
                    React.createElement("div", {className: "radiator-build-id"}, React.createElement("a", {target: "_blank", href: buildLifeUrl + buildLifeId}, data.latestStamp ? data.latestStamp :
                        (buildLifeId ? ('#' + buildLifeId) : ""))), 
                    React.createElement(Duration, {data: data})
                )
            )
        )

    }
});

var ProcessList = React.createClass({displayName: "ProcessList",
    render: function() {
        var processes = [];
        var numProcesses = this.props.list.length;

        for (var i = 0; i < numProcesses; i++) {
            var process = this.props.list[i];

            var processComponent;
            if (process) {
                processComponent = React.createElement(Process, {process: process});
            }
            processes.push(processComponent);
        }

        // Setting fluid to true makes the Grid take up the full width of the screen
        return (
            React.createElement(Grid, {fluid: true}, 
                React.createElement(Row, null, processes)
            )
        )
    }
});
