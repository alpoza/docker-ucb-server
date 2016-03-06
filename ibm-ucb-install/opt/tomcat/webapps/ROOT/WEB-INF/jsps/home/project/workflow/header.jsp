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

<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks id="AdminWorkflowTasks" class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" useConversation="false" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.changeset.ChangeSetTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.myactivity.MyActivityTasks" />

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="dashboardClass" value="disabled"/>
    <c:set var="changeSetClass" value="disabled"/>
    <c:set var="myActivityClass" value="disabled"/>
    <c:set var="tasksClass" value="disabled"/>
    <c:set var="configClass"         value="disabled"/>
    <c:set var="dependencyClass"   value="disabled"/>
    <c:set var="triggerClass"      value="disabled"/>
    <c:set var="securityClass"     value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>

  <c:when test="${param.selected == 'dashboard'}">
    <c:set var="dashboardClass" value="selected"/>
    <c:set var="showRefresh" value="false"/>
  </c:when>

  <c:when test="${param.selected == 'changeSet'}">
    <c:set var="changeSetClass" value="selected"/>
    <c:set var="showRefresh" value="true"/>
  </c:when>

  <c:when test="${param.selected == 'myActivity'}">
    <c:set var="myActivityClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'configuration'}">
    <c:set var="configClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'dependencies'}">
    <c:set var="dependencyClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'triggers'}">
    <c:set var="triggerClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'security'}">
    <c:set var="securityClass" value="selected"/>
  </c:when>
  <c:otherwise>
    <%-- WTF ---%>
  </c:otherwise>

</c:choose>

<c:url var="dashboardUrl" value="${WorkflowTasks.viewDashboard}">
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>

<c:url var="changeSetsUrl" value="${ChangeSetTasks.viewWorkflowChangeSets}">
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>

<c:url var="myActivityUrl" value="${MyActivityTasks.viewMyWorkflowActivity}">
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>

<c:if test="${!param.disabled}">
  <c:url var="configUrl" value="${AdminWorkflowTasks.viewWorkflow}">
    <c:if test="${workflow.id != null}"><c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/></c:if>
  </c:url>

  <c:url var="dependenciesUrl" value="${AdminWorkflowTasks.viewDependencies}">
    <c:if test="${workflow.id != null}"><c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/></c:if>
  </c:url>

  <c:url var="triggersUrl" value="${AdminWorkflowTasks.viewTriggers}">
    <c:if test="${workflow.id != null}"><c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/></c:if>
  </c:url>

  <c:url var="securityUrl" value='${ResourceTasks.viewResource}'>
    <c:param name="${WebConstants.RESOURCE_ID}" value="${workflow.securityResourceId}"/>
  </c:url>
</c:if>

<%-- CONTENT --%>
<c:if test="${showRefresh}">
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
  <c:param name="title" value="${workflow.name}" />
  <c:param name="disabled" value="${param.disabled}" />
  <c:param name="selected" value="projects" />
  <c:param name="doNotFocus" value="true" />
</c:import>
<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('Main')}" href="${dashboardUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(dashboardClass)} tab"/>
  <c:if test="${workflow.buildProfile!=null}">
    <ucf:link label="${ub:i18n('Changes')}" href="${changeSetsUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(changeSetClass)} tab"/>
    <ucf:link label="${ub:i18n('MyActivity')}" href="${myActivityUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(myActivityClass)} tab"/>
  </c:if>
  <ucf:link label="${ub:i18n('Configuration')}" href="${configUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(configClass)} tab"/>
  <c:if test="${not empty workflow and not workflow.new}">
    <c:if test="${workflow.buildProfile!=null}">
      <ucf:link label="${ub:i18n('Dependencies')}" href="${dependenciesUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(dependencyClass)} tab"/>
    </c:if>
    <c:if test="${not param.disabledForPreflight}">
        <ucf:link label="${ub:i18n('Triggers')}" href="${triggersUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(triggerClass)} tab"/>
    </c:if>
    <ucf:link label="${ub:i18n('Security')}" href="#" onclick="showPopup('${ah3:escapeJs(securityUrl)}', 800, 600); return false;" enabled="${!param.disabled}" klass="${securityClass} tab"/>
  </c:if>
</div>

<c:if test="${showRefresh}">
  <c:import url="/WEB-INF/snippets/refresh.jsp"/>
</c:if>
