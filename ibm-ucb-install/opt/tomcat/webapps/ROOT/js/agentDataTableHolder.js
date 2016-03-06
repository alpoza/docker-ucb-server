/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var AgentDataTableHolder = function() {
    this.imgUrl = "";
    this.viewAgentUrl = "";
    this.testAgentUrl = "";

    this.noWrapFormatter = function(elLiner,oRecord,oColumn,oData) {
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        elLiner.innerHTML = oData;
    }

    this.centerNoWrapFormatter = function(elLiner,oRecord,oColumn,oData) {
        YAHOO.util.Dom.setStyle(elLiner,"text-align", "center");
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        elLiner.innerHTML = i18n(oData);
    }

    this.descriptionFormatter = function(elLiner,oRecord,oColumn,oData) {
        if (!oData) {
            elLiner.innerHTML = "";
        }
        else if (oData.length <= 256) {
              elLiner.innerHTML = oData;
        }
        else {
              elLiner.innerHTML = oData.substr(0, 256) + "...";
        }
    }

    this.statusFormatter = function(elLiner,oRecord,oColumn,oData) {
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        if (oData == "Online") {
            YAHOO.util.Dom.setStyle(elLiner.parentNode,"background-color", "#8dd889");
        } else if (oData == "Offline") {
            YAHOO.util.Dom.setStyle(elLiner.parentNode,"background-color", "#c86f6f");
        } else if (oData == "Upgrading" || oData == "Restarting") {
            YAHOO.util.Dom.setStyle(elLiner.parentNode,"background-color", "#f4e48f");
        } else if (oData == "Queued For Upgrade" || oData == "Queued For Restart") {
            YAHOO.util.Dom.setStyle(elLiner.parentNode,"background-color", "#0033ff");
        } else {
            YAHOO.util.Dom.setStyle(elLiner.parentNode,"background-color", "#ff8000");
        }
        YAHOO.util.Dom.setStyle(elLiner,"text-align", "center");
        elLiner.innerHTML = i18n(oData);
    }

    this.lastSeenFormatter = function(elLiner,oRecord,oColumn,oData) {
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        var status = oRecord.getData('status');
        if (status === "Online") {
            elLiner.innerHTML = i18n("Now");
        }
        else if (!oData) {
            elLiner.innerHTML = i18n("Unknown");
        }
        else {
            var text = oRecord.getData('lastOnlineString');
            elLiner.innerHTML = text || oData;
        }

        YAHOO.util.Dom.setStyle(elLiner,"text-align", "center");
    }

    var viewAgentLink = function(id, name, viewAgentUrl, imgUrl) {
        var a = document.createElement("a");
        a.href = viewAgentUrl + "?agent_id=" + id;
        a.id = 'view' + id;

        var img = document.createElement("img");
        img.src = imgUrl + "/icon_magnifyglass.gif";
        img.title = i18n("View");
        img.alt = i18n("View");
        img.border = 0;

        a.appendChild(img);

        return a;
    }

    var testAgentLink = function(id, name, testAgentUrl, imgUrl) {
        var a = document.createElement("a");
        a.href = "javascript:showPopup('" + testAgentUrl + "?agent_id=" + id + "', 640, 200);";
        a.id = 'test' + id;

        var img = document.createElement("img");
        img.src = imgUrl + "/icon_run.gif";
        img.title = i18n("CommunicationTest");
        img.alt = i18n("CommunicationTest");
        img.border = 0;

        a.appendChild(img);

        return a;
    }

    this.operationsFormatter = function(elLiner,oRecord,oColumn,oData) {
        YAHOO.util.Dom.setStyle(elLiner, "text-align", "center");
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        elLiner.innerHTML = "";
        elLiner.appendChild(viewAgentLink(oRecord.getData("id"),oRecord.getData("name"),this.viewAgentUrl, this.imgUrl));
        elLiner.appendChild(document.createTextNode('\u00A0\u00A0'));
        if (oRecord.getData("status").match("Online")) {
            elLiner.appendChild(testAgentLink(oRecord.getData("id"), oRecord.getData("name"), this.testAgentUrl, this.imgUrl));
        }
    }

    this.nameFormatter = function(elLiner,oRecord,oColumn,oData) {
        elLiner.innerHTML = "";
        YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
        var a = document.createElement("a");
        a.href = this.viewAgentUrl + "?agent_id=" + oRecord.getData("id");
        a.id = 'viewByName' + oRecord.getData("id");
        a.appendChild(document.createTextNode(oData));

        elLiner.appendChild(a);
    }

    this.newCheckboxFormatter = function(elLiner, oRecord, oColumn, oData) {
        var id = parseInt(oRecord.getData('id'));
        if (this.selectedAgents.indexOf(id) != -1) {
            oData = true;
        }
        YAHOO.widget.DataTable.formatCheckbox(elLiner, oRecord, oColumn, oData);
    }

    this.dataReturnPayloadHandler = function(oRequest, oResponse, oPayload) {
        if (!oPayload) {
            oPayload = {};
        }
        oPayload.totalRecords = oResponse.meta.totalRecords;
        return oPayload;
    }

    this.beforeLoadDataHandler = function(oRequest, oResponse, oPayload) {
        oPayload.pagination.recordOffset = parseInt(oResponse.meta.startIndex);
        return true;
    }
}
