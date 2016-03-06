<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.dashboard.BuildLifeActivitySummary"%>
<%@ page import="com.urbancode.ubuild.domain.project.Project"%>
<%@ page import="com.urbancode.ubuild.domain.profile.BuildProfile"%>
<%@ page import="com.urbancode.ubuild.domain.persistent.Handle"%>
<%@ page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowStatusEnum" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.ProcessSuccessReportTimeTypeEnum" %>
<%@ page import="com.urbancode.ubuild.services.workflow.WorkflowStatusService"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.BuildRequestTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.WorkflowTasks"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*"%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.workflow.ProcessSuccessReportTimeTypeEnum"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
  EvenOdd eo = new EvenOdd();

  Workflow workflow = (Workflow) pageContext.findAttribute(WebConstants.WORKFLOW);
  Project project = workflow.getProject();

  int timeNum = workflow.getSuccessReportTimeNum();
  ProcessSuccessReportTimeTypeEnum timeType = workflow.getSuccessReportTimeType();

  pageContext.setAttribute("timeNum", timeNum);
  pageContext.setAttribute("timeType", timeType);
%>

<c:url var="loadingImgUrl" value="/images/loading.gif"/>
<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${workflow.project.id}"/>
</c:url>
<c:url var="viewAgentPoolErrorPopupUrl" value="${WorkflowTasks.viewAgentPoolErrorPopup}">
    <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
</c:url>

<c:url var="processCommitReportUrl" value="/rest2/reports/commits/projects/${workflow.project.id}/build-processes/${workflow.id}"/>
<c:url var="processBuildReportUrl" value="/rest2/reports/builds/projects/${workflow.project.id}/build-processes/${workflow.id}"/>
<c:url var="processTestReportUrl" value="/rest2/reports/tests/projects/${workflow.project.id}/build-processes/${workflow.id}"/>
<c:url var="highchartsDir" value="/lib/highcharts/js"/>
<c:url var="recentProcessActivityRestUrl" value="/rest2/projects/${workflow.project.id}/buildProcesses/${workflow.id}/dashboardActivity"/>
<c:url var="processLatestStatusRestUrl" value="/rest2/projects/${workflow.project.id}/buildProcesses/${workflow.id}/statusSummaries"/>
<c:url var="processDependencyRestUrl" value="/rest2/projects/${workflow.project.id}/buildProcesses/${workflow.id}/dependencySummaries"/>
<c:url var="successReportRestUrl" value="/rest2/projects/${workflow.project.id}/buildProcesses/${workflow.id}/successRateReport"/>

<%-- CONTENT --%>

<%-- HEADER --%>
<c:set var="onDocumentLoad" scope="request">
  renderProcessDashboard();
  <c:if test="${viewGraphs}">
  /* <![CDATA[ */
      var commitChartUrl = "${ah3:escapeJs(processCommitReportUrl)}";
      var commitReportChart = new CommitReport();
      commitReportChart.retrieveCommitData(commitChartUrl, null, '${ah3:escapeJs(ub:i18n("DashboardCommitChartError"))}');
      var buildChartUrl = "${ah3:escapeJs(processBuildReportUrl)}";
      var buildReportChart = new BuildReport();
      buildReportChart.retrieveBuildData(buildChartUrl, null, '${ah3:escapeJs(ub:i18n("DashboardBuildChartError"))}');
      var testChartUrl = "${ah3:escapeJs(processTestReportUrl)}";
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
<c:import url="/WEB-INF/jsps/home/project/workflow/header.jsp">
  <c:param name="selected" value="dashboard"/>
</c:import>

<c:set var="dynamicRefreshCssUrl" value="/css/dynamicRefresh" />
<c:set var="dynamicRefreshJsUrl" value="/js/dynamicRefresh" />
<c:set var="dynamicRefreshProcessJsUrl" value="${dynamicRefreshJsUrl}/process" />
<link rel="stylesheet" href="${dynamicRefreshCssUrl}/dynamicRefresh.css">
<script type="text/javascript" src="${dynamicRefreshJsUrl}/Utils.js"></script>
<script type="text/javascript" src="${dynamicRefreshProcessJsUrl}/ProcessDashboard.js"></script>
<script type="text/javascript" src="${dynamicRefreshProcessJsUrl}/LatestStatusForProcess.js"></script>
<script type="text/javascript" src="${dynamicRefreshJsUrl}/RecentActivity.js"></script>
<script type="text/javascript" src="${dynamicRefreshProcessJsUrl}/DependencyConfigurationForProcess.js"></script>

