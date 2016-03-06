<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<auth:check persistent="${workflowTemplate}" var="canViewProcessTemplate" action="${UBuildAction.PROCESS_TEMPLATE_VIEW}"/>

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
  <c:set var="mainClass"        value="disabled ${mainClassError}"/>
  <c:set var="definitionClass"    value="disabled"/>
  <c:set var="propertiesClass"  value="disabled ${propertiesClassError}"/>
  <c:set var="artifactClass"    value="disabled"/>
  <c:set var="securityClass"    value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'main'}">
    <c:set var="mainClass" value="selected ${mainClassError}"/>
  </c:when>

  <c:when test="${param.selected == 'definition'}">
    <c:set var="definitionClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'properties'}">
    <c:set var="propertiesClass" value="selected ${propertiesClassError}"/>
  </c:when>

  <c:when test="${param.selected == 'artifacts'}">
    <c:set var="artifactClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'security'}">
    <c:set var="securityClass" value="selected"/>
  </c:when>
</c:choose>

<c:url var="mainTabUrl" value='${WorkflowTemplateTasks.viewWorkflowTemplate}'>
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:url var="definitionTabUrl" value='${WorkflowDefinitionTasks.viewWorkflowDefinition}'>
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:url var="propertiesTabUrl" value='${WorkflowTemplateTasks.viewPropertyList}'>
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:url var="artifactsTabUrl" value='${WorkflowTemplateTasks.viewArtifactConfigs}'>
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:url var="securityTabUrl" value='${ResourceTasks.viewResource}'>
  <c:param name="resourceId" value="${workflowTemplate.securityResourceId}"/>
</c:url>

<%-- CONTENT --%>

<c:choose>
    <c:when test="${workflowTemplate.originating}">
      <c:set var="title" value="${ub:i18nMessage('AdministrationProcessTemplateBuild', fn:escapeXml(workflowTemplate.name))}" />
    </c:when>
    <c:otherwise>
      <c:set var="title" value="${ub:i18nMessage('AdministrationProcessTemplateSecondary', fn:escapeXml(workflowTemplate.name))}" />
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${title}"/>
  <jsp:param name="selected" value="template" />
  <jsp:param name="disabled" value="${param.disabled}"/>
</jsp:include>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('Main')}" href="${mainTabUrl}" enabled="${!param.disabled}" klass="${mainClass} tab"/>
    <ucf:link label="${ub:i18n('Definition')}" href="${definitionTabUrl}" enabled="${!param.disabled && canViewProcessTemplate}" klass="${definitionClass} tab"/>
    <ucf:link label="${ub:i18n('Properties')}" href="${propertiesTabUrl}" enabled="${!param.disabled}" klass="${propertiesClass} tab"/>
    <c:if test="${workflowTemplate.originating}">
      <ucf:link label="${ub:i18n('Artifacts')}" href="${artifactsTabUrl}" enabled="${!param.disabled}" klass="${artifactClass} tab"/>
    </c:if>
    <ucf:link label="${ub:i18n('Security')}" href="#" onclick="showPopup('${ah3:escapeJs(securityTabUrl)}', 800, 600); return false;"
              enabled="${!param.disabled}" klass="${securityClass} tab"/>
  </div>

  <div class="contents">
