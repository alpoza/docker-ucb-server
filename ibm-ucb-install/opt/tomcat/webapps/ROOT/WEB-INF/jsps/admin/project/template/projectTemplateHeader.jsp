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

<%@page import="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.domain.project.Project"%>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
  <c:set var="mainClass"            value="disabled ${mainClassError}"/>
  <c:set var="buildPreProcessClass" value = "disabled ${buildPreProcessError}"/>
  <c:set var="propertiesClass"      value="disabled ${propertiesClassError}"/>
  <c:set var="securityClass"        value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'main'}">
    <c:set var="mainClass" value="selected ${mainClassError}"/>
  </c:when>

  <c:when test="${param.selected == 'buildpreprocess'}">
    <c:set var="buildPreProcessClass" value="selected ${buildPreProcessError}"/>
  </c:when>

  <c:when test="${param.selected == 'properties'}">
    <c:set var="propertiesClass" value="selected ${propertiesClassError}"/>
  </c:when>

  <c:when test="${param.selected == 'security'}">
    <c:set var="securityClass" value="selected"/>
  </c:when>
</c:choose>

<c:url var="mainTabUrl" value='${ProjectTemplateTasks.viewProjectTemplate}'>
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>
<c:url var="buildPreProcessTabUrl" value='${ProjectTemplateTasks.viewBuildPreProcess}'>
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>
<c:url var="propertiesTabUrl" value='${ProjectTemplateTasks.viewPropertyList}'>
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>
<c:url var="securityTabUrl" value='${ResourceTasks.viewResource}'>
  <c:param name="resourceId" value="${projectTemplate.securityResourceId}"/>
</c:url>

<%-- CONTENT --%>


<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18nMessage('AdministrationProjectTemplate', fn:escapeXml(projectTemplate.name))}" />
  <jsp:param name="selected" value="template" />
  <jsp:param name="disabled" value="${param.disabled}"/>
</jsp:include>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('Main')}" href="${mainTabUrl}" enabled="${!param.disabled}" klass="${mainClass} tab"/>
    <ucf:link label="${ub:i18n('BuildPreProcessing')}" href="${buildPreProcessTabUrl}" enabled="${!param.disabled}" klass="${buildPreProcessClass} tab"/>
    <ucf:link label="${ub:i18n('Properties')}" href="${propertiesTabUrl}" enabled="${!param.disabled}" klass="${propertiesClass} tab"/>
    <ucf:link label="${ub:i18n('Security')}" href="#" onclick="showPopup('${ah3:escapeJs(securityTabUrl)}', 800, 600); return false;"
        enabled="${!param.disabled}" klass="${securityClass} tab"/>
  </div>

  <div class="contents">