<script type="text/javascript">
  /* <![CDATA[ */
  var recentProcessActivityRestUrl = "${recentProcessActivityRestUrl}";
  var processLatestStatusRestUrl = "${processLatestStatusRestUrl}";
  var processDependencyRestUrl = "${processDependencyRestUrl}";
  var successReportRestUrl = "${successReportRestUrl}";
  var buildLifeUrl = "/tasks/project/BuildLifeTasks/viewBuildLife?buildLifeId=";
  var processUrl = "/tasks/project/WorkflowTasks/viewDashboard?workflowId=";
  var jobTraceUrl = "/tasks/jobs/JobTasks/viewJobTrace?job_trace_id=";
  var statusHistoryUrl = "/tasks/search/SearchTasks/viewStatusHistory?projectId=${workflow.project.id}&search=true&statusId=";
  var projectDependencyUrl = "/tasks/project/ProjectTasks/viewDashboard?projectId=";
  var workflowDependencyUrl = "/tasks/project/WorkflowTasks/viewDashboard?workflowId=";
  var isLatestStatusLoading = false;
  var isDependencyConfigurationLoading = false;
  var isSuccessReportLoading = false;
  var thisProcessId = ${workflow.id};
  /* ]]> */
</script>

<script type="text/javascript">
<!--
require(["dojo/_base/xhr"], function(xhr){
    successReportBtnClick = function (projectID, workflowID) {
        var time = document.getElementById("successReportNumber").value;
        var typeElement = document.getElementById("successReportType");
        var typeIndex = typeElement.selectedIndex;
        var type = typeElement.options[typeIndex].value;
        var AjaxURL = successReportRestUrl + "?time=" + time + "&type=" + type;
        isSuccessReportLoading = true;
        xhr.get({
            url: AjaxURL,
            handleAs: "json",
            load: function(data){
                isSuccessReportLoading = false;
                updateSuccessReportBox(data);
            },
            error: function(){
                isSuccessReportLoading = false;
                alert(i18n("GetWorkFlowSuccessReportError"));
            }
        });
    };

    successReportSetDefaultBtnClick = function (projectID, workflowID) {
        var time = document.getElementById("successReportNumber").value;
        var typeElement = document.getElementById("successReportType");
        var typeIndex = typeElement.selectedIndex;
        var type = typeElement.options[typeIndex].value;
        var AjaxURL = "/rest2/projects/" + projectID + "/buildProcesses/" + workflowID + "/successRateReport";
        xhr.put({
            url: AjaxURL,
            handleAs: "json",
            putData: {"time":time,"type":type},
            load: function(data){
                updateSuccessReportBox(data);
                alert(i18n("SaveWorkFlowSuccessReportSuccess"));
            },
            error: function(){
                alert(i18n("SaveWorkFlowSuccessReportError"));
            }
        });
    };

    updateSuccessReportBox = function (response) {
        //Update the color
        var successReportBox = document.getElementById("successReport");
        if (response.successCount * 2 >= response.totalCount) {
            successReportBox.style.color="#616d33";
            successReportBox.style.backgroundColor="#c7e094";
        }
        else {
            successReportBox.style.color="#875346";
            successReportBox.style.backgroundColor="#E29797";
        }

        // update datas
        document.getElementById("successPercent").textContent = response.successPercent + "%";
        if (response.totalCount != 0) {
            document.getElementById("SuccessRate").textContent = response.successCount + "/" + response.totalCount;
        }
        else {
            document.getElementById("SuccessRate").textContent = "0/0";
        }
        document.getElementById("avgDuration").textContent = response.avgDuration;
    };

    successReportTypeChange = function () {
        var typeElement = document.getElementById("successReportType");
        var typeIndex = typeElement.selectedIndex;
        var type = typeElement.options[typeIndex].value;
        if (type == "ALL_HISTORY") {
            document.getElementById("LastLabel").style.display = "none";
            document.getElementById("successReportNumber").style.display = "none";
        }
        else {
            document.getElementById("LastLabel").style.display = "inline";
            document.getElementById("successReportNumber").style.display = "inline";
        }
    };
});
//-->
</script>

<c:if test='${isServerGroupError == "true"}'>
  <script type="text/javascript"><!--
  function showWarning() {
    showPopup('${ah3:escapeJs(viewAgentPoolErrorPopupUrl)}', 600, 400);
  }
  YAHOO.util.Event.addListener(window, "load", showWarning);
