<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>

<%@page import="com.urbancode.ubuild.web.admin.project.ProjectTasks" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.changeset.ChangeSetTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.myactivity.MyActivityTasks" />

<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<auth:check persistent="${WebConstants.PROJECT}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}" resultWhenNotFound="true"/>

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="dashboardClass" value="disabled"/>
    <c:set var="changeSetClass" value="disabled"/>
    <c:set var="myActivityClass" value="disabled"/>
    <%-- <c:set var="tasksClass" value="disabled"/> --%>
    <c:set var="configClass" value="disabled"/>
    <c:set var="quietPeriodClass" value="disabled"/>
    <c:set var="auditClass" value="disabled"/>
    <c:set var="securityClass" value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
    <c:when test="${param.selected == 'dashboard'}">
        <c:set var="dashboardClass" value="selected"/>
    </c:when>

    <c:when test="${param.selected == 'changeSet'}">
        <c:set var="changeSetClass" value="selected"/>
    </c:when>

    <c:when test="${param.selected == 'myActivity'}">
        <c:set var="myActivityClass" value="selected"/>
    </c:when>

    <c:when test="${param.selected == 'configuration'}">
        <c:set var="configurationClass" value="selected"/>
    </c:when>

    <c:when test="${param.selected == 'audit'}">
        <c:set var="auditClass" value="selected"/>
    </c:when>

    <c:when test="${param.selected == 'security'}">
        <c:set var="securityClass" value="selected"/>
    </c:when>

    <c:otherwise>
        <%-- WTF ---%>
    </c:otherwise>

</c:choose>

<c:url var="dashboardUrl" value="${ProjectTasks.viewDashboard}">
    <c:param name="projectId" value="${project.id}"/>
</c:url>

<c:url var="changeSetsUrl" value="${ChangeSetTasks.viewProjectChangeSets}">
    <c:param name="projectId" value="${project.id}"/>
</c:url>

<c:url var="myActivityUrl" value="${MyActivityTasks.viewMyProjectActivity}">
    <c:param name="projectId" value="${project.id}"/>
</c:url>

<c:url var="configTabUrl" value='${ProjectTasks.viewProject}'>
  <c:param name="projectId" value="${project.id}"/>
</c:url>

<c:if test="${canEdit}">
  <c:url var="auditTabUrl" value='${ProjectTasks.viewAudit}'>
    <c:param name="projectId" value="${project.id}"/>
  </c:url>
</c:if>

<c:url var="securityTabUrl" value='${ResourceTasks.viewResource}'>
  <c:param name="resourceId" value="${project.securityResourceId}"/>
</c:url>

<%-- CONTENT --%>
<c:if test="${empty param.noRefresh}">
  <c:import var="refreshJs" url="/WEB-INF/snippets/refreshJs.jsp">
    <c:param name="refresh" value="30" />
    <c:param name="sessionKey" value="dashboard-refresh" />
  </c:import>
</c:if>
<c:set var="onDocumentLoad" scope="request">
  ${requestScope.onDocumentLoad}
  ${refreshJs}
</c:set>
<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${project.name}" />
  <c:param name="disabled" value="${param.disabled}" />
  <c:param name="selected" value="projects" />
</c:import>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('Main')}" href="${dashboardUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(dashboardClass)} tab"/>
  <ucf:link label="${ub:i18n('Changes')}" href="${changeSetsUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(changeSetClass)} tab"/>
  <ucf:link label="${ub:i18n('MyActivity')}" href="${myActivityUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(myActivityClass)} tab"/>
  <ucf:link label="${ub:i18n('Configuration')}" href="${configTabUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(configurationClass)} tab"/>
  <c:if test="${canEdit}">
    <ucf:link label="${ub:i18n('Auditing')}" href="${auditTabUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(auditClass)} tab"/>
  </c:if>
  <ucf:link label="${ub:i18n('Security')}" href="#" onclick="showPopup('${ah3:escapeJs(securityTabUrl)}', 800, 600); return false;" enabled="${!param.disabled}" klass="${fn:escapeXml(securityClass)} tab"/>
</div>
<c:if test="${empty param.noRefresh}">
  <c:import url="/WEB-INF/snippets/refresh.jsp"/>
</c:if>
