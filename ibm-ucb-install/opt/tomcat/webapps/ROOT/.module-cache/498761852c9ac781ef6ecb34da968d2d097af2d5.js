var BasicConfirmSpan = React.createClass({displayName: "BasicConfirmSpan",
    render: function() {
        var data = this.props.data;
        return (
            React.createElement("span", null, 
                React.createElement(BasicConfirmLink, {data: data})
            )
        );
    }
});

var BasicConfirmLink = React.createClass({displayName: "BasicConfirmLink",
    render: function() {
        var hrefUrl = this.props.data.hrefUrl;
        var confirmI18n = this.props.data.confirmI18n;
        var hrefTitle = this.props.data.hrefTitle;
        var imgSrc = this.props.data.imgSrc;
        var img = hrefTitle;
        if (imgSrc) {
            img = React.createElement("img", {src: imgSrc, title: hrefTitle, alt: hrefTitle, border: "0"});
        }
        return (
            React.createElement("a", {href: hrefUrl, onClick: function(){return basicConfirm(confirmI18n);}, title: hrefTitle}, 
                img
            )
        );
    }
});

var ShowPopupSpan = React.createClass({displayName: "ShowPopupSpan",
    render: function() {
        var data = this.props.data;
        return (
            React.createElement("span", null, 
                React.createElement(ShowPopupLink, {data: data})
            )
        );
    }
});

var ShowPopupLink = React.createClass({displayName: "ShowPopupLink",
    render: function() {
        var showPopUpUrl = this.props.data.showPopUpUrl;
        var dialogWidth = this.props.data.dialogWidth;
        var dialogHeight = this.props.data.dialogHeight;
        var title = this.props.data.title;
        var imgSrc = this.props.data.imgSrc;
        return (
            React.createElement("a", {href: "#", onClick: function(){showPopup(showPopUpUrl, dialogWidth, dialogHeight); return false;}, title: title}, 
                React.createElement("img", {src: imgSrc, title: title, alt: title, border: "0"})
            )
        );
    }
});

var ShowPopupLinkNoImg = React.createClass({displayName: "ShowPopupLinkNoImg",
    render: function() {
        var showPopUpUrl = this.props.data.showPopUpUrl;
        var dialogWidth = this.props.data.dialogWidth;
        var dialogHeight = this.props.data.dialogHeight;
        var title = this.props.data.title;
        var text = this.props.data.text;
        return (
            React.createElement("a", {href: showPopUpUrl, onClick: function(){showPopup(showPopUpUrl, dialogWidth, dialogHeight); return false;}, title: title}, 
                text
            )
        );
    }
});

var SpacerImg = React.createClass({displayName: "SpacerImg",
    render: function() {
        return (
            React.createElement("span", null, 
                React.createElement("img", {alt: "", src: spacerImage, width: "16", height: "16", style: {"border": 0}})
            )
        );
    }
});

var CommaSpan = React.createClass({displayName: "CommaSpan",
    render: function() {
        var data = this.props.data;
        var hrefUrl = data.hrefUrl;
        var title = data.title;
        var imgSrc = data.imgSrc;
        return (
            React.createElement("span", null, 
                ",", 
                React.createElement("a", {href: hrefUrl, title: title}, 
                    React.createElement("img", {src: imgSrc, title: title, alt: title, border: "0"}), 
                    title
                )
            )
        );
    }
});

var isDarkColorFunc = function(color) {
    var rgbColor = new dojo.Color(color).toRgb();
    var colorWeight = 1 - (0.25 * rgbColor[0] + 0.6 * rgbColor[1] + 0.1 * rgbColor[2]) / 255;
    return colorWeight > 0.25;
};
