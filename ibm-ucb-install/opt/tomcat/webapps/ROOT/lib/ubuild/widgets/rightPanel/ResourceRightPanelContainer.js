/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global define, require */
define(["dijit/_Widget",
        "dojo/_base/declare",
        "ubuild/rightPanel/RightPanelAgentsWithNoResource",
        "ubuild/rightPanel/RightPanelComponents",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/on",
        "dijit/form/Button",
        "js/webext/widgets/form/MenuButton"
        ],
        function(
            _Widget,
            declare,
            RightPanelAgent,
            RightPanelComponent,
            domClass,
            domConstruct,
            on,
            Button,
            MenuButton
        ){
    /**
     * Resource Right Panel Container
     * 
     * Widget for displaying a hovering side panel on the right side of the window with a table on the resources page.
     * 
     * Use: new ResourceRightPanelContainer(options{});
     * 
     * options: {
     *  parent: Reference to the widget (ex. ResourceTree) that is using this widget.
     *  attachPoint: The attachPoint to place the right panel.
     *  buttonAttachPoint: The attachPoint to place the show and hide buttons.
     * }
     */
    return declare('ubuild.widgets.resource.ResourceRightPanelContainer',  [_Widget], {
        
        attachPoint: null,
        buttonAttachPoint: null,
        parent: null,
        
        postCreate: function() {
            this.inherited(arguments);
            this._buildHideButton();
            this.buildPanels();
        },
        
        /**
         * Creates a menu button displaying the types of right panels to show.
         */
        _buildShowButton: function(options){
            this.showButton = new MenuButton({
                options: options,
                label: i18n("Show")
            });
            domClass.add(this.showButton.domNode, "idxButtonCompact");
            if (this.buttonAttachPoint){
                this.showButton.placeAt(this.buttonAttachPoint);
            }
            this._buildHideButton();
        },
        
        /**
         * Creates the hide button when the right panel is shown.
         */
        _buildHideButton: function(){
            var _this = this;
            if (!this.hideButton){
                this.hideButton = new Button({
                    label: i18n("Hide Panel")
                });
                domClass.add(this.hideButton.domNode, "idxButtonCompact");
            }
            else {
                if (this.buttonAttachPoint){
                    on(this.hideButton, "click", function(evt){
                        _this.current.hide(evt.shiftKey);
                    });
                    this.hideButton.placeAt(this.buttonAttachPoint);
                }
            }
        },

        /**
         * Builds the panels and options in the show button.
         */
        buildPanels: function(){
            var _this = this;
            var parent = this.parent;
            var showButtonOptions = [];
            this.panel = {};

            var panelOptions = {
                    parent: parent,
                    attachPoint: _this.parent.panelAttach,
                    onShow: function(duration){
                        domClass.remove(_this.hideButton.domNode, "hidden"); // Show "Hide Panel" button.
                    },
                    onHide: function(duration){
                        domClass.add(_this.hideButton.domNode, "hidden"); // Hide "Hide Panel" button and clear table in the right panel.
                    }
                };

            var buildPanel = function(panel, option){
                _this.panel[option] = panel;
                showButtonOptions.push({
                    label: i18n(panel.header),
                    onClick: function(evt){
                        panel.show(evt.shiftKey);
                        if (_this.current && _this.current !== panel){
                            _this.current.hide(evt.shiftKey|| 0);
                        }
                        domClass.remove(_this.hideButton.domNode, "hidden");
                        // Keep track and set the current right panel shown.
                        _this.current = panel;
                    }
                });
            };

            if ((parent.resource && !parent.resource.hasAgent) || domClass.contains(parent.domNode, "all-resources") || parent.environment){
                buildPanel(new RightPanelAgent(panelOptions), "agent");
            }
            // When viewing an environment in an applications, show components associated with the application.
            if (parent.environment && parent.environment.application){
                panelOptions.url = bootstrap.restUrl + "deploy/application/" + parent.environment.application.id + "/components";
            }
            buildPanel(new RightPanelComponent(panelOptions), "component");

            this._buildShowButton(showButtonOptions);
        }
    });
});