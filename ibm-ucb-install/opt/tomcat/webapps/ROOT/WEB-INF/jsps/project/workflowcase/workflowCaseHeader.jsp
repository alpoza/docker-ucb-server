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
<%@ page import="com.urbancode.ubuild.runtime.scripting.helpers.*" %>
<%@ page import="com.urbancode.ubuild.domain.buildrequest.BuildRequest" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.buildlife.BuildLifeJobTrace" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.buildlife.BuildLifeJobTraceFactory" %>
<%@ page import="com.urbancode.ubuild.services.logging.*" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.*" %>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks" %>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks" %>
<%@ page import="com.urbancode.ubuild.web.project.BuildRequestTasks" %>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="java.util.Date" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks"/>

<c:url var="dashboardUrl" value="${DashboardTasks.viewDashboard}"/>

<c:set var="project" value="${workflowCase.workflow.project}"/>

<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
  <c:param name="projectId" value="${project.id}"/>
</c:url>

<c:url var="workflowUrl" value="${WorkflowTasks.viewDashboard}">
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>
<%
    boolean doAutoRefresh = false;
    WorkflowCase workflowCase = (WorkflowCase) request.getAttribute(WebConstants.WORKFLOW_CASE);
    if (WorkflowStatusEnum.RUNNING.equals(workflowCase.getStatus()) ||
        WorkflowStatusEnum.QUEUED.equals(workflowCase.getStatus()) ||
        WorkflowStatusEnum.WAITING_ON_AGENTS.equals(workflowCase.getStatus())) {
        pageContext.setAttribute("showRefresh", true);
    }
    else {
        pageContext.setAttribute("showRefresh", false);
    }
%>

<%-- CONTENT --%>
<c:if test="${showRefresh}">
  <c:import var="refreshJs" url="/WEB-INF/snippets/refreshJs.jsp">
    <c:param name="refresh" value="30" />
    <c:param name="sessionKey" value="dashboard-refresh" />
  </c:import>
</c:if>
<c:set var="onDocumentLoad" value="${refreshJs}" scope="request"/>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="Operation"/>
  <jsp:param name="selected" value="projects"/>
</jsp:include>

<div>
  <table border="0" style=" width: 100%;">
    <tbody>
      <tr>
        <td align="left">

          <div class="tabManager" id="secondLevelTabs">
            <ucf:link label="${ub:i18n('Main')}" href="" enabled="${false}" klass="selected tab"/>
          </div>
          
          <c:if test="${showRefresh}">
            <c:import url="/WEB-INF/snippets/refresh.jsp"/>
          </c:if>

        </td>
      </tr>
      <tr>
        <td>
          <div class="contents">
