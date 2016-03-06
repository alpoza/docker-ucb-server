var Checkbox = React.createClass({displayName: "Checkbox",
    render: function() {
        var nbsp = '\xA0';
        var beforeLabelClass = this.props.labelBefore ? "" : "display-none";
        var afterLabelClass = this.props.labelBefore ? "display-none" : "float-right";
        var checkboxClass = this.props.labelBefore ? "float-right" : "";
        return (
            React.createElement("div", null, 
                React.createElement("label", {className: this.props.className + " " + beforeLabelClass, htmlFor: this.props.id}, 
                    this.props.label + nbsp
                ), 
                React.createElement("input", {id: this.props.id, name: this.props.name, type: "checkbox", defaultChecked: this.props.checked, className: checkboxClass}), 
                React.createElement("label", {className: this.props.className + " " + afterLabelClass, htmlFor: this.props.id}, 
                    this.props.label + nbsp
                )
            )
        );
    }
});
