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

<%@ page import="com.urbancode.ubuild.domain.security.UBuildUser" %>
<%@ page import="com.urbancode.ubuild.web.admin.security.LoginTasks" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ page import="com.urbancode.ubuild.domain.buildrequest.BuildRequest" %>
<%@ page import="com.urbancode.ubuild.domain.currentactivity.CurrentActivityFilterBy" %>
<%@ page import="com.urbancode.ubuild.domain.currentactivity.CurrentActivityGroupBy" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.currentactivity.CurrentActivityTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.ClientSessionTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="loadUrl" value="${CurrentActivityTasks.getCurrentActivity}"/>
<c:url var="viewWorkflowUrl" value="${WorkflowCaseTasks.viewWorkflowCase}"/>
<c:url var="abortWorkflowUrl" value="${CurrentActivityTasks.abortWorkflow}"/>
<c:url var="suspendWorkflowUrl" value="${CurrentActivityTasks.suspendWorkflow}"/>
<c:url var="resumeWorkflowUrl" value="${CurrentActivityTasks.resumeWorkflow}"/>
<c:url var="prioritizeWorkflowUrl" value="${CurrentActivityTasks.prioritizeWorkflow}"/>
<c:url var="viewJobUrl" value="${JobTasks.viewJobTrace}"/>
<c:url var="setPropertyUrl" value="${ClientSessionTasks.setProperty}"/>
<c:url var="saveFilterUrl" value='${CurrentActivityTasks.saveActivityFilter}'/>
<c:url var="deleteFilterUrl" value='${CurrentActivityTasks.deleteActivityFilter}'/>

<c:url var="imgUrl" value="/images"/>
<c:url var="iconViewUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconPlusUrl" value="/images/icon_plus_sign.gif"/>
<c:url var="iconMinusUrl" value="/images/icon_minus_sign.gif"/>
<c:url var="iconWorkflowUrl" value="/images/icon_workflow.gif"/>
<c:url var="iconJobUrl" value="/images/icon_job.gif"/>
<c:url var="iconAbortUrl" value="/images/icon_delete.gif"/>
<c:url var="iconSuspendUrl" value="/images/icon_suspend.gif"/>
<c:url var="iconResumeUrl" value="/images/icon_resume.gif"/>
<c:url var="iconPrioritizeUrl" value="/images/icon_priority.gif"/>
<c:url var="iconWorkflowRemove" value="/images/workflow-remove.gif"/>

<c:url var="cssUrl" value="/css"/>
<c:url var="jsUrl" value="/js"/>

<c:url var="viewUrl" value='${CurrentActivityTasks.viewCurrentActivity}'/>
<c:url var="iconDeleteFilterUrl" value="/images/icon_delete.gif"/>

<%-- CONTENT --%>
<%
    pageContext.setAttribute("eo", new EvenOdd());
%>

<c:set var="expandAllRows" value="${'true' == clientSession['currentActivityAllRowsExpanded']}" />
<c:set var="singleRowExpandedKeyPrefix" value="currentActivitySingleWorkflow:"/>

