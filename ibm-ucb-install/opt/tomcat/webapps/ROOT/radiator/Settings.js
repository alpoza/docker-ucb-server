var Modal = ReactBootstrap.Modal;
var Button = ReactBootstrap.Button;

var SettingModal = React.createClass({displayName: "SettingModal",
    render: function() {
        var sizeOptions = [1, 2, 3, 4, 6, 12];
        var sortOrderDefault = ["Failed", "Claimed", "Aborted", "Running", "Complete"];
        if (sortOrder) {
            var sortOrderList = sortOrder.split(",");
            for (var i = 0; i < sortOrderDefault.length; i++) {
                if (sortOrderList.indexOf(sortOrderDefault[i]) < 0) {
                    sortOrderList.push(sortOrderDefault[i]);
                }
            }
            sortOrderDefault = sortOrderList;
        }
        return (
            React.createElement(Modal, {className: "settings-modal", title: i18n('Settings'), animation: false, onRequestHide: this.done, closeButton: false}, 
                React.createElement("div", {className: "modal-body"}, 
                    React.createElement(Selector, {type: i18n('FailureSizeSelector'), defaultValue: failureCol, id: "failureCol", options: sizeOptions}), 
                    React.createElement(Selector, {type: i18n('RunningSizeSelector'), defaultValue: runningCol, id: "runningCol", options: sizeOptions}), 
                    React.createElement(Selector, {type: i18n('SuccessSizeSelector'), defaultValue: successCol, id: "successCol", options: sizeOptions}), 
                    React.createElement(Selector, {type: i18n('AbortedSizeSelector'), defaultValue: abortedCol, id: "abortedCol", options: sizeOptions}), 
                    React.createElement(Checkbox, {className: "setting-item", id: "showTimeSinceBuild", name: "showTimeSinceBuild", label: i18n('ShowTimeSinceBuild'), 
                                  checked: showTimeSinceBuild, labelBefore: true}), 
                    React.createElement(SortOrderList, {sortOrderDefault: sortOrderDefault, className: "setting-item", label: i18n('SortOrder')}), 
                    React.createElement("div", {className: "setting-item center"}, 
                        React.createElement(AddRemProcessBtn, {allProcesses: this.props.allProcesses})
                    )
                ), 
                React.createElement("div", {className: "modal-footer center"}, 
                    React.createElement(Button, {bsStyle: "primary", onClick: this.done}, i18n('Done'))
                )
            )
        );
    },
    done: function() {
        var parameters = [];
        var windowLoc = viewRadiatorUrl;
        var selectIds = ["failureCol", "runningCol", "successCol", "abortedCol", "showTimeSinceBuild"];
        for (var i = 0; i < selectIds.length; i++) {
            var id = selectIds[i];
            var value = this.getValue(id);
            if (value) {
                parameters.push(id + "=" + value);
            }
        }
        if (urlProcessList) {
            parameters.push("processList=" + urlProcessList)
        }
        var sortedIDs = jQuery( "#draggableButtons" ).sortable("toArray");
        parameters.push("sortOrder=" + sortedIDs.join(","));
        if (parameters.length) {
            var joinedParams = parameters.join("&");
            windowLoc += "?" + joinedParams;
        }
        // This may cause issues with our CSRF Filter when using IE8
        window.location = windowLoc;
    },
    getValue: function(id) {
        var value;
        var obj = document.getElementById(id);
        if (obj.type === "checkbox") {
            value = obj.checked;
        }
        else if (obj.type === "select-one") {
            var index = obj.selectedIndex;
            value = obj.options[index].value;
        }
        return value;
    }
});
