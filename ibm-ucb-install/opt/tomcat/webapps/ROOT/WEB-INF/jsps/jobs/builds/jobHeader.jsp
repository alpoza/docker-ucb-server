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

<%@ page import="com.urbancode.ubuild.domain.jobtrace.JobTrace" %>
<%@ page import="com.urbancode.ubuild.services.jobs.JobStatusEnum" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%
    JobTrace jobTrace = (JobTrace) pageContext.findAttribute(WebConstants.JOB_TRACE);
    if (JobStatusEnum.RUNNING.equals(jobTrace.getStatus()) ||
        JobStatusEnum.QUEUED.equals(jobTrace.getStatus()) ||
        JobStatusEnum.WAITING_ON_AGENTS.equals(jobTrace.getStatus()) ||
        JobStatusEnum.ABORTING.equals(jobTrace.getStatus()) ||
        JobStatusEnum.RESUMING.equals(jobTrace.getStatus())) {
        pageContext.setAttribute("showRefresh", true);
    }
    else {
        pageContext.setAttribute("showRefresh", false);
    }
%>
<%-- CONTENT --%>
<c:if test="${showRefresh}">
  <c:import var="refreshJs" url="/WEB-INF/snippets/refreshJs.jsp">
    <c:param name="refresh" value="30" />
    <c:param name="refreshDefault" value="true" />
    <c:param name="sessionKey" value="jobtrace-refresh" />
  </c:import>
</c:if>
<c:set var="onDocumentLoad" value="${refreshJs}" scope="request"/>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('Job')}" />
  <jsp:param name="selected" value="projects" />
</jsp:include>

<div style="">

<div class="tabManager" id="secondLevelTabs">
  <c:import url="/WEB-INF/jsps/jobs/builds/jobTabs.jsp">
     <c:param name="selected" value="${param.selected}"/>
  </c:import>
</div>
<c:if test="${showRefresh}">
  <c:import url="/WEB-INF/snippets/refresh.jsp"/>
</c:if>
<div class="contents">
