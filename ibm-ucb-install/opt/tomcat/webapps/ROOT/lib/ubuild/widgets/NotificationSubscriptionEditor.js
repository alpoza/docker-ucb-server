/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*global define, require */
define(["dojo/_base/declare",
        "dojo/_base/lang",
        "dojo/_base/array",
        "dijit/_Widget",
        "dijit/_TemplatedMixin",
        "dojo/dom-construct",
        "dojo/_base/xhr",
        "dijit/form/Button",
        "dijit/form/TextBox",
        "dojox/layout/TableContainer",
        "dojo/data/ObjectStore",
        "dojo/store/Memory",
        "dijit/form/Select",
        "js/webext/widgets/Dialog",
        "dojo/json",
        "dojo/DeferredList",
        "dojo/_base/Deferred",
        "dojo/query"],
        function (declare, lang, array, _Widget, _TemplatedMixin, domConstruct, baseXhr, Button, TextBox, TableContainer, ObjectStore, Memory, Select, Dialog, json, DeferredList, Deferred, query) {
        return declare("ubuild/widgets/NotificationSubscriptionEditor", [_Widget, _TemplatedMixin], {

            templateString:
                '<div data-dojo-attach-point="subscriptions">' +
                    '<div class="subscribe-button">' +
                        '<div data-dojo-attach-point="subscribeLabelAttach"></div>' +
                        '<div data-dojo-attach-point="subscribeRemoveAttach"></div>' +
                    '</div>' +
                '</div>',
            dialog: null,
            ID: null,
            projectID: null,
            currentStatus: 'DEFAULT',
            subscriptionID: null,
            isProject: true,
            subscriptionEventJson: null,
            notificationSubscriptionURL: null,
            projectNotificationSubscriptionsURL: null,
            isButton: false,

            postCreate: function() {
                this.inherited(arguments);
                var self = this;
                if (self.isButton) {
                    this.subscribeLabel = new Button({
                        label: i18n(this.currentStatusLabel),
                        style: "height: 25px;",
                        onClick: function(){
                            // get processes of the project and their status
                            // if success show dialog
                            self.getSubscriptionJson();
                        }
                    }, this.subscribeLabelAttach);

                    this.subscribeRemove = new Button({
                        label: "<img src='/images/icon_delete.gif'/>",
                        style: "height: 25px; width: 25px;",
                        onClick: function () {
                            // remove the project's or process's status
                            // if success, remove btn click
                            self.removeBtnClick();
                        }
                    }, this.subscribeRemoveAttach)

                    if (this.currentStatus === 'NONE') {
                        this.subscribeRemove.domNode.style.display = "none";
                    }
                }
                else {
                    self.getSubscriptionJson();
                }
            },

            renderData: function(data) {
                var self = this;
                var tableAttach = domConstruct.create("div");

                if (self.isButton) {
                    self.dialog = new Dialog({
                        title: i18n("NotificationSubscription"),
                        content: tableAttach
                    });
                    self.dialog.show();
                }
                else {
                    domConstruct.place(tableAttach, self.subscriptions, "only");
                }

                var table = domConstruct.create("table");
                var tBody = domConstruct.create("tBody");
                domConstruct.place(tBody, table, "only");
                // define the select store
                var options = [];
                for (var key in self.subscriptionEventJson) {
                    options.push({id: key, label: i18n(self.subscriptionEventJson[key])});
                }
                var store = new Memory({
                    data: options
                });
                var os = new ObjectStore({ objectStore: store });

                // If we pass in multiple projects, we should render all of them
                if (Array.isArray(data)) {
                    data.forEach(function (projectSubscription) {
                        self.renderProjectSubscription(projectSubscription, 0, os, table);
                    });
                }
                else {
                    self.renderProjectSubscription(data, 0, os, table);
                }
                domConstruct.place(table, tableAttach, "first");
                var btnTable = new TableContainer({
                    cols: 1,
                    showLabels: false
                });

                if (self.isButton) {
                    var doneBtn = new Button({
                        label: i18n("Done"),
                        style: "text-align:center;",
                        onClick: function () {
                            self.dialog.destroy();
                        }
                    });
                    btnTable.addChild(doneBtn);
                    btnTable.placeAt(tableAttach);
                }
            },

            removeBtnClick: function() {
                var self = this;
                if (self.subscriptionID === -1) {
                    baseXhr.post({
                        headers: {
                            "Content-Type": "application/json"
                        },
                        url: self.notificationSubscriptionURL,
                        postData: json.stringify({
                                    subscribedObjectType: self.isProject ? "com.urbancode.ubuild.domain.project.Project" : "com.urbancode.ubuild.domain.workflow.Workflow",
                                    subscribedObjectId: self.ID,
                                    event: 'NONE'}),
                        handleAs: "json",
                        load: function(data, ioArgs) {
                             self.subscribeLabel.set('label', i18n('None'));
                             self.subscribeRemove.domNode.style.display = "none";
                             self.subscriptionID = data.id;
                             self.currentStatus = data.event;
                        },
                        error: function(data) {
                            alert(i18n("NotificationSubscriptionUpdateError"));
                        }
                      });
                }
                else {
                    baseXhr.put({
                        headers: {
                            "Content-Type": "application/json"
                        },
                        url: self.notificationSubscriptionURL + "/" + self.subscriptionID,
                        putData: json.stringify({event: 'NONE'}),
                        handleAs: "json",
                        load: function(data, ioArgs) {
                            self.subscribeLabel.set('label', i18n('None'));
                            self.subscribeRemove.domNode.style.display = "none";
                            self.currentStatus = data.event;
                        },
                        error: function(data) {
                            alert(i18n("NotificationSubscriptionUpdateError"));
                        }
                    });
                }
            },

            renderProjectSubscription: function(subscription, level, os, table) {
                var self = this;
                var subscriptionLabel = domConstruct.create("label", {
                    innerHTML: subscription.subscribedObjectName,
                    style: { "padding-left": 15 * level + "px" }
                });
                var subscriptionEventSelect = new Select ({
                    store: os,
                    value: subscription.event ? subscription.event : "DEFAULT",
                    selectData: subscription,
                    style: { "width": "160px" }
                 });
                subscriptionEventSelect.on("change", function() {
                    var newEvent = this.get("value");
                    var newEventLabel = this.domNode.textContent;
                    var _this = this;

                    // User change event and add the subscription into DB, expect two cases
                    // 1. the data id is undefined and the user select default
                    // 1. the id is -1 and user select default
                    if (!((_this.selectData.id === null && newEvent === 'DEFAULT') || (_this.selectData.id === -1 && newEvent === 'DEFAULT'))){
                        _this.selectData.event = newEvent;

                        // change the label on button
                        if (_this.selectData.subscribedObjectId === self.ID) {
                            self.subscribeLabel.set('label', i18n(newEventLabel));
                            if (newEvent === 'NONE') {
                                self.subscribeRemove.domNode.style.display = "none";
                            }
                            else {
                                self.subscribeRemove.domNode.style.display = "";
                            }
                        }
                        if (_this.selectData.id === null || _this.selectData.id === -1) {
                            // create a new subscription
                            baseXhr.post({
                                headers: {
                                    "Content-Type": "application/json"
                                },
                                url: self.notificationSubscriptionURL,
                                postData: json.stringify({
                                            subscribedObjectType: _this.selectData.subscribedObjectType,
                                            subscribedObjectId: _this.selectData.subscribedObjectId,
                                            event: newEvent}),
                                handleAs: "json",
                                load: function(data, ioArgs) {
                                    _this.selectData.id = data.id;
                                    _this.selectData.userId = data.userId;
                                    _this.selectData.location = data.location;
                                    if (_this.selectData.subscribedObjectId === self.ID) {
                                        self.subscriptionID = data.id;
                                    }
                                },
                                error: function(data) {
                                    alert(i18n("NotificationSubscriptionUpdateError"));
                                }
                            });
                        }
                        else {
                            baseXhr.put({
                                headers: {
                                    "Content-Type": "application/json"
                                },
                                url: self.notificationSubscriptionURL + "/" + _this.selectData.id,
                                putData: json.stringify(_this.selectData),
                                handleAs: "json",
                                load: function(data, ioArgs) {
                                },
                                error: function(data) {
                                    alert(i18n("NotificationSubscriptionUpdateError"));
                                }
                            });
                        }
                    }
                });

                var tr = domConstruct.create("tr");
                domConstruct.place(tr, table, "last");

                var labelTd = domConstruct.create("td");
                domConstruct.place(labelTd, tr, "first");
                domConstruct.place(subscriptionLabel, labelTd, "only");

                var selectTd = domConstruct.create("td");
                domConstruct.place(selectTd, labelTd, "after");
                subscriptionEventSelect.placeAt(selectTd);
                subscriptionEventSelect.startup();

                // If the subscription has children, render them
                if (subscription.children) {
                    subscription.children.forEach(function(child) {
                        self.renderProjectSubscription(child, level + 1, os, table);
                    });
                }
            },

            getSubscriptionJson: function() {
                var self = this;
                baseXhr.get({
                    url: self.projectNotificationSubscriptionsURL + "?allowNull=true",
                    handleAs: "json",
                    load: function(data, ioArgs) {
                        self.renderData(data);
                    },
                    error: function(data) {
                        alert(i18n("ProjectAndProcessGetError"));
                    }
                });
            }
        });
    });
