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
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.reporting.ReportingTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.reporting.ReportTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<c:url var="reportingUrl" value="${ReportingTasks.viewReportList}"/>
<c:url var="imagesUrl" value="/images"/>
<c:url var="queryUrl" value="/rest2/reporting/query"/>
<c:url var="tablesUrl" value="/rest2/reporting/tables"/>
<c:url var="dimensionsUrl" value="/rest2/reporting/dimensions"/>
<c:url var="tablesAndDimensionsUrl" value="/rest2/reporting/tablesAndDimensions"/>
<c:url var="reportsUrl" value="/rest2/reporting/reports"/>
<c:url var="securityUrl" value="${ResourceTasks.viewResource}"/>
<c:url var="highchartsUrl" value="/lib/highcharts/js"/>
<c:url var="reportCSSUrl" value="/css/reporting/reporting.css"/>
<%-- CONTENT --%>
<%-- HEADER --%>
<c:set var="onDocumentLoad" scope="request">
  var reportBuilderOptions = {
    imagesUrl : '${ah3:escapeJs(imagesUrl)}',
    queryUrl : '${ah3:escapeJs(queryUrl)}',
    tablesUrl : '${ah3:escapeJs(tablesUrl)}',
    dimensionsUrl : '${ah3:escapeJs(dimensionsUrl)}',
    tablesAndDimensionsUrl : '${ah3:escapeJs(tablesAndDimensionsUrl)}',
    reportsUrl : '${ah3:escapeJs(reportsUrl)}'
  }
  reportBuilder = new UC_REPORT_BUILDER(reportBuilderOptions);


  //----------------------------------------------------
  //Initialization
  //----------------------------------------------------
  jQuery(document).ready(function() {
    reportBuilder.getAllTables();
    reportBuilder.getAllDimensions();

     // if close button is clicked
     jQuery('.modal .close').click(function(e) {
         // Cancel the link behavior
         e.preventDefault();
         reportBuilder.closeModals();
     });

     jQuery('#runButton').click(function(e) {
         e.preventDefault();
         if (!reportBuilder.reportRunning) {
             reportBuilder.runReport();
         }
     });

     jQuery('#saveButton').click(function(e) {
       e.preventDefault();
       if (jQuery('input[name=reportName]').val()) {
           reportBuilder.saveReport();
       }
       else {
         alert(i18n('ReportNameDesc'));
       }
     });

     jQuery('#csvButton').click(function(e) {
       e.preventDefault();
       jQuery('#downloadForm').submit();
     });

     jQuery('#manualQueryButton').click(function(e) {
       e.preventDefault();
       reportBuilder.toggleManualQuery();
     });

     <c:choose>
       <c:when test="${not empty param.reportName}">
         reportBuilder.getSavedReport('${ah3:escapeJs(param.reportName)}', function(report) {
           var securityUrl = '${ah3:escapeJs(securityUrl)}?resourceId=' + report.resourceId;
           jQuery('#securityTabLink').click(function(e) {
             e.preventDefault();
             showPopup(securityUrl, 800, 600);
           });
         });
       </c:when>
     <c:otherwise>
       reportBuilder.newReport();
     </c:otherwise>
   </c:choose>
  });
</c:set>
<c:set var="headContent" scope="request">
  <script type="text/javascript">
    var reportBuilder;
  </script>
</c:set>
<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value='${ub:i18n("ReportingWithColon")} ${empty param.reportName ? ub:i18n("NewReport") : param.reportName}'/>
  <c:param name="selected" value="reporting"/>
</c:import>

<link type="text/css" href="${reportCSSUrl}" rel="stylesheet" />
<script src="${highchartsUrl}/adapters/prototype-adapter.js" type="text/javascript"></script>
<script src="${highchartsUrl}/highcharts.js" type="text/javascript"></script>


<c:url var="securityTabUrl" value='${ResourceTasks.viewResource}'>
  <c:param name="resourceId" value="${project.securityResourceId}"/>
