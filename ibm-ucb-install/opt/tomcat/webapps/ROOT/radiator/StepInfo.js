var Input = ReactBootstrap.Input;
var Modal = ReactBootstrap.Modal;
var ModalTrigger = ReactBootstrap.ModalTrigger;

var Error = React.createClass({displayName: "Error",
    render: function() {
        var error = this.props.error;
        var users = error.users;
        var claimedBy = error.claimedBy;

        var claim;
        if (!claimedBy) {
            claim = React.createElement(Claim, {processId: this.props.processId, name: this.props.name})
        }
        else {
            claim = React.createElement(Unclaim, {processId: this.props.processId})
        }

        var usersMessage;
        if (claimedBy) {
            usersMessage = React.createElement(ClaimedFailure, {claimedBy: claimedBy})
        }
        else if (users && users.length > 0) {
            usersMessage = React.createElement(PossibleCulprits, {users: users, processId: this.props.processId})
        }

        return (
            React.createElement("div", {className: "radiator-build-body"}, 
                React.createElement("div", null, 
                    error.message, 
                    claim
                ), 
                usersMessage
            )
        );
    }
});

var CurrentStep = React.createClass({displayName: "CurrentStep",
    render: function() {
        var currentStep = this.props.currentStep;
        return (
            React.createElement("div", {className: "radiator-build-body"}, 
                React.createElement("span", null, i18n('CurrentlyRunningSteps', currentStep.join(", ")))
            )
        );
    }
});

var PossibleCulprits = React.createClass({displayName: "PossibleCulprits",
    render: function() {
        var users = this.props.users;
        return (
            React.createElement("div", null, 
                React.createElement("span", null, i18n('PossibleCulprits', users.join(", ")))
            )
        )
    }
});

var Claim = React.createClass({displayName: "Claim",
    render: function() {
        return (
            React.createElement(ModalTrigger, {modal: React.createElement(ClaimModal, {processId: this.props.processId, name: this.props.name})}, 
                React.createElement("a", {className: "claim"}, i18n('RadiatorClaim'))
            )
        )
    }
});

var Unclaim = React.createClass({displayName: "Unclaim",
    render: function() {
        return React.createElement("a", {className: "claim", onClick: this.unclaim}, i18n('RadiatorUnclaim'))
    },
    unclaim: function() {
        sendRequest(false, this.props.processId, currentUser, null);
    }
});

var ClaimedFailure = React.createClass({displayName: "ClaimedFailure",
    render: function() {
        var claimedBy = this.props.claimedBy;

        var reason = claimedBy.reason;

        var message;
        if (reason) {
            message = ": " + reason;
        }
        return (
            React.createElement("div", null, 
                React.createElement("span", {dangerouslySetInnerHTML: this.generateHtml()}), 
                message
            )
        )
    },
    generateHtml: function() {
        var claimedBy = this.props.claimedBy;
        var user = claimedBy.user;
        return {
            __html: i18n('ClaimedByUser', user)
        }
    }
});

var ClaimModal = React.createClass({displayName: "ClaimModal",
    render: function() {
        return (
            React.createElement(Modal, {title: i18n('ClaimProcess', this.props.name), animation: false, onRequestHide: this.props.onRequestHide}, 
                React.createElement("div", {className: "modal-body"}, 
                    React.createElement(Input, {type: "text", ref: "user", label: i18n('User'), defaultValue: currentUser}), 
                    React.createElement(Input, {type: "textarea", ref: "reason", label: i18n('Reason')})
                ), 
                React.createElement("div", {className: "modal-footer center"}, 
                    React.createElement(Button, {bsStyle: "primary", onClick: this.done}, i18n('Done'))
                )
            )
        );
    },
    done: function() {
        sendRequest(true, this.props.processId, this.refs.user.getValue(), this.refs.reason.getValue());
        this.props.onRequestHide();
    }
});

var sendRequest = function(claiming, processId, user, reason) {
    var claim = {
        "user": user,
        "reason": reason
    };
    var xhrArgs = {
        url: radiatorRestUrl + "/" + processId,
        postData: dojo.toJson(claim),
        handleAs: "text",
        headers: {
            "Content-Type": "application/json"
        }
    };

    if (claiming) {
        dojo.xhrPost(xhrArgs);
    }
    else {
        dojo.xhrDelete(xhrArgs);
    }
};
