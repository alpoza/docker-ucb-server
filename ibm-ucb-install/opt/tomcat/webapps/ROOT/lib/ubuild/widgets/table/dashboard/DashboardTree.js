/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global define, require */

define([
        "dojo/_base/declare",
        "dojo/_base/lang",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/dom-style",
        "dijit/_WidgetBase",
        "ubuild/table/dashboard/_DashboardTreeMixin",
        "js/webext/widgets/table/TreeTable",
        "js/webext/widgets/Link"
        ],
function(
        declare,
        lang,
        domClass,
        domConstruct,
        domStyle,
        _WidgetBase,
        _DashboardTreeMixin,
        TreeTable,
        Link
) {
    /**
     * A projects table widget with pagination, sorting, and custom formatting. Uses an actual
     * HTML table for display.
     *
     * Pagination, sorting, and filtering are supported by REST services. REST
     * services built to perform these operations must return an object of the format (the totalRecords value is optional):
     *  {
     *      totalRecords: ##,
     *      records: [
     *          {record}, ...
     *      ]
     *  }
     */

    return declare('js.ubuild.widgets.table.DashboardTree', [_WidgetBase, _DashboardTreeMixin], {
        "createNewProjectUrl": bootstrap.baseUrl + "tasks/admin/project/ProjectTasks/newProject",
        "viewProjectUrl": bootstrap.baseUrl + "tasks/project/ProjectTasks/viewDashboard?projectId=",
        "viewProcessUrl": bootstrap.baseUrl + "tasks/project/WorkflowTasks/viewDashboard?workflowId=",
        "viewBuildLifeUrl": bootstrap.baseUrl + "tasks/project/BuildLifeTasks/viewBuildLife?buildLifeId=",
        "viewBuildLifeErrorsUrl": bootstrap.baseUrl + "tasks/project/BuildLifeTasks/viewErrors?buildLifeId=",
        "importUrl": bootstrap.baseUrl + "tasks/admin/project/ImportExportTasks/viewImportForm",

        /**
         *
         */
        "postCreate": function() {
            this.inherited(arguments);
            var self = this;

            var columns = [{
                    "name": i18n("Name"),
                    "field": "name",
                    "orderField": "name",
                    "filterField": "name",
                    "filterType": "text",
                    "formatter": lang.hitch(self, self.nameFormatter),
                    "style": { width: "45%" },
                    "class": "center"
                },{
                    "name": i18n("Status"),
                    "formatter": lang.hitch(self, self.statusFormatter),
                    "style": { width: "7%"},
                    "class": "center"
                },{
                    "name": i18n("Stamp"),
                    "formatter": lang.hitch(self, self.stampFormatter),
                    "class": "center"
                },{
                    "name": i18n("When"),
                    "formatter": lang.hitch(self, self.whenFormatter),
                    "class": "center"
                },{
                    "name": i18n("Duration"),
                    "formatter": lang.hitch(self, self.durationFormatter),
                    "class": "center"
                },{
                    "name": i18n("Why"),
                    "formatter": lang.hitch(self, self.whyFormatter),
                    "class": "center"
                },{
                    "name": i18n("Tests"),
                    "formatter": lang.hitch(self, self.testsFormatter),
                    "class": "center"
                },{
                    "name": i18n("Issues"),
                    "formatter": lang.hitch(self, self.issuesFormatter),
                    "class": "center"
                },{
                    "name": i18n("Changes"),
                    "formatter": lang.hitch(self, self.changesFormatter),
                    "class": "center"
                }];

            self.dashboardTree = new TreeTable({
                "url": self.treeRestUrl,
                "getChildUrl": lang.hitch(self, self.getChildUrl),
                "hasChildren": lang.hitch(self, self.hasChildren),
                "columns": columns,
                "orderField": "name",
                "queryData": {
                    "showInactive": self.showInactive
                },

                "class": "dashboard-tree-table",
                "expandImageClass": "expandImage",
                "collapseImageClass": "collapseImage",
                "expandCollapseAllLinkClass": "clickable",

                "hidePrintLink": true,
                "hideExpandCollapse": true,
                "hidePagination": false,
                "noDataMessage": i18n("No records found."),
                "pageOptions": [25, 50, 100, 250],
                "rowsPerPage": 50
            });
            self.own(self.dashboardTree);
            self.dashboardTree.placeAt(self.dashboardTreeDiv);
        },

        "nameFormatter": function(item, value, cellDom) {
            var self = this;
            var result;
            var taskUrl;
            var iconClass;
            switch (item.type) {
                case "project":
                    taskUrl = self.viewProjectUrl;
                    iconClass = "projectIcon";
                    break;
                case "process":
                    taskUrl = self.viewProcessUrl;
                    iconClass = "workflowIcon";
                    break;
            }

            var name = item.name;
            var title = item.description ? (name + ' - ' + item.description) : name;
            result = domConstruct.create("div");
            var nameLink = new Link({
                "labelText": name,
                "href": taskUrl + item.id,
                "class": "clickable",
                "iconClass": iconClass,
                "title": title
            });
            nameLink.placeAt(result);

            if (item.tags) {
                dojo.forEach(item.tags, function(tag) {
                    var tagDiv = self.createTag(tag);
                    result.appendChild(tagDiv);
                });
            }

            domClass.remove(cellDom, "center");

            return result;
        },

        "statusFormatter": function(item, value, cellDom) {
            var t = this;
            var result = "";
            if (item.latest && item.latest.status) {
                if (item.latest.statusColor) {
                    domStyle.set(cellDom, "background-color", item.latest.statusColor);
                }

                var status = i18n(item.latest.status);
                if (item.latest.status === "Failed") {
                    result = new Link({
                        "labelText": status,
                        "class": "clickable",
                        "title": i18n('ClickToViewErrors'),
                        "onClick": lang.hitch(t, t.showPopup, t.viewBuildLifeErrorsUrl + item.latest.id, 800, 600)
                    });
                    t.own(result);
                }
                else {
                    result = status;
                }
            }
            else if (item.type === "process") {
                result = i18n('NoActivity');
            }
            return result;
        },

        "stampFormatter": function(item, value, cellDom) {
            var t = this;
            var result = "";
            if (item && item.latest) {
                var params = {
                    "title": i18n('ViewBuildLife'),
                    "class": "clickable"
                };
                if (!!item.latest.stamp) {
                    params.labelText = item.latest.stamp;
                }
                else {
                    params.iconClass = "magnifyingGlassIcon";
                }
                params.href = t.viewBuildLifeUrl + item.latest.id;
                params.title = params.labelText || item.name;

                result = new Link(params);
                t.own(result);
            }
            return result;
        },

        "whenFormatter": function(item, value, cellDom) {
            var result = "";
            if (item && item.latest && item.latest.date) {
                result = item.latest.date;
            }
            return result;
        },

        "durationFormatter": function(item, value, cellDom) {
            var result = "";
            if (item && item.latest && item.latest.duration) {
                result = item.latest.duration;
                domClass.add(cellDom, "right");
            }
            return result;
        },

        "whyFormatter": function(item, value, cellDom) {
            var result;
            if (item && item.latest && item.latest.request) {
                result = domConstruct.create("div");
                result.innerHTML = i18n(item.latest.request.type);
                if (item.latest.request.requester) {
                    result.title = i18n('RequestedByUser', item.latest.request.requester);
                }
            }
            return result;
        },

        "testsFormatter": function(item, value, cellDom) {
            var result = "";
            if (item.type === "process") {
                result = "0 / 0";
                if (item && item.latest && item.latest.testsRun) {
                    result = item.latest.testsPassed + " / " + item.latest.testsRun;
                }
            }
            return result;
        },

        "issuesFormatter": function(item, value, cellDom) {
            var result = "";
            if (item.type === "process") {
                result = 0;
                if (item && item.latest && item.latest.issues) {
                    result = item.latest.issues;
                }
            }
            return result;
        },

        "changesFormatter": function(item, value, cellDom) {
            var result = "";
            if (item.type === "process") {
                result = "0 ( 0 )";
                if (item && item.latest && item.latest.changes) {
                    result = item.latest.changes + " ( " + item.latest.changedFiles + " )";
                }
            }
            return result;
        },

        "createTag": function(item) {
            var tagDisplay = domConstruct.create("div");
            tagDisplay.className = "tagDisplay";

            var tagContainer = domConstruct.create("div");
            tagContainer.className = "tagContainer";
            tagDisplay.appendChild(tagContainer);

            var tagBox = domConstruct.create("div");
            tagBox.className = "tagBox";
            tagContainer.appendChild(tagBox);

            var tag = domConstruct.create("div");
            tag.className = "tagName";
            tag.innerHTML = item;
            tagBox.appendChild(tag);

            return tagDisplay;
        },

        "hasChildren": function(item) {
            return item.type === "project";
        },

        "getChildUrl": function(item) {
            return bootstrap.restUrl + "/dashboard/activity/" + item.id;
        }
    });
});
