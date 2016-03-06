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

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<auth:checkAction var="canViewProjectTemplates" action="${UBuildAction.PROJECT_TEMPLATE_VIEW}"/>
<auth:checkAction var="canViewProcessTemplates" action="${UBuildAction.PROCESS_TEMPLATE_VIEW}"/>
<auth:checkAction var="canViewSourceTemplates" action="${UBuildAction.SOURCE_TEMPLATE_VIEW}"/>
<auth:checkAction var="canViewJobs" action="${UBuildAction.JOB_VIEW}"/>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
    <c:when test="${param.selected == 'Projects'}">
        <c:set var="projectClass" value="selected"/>
        <c:set var="title" value="${ub:i18n('ProjectTemplates')}"/>
    </c:when>
    <c:when test="${param.selected == 'Process'}">
        <c:set var="processClass" value="selected"/>
        <c:set var="title" value="${ub:i18n('ProcessTemplates')}"/>
    </c:when>
    <c:when test="${param.selected == 'Source'}">
        <c:set var="sourceClass" value="selected"/>
        <c:set var="title" value="${ub:i18n('SourceTemplates')}"/>
    </c:when>
    <c:when test="${param.selected == 'Job'}">
        <c:set var="jobClass" value="selected"/>
        <c:set var="title" value="${ub:i18n('Jobs')}"/>
    </c:when>
</c:choose>

<c:url var="projectsUrl" value="${ProjectTemplateTasks.viewList}"/>
<c:url var="processUrl" value="${WorkflowTemplateTasks.viewList}"/>
<c:url var="sourceUrl" value="${SourceConfigTemplateTasks.viewList}"/>
<c:url var="jobsUrl" value="${LibraryJobConfigTasks.viewList}"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="title" value='${ub:i18n("TemplatesWithColon")} ${title}'/>
    <jsp:param name="selected" value="template"/>
</jsp:include>
<c:remove var="title"/>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <c:if test="${canViewProjectTemplates}">
        <ucf:link label="${ub:i18n('Project')}" href="${fn:escapeXml(projectsUrl)}" klass="${fn:escapeXml(projectClass)} tab"/>
      </c:if>
      <c:if test="${canViewProcessTemplates}">
        <ucf:link label="${ub:i18n('Process')}" href="${fn:escapeXml(processUrl)}" klass="${fn:escapeXml(processClass)} tab"/>
      </c:if>
      <c:if test="${canViewSourceTemplates}">
        <ucf:link label="${ub:i18n('Source')}" href="${fn:escapeXml(sourceUrl)}" klass="${fn:escapeXml(sourceClass)} tab"/>
      </c:if>
      <c:if test="${canViewJobs}">
        <ucf:link label="${ub:i18n('Jobs')}" href="${fn:escapeXml(jobsUrl)}" klass="${fn:escapeXml(jobClass)} tab"/>
      </c:if>
    </div>
