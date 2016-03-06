<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.reporting.ReportingTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.reporting.ReportTasks" />
<c:url var="reportingUrl" value="${ReportingTasks.viewReportList}"/>
<c:url var="newReportUrl" value="${ReportTasks.newReport}"/>
<c:url var="viewReportUrl" value="${ReportTasks.viewReport}"/>
<c:url var="imagesUrl" value="/images"/>
<c:url var="queryUrl" value="/rest2/reporting/query"/>
<c:url var="tablesUrl" value="/rest2/reporting/tables"/>
<c:url var="dimensionsUrl" value="/rest2/reporting/dimensions"/>
<c:url var="tablesAndDimensionsUrl" value="/rest2/reporting/tablesAndDimensions"/>
<c:url var="reportsUrl" value="/rest2/reporting/reports"/>
<c:url var="highchartsUrl" value="/lib/highcharts/js"/>
<c:url var="reportCSSUrl" value="/css/reporting/reporting.css"/>
<auth:checkAction var="canCreateReports" action="${UBuildAction.REPORT_CREATE}"/>
<%-- CONTENT --%>
<%-- HEADER --%>
<c:import url="/WEB-INF/snippets/header.jsp">
   <c:param name="title" value="${ub:i18n('Reporting')}"/>
   <c:param name="selected" value="reporting"/>
</c:import>

