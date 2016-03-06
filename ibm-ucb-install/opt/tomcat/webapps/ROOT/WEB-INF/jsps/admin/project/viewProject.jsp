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
<%@page import="com.urbancode.ubuild.domain.agentfilter.*"%>
<%@page import="com.urbancode.ubuild.domain.jobconfig.JobConfig" %>
<%@page import="com.urbancode.ubuild.domain.project.Project"%>
<%@page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowComparator" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.commons.xml.XMLUtils" %>
<%@page import="java.util.Arrays"%>
<%@page import="javax.servlet.jsp.JspWriter"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="imsg" tagdir="/WEB-INF/tags/ui/admin/inactiveMessage" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/home/project/header.jsp">
  <jsp:param name="disabled" value="${inEditMode}"/>
  <jsp:param name="selected" value="configuration"/>
  <jsp:param name="noRefresh" value="true"/>
</jsp:include>

<div class="contents">
<c:choose>
  <c:when test="${project.active}">
    <div class="system-helpbox">
      ${ub:i18n("ProjectSystemHelpBox")}
    </div>
  </c:when>
  <c:otherwise>
    <imsg:inactiveMessage isActive="${project.active}" message="${ub:i18n('ProjectDeactivated')}"/>
  </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/jsps/admin/project/editProject.jsp"/>

<c:if test="${inViewMode}">
  <jsp:include page="/WEB-INF/jsps/admin/project/workflow/workflowList.jsp">
    <jsp:param name="enabled" value="${not empty project}"/>
  </jsp:include>
</c:if>
</div>

<jsp:include page="/WEB-INF/jsps/admin/project/projectFooter.jsp"/>
