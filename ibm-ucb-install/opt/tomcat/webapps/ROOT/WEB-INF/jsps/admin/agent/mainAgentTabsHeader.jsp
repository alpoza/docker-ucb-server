<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />

<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.broker.BrokerTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" />

<auth:checkAction var="canViewSystemTab" action="${UBuildAction.SYSTEM_TAB}"/>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
    <c:when test="${param.selected == 'Agent'}">
        <c:set var="agentClass" value="selected"/>
    </c:when>
    
    <c:when test="${param.selected == 'Environment'}">
        <c:set var="environmentClass" value="selected"/>
    </c:when>
    
    <c:when test="${param.selected == 'Broker'}">
      <c:set var="brokerClass" value="selected"/>
    </c:when>
    
    <c:when test="${param.selected == 'AgentCertificateManagement'}">
      <c:set var="AgentCertificateManagementClass" value="selected"/>
    </c:when>
</c:choose>

<c:url var="agentsUrl" value="${AgentTasks.viewList}"/>
<c:url var="environmentUrl" value="${AgentPoolTasks.viewAgentPoolList}"/>
<c:url var="brokerUrl" value="${BrokerTasks.viewBroker}"/>
<c:url var="agentCertificateManagementUrl" value="${BrokerTasks.viewAgentCertificateManagement}"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="title" value='${ub:i18n("AgentWithColon")} ${param.title}'/>
    <jsp:param name="selected" value="agents"/>
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('Agents')}" href="${agentsUrl}" klass="${fn:escapeXml(agentClass)} tab"/>
      <c:if test="${canViewSystemTab}">
        <ucf:link label="${ub:i18n('AgentPools')}" href="${environmentUrl}" klass="${fn:escapeXml(environmentClass)} tab"/>
        <ucf:link label="${ub:i18n('Broker')}" href="${brokerUrl}" klass="${fn:escapeXml(brokerClass)} tab"/>
        <ucf:link label="${ub:i18n('AgentCertificateManagement')}" href="${agentCertificateManagementUrl}" klass="${fn:escapeXml(AgentCertificateManagementClass)} tab"/>
      </c:if>
    </div>
