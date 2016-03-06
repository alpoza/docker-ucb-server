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
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/request/xhr",
    "dojo/dom-construct",
    "dojo/dom-class",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetBase",
    "js/webext/widgets/Table"],
function(   declare,
            lang,
            xhr,
            domConstruct,
            domClass,
            _TemplatedMixin,
            _WidgetBase,
            Table) {
    return declare([_WidgetBase, _TemplatedMixin], {

        templateString: '<div data-dojo-attach-point="buildArtifacts"></div>',
        artifactType: null,
        artifactSetId: null,
        buildLifeId: null,
        viewFileUrl: null,
        downloadSingleArtifactUrl: null,
        downloadAllArtifactsUrl: null,
        grid: null,
        canDownload: false,
        dateFormat: null,

        refresh: function() {
            this.grid.refresh();
        },

        postCreate: function() {
            var self = this;

            var gridRestUrl = bootstrap.restUrl + "/build-lives/" + self.buildLifeId + "/" + self.artifactType + "/" + self.artifactSetId + "/artifacts";
            var gridLayout = [{
                name: i18n("FilePath"),
                formatter: self.pathFormatter,
                style: { width: "40%"},
                parentWidget: this
            }, {
                name: i18n("Size"),
                formatter: self.sizeFormatter,
                style: { width: "15%" },
                parentWidget: this
            }, {
                name: i18n("Hash"),
                formatter: self.hashFormatter,
                style: { width: "30%" }
            }, {
                name: i18n("LastModified"),
                formatter: self.dateFormatter,
                style: { width: "15%" },
                parentWidget: this
            }];

            this.grid = new Table({
                "url": gridRestUrl,
                "noDataMessage": i18n("No records found."),
                "hidePagination": false,
                "columns": gridLayout,
                "pageOptions": [25, 50, 100, 250],
                "rowsPerPage": 25
            });

            self.grid.placeAt(self.buildArtifacts);
        },

        pathFormatter: function(item) {
            var self = this.parentWidget;
            var result = domConstruct.create("div");

            if (self.canDownload) {
                var link = domConstruct.create("a");
                link.innerHTML = item.path;
                link.href = self.viewFileUrl + encodeURIComponent(item.path);
                result.appendChild(link);
            }
            else {
                result.innerHTML = item.path;
            }

            return result;
        },

        sizeFormatter: function(item) {
            var self = this.parentWidget;
            var result = domConstruct.create("div");

            var size = domConstruct.create("span");
            size.innerHTML = util.fileSizeFormat(item.size, 2);
            result.appendChild(size);

            if (self.canDownload) {
                var spacer = domConstruct.create("span");
                spacer.innerHTML = "&nbsp;";
                result.appendChild(spacer);
                var small = domConstruct.create("small");
                result.appendChild(small);

                var link = domConstruct.create("a");
                link.innerHTML = i18n("ArtifactsDownloadLowercase");
                link.href = self.downloadSingleArtifactUrl + encodeURIComponent(item.path);
                small.appendChild(link);
            }
            else {
                result.innerHTML = item.size;
            }

            return result;
        },

        hashFormatter: function(item) {
            var result = domConstruct.create("div");
            if (item.hashes) {
                result.innerHTML = item.hashes.join("<br/>");
            }
            return result;
        },

        dateFormatter: function(item) {
            var self = this.parentWidget;
            return util.dateOnlyFormat(item.lastModified, self.dateFormat);
        }
    });
});
