<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLife" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="profile" value="${buildLife.profile}"/>
<c:set var="project" value="${profile.project}"/>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<c:url var="dashboardUrl" value="${DashboardTasks.viewDashboard}"/>
<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
  <c:param name="projectId" value="${project.id}"/>
</c:url>

<c:import url="buildLifeHeader.jsp">
  <c:param name="selected" value="reports"/>
</c:import>

<br/>
<h3>${ub:i18n("PublishedReports")}</h3>
<div>
  <table class="data-table">
    <thead>
      <tr class="">
        <th scope="col" width="35%" style="text-align: left;">${ub:i18n("Report")}</th>
        <th scope="col" width="35%" style="text-align: left;">${ub:i18n("Process")}</th>
        <th scope="col" width="20%">${ub:i18n("Agent")}</th>
        <th scope="col" width="10%">${ub:i18n("Job")}</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${fn:length(key_project_artifacts) == 0}">
          <tr>
            <td colspan="4" style="text-align: left;">${ub:i18n("NoReportsOnBuildLife")}</td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="artifactSummary" items="${key_project_artifacts}">
            <tr>
              <c:url var="artifactUrl" value="${artifactSummary.artifactUrl}"/>
              <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
               <c:param name="buildLifeId" value="${buildLife.id}"/>
              </c:url>
              <c:url var="buildSummaryUrl" value="${JobTasks.viewBuildSummary}">
                <c:param name="job_trace_id" value="${artifactSummary.jobTraceId}"/>
              </c:url>
              <td nowrap="nowrap"><a href="${fn:escapeXml(artifactUrl)}">${fn:escapeXml(artifactSummary.artifactName)}</a></td>
              <td><a href="${fn:escapeXml(buildLifeUrl)}#workflowCase${fn:escapeXml(artifactSummary.workflowCaseId)}"
              >${fn:escapeXml(artifactSummary.workflowName)} (${fn:escapeXml(artifactSummary.workflowCaseId)})</a></td>
              <td style="text-align: center;">${fn:escapeXml(artifactSummary.agentName)}</td>
              <td style="text-align: center;"><a href="${fn:escapeXml(buildSummaryUrl)}">${fn:escapeXml(artifactSummary.jobTraceId)}</a></td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>
<br/>
<br/>
<h3>${ub:i18n("PublishedLinks")}</h3>
<div>
  <table class="data-table">
    <thead>
      <tr class="">
        <th scope="col" width="25%" style="text-align: left;">${ub:i18n("Link")}</th>
        <th scope="col" width="75%" style="text-align: left;">${ub:i18n("Description")}</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${fn:length(buildLife.links) == 0}">
          <tr>
            <td colspan="2" align="left">${ub:i18n("NoLinksOnBuildLife")}</td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="buildLifeLink" items="${buildLife.links}">
            <tr>
              <c:url var="linkUrl" value="${buildLifeLink.url}"/>
              <td align="left" nowrap="nowrap"><a href="${fn:escapeXml(linkUrl)}" target="_blank">${fn:escapeXml(buildLifeLink.name)}</a></td>
              <td align="left">${fn:escapeXml(buildLifeLink.description)}</td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>
<br/>
<br/>

<br/>
<c:import url="buildLifeFooter.jsp"/>
