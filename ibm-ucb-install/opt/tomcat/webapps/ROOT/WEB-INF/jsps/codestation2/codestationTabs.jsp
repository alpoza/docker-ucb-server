<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.codestation2.domain.project.CodestationProject" %>
<%@page import="com.urbancode.ubuild.web.admin.codestation2.CodestationTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${taskClass}" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="mainClass"      value="disabled"/>
    <c:set var="propertyClass"  value="disabled"/>
    <c:set var="securityClass"  value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'main'}">
    <c:set var="mainClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'property'}">
    <c:set var="propertyClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'security'}">
    <c:set var="securityClass" value="selected"/>
  </c:when>
</c:choose>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="CodeStation: ${ub:i18n('Project')}"/>
  <jsp:param name="selected" value="codestation"/>
  <jsp:param name="disabled" value="${param.disabled}"/>
</jsp:include>

<%
   CodestationProject project = (CodestationProject) pageContext.findAttribute(WebConstants.CODESTATION_PROJECT);
%>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <c:url var="mainTabUrl" value='${CodestationTasks.viewCodestationProject}'>
      <c:param name="${WebConstants.CODESTATION_PROJECT_ID}" value="${codestationProject.id}"/>
    </c:url>
    <c:url var="propertiesTabUrl" value='${CodestationTasks.viewPropertyList}'>
      <c:param name="${WebConstants.CODESTATION_PROJECT_ID}" value="${codestationProject.id}"/>
    </c:url>
    <c:url var="securityUrl" value='${ResourceTasks.viewResource}'>
      <c:param name="${WebConstants.RESOURCE_ID}" value="${codestationProject.securityResourceId}"/>
    </c:url>
    <ucf:link label="${ub:i18n('Main')}" href="${mainTabUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(mainClass)} tab"/>
    <ucf:link label="${ub:i18n('Properties')}" href="${propertiesTabUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(propertyClass)} tab"/>
    <ucf:link label="${ub:i18n('Security')}" href="#" onclick="showPopup('${ah3:escapeJs(securityUrl)}', 800, 600); return false;"
        enabled="${!param.disabled}" klass="${fn:escapeXml(securityClass)} tab"/>
  </div>

  <div class="contents">