<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${buildLifeTaskClass}" />

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="mainClass" value="disabled"/>
    <c:set var="artifactsClass"   value="disabled"/>
    <c:set var="propertyClass"  value="disabled"/>
    <c:set var="statusClass"  value="disabled"/>
    <c:set var="useClass" value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'main'}">
    <c:set var="mainClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'artifacts'}">
    <c:set var="artifactsClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'properties'}">
    <c:set var="propertyClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'statusHistory'}">
    <c:set var="statusClass" value="selected"/>
  </c:when>
  
  <c:when test="${param.selected == 'use'}">
    <c:set var="useClass" value="selected"/>
  </c:when>
</c:choose>

<c:url var="mainTabUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}">
  <c:param name="codestationBuildLifeId" value="${codestationBuildLife.id}"/>
</c:url>

<c:url var="artifactListUrl"  value="${CodestationBuildLifeTasks.viewArtifacts}">
  <c:param name="codestationBuildLifeId" value="${codestationBuildLife.id}"/>
</c:url>

<c:url var="propertiesTabUrl" value="${CodestationBuildLifeTasks.viewPropertyList}">
  <c:param name="codestationBuildLifeId" value="${codestationBuildLife.id}"/>
</c:url>

<c:url var="statusHistoryUrl" value="${CodestationBuildLifeTasks.viewStatusHistory}">
  <c:param name="codestationBuildLifeId" value="${codestationBuildLife.id}"/>
</c:url>

<c:url var="useUrl" value="${CodestationBuildLifeTasks.viewUse}">
  <c:param name="codestationBuildLifeId" value="${codestationBuildLife.id}"/>
</c:url>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('Main')}" href="${mainTabUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(mainClass)} tab"/>
    <ucf:link label="${ub:i18n('Artifacts')}" href="${artifactListUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(artifactsClass)} tab"/>
    <ucf:link label="${ub:i18n('Properties')}" href="${propertiesTabUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(propertyClass)} tab"/>
    <ucf:link label="${ub:i18n('Statuses')}" href="${statusHistoryUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(statusClass)} tab"/>
    <ucf:link label="${ub:i18n('Dependencies')}" href="${useUrl}" enabled="${!param.disabled}" klass="${fn:escapeXml(useClass)} tab"/>
  </div>

  <div class="contents">