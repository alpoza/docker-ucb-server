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

<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="java.util.*"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.myactivity.MyActivityTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="buildLifeImg" value="/images/icon_orig_process.gif"/>
<c:url var="requestImg" value="/images/icon_job.gif"/>
<c:url var="workflowImg" value="/images/icon_workflow.gif"/>
<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<%-- CONTENT --%>
<input type="hidden" id="activityPageIndex" name="activityPageIndex" value="${activityPage.index}" />
<input type="hidden" id="activityPageDirection" name="activityPageDirection" value="" />
<script type="text/javascript">
  /* <![CDATA[ */
  function toActivityPage(page) {
    $("activityPageIndex").value = page; // part of myActivityForm
    $("myActivityForm").submit();
  }

  var buildLifeImg = "${buildLifeImg}";
  var requestImg = "${requestImg}";
  var workflowImg = "${buildLifeImg}";
  var myActivityRestUrl = "${param.myActivityRestUrl}";
  /* ]]> */
</script>
<c:set var="dynamicRefreshCssUrl" value="/css/dynamicRefresh" />
<c:set var="dynamicRefreshJsUrl" value="/js/dynamicRefresh" />
<c:set var="dynamicRefreshMyActivityJsUrl" value="${dynamicRefreshJsUrl}/myActivity" />
<link rel="stylesheet" href="${dynamicRefreshCssUrl}/dynamicRefresh.css">
<script type="text/javascript" src="${dynamicRefreshMyActivityJsUrl}/MyActivity.js"></script>
<br />
<br />
<ucui:carousel id="request" currentPage="${activityPage.index}" numberOfPages="${activityPage.count}" methodName="toActivityPage" />
<h2><c:out value="${param.caption}" default="${ub:i18n('Activity')}"/></h2>
<div id="myActivityTable">
</div>
