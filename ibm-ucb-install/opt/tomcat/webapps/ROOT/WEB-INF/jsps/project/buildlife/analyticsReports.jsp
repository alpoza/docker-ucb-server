<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />

<c:url var="plusImage" value="/images/plus.gif"/>
<c:url var="minusImage" value="/images/minus.gif"/>
<c:url var="linkImage" value="/images/icon_magnifyglass.gif"/>
<c:url var="trendImage" value="/images/icon_note_file_small.gif"/>

<c:set var="onDocumentLoad" scope="request">
   /* <![CDATA[ */
        <c:forEach var="analyticsReport" items="${analyticsReports}">
            var severityDiv = "${ah3:escapeJs(severityDivMap[analyticsReport])}"
            var findingDiv = "${ah3:escapeJs(findingDivMap[analyticsReport])}"
            <c:url var="severityUrl" value="/rest2/trends/analytics/${analyticsReport.reportName}/${buildLife.id}/-1"/>
            <c:url var="topUrl" value="/rest2/trends/analytics/${analyticsReport.reportName}/${buildLife.id}/10"/>
            var severityUrl = "${ah3:escapeJs(severityUrl)}"
            var severityChart = new MetricSeverityChart();
            severityChart.retrieveCommitData(severityUrl, null, i18n("AnalyticsSeverityChartError"), severityDiv);
            var topUrl = "${ah3:escapeJs(topUrl)}"
            var topChart = new TopMetricChart();
            topChart.retrieveCommitData(topUrl, null, i18n("AnalyticsFindingsChartError"), findingDiv);
        </c:forEach>
   /* ]]> */
</c:set>
<c:import url="buildLifeHeader.jsp">
  <c:param name="selected" value="analytics"/>
</c:import>

<c:set var="summaryReports" value="${buildLife.sourceAnalyticSummaryReportList}"/>

