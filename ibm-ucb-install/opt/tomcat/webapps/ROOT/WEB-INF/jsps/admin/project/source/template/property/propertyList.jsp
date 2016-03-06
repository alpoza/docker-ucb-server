<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks"%>
<%@page import="java.util.*" %>
<%@page import="org.apache.commons.lang3.StringUtils" %>
<%@page import="com.urbancode.air.property.prop_sheet.PropSheet" %>
<%@page import="com.urbancode.air.property.prop_sheet.PropSheetFactoryRegistry" %>
<%@page import="com.urbancode.ubuild.domain.source.template.SourceConfigTemplateProperty" %>
<%@page import="com.urbancode.air.i18n.TranslateMessage" %>

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" />

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:url var="newPropertyUrl" value="${SourceConfigTemplateTasks.newProperty}">
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>

<%-- Image resources --%>
<c:url var="grabberIconUrl" value="/images/icon_grabber.gif"/>
<c:url var="iconPencilUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconUpUrl" value="/images/icon_up_arrow.gif"/>
<c:url var="iconDownUrl" value="/images/icon_down_arrow.gif"/>
<c:url var="iconCopyUrl" value="/images/icon_copy_project.gif" />
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

<auth:check persistent="${sourceConfigTemplate}" var="canEdit" action="${UBuildAction.SOURCE_TEMPLATE_EDIT}"/>

<%-- CONTENT --%>
<style type="text/css">
    .property-row td {
       background-color: #ffffff;
    }

    .property-row-highlight td {
       background-color: #dee8ef;
    }

    .property-row-moving td {
       background-color: #cbd37c;
    }

</style>


<c:url var="movePropertyUrl" value='<%= new SourceConfigTemplateTasks().methodUrl("moveProperty", false)%>'>
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>
<c:url var="pasteFromClipboardUrl" value='${SourceConfigTemplateTasks.pasteFromClipboard}'>
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>
<c:url var="pasteAndRemoveFromClipboardUrl" value='${SourceConfigTemplateTasks.pasteAndRemoveFromClipboard}'>
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>
<c:set var="groupParamName" value="${WebConstants.CLIPBOARD_PARAM_GROUP_NAME}" />

<script type="text/javascript"> /* <![CDATA[ */

    /**
     * Method to handle updating of workflow property ordering
     */
    var moveProperty = function(fromIdx, toIdx) {
        var url = ${ah3:toJson(movePropertyUrl)}+
            '&'+ WebConstants.SOURCE_CONFIG_TEMPLATE_PROP_SEQ+'='+fromIdx+
            "&"+ "to"+WebConstants.SOURCE_CONFIG_TEMPLATE_PROP_SEQ+'='+toIdx;
        if (fromIdx === toIdx) {
            // TODO
            window.location.reload();
        }
        else if(confirm(i18n("PropertyMoveMessage"))) {
            goTo(url);
        }
        else {
            // TODO
            window.location.reload();
        }
    }

    var pasteFromClipboardUrl = "${pasteFromClipboardUrl}";
    var pasteAndRemoveFromClipboardUrl = "${pasteAndRemoveFromClipboardUrl}";
    var groupParamName = "${groupParamName}";

    function pasteFromClipboard(groupName) {
        var url = pasteFromClipboardUrl + "&" + groupParamName + "=" + groupName;
        goTo(url);
    }

    function pasteAndRemoveFromClipboard(groupName) {
        var url = pasteAndRemoveFromClipboardUrl + "&" + groupParamName + "=" + groupName;
        goTo(url);
    }
/* ]]> */
</script>

<br/>
<c:import url="/WEB-INF/jsps/admin/library/jobconfig/clipboard.jsp">
  <c:param name="clipboard-param-show-for-paste-name-prefix" value="${WebConstants.CLIPBOARD_COPIED_TEMPLATE_PROPS}"/>
</c:import>
<br/>

<div class="component-heading">
  <div style="float: right;">
    <ucf:link label="${ub:i18n('Create')}" href="${newPropertyUrl}" enabled="${canEdit}"/>
  </div>
  ${ub:i18n("Properties")}