<c:set var="onDocumentLoad" scope="request">
  /* <![CDATA[ */
  var currentActivityWorkflowOverrideIds = new Array();
  var allRowsExpanded = false;
  var isExpandAll = true;

  <c:forEach var="sessionEntry" items="${clientSession}">
    <c:if test="${fn:startsWith(sessionEntry.key, 'currentActivitySingleWorkflow:')}">
      currentActivityWorkflowOverrideIds.push(${fn:split(sessionEntry.key, ':')[1]});
    </c:if>
    <c:if test="${sessionEntry.key eq 'currentActivityAllRowsExpanded'}">
      allRowsExpanded = true;
      isExpandAll = false;
      iconExpandAllUrl = '${ah3:escapeJs(iconPlusUrl)}'
    </c:if>
  </c:forEach>

  currentActivity = new createCurrentActivity("groupId");
  currentActivity.createTable(currentActivityWorkflowOverrideIds, allRowsExpanded, isExpandAll);
  currentActivity.loadTable();

  YAHOO.util.Event.addListener(window, "load", function() {
      YAHOO.example.EnhanceFromMarkup = function() {
          var noWrapFormatter = function(elLiner, record, oColumn, oData) {
              elLiner = $(elLiner);
              YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
              elLiner.innerHTML = oData;
          };

          var centerNoWrapFormatter = function(elLiner, record, oColumn, oData) {
              elLiner = $(elLiner);
              YAHOO.util.Dom.setStyle(elLiner,"text-align", "center");
              YAHOO.util.Dom.setStyle(elLiner, "white-space", "nowrap");
              elLiner.innerHTML = oData;
          };

          var myColumnDefs = [
              {
                  formatter: noWrapFormatter,
                  key:"project",
                  label:"${ub:i18n('Project')}",
                  sortable:true
              },
              {
                  formatter: noWrapFormatter,
                  key:"workflow",
                  label:"${ub:i18n('Process')}",
                  sortable:true
              },
              {
                  key:"date",
                  formatter: centerNoWrapFormatter,
                  label:"${ub:i18n('Date')}",
                  sortable:true,
                  sortOptions:{ sortFunction: this.startDateSort }
              },
              {
                  formatter: noWrapFormatter,
                  key:"created_by",
                  label:"${ub:i18n('CreatedBy')}",
                  sortable:true
              },
              {
                  formatter: centerNoWrapFormatter,
                  key:"log",
                  label:"${ub:i18n('Log')}"
              },
              {
                  formatter: centerNoWrapFormatter,
                  key:"details",
                  label:"${ub:i18n('Details')}"
              },
              {
                  formatter: centerNoWrapFormatter,
                  key:"actions",
                  label:"${ub:i18n('Actions')}"
              }
          ];

          var myDataSource = new YAHOO.util.DataSource(YAHOO.util.Dom.get("delayed-builds-table"));
          myDataSource.responseType = YAHOO.util.DataSource.TYPE_HTMLTABLE;
          myDataSource.responseSchema = {
              fields: [
                  {key:"project"},
                  {key:"workflow"},
                  {key:"date"},
                  {key:"created_by"},
                  {key:"log"},
                  {key:"details"},
                  {key:"actions"}
              ]
          };

          var myDataTable = new YAHOO.widget.DataTable("delayed-builds-container", myColumnDefs, myDataSource,
                {
                    caption: "${ub:i18n('PlannedProcessExecutions')}",
                    sortedBy:{key:"date",dir:"desc"},
                    MSG_EMPTY: i18n("No records found."),
                    MSG_LOADING: i18n('LoadingEllipsis')
                }
          );

          return {
              oDS: myDataSource,
              oDT: myDataTable
          };
      }();
  });
  /* ]]> */
</c:set>
<c:import url="/WEB-INF/jsps/currentActivity/_header.jsp">
  <c:param name="selected" value="activity" />
  <c:param name="disabled" value="${inEditMode}"/>
</c:import>

<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cssUrl)}/currentActivity.css"/>

<script type="text/javascript" src="${fn:escapeXml(jsUrl)}/currentActivity.js"></script>

<script type="text/javascript"><!--
  /* <![CDATA[ */

loadUrl = '${ah3:escapeJs(loadUrl)}';
viewWorkflowUrl = '${ah3:escapeJs(viewWorkflowUrl)}?${WebConstants.WORKFLOW_CASE_ID}=';
abortWorkflowUrl = '${ah3:escapeJs(abortWorkflowUrl)}?${WebConstants.WORKFLOW_CASE_ID}=';
suspendWorkflowUrl = '${ah3:escapeJs(suspendWorkflowUrl)}?${WebConstants.WORKFLOW_CASE_ID}=';
resumeWorkflowUrl = '${ah3:escapeJs(resumeWorkflowUrl)}?${WebConstants.WORKFLOW_CASE_ID}=';
prioritizeWorkflowUrl = '${ah3:escapeJs(prioritizeWorkflowUrl)}?${WebConstants.WORKFLOW_CASE_ID}=';
viewJobUrl = '${ah3:escapeJs(viewJobUrl)}?${WebConstants.JOB_TRACE_ID}=';
setPropertyUrl = '${ah3:escapeJs(setPropertyUrl)}';
saveFilterUrl = '${ah3:escapeJs(saveFilterUrl)}';
deleteFilterUrl = '${ah3:escapeJs(deleteFilterUrl)}';
savedFilterUrl = '${ah3:escapeJs(savedFilterUrl)}';

iconViewUrl = '${ah3:escapeJs(iconViewUrl)}';
iconPlusUrl = '${ah3:escapeJs(iconPlusUrl)}';
iconMinusUrl = '${ah3:escapeJs(iconMinusUrl)}';
iconWorkflowUrl = '${ah3:escapeJs(iconWorkflowUrl)}';
iconJobUrl = '${ah3:escapeJs(iconJobUrl)}';
iconAbortUrl = '${ah3:escapeJs(iconAbortUrl)}';
iconSuspendUrl = '${ah3:escapeJs(iconSuspendUrl)}';
iconResumeUrl = '${ah3:escapeJs(iconResumeUrl)}';
iconPrioritizeUrl = '${ah3:escapeJs(iconPrioritizeUrl)}';
iconWorkflowRemoveUrl = '${ah3:escapeJs(iconWorkflowRemove)}';
iconExpandAllUrl = '${ah3:escapeJs(iconPlusUrl)}';
  /* ]]> */
