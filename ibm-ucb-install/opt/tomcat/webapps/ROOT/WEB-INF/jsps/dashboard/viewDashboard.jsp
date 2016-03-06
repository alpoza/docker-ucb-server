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

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.NewDashboardTasks"/>
<c:url var="basePluginContentUrl" value="${NewDashboardTasks.viewPluginContent}"/>

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="selected" value="dashboard" />
</c:import>

<div class="tabManager" id="secondLevelTabs">
  <c:forEach var="availableDashboard" items="${dashboards}">
    <c:url var="availableDashboardUrl" value="${NewDashboardTasks.viewDashboard}">
      <c:param name="dashboardId" value="${availableDashboard.id}"/>
    </c:url>
    <c:set var="tabClass" value="disabled"/>
    <c:if test="${dashboard eq availableDashboard}">
      <c:set var="tabClass" value="current"/>
    </c:if>
    <ucf:link label="${availableDashboard.name}" href="${availableDashboardUrl}" klass="${tabClass} tab"/>
  </c:forEach>
</div>

<br/>

<div style="text-align: right; padding-right: 5%;">
  <c:url var="editViewUrl" value="${NewDashboardTasks.editView}">
    <c:param name="dashboardId" value="${dashboard.id}"/>
  </c:url>
  <ucf:button name="EditView" label="${ub:i18n('EditView')}" href="${editViewUrl}"/>
</div>

<div class="dashboard clearfix">
  <c:forEach var="dashboardColumn" items="${dashboard.columns}">
    <div class="dashboard-column">
      <c:forEach var="dashboardWidget" items="${dashboardColumn.widgets}">
        <div class="dashboard-widget-header">
          <div class="dashboard-widget-header-content">${dashboardWidget.name}</div>
        </div>
        <c:url var="pluginContentUrl" value="${basePluginContentUrl}">
          <c:param name="dashboardWidgetId" value="${dashboardWidget.id}"/>
        </c:url>
        <iframe class="dashboard-widget" src="${pluginContentUrl}">
        </iframe>
      </c:forEach>
    </div>
  </c:forEach>
</div>

<c:import url="/WEB-INF/snippets/footer.jsp"/>
