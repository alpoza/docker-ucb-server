/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildlifeStatus = React.createClass({displayName: "BuildlifeStatus",
    render: function() {
        var statuses = this.props.statuses;
            return (
               React.createElement("table", {className: "data-table"}, 
                    React.createElement(StatusHeader, null), 
                    React.createElement(StatusBody, {statuses: statuses})
               )
            );
    }
});

var StatusHeader = React.createClass({displayName: "StatusHeader",
    render: function() {
        var originColumnWidth = showManualStatusRemoval ? "65%" : "70%";
        var actionsColumn = showManualStatusRemoval ? React.createElement("th", {width: "5%"}) : "";
        return (
            React.createElement("thead", null, 
              React.createElement("tr", null, 
                React.createElement("th", {width: "30%"}, i18n("StatusName")), 
                React.createElement("th", {width: originColumnWidth}, i18n("Origin")), 
                actionsColumn
              )
            )
        );
    }
});

var StatusBody = React.createClass({displayName: "StatusBody",
    render: function() {
        var statuses = this.props.statuses;
        if (statuses.length === 0) {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "2", className: "align-left"}, i18n("BuildLifeNoStatusesAssigned"))
                    )
                )
            );
        }
        else {
            var i = 0;
            return (
                React.createElement("tbody", null, 
                   
                        statuses.map(function(status) {
                            return (
                                React.createElement(StatusRow, {status: status, index: i++})
                            )
                        })
                    
                )
            );
        }
    }
});

var StatusRow = React.createClass({displayName: "StatusRow",
    render: function() {
        var status = this.props.status;
        var index = this.props.index;

        var isDarkColor = isDarkColorFunc(status.statusColor);
        var textColor = "";
        if(isDarkColor) {
            textColor = "#FFFFFF";
        }

        var origin = status.origin;
        if (status.message) {
            origin = status.message;
        }

        var actionsColumn = "";
        if (showManualStatusRemoval) {
            var deleteStatusUrl = deleteManualStatusUrlId + "?status_index=" + encodeURI(index) + "&buildLifeId=" + encodeURI(buildLifeId);
            var data = {
                "hrefUrl": deleteStatusUrl,
                "confirmI18n": i18n('ManualStatusDeleteConfirm'),
                "hrefTitle": i18n('Delete'),
                "imgSrc": iconDeleteUrl
            };
            if (status.user) {
                actionsColumn = React.createElement("td", null, React.createElement(BasicConfirmLink, {data: data}));
            }
            else {
                actionsColumn = React.createElement("td", null);
            }
        }

        return (
            React.createElement("tr", null, 
                React.createElement("td", {style: {backgroundColor: status.statusColor, color: textColor}}, i18n(status.statusName)), 
                React.createElement("td", null, origin), 
                actionsColumn
            )
        );
    }
});
