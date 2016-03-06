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
<%@page import="com.urbancode.ubuild.domain.agentpool.FixedAgentPool" %>
<%@page import="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" useConversation="false"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'main'}">
    <c:set var="mainClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'security'}">
    <c:set var="securityClass" value="selected"/>
  </c:when>
</c:choose>

<div class="tabManager" id="secondLevelTabs">
  <c:url var="mainTabUrl" value='${AgentPoolTasks.viewFixedAgentPool}'>
      <c:param name="${WebConstants.AGENT_POOL_ID}" value="${agentPool.id}"/>
  </c:url>
  <c:url var="securityTabUrl" value='${ResourceTasks.viewResource}'>
    <c:param name="${WebConstants.RESOURCE_ID}" value="${agentPool.securityResourceId}"/>
  </c:url>
  
  <ucf:link label="${ub:i18n('Main')}" href="${mainTabUrl}" enabled="${false}" klass="${mainClass} tab"/>
  <ucf:link label="${ub:i18n('Security')}" href="#" onclick="showPopup('${ah3:escapeJs(securityTabUrl)}', 800, 600); return false;" enabled="${!param.disabled}" klass="${securityClass} tab"/>
</div>

<br/>