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
<%@ page import="com.urbancode.ubuild.web.currentactivity.CurrentActivityTasks" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.currentactivity.CurrentActivityTasks" />

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="activityClass"   value="disabled"/>
    <c:set var="agentsClass"     value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'activity'}">
    <c:set var="activityClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'agents'}">
    <c:set var="agentsClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'lockableResources'}">
    <c:set var="lockableResourcesClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'schedules'}">
    <c:set var="schedulesClass" value="selected"/>
  </c:when>
</c:choose>

<%-- content --%>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('CurrentActivity')}"/>
  <c:param name="selected" value="currentActivity"/>
  <c:param name="disabled" value="${param.disabled}" />
</c:import>

<div>

<div class="tabManager" id="secondLevelTabs">
  <c:url var="activityUrl" value="${CurrentActivityTasks.viewCurrentActivity}"/>
  <c:url var="agentsUrl" value="${CurrentActivityTasks.viewAgents}"/>
  <c:url var="lockableResourcesUrl" value="${CurrentActivityTasks.viewLockableResources}"/>
  <c:url var="schedulesUrl" value="${CurrentActivityTasks.viewSchedules}"/>
  <ucf:link label="${ub:i18n('Activity')}" href="${activityUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(activityClass)} tab"/>
  <ucf:link label="${ub:i18n('Agents')}" href="${agentsUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(agentsClass)} tab"/>
  <ucf:link label="${ub:i18n('LockableResources')}" href="${lockableResourcesUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(lockableResourcesClass)} tab"/>
  <ucf:link label="${ub:i18n('Schedules')}" href="${schedulesUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(schedulesClass)} tab"/>
</div>
<div class="contents">
