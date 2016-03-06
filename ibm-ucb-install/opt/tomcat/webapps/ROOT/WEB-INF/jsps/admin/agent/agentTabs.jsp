<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.ubuild.domain.agent.Agent" %>
<%@page import="com.urbancode.ubuild.web.admin.agent.AgentTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentPropertyTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentLockedPropertyTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentAnthillPropertyTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentSystemPropertyTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentEnvironmentTasks" />

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="mainClass"      value="disabled"/>
    <c:set var="agentPropertiesClass" value="disabled"/>
    <c:set var="lockedPropertiesClass" value="disabled"/>
    <c:set var="systemPropertiesClass" value="disabled"/>
    <c:set var="environmentClass" value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'Main'}">
    <c:set var="mainClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'LockedProperties'}">
    <c:set var="lockedPropertiesClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'AgentProperties'}">
    <c:set var="agentPropertiesClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'Environment'}">
    <c:set var="environmentClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'SystemProperties'}">
    <c:set var="systemPropertiesClass" value="selected"/>
  </c:when>
</c:choose>

<div class="tabManager" id="secondLevelTabs">
  <c:url var="mainTabUrl" value="${AgentTasks.viewAgent}">
    <c:param name="${WebConstants.AGENT_ID}" value="${agent.id}"/>
  </c:url>
  <c:url var="viewAgentPropertiesUrl"  value="${AgentPropertyTasks.viewAgentProperties}">
    <c:param name="${WebConstants.AGENT_ID}" value="${agent.id}"/>
  </c:url>
  <c:url var="viewLockedPropertiesUrl"  value="${AgentLockedPropertyTasks.viewLockedProperties}">
    <c:param name="${WebConstants.AGENT_ID}" value="${agent.id}"/>
  </c:url>
  <c:url var="viewSystemPropertiesUrl"  value="${AgentSystemPropertyTasks.viewSystemProperties}">
    <c:param name="${WebConstants.AGENT_ID}" value="${agent.id}"/>
  </c:url>
  <c:url var="viewEnvironmentUrl"  value="${AgentEnvironmentTasks.viewEnvironmentVariables}">
    <c:param name="${WebConstants.AGENT_ID}" value="${agent.id}"/>
  </c:url>
  <ucf:link label="${ub:i18n('Main')}" href="${mainTabUrl}" klass="${mainClass} tab" enabled="${!param.disabled}"/>
  <ucf:link label="${ub:i18n('Properties')}" href="${viewAgentPropertiesUrl}" klass="${agentPropertiesClass} tab" enabled="${!param.disabled}"/>
  <ucf:link label="${ub:i18n('Environment')}" href="${viewEnvironmentUrl}" klass="${environmentClass} tab" enabled="${!param.disabled}"/>
  <ucf:link label="${ub:i18n('LockedProperties')}" href="${viewLockedPropertiesUrl}" klass="${lockedPropertiesClass} tab" enabled="${!param.disabled}"/>
  <ucf:link label="${ub:i18n('SystemProperties')}" href="${viewSystemPropertiesUrl}" klass="${systemPropertiesClass} tab" enabled="${!param.disabled}"/>
</div>