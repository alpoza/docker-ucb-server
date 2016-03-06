<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettings"%>
<%@page import="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@ page import="com.urbancode.commons.util.LocalNetworkResourceResolver"%>
<%@page import="com.urbancode.commons.xml.*"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0"%>
<%@taglib prefix="error" uri="error"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" id="SSTasks" useConversation="false"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<%
    EvenOdd eo = new EvenOdd();
    pageContext.setAttribute( "eo", eo );
%>
<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true" />
    <c:set var="textFieldAttributes" value="" />
    <%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true" />
    <c:set var="textFieldAttributes" value="disabled class='inputdissabled'" />
  </c:otherwise>
</c:choose>

<jsp:useBean id="server_settings" scope="request"
  type="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettings" />
<jsp:useBean id="logging_settings" scope="request" type="java.lang.String" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:url var="saveUrl" value="${ServerSettingsTasks.saveNetworkServerSettings}" />
<c:url var="editUrl" value='${SSTasks.editNetworkServerSettings}' />
<c:url var="cancelUrl" value="${ServerSettingsTasks.cancelNetworkServerSettings}" />
<c:url var="doneUrl" value="${SystemTasks.viewIndex}" />

<%--  CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEditServerSettings')}" />
  <jsp:param name="selected" value="system" />
  <jsp:param name="disabled" value="${inEditMode}" />
</jsp:include>
<div style="padding-bottom: 1em;"><c:import url="tabs.jsp">
  <c:param name="selected" value="network" />
  <c:param name="disabled" value="${inEditMode}" />
</c:import>
<div class="contents">
<div class="system-helpbox">${ub:i18n("SettingsNetworkSystemHelpBox")}</div>
<br />
<div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
<input:form name="server-settings-form" bean="agent" method="post" action="${saveUrl}">
  <table class="property-table">
    <tbody>
    
      <error:field-error field="externalUrl" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("ExternalURL")} <span class="required-text">*</span></span></td>
        <td align="left" width="20%">
          <ucf:text id="externalUrl" name="externalUrl" value="${server_settings.externalUrl}" enabled="${inEditMode}"/>
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsExternalUrlDesc")}</span></td>
      </tr>

      <error:field-error field="agentExternalUrl" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("AgentExternalURL")} <span class="required-text">*</span></span></td>
        <td align="left" width="20%">
          <ucf:text id="agentExternalUrl" name="agentExternalUrl" value="${server_settings.agentExternalUrl}" enabled="${inEditMode}"/>
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsAgentUrlDesc")}</span></td>
      </tr>
      
      <error:field-error field="rclLicensePath" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("RCLLicensePath")}</span></td>
        <td align="left" width="20%">
          <ucf:text id="rclLicensePath" name="rclLicensePath" value="${server_settings.rclLicensePath}" enabled="${inEditMode}"/>
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsRCLUrlDesc")}</span></td>
      </tr>

    </tbody>
  </table>

  <br/>
  <c:if test="${inEditMode}">
    <ucf:button name="saveServerSettings" label="${ub:i18n('Save')}"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" />
    <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}" />
  </c:if>
  <br/>
</input:form></div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp" />