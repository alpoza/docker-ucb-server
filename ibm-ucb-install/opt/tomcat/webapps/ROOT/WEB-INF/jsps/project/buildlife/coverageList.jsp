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
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />

<c:url var="plusImage" value="/images/plus.gif"/>
<c:url var="minusImage" value="/images/minus.gif"/>
<c:url var="trendImage" value="/images/icon_note_file_small.gif"/>

<%-- CONTENT --%>

<c:set var="onDocumentLoad" scope="request">
   /* <![CDATA[ */
        <c:forEach var="coverageReport" items="${coverageReportArray}">
            var divName = "${ah3:escapeJs(divMap[coverageReport])}";
            <c:url var="coverageUrl" value="/rest2/trends/coverages/${coverageReport.name}/${buildLife.id}"/>
            var coverageUrl = "${ah3:escapeJs(coverageUrl)}";
            var coverageChart = new CoverageReportChart();
            coverageChart.retrieveCommitData(coverageUrl, null, i18n('CoverageReportsCoverageChartError'), divName);
        </c:forEach>
   /* ]]> */
</c:set>
<c:import url="buildLifeHeader.jsp">
  <c:param name="selected" value="coverage"/>
</c:import>

<div class="data-table_container">
  <br/>
  <h3>${ub:i18n("CoverageReports")} [${fn:length(coverageReportArray)}]</h3>
  <br/>

   <c:if test="${empty coverageReportArray}">
     <div>${ub:i18n("CoverageReportsHelp")}</div>
   </c:if>
   
   <c:url var="highchartsDir" value="/lib/highcharts/js"/>
   <script src="${highchartsDir}/adapters/prototype-adapter.js" type="text/javascript"></script>
   <script src="${highchartsDir}/highcharts.js" type="text/javascript"></script>
   <%-- "c:else" --%>
   <c:forEach var="coverageReport" items="${coverageReportArray}">
     <c:remove var="divName"/>
     <c:set var="divName" value="${divMap[coverageReport]}"/>
     
     <table class="note-table">
       <thead>
         <tr class="align-top">
           <td width="60%">
             <table>
               <tr>
                 <td width="100"><b>${ub:i18n("NameWithColon")}</b></td>
                 <td>${fn:escapeXml(coverageReport.name)}</td>
               </tr>
               <tr>
                 <td width="100"><b>${ub:i18n("TypeWithColon")}</b></td>
                 <td>${fn:escapeXml(coverageReport.coverageType)}</td>
               </tr>
               <tr>
                 <td width="100"><b>${ub:i18n("CoverageReportsNumberOfGroups")}</b></td>
                 <td>${fn:length(coverageReport.coverageGroupArray)}</td>
               </tr>
             </table>
           </td>

           <td valign="top" align="left" width="10%">
             <table>
               <c:if test="${not empty coverageReport.linePercentage}">
               <tr>
                 <td width="60"><b>${ub:i18n("LineWithColon")}</b></td>
                 <td><fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageReport.linePercentage}"/></td>
               </tr>
               </c:if>
               <c:if test="${not empty coverageReport.methodPercentage}">
               <tr>
                 <td width="60"><b>${ub:i18n("MethodWithColon")}</b></td>
                 <td><fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageReport.methodPercentage}"/></td>
               </tr>
               </c:if>
               <c:if test="${not empty coverageReport.branchPercentage}">
               <tr>
                 <td width="60"><b>${ub:i18n("BranchWithColon")}</b></td>
                 <td><fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageReport.branchPercentage}"/></td>
               </tr>
               </c:if>
             </table>
           </td>

           <td valign="middle" align="right" width="10%" rowspan="2">
               <div id="${divName}" style="height: 125px;"></div>
               <c:url var="coverageJsUrl" value="/js/trendcharts/coverageReportChart.js"/>
               <script src="${coverageJsUrl}"></script>
           </td>
         </tr>
         
         <tr>
           <td valign="bottom" colspan="2">
             <c:if test="${!empty coverageReport.coverageGroupArray}">
               <div style="margin-bottom: 3px;">
                 <c:url var="viewCoverageTrendsUrl" value="${BuildLifeTasks.viewCoverageTrends}">
                   <c:param name="buildLifeId" value="${buildLife.id}"/>
                   <c:param name="coverageReportName" value="${coverageReport.name}"/>
                 </c:url>
                 <a href="#" onclick="showPopup('${ah3:escapeJs(fn:escapeXml(viewCoverageTrendsUrl))}', 1000, 600); return false;" title="${ub:i18n('ViewCoverageTrends')}"><img src="${fn:escapeXml(trendImage)}" border="0">${ub:i18n('ViewCoverageTrends')}</a>
               </div>
               <span onclick="$(this).hide(); $(this).next().show();     $(this).up('thead').next().show();" style="white-space: nowrap"><img src="${plusImage}" alt="+"/>${ub:i18n("ShowCoverageGroups")}</span>
               <span onclick="$(this).hide(); $(this).previous().show(); $(this).up('thead').next().hide();" style="white-space: nowrap; display:none;"><img src="${minusImage}" alt="-"/>${ub:i18n("HideCoverageGroups")}</span>
             </c:if>
           </td>
           <!-- td: chart rowspan -->
         </tr>
       </thead>

       <tbody class="covgGrps" style="display:none; margin-bottom: 10px;">
         <tr><td colspan="3"><hr size="1"></td></tr>
         
         <tr><td colspan="3"><b>${ub:i18n("CoverageGroups")}</b></td></tr>
         <tr>
           <td colspan="3">
             <table cellpadding="2" cellspacing="1" class="data-table" width="100%">
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
                 <c:forEach var="coverageGroup" items="${coverageReport.coverageGroupArray}" varStatus="status">
                   <tr valign="top" class="odd">
                     <td>${fn:escapeXml(coverageGroup.name)}</td>
                     <td align="right">
                       <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageGroup.linePercentage}"/>
                       <c:if test="${coverageGroup.linePercentage==null}">${ub:i18n("N/A")}</c:if>
                     </td>
                     <td align="right">
                       <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageGroup.methodPercentage}"/>
                       <c:if test="${coverageGroup.methodPercentage==null}">${ub:i18n("N/A")}</c:if>
                     </td>
                     <td align="right">
                       <fmt:formatNumber type="percent" maxFractionDigits="1" minFractionDigits="1"  value="${coverageGroup.branchPercentage}"/>
                       <c:if test="${coverageGroup.branchPercentage==null}">${ub:i18n("N/A")}</c:if>
                     </td>
                     <td align="right">
                       <fmt:formatNumber maxFractionDigits="3" value="${coverageGroup.complexity}"/>
                       <c:if test="${coverageGroup.complexity==null}">${ub:i18n("N/A")}</c:if>
                     </td>
                   </tr>
                 </c:forEach>
               </tbody>
             </table>
           </td>
         </tr>

       </tbody>
      </table>
      <br/>
    </c:forEach>

</div>

<c:import url="buildLifeFooter.jsp"/>
