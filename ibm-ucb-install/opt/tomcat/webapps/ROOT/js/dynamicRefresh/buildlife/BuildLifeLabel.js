/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildlifeLabel = React.createClass({displayName: "BuildlifeLabel",
    render: function() {
        var labels = this.props.labels;
            return (
               React.createElement("table", {className: "data-table"}, 
                    React.createElement(LabelHeader, {labels: labels}), 
                    React.createElement(LabelBody, {labels: labels})
               )
            );
    }
});

var LabelHeader = React.createClass({displayName: "LabelHeader",
    render: function() {
        var labels = this.props.labels;

        var action;
        if (labels.canAddStamp && labels.labelsArray.length > 0) {
            action = React.createElement("th", {width: "10%"}, i18n("Action"));
        }
        return (
            React.createElement("thead", null, 
                React.createElement("tr", null, 
                    React.createElement("th", {width: "35%"}, i18n("LabelValue")), 
                    React.createElement("th", {width: "20%"}, i18n("User")), 
                    React.createElement("th", null, i18n('Date')), 
                    action
                )
            )
        );
    }
});

var LabelBody = React.createClass({displayName: "LabelBody",
    render: function() {
        var labels = this.props.labels.labelsArray;
        if (labels.length === 0) {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "3", className: "align-left"}, i18n("BuildLifeNoLabelsAssigned"))
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                   
                        labels.map(function(label) {
                            return (
                                React.createElement(LabelRow, {label: label})
                            );
                        })
                    
                )
            );
        }
    }
});

var LabelRow = React.createClass({displayName: "LabelRow",
    render: function() {
        var label = this.props.label;
        var viewLabelUrl = viewLabelUrlId + "?labelId=" + label.labelId;
        return (
            React.createElement("tr", null, 
                React.createElement("td", null, label.label), 
                React.createElement("td", null, label.user), 
                React.createElement("td", null, label.assignedDateFormat), 
                React.createElement("td", {className: "align-center"}, 
                    React.createElement("a", {href: viewLabelUrl, title: i18n('ViewAll')}, 
                        React.createElement("img", {src: iconMagnifyUrl, alt: i18n('ViewAll'), width: "16", height: "16", style: {border: 0}})
                    )
                )
            )
        );
    }
});