<link type="text/css" href="${reportCSSUrl}" rel="stylesheet" />
<script src="${highchartsUrl}/adapters/prototype-adapter.js" type="text/javascript"></script>
<script src="${highchartsUrl}/highcharts.js" type="text/javascript"></script>
<script type="text/javascript">
/* <![CDATA[ */
require(["ubuild/module/UBuildApp"], function(UBuildApp) {
 UBuildApp.util.i18nLoaded.then(function() {
  var reportBuilderOptions = {
    imagesUrl : '${ah3:escapeJs(imagesUrl)}',
    queryUrl : '${ah3:escapeJs(queryUrl)}',
    tablesUrl : '${ah3:escapeJs(tablesUrl)}',
    dimensionsUrl : '${ah3:escapeJs(dimensionsUrl)}',
    tablesAndDimensionsUrl : '${ah3:escapeJs(tablesAndDimensionsUrl)}',
    reportsUrl : '${ah3:escapeJs(reportsUrl)}'
  }
  var reportBuilder = new UC_REPORT_BUILDER(reportBuilderOptions);

  var fileInput;

  function clearData() {
      jQuery('#importFile').wrap('<form>').parent('form').trigger('reset');
      jQuery('#importFile').unwrap();
      document.getElementById('importArea').value = "";
      document.getElementById('teamSpaceId').value = "";
      fileInput = null;
  }

  //----------------------------------------------------
  //Initialization
  //----------------------------------------------------
  jQuery(document).ready(function() {

      jQuery('#csvButton').click(function(e) {
          e.preventDefault();
          jQuery('#downloadForm').submit();
      });

      jQuery('#import').click(function(e) {
          e.preventDefault();
          reportBuilder.showImportReportPopup();
      });

      jQuery('#importButton').click(function(e) {
          e.preventDefault();
          reportBuilder.importReport(fileInput);
      });

      jQuery('#importFile').change(function(e) {
          if (window.File && window.FileReader && window.FileList && window.Blob) {
              var file = jQuery("#importFile")[0].files[0];
              var fr = new FileReader();
              fr.onload = function() {
                  fileInput = fr.result;
              }
              fr.readAsText(file);
          }
          else if (window.ActiveXObject) {
              var input = document.getElementById("importFile").value;
              var fso = new ActiveXObject("Scripting.FileSystemObject");
              var file = fso.OpenTextFile(input);
              fileInput = file.ReadAll();
              file.close();
          }
          else {
              var resultHtml = '<span class="error">' + i18n("ImportReportNotSupported") + '</span>';
              jQuery('#importErrorDiv').html(resultHtml).show();
          }
      });

      reportBuilder.getAllSavedReports(function(reports) {
          reportBuilder.queryMap = [];
          reportBuilder.reportMap = [];
          jQuery.each(reports, function(index, report) {
              var rowId = 'report_' + index;
              var reportName = report.name;
              var reportDesc = report.description ? report.description : "";
              var viewReportUrl = '${ah3:escapeJs(viewReportUrl)}?reportName=' + encodeURIComponent(reportName);
              reportBuilder.reportMap[reportName] = report;
              var rowHtml = '<tr id="' + rowId + '"><td>';
              if (report.canEdit) {
                  rowHtml += '<a href="' + viewReportUrl + '" class="viewReport" title="' + i18n('ReportEditReport') + '">';
              }
              rowHtml += jQuery('<div/>').text(i18n(reportName)).html();
              if (report.canEdit) {
                  rowHtml += '</a>';
              }
              rowHtml += '</td><td>' + i18n(reportDesc) +
                  '</td><td style="text-align: center;">';
              if (report.canRun) {
                  rowHtml += '<a href="#run" class="runReport" title="' + i18n('ReportRunReport') + '">' +
                      '<img src="${ah3:escapeJs(imagesUrl)}/icon_run.gif"></a> &nbsp; ';
              }
              else {
                  rowHtml += '<img src="${ah3:escapeJs(imagesUrl)}/icon_run_disabled.gif"> &nbsp; ';
              }
              if (report.canEdit) {
                  rowHtml += '<a href="' + viewReportUrl + '" class="editReport" title="' + i18n('ReportEditReport') + '">' +
                      '<img src="${ah3:escapeJs(imagesUrl)}/icon_pencil_edit.gif"></a> &nbsp; ';
                  rowHtml += '<a href="' + reportBuilderOptions.reportsUrl + '/' + encodeURIComponent(reportName) +
                      '?download=true" class="exportReport" title="' + i18n('Export') + '">' +
                      '<img src="${ah3:escapeJs(imagesUrl)}/icon_export_project.gif"></a> &nbsp; ';
                  rowHtml += '<a href="#delete" class="deleteReport" title="' + i18n('ReportDeleteReport') + '">' +
                      '<img src="${ah3:escapeJs(imagesUrl)}/icon_delete.gif"></a> &nbsp; ';
              }
              else {
                  rowHtml += '<img src="${ah3:escapeJs(imagesUrl)}/icon_pencil_edit_disabled.gif"> &nbsp; ';
                  rowHtml += '<img src="${ah3:escapeJs(imagesUrl)}/icon_delete_disabled.gif"> &nbsp; ';
              }
              rowHtml += '</td></tr>';
              jQuery('#reportListTable tbody').append(rowHtml);
              jQuery('#' + rowId + ' a.runReport').click(function(e) {
                  e.preventDefault();
                  var query = reportBuilder.reportMap[reportName].query;
                  reportBuilder.queryMap[0] = query;
                  reportBuilder.outputConfig = reportBuilder.reportMap[reportName].output;
                  reportBuilder.reportName = reportName;
                  if (reportBuilder.isParameterized(query)) {
                      reportBuilder.showParameterPopup(query);
                  }
                  else {
                      reportBuilder.runReport(reportName);
                  }
              });
              jQuery('#' + rowId + ' a.deleteReport').click(function(e) {
                  e.preventDefault();
                  if (confirmDelete(reportName)) {
                      reportBuilder.deleteSavedReport(reportName, function(response) {
                          jQuery('#' + rowId).remove();
                      });
                  }
              });
          });
      });
  });
 });
});
/* ]]> */
</script>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('Reporting')}" href="${reportingUrl}" enabled="${false}" klass="selected tab"/>
</div>
<div class="contents">
  <br/>
  <br/>
  <div class="component-heading">
    <c:if test="${canCreateReports}">
      <div style="float: right">
        <ucf:button name="NewReport" label="${ub:i18n('NewReport')}" href="${newReportUrl}"/>
        <a href="#import" id="import" class="button">${ub:i18n('Import')}</a>
      </div>
    </c:if>
    ${ub:i18n("Reports")}
  </div>
  <table id="reportListTable" class="data-table">
    <thead>
      <tr>
        <th width="30%">${ub:i18n("Report")}</th>
        <th width="60%">${ub:i18n("Description")}</th>
        <th width="10%">${ub:i18n("Actions")}</th>
      </tr>
    </thead>
    <tbody>
    </tbody>
  </table>

  <%-- modal pop-up for parameters --%>
  <div id="paramModal" class="modalContainer">
    <div id="paramPopup" class="modal">
      <div id="paramContainer"></div>
      <br/>
      <div>
        <a href="#runReport" class="button" onclick="reportBuilder.runReport(); return false;"
            title="${ub:i18n('ReportRunReport')}">${ub:i18n("Run")}</a>
        <a href="#cancelRun" class="close button">${ub:i18n("Cancel")}</a>
      </div>
    </div>
  </div>

  <%-- modal pop-up for running the report --%>
  <div id="reportResultsContainer" class="modalContainer">
    <div id="reportResults" class="modal">
      <div id="downloadButtons" class="downloadButtonBar" style="display: none;">
        <div style="float: right;">
          <a title="${ub:i18n('Close')}"><img class="close" src="${imagesUrl}/reporting/close_modal.png" /></a>
        </div>
        <form id="downloadForm" method="get" target="download" action="${queryUrl}/download">
          <input id="csvQuery" type="hidden" name="query" />
          <a id="csvButton" title="${ub:i18n('DownloadAsCSV')}"><img src="${imagesUrl}/reporting/csv_text.png" /></a>
        </form>
      </div>
      <div id="queryResults"></div>
    </div>
  </div>

  <%-- modal pop-up for importing the report --%>
  <div id="reportImportContainer" class="modalContainer">
    <div id="reportImport" class="modal">
      <div class="system-helpbox">${ub:i18n("ImportReportSystemHelpBox1")}<br/><br/>${ub:i18n("ImportReportSystemHelpBox2")}</div>
      <div id="importErrorDiv" style="display: none;"></div>
      <input type='file' id="importFile">
      <br/><br/>${fn:toUpperCase(ub:i18n("Or"))}<br/><br/>
      <textarea id="importArea" rows="20" cols="80">${fn:escapeXml(requestScope.json)}</textarea>
      <br/><br/>
      <table class="property-table" style="width: 50%;">
        <tbody>
          <tr class="reportCreateOnlyRow">
              <td align="left" width="20%"><span class="bold">${ub:i18n("TeamWithColon")}</span>
              <td align="left">
                  <ucf:idSelector
                      name="${WebConstants.TEAM_SPACE_ID}"
                      list="${teamSpaceList}"
                      multiple="true"
                      optimizeOne="true"
                  />
              </td>
          </tr>
        </tbody>
      </table>
      <br/><br/>
      <a id="importButton" class="button">${ub:i18n('Import')}</a>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" cssclass="close" onclick="clearData()"/>
    </div>
    <script type="text/javascript">
    </script>
  </div>

</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp" />
