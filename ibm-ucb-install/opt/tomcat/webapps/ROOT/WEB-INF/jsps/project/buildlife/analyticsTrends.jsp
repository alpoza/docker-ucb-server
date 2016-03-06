<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.reporting.analytic.SourceAnalyticUserView" %>
<%@ page import="com.urbancode.ubuild.reporting.sourcechange.SourceChange"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error"  uri="error" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imagesUrl" value="/images"/>
<c:url var="plusImage" value="/images/plus.gif"/>
<c:url var="minusImage" value="/images/minus.gif"/>
<c:set var="clippedCommentWidth" value="100" />

<c:set var="onDocumentLoad" scope="request">
   /* <![CDATA[ */
        if ("${ah3:escapeJs(buildLifeSince)}") {
            <c:url var="severityChartUrl" value="/rest2/trends/analytics/${param.analyticReportName}/${buildLife.id}/since/severities/${buildLifeSince.id}"/>
            <c:url var="countChartUrl" value="/rest2/trends/analytics/${param.analyticReportName}/${buildLife.id}/since/counts/${buildLifeSince.id}"/>
            var countChartUrl = "${ah3:escapeJs(countChartUrl)}";
            var findingChart = new FindingCountChart();
            findingChart.retrieveCommitData(countChartUrl, null, i18n('AnalyticsTrendsFindingCountChartError'));
            var severityChartUrl = "${ah3:escapeJs(severityChartUrl)}";
            var severityChart = new SeverityCountChart();
            severityChart.retrieveCommitData(severityChartUrl, null, i18n('AnalyticsTrendsSeverityCountChartError'));
        }
   /* ]]> */
