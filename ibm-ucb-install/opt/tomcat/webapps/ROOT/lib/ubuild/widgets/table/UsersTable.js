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
        "dijit/_TemplatedMixin",
        "dijit/_Widget",
        "dijit/form/Button",
        "dojo/_base/declare",
        "dojo/_base/lang",
        "dojo/_base/xhr",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/on",
        "dojox/html/entities",
        "js/webext/widgets/Alert",
        "js/webext/widgets/Dialog",
        "js/webext/widgets/GenericConfirm",
        "js/webext/widgets/Table",
        "js/util/ie/goTo"
        ],
function(
        _TemplatedMixin,
        _Widget,
        Button,
        declare,
        lang,
        xhr,
        domClass,
        domConstruct,
        on,
        entities,
        Alert,
        Dialog,
        GenericConfirm,
        Table,
        goTo
) {
    /**
     * A users table widget with pagination, sorting, and custom formatting. Uses an actual
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
     *
     * Supported properties:
     *  tasksUrl / String                   The URL for the UserTasks class. Required.
     */

    return declare('js.ubuild.widgets.table.UsersTable', [_Widget, _TemplatedMixin], {
        templateString:
            '<div class="usersTable">'+
                '<div data-dojo-attach-point="usersGrid"></div>'+
            '</div>',
        tasksUrl: undefined,

        /**
         *
         */
        postCreate: function() {
            this.inherited(arguments);
            var self = this;

            this.inactivateImageTemplate = domConstruct.create("img", {
                "border": "0",
                "src": bootstrap.imagesUrl + "/icon_active.gif",
                "title": i18n("Inactivate"),
                "alt": i18n("Inactivate")
            });

            this.inactivateDisabledImageTemplate = domConstruct.create("img", {
                "border": "0",
                "src": bootstrap.imagesUrl + "/icon_active_disabled.gif",
                "title": i18n("DeactivateDisabled"),
                "alt": i18n("DeactivateDisabled")
            });

            this.activateImageTemplate = domConstruct.create("img", {
                "border": "0",
                "src": bootstrap.imagesUrl + "/icon_inactive.gif",
                "title": i18n("Reactivate"),
                "alt": i18n("Reactivate")
            });

            this.linkTemplate = domConstruct.create("a", { "class": "actions-link" });

            var gridRestUrl = bootstrap.restUrl + "/users";
            var gridLayout = [{
                    name: i18n("UserName"),
                    orderField: "name",
                    field: "name",
                    formatter: lang.hitch(this, 'resourceFormatter'),
                    style: { width: "20%" },
                    filterField: "name",
                    filterType: "text"
                },
                {
                    name: i18n("UserProfileActualName"),
                    orderField: "actualName",
                    field: "actualName",
                    filterField: "actualName",
                    filterType: "text",
                    style: { width: "20%" }
                },
                {
                    name: i18n("Email"),
                    field: "email",
                    orderField: "email",
                    filterField: "email",
                    filterType: "text",
                    style: { width: "20%" }
                },
                {
                    name: i18n("AuthenticationRealm"),
                    field: "realm",
                    formatter: lang.hitch(this, 'authenticationRealmFormatter'),
                    orderField: "realm",
                    filterField: "realm",
                    filterType: "select",
                    filterOptions: self.getAuthenticationRealms(),
                    style: { width: "30%" }
                },
                {
                    name: i18n("Enabled"),
                    orderField: "inactive",
                    filterField: "inactive",
                    filterType: "select",
                    filterOptions: [
                                     {
                                         "label": i18n("Active"),
                                         "value": "ACTIVE"
                                     },
                                     {
                                         "label": i18n("Inactive"),
                                         "value": "INACTIVE"
                                     }
                                   ],
                    formatter: lang.hitch(self, 'actionsFormatter'),
                    style: { width: "10%" }
                }];

            this.grid = new Table({
                "url": gridRestUrl,
                "orderField": "name",
                "noDataMessage": i18n("UserDataNotFound"),
                "hidePagination": false,
                "hideExpandCollapse": true,
                "columns": gridLayout,
                "pageOptions": [25, 50, 100, 250],
                "rowsPerPage": 25,
                "alwaysShowFilters": true
            });
            this.own(this.grid);
            this.grid.placeAt(this.usersGrid);
        },

        /**
         *
         */
        actionsFormatter: function(item) {
            var self = this;
            var result = domConstruct.create("div");

            if (item.active && item.security.canDeactivate) {
                var inactivateImage;
                if (item.deletable) {
                    var inactivateLink = self.linkTemplate.cloneNode(true);
                    inactivateImage = self.inactivateImageTemplate.cloneNode(true);
                    inactivateLink.appendChild(inactivateImage);
                    result.appendChild(inactivateLink);

                    var inactivateListener = on(inactivateLink, "click", function() {
                        self.confirmInactivate(item);
                    });
                    this.own(inactivateListener);
                }
                else {
                    inactivateImage = self.inactivateDisabledImageTemplate.cloneNode(true);
                    result.appendChild(inactivateImage);
                }
            }
            else if (!item.active && item.security.canReactivate) {
                var activateLink = self.linkTemplate.cloneNode(true);
                var activateImage = self.activateImageTemplate.cloneNode(true);
                activateLink.appendChild(activateImage);
                result.appendChild(activateLink);

                var activateListener = on(activateLink, "click", function() {
                    self.confirmActivate(item);
                });
                this.own(activateListener);
            }

            return result;
        },

        resourceFormatter: function(item) {
            var self = this;

            var result = domConstruct.create("div");
            var viewLink = self.createViewLink(result, item);
            viewLink.innerHTML = entities.encode(item.name);
            result.appendChild(viewLink);

            return result;
        },

        authenticationRealmFormatter: function(item) {
            var result = domConstruct.create("div");
            result.innerHTML = i18n(item.realm);
            return result;
        },

        viewUser: function(target) {
            var self = this;
            goTo(self.tasksUrl + "/viewUser?userId=" + target.id);
        },

        createViewLink: function(parent, item) {
            var self = this;
            var viewLink = self.linkTemplate.cloneNode(true);
            parent.appendChild(viewLink);
            var viewListener = on(viewLink, "click", function() {
                self.viewUser(item);
            });
            this.own(viewListener);

            return viewLink;
        },

        /**
         *
         */
        confirmInactivate: function(target) {
            var self = this;
            var confirm = new GenericConfirm({
                message: i18n("UserConfirmInactivate", target.name),
                action: function() {
                    self.grid.block();
                    xhr.put({
                        url: bootstrap.restUrl + "/users/" + target.id + "/inactivate",
                        handleAs: "json",
                        load: function(data) {
                            self.grid.unblock();
                            self.grid.refresh();
                        }
                    });
                }
            });
        },

        /**
         *
         */
        confirmActivate: function(target) {
            var self = this;
            self.grid.block();
            xhr.put({
                url: bootstrap.restUrl + "/users/" + target.id + "/activate",
                handleAs: "json",
                load: function(data) {
                    self.grid.unblock();
                    self.grid.refresh();
                }
            });
        },

        getAuthenticationRealms: function() {
            var self = this;
            var realms = [];
            xhr.get({
               url: bootstrap.restUrl + "/authenticationRealm",
               sync: true, // otherwise the method returns with no realms added
               handleAs: "json",
               load: function(data) {
                   dojo.forEach(data, function(realm) {
                       realms.push({ "label": i18n(realm.name), "value": realm.id });
                   });
               }
            });
            return realms;
        }
    });
});
