<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub" uri="http://www.urbancode.com/ubuild/tags" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.GroupTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.SecurityUserAdminTasks" useConversation="false"/>

<c:url var="imgUrl" value="/images"/>

<c:url var="saveAddRemoveGroupUsersUrl" value="${SecurityUserAdminTasks.saveAddRemoveGroupUsers}">
  <c:param name="${WebConstants.GROUP_ID}" value="${group.id}"/>
</c:url>
<c:url var="getGroupCurrentUsersUrl" value="${SecurityUserAdminTasks.getGroupCurrentUsers}">
  <c:param name="${WebConstants.GROUP_ID}" value="${group.id}"/>
</c:url>
<c:url var="getGroupNewUsersUrl" value="${SecurityUserAdminTasks.getGroupNewUsers}">
  <c:param name="${WebConstants.GROUP_ID}" value="${group.id}"/>
</c:url>
<c:url var="viewGroupUrl" value="${GroupTasks.viewGroup}">
  <c:param name="${WebConstants.GROUP_ID}" value="${group.id}"/>
</c:url>



<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp">
  <c:param name="noResize" value="true"/>
</c:import>

<style type="text/css">
  #addItems {
    display: inline-block;
    width: 42px;
    height: 35px;
    background: url("${ah3:escapeJs(imgUrl)}/arrow-up-button.gif") no-repeat 0 0;
  }

  #addItems:hover {
    background-position: 0 -35px;
  }

  #addItems span {
    display: none;
  }

  #removeItems {
    display: inline-block;
    width: 42px;
    height: 35px;
    background: url("${ah3:escapeJs(imgUrl)}/arrow-down-button.gif") no-repeat 0 0;
  }

  #removeItems:hover {
    background-position: 0 -35px;
  }

  #removeItems span {
    display: none;
  }
</style>

<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("AddRemoveUsers")}</a></li>
  </ul>
</div>

<div class="contents">
  <div class="table_wrapper">
    <form id="addItemsForm" action="${saveAddRemoveGroupUsersUrl}" method="post" onsubmit="addRemoveTableFormController.preSaveAction()">

      <div style="margin:0 2em 0 1em">
        <div><h2>${ub:i18nMessage("UsersForGroup", group.name)}</h2></div>
        <div id="items-in-collection-paging" class="yui-skin-sam" style="margin:3px 0 5px 0; text-align:right;"></div>
        <div id="items-in-collection-table" style="width:100%"></div>
      </div>

      <div style="text-align:center; margin: 10px 0 10px 0;">
        <!--[if lt IE 7 ]>
          <a title="${ub:i18n('AddItems')}" onclick="addRemoveTableFormController.addSelectedItems()"><img border="0" alt="${ub:i18n('AddItems')}" src="${fn:escapeXml(imgUrl)}/arrowUP.gif"/></a>
          <a title="${ub:i18n('RemoveItems')}" onclick="addRemoveTableFormController.removeSelectedItems()"><img border="0" alt="${ub:i18n('RemoveItems')}" src="${fn:escapeXml(imgUrl)}/arrowDOWN.gif"/></a>
        <![endif]-->
        <!--[if gte IE 7]><!-->
          <a id="addItems" title="${ub:i18n('Add')}" onclick="addRemoveTableFormController.addSelectedItems()" style="cursor: pointer;"><span>${ub:i18n("AddItems")}</span></a>
          <a id="removeItems" title="${ub:i18n('Remove')}" onclick="addRemoveTableFormController.removeSelectedItems()" style="cursor: pointer;"><span>${ub:i18n("RemoveItems")}</span></a>
        <!--<![endif]-->
      </div>

      <div style="margin:0 2em 0 1em">
        <div><h2>${ub:i18n("AdditionalUsers")}</h2></div>
        <div id="autocomplete" style="margin: 3px 0 5px 0; text-align:left;">
          <label for="query_input">${ub:i18n("FilterWithColon")}</label><input type="text" id="query_input" name="query" value="" size="10" onkeypress="return event.keyCode!=13"/>
          <div id="dt_ac_container"></div>
        </div>
        <div id="add-items-table" style="width:100%"></div>
        <div id="add-items-paging" class="yui-skin-sam" style="margin: 5px 0 0 0; text-align:right;"></div>
      </div>

      <div style="margin:7px 0 0 0">
        <input id="${WebConstants.USER_ID}" type="hidden" name="${WebConstants.USER_ID}" value="" />
        <ucf:button name="Save" label="${ub:i18n('Save')}" submit="${true}"/>
        <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="addRemoveTableFormController.cancelTable(); return false"/>
      </div>
    </form>
    </div>
</div>

<script type="text/javascript">
  /* <![CDATA[ */
          var addRemoveTableFormController = new AddRemoveTableFormController({
              "backUrl" : ${ah3:toJson(viewGroupUrl)},
              "itemsInCollectionUrl" : ${ah3:toJson(getGroupCurrentUsersUrl)},
              "addItemsUrl" : ${ah3:toJson(getGroupNewUsersUrl)},
              "imgUrl": ${ah3:toJson(imgUrl)},

              "resultInputId": WebConstants.USER_ID,

              "itemIdAttribute": "UserId",
              "itemEnabled": function(oRecord) { return oRecord.getData('CanManage')},
              "tableResponseSchema": {
                  "resultsList": "items",
                  "fields": [
                      {"key":"UserId"},
                      {"key":"Name"},
                      {"key":"ActualName"},
                      {"key":"AuthenticationRealm"},
                      {"key":"AuthorizationRealm"},
                      {"key":"CanManage"},
                      {"key":"Active"}
                  ],
                  "metaFields":{
                      "totalRecords": "totalRecords"
                  }
                },

                "columnDefs": [
                    {
                        "key": "Name",
                        "label": "${ub:i18n('Name')}",
                        "className":"nameCol",
                        "sortable": true,
                        "formatter": function(elLiner, oRecord, oColumn, oData) {
                            var name = oRecord.getData('Name');
                            var actualName = oRecord.getData('ActualName');
                            if (!!actualName) {
                                name += " (" + actualName + ")";
                            }

                            var active = !!oRecord.getData('Active');

                            $(elLiner).insert(name.escapeHTML());
                            if (!active) {
                                $(elLiner).insert('<span style="color:#FF8C00">(' + i18n("Inactive") +')<span>');
                            }
                        }
                    },
                    {
                        "key": "AuthenticationRealm",
                        "label": "${ub:i18n('AuthenticationRealm')}",
                        "className":"authenticationCol",
                        "sortable": true,
                        "formatter": function(elLiner, oRecord, oColumn, oData) {
                            var authenticationRealm = oRecord.getData('AuthenticationRealm');
                            var canManage = !!oRecord.getData('CanManage');

                            $(elLiner).insert(authenticationRealm.escapeHTML());
                            if (!canManage) {
                                $(elLiner).insert(' <span style="color:#FF8C00">(' + i18n("UsersManuallyAddGroup") +')<span>');
                            }
                        }
                    }
                ],

              "emptyMessage": "${ub:i18n('No records found.')}",
              "loadingMessage": "${ub:i18n('LoadingEllipsis')}"
          });
          YAHOO.util.Event.addListener(window, "load", function() {
              addRemoveTableFormController.initializeItemsInCollectionTable();
              addRemoveTableFormController.initializeAddItemTable();
          });
  /* ]]> */
</script>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
