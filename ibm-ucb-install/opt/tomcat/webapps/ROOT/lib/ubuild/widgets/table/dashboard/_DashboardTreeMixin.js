/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2016. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */
/*global define */
define([
        "dojo/_base/array",
        "dojo/_base/declare",
        "dojo/_base/lang",
        "dojo/dom-class",
        "dijit/_TemplatedMixin",
        "dijit/_WidgetBase",
        "js/webext/widgets/Link",
        "dojo/text!ubuild/table/dashboard/DashboardTree.html"
        ],
function(
    array,
    declare,
    lang,
    domClass,
    _TemplatedMixin,
    _WidgetBase,
    Link,
    template
) {

    /**
     * A tree table widget used for the main dashboard pages
     */
    return declare("lib/ubuild/widgets/table/dashboard/_DashboardTreeMixin",
        [_WidgetBase, _TemplatedMixin],
        {
            "templateString":           template,

            "dashboardTreeDiv":         null,

            "notificationDiv":          null,

            "toggleInactiveDiv":        null,

            "dashboardTree":            null,

            "toggleInactiveLink":       null,

            "createProjectLink":        null,

            "importLink":               null,

            "showInactive":             null,

            "treeRestUrl":              bootstrap.restUrl + "/dashboard/activity",

            "setShowInactive": function(showInactive) {
                var t = this;
                t.showInactive = showInactive;
                t.toggleInactiveLink.set("labelText", t.showInactive ? i18n('ViewActive') : i18n('ViewInactive'));
                t.dashboardTree.queryData.showInactive = t.showInactive;
                t.dashboardTree.refresh();
            },

            "toggleShowInactive": function() {
                var t = this;
                t.setShowInactive(!t.showInactive);
            },

            "hasChildren": function(item) {
                return item.type === "project";
            },

            "showPopup": function(url, width, height) {
                showPopup(url, width, height);
                return false;
            },

            "postCreate": function() {
                var t = this;
                t.inherited(arguments);

                var showInactiveText = i18n('ViewInactive');
                if (t.showInactive) {
                    showInactiveText = i18n('ViewActive');
                }
                t.toggleInactiveLink = new Link({
                    "labelText":    showInactiveText,
                    "onClick":      lang.hitch(t, t.toggleShowInactive),
                    "class":        "clickable"
                });
                t.own(t.toggleInactiveLink);
                t.toggleInactiveLink.placeAt(t.toggleInactiveDiv);

                t.importLink = new Link({
                    "labelText":    i18n('Import'),
                    "onClick":      lang.hitch(t, t.showPopup, t.importUrl, 800, 400),
                    "class":        "clickable"
                });
                t.own(t.importLink);
                t.importLink.placeAt(t.importDiv);

                t.createProjectLink = new Link({
                    "labelText":    i18n("Create"),
                    "onClick":      lang.hitch(t, t.showPopup, t.createNewProjectUrl, 800, 400),
                    "class":        "clickable"
                });
                t.own(t.createProjectLink);
                t.createProjectLink.placeAt(t.createDiv);
            },

            "startup": function() {
                var t = this;

                domClass.add(t.dashboardTree.aboveTreeOptions, "aboveTreeOptions");
                if (t.hideExpandCollapse) {
                    domClass.add(t.toggleInactiveDiv, "bottomLink");
                    domClass.add(t.importLink, "bottomLink");
                    domClass.add(t.createProjectLink, "bottomLink");
                }
                else {
                    domClass.add(t.dashboardTree.expandCollapseAttach, "bottomLink");
                    domClass.add(t.toggleInactiveDiv, "topLink");
                    domClass.add(t.importLink, "topLink");
                    domClass.add(t.createProjectLink, "topLink");
                }
            }
        });
});