</c:url>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('Reporting')}" href="${reportingUrl}" klass="selected tab"/>
  <c:if test="${not empty param.reportName}">
    <ucf:link label="${ub:i18n('Security')}" id="securityTabLink" href="" klass="tab"/>
  </c:if>
</div>
<div class="contents">
  <br/>
  <br/>

  <%-- modal pop-up for running the report --%>
  <div id="reportResultsContainer" class="modalContainer">
    <div id="reportResults" class="modal">
      <div id="downloadButtons" class="downloadButtonBar" style="display: none;">
        <div style="float: right;">
          <a title="${ub:i18n('Close')}"><img class="close" src="${imagesUrl}/reporting/close_modal.png" /></a>
        </div>
        <form id="downloadForm" method="get" target="download" action="${queryUrl}/download" accept="text/csv">
          <input id="csvQuery" type="hidden" name="query" />
          <a id="csvButton" title="${ub:i18n('DownloadAsCSV')}"><img src="${imagesUrl}/reporting/csv_text.png" /></a>
        </form>
      </div>
      <div id="queryResults"></div>
    </div>
  </div>

  <%-- modal pop-up to restrict report table columns --%>
  <div id="columnsContainer" class="modalContainer">
    <div id="columns" class="modal">
      <img src="${imagesUrl}/reporting/table.png" class="table_icon" />
      <h1 id="columnsTable" class="table_title"></h1>
      <br />
      <br />
      <br /> ${ub:i18n("ReportColumnsDesc")}<br /> <br />
      <div style="padding-bottom: 5px; text-align: center;">
        <a href="#all" class="normal_link" onclick="reportBuilder.includeAllColumns(); return false;">${ub:i18n("All")}</a>
        &nbsp; <a href="#none" class="normal_link" onclick="reportBuilder.removeAllColumns(); return false;">${ub:i18n("None")}</a>
      </div>
      <table>
        <tr valign="top">
          <td id="reportColumns">
            <table class="data-table">
              <thead><tr><th nowrap="nowrap">${ub:i18n("ReportColumnToInclude")}</th><th>&nbsp;</th></tr></thead>
              <tbody></tbody>
            </table>
          </td>
          <td id="includedReportColumns">
            <table class="data-table">
              <thead><tr><th colspan="2" nowrap="nowrap">${ub:i18n("ReportIncludedColumns")}</th><th>${ub:i18n("Alias")}</th><th>${ub:i18n("Function")}</th><th>&nbsp;</th></tr></thead>
              <tbody></tbody>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <a href="#addCompoundColumn" onclick="reportBuilder.includeCompoundColumn(); return false;">${ub:i18n("ReportAddCompoundColumn")}</a>
          </td>
        </tr>
      </table>
      <br /> <br />
      <a href="#updateColumns" class="button" onclick="reportBuilder.updateColumns(); return false;">${ub:i18n("Apply")}</a>
      <a href="#cancel" class="close button">${ub:i18n('Cancel')}</a>
    </div>
  </div>

  <%-- modal pop-up to add/edit a filter --%>
  <div id="filterContainer" class="modalContainer">
    <div id="filter" class="modal">
      <h1 class="table_title">${ub:i18n("ReportAddAFilter")}</h1>
      <br /><br /><br />
      <div class="filter">
        <table>
          <tbody>
            <tr>
              <td class="form_label">${ub:i18n("ColumnWithColon")}</td>
              <td>
                <select id="filterColumn" onchange="reportBuilder.filterColumnSelected();"></select><br />
                <span id="filterColumnDesc"></span>
              </td>
            </tr>
            <tr>
              <td class="form_label">${ub:i18n("ReportFilterType")}</td>
              <td>
                <select id="filterType" name="filterType" onchange="reportBuilder.filterTypeChanged();">
                  <option value="equals">${ub:i18n("equals")}</option>
                  <option value="like">${ub:i18n("like")}</option>
                  <option value="not_like">${ub:i18n("not_like")}</option>
                  <option value="not">${ub:i18n("not")}</option>
                  <option value="in">${ub:i18n("in")}</option>
                  <option value="not_null">${ub:i18n("not_null")}</option>
                  <option value="is_null">${ub:i18n("is_null")}</option>
                  <option>&gt;</option>
                  <option>&gt;=</option>
                  <option>&lt;</option>
                  <option>&lt;=</option>
                </select>
              </td>
            </tr>
          </tbody>
          <tbody id="filterValueTypeDiv" class="filterValueConfig">
            <tr>
              <td class="form_label">${ub:i18n("ValueWithColon")}</td>
              <td>
                <input type="radio" name="filterValueType" onclick="reportBuilder.filterValueTypeChanged();" value="enter"> ${ub:i18n("ReportValueEnterValue")}<br/>
                <input type="radio" name="filterValueType" onclick="reportBuilder.filterValueTypeChanged();" value="select"> ${ub:i18n("ReportValueSelectValue")}<br/>
                <input type="radio" name="filterValueType" onclick="reportBuilder.filterValueTypeChanged();" value="param"> ${ub:i18n("ReportValueParameterValue")}
              </td>
            </tr>
          </tbody>
          <tbody id="filterEnterValueDiv" class="filterValueConfig">
            <tr>
              <td></td>
              <td>
                <input id="filterValue" name="filterValue" type="text" value="" size="40"/>
              </td>
            </tr>
          </tbody>
          <tbody id="filterEnterValuesDiv" class="filterValueConfig">
            <tr>
              <td></td>
              <td>
                <textarea id="filterValues" name="filterValues" cols="40" rows="5" title="${ub:i18n('EnterEachValueOnANewLine')}"></textarea>
              </td>
            </tr>
          </tbody>
          <tbody id="filterSelectValueDiv" class="filterValueConfig">
            <tr>
              <td></td>
              <td>
                <select id="filterSelectValue" name="filterSelectValue"></select>
              </td>
            </tr>
          </tbody>
          <tbody id="filterSelectValuesDiv" class="filterValueConfig">
            <tr>
              <td></td>
              <td>
                <select id="filterSelectValues" name="filterSelectValues" multiple="multiple"></select>
              </td>
            </tr>
          </tbody>
          <tbody id="filterParamValueDiv" class="filterValueConfig">
            <tr>
              <td class="form_label">${ub:i18n("LabelWithColon")}</td>
              <td>
                <input id="filterParamLabel" name="filterParamLabel" type="text" value="" />
              </td>
            </tr>
            <tr>
              <td class="form_label">${ub:i18n("ReportInputType")}</td>
              <td>
                <select id="filterParamType" name="filterParamType">
                  <option value="enter">${ub:i18n("ReportValueEnterValue")}</option>
                  <option value="select">${ub:i18n("ReportValueSelectValue")}</option>
                </select>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="white-box">
        <br /> <br />
        <a href="#addFilter" class="button" onclick="reportBuilder.addFilter(); return false;">${ub:i18n("Apply")}</a>
        <a href="#cancelFilter" class="close button">${ub:i18n("Cancel")}</a>
      </div>
    </div>
  </div>

  <%-- modal pop-up for ordering results --%>
  <div id="orderContainer" class="modalContainer">
    <div id="order" class="modal">
      <img src="${imagesUrl}/reporting/table.png" class="table_icon" />
      <h1 class="table_title"></h1>
      <br />
      <br />
      <br /> ${ub:i18n("ReportOrderingDesc")}<br /> <br />
      <table id="orderTable" class="data-table">
        <thead><tr><th colspan="2" nowrap="nowrap">${ub:i18n("Column")}</th><th>${ub:i18n("Order")}</th><th>&nbsp;</th></tr></thead>
        <tbody></tbody>
      </table>
      <br/>
      <a href="#addOrder" onclick="reportBuilder.addOrdering(); return false;">${ub:i18n("ReportAddOrdering")}</a>
      <br /> <br />
      <a href="#updateOrdering" class="button" onclick="reportBuilder.updateOrdering(); return false;">${ub:i18n("Apply")}</a>
      <a href="#cancel" class="close button">${ub:i18n("Cancel")}</a>
    </div>
  </div>


  <%-- modal pop-up to join to another table --%>
  <div id="joinContainer" class="modalContainer">
    <div id="join" class="modal">
      <img src="${imagesUrl}/reporting/join.png" class="table_icon" />
      <h1 class="table_title">${ub:i18n("Join")}</h1>
      <br /><br /><br />
      <div class="join">
        <table>
          <tbody>
            <tr>
              <td class="form_label">${ub:i18n("Table")}</td>
              <td><span id="joinTable"></span></td>
            </tr>
            <tr>
              <td class="form_label">${ub:i18n("AliasWithColon")}</td>
              <td><input id="joinAlias" type="text" value="" /></td>
            </tr>
            <tr>
              <td class="form_label">${ub:i18n("JoinWithColon")}</td>
              <td><select id="joinTableSelect"></select></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="white-box">
        <br /> <br />
        <a href="#addJoin" class="button" onclick="reportBuilder.addJoin(); return false;">${ub:i18n("Apply")}</a>
        <a href="#cancelJoin" class="close button">${ub:i18n("Cancel")}</a>
      </div>
    </div>
  </div>


  <%-- modal pop-up to configure report output to graph --%>
  <div id="outputConfigContainer" class="modalContainer">
    <div id="outputConfig" class="modal">
      <table>
        <tbody>
          <tr>
            <td class="form_label">${ub:i18n("ReportOutputType")}</td>
            <td>
              <select name="outputType">
              <%-- AREA_CHART, AREASPLINE_CHART, BAR_CHART, COLUMN_CHART, LINE_CHART, PIE_CHART, SCATTER_CHART, SPLINE_CHART; --%>
                <option value="AREA_CHART">${ub:i18n("ReportOutputTypeArea")}</option>
                <option value="AREASPLINE_CHART">${ub:i18n("ReportOutputTypeAreaSpline")}</option>
                <option value="BAR_CHART">${ub:i18n("ReportOutputTypeBar")}</option>
                <option value="COLUMN_CHART">${ub:i18n("ReportOutputTypeColumn")}</option>
                <option value="LINE_CHART">${ub:i18n("ReportOutputTypeLine")}</option>
                <option value="PIE_CHART">${ub:i18n("ReportOutputTypePie")}</option>
                <option value="SCATTER_CHART">${ub:i18n("ReportOutputTypeScatter")}</option>
                <option value="SPLINE_CHART">${ub:i18n("ReportOutputTypeSpline")}</option>
              </select>
            </td>
          </tr>
        </tbody>
        <tbody id="chartConfig">
          <tr>
            <td class="form_label" colspan="2">${ub:i18n("ReportSeriesDefinitionX")}</td>
          </tr>
          <tr>
            <td class="form_sub_label">${ub:i18n("NameWithColon")}</td>
            <td><input name="chartSeriesName" type="text"/></td>
          </tr>
          <tr>
            <td class="form_sub_label">${ub:i18n("ValueWithColon")}</td>
            <td><select name="chartSeriesColumn"></select></td>
          </tr>
          <tr>
            <td class="form_sub_label">${ub:i18n("Category")}</td>
            <td><select name="chartSeriesCategoryColumn"></select></td>
          </tr>
          <tr>
            <td class="form_label" colspan="2">${ub:i18n("ReportSeriesDefinitionY")}</td>
          </tr>
          <tr>
            <td class="form_sub_label">${ub:i18n("NameWithColon")}</td>
            <td><input name="chartDataName" type="text"/></td>
          </tr>
          <tr>
            <td class="form_sub_label">${ub:i18n("ValueWithColon")}</td>
            <td><select name="chartDataColumn"></select></td>
          </tr>
        </tbody>
      </table>
      <br /> <br />
      <a href="#saveOutput" class="button" onclick="reportBuilder.saveOutputConfig(); return false;">${ub:i18n("Apply")}</a>
      <a href="#deleteOutput" class="button" onclick="reportBuilder.removeOutputConfig(); return false;">${ub:i18n("Delete")}</a>
      <a href="#cancelOutput" class="close button">${ub:i18n("Cancel")}</a>
    </div>
  </div>


  <div style="text-align: right; border-top :0px; vertical-align: bottom;">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>
  <div id="translatedName" class="translatedName"></div>
  <div id="translatedDesc" class="translatedDescription"></div>
  <table class="property-table" style="width: 50%;">
    <tbody>
      <tr>
        <td width="20%"><label>${ub:i18n("NameWithColon")} <span class="required-text">*</span></label></td>
        <td><ucf:text name="reportName" value="" size="60"/></td>
      </tr>
      <tr>
        <td width="20%"><label>${ub:i18n("DescriptionWithColon")}</label></td>
        <td><ucf:textarea name="reportDesc" value=""/></td>
      </tr>

      <c:if test="${not empty teamSpaceList}">
        <c:set var="fieldName" value="${WebConstants.TEAM_SPACE_ID}"/>
        <c:set var="teamValue" value="${param[fieldName] != null ? param[fieldName] : null}"/>
        <tr class="reportCreateOnlyRow">
            <td align="left" width="20%"><span class="bold">${ub:i18n("TeamWithColon")} <span class="required-text">*</span></span></td>
            <td align="left">
                <ucf:idSelector
                     name="${WebConstants.TEAM_SPACE_ID}"
                     list="${teamSpaceList}"
                     selectedId="${teamValue}"
                     multiple="true"
                     optimizeOne="true"
                />
            </td>
        </tr>

        <%--
        <c:if test="${not empty resourceRoleList}">
          <c:set var="fieldName" value="${WebConstants.RESOURCE_ROLE_ID}"/>
          <c:set var="resourceRoleValue" value="${param[fieldName] != null ? param[fieldName] : null}"/>
          <tr class="reportCreateOnlyRow">
              <td align="left" width="10%"><span class="bold">${ub:i18n("ResourceRole")} </span></td>
              <td align="left">
                  <ucf:idSelector
                        emptyMessage="${ub:i18n('NoResourceRole')}"
                        name="${WebConstants.RESOURCE_ROLE_ID}"
                        list="${resourceRoleList}"
                        selectedId="${resourceRoleValue}"
                    />
              </td>
              <td align="left">
                  <span class="inlinehelp">${ub:i18n("ReportResourceRoleDesc")}</span>
              </td>
          </tr>
        </c:if>
         --%>
      </c:if>
    </tbody>
  </table>
  <div class="report-container">
    <div id="tableLayout">
      <img alt="${ub:i18n('LoadingEllipsis')}" src="${fn:escapeXml(imagesUrl)}/loading.gif" style="padding-top: 100px; padding-left: 100px;"/>
    </div>
  </div>
  <div class="manualQueryContainer" style="display: none">
    <div id="manualQuery">
      <span style="color:black;">${ub:i18n("ReportEnterReportAsJSONWithColon")}</span><br />
      <ucf:textarea id="manualQueryTextArea" name="manualQueryTextArea" value="" cols="120" rows="25"/>
    </div>
  </div>
  <div style="margin: 10px 20px;">
    <label id="saveResultDiv" style="display: none;"></label>
  </div>
  <div style="margin: 10px 20px;">
    <ucf:button name="Save" label="${ub:i18n('Save')}" id="saveButton" href="#save" title="${ub:i18n('ReportSaveReport')}"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" id="cancelButton" href="${reportingUrl}" title="${ub:i18n('ReportCancelReport')}"/>
    <ucf:button name="Text" label="${ub:i18n('Text')}" id="manualQueryButton" title="${ub:i18n('ReportSwitchReportType')}"/>
  </div>
  <br />
  <div id="paramContainer" style="margin: 10px 20px;">
  </div>
  <div style="margin: 10px 20px;">
    <ucf:button name="Run" label="${ub:i18n('Run')}" id="runButton" href="#execute" title="${ub:i18n('ReportRunReport')}"/>
  </div>
  <br />
  <div id="graphContainer"></div>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp" />
