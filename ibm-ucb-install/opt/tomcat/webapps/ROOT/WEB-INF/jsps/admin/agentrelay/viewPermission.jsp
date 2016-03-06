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
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.commons.xml.*"%>
<%@page import="java.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentrelay.AgentRelayTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="submitUrl" value="${AgentRelayTasks.savePermission}" scope="request">
  <c:param name="permissionInline" value="true"/>
  <c:param name="${WebConstants.AGENT_RELAY_ID}" value="${agentRelay.id}"/>
</c:url>

<c:url var="cancelUrl" value="${AgentRelayTasks.cancelPermission}" scope="request">
  <c:param name="permissionInline" value="true"/>
  <c:param name="${WebConstants.AGENT_RELAY_ID}" value="${agentRelay.id}"/>
</c:url>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/jsps/admin/security/permissionForm.jsp"/>