--></script>
  <br/>
  <table style="width: 100%;">
    <tr valign="top">
      <td width="35%" nowrap="nowrap">
        <table id="current-activity-filter">
          <tr height="20">
            <td style="text-align: right;" nowrap="nowrap"><span class="bold">${ub:i18n("AddToFilter")}</span></td>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr height="20">
            <td style="text-align: right;" nowrap="nowrap"><span class="bold">${ub:i18n("GroupBy")}</span></td>
            <td>
              <% pageContext.setAttribute("groupByList", CurrentActivityGroupBy.values()); %>
              <ucf:nameSelector id="groupBy" name="groupBy" list="${groupByList}" unselectedText="-- ${ub:i18n('NoGrouping')} --" />
            </td>
            <td>
              <a onclick="setCurrentFilterGroupBy();" style="cursor: pointer;">
                <img src="${fn:escapeXml(imgUrl)}/go-next.png" title="${ub:i18n('SetInCurrentFilter')}"/>
              </a>
            </td>
          </tr>
          <tr height="20">
            <td style="text-align: right;" nowrap="nowrap"><span class="bold">${ub:i18n("FilterBy")}</span></td>
            <td>
              <% pageContext.setAttribute("filterByList", CurrentActivityFilterBy.values()); %>
              <ucf:nameSelector id="filterBy" name="filterBy" list="${filterByList}" unselectedText="-- ${ub:i18n('NoFiltering')} --" />
            </td>
            <td>
              <a onclick="addCurrentFilterFilterBy();" style="cursor: pointer;">
                <img src="${fn:escapeXml(imgUrl)}/go-next.png" title="${ub:i18n('CurrentActivityAddToFilter')}"/>
              </a>
            </td>
          </tr>
          <tr height="20">
            <td>&nbsp;</td>
            <td>
              <ucf:text id="filterValue" name="filterValue" value="" title="${ub:i18n('CurrentActivityFilterDesc')}"/>
            </td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
      <td width="35%">
        <form action="<c:out value="${viewUrl}"/>" method="post">
        </form>
          <table id="current-activity-current-filter">
            <tr valign="middle" height="20">
              <td style="text-align: right;" nowrap="nowrap"><span class="bold">${ub:i18n("CurrentFilter")}</span></td>
              <td>
                <ucf:hidden id="filterId" name="filterId" value="${currentFilter.id}" renderNull="true"/>
                <ucf:text id="filterName" name="filterName" value="${currentFilter.name}"/>
              </td>
            </tr>
            <tr valign="middle" height="20">
              <td style="text-align: right;" nowrap="nowrap"><span class="bold">${ub:i18n("GroupedBy")}</span></td>
              <td>
                <input type="hidden" id="currentGroupBy" name="currentGroupBy" value="${currentFilter.groupBy.name}"/>
                <div id="currentGroupByDiv"><c:out value="${ub:i18n(currentFilter.groupBy.name)}"/></div>
              </td>
            </tr>
            <tr valign="top" height="20">
              <td style="text-align: right;" nowrap="nowrap"><span class="bold">${ub:i18n("FilteredBy")}</span></td>
              <td>
                <div id="currentFilterByDiv">
                  <c:forEach var="currentFilterCriteria" items="${currentFilter.filterCriteria}">
                    <ucf:hidden name="currentFilterBy" value="${currentFilterCriteria.filterBy.name}:${currentFilterCriteria.filterValue}"/>
                    <c:set var="msgValue" scope="session" value="${currentFilterCriteria.filterBy.name}|${currentFilterCriteria.filterValue}"/>
                    <c:set var="filterCriteriaShownMsg" scope="session" value="${ub:i18nMessage('FilterObjectIsValue', msgValue)}"/>
                    <c:out value="${filterCriteriaShownMsg}"/><br/>
                  </c:forEach>
                </div>
              </td>
            </tr>
            <tr valign="top" height="20">
              <td colspan="2" align="right"><br/>
                  <ucf:button name="Filter" label="${ub:i18n('Filter')}" title="${ub:i18n('ReloadAndApplyFilter')}"
                    submit="${false}" onclick="clearFilterBuilder(); currentActivity.loadTable(); return false;"/>
                  <ucf:button name="Save" label="${ub:i18n('Save')}" title="${ub:i18n('SaveFilterSettings')}"
                    submit="${false}" onclick="saveCurrentFilter(); return false;"/>
                  <ucf:button name="Clear" label="${ub:i18n('Clear')}" title="${ub:i18n('ClearFilterSettings')}"
                    submit="${false}" onclick="clearCurrentFilter(); return false;"/>
              </td>
            </tr>
          </table>
      </td>
      <td width="30%">
        <span class="bold">${ub:i18n("SavedFilters")}</span>
        <div style="overflow: auto; height: 90px; width: 100%;">
          <table id="current-activity-saved-filters" style="width: 100%;">
            <c:forEach var="savedFilter" items="${savedFilters}">
              <tr id="savedFilter-${savedFilter.id}">
                <td style="padding-left: 10px;">
                  <c:url var="savedFilterUrl" value="${viewUrl}">
                    <c:param name="filterId" value="${savedFilter.id}"/>
                  </c:url>
                  <ucf:link href="${savedFilterUrl}" label="${savedFilter.name}" title="${ub:i18n('ReloadAndApplyFilter')}"/>
                </td>
                <td>
                  <c:url var="deleteSavedFilterUrl" value="${deleteFilterUrl}">
                    <c:param name="filterId" value="${savedFilter.id}"/>
                  </c:url>
                  <a href="#" onclick="if (confirmDelete('${savedFilter.name}')) deleteSavedFilter('${savedFilter.id}');"
                     title="${ub:i18n('DeleteFilter')}"><img src="${iconDeleteFilterUrl}" border="0"/></a>
                </td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </td>
    </tr>
  </table>

