var Button = ReactBootstrap.Button;
var ButtonGroup = ReactBootstrap.ButtonGroup;

var SortOrderLabel = React.createClass({displayName: "SortOrderLabel",
    render: function() {
        var nbsp = '\xA0';
        return (
            React.createElement("label", {className: this.props.className}, 
                this.props.label + nbsp
            )
        );
    }
});

var SortOrderList = React.createClass({displayName: "SortOrderList",
    componentDidMount: function () {
        jQuery(function($) {
            var panelList = $('#draggableButtons');
            panelList.sortable({
              revert: true
            }).disableSelection();
        });
    },
    render: function() {
        var sortOrderDefault = this.props.sortOrderDefault;
        return (
            React.createElement("div", null, 
                React.createElement(SortOrderLabel, {label: this.props.label, className: this.props.className}), 
                React.createElement("div", {id: "draggableButtons"}, 
                    
                        sortOrderDefault.map(function (item) {
                            var className = "sortOrderButton " + item.toLowerCase();
                            return (
                                React.createElement("div", {id: item, className: className}, 
                                    React.createElement("p", null, i18n(item))
                                )
                            );
                        })
                    
                )
            )
        );
    }
});
