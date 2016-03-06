<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.dashboard.StatusSummary"%>
<%@ page import="com.urbancode.ubuild.domain.status.Status"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Enumeration"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%
StatusSummary[] statusSummaries = (StatusSummary[]) request.getAttribute(ProjectTasks.KEY_STATUS_SUMMARIES);
boolean atLeastOneStatusApplied = false;
pageContext.setAttribute("eo", new EvenOdd());
%>
  <c:url var="viewAllUrl2" value="${SearchTasks.viewStatusHistory}">
    <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
    <c:param name="search" value="true"/>
  </c:url>

  <div class="dashboard-contents">
      <div class="dashboard-contents-header">
        <div style="float: right; position: relative;"><a href="${fn:escapeXml(viewAllUrl2)}">${ub:i18n("ViewAll")}</a></div>
        ${ub:i18n("ProjectLatestStatusesLatestStatusAssignments")}
      </div>

      <div id="latestStatusTable"></div>
  </div>
