<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.reporting.test.TestInstance" %>
<%@ page import="com.urbancode.ubuild.reporting.test.TestTrendView" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error"  uri="error" %>
<%@taglib prefix="ui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

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
            <c:url var="testTrendUrl" value="/rest2/trends/tests/${param.testReportName}/${buildLife.id}/since/${buildLifeSince.id}"/>
            var testTrendUrl = "${ah3:escapeJs(testTrendUrl)}";
            var testChart = new NumTestChart();
            testChart.retrieveCommitData(testTrendUrl, null, i18n('TestTrendChartError'));
        }
   /* ]]> */
</c:set>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<%
  TestTrendView testTrendView = (TestTrendView) request.getAttribute("testTrendView");
%>
  <c:set var="showDuration" value="${testTrendView.report.duration > 0}"/>

  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18nMessage("TestTrendsLabel", fn:escapeXml(param.testReportName))}</a></li>
    </ul>
  </div>
  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("TestTrendsHelp")}
    </div>

    <form action="${fn:escapeXml(actionUrl)}" method="get">
      <input type="hidden" name="${fn:escapeXml(WebConstants.BUILD_LIFE_ID)}" value="${fn:escapeXml(buildLife.id)}"/>
      <input type="hidden" name="testReportName" value="${fn:escapeXml(param.testReportName)}"/>

      <div align="right">
        <br/>
        <span class="required-text">${ub:i18n("RequiredField")}</span>
      </div>

      <table class="property-table">
        <tbody>

          <error:field-error field="${WebConstants.BUILD_LIFE_SINCE_ID}" cssClass="odd"/>
          <tr class="odd" valign="top">
            <td width="20%"><span class="bold">${ub:i18n("Since")} <span class="required-text">*</span></span></td>

            <td width="20%">
                <ucf:trendBuildLifeSelector sinceId="${buildLifeSince.id}" buildLifeList="${buildLifeList}"/>
            </td>
            <td>
              <span class="inlinehelp">${ub:i18n("TestTrendsSinceDesc")}</span>
            </td>
          </tr>
        </tbody>
      </table>
      <br/>
      <ucf:button name="Select" label="${ub:i18n('Select')}"/>
      <ucf:button name="Close" label="${ub:i18n('Close')}" href="javascript:parent.hidePopup();"/>
    </form>


    <c:if test="${not empty buildLifeSince}">

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
        ${ub:i18n("TestTrends")}&nbsp;${fn:escapeXml(buildLife.profile.project.name)} - ${fn:escapeXml(buildLife.profile.workflow.name)}<br/>
        ${ub:i18n("From")} <c:out value="${sinceName}"/>&nbsp;&nbsp;&nbsp;${ub:i18n("To")} <c:out value="${buildLifeName}"/><br/>
        ${ub:i18n("ReportsWithColon")} ${fn:length(testTrendView.reports)}
        <br/>
      </div>
      <br/>

      <table class="generic" style="width: 48%; float: right;">
        <caption>${ub:i18n("TestTrendsTestChanges")}</caption>
        <tr>
          <td width="25%"><span class="bold">${ub:i18n("TestTrendsTestsFixedWithColon")}</span></td>
          <td width="25%">${fn:escapeXml(testTrendView.numberOfTestsFixed)}</td>
          <td width="25%"><span class="bold">${ub:i18n("TestTrendsTestsAddedWithColon")}</span></td>
          <td width="25%">${fn:escapeXml(testTrendView.numberOfTestsAdded)}</td>
        </tr>
        <tr>
          <td width="25%"><span class="bold">${ub:i18n("TestTrendsTestsBrokenWithColon")}</span></td>
          <td width="25%">${fn:escapeXml(testTrendView.numberOfTestsBroken)}</td>
          <td width="25%"><span class="bold">${ub:i18n("TestTrendsTestsRemovedWithColon")}</span></td>
          <td width="25%">${fn:escapeXml(testTrendView.numberOfTestsRemoved)}</td>
        </tr>
      </table>

      <c:set var="successRateChange" value="${testTrendView.successRateChange}"/>
      <c:set var="rateChangeColor">
        <c:choose>
          <c:when test="${successRateChange > 0}">
            #8dd889
          </c:when>
          <c:when test="${successRateChange < 0}">
            #c86f6f
          </c:when>
          <c:otherwise>
            #b0b0b0
          </c:otherwise>
        </c:choose>
      </c:set>
      <table style="width: 48%;" class="generic">
        <caption>${ub:i18n("TestTrendsSuccessRateChange")}</caption>
        <tr>
          <td>
            <table>
              <c:choose>
                <c:when test="${testTrendView.report.numberOfTests eq 0}">
                  <c:set var="successPercentage" value="0"/>
                </c:when>
                <c:otherwise>
                  <c:set var="successPercentage" value="${testTrendView.report.numberOfSuccesses / testTrendView.report.numberOfTests * 100}"/>
                </c:otherwise>
              </c:choose>
              <tr>
                <td><span class="bold">${ub:i18n("CurrentWithColon")}</span></td>
                <td>${fn:escapeXml(testTrendView.report.numberOfSuccesses)} / ${fn:escapeXml(testTrendView.report.numberOfTests)}&nbsp;${ub:i18n("SuccessLowercase")}
              ( <fmt:formatNumber maxFractionDigits="1" minFractionDigits="1" value="${successPercentage}"/>% )</td>
              </tr>
              <c:choose>
                <c:when test="${testTrendView.reportSince.numberOfTests eq 0}">
                  <c:set var="successPercentage" value="0"/>
                </c:when>
                <c:otherwise>
                  <c:set var="successPercentage" value="${testTrendView.reportSince.numberOfSuccesses / testTrendView.reportSince.numberOfTests * 100}"/>
                </c:otherwise>
              </c:choose>
              <tr>
                <td><span class="bold">${ub:i18n("PreviousWithColon")}</span></td>
                <td>${fn:escapeXml(testTrendView.reportSince.numberOfSuccesses)} / ${fn:escapeXml(testTrendView.reportSince.numberOfTests)}&nbsp;${ub:i18n("SuccessLowercase")}
              ( <fmt:formatNumber maxFractionDigits="1" minFractionDigits="1" value="${successPercentage}"/>% )</td>
              </tr>
            </table>
          </td>

          <td align="center" class="bold" style="color: white; background-color: ${fn:escapeXml(rateChangeColor)};">
            <span style="font-size: 24px;font-weight:bold;font-family:Verdana;"><fmt:formatNumber maxFractionDigits="2" minFractionDigits="1" value="${successRateChange * 100}"/>%</span><br/>
            <span style="font-size: 16px;font-weight:bold;font-family:Verdana;">${ub:i18n("ChangeLowercase")}</span>
          </td>
        </tr>
      </table>

      <br/>

      <c:url var="highchartsDir" value="/lib/highcharts/js"/>
      <script src="${highchartsDir}/adapters/prototype-adapter.js" type="text/javascript"></script>
      <script src="${highchartsDir}/highcharts.js" type="text/javascript"></script>

      <table class="generic">
      <tr><td>
        <div id="numTestContainer"></div>
        <c:url var="testTrendJsUrl" value="/js/trendcharts/numTestChart.js"/>
        <script src="${testTrendJsUrl}"></script>
      </td></tr>
      </table>

      <c:set var="detailColspan" value="${showDuration ? '4' : '3'}"/>

      <c:if test="${testTrendView.numberOfTestsFixed > 0}">
        <br/>
        <table class="data-table" style="width: 100%;">
          <caption>${ub:i18n("TestTrendsTestsFixed")}</caption>
          <thead>
            <tr>
              <th>Test</th>
              <th width="20%">${ub:i18n("Suite")}</th>
              <th width="10%">${ub:i18n("Result")}</th>
              <c:if test="${showDuration}">
              <th width="10%">${ub:i18n("Duration")}</th>
              </c:if>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="testInstance" items="${testTrendView.testsFixed}">
            <c:set var="testTitle" value='${ub:i18n("SuiteWithColon")} ${fn:escapeXml(testInstance.suite.name)}'/>
            <tr>
              <td>
                <span title="${ub:i18n('ShowChanges')}"
                      onclick="$(this).up('tr').next().show(); $(this).hide(); $(this).next().show()"><img src="${plusImage}" alt=""/></span>
                <span title="${ub:i18n('HideChanges')}" style="display:none;"
                      onclick="$(this).up('tr').next().hide(); $(this).hide(); $(this).previous().show()"><img src="${minusImage}" alt=""/></span>
                <span title="${fn:escapeXml(testTitle)}">${fn:escapeXml(testInstance.name)}</span></td>
              <td>${fn:escapeXml(testInstance.suite.name)}</td>
              <td class="${fn:escapeXml(testInstance.result)}" style="text-align: center;">${fn:escapeXml(testInstance.result)}</td>
              <c:if test="${showDuration}">
                <td style="text-align: right;"><ui:duration milliseconds="${testInstance.duration}" abbreviated="true" showMillis="true"/></td>
              </c:if>
            </tr>
            <%
              TestInstance testInstance = (TestInstance) pageContext.getAttribute("testInstance");
              pageContext.setAttribute("testCaseChanges", testTrendView.getChangesForTestIntance(testInstance));
            %>
            <tr style="display: none;">
              <td colspan="${detailColspan}" style="background-color: #d8d8d8;">
                <table class="data-table" style="width: 100%;">
                  <c:forEach var="buildLifeChangeSet" items="${testCaseChanges}">
                    <c:set var="changeSet" value="${buildLifeChangeSet.changeSet}"/>
                    <tr>
                      <th>${ub:i18n("Change")}</th>
                      <th>${ub:i18n("Description")}</th>
                      <th width="10%">${ub:i18n("User")}</th>
                      <th width="10%">${ub:i18n("Date")}</th>
                    </tr>
                    <tr class="odd">
                      <td onclick="toggleChangeDetail(this);">
                        <span>
                          ${ub:i18n("Change")}&nbsp;<c:if test="${empty revisionLink}">
                                   ${fn:escapeXml(changeSet.scmId)}
                                 </c:if>
                                 <c:if test="${!empty revisionLink}">
                                   <a href="${revisionLink}" target="srcviewer">${fn:escapeXml(changeSet.scmId)}</a>
                                 </c:if>
                        </span>
                      </td>
                      <td>${ah3:htmlBreaks(fn:escapeXml(changeSet.comment))}</td>
                      <td width="10%" align="center">${fn:escapeXml(changeSet.repositoryUser.repositoryUserName)}</td>
                      <td width="10%" align="center">
                        ${fn:escapeXml(changeSet.changeDate)}
                      </td>
                    </tr>
                  </c:forEach>
                </table>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>

      <c:if test="${testTrendView.numberOfTestsBroken > 0}">
        <br/>
        <table class="data-table" style="width: 100%;">
          <caption>${ub:i18n("TestTrendsTestsBroken")}</caption>
          <thead>
            <tr>
              <th>Test</th>
              <th width="20%">${ub:i18n("Suite")}</th>
              <th width="10%">${ub:i18n("Result")}</th>
              <c:if test="${showDuration}">
              <th width="10%">${ub:i18n("Duration")}</th>
              </c:if>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="testInstance" items="${testTrendView.testsBroken}">
            <%
              TestInstance testInstance = (TestInstance) pageContext.getAttribute("testInstance");
              pageContext.setAttribute("testCaseChanges", testTrendView.getChangesForTestIntance(testInstance));
            %>
            <c:set var="testTitle" value='${ub:i18n("SuiteWithColon")} ${fn:escapeXml(testInstance.suite.name)}'/>
            <tr>
              <td>
                <c:if test="${not empty testCaseChanges}">
                  <span title="${ub:i18n('ShowChanges')}"
                        onclick="$(this).up('tr').next().show(); $(this).hide(); $(this).next().show()"><img src="${plusImage}" alt="+"/></span>
                  <span title="${ub:i18n('HideChanges')}" style="display:none;"
                        onclick="$(this).up('tr').next().hide(); $(this).previous().show(); $(this).hide()"><img src="${minusImage}" alt="-"/></span>
                </c:if>
                <span title="${fn:escapeXml(testTitle)}">${fn:escapeXml(testInstance.name)}</span></td>
              <td>${fn:escapeXml(testInstance.suite.name)}</td>
              <td class="${fn:escapeXml(testInstance.result)}" style="text-align: center;">${fn:escapeXml(testInstance.result)}</td>
              <c:if test="${showDuration}">
                <td style="text-align: right;"><ui:duration milliseconds="${testInstance.duration}" abbreviated="true" showMillis="true"/></td>
              </c:if>
            </tr>
            <c:if test="${not empty testCaseChanges}">
              <tr style="display:none;">
                <td colspan="${detailColspan}" style="background-color: #d8d8d8;">
                  <table class="data-table" style="width: 100%;">
                    <c:forEach var="buildLifeChangeSet" items="${testCaseChanges}">
                      <c:set var="changeSet" value="${buildLifeChangeSet.changeSet}"/>
                      <tr>
                        <th>${ub:i18n("Change")}</th>
                        <th>${ub:i18n("Description")}</th>
                        <th width="10%">${ub:i18n("User")}</th>
                        <th width="10%">${ub:i18n("Date")}</th>
                      </tr>
                      <tr class="odd">
                        <td onclick="toggleChangeDetail(this);">
                          <span>
                            ${ub:i18n("Change")}&nbsp;<c:if test="${empty revisionLink}">
                                     ${fn:escapeXml(changeSet.scmId)}
                                   </c:if>
                                   <c:if test="${!empty revisionLink}">
                                     <a href="${revisionLink}" target="srcviewer">${fn:escapeXml(changeSet.scmId)}</a>
                                   </c:if>
                          </span>
                        </td>

                        <td>${ah3:htmlBreaks(fn:escapeXml(changeSet.comment))}</td>

                        <td width="10%" align="center">${fn:escapeXml(changeSet.repositoryUser.repositoryUserName)}</td>

                        <td width="10%" align="center">
                          ${fn:escapeXml(changeSet.changeDate)}
                        </td>
                      </tr>
                    </c:forEach>
                  </table>
                </td>
              </tr>
            </c:if>
          </c:forEach>
          </tbody>
        </table>
      </c:if>

      <c:if test="${testTrendView.numberOfTestsAdded > 0}">
        <br/>
        <table class="data-table" style="width: 100%;">
          <caption>${ub:i18n("TestTrendsTestsAdded")}</caption>
          <thead>
            <tr>
              <th>${ub:i18n("Test")}</th>
              <th width="20%">${ub:i18n("Suite")}</th>
              <th width="10%">${ub:i18n("Result")}</th>
              <c:if test="${showDuration}">
                <th width="10%">${ub:i18n("Duration")}</th>
              </c:if>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="testInstance" items="${testTrendView.testsAdded}">
            <c:set var="testTitle" value="Suite: ${fn:escapeXml(testInstance.suite.name)}"/>
            <tr>
              <td>
                <span title="${ub:i18n('ShowChanges')}"
                      onclick="$(this).up('tr').next().toggle(); $(this).hide(); $(this).next().show()"><img src="${plusImage}" alt="+"/></span>
                <span title="${ub:i18n('HideChanges')}" style="display:none;"
                      onclick="$(this).up('tr').next().toggle(); $(this).previous().show(); $(this).hide()"><img src="${minusImage}" alt="-"/></span>
                <span title="${fn:escapeXml(testTitle)}">${fn:escapeXml(testInstance.name)}</span>
              </td>
              <td>${fn:escapeXml(testInstance.suite.name)}</td>
              <td class="${fn:escapeXml(testInstance.result)}" style="text-align: center;">${fn:escapeXml(testInstance.result)}</td>
              <c:if test="${showDuration}">
                <td style="text-align: right;"><ui:duration milliseconds="${testInstance.duration}" abbreviated="true" showMillis="true"/></td>
              </c:if>
            </tr>
            <%
              TestInstance testInstance = (TestInstance) pageContext.getAttribute("testInstance");
              pageContext.setAttribute("testCaseChanges", testTrendView.getChangesForTestIntance(testInstance));
            %>
            <tr style="display:none;">
              <td colspan="${detailColspan}" style="background-color: #d8d8d8;">
                <table class="data-table" style="width: 100%;">
                  <c:forEach var="buildLifeChangeSet" items="${testCaseChanges}">
                    <c:set var="changeSet" value="${buildLifeChangeSet.changeSet}"/>
                    <tr>
                      <th>${ub:i18n("Change")}</th>
                      <th>${ub:i18n("Description")}</th>
                      <th width="10%">${ub:i18n("User")}</th>
                      <th width="10%">${ub:i18n("Date")}</th>
                    </tr>
                    <tr class="odd">
                      <td onclick="toggleChangeDetail(this);">
                        <span>
                          ${ub:i18n("Change")}&nbsp;
                          <c:if test="${empty revisionLink}">${fn:escapeXml(changeSet.scmId)}</c:if>
                          <c:if test="${!empty revisionLink}">
                            <a href="${revisionLink}" target="srcviewer">${fn:escapeXml(changeSet.scmId)}</a>
                          </c:if>
                        </span>
                      </td>
                      <td>${ah3:htmlBreaks(fn:escapeXml(changeSet.comment))}</td>
                      <td width="10%" align="center">${fn:escapeXml(changeSet.repositoryUser.repositoryUserName)}</td>
                      <td width="10%" align="center">
                        ${fn:escapeXml(changeSet.changeDate)}
                      </td>
                    </tr>
                  </c:forEach>
                </table>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>

      <c:if test="${testTrendView.numberOfTestsRemoved > 0}">
        <br/>
        <table class="data-table" style="width: 100%;">
          <caption>${ub:i18n("TestTrendsTestsRemoved")}</caption>
          <thead>
            <tr>
              <th>${ub:i18n("Test")}</th>
              <th width="20%">${ub:i18n("Suite")}</th>
              <th width="10%">${ub:i18n("Result")}</th>
              <c:if test="${showDuration}">
                <th width="10%">${ub:i18n("Duration")}</th>
              </c:if>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="testInstance" items="${testTrendView.testsRemoved}">
            <c:set var="testTitle" value="Suite: ${fn:escapeXml(testInstance.suite.name)}"/>
            <tr>
              <td>
                <span title="${ub:i18n('ShowChanges')}"
                      onclick="$(this).up('tr').next().show(); $(this).hide(); $(this).next().show()"><img src="${plusImage}" alt="+"/></span>
                <span title="${ub:i18n('HideChanges')}" style="display:none;"
                      onclick="$(this).up('tr').next().hide(); $(this).hide(); $(this).previous().show()"><img src="${minusImage}" alt="-"/></span>
                <span title="${fn:escapeXml(testTitle)}">${fn:escapeXml(testInstance.name)}</span></td>
              <td>${fn:escapeXml(testInstance.suite.name)}</td>
              <td class="${fn:escapeXml(testInstance.result)}" style="text-align: center;">${fn:escapeXml(testInstance.result)}</td>
              <c:if test="${showDuration}">
                <td style="text-align: right;"><ui:duration milliseconds="${testInstance.duration}" abbreviated="true" showMillis="true"/></td>
              </c:if>
            </tr>
            <%
              TestInstance testInstance = (TestInstance) pageContext.getAttribute("testInstance");
              pageContext.setAttribute("testCaseChanges", testTrendView.getChangesForTestIntance(testInstance));
            %>
            <tr style="display:none;">
              <td colspan="${detailColspan}" style="background-color: #d8d8d8;">
                <table class="data-table" style="width: 100%;">
                  <c:forEach var="buildLifeChangeSet" items="${testCaseChanges}">
                    <c:set var="changeSet" value="${buildLifeChangeSet.changeSet}"/>
                    <tr>
                      <th>${ub:i18n("Change")}</th>
                      <th>${ub:i18n("Description")}</th>
                      <th width="10%">${ub:i18n("User")}</th>
                      <th width="10%">${ub:i18n("Date")}</th>
                    </tr>
                    <tr class="odd">
                      <td onclick="toggleChangeDetail(this);">
                        <span>
                          ${ub:i18n("Change")}&nbsp;<c:if test="${empty revisionLink}">
                                   ${fn:escapeXml(changeSet.scmId)}
                                 </c:if>
                                 <c:if test="${!empty revisionLink}">
                                   <a href="${revisionLink}" target="srcviewer">${fn:escapeXml(changeSet.scmId)}</a>
                                 </c:if>
                        </span>
                      </td>

                      <td>${ah3:htmlBreaks(fn:escapeXml(changeSet.comment))}</td>

                      <td width="10%" align="center">${fn:escapeXml(changeSet.repositoryUser.repositoryUserName)}</td>

                      <td width="10%" align="center">
                        ${fn:escapeXml(changeSet.changeDate)}
                      </td>
                    </tr>
                  </c:forEach>
                </table>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>

      <br/>

      <% pageContext.setAttribute("leastSuccessfulSuites", testTrendView.getLeastSuccessfulSuites(5)); %>
      <table class="data-table" style="width: 100%;">
        <caption>${ub:i18n("TestTrendsLeastSuccessfulSuites")}</caption>
        <thead>
          <tr>
            <th width="70%">${ub:i18n("Suite")}</th>
            <th width="15%">${ub:i18n("SuccessRate")}</th>
            <th width="15%">${ub:i18n("AvgDuration")}</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="testSuite" items="${leastSuccessfulSuites}">
          <tr>
            <td>${fn:escapeXml(testSuite.name)}</td>
            <td style="text-align: center;"><fmt:formatNumber maxFractionDigits="1" minFractionDigits="1" value="${testSuite.successRate * 100}"/>%</td>
            <td style="text-align: right;">${fn:escapeXml(testSuite.formattedAverageDuration)}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>

      <c:if test="${showDuration}">
        <br/>

        <% pageContext.setAttribute("longestSuites", testTrendView.getLongestSuites()); %>
        <table class="data-table" style="width: 100%;">
          <caption>${ub:i18n("TestTrendsLongestRunningSuites")}</caption>
          <thead>
            <tr>
              <th width="70%">${ub:i18n("Suite")}</th>
              <th width="15%">${ub:i18n("SuccessRate")}</th>
              <th width="15%">${ub:i18n("AvgDuration")}</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="testSuite" items="${longestSuites}">
            <tr>
              <td>${fn:escapeXml(testSuite.name)}</td>
              <td style="text-align: center;"><fmt:formatNumber maxFractionDigits="1" minFractionDigits="1" value="${fn:escapeXml(testSuite.successRate * 100)}"/>%</td>
              <td style="text-align: right;">${fn:escapeXml(testSuite.formattedAverageDuration)}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>

        <br/>

        <% pageContext.setAttribute("longestTests", testTrendView.getLongestTests()); %>
        <table class="data-table" style="width: 100%;">
          <caption>${ub:i18n("TestTrendsLongestRunningTests")}</caption>
          <thead>
            <tr>
              <th width="70%">${ub:i18n("Test")}</th>
              <th width="15%">${ub:i18n("TestTrendsAvgSuccessDuration")}</th>
              <th width="15%">${ub:i18n("AvgDuration")}</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="testInstance" items="${longestTests}">
            <fmt:formatNumber var="successPercentage" maxFractionDigits="1" minFractionDigits="1" value="${testInstance.successRate * 100}"/>
            <c:set var="testTitle" value='${ub:i18n("Results")} ${testInstance.numberOfSuccesses}/${testInstance.numberOfTests} ( ${successPercentage}% ) ${ub:i18n("SuiteWithColon")} ${fn:escapeXml(testInstance.suiteName)}'/>
            <tr>
              <td><span title="${fn:escapeXml(testTitle)}">${fn:escapeXml(testInstance.name)}</span></td>
              <td style="text-align: right;">${fn:escapeXml(testInstance.formattedAverageSuccessDuration)}</td>
              <td style="text-align: right;">${fn:escapeXml(testInstance.formattedAverageDuration)}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>

      <br/>

    </c:if>
  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