--></script>
</c:if>

<table style="width: 100%;">
    <tbody>
        <tr class="align-top">
            <td style="padding-bottom: 1em" class="align-top">
                <c:import url="/WEB-INF/jsps/project/workflow/latestStatuses.jsp"/>
                <c:import url="/WEB-INF/jsps/project/workflow/originatingWorkflowActivity.jsp"/>
                <c:import url="/WEB-INF/jsps/project/workflow/buildWorkflow.jsp">
                   <c:param name="mode" value="view"/>
                </c:import>
                <c:import url="/WEB-INF/jsps/project/workflow/dependencyList.jsp"/>
            </td>

            <td align="right" width="300px" style="padding-left: 10px">
              <c:if test="${not empty workflowResultSummary}">
                <div class="dashboard-contents" style="margin-top: 0; margin-bottom: 1em;">
                  <c:choose>
                    <c:when test="${workflowResultSummary.successCount * 2 >= workflowResultSummary.totalCount}">
                      <c:set var="testStyle" value="color: #616d33; background-color: #c7e094;"/>
                    </c:when>
                    <c:otherwise>
                      <c:set var="testStyle" value="color: #875346; background-color: #E29797;"/>
                    </c:otherwise>
                  </c:choose>

                  <table class="data-table">
                    <tr>
                        <td colspan="2">
                            <c:if test="${timeType ne ProcessSuccessReportTimeTypeEnum.ALL_HISTORY}">
                                <span id="LastLabel">${ub:i18n('Last')}</span>
                                <input type="text" id="successReportNumber" name="" value="${timeNum}" size="2"/>
                            </c:if>
                            <c:if test="${timeType eq ProcessSuccessReportTimeTypeEnum.ALL_HISTORY}">
                                <span style="display:none;" id="LastLabel">${ub:i18n('Last')}</span>
                                <input style="display:none;" type="text" id="successReportNumber" name="" value="${timeNum}" size="2"/>
                            </c:if>
                            <select id="successReportType" class="input" onchange="successReportTypeChange()">
                                <c:forEach var="enum" items="${ProcessSuccessReportTimeTypeEnum.values}">
                                     <option value="${enum}" <c:if test="${timeType eq enum}">selected=""</c:if>>${ub:i18n(enum)}</option>
                                 </c:forEach>
                            </select>
                            <ucf:button name="OK" id="successReportBtn" submit="${false}" label="${ub:i18n('OK')}" onclick="successReportBtnClick(${workflow.project.id}, ${workflow.id});" style="margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;"/>
                            <ucf:button name="Set Default" id="successReportSetDefaultBtn" submit="${false}" label="${ub:i18n('SetDefault')}" onclick="successReportSetDefaultBtnClick(${workflow.project.id}, ${workflow.id});" style="margin-left: 0px; margin-right: 0px; padding-left: 6px; padding-right: 6px;" />
                        </td>
                    </tr>
                    <tr>
                      <td align="center" class="bold" style="${testStyle};" id="successReport">
                        <span style="font-size: 24px;font-weight:bold;font-family:Verdana;" id="successPercent">${workflowResultSummary.successPercent}%</span><br/>
                        <span style="font-size: 16px;font-weight:bold;font-family:Verdana;">${ub:i18n("WorkflowDashboardSuccessful")}</span>
                      </td>
                      <td>
                        <div style="padding: 5px;">
                          <div style="float: right;" id="SuccessRate">${workflowResultSummary.successCount}/${workflowResultSummary.totalCount}</div>
                          <div><span class="bold">${ub:i18n("SuccessRateWithColon")}</span></div>
                          <div style="float: right;" id="avgDuration">${workflowResultSummary.avgDuration}</div>
                          <div><span class="bold">${ub:i18n("AvgDurationWithColon")}</span></div>
                        </div>
                      </td>
                    </tr>
                  </table>
                </div>
              </c:if>

              <c:if test="${viewGraphs}">
                <div id="commitChartContainer"><img src="${loadingImgUrl}"/></div>
                <br>
                <div id="buildChartContainer"><img src="${loadingImgUrl}"/></div>
                <br>
                <div id="testChartContainer"><img src="${loadingImgUrl}"/></div>
              </c:if>
            </td>
        </tr>
    </tbody>
</table>

<c:import url="/WEB-INF/jsps/home/project/workflow/footer.jsp"/>
