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

<%@page import="com.urbancode.ubuild.web.project.BuildLifeTasks" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />

<c:url var="plusImage" value="/images/plus.gif"/>
<c:url var="minusImage" value="/images/minus.gif"/>
<c:url var="trendImage" value="/images/icon_note_file_small.gif"/>

<c:import url="buildLifeHeader.jsp">
  <c:param name="selected" value="tests"/>
</c:import>

<style type="text/css">
table.data-table td.test_suite_details {
    background:#cfdbef;
    padding: 10px 15px;

}
</style>
<script type="text/javascript">
function toggleTestReport(element, id) {
    if ($(id).visible()) {
        $(element).down('img').src = '${plusImage}';
        $(element).down('span').update(i18n("ShowTestSuites"));
        $(id).hide();
    } else {
        $(element).down('img').src = '${minusImage}';
        $(element).down('span').update(i18n("HideTestSuites"));
        $(id).show();
    }
}
function toggleTestReportTestSuites(element, id) {
    var doShow = $(element).down('img').src.endsWith('${plusImage}');
    if (doShow) {
    	$(element).title = i18n("HideAllTests");
        $(element).down('img').src = '${minusImage}';
    } else {
        $(element).title = i18n("ShowAllTests");
        $(element).down('img').src = '${plusImage}';
    }
    $$('.test_suite').each(
        function(testSuite) {
            if (testSuite.id.startsWith(id)) {
                if (doShow) {
                	showTestSuite($(testSuite.id + "-toggle"), testSuite.id);
                } else {
                	hideTestSuite($(testSuite.id + "-toggle"), testSuite.id);
                }
            }
        }
    );
}
function toggleTestSuite(element, id) {
    if ($(id).visible()) {
        hideTestElement(element, id, i18n("ShowTests"));
    } else {
        showTestElement(element, id, i18n("HideTests"));
    }
}
function toggleTestDetails(element, id) {
    if ($(id).visible()) {
        hideTestElement(element, id, i18n("ShowDetails"));
    } else {
        showTestElement(element, id, i18n("HideDetails"));
    }
}
function hideTestElement(element, id, newTitle) {
    $(element).title = newTitle;
    $(element).down().src = '${plusImage}';
    $(id).hide();
}
function showTestElement(element, id, newTitle) {
    $(element).title = newTitle;
    $(element).down().src = '${minusImage}';
    $(id).show();
}
</script>

