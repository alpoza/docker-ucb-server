<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>

<%@ page import="com.urbancode.ubuild.web.currentactivity.CurrentActivityTasks" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="mainClass"          value="disabled"/>
    <c:set var="buildLifeHistoryClass" value="disabled"/>
    <c:set var="statusHistoryClass" value="disabled"/>
    <c:set var="labelSearchClass" value="disabled"/>
    <c:set var="buildRequestClass" value="disabled"/>
    <c:set var="miscJobsHistoryClass" value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'buildLifeHistory'}">
    <c:set var="buildLifeHistoryClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'statusHistory'}">
    <c:set var="statusHistoryClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'labelSearch'}">
    <c:set var="labelSearchClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'buildRequest'}">
    <c:set var="buildRequestClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'buildLifeActivityHistory'}">
    <c:set var="buildLifeActivityHistoryClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'miscJobsHistory'}">
    <c:set var="miscJobsHistoryClass" value="selected"/>
  </c:when>

</c:choose>

<%-- content --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('Search')}" />
  <jsp:param name="selected" value="search" />
  <jsp:param name="disabled" value="${param.disabled}" />
</jsp:include>

<div>

  <div class="tabManager" id="secondLevelTabs">
    <c:url var="buildLifeUrl" value="${SearchTasks.viewBuildLifeHistory}"/>
    <c:url var="buildRequestUrl" value="${SearchTasks.viewBuildRequests}"/>
    <c:url var="workflowUrl" value="${SearchTasks.viewBuildLifeActivityHistory}"/>
    <c:url var="statusHistoryUrl" value="${SearchTasks.viewStatusHistory}"/>
    <c:url var="labelSearchUrl" value="${SearchTasks.viewLabels}"/>
    <c:url var="miscJobsUrl" value="${SearchTasks.viewMiscJobs}"/>
    <ucf:link label="${ub:i18n('Build')}" href="${buildLifeUrl}" klass="${buildLifeHistoryClass} tab" enabled="${!param.disabled}"/>
    <ucf:link label="${ub:i18n('Request')}" href="${buildRequestUrl}" klass="${buildRequestClass} tab" enabled="${!param.disabled}"/>
    <ucf:link label="${ub:i18n('Process')}" href="${workflowUrl}" klass="${buildLifeActivityHistoryClass} tab" enabled="${!param.disabled}"/>
    <ucf:link label="${ub:i18n('Status')}" href="${statusHistoryUrl}" klass="${statusHistoryClass} tab" enabled="${!param.disabled}"/>
    <ucf:link label="${ub:i18n('Label')}" href="${labelSearchUrl}" klass="${labelSearchClass} tab" enabled="${!param.disabled}"/>
    <ucf:link label="${ub:i18n('MiscJobs')}" href="${miscJobsUrl}" klass="${miscJobsHistoryClass} tab" enabled="${!param.disabled}"/>
  </div>
  <div class="contents">

