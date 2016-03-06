<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.domain.agent.Agent" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@ taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@ taglib prefix="error" uri="error" %>
<%@ taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentSystemPropertyTasks" />

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.domain.agent.Agent" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="iconEditUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

<%-- HEADER --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEditAgent')}"/>
  <jsp:param name="selected" value="agents"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div style="padding-bottom: 1em;">

<%-- TABS --%>

  <jsp:include page="/WEB-INF/jsps/admin/agent/agentTabs.jsp">
     <jsp:param name="selected" value="SystemProperties"/>
     <jsp:param name="disabled" value="${inEditMode}"/>
  </jsp:include>

<%-- CONTENT--%>

  <div class="contents">
    <div class="system-helpbox">${ub:i18n("AgentSystemPropertiesSystemHelpBox")}</div>
    <br/>
    <%@include file="systemPropertyTable.inc"%>

    <br/><br/>

  </div>
</div>

<%-- FOOTER --%>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
