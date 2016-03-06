var Modal = ReactBootstrap.Modal;
var ModalTrigger = ReactBootstrap.ModalTrigger;
var Button = ReactBootstrap.Button;

var selectedProcessList = [];
if (urlProcessList) {
    selectedProcessList = urlProcessList.split(",");
}

var AddRemProcessBtn = React.createClass({displayName: "AddRemProcessBtn",
    render: function() {
        return(
            React.createElement(ModalTrigger, {modal: React.createElement(AddRemoveProcessModal, {allProcesses: this.props.allProcesses})}, 
                React.createElement(Button, {bsStyle: "primary"}, i18n('AddRemoveProcesses'))
            )
        )
    }
});


var FilterAddRemoveProcessList = React.createClass({displayName: "FilterAddRemoveProcessList",
    getInitialState: function() {
        return {
            value: '',
            afterFilteredProcesses: this.props.allProcesses
        };
    },

    handleChange: function() {
        this.setState({
            value: this.refs.input.getValue()
        });

        var allProcesses = this.props.allProcesses;
        var filter = jQuery.trim(this.refs.input.getValue());
        if (filter && filter.normalize) {
            filter = filter.normalize("NFC");
        }

        var filteredProcesses = [];

        if (filter) {
            for (var i = 0; i < allProcesses.length; i++) {
                var name = jQuery.trim(allProcesses[i].name);
                if (name && name.normalize) {
                    name = name.normalize("NFC");
                }
                if (name.toLowerCase().indexOf(filter.toLowerCase()) !== -1) {
                    filteredProcesses.push(allProcesses[i]);
                }
            }
        }
        else {
            filteredProcesses = allProcesses;
        }

        this.setState({
            afterFilteredProcesses: filteredProcesses
        });

    },
    checkAll: function() {
        var checkboxList = document.getElementsByName("processCheckBox");
        for (var i = 0; i < checkboxList.length; i++) {
            if (!checkboxList[i].checked) {
                checkboxList[i].checked = true;
                var workflowId = checkboxList[i].id;
                selectedProcessList.push(workflowId);
            }
        }
    },
    checkNone: function() {
        var checkboxList = document.getElementsByName("processCheckBox");
        for(var i = 0; i < checkboxList.length; i++) {
            if (checkboxList[i].checked) {
                checkboxList[i].checked = false;
                var workflowId = checkboxList[i].id;
                var index = this.getIndexInArray(selectedProcessList,workflowId);
                if (index !== -1) {
                    var arrayBeforeIndex = selectedProcessList.slice(0,index);
                    var arrayAfterIndex = selectedProcessList.slice(index+1);
                    var newArray = arrayBeforeIndex.concat(arrayAfterIndex);
                    selectedProcessList = newArray;
                }
            }
        }
    },
    getIndexInArray: function(arr, obj) {
        var returnVal = -1;
        for (var i=0; i<arr.length; i++) {
            if(arr[i] == obj) {
                returnVal = i;
                break;
            }
        }
        return returnVal;
    },
    handleCheckBoxChange: function(event) {
        var workflowId = event.target.id;
        var checkedStatus = event.target.checked;
        var index = this.getIndexInArray(selectedProcessList, workflowId);
        if (checkedStatus && index === -1) {
            selectedProcessList.push(workflowId);
        }
        else if (!checkedStatus && index !== -1) {
             var arrayBeforeIndex = selectedProcessList.slice(0,index);
             var arrayAfterIndex = selectedProcessList.slice(index+1);
             var newArray = arrayBeforeIndex.concat(arrayAfterIndex);
             selectedProcessList = newArray;
        }
        this.setState({});
    },
    render: function() {
        var sortedProcessArray = this.state.afterFilteredProcesses;
        var checkboxArray = [];
        sortedProcessArray.sort(function(a, b) {
            var result = 0;
            a = a.name.toLowerCase();
            b = b.name.toLowerCase();

            if (a < b) {
                result = -1;
            }
            else if (a > b) {
                result = 1;
            }
            return result;
        });

        for (var i=0 ; i < sortedProcessArray.length ; i++) {
            var item = sortedProcessArray[i];
            var checkedOrNot = false;
            var workflowId = item.id;
            var index = -1;
            for (var j=0; j < selectedProcessList.length; j++){
                if (selectedProcessList[j] == workflowId) {
                    index = j;
                    break;
                }
            }

            if (index != -1) {
                 checkedOrNot = true;
            }
            checkboxArray.push(React.createElement(Input, {type: "checkbox", id: workflowId, name: "processCheckBox", checked: checkedOrNot, label: item.name, onChange: this.handleCheckBoxChange}));
        }
        return (
            React.createElement("div", {className: "setting-item"}, 
                React.createElement("span", null, i18n('AddRemoveProcessDesc')), 
                React.createElement("div", null, 
                    React.createElement("div", {className: "setting-item center"}, 
                        React.createElement(Button, {id: "SelectAllBtn", bsStyle: "primary", onClick: this.checkAll}, i18n('Select All')), 
                        "    ", 
                        React.createElement(Button, {id: "SelectNoneBtn", bsStyle: "primary", onClick: this.checkNone}, i18n('Select None'))
                    ), 
                    React.createElement("div", null, 
                        React.createElement("span", {className: "add-remove-header"}, i18n('ProjectNameProcessName')), 
                        React.createElement(Input, {
                            type: "text", 
                            value: this.state.value, 
                            placeholder: i18n('Enter text to filter...'), 
                            hasFeedback: true, 
                            ref: "input", 
                            groupClassName: "group-class", 
                            labelClassName: "label-class", 
                            onChange: this.handleChange}
                        )
                    ), 
                    checkboxArray
               )
            )
    );
  }
});



var AddRemoveProcessModal = React.createClass({displayName: "AddRemoveProcessModal",
    render: function() {
        return (
            React.createElement(Modal, {className: "settings-modal", title: i18n('AddRemoveProcesses'), animation: false, backdrop: false, closeButton: false}, 
                React.createElement("div", {className: "modal-body"}, 
                    React.createElement(FilterAddRemoveProcessList, {allProcesses: this.props.allProcesses})
                ), 
                React.createElement("div", {className: "modal-footer center"}, 
                    React.createElement(Button, {bsStyle: "primary", onClick: this.checkDone}, i18n('Done'))
                )
            )
        );
    },
    checkDone: function() {
        urlProcessList = selectedProcessList.join();

        this.props.onRequestHide();
    }

});

