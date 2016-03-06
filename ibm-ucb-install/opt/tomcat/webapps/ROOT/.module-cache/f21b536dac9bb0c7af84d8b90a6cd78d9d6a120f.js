var Selector = React.createClass({displayName: "Selector",
    render: function() {
        return (
            React.createElement("div", {className: "setting-item"}, 
                React.createElement("span", null, this.props.type), 
                React.createElement("span", {className: "float-right"}, 
                    React.createElement("select", {id: this.props.id, className: "selector", defaultValue: this.props.defaultValue}, 
                        
                            this.props.options.map(function(option) {
                                return React.createElement("option", {value: option}, option);
                            })
                        
                    ), 
                    React.createElement("span", null, i18n('RadiatorSettingCol'))
                )
            )
        );
    }
});
