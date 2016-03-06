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
<c:set var="clippedCommentWidth" value="60" />

<c:set var="onDocumentLoad" scope="request">
    /* <![CDATA[ */
        if ("${ah3:escapeJs(buildLifeSince)}") {
            <c:url var="coverageTrendUrl" value="/rest2/trends/coverages/${param.coverageReportName}/${buildLife.id}/since/${buildLifeSince.id}"/>
            var coverageTrendUrl = "${ah3:escapeJs(coverageTrendUrl)}";
            var coverageChart = new CoverageChart();
            coverageChart.retrieveCommitData(coverageTrendUrl, null, i18n('CoverageReportsCoverageChartError'));
        }
    /* ]]> */
</c:set>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <li class="current"><a>'${ub:i18nMessage("CoverageTrendsLabel", fn:escapeXml(param.coverageReportName))}'</a></li>
    </ul>
  </div>
  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("CoverageTrendsHelp")}
    </div>

    <form action="${fn:escapeXml(actionUrl)}" method="get">
      <input type="hidden" name="${fn:escapeXml(WebConstants.BUILD_LIFE_ID)}" value="${fn:escapeXml(buildLife.id)}"/>
      <input type="hidden" name="coverageReportName" value="${fn:escapeXml(param.coverageReportName)}"/>

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
              <span class="inlinehelp">${ub:i18n("CoverageTrendsSinceDesc")}</span>
            </td>
          </tr>
        </tbody>
      </table>
      <br/>
      <ucf:button name="Select" label="${ub:i18n('Select')}"/>
      <ucf:button name="Close" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;"/>
    </form>


    <c:if test="${coverageTrendView != null}">

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
        ${ub:i18n("CoverageTrends")}&nbsp;${fn:escapeXml(buildLife.profile.project.name)} - ${fn:escapeXml(buildLife.profile.workflow.name)}<br/>
        ${ub:i18n("From")} <c:out value="${sinceName}"/>&nbsp;&nbsp;&nbsp;${ub:i18n("To")} <c:out value="${buildLifeName}"/><br/>
        ${ub:i18n("ReportsWithColon")} ${fn:length(coverageTrendView.reports)}
        <br/>
      </div>


      <div id="coverage-graph-section" style="margin-top: 0.25em; margin-bottom:0.25em">

      <%-- LINE COVERAGE --%>
      <div style="width: 100%; margin-top: 0.5em;">

        <table width="100%" cellspacing="0" class="generic" style="padding: 9px;">
          <tbody>
            <tr>
              <td align="left" width="33%"><span class="bold">${ub:i18n("LineCoverageChanges")}</span></td>
              <td align="left" width="16%"><span class="bold">${ub:i18n("CurrentWithColon")}</span></td>
              <td align="left" width="17%">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageTrendView.report.linePercentage}"/>
                <c:if test="${coverageTrendView.report.linePercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
              <td align="left" width="16%"><span class="bold">${ub:i18n("PreviousWithColon")}</span></td>
              <td align="left" width="17%">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageTrendView.reportSince.linePercentage}"/>
                <c:if test="${coverageTrendView.reportSince.linePercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <%-- METHOD COVERAGE  --%>
      <div style="width: 100%; margin-top: 0.5em;">

        <table width="100%" cellspacing="0" class="generic" style="padding: 9px;">
          <tbody>
            <tr>
              <td align="left" width="33%"><span class="bold">${ub:i18n("MethodCoverageChanges")}</span></td>
              <td align="left" width="16%"><span class="bold">${ub:i18n("CurrentWithColon")}</span></td>
              <td align="left" width="17%">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageTrendView.report.methodPercentage}"/>
                <c:if test="${coverageTrendView.report.methodPercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
              <td align="left" width="16%"><span class="bold">${ub:i18n("PreviousWithColon")}</span></td>
              <td align="left" width="17%">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageTrendView.reportSince.methodPercentage}"/>
                <c:if test="${coverageTrendView.reportSince.methodPercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
            </tr>
          </tbody>
        </table>

      </div>

      <%-- BRANCH COVERAGE --%>
      <div style="width: 100%; margin-top: 0.5em;">

        <table width="100%" cellspacing="0" class="generic" style="padding: 9px;">
          <tbody>
            <tr>
              <td align="left" width="33%"><span class="bold">${ub:i18n("BranchCoverageChanges")}</span></td>
              <td align="left" width="16%"><span class="bold">${ub:i18n("CurrentWithColon")}</span></td>
              <td align="left" width="17%">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageTrendView.report.branchPercentage}"/>
                <c:if test="${coverageTrendView.report.branchPercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
              <td align="left" width="16%"><span class="bold">${ub:i18n("PreviousWithColon")}</span></td>
              <td align="left" width="17%">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageTrendView.reportSince.branchPercentage}"/>
                <c:if test="${coverageTrendView.reportSince.branchPercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
            </tr>
          </tbody>
        </table>

      </div>

      <%-- COVERAGE GRAPH --%>
      <c:url var="highchartsDir" value="/lib/highcharts/js"/>
      <script src="${highchartsDir}/adapters/prototype-adapter.js" type="text/javascript"></script>
      <script src="${highchartsDir}/highcharts.js" type="text/javascript"></script>

      <div style="margin-top: 0.5em; width: 925px; height: 250px;">
        <div id="coverageChartContainer"></div>
        <c:url var="coverageTrendJsUrl" value="/js/trendcharts/coverageChart.js"/>
        <script src="${coverageTrendJsUrl}"></script>
      </div>

      <div style="clear: both">&nbsp;</div>
      </div><%-- close graph section --%>


      <%-- GROUPS ADDED TABLE --%>
      <c:if test="${!empty coverageTrendView.addedGroups}">
        <br/>
        <table class="data-table" width="100%">
          <caption>${ub:i18n("GroupsAdded")}</caption>
          <thead>
            <tr>
              <th>${ub:i18n("GroupName")}</th>
              <th>${ub:i18n("LineCoverage")}</th>
              <th>${ub:i18n("MethodCoverage")}</th>
              <th>${ub:i18n("BranchCoverage")}</th>
              <th>${ub:i18n("Complexity")}</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="group" items="${coverageTrendView.addedGroups}">
            <tr>
              <td>
                <span>${fn:escapeXml(group.name)}</span>
              </td>
              <td align="right">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${group.linePercentage}"/>
                <c:if test="${group.linePercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
              <td align="right">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${group.methodPercentage}"/>
                <c:if test="${group.methodPercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
              <td align="right">
                <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${group.branchPercentage}"/>
                <c:if test="${group.branchPercentage==null}">${ub:i18n("N/A")}</c:if>
              </td>
              <td align="right">
                <fmt:formatNumber maxFractionDigits="3" value="${group.complexity}"/>
                <c:if test="${group.complexity==null}">${ub:i18n("N/A")}</c:if>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>

      <%-- MOST +/- LINE COVERAGE TABLE --%>
      <c:if test="${!empty coverageTrendView.mostIncreasedLineCoverage || !empty coverageTrendView.mostDecreasedLineCoverage}">
        <div style="margin-top: 0.5em;">

          <table class="data-table" width="48%" style="margin-top: 0.5em; float: left">
            <caption>${ub:i18n("CoverageMostIncreasedLineCoverage")}</caption>
            <thead>
              <tr>
                <th>${ub:i18n("GroupName")}</th>
                <th>${ub:i18n("Coverage")} <small>${ub:i18n("ChangeLowercaseInParentheses")}</small></th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${empty coverageTrendView.mostIncreasedLineCoverage}">
                <tr><td colspan="2" style="text-align: center">${ub:i18n("CoverageNoGroupsIncreased")}</td></tr>
              </c:if>
              <c:forEach var="delta" items="${coverageTrendView.mostIncreasedLineCoverage}">
                <tr>
                  <td>
                    <span>${fn:escapeXml(delta.name)}</span>
                  </td>
                  <td align="right">
                    <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.after.linePercentage}"/>
                    (+<fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.linePercentageDelta}"/>)
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>

          <table class="data-table" width="48%" style="margin-top: 0.5em; float: right">
            <caption>${ub:i18n("CoverageMostDecreasedLineCoverage")}</caption>
            <thead>
              <tr>
                <th>${ub:i18n("GroupName")}</th>
                <th>${ub:i18n("Coverage")} <small>${ub:i18n("ChangeLowercaseInParentheses")}</small></th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${empty coverageTrendView.mostDecreasedLineCoverage}">
                <tr><td colspan="2" style="text-align: center">${ub:i18n("CoverageNoGroupsDecreased")}</td></tr>
              </c:if>
              <c:forEach var="delta" items="${coverageTrendView.mostDecreasedLineCoverage}">
                <tr>
                  <td>
                    <span>${fn:escapeXml(delta.name)}</span>
                  </td>
                  <td align="right">
                    <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.after.linePercentage}"/>
                    (<fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.linePercentageDelta}"/>)
                  </td>
                 </tr>
              </c:forEach>
            </tbody>
          </table>

          <div style="clear:both;">&nbsp;</div>
        </div>
      </c:if>


      <%-- MOST +/- METHOD COVERAGE TABLE --%>
      <c:if test="${!empty coverageTrendView.mostIncreasedMethodCoverage || !empty coverageTrendView.mostDecreasedMethodCoverage}">
        <div style="margin-top: 0.5em;">

          <table class="data-table" width="48%" style="margin-top: 0.5em; float: right">
            <caption>${ub:i18n("CoverageMostIncreasedMethodCoverage")}</caption>
            <thead>
              <tr>
                <th>${ub:i18n("GroupName")}</th>
                <th>${ub:i18n("Coverage")} <small>${ub:i18n("ChangeLowercaseInParentheses")}</small></th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${empty coverageTrendView.mostIncreasedMethodCoverage}">
                <tr><td colspan="2" style="text-align: center">${ub:i18n("CoverageNoGroupsIncreased")}</td></tr>
              </c:if>
              <c:forEach var="delta" items="${coverageTrendView.mostIncreasedMethodCoverage}">
                <tr>
                  <td>
                    <span>${fn:escapeXml(delta.name)}</span>
                  </td>
                  <td align="right">
                    <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.after.methodPercentage}"/>
                    (+<fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.methodPercentageDelta}"/>)
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>

          <table class="data-table" width="48%" style="margin-top: 0.5em; float: left">
            <caption>${ub:i18n("CoverageMostDecreasedMethodCoverage")}</caption>
            <thead>
              <tr>
                <th>${ub:i18n("GroupName")}</th>
                <th>${ub:i18n("Coverage")} <small>${ub:i18n("ChangeLowercaseInParentheses")}</small></th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${empty coverageTrendView.mostDecreasedMethodCoverage}">
                <tr><td colspan="2" style="text-align: center">${ub:i18n("CoverageNoGroupsDecreased")}</td></tr>
              </c:if>
              <c:forEach var="delta" items="${coverageTrendView.mostDecreasedMethodCoverage}">
                <tr>
                  <td>
                    <span>${fn:escapeXml(delta.name)}</span>
                  </td>
                  <td align="right">
                    <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.after.methodPercentage}"/>
                    (<fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.methodPercentageDelta}"/>)
                  </td>
                 </tr>
              </c:forEach>
            </tbody>
          </table>

          <div style="clear:both;">&nbsp;</div>
        </div>
      </c:if>

      <%-- MOST +/- BRANCH COVERAGE TABLE --%>
      <c:if test="${!empty coverageTrendView.mostIncreasedBranchCoverage || !empty coverageTrendView.mostDecreasedBranchCoverage}">
        <div style="margin-top: 0.5em;">

          <table class="data-table" width="48%" style="margin-top: 0.5em; float: left">
            <caption>${ub:i18n("CoverageMostIncreasedBranchCoverage")}</caption>
            <thead>
              <tr>
                <th>${ub:i18n("GroupName")}</th>
                <th>${ub:i18n("Coverage")} <small>${ub:i18n("ChangeLowercaseInParentheses")}</small></th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${empty coverageTrendView.mostIncreasedBranchCoverage}">
                <tr><td colspan="2" style="text-align: center">${ub:i18n("CoverageNoGroupsIncreased")}</td></tr>
              </c:if>
              <c:forEach var="delta" items="${coverageTrendView.mostIncreasedBranchCoverage}">
                <tr>
                  <td>
                    <span>${fn:escapeXml(delta.name)}</span>
                  </td>
                  <td align="right">
                    <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.after.branchPercentage}"/>
                    (+<fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.branchPercentageDelta}"/>)
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>

          <table class="data-table" width="48%" style="margin-top: 0.5em; float: right">
            <caption>${ub:i18n("CoverageMostDecreasedBranchCoverage")}</caption>
            <thead>
              <tr>
                <th>${ub:i18n("GroupName")}</th>
                <th>${ub:i18n("Coverage")} <small>${ub:i18n("ChangeLowercaseInParentheses")}</small></th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${empty coverageTrendView.mostDecreasedBranchCoverage}">
                <tr><td colspan="2" style="text-align: center">${ub:i18n("CoverageNoGroupsDecreased")}</td></tr>
              </c:if>
              <c:forEach var="delta" items="${coverageTrendView.mostDecreasedBranchCoverage}">
                <tr>
                  <td>
                    <span>${fn:escapeXml(delta.name)}</span>
                  </td>
                  <td align="right">
                    <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.after.branchPercentage}"/>
                    (<fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${delta.branchPercentageDelta}"/>)
                  </td>
                 </tr>
              </c:forEach>
            </tbody>
          </table>

          <div style="clear:both;">&nbsp;</div>
        </div>
      </c:if>

      <%-- MOST +/- COMPLEXITY COVERAGE TABLE --%>
      <c:if test="${!empty coverageTrendView.mostIncreasedComplexity || !empty coverageTrendView.mostDecreasedComplexity}">
        <div style="margin-top: 0.5em;">

          <table class="data-table" width="48%" style="margin-top: 0.5em; float: left">
            <caption>${ub:i18n("CoverageMostIncreasedComplexity")}</caption>
            <thead>
              <tr>
                <th>${ub:i18n("GroupName")}</th>
                <th>${ub:i18n("Complexity")} <small>${ub:i18n("ChangeLowercaseInParentheses")}</small></th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${empty coverageTrendView.mostIncreasedComplexity}">
                <tr><td colspan="2" style="text-align: center">${ub:i18n("CoverageNoGroupsIncreased")}</td></tr>
              </c:if>
              <c:forEach var="delta" items="${coverageTrendView.mostIncreasedComplexity}">
                <tr>
                  <td>
                    <span>${fn:escapeXml(delta.name)}</span>
                  </td>
                  <td align="right">
                    <fmt:formatNumber maxFractionDigits="3" minFractionDigits="1"  value="${delta.after.complexity}"/>
                    (+<fmt:formatNumber maxFractionDigits="3" minFractionDigits="1"  value="${delta.complexityDelta}"/>)
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>

          <table class="data-table" width="48%" style="margin-top: 0.5em; float: right">
            <caption>${ub:i18n("CoverageMostDecreasedComplexity")}</caption>
            <thead>
              <tr>
                <th>${ub:i18n("GroupName")}</th>
                <th>${ub:i18n("Complexity")} <small>${ub:i18n("ChangeLowercaseInParentheses")}</small></th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${empty coverageTrendView.mostDecreasedComplexity}">
                <tr><td colspan="2" style="text-align: center">${ub:i18n("CoverageNoGroupsDecreased")}</td></tr>
              </c:if>
              <c:forEach var="delta" items="${coverageTrendView.mostDecreasedComplexity}">
                <tr>
                  <td>
                    <span>${fn:escapeXml(delta.name)}</span>
                  </td>
                  <td align="right">
                    <fmt:formatNumber maxFractionDigits="3" minFractionDigits="1"  value="${delta.after.complexity}"/>
                    (<fmt:formatNumber maxFractionDigits="3" minFractionDigits="1"  value="${delta.complexityDelta}"/>)
                  </td>
                 </tr>
              </c:forEach>
            </tbody>
          </table>

          <div style="clear:both;">&nbsp;</div>
        </div>
      </c:if>
    </c:if>
  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
