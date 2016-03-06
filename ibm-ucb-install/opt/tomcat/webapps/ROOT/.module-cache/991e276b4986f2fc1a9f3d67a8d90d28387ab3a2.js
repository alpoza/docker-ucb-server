/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildRequestProperty = React.createClass({displayName: "BuildRequestProperty",
    render: function() {
        var properties = this.props.properties;
            return (
               React.createElement("table", {className: "data-table"}, 
                    React.createElement("caption", null, i18n("Properties")), 
                    React.createElement(PropertyHeader, null), 
                    React.createElement(PropertyBody, {properties: properties})
               )
            );
    }
});

var PropertyHeader = React.createClass({displayName: "PropertyHeader",
    render: function() {
        return (
            React.createElement("thead", null, 
              React.createElement("tr", null, 
                React.createElement("th", {width: "33%"}, i18n("Label")), 
                React.createElement("th", {width: "33%"}, i18n("PropertyName")), 
                React.createElement("th", {width: "34%"}, i18n("Value"))
              )
            )
        );
    }
});

var PropertyBody = React.createClass({displayName: "PropertyBody",
    render: function() {
        var properties = this.props.properties;
        if (properties.length === 0) {
            return (
                React.createElement("tbody", null, 
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "3", className: "align-left"}, i18n("NoRequestProperties"))
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                   
                        properties.map(function(property) {
                            return (
                                React.createElement(Row, {property: property})
                            )
                        })
                    
                )
            );
        }
    }
});

var Row = React.createClass({displayName: "Row",
    render: function() {
        var property = this.props.property;
        return (
            React.createElement("tr", {className: "odd"}, 
                React.createElement("td", null, property.label), 
                React.createElement("td", {className: "nowrap"}, property.name), 
                React.createElement("td", null, property.value)
            )
        );
    }
});
