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

<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.myactivity.MyActivityTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="buildLifeImg" value="/images/icon_workflow.gif"/>
<c:url var="requestImg" value="/images/icon_job.gif"/>
<c:url var="workflowImg" value="/images/icon_preflight_process.gif"/>

<input type="hidden" id="preflightActivityPageIndex" name="preflightActivityPageIndex" value="${preflightActivityPage.index}" />
<input type="hidden" id="preflightActivityPageDirection" name="preflightActivityPageDirection" value="" />
<script type="text/javascript">
  /* <![CDATA[ */
  function toPreflightActivityPage(page) {
    $("preflightActivityPageIndex").value = page; // is part of myActivityForm
    $("myActivityForm").submit();
  }
  /* ]]> */
</script>
<ucui:carousel id="preflightActivity" currentPage="${preflightActivityPage.index}" numberOfPages="${preflightActivityPage.count}" methodName="toPreflightActivityPage" />

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<br />
<br />
<br />

<table class="data-table">
  <thead>
    <tr>
      <th align="center" width="4%">&nbsp;</th>
      <th align="left" width="6%">${ub:i18n("ID")}</th>
      <th align="left">${ub:i18n("Project")}</th>
      <th align="left">${ub:i18n("Process")}</th>
      <th align="center">${ub:i18n("Status")}</th>
      <th align="center">${ub:i18n("Stamp")}</th>
      <th align="center" width="10%">${ub:i18n("Date")}</th>
    </tr>
  </thead>
  <tbody>
    <c:if test="${preflightActivityPage.count == 0}">
        <tr>
            <td colspan="6" align="left"><em>${ub:i18n("NoActivity")}</em></td>
        </tr>
    </c:if>

    <c:forEach var="activity" items="${preflightActivityPage.items}">
  
      <tr class="${eo.next}">
        <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
          <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${activity.buildLifeId}" />
        </c:url>
  
        <c:url var="workflowCaseUrl" value="${WorkflowCaseTasks.viewWorkflowCase}">
          <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${activity.workflowCaseId}" />
        </c:url>
  
        <c:url var="buildRequestUrl" value="${BuildRequestTasks.viewBuildRequest}">
          <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${activity.requestId}" />
        </c:url>
  
        <c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
          <c:param name="${WebConstants.PROJECT_ID}" value="${activity.projectId}" />
        </c:url>
  
        <c:url var="workflowUrl" value="${WorkflowTasks.viewDashboard}">
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${activity.workflowId}" />
        </c:url>
        
  
  
        <c:choose>
          <c:when test="${not empty activity.workflowStatus}">
            <c:set var="activityStatus" value="${activity.workflowStatus}"/>
          </c:when>
          <c:otherwise>
            <c:set var="activityStatus" value="${activity.requestStatus}"/>
          </c:otherwise>
        </c:choose>
  
        <c:choose>
          <c:when test="${activity.buildLifeId != null}">
            <td align="right" nowrap="nowrap" width="4%">
              <ucf:link href="${buildLifeUrl}" label="${activity.buildLifeId}" forceLabel="false" img="${buildLifeImg}" title="${ub:i18n('ViewBuildLife')}"/>
            </td>
            <td align="left" nowrap="nowrap" width="6%">
              <ucf:link href="${buildLifeUrl}" label="${activity.buildLifeId}" forceLabel="true" title="${ub:i18n('ViewBuildLife')}"/>
            </td>
          </c:when>
          <c:otherwise>
            <td align="right" nowrap="nowrap" width="4%">
              <ucf:link href="${buildRequestUrl}" label="${activity.requestId}" forceLabel="false" img="${requestImg}" title="${ub:i18n('ViewRequest')}"/>
            </td>
            <td align="left" nowrap="nowrap" width="6%">
              <ucf:link href="${buildRequestUrl}" label="${activity.requestId}" forceLabel="true" title="${ub:i18n('ViewRequest')}"/>
            </td>
          </c:otherwise>
        </c:choose>
        <td align="left">
          <ucf:link href="${projectUrl}" label="${activity.project}" title="${ub:i18n('ViewProjectDashboard')}"/>
        </td>
        <td align="left">
          <ucf:link href="${workflowUrl}" label="${activity.workflow}" title="${ub:i18n('ViewProcessDashboard')}"/>
        </td>
        <td align="center" nowrap="nowrap" style="background-color: <c:out value="${activityStatus.color}" default="#f6f4d8"/>;">
          <c:out value="${ub:i18n(activityStatus.name)}" default="${ub:i18n('Running')}"/>
        </td>
        <td align="center">
          <c:out value="${activity.stamp}" default="${ub:i18n('N/A')}"/>
        </td>
        <td align="center" nowrap="nowrap">
          <c:out value="${ah3:formatDate(longDateTimeFormat, activity.startDate)}" default="${ub:i18n('N/A')}"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>
