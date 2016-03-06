<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.project.*"%>
<%@ page import="com.urbancode.ubuild.domain.security.*"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="imsg" tagdir="/WEB-INF/tags/ui/admin/inactiveMessage" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
  EvenOdd eo = new EvenOdd();

  Authority auth = Authority.getInstance();
  Project project = (Project)pageContext.findAttribute(WebConstants.PROJECT);
  pageContext.setAttribute("projectWrite", Boolean.valueOf(auth.hasPermission(project, UBuildAction.PROJECT_EDIT)));
%>

<c:url var="imgUrl" value="/images"/>
<c:url var="loadingImgUrl" value="/images/loading.gif"/>

<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="projectCommitReportUrl" value="/rest2/reports/commits/projects/${project.id}"/>
<c:url var="projectBuildReportUrl" value="/rest2/reports/builds/projects/${project.id}"/>
<c:url var="projectTestReportUrl" value="/rest2/reports/tests/projects/${project.id}"/>
<c:url var="recentProjectActivityRestUrl" value="/rest2/projects/${project.id}/recentProcessActivity"/>
<c:url var="latestStatusRestUrl" value="/rest2/projects/${project.id}/latestStatus"/>
<c:url var="latestBuildsRestUrl" value="/rest2/projects/${project.id}/latestBuilds"/>
<c:url var="highchartsDir" value="/lib/highcharts/js"/>

<%-- CONTENT --%>

<%-- HEADER --%>
<c:set var="onDocumentLoad" scope="request">
  renderPorjectDashboard();
  refreshLatestStatus();
  refreshLatestBuilds();
  <c:if test="${viewGraphs}">
  /* <![CDATA[ */
      var commitChartUrl = "${ah3:escapeJs(projectCommitReportUrl)}";
      var commitReportChart = new CommitReport();
      commitReportChart.retrieveCommitData(commitChartUrl, null, '${ah3:escapeJs(ub:i18n("DashboardCommitChartError"))}');
      var buildChartUrl = "${ah3:escapeJs(projectBuildReportUrl)}";
      var buildReportChart = new BuildReport();
      buildReportChart.retrieveBuildData(buildChartUrl, null, '${ah3:escapeJs(ub:i18n("DashboardBuildChartError"))}');
      var testChartUrl = "${ah3:escapeJs(projectTestReportUrl)}";
      var testReportChart = new TestReport();
      testReportChart.retrieveTestData(testChartUrl, null, '${ah3:escapeJs(ub:i18n("DashboardTestingChartError"))}');
  /* ]]> */
  </c:if>
</c:set>
<c:set var="headContent" scope="request">
  <c:if test="${viewGraphs}">
    <script src="${highchartsDir}/adapters/prototype-adapter.js" type="text/javascript"></script>
    <script src="${highchartsDir}/highcharts.js" type="text/javascript"></script>
  </c:if>
</c:set>

<jsp:include page="/WEB-INF/snippets/react.jsp"/>

<c:import url="/WEB-INF/jsps/home/project/header.jsp">
  <c:param name="selected" value="dashboard"/>
  <c:param name="noRefresh" value="false" />
</c:import>

<c:set var="dynamicRefreshCssUrl" value="/css/dynamicRefresh" />
<c:set var="dynamicRefreshJsUrl" value="/js/dynamicRefresh" />
<c:set var="dynamicRefreshProjectJsUrl" value="${dynamicRefreshJsUrl}/project" />
<link rel="stylesheet" href="${dynamicRefreshCssUrl}/dynamicRefresh.css">
<script type="text/javascript" src="${dynamicRefreshJsUrl}/Utils.js"></script>
<script type="text/javascript" src="${dynamicRefreshProjectJsUrl}/ProjectDashboard.js"></script>
<script type="text/javascript" src="${dynamicRefreshProjectJsUrl}/LatestBuildsForProject.js"></script>
<script type="text/javascript" src="${dynamicRefreshProjectJsUrl}/LatestStatusForProject.js"></script>
<script type="text/javascript" src="${dynamicRefreshJsUrl}/RecentActivity.js"></script>

<script type="text/javascript">
  /* <![CDATA[ */
  var latestBuildsRestUrl = "${latestBuildsRestUrl}";
  var latestStatusRestUrl = "${latestStatusRestUrl}";
  var imgUrl = "${imgUrl}";
  var recentProjectActivityRestUrl = "${recentProjectActivityRestUrl}";
  var buildLifeUrl = "/tasks/project/BuildLifeTasks/viewBuildLife?buildLifeId=";
  var errorUrl = "/tasks/project/BuildLifeTasks/viewErrors?buildLifeId=";
  var processUrl = "/tasks/project/WorkflowTasks/viewDashboard?workflowId=";
  var workflowUrl = "/tasks/project/WorkflowTasks/viewDashboard?workflowId=";
  var jobTraceUrl = "/tasks/jobs/JobTasks/viewBuildSummary?job_trace_id=";
  var statusHistoryUrl = "/tasks/search/SearchTasks/viewStatusHistory?projectId=";
  var isLatestBuildsLoading = false;
  var isLatestStatusLoading = false;
  /* ]]> */
</script>

<table style="border: none; width: 100%;">
  <tbody>
    <tr class="align-top">
      <td style="padding-bottom: 1em" class="align-top">
        <c:if test="${not project.active}">
          <div class="dashboard-contents">
            <imsg:inactiveMessage isActive="${project.active}" message="${ub:i18n('ProjectDeactivated')}"/>
          </div>
        </c:if>

        <c:import url="/WEB-INF/jsps/project/latestStatuses.jsp"/>

        <c:import url="/WEB-INF/jsps/project/latestBuilds.jsp"/>

        <%
           String messageAttributeName = ProjectTasks.class.getName() + ":actionMessage";
           pageContext.setAttribute("message", session.getAttribute(messageAttributeName));
           session.removeAttribute(messageAttributeName);
        %>
        <c:if test="${!empty message}">
          <div class="dashboard-contents"><span class="message">${fn:escapeXml(message)}</span></div>
        </c:if>

        <div class="dashboard-contents">
            <div class="dashboard-contents-header">
                <c:url var="viewAllUrl4" value="${SearchTasks.viewBuildLifeActivityHistory}">
                    <c:param name="projectId" value="${project.id}"/>
                    <c:param name="search" value="true"/>
                </c:url>
                <div style="float: right">
                  <ucf:link label="${ub:i18n('ViewAll')}"  href="${viewAllUrl4}"/>
                </div>
                ${ub:i18n('RecentProcessActivity')}
            </div>
            <div id="projectRecentActivityTable"></div>
        </div>
      </td>

      <c:if test="${viewGraphs}">
        <td width="340px">
          <div id="commitChartContainer"><img src="${loadingImgUrl}"/></div>
          <br>
          <div id="buildChartContainer"><img src="${loadingImgUrl}"/></div>
          <br>
          <div id="testChartContainer"><img src="${loadingImgUrl}"/></div>
        </td>
      </c:if>
    </tr>
  </tbody>
</table>

<c:import url="/WEB-INF/jsps/home/project/footer.jsp"/>
