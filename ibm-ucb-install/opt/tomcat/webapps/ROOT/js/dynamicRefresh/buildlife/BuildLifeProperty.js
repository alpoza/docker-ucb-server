/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */

var BuildlifeProperty = React.createClass({displayName: "BuildlifeProperty",
    render: function() {
        var properties = this.props.properties;
            return (
               React.createElement("table", {className: "data-table"}, 
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
                React.createElement("th", {width: "50%"}, i18n("PropertyName")), 
                React.createElement("th", {width: "50%"}, i18n("Value"))
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
                        React.createElement("td", {colSpan: "2", className: "align-left"}, i18n("BuildLifeNoProperties"))
                    )
                )
            );
        }
        else {
            return (
                React.createElement("tbody", null, 
                   
                        properties.map(function(property) {
                            return (
                                React.createElement(PropertyRow, {property: property})
                            )
                        })
                    
                )
            );
        }
    }
});

var PropertyRow = React.createClass({displayName: "PropertyRow",
    render: function() {
        var property = this.props.property;
        var propertyLabel = property.propertyLabel;
        if (propertyLabel) {
            propertyLabel = "(" + property.propertyLabel + ")";
        }
        return (
            React.createElement("tr", null, 
                React.createElement("td", null, 
                    property.name, 
                    React.createElement("span", {className: "small-text"}, propertyLabel)
                ), 
                React.createElement("td", null, property.value)
            )
        );
    }
});