<div class="data-table_container">
  <br/>
  <h3>${ub:i18n("AnalyticsReports")} [${fn:length(analyticsReports) + fn:length(summaryReports)}]</h3>
  <br/>

  <c:if test="${empty analyticsReports and empty summaryReports}">
    ${ub:i18n("NoReportsOnBuildLife")}
  </c:if>

  <c:url var="highchartsDir" value="/lib/highcharts/js"/>
  <script src="${highchartsDir}/adapters/prototype-adapter.js" type="text/javascript"></script>
  <script src="${highchartsDir}/highcharts.js" type="text/javascript"></script>

  <c:forEach var="summaryReport" items="${summaryReports}" varStatus="indx">
     <table class="note-table">
       <thead>
         <tr>
           <td colspan="2">
             <table>
               <tr>
                 <td nowrap="nowrap"><span class="bold">${ub:i18n("NameWithColon")}</span></td>
                 <td>${fn:escapeXml(summaryReport.reportName)}</td>
               </tr>
               <tr>
                 <td nowrap="nowrap"><span class="bold">${ub:i18n("TypeWithColon")}</span></td>
                 <td>${fn:escapeXml(summaryReport.type)}</td>
               </tr>
               <c:set var="reportUrlLink" value="${summaryReport.urlLink}"/>
               <c:if test="${not empty reportUrlLink}">
                 <tr>
                   <td nowrap="nowrap"><span class="bold">${ub:i18n("LinkWithColon")}</span></td>
                   <td><ucf:link href="${reportUrlLink}" target="_externalAnalytics" img="${linkImage}"
                                 label="${ub:i18n('GoToExternalReport')}"/></td>
                 </tr>
               </c:if>
             </table>
           </td>
         </tr>
       </thead>
       <tbody>
         <tr><td colspan="2">
            <div id="summariesReport${summaryReport.reportName}"></div>
            <c:url var="reportUrl" value="/rest2/build-lives/${buildLife.id}/analyticSummaries/${summaryReport.reportName}/summaries"/>
            <script type="text/javascript">
                require(["ubuild/module/UBuildApp", "ubuild/table/SourceAnalyticSummariesTable"],
                    function(UBuildApp, SourceAnalyticSummariesTable) {
                    UBuildApp.util.i18nLoaded.then(function() {
                        var table = new SourceAnalyticSummariesTable({
                            "url": "${reportUrl}"
                        });
                        table.placeAt("summariesReport${summaryReport.reportName}");
                    });
                });
            </script>
         </td></tr>
       </tbody>
     </table>
     <br/>
  </c:forEach>

   <c:forEach var="analyticsReport" items="${analyticsReports}" varStatus="indx">
     <c:remove var="severityDiv"/>
     <c:set var="severityDiv" value="${severityDivMap[analyticsReport]}"/>
     <c:remove var="findingDiv"/>
     <c:set var="findingDiv" value="${findingDivMap[analyticsReport]}"/>

     <table class="note-table">
       <thead>
         <tr>
           <td>
             <table>
               <tr>
                 <td nowrap="nowrap"><span class="bold">${ub:i18n("NameWithColon")}</span></td>
                 <td>${fn:escapeXml(analyticsReport.reportName)}</td>
               </tr>
               <tr>
                 <td nowrap="nowrap"><span class="bold">${ub:i18n("TypeWithColon")}</span></td>
                 <td>${fn:escapeXml(analyticsReport.type)}</td>
               </tr>
               <tr>
                 <td nowrap="nowrap"><span class="bold">${ub:i18n("AnalyticsNumberOfFindingsWithColon")}</span></td>
                 <td>${fn:length(analyticsReport.findings)}</td>
               </tr>
               <c:set var="reportUrlLink" value="${analyticsReport.urlLink}"/>
               <c:if test="${not empty reportUrlLink}">
                 <tr>
                   <td nowrap="nowrap"><span class="bold">${ub:i18n("LinkWithColon")}</span></td>
                   <td><ucf:link href="${reportUrlLink}" target="_externalAnalytics" img="${linkImage}"
                                 label="${ub:i18n('GoToExternalReport')}"/></td>
                 </tr>
               </c:if>
               <tr>
                 <td colspan="2">
                   <br/><br/>
                   <c:url var="viewAnalyticsTrendsUrl" value="${BuildLifeTasks.viewAnalyticsTrends}">
                     <c:param name="buildLifeId" value="${buildLife.id}"/>
                     <c:param name="analyticReportName" value="${analyticsReport.reportName}"/>
                   </c:url>

                   <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(fn:escapeXml(viewAnalyticsTrendsUrl))}', 1000, 600); return false;"
                        label="${ub:i18n('ViewAnalyticsTrends')}" title="${ub:i18n('ViewAnalyticsTrends')}" img="${trendImage}" forceLabel="true"/>
                 </td>
               </tr>
             </table>
           </td>

           <td valign="middle" align="right" width="30%" nowrap="nowrap">
             <c:if test="${fn:length(analyticsReport.findings) > 0}">
               <table>
                 <tr>
                   <td valign="middle" align="right">
                     <div id="${severityDiv}"></div>
                     <c:url var="severityJsUrl" value="/js/trendcharts/metricSeverityChart.js"/>
                     <script src="${severityJsUrl}"></script>
                   </td>
                   <td valign="middle" align="right">
                     <div id="${findingDiv}"></div>
                     <c:url var="topJsUrl" value="/js/trendcharts/topMetricChart.js"/>
                     <script src="${topJsUrl}"></script>
                   </td>
                 </tr>
               </table>
             </c:if>
           </td>
         </tr>

       </thead>

       <tbody id="tr${fn:escapeXml(analyticsReport.id)}-findings">
         <tr><td colspan="2">
           <c:set var="hasFindings" value="${analyticsReport.findingCount gt 0}"/>
           <c:set var="firstFinding" value="${hasFindings ? analyticsReport.findings[0] : null}"/>
           <c:set var="displayIdCol" value="${hasFindings and (not empty firstFinding.id) and (fn:length(firstFinding.id) != 32)}"/>
           <c:set var="displayStatusCol" value="${hasFindings and (not empty firstFinding.status)}"/>

            <div id="analyticsReport${analyticsReport.id}"></div>
            <c:url var="reportUrl" value="/rest2/build-lives/${buildLife.id}/analytics/${analyticsReport.id}/findings"/>
            <script type="text/javascript">
                require(["ubuild/module/UBuildApp", "ubuild/table/SourceAnalyticFindingsTable"],
                    function(UBuildApp, SourceAnalyticFindingsTable) {
                    UBuildApp.util.i18nLoaded.then(function() {
                        var table = new SourceAnalyticFindingsTable({
                            "url": "${reportUrl}",
                            "displayId": ${displayIdCol},
                            "displayStatus": ${displayStatusCol}
                        });
                        table.placeAt("analyticsReport${analyticsReport.id}");
                    });
                });
            </script>
         </td></tr>
       </tbody>

      </table>
     <br/>

    </c:forEach>

</div>

<c:import url="buildLifeFooter.jsp"/>
