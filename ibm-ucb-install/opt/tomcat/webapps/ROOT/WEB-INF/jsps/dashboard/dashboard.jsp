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
<%@ page import="com.urbancode.ubuild.runtime.scripting.helpers.UrlHelper" %>
<%@ page import="com.urbancode.ubuild.persistence.UnitOfWork" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:url var="loadingImgUrl" value="/images/loading.gif"/>
<jsp:useBean id="agentInfo" class="com.urbancode.ubuild.web.components.AgentInfo"/>

<c:url var="projectsCommitReportUrl" value="/rest2/reports/commits/projects"/>
<c:url var="projectsBuildReportUrl" value="/rest2/reports/builds/projects"/>
<c:url var="projectsTestReportUrl" value="/rest2/reports/tests/projects"/>
<c:url var="highchartsDir" value="/lib/highcharts/js"/>

<%-- CONTENT --%>

<c:set var="onDocumentLoad" scope="request">
  <c:if test="${viewGraphs}">
  /* <![CDATA[ */
      var commitChartUrl = "${ah3:escapeJs(projectsCommitReportUrl)}";
      var commitReportChart = new CommitReport();
      commitReportChart.retrieveCommitData(commitChartUrl, null, '${ah3:escapeJs(ub:i18n("DashboardCommitChartError"))}');
      var buildChartUrl = "${ah3:escapeJs(projectsBuildReportUrl)}";
      var buildReportChart = new BuildReport();
      buildReportChart.retrieveBuildData(buildChartUrl, null, '${ah3:escapeJs(ub:i18n("DashboardBuildChartError"))}');
      var testChartUrl = "${ah3:escapeJs(projectsTestReportUrl)}";
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
<c:import url="/WEB-INF/jsps/home/header.jsp">
  <c:param name="selected" value="dashboard" />
</c:import>

<table class="wide-table">
  <tbody>
    <tr class="align-top">
      <td style="padding-bottom: 1em" class="align-top">

        <%-- EVAL PERIOD EXCEEDED MESSAGE --%>

        <c:if test="${licenseInfo.evalPeriodExceeded}">
          <table class="dashboard-warning">
            <tr class="dashboard-region-title">
              <td>
                <span class="large-text" style="color:red; font-weight:bold;">
                  ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
                  ${ub:i18n("EvalPeriodExceededServerLock")}
                </span>
              </td>
            </tr>
          </table>
        </c:if>

        <%-- GRACE PERIOD EXCEEDED MESSAGE --%>

        <c:if test="${licenseInfo.gracePeriodExceeded}">
          <table class="dashboard-warning">
            <tr class="dashboard-region-title">
              <td>
                <span class="large-text" style="color:red; font-weight:bold;">
                  ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
                  ${ub:i18n("GracePeriodExceededServerLock")}
                </span>
              </td>
            </tr>
          </table>
        </c:if>

        <%-- EVAL MODE MESSAGE --%>

        <c:if test="${licenseInfo.inEvalMode}">
          <table class="dashboard-warning">
            <tr class="dashboard-region-title">
              <td>
                <span class="warningHeader">
                  ${ub:i18n("ServerInEvalModeWarning")}
                </span>
              </td>
            </tr>

            <tr>
              <td>
                <span class="warningHeader" style="font-weight:normal;">
                  ${ub:i18nMessage("ServerLockWarning", fn:escapeXml(licenseInfo.evalDaysRemaining))}
                </span>
              </td>
            </tr>
          </table>
        </c:if>

        <%-- LICENSE WARNINGS --%>

        <c:if test="${licenseInfo.inGracePeriod}">
          <table class="dashboard-warning">
            <tr class="dashboard-region-title">
              <td>
                <span style="color:red;font-weight:bold;">
                  ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
                  ${ub:i18n("LicenseCommitterLimitExcededWarning")}
                </span>
              </td>
            </tr>

            <tr>
              <td>
                <span style="color:red;font-weight:normal;">
                  ${ub:i18nMessage("ServerLockWarning", fn:escapeXml(licenseInfo.gracePeriodDaysRemaining))}
                </span>
              </td>
            </tr>
          </table>
        </c:if>

        <%-- AGENT WARNINGS --%>

        <c:if test="${agentInfo.configuredAgentCount == 0}">
          <table class="dashboard-warning">
            <tr class="dashboard-region-title">
              <td>
                <div class="warningHeader">
                  ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
                  ${ub:i18n("DashboardNoAgentsMessage")}
                </div>
              </td>
            </tr>
          </table>
        </c:if>

        <div id="dashboardTree"></div>
        <script type="text/javascript">
          require(["ubuild/module/UBuildApp", "ubuild/table/dashboard/DashboardTree"],
              function(UBuildApp, DashboardTree) {
                UBuildApp.util.i18nLoaded.then(function() {
                  var dashTree = new DashboardTree();
                  dashTree.placeAt("dashboardTree");
                  dashTree.startup();
                });
              });
        </script>
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

<c:import url="/WEB-INF/jsps/home/footer.jsp"/>
