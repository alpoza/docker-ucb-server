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

<%@ page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@ page import="com.urbancode.ubuild.domain.project.*"%>
<%@ page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks"%>
<%@ page import="com.urbancode.ubuild.dashboard.StatusSummary"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.myactivity.MyActivityTasks" />

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="dashboardClass" value="disabled"/>
    <c:set var="changeSetClass" value="disabled"/>
    <c:set var="myActivityClass" value="disabled"/>
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

</c:choose>

<%-- content --%>
<c:if test="${not param.refreshDisabled}">
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
  <c:param name="title" value="${ub:i18n('Home')}" />
  <c:param name="disabled" value="${param.disabled}" />
  <c:param name="selected" value="projects" />
</c:import>
<div>
  <div class="tabManager" id="secondLevelTabs">
    <c:url var="dashboardUrl" value="${DashboardTasks.viewDashboard}"/>
    <%-- <c:url var="changeSetsUrl" value="${ChangeSetTasks.viewChangeSets}"/> --%>
    <c:url var="myActivityUrl" value="${MyActivityTasks.viewMyActivity}"/>

    <ucf:link label="${ub:i18n('Projects')}" href="${dashboardUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(dashboardClass)} tab"/>
    <%-- <ucf:link label="${ub:i18n('Changes')}" href="${changeSetsUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(changeSetClass)} tab"/> --%>
    <ucf:link label="${ub:i18n('MyActivity')}" href="${myActivityUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(myActivityClass)} tab"/>
  </div>
  <c:if test="${not param.refreshDisabled}">
    <c:import url="/WEB-INF/snippets/refresh.jsp"/>
  </c:if>