</c:set>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18nMessage("AnalyticsTrendsLabel", fn:escapeXml(param.analyticReportName))}</a></li>
    </ul>
  </div>
  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("AnalyticsTrendsHelp")}
    </div>

    <form action="${fn:escapeXml(actionUrl)}" method="get">
      <input type="hidden" name="${fn:escapeXml(WebConstants.BUILD_LIFE_ID)}" value="${fn:escapeXml(buildLife.id)}"/>
      <input type="hidden" name="analyticReportName" value="${fn:escapeXml(param.analyticReportName)}"/>

      <div align="right">
        <span class="required-text">${ub:i18n("RequiredField")}</span>
      </div>

      <table class="property-table">
        <tbody>

          <error:field-error field="${WebConstants.BUILD_LIFE_SINCE_ID}" cssClass="odd"/>
          <tr class="odd" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("Since")} <span class="required-text">*</span></span></td>
            
            <td align="left" width="20%">
              <ucf:trendBuildLifeSelector sinceId="${buildLifeSince.id}" buildLifeList="${buildLifeList}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("AnalyticsTrendsSinceDesc")}</span>
            </td>
          </tr>
        </tbody>
      </table>
      <br/>
      <ucf:button name="Select" label="${ub:i18n('Select')}"/>
      <ucf:button name="Close" label="${ub:i18n('Close')}" href="javascript:parent.hidePopup();"/>
    </form>


    <c:if test="${analyticsTrend != null}">

      <br/>
      <br/>

      <c:choose>
        <c:when test="${not empty buildLife.latestStampValue}">
          <c:set var="buildLifeName" value="${buildLife.latestStampValue}"/>
        </c:when>
        <c:otherwise>
          <c:set var="buildLifeName" value="${buildLife.id}"/>
        </c:otherwise>
      </c:choose>
      <c:choose>
        <c:when test="${not empty buildLifeSince.latestStampValue}">
          <c:set var="sinceName" value="${buildLifeSince.latestStampValue}"/>
        </c:when>
        <c:otherwise>
          <c:set var="sinceName" value="${buildLifeSince.id}"/>
        </c:otherwise>
      </c:choose>

      <div class="system-helpbox">
        ${ub:i18n("AnalyticsTrends")}&nbsp;${fn:escapeXml(buildLife.profile.project.name)} - ${fn:escapeXml(buildLife.profile.workflow.name)}<br/>
        ${ub:i18n("From")} <c:out value="${sinceName}"/>&nbsp;&nbsp;&nbsp;${ub:i18n("To")} <c:out value="${buildLifeName}"/><br/>
        ${ub:i18n("ReportsWithColon")} ${fn:length(analyticsTrend.reports)}
        <br/>
      </div>


      <div id="analytics-graph-section" style="margin-top: 0.25em; margin-bottom:0.25em">
      
        <c:url var="highchartsDir" value="/lib/highcharts/js"/>
        <script src="${highchartsDir}/adapters/prototype-adapter.js" type="text/javascript"></script>
        <script src="${highchartsDir}/highcharts.js" type="text/javascript"></script>
        
        <%-- FINDINGS COUNT GRAPH --%>
        <div style="width: 46%; margin-top: 0.5em; float: left">

          <table class="generic" style="padding: 9px;">
            <caption>${ub:i18n("AnalyticsTrendsFindingCountTrend")}</caption>
            <tbody>
              <tr>
                <td align="left" width="16%"><span class="bold">${ub:i18n("CurrentWithColon")}</span></td>
                <td align="left" width="17%">
                  <c:out value="${analyticsTrend.report.findingCount}"/>
                </td>
                <td align="left" width="16%"><span class="bold">${ub:i18n("PreviousWithColon")}</span></td>
                <td align="left" width="17%">
                  <c:out value="${analyticsTrend.sinceReport.findingCount}"/>
                </td>
                <td align="left" width="16%"><span class="bold">${ub:i18n("AverageWithColon")}</span></td>
                <td align="left" width="18%">
                  <fmt:formatNumber type="number" maxFractionDigits="1" minFractionDigits="0" value="${analyticsTrend.averageFindingsPerReport}"/>
                </td>
              </tr>
            </tbody>
          </table>

          <div style="margin-top: 0.5em; width: 400px; height: 200px;">
            <div id="findingChartContainer"></div>
            <c:url var="countChartJsUrl" value="/js/trendcharts/findingCountChart.js"/>
            <script src="${countChartJsUrl}"></script>
          </div>

        </div>

        <%-- FINDINGS BY SEVERITY COUNT GRAPH --%>
        <div style="width: 46%; margin-top: 0.5em; float: right">
          <table class="generic" style="padding: 9px;">
            <caption>${ub:i18n("AnalyticsTrendsSeverityCountTrend")}</caption>
            <tbody>
              <tr>
                <td align="left">${ub:i18n("AnalyticsTrendsSeverityCountTrendDesc")}
                </td>
              </tr>
            </tbody>
          </table>

          <div style="margin-top: 0.5em; width: 400px; height: 200px;">
            <div id="severityChartContainer"></div>
            <c:url var="severityChartJsUrl" value="/js/trendcharts/severityCountChart.js"/>
            <script src="${severityChartJsUrl}"></script>
          </div>
        </div>

        <div style="clear:both;">&nbsp;</div>
      </div>

      <div style="margin-top: 1em;">
        <table class="data-table" style="padding: 9px;">
          <caption>${ub:i18n("AnalyticsTrendsFindingsByCommitter")}</caption>
          <thead>
            <tr>
              <th>${ub:i18n("User")}</th>
              <th>${ub:i18n("AnalyticsTrendsNumberOfChanges")}</th>
              <th>${ub:i18n("AnalyticsTrendsNumberOfFiles")}</th>
              <th>${ub:i18n("Change")}</th>
              <th>${ub:i18n("FilePath")}</th>
              <th>${ub:i18n("AnalyticsTrendsFindingsTracking")}</th>
            </tr>
          </thead>
          <tbody>
            <c:set var="userViews" value="${analyticsTrend.userRatings}"/>
            <c:if test="${fn:length(userViews) eq 0}">
              <tr>
                <td colspan="6">${ub:i18n("AnalyticsTrendsNoSourceChangesForFindings")}</td>
              </tr>
            </c:if>
            <c:forEach var="userView" items="${userViews}">
              <c:if test="${userView.filesChangedCausingAnalyticsChanges > 0}">
                  <tr>
                    <td rowspan="${userView.filesChangedCausingAnalyticsChanges}"><c:out value="${userView.username}"/></td>
                    <td align="center" rowspan="${userView.filesChangedCausingAnalyticsChanges}"><c:out value="${userView.changeSetCount}"/></td>
                    <td align="center" rowspan="${userView.filesChangedCausingAnalyticsChanges}"><c:out value="${userView.filesChanged}"/></td>
                    <c:forEach var="changeSet" items="${userView.changeSets}">
                      <%
                        SourceAnalyticUserView userView = (SourceAnalyticUserView) pageContext.getAttribute("userView");
                        SourceChange changeSet = (SourceChange) pageContext.getAttribute("changeSet");
                        pageContext.setAttribute("changeSetDeltas", userView.getDeltasFromChangeSet(changeSet));
                      %>
                      <td rowspan="${fn:length(changeSetDeltas)}">
                        <span class="bold">${ub:i18n("ChangeId")}</span> <c:out value="${changeSet.changeSet.scmId}" default="${ub:i18n('N/A')}"/><br/>
                        <span class="bold">${ub:i18n("Comment")}</span>
                        <c:choose>
                          <c:when test="${fn:length(changeSet.changeSet.comment) lt clippedCommentWidth}">
                            ${fn:escapeXml(changeSet.changeSet.comment)}
                          </c:when>
    
                          <c:otherwise>
                            ${fn:escapeXml(fn:substring(changeSet.changeSet.comment, 0, clippedCommentWidth))}&hellip;
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <c:forEach var="changeSetDelta" items="${changeSetDeltas}" varStatus="changeSetDeltaStatus">
                        <c:if test="${not changeSetDeltaStatus.first}">
                          <tr>
                        </c:if>
                        <td><c:out value="${changeSetDelta.filePath}"/></td>
                        <td align="center">
                          <c:choose>
                            <c:when test="${changeSetDelta.findingsChange gt 0}">
                              <span class="error">+<c:out value="${changeSetDelta.findingsChange}"/></span>
                            </c:when>
                            <c:otherwise>
                              <span class="success"><c:out value="${changeSetDelta.findingsChange}"/></span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                     </c:forEach>
                   </c:forEach>
                 </tr>
              </c:if>
            </c:forEach>
          </tbody>
        </table>
      </div>

      <div style="clear: both">&nbsp;</div>

      <br/>
      
    </c:if>
  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
