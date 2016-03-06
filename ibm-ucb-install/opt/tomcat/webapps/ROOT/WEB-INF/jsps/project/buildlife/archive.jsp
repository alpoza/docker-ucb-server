<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose>
  <c:when test='${buildLife.archived}'>
    <c:url var="actionUrl" value="${BuildLifeTasks.unarchiveBuildLife}"/>
  </c:when>
  <c:otherwise>
    <c:url var="actionUrl" value="${BuildLifeTasks.archiveBuildLife}"/>
  </c:otherwise>
</c:choose>

<c:url var="dashboardUrl" value="${DashboardTasks.viewDashboard}"/>

<c:set var="profile" value="${buildLife.profile}"/>
<c:set var="project" value="${profile.project}"/>

<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
  <c:param name="projectId" value="${project.id}"/>
</c:url>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%-- CONTENT --%>

      <c:import url="buildLifeHeader.jsp">
          <c:param name="selected" value="archive"/>
      </c:import>

      <c:choose>
        <c:when test="${buildLife.inactive}">
          <p>${ub:i18n("BuildLifeArchiveInactiveError")}</p>
        </c:when>
        <c:when test="${!buildLife.archivePermission}">
          <p>${ub:i18n("BuildLifeArchivePermissionError")}</p>
        </c:when>
        <c:otherwise>
          <c:choose>
            <c:when test="${buildLife.archived}">
            <c:set var="workflow" value="${buildLife.originatingWorkflow.workflow}"/>
            <form action="${fn:escapeXml(actionUrl)}" method="post">
              
              <p>${ub:i18n("BuildLifeArchiveRebuildMessage")}</p><br/>
              
              <c:if test="${errorMsg != null}">
                <div class="error">${fn:escapeXml(errorMsg)}</div><br/>
              </c:if>
              
              <input type="hidden" name="${fn:escapeXml(WebConstants.BUILD_LIFE_ID)}" value="${fn:escapeXml(buildLife.id)}" />
              <ucf:button name="Rebuild" label="${ub:i18n('Rebuild')}"/>
            </form>
            </c:when>
            <c:otherwise>
            <form action="${fn:escapeXml(actionUrl)}" method="post">
                <p>${ub:i18n("BuildLifeArchiveMessage")}</p><br/>

                <c:if test="${errorMsg != null}">
                <div class="error">${fn:escapeXml(errorMsg)}</div><br/>
                </c:if>
                  
              <input type="hidden" name="${fn:escapeXml(WebConstants.BUILD_LIFE_ID)}" value="${fn:escapeXml(buildLife.id)}"/>
              <ucf:button name="Archive" label="${ub:i18n('Archive')}"/>
            </form>
            </c:otherwise>
          </c:choose>
        </c:otherwise>
      </c:choose>
  
<c:import url="buildLifeFooter.jsp"/>
