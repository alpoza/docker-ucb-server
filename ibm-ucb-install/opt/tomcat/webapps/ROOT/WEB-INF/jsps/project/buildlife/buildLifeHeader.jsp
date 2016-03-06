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
<%@ page import="com.urbancode.ubuild.runtime.scripting.helpers.*"%>
<%@ page import="com.urbancode.ubuild.domain.buildrequest.BuildRequest"%>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.buildlife.BuildLifeJobTrace" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.buildlife.BuildLifeJobTraceFactory" %>
<%@ page import="com.urbancode.ubuild.services.logging.*" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.*"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.BuildRequestTasks" %>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.Date"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />

<c:set var="profile" value="${buildLife.profile}"/>
<c:set var="project" value="${profile.project}"/>

<c:url var="imgUrl" value="/images"/>

<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
    <c:param name="projectId" value="${project.id}"/>
</c:url>
<c:set var="onDocumentLoad" scope="request">
  ${requestScope.onDocumentLoad}
</c:set>

<c:import url="/WEB-INF/snippets/react.jsp"></c:import>
<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title" value="${ub:i18n('Build')}" />
    <c:param name="selected" value="projects" />
    <c:param name="showYuiMenu" value="${param.showYuiMenu}"/>
</c:import>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'workflows'}">
    <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}"/>
  </c:when>

  <c:when test="${param.selected == 'reports'}">
    <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewReportList}"/>
  </c:when>

  <c:when test="${param.selected == 'artifacts'}">
    <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewArtifactList}"/>
  </c:when>

  <c:when test="${param.selected == 'dependencies'}">
    <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLifeDependencies}"/>
  </c:when>

  <c:when test="${param.selected == 'changes'}">
	  <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewChangeList}"/>
  </c:when>
  
  <c:when test="${param.selected == 'issues'}">
      <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewIssueList}"/>
  </c:when>
  
  <c:when test="${param.selected == 'tests'}">
    <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewTestList}"/>
  </c:when>
  
  <c:when test="${param.selected == 'coverage'}">
    <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewCoverageList}"/>
  </c:when>

  <c:when test="${param.selected == 'analytics'}">
      <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewAnalytics}"/>
  </c:when>

  <c:when test="${param.selected == 'notes'}">
    <c:set var="buildLifeUrl" value="${BuildLifeTasks.viewNotes}"/>
  </c:when>
</c:choose>
            
<div class="tabManager" id="secondLevelTabs">
    <c:import url="buildLifeTabs.jsp">
        <c:param name="selected" value="${param.selected}"/>
    </c:import>    
</div>

<c:if test="${showRefresh}">
    <c:import url="/WEB-INF/snippets/refresh.jsp"/>
</c:if>

<c:set var="prevBuildLife" value="${buildLife.prevBuildLife}"/>
<c:set var="nextBuildLife" value="${buildLife.nextBuildLife}"/>
<c:if test="${prevBuildLife != null || nextBuildLife != null}">
    <div style="text-align:right; padding-top: 10px; padding-right: 250px;">
        <c:if test="${prevBuildLife != null}">
            <c:url var="prevBuildLifeUrl" value="${buildLifeUrl}">
                <c:param name="buildLifeId" value="${prevBuildLife.id}"/>
            </c:url>
            <td><a href="${fn:escapeXml(prevBuildLifeUrl)}"><img alt="&lt;-" src="${fn:escapeXml(imgUrl)}/go-previous.png" border="0" /></a></td>
            <c:set var="prevBuildLifeName" value="${prevBuildLife.latestStampValue}"/>
            <c:if test="${fn:length(prevBuildLifeName) == 0}">
                <c:set var="prevBuildLifeName" value="${prevBuildLife.id}"/>
            </c:if>
            <a href="${fn:escapeXml(prevBuildLifeUrl)}">${fn:escapeXml(prevBuildLifeName)}</a>
        </c:if>
        <c:if test="${prevBuildLife != null && nextBuildLife != null}">
            &nbsp;|&nbsp;
        </c:if>
        <c:if test="${nextBuildLife != null}">
            <c:url var="nextBuildLifeUrl" value="${buildLifeUrl}">
                <c:param name="buildLifeId" value="${nextBuildLife.id}"/>
            </c:url>
            <c:set var="nextBuildLifeName" value="${nextBuildLife.latestStampValue}"/>
            <c:if test="${fn:length(nextBuildLifeName) == 0}">
                <c:set var="nextBuildLifeName" value="${nextBuildLife.id}"/>
            </c:if>
            <a href="${fn:escapeXml(nextBuildLifeUrl)}">${nextBuildLifeName}</a>
            <a href="${fn:escapeXml(nextBuildLifeUrl)}"><img alt="-&gt;" src="${fn:escapeXml(imgUrl)}/go-next.png" border="0"/></a>
        </c:if>
    </div>
</c:if>

<div class="contents">
  <br/>