<div class="data-table_container">

  <br/>
  <h3>${ub:i18n("TestReports")} [${fn:length(testReports)}]</h3>
  <br/>

   <c:if test="${empty testReports}">
     ${ub:i18n("NoTestsOnBuildLife")}
   </c:if>
   <%-- "c:else" --%>
   <c:forEach var="testReport" items="${testReports}" varStatus="indx">
     <table class="note-table">
       <thead>
         <tr>
           <td width="60%">
             <table>
               <tr>
                 <td width="100"><b>${ub:i18n("NameWithColon")}</b></td>
                 <td>${fn:escapeXml(testReport.name)}</td>
               </tr>
               <%--
               <tr>
                 <td width="100"><b>Type:</b></td>
                 <td>${fn:escapeXml(testReport.testType)}</td>
               </tr>
                --%>
               <tr>
                 <td width="100"><b>${ub:i18n("TestsNumberOfSuites")}</b></td>
                 <td>${fn:escapeXml(testReport.numberOfSuites)}</td>
               </tr>
               <c:set var="testSuites" value="${testReport.sortedTestSuites}"/>
               <c:if test="${!empty testSuites}">
                 <tr valign="bottom">
                   <td width="100" colspan="2">
                     <br/>
                     <span onclick="toggleTestReport(this, 'report-${fn:escapeXml(testReport.id)}-testsuites');" style="cursor: pointer;">
                       <img src="${minusImage}" style="vertical-align: middle;"/>
                       <span>${ub:i18n("HideTestSuites")}</span>
                     </span>
                     <br/>
                     <br/>
                     <c:url var="viewTestTrendsUrl" value="${BuildLifeTasks.viewTestTrends}">
                       <c:param name="buildLifeId" value="${buildLife.id}"/>
                       <c:param name="testReportName" value="${testReport.name}"/>
                     </c:url>
                     <a href="javascript:showPopup('${ah3:escapeJs(viewTestTrendsUrl)}', 1000, 600);" title="${ub:i18n('ViewTestTrends')}">
                        <img src="${fn:escapeXml(trendImage)}" border="0" style="vertical-align: middle;">&nbsp;${ub:i18n("ViewTestTrends")}</a>
                   </td>
                 </tr>
               </c:if>
             </table>
           </td>

           <td valign="middle" align="right" width="40%">
             <c:choose>
               <c:when test="${testReport.numberOfTests eq 0}">
                 <c:set var="successPercentage" value="0"/>
               </c:when>
               <c:otherwise>
                 <c:set var="successPercentage" value="${testReport.numberOfSuccesses / testReport.numberOfTests * 100}"/>
               </c:otherwise>
             </c:choose>
             <strong>${ub:i18n("TestResults")}</strong> ${fn:escapeXml(testReport.numberOfSuccesses)} / ${fn:escapeXml(testReport.numberOfTests)}&nbsp;${ub:i18n("Success")}
             ( <fmt:formatNumber maxFractionDigits="1" minFractionDigits="1" value="${successPercentage}"/>% )
             <br/>
             <c:if test="${testReport.numberOfTests > 0}">
             <c:set var="chartUrl" value="${chartMap[testReport]}"/>
             <c:if test="${!empty chartUrl}"><img src="${fn:escapeXml(chartUrl)}" alt=""></c:if>
             </c:if>
           </td>
         </tr>

       </thead>

       <tbody id="report-${fn:escapeXml(testReport.id)}-testsuites">

         <tr><td colspan="2"><hr size="1"></td></tr>
         <tr>
            <td colspan="2">
             <span onclick="toggleTestReportTestSuites(this, 'report-${fn:escapeXml(testReport.id)}');" class="bold"
                   style="cursor: pointer;" title="${ub:i18n('ShowAllTests')}">
               <img src="${plusImage}" style="vertical-align: middle;"/>
               Test Suites
             </span>
           </td>
         </tr>
         <tr><td colspan="2">

           <table class="data-table">

           <c:forEach var="testSuite" items="${testSuites}" varStatus="status">

            <tr valign="top">
              <td width="75%">
                <span id="report-${fn:escapeXml(testReport.id)}-${status.index}-toggle"
                      onclick="toggleTestSuite(this, 'report-${fn:escapeXml(testReport.id)}-${status.index}');"
                      style="cursor: pointer;" title="${ub:i18n('ShowTests')}">
                  <img src="${plusImage}" style="vertical-align: middle;"/>
                  ${fn:escapeXml(testSuite.name)}
                </span>
              </td>
              <td width="10%" align="center" nowrap="nowrap"><ui:duration milliseconds="${testSuite.duration}" abbreviated="true" showMillis="true"/></td>
              <c:choose>
                <c:when test="${testSuite.numberOfSuccesses < testSuite.numberOfTests}"><c:set var="testSuiteResultClass" value="failure"/></c:when>
                <c:otherwise><c:set var="testSuiteResultClass" value="success"/></c:otherwise>
              </c:choose>
              <td width="15%" align="right" nowrap="nowrap" class="${testSuiteResultClass}">
                <c:if test="${testSuite.numberOfTests > 0}">
                ${fn:escapeXml(testSuite.numberOfSuccesses)} / ${fn:escapeXml(testSuite.numberOfTests)}&nbsp;${ub:i18n("SuccessLowercase")}
                  ( <fmt:formatNumber maxFractionDigits="1" minFractionDigits="1" value="${testSuite.numberOfSuccesses / testSuite.numberOfTests * 100}"/>% )
                </c:if>
              </td>
            </tr>
            <tr id="report-${fn:escapeXml(testReport.id)}-${status.index}" class="test_suite" style="display: none;">
              <td class="test_suite_details" colspan="3">
                <table style="table-layout: fixed;" class="data-table">
                  <c:forEach var="testInstance" items="${testSuite.tests}" varStatus="testStatus">
                    <c:set var="testHasMessage" value="${fn:length(testInstance.message) > 0}" scope="page"/>
                    <c:set var="testId" value="test-${fn:escapeXml(testReport.id)}-${testStatus.index}"/>
                    <tr valign="top" class="odd">
                      <td width="80%">
                        <c:if test="${testHasMessage}">
                          <span onclick="toggleTestDetails(this, '${fn:escapeXml(testId)}');"
                                style="cursor: pointer;" title="${ub:i18n('ShowTests')}">
                            <img src="${minusImage}" style="vertical-align: middle;"/>
                          </span>
                        </c:if>
                        ${fn:escapeXml(testInstance.name)}
                      </td>
                      <td width="10%" align="center"><ui:duration milliseconds="${testInstance.duration}" abbreviated="true" showMillis="true"/></td>
                      <c:set var="testResult" value="${testInstance.success ? 'success' : 'failure'}"/>
                      <td width="10%" align="center" class="${testResult}">${testResult}</td>
                    </tr>
                    <c:if test="${testHasMessage}">
                      <tr valign="top" class="even" id="${testId}">
                          <td colspan="3"><div style="overflow: auto;"><pre style="overflow: auto;">${fn:escapeXml(testInstance.message)}</pre></div></td>
                      </tr>
                    </c:if>
                  </c:forEach>
                </table>
              </td>
            </tr>

           </c:forEach>
           </table>
         </td></tr>

       </tbody>
      </table>
     <br/>

    </c:forEach>

</div>

<c:import url="buildLifeFooter.jsp"/>
