<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.ubuild.domain.buildlife.BuildLife"%>
<%@page import="com.urbancode.ubuild.reporting.coverage.CoverageReporting"%>
<%@page import="com.urbancode.ubuild.reporting.analytic.SourceAnalyticReporting" %>
<%@page import="com.urbancode.ubuild.reporting.sourcechange.SourceChangeReportingFactory" %>
<%@page import="com.urbancode.ubuild.domain.workflow.*"%>
<%@page import="com.urbancode.ubuild.reporting.issue.IssueReportingFactory"%>
<%@page import="com.urbancode.ubuild.reporting.test.TestReporting"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />

<c:if test="${param.disabled == 'true'}">
  <%-- If disabled, the default class is 'disabled' --%>
  <c:set var="workflowsClass" value="disabled" />
  <c:set var="reportsClass" value="disabled" />
  <c:set var="artifactsClass" value="disabled" />
  <c:set var="dependencyClass" value="disabled" />
  <c:set var="changeClass" value="disabled" />
  <c:set var="issueClass" value="disabled" />
  <c:set var="testClass" value="disabled" />
  <c:set var="coverageClass" value="disabled" />
  <c:set var="analyticsClass" value="disabled" />
  <c:set var="runWorkflowClass" value="disabled" />
  <c:set var="notesClass" value="disabled" />
</c:if>

<c:choose>
  <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'workflows'}">
    <c:set var="workflowsClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'reports'}">
    <c:set var="reportsClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'artifacts'}">
    <c:set var="artifactsClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'dependencies'}">
    <c:set var="dependencyClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'changes'}">
    <c:set var="changeClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'issues'}">
    <c:set var="issueClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'tests'}">
    <c:set var="testClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'coverage'}">
    <c:set var="coverageClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'analytics'}">
    <c:set var="analyticsClass" value="selected" />
  </c:when>

  <c:when test="${param.selected == 'notes'}">
    <c:set var="notesClass" value="selected" />
  </c:when>
</c:choose>

<c:url var="workflowListUrl" value="${BuildLifeTasks.viewBuildLife}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="reportListUrl" value="${BuildLifeTasks.viewReportList}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="artifactListUrl" value="${BuildLifeTasks.viewArtifactList}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="dependenciesUrl" value="${BuildLifeTasks.viewBuildLifeDependencies}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="changesUrl" value="${BuildLifeTasks.viewChangeList}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="issuesUrl" value="${BuildLifeTasks.viewIssueList}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="testsUrl" value="${BuildLifeTasks.viewTestList}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="coverageUrl" value="${BuildLifeTasks.viewCoverageList}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="analyticsUrl" value="${BuildLifeTasks.viewAnalytics}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<c:url var="notesUrl" value="${BuildLifeTasks.viewNotes}">
  <c:param name="buildLifeId" value="${param.buildLifeId}" />
</c:url>

<%
  BuildLife buildLife = (BuildLife) request.getAttribute(WebConstants.BUILD_LIFE);
  String buildLifeId = String.valueOf(buildLife.getId());
  List<String> buildLifeIds = new ArrayList<String>();
  buildLifeIds.add(buildLifeId);
  
  pageContext.setAttribute("issueCount", IssueReportingFactory.getInstance().countIssuesForBuildLifeIds(buildLifeIds));
  pageContext.setAttribute("testReportCount", new TestReporting().getNumberOfReportsOnBuildLife(buildLife));
  pageContext.setAttribute("coverageReportCount", new CoverageReporting().getNumberOfReportsOnBuildLife(buildLife));
  pageContext.setAttribute("analyticsReportCount", new SourceAnalyticReporting().getReportCountOnBuildLife(buildLife));
  pageContext.setAttribute("changesCount", SourceChangeReportingFactory.getInstance().countSourceChangesForBuildLife(buildLife));
%>

<ucf:link label="${ub:i18n('Main')}" href="${workflowListUrl}" klass="${fn:escapeXml(workflowsClass)} tab"/>
<ucf:link label="${ub:i18n('Reports')}" href="${reportListUrl}" klass="${fn:escapeXml(reportsClass)} tab"/>
<c:if test="${!buildLife.inactive}">
  <ucf:link label="${ub:i18n('Artifacts')}" href="${artifactListUrl}" klass="${fn:escapeXml(artifactsClass)} tab"/>
</c:if>

<c:set var="dependenciesName" value="${ub:i18n('Dependencies')}"/>
<c:if test="${not empty buildLife.dependencyBuildLifeArray}">
  <c:set var="dependenciesName" value="${dependenciesName} (${fn:length(buildLife.dependencyBuildLifeArray)})"/>
</c:if>
<c:set var="changesName" value="${ub:i18n('Changes')}"/>
<c:if test="${changesCount gt 0}">
  <c:set var="changesName" value="${changesName} (${changesCount})"/>
</c:if>
<c:set var="issuesName" value="${ub:i18n('Issues')}"/>
<c:if test="${issueCount gt 0}">
  <c:set var="issuesName" value="${issuesName} (${issueCount})"/>
</c:if>
<c:set var="testsName" value="${ub:i18n('Tests')}"/>
<c:if test="${testReportCount gt 0}">
  <c:set var="testsName" value="${testsName} (${testReportCount})"/>
</c:if>
<c:set var="coverageName" value="${ub:i18n('Coverage')}"/>
<c:if test="${coverageReportCount gt 0}">
  <c:set var="coverageName" value="${coverageName} (${coverageReportCount})"/>
</c:if>
<c:set var="analyticsName" value="${ub:i18n('Analytics')}"/>
<c:if test="${analyticsReportCount gt 0}">
  <c:set var="analyticsName" value="${analyticsName} (${analyticsReportCount})"/>
</c:if>
<c:set var="notesName" value="${ub:i18n('Notes')}"/>
<c:if test="${not empty buildLife.notes}">
  <c:set var="notesName" value="${notesName} (${fn:length(buildLife.notes)})"/>
</c:if>

<ucf:link label="${dependenciesName}" href="${dependenciesUrl}" klass="${dependencyClass} tab"/>
<ucf:link label="${changesName}" href="${changesUrl}" klass="${changeClass} tab"/>
<ucf:link label="${issuesName}" href="${issuesUrl}" klass="${issueClass} tab"/>
<ucf:link label="${testsName}" href="${testsUrl}" klass="${testClass} tab"/>
<ucf:link label="${coverageName}" href="${coverageUrl}" klass="${coverageClass} tab"/>
<ucf:link label="${analyticsName}" href="${analyticsUrl}" klass="${analyticsClass} tab"/>
<ucf:link label="${notesName}" href="${notesUrl}" klass="${notesClass} tab"/>
