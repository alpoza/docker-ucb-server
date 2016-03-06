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

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="viewAllUrl" value="${SearchTasks.viewBuildLifeActivityHistory}">
  <c:param name="projectId" value="${workflow.project.id}"/>
  <c:param name="workflowId" value="${workflow.id}"/>
  <c:param name="search" value="true"/>
</c:url>
<c:set var="viewAllUrl" value="${fn:escapeXml(viewAllUrl)}"/>

<div class="dashboard-contents">
  <div class="dashboard-contents-header">
    <div style="float: right; position: relative;"><a href="${viewAllUrl}">${ub:i18n("ViewAll")}</a></div>
    ${ub:i18n("RecentActivity")}
  </div>
  <div id="SecondaryProcessRecentActivityTable"></div>
</div>
