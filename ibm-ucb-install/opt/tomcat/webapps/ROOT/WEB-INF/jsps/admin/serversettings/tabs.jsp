<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" useConversation="false"/>

<c:url var="networkUrl" value='${ServerSettingsTasks.viewNetworkServerSettings}'/>
<c:url var="securityUrl" value='${ServerSettingsTasks.viewSecurityServerSettings}'/>
<c:url var="miscUrl" value='${ServerSettingsTasks.viewMiscServerSettings}'/>
<c:url var="maintenanceUrl" value='${ServerSettingsTasks.viewMaintenance}'/>
<c:url var="logUrl" value='${ServerSettingsTasks.viewLog}'/>
<c:url var="errorUrl" value='${ServerSettingsTasks.viewError}'/>
<c:url var="viewsUrl" value='${ServerSettingsTasks.manageViews}'/>
<c:url var="diagnosticsUrl" value='${ServerSettingsTasks.viewDiagnostics}'/>

<c:choose>
  <c:when test="${param.selected == 'network'}">
    <c:set var="networkClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'security'}">
    <c:set var="securityClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'misc'}">
    <c:set var="miscClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'maintenance'}">
    <c:set var="maintenanceClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'log'}">
    <c:set var="logClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'error'}">
    <c:set var="errorClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'views'}">
    <c:set var="viewsClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'diagnostics'}">
    <c:set var="diagnosticsClass" value="selected"/>
  </c:when>
</c:choose>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link href="${networkUrl}" label="${ub:i18n('Network')}" enabled="${!param.disabled}" klass="${fn:escapeXml(networkClass)} tab"/>
  <ucf:link href="${securityUrl}" label="${ub:i18n('Security')}" enabled="${!param.disabled}" klass="${fn:escapeXml(securityClass)} tab"/>
  <ucf:link href="${miscUrl}" label="${ub:i18n('Misc')}" enabled="${!param.disabled}" klass="${fn:escapeXml(miscClass)} tab"/>
  <ucf:link href="${maintenanceUrl}" label="${ub:i18n('Maintenance')}" enabled="${!param.disabled}" klass="${fn:escapeXml(maintenanceClass)} tab"/>
  <ucf:link href="${logUrl}" label="${ub:i18n('Log')}" enabled="${!param.disabled}" klass="${fn:escapeXml(logClass)} tab"/>
  <ucf:link href="${errorUrl}" label="${ub:i18n('Error')}" enabled="${!param.disabled}" klass="${fn:escapeXml(errorClass)} tab"/>
  <ucf:link href="${viewsUrl}" label="${ub:i18n('Views')}" enabled="${!param.disabled}" klass="${fn:escapeXml(viewsClass)} tab"/>
  <ucf:link href="${diagnosticsUrl}" label="${ub:i18n('Diagnostics')}" enabled="${!param.disabled}" klass="${fn:escapeXml(diagnosticsClass)} tab"/>
</div>