<br/>

<div id="actionResultMessage" class="note" style="display: none;"></div>

<div id="current-activity"></div>

<br/>

<div id="delayed-builds-container">
    <table id="delayed-builds-table" class="data-table">
        <thead>
            <tr>
                <th>${ub:i18n("Project")}</th>
                <th>${ub:i18n("Process")}</th>
                <th>${ub:i18n("Date")}</th>
                <th>${ub:i18n("CreatedBy")}</th>
                <th>${ub:i18n("Log")}</th>
                <th>${ub:i18n("Details")}</th>
                <th>${ub:i18n("Actions")}</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="delayedBuild" items="${delayedBuilds}">
                <c:url var="abortDelayedBuildUrl" value="${CurrentActivityTasks.abortBuildRequest}">
                    <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${delayedBuild.id}"/>
                </c:url>
                <c:url var="viewProject" value="${ProjectTasks.viewDashboard}">
                    <c:param name="${WebConstants.PROJECT_ID}" value="${delayedBuild.workflow.project.id}"/>
                </c:url>
                <c:url var="viewWorkflow" value="${WorkflowTasks.viewDashboard}">
                    <c:param name="${WebConstants.WORKFLOW_ID}" value="${delayedBuild.workflow.id}"/>
                </c:url>
                <c:url var="viewBuildRequest" value="${BuildRequestTasks.viewBuildRequest}">
                    <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${delayedBuild.id}"/>
                </c:url>
                <c:url var="viewLog" value="${ViewLogTasks.viewLog}"/>
                <tr>
                    <td><a href="${viewProject}">${delayedBuild.workflow.project.name}</a></td>
                    <td><a href="${viewWorkflow}">${delayedBuild.workflow.name}</a></td>
                    <td>${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, delayedBuild.delayUntilDate))}</td>
                    <td>${delayedBuild.requesterName}</td>
                    <td><a href="#" onclick="showPopup('${ah3:escapeJs(viewLog)}?log_name=br%2f${delayedBuild.id}%2fmain.log&amp;pathSeparator=%2f', windowWidth() - 100, windowHeight() - 100); return false;" title="${ub:i18n('ShowLog')}"><img border="0" src="${fn:escapeXml(imgUrl)}/icon_note_file.gif" title="${ub:i18n('ShowLog')}" alt="${ub:i18n('ShowLog')}"/></a></td>
                    <td><a href="${viewBuildRequest}">${delayedBuild.id}</a></td>
                    <td>
                        <ucf:confirmlink href="${abortDelayedBuildUrl}"
                            message="${ub:i18n('BuildLifeAbortConfirm')}"
                            img="/images/icon_delete.gif"
                            label="${ub:i18n('Abort')}"
                            enabled="true"/>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script type="text/javascript">

</script>

<jsp:include page="/WEB-INF/jsps/currentActivity/_footer.jsp"/>