</div>
<table id="PropertyTable" class="data-table" width="100%">
  <thead>
    <tr>
      <th scope="col" width="15%">${ub:i18n("Name")}</th>
      <th scope="col" width="12%">${ub:i18n("Type")}</th>
      <th scope="col" width="5%" >${ub:i18n("Required")}</th>
      <th scope="col"            >${ub:i18n("DefaultValue")}</th>
      <th scope="col"            >${ub:i18n("Description")}</th>
      <th scope="col" width="10%">${ub:i18n("Actions")}</th>
    </tr>
  </thead>
  <tbody>
    <c:choose>
      <c:when test="${empty sourceConfigTemplate.propertyList}">
        <tr bgcolor="#ffffff">
          <td colspan="6">${ub:i18n("PropertyNoneDefinedMessage")}</td>
        </tr>
      </c:when>
      <c:otherwise>
        <c:forEach var="property" items="${sourceConfigTemplate.propertyList}" varStatus="status">
          <c:url var="editPropertyUrlSeq" value="${SourceConfigTemplateTasks.editProperty}">
            <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
            <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_PROP_SEQ}" value="${status.index}"/>
          </c:url>

          <c:url var="copyPropertyToClipboardUrl" value='${SourceConfigTemplateTasks.copyPropertyToClipboard}'>
            <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
            <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_PROP_SEQ}" value="${status.index}"/>
          </c:url>

          <c:url var="removePropertyUrlSeq" value='<%= new SourceConfigTemplateTasks().methodUrl("removeProperty", false)%>'>
            <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
            <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_PROP_SEQ}" value="${status.index}"/>
          </c:url>

          <c:set var="rowId" value="property-row-${status.index}"/>
          <c:set var="rowGrabberId" value="${rowId}-grabber"/>
          <tr id="${rowId}" class="property-row">
            <td nowrap="nowrap">
              <c:if test="${sourceConfigTemplateProp==null && canEdit}">
                <script type="text/javascript"> /* <![CDATA[ */
                  Element.observe(window, 'load', function(event) {
                      new UC_WORKFLOW_PROPERTY_ROW("${rowId}", ${status.index}, {'onChange': moveProperty});
                  });
                  /* ]]> */
                </script>
                <div style="float: right;" align="right"><img style="cursor:move;" id="${rowGrabberId}"
                 alt="${ub:i18n('Reorder')}" title="${ub:i18n('Reorder')}" src="${grabberIconUrl}"/></div>
              </c:if>

              <ucf:link href="${editPropertyUrlSeq}#property" label="${property.name}" enabled="${sourceConfigTemplateProp==null && canEdit}"/>
            </td>

            <td nowrap="nowrap">
              ${ub:i18n(fn:escapeXml(property.interfaceType.name))}
              <c:if test="${property.scriptedValue}"> ${ub:i18n("PropertyScriptedParens")}</c:if>
              <c:if test="${property.jobExecutionValue}"> ${ub:i18n("PropertyJobExecutionParens")}</c:if>
            </td>

            <td nowrap="nowrap" align="center">
              ${ub:i18n(fn:escapeXml(property.required))}
            </td>

            <td>
              <%
                SourceConfigTemplateProperty property = (SourceConfigTemplateProperty) pageContext.getAttribute("property");
                String value = property.getPropertyValue().getDisplayedValue();
                if (property.getInterfaceType().isIntegrationPlugin() && !StringUtils.isBlank(value)) {
                    UUID propSheetId = UUID.fromString(value);
                    PropSheet propSheet = PropSheetFactoryRegistry.getFactory().getPropSheetForId(propSheetId);

                    if (propSheet != null) {
                        value = propSheet.getName();
                    }
                    else {
                        value = TranslateMessage.translate("PropertyInvalidPropGroupMessage");
                    }
                }

                pageContext.setAttribute("propertyValue", value);
              %>
              ${fn:escapeXml(propertyValue)}
              <c:if test="${(property.scriptedValue or property.jobExecutionValue) and not empty property.valueScript}">
                ${ub:i18n("PropertyScriptedValue")}
              </c:if>
            </td>
            <td>${fn:escapeXml(property.description)}</td>

            <td align="center" height="1" nowrap="nowrap">
              <ucf:link href="${editPropertyUrlSeq}#property" img="${iconPencilUrl}" label="${ub:i18n('Edit')}" enabled="${canEdit}"/> &nbsp;
              <ucf:link href="${copyPropertyToClipboardUrl}"
                label="${ub:i18n('CopyVerb')}" title="${ub:i18n('CopyVerb')}" img="${iconCopyUrl}" enabled="${canEdit}"/>&nbsp;
              <ucf:deletelink href="${removePropertyUrlSeq}" name="${property.name}" label="${ub:i18n('Remove')}" img="${iconDeleteUrl}" enabled="${canEdit}"/>
            </td>
          </tr>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </tbody>
</table>
