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
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLife"%>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.StepTrace" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.buildlife.BuildLifeJobTrace" %>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@ page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@ page import="com.urbancode.ubuild.domain.security.SystemFunction" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.Workflow"%>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowCase"%>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowStatusEnum"%>
<%@ page import="com.urbancode.ubuild.runtime.paths.LogPathHelper" %>
<%@ page import="com.urbancode.ubuild.runtime.scripting.helpers.WorkflowErrorSummary"%>
<%@ page import="com.urbancode.ubuild.services.file.FileInfo" %>
<%@ page import="com.urbancode.ubuild.services.jobs.JobStatusEnum" %>
<%@ page import="com.urbancode.ubuild.services.logging.LogNamingHelper" %>
<%@ page import="com.urbancode.ubuild.services.logging.LoggingService" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.commons.logfile.ILogFile" %>
<%@ page import="com.urbancode.commons.logfile.RemoteLogFileFactory" %>
<%@ page import="com.urbancode.commons.util.Duration" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Date" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.ClientSessionTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imgUrl" value="/images"/>
<c:url var="spacerImage" value="${imgUrl}/spacer.gif"/>
<c:url var="iconAddUrl" value="${imgUrl}/icon_add.gif"/>
<c:url var="iconPlusUrl" value="${imgUrl}/icon_plus_sign.gif"/>
<c:url var="iconMinusUrl" value="${imgUrl}/icon_minus_sign.gif"/>
<c:url var="iconRestartUrl" value="${imgUrl}/icon_restart.gif"/>
<c:url var="iconDeleteUrl" value="${imgUrl}/icon_delete.gif"/>
<c:url var="iconMagnifyUrl" value="${imgUrl}/icon_magnifyglass.gif"/>
<c:url var="iconSuspendUrl" value="${imgUrl}/icon_suspend.gif"/>
<c:url var="iconResumeUrl" value="${imgUrl}/icon_resume.gif"/>
<c:url var="iconPriorityUrl" value="${imgUrl}/icon_priority.gif"/>
<c:url var="logImage" value="${imgUrl}/icon_note_file.gif"/>
<c:url var="outputImage" value="${imgUrl}/icon_output.gif"/>
<c:url var="restartImage" value="${imgUrl}/icon_restart.gif"/>
<c:url var="viewWorkflowLogIconUrl" value="${imgUrl}/icon_workflow_log.gif"/>
<c:url var="viewWorkflowLogDisabledIconUrl" value="${imgUrl}/icon_workflow_log_disabled.gif"/>
<c:url var="viewJobLogIconUrl" value="${imgUrl}/icon_job_log.gif"/>
<c:url var="viewJobLogDisabledIconUrl" value="${imgUrl}/icon_job_log_disabled.gif"/>
<c:url var="iconOrigProcess" value="${imgUrl}/icon_orig_process.gif"/>
<c:url var="iconWorkflow" value="${imgUrl}/icon_workflow.gif"/>
<c:url var="iconErrorArrow" value="${imgUrl}/icon_error_arrow.gif"/>

<c:set var="profile" value="${buildLife.profile}"/>
<c:set var="project" value="${profile.project}"/>

<c:url var="dashboardUrl" value="${DashboardTasks.viewDashboard}"/>

<c:url var="runWorkflowUrl" value="${BuildLifeTasks.viewRunWorkflow}">
  <c:param name="buildLifeId" value="${buildLife.id}"/>
</c:url>

<c:set var="workflow" value="${profile.workflow}"/>
<c:url var="buildLifeRestUrl" value="/rest2/projects/${project.id}/buildProcesses/${workflow.id}/buildLives/${buildLife.id}?extended=true" />
<c:set var="clientSessionKeyPrefix" value="activity:"/>
<c:url var="setPropertyUrl" value="${ClientSessionTasks.setProperty}"/>

<%
  LogPathHelper logPathHelper = LogPathHelper.getInstance();
  LogNamingHelper logNamingHelper = LogNamingHelper.getInstance();

  BuildLife life = (BuildLife) pageContext.findAttribute("buildLife");
  WorkflowCase originatingCase = life.getOriginatingWorkflow(); // due to timing, this can actually be null
  pageContext.setAttribute("originatingCase", originatingCase);
  WorkflowStatusEnum status = originatingCase == null ? null : originatingCase.getStatus();

  boolean canWrite = Authority.getInstance().hasPermission(life.getProfile().getProject(), UBuildAction.PROJECT_EDIT);
  pageContext.setAttribute("canWrite", Boolean.valueOf(canWrite));

  boolean canDelete = SystemFunction.hasPermission(UBuildAction.DELETE_RUNTIME_HISTORY);
  pageContext.setAttribute("canDelete", Boolean.valueOf(canDelete));

  boolean isComplete = originatingCase == null ? life.isInactive() : originatingCase.isComplete();
  pageContext.setAttribute("isComplete", Boolean.valueOf(isComplete));

  boolean isRunning = status != null && WorkflowStatusEnum.RUNNING.equals(status);
  pageContext.setAttribute("isRunning", Boolean.valueOf(isRunning));

  boolean isQueued = status != null && WorkflowStatusEnum.QUEUED.equals(status);
  pageContext.setAttribute("isQueued", Boolean.valueOf(isQueued));

  boolean isSuspended = status != null && WorkflowStatusEnum.SUSPENDED.equals(status);
  pageContext.setAttribute("isSuspended", Boolean.valueOf(isSuspended));

  boolean isPriority = originatingCase == null ? false : originatingCase.getPriority().isHigh();
  pageContext.setAttribute("isPriority", Boolean.valueOf(isPriority));

  boolean canAddStamp = SystemFunction.hasPermission(UBuildAction.MANUALLY_ADD_STAMP);
  pageContext.setAttribute("canAddStamp", canAddStamp);

  boolean canAddStatus = SystemFunction.hasPermission(UBuildAction.MANUALLY_ADD_STATUS);
  pageContext.setAttribute("canAddStatus", canAddStatus);

  boolean showManualStatusRemoval = life.hasManualStatus() && canAddStatus;
  pageContext.setAttribute("showManualStatusRemoval", showManualStatusRemoval);
%>

<%-- CONTENT --%>
<c:set var="onDocumentLoad" scope="request">renderBuildLife();</c:set>
<c:import url="buildLifeHeader.jsp">
  <c:param name="selected" value="workflows"/>
  <c:param name="showYuiMenu" value="true"/>
</c:import>
<c:if test="${!empty errorMsg}"><div class="error">${fn:escapeXml(errorMsg)}</div><br/></c:if>

<c:set var="dynamicRefreshCssUrl" value="/css/dynamicRefresh" />
<c:set var="dynamicRefreshJsUrl" value="/js/dynamicRefresh" />
<c:set var="dynamicRefreshBuildLifeJsUrl" value="${dynamicRefreshJsUrl}/buildlife" />
<link rel="stylesheet" href="${dynamicRefreshCssUrl}/dynamicRefresh.css"/>
<script src="${dynamicRefreshJsUrl}/Utils.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLife.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeJobTrace.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeSteps.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeWorkflow.js"></script>
<script src="${dynamicRefreshJsUrl}/Utils.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeError.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeStamp.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeStatus.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeProperty.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeLabel.js"></script>
<script src="${dynamicRefreshBuildLifeJsUrl}/BuildLifeActions.js"></script>

<script type="text/javascript">
    var buildLifeRestUrl = "${buildLifeRestUrl}";
    var buildLifeId = "${buildLife.id}";
    var isPreflight = ${buildLife.preflight};
    var isArchived = ${buildLife.archived};
    var isActive = ${buildLife.active};
    var canWrite = ${canWrite};
    var canDelete = ${canDelete};
    var isRunning = ${isRunning};
    var isQueued = ${isQueued};
    var isSuspended = ${isSuspended};
    var isPriority = ${isPriority};
    var canAddStamp = ${canAddStamp};
    var canAddStatus = ${canAddStatus};
    var showManualStatusRemoval = ${showManualStatusRemoval};
    var isAborted = ${originatingCase.aborted};
    var abortOrSuspendPermission = ${originatingCase.abortOrSuspendPermission};
    var prioritizationPermission = ${originatingCase.prioritizationPermission};
    var originatingCaseId = "${originatingCase.id}";

    var imgUrl = "${imgUrl}";
    var iconMagnifyUrl = "${iconMagnifyUrl}";
    var iconPlusUrl = "${iconPlusUrl}";
    var iconMinusUrl = "${iconMinusUrl}";
    var viewWorkflowLogIconUrl = "${viewWorkflowLogIconUrl}";
    var viewWorkflowLogDisabledIconUrl = "${viewWorkflowLogDisabledIconUrl}";
    var viewJobLogIconUrl = "${viewJobLogIconUrl}";
    var viewJobLogDisabledIconUrl = "${viewJobLogDisabledIconUrl}";
    var iconDeleteUrl = "${iconDeleteUrl}";
    var iconResumeUrl = "${iconResumeUrl}";
    var iconSuspendUrl = "${iconSuspendUrl}";
    var spacerImage = "${spacerImage}";
    var iconRestartUrl = "${iconRestartUrl}";
    var outputImage = "${outputImage}";
    var logImage = "${logImage}";
    var iconOrigProcess = "${iconOrigProcess}";
    var iconWorkflow = "${iconWorkflow}";
    var iconPriorityUrl = "${iconPriorityUrl}";
    var iconErrorArrow = "${iconErrorArrow}";

    var viewBuildConfigUrlId = "/tasks/admin/project/workflow/WorkflowTasks/viewBuildConfiguration";
    var viewRequestUrlId = "/tasks/project/BuildRequestTasks/viewBuildRequest";
    var viewRequestContextUrlId = "/tasks/project/BuildRequestTasks/viewBuildRequestGraph";
    var viewWorkflowUrlId = "/tasks/admin/project/workflow/WorkflowTasks/viewWorkflow";
    var resumeUrlId = "/tasks/project/WorkflowCaseTasks/resumeWorkflow";
    var suspendUrlId = "/tasks/project/WorkflowCaseTasks/suspendWorkflow";
    var abortUrlId = "/tasks/project/WorkflowCaseTasks/abortWorkflow";
    var prioritizeUrlId = "/tasks/project/WorkflowCaseTasks/prioritizeWorkflow";
    var deleteWorkflowUrlId = "/tasks/project/WorkflowCaseTasks/deleteWorkflowCase";
    var restartWorkflowUrlId = "/tasks/project/BuildLifeTasks/popupRestartWorkflow";
    var detailsUrlId = "/tasks/jobs/JobTasks/viewJobTrace";
    var viewLogUrlId = "/tasks/logs/ViewLogTasks/viewLog";
    var viewLabelUrlId = "/tasks/search/SearchTasks/viewLabels";
    var addStampUrlId = "/tasks/project/BuildLifeTasks/viewAddStamp";
    var assignLabelUrlId = "/tasks/project/BuildLifeTasks/viewAssignLabel";
    var inactivateUrlId = "/tasks/project/BuildLifeTasks/inactivateBuildLife";
    var deleteUrlId = "/tasks/project/BuildLifeTasks/deleteBuildLife";
    var archiveUrlId = "/tasks/project/BuildLifeTasks/archiveBuildLife";
    var unarchiveUrlId = "/tasks/project/BuildLifeTasks/unarchiveBuildLife";
    var addManualStatusUrlId = "/tasks/project/BuildLifeTasks/viewAddStatus";
    var deleteManualStatusUrlId = "/tasks/project/BuildLifeTasks/deleteStatus";
</script>

<script type="text/javascript">
  /* <![CDATA[ */

<c:if test="${canAddStamp and not empty buildLife.labelArray}">
YAHOO.example.onDOMReady = function(p_sType) {
    var showContextMenu = function(e, elementId) {
        this.show();
        YAHOO.util.Dom.setXY(YAHOO.util.Dom.get(elementId), YAHOO.util.Event.getXY(e));
    }

    <c:forEach var="buildLifeLabel" items="${buildLife.labelArray}" varStatus="buildLifeLabelStatus">
        var labelMenu${buildLifeLabelStatus.count} = new YAHOO.widget.ContextMenu("labelMenu${buildLifeLabelStatus.count}", {clicktohide: true, zIndex: 2, lazyload: true});
        labelMenu${buildLifeLabelStatus.count}.render();
        YAHOO.util.Event.addListener("buildLifeLabel${buildLifeLabelStatus.count}", "click", showContextMenu, 'labelMenu${buildLifeLabelStatus.count}', labelMenu${buildLifeLabelStatus.count});
    </c:forEach>
};
YAHOO.util.Event.onDOMReady(YAHOO.example.onDOMReady);
</c:if>

 /* ]]> */
</script>

<br/>
<br/>
<div style="height: 180px; margin-bottom: 7px;">
  <div class="build_life_identifiers">
    <div id = "buildLifeStatus"></div>
    <br/>
    <div id = "buildLifeStamp"></div>
    <br/>
    <div id = "buildLifeLabel"></div>
  </div>

  <div class="build_life_properties">
  <div id = "buildLifeProperty"></div>
  </div>

  <div class="secondary_process_bg">
    <c:choose>
      <c:when test="${buildLife.preflight}">
        <div style="text-align: center; color: white; background-color: #ca6060">${fn:toUpperCase(ub:i18n("Preflight"))}</div>
      </c:when>
      <c:when test="${buildLife.archived}">
        <div style="text-align: center; color: white; background-color: #ca6060">${fn:toUpperCase(ub:i18n("Archived"))}</div>
      </c:when>
      <c:when test="${!buildLife.active}">
        <div style="text-align: center; color: white; background-color: #ca6060">${fn:toUpperCase(ub:i18n("Inactive"))}</div>
      </c:when>
    </c:choose>

    <div class="secondary_process_title_bar">
      <c:choose>
        <c:when test="${buildLife.preflight}">
          <div>
            <img alt="" src="${fn:escapeXml(imgUrl)}/btn_sec_process_disabled.gif" style="padding-bottom: 5px;"/><br/>
            ${ub:i18n("BuildLifeCanNotRunSecondaryProcessOnPreflightBuild")}
          </div>
        </c:when>
        <c:when test="${buildLife.active and not originatingCase.aborted and not buildLife.archived}">
          <div onclick="showPopup('${fn:escapeXml(runWorkflowUrl)}',640,400); return false;" title="${ub:i18n('Run a secondary process on this build.')}">
            <img alt="" src="${fn:escapeXml(imgUrl)}/btn_sec_process.gif" style="padding-bottom: 5px;"/><br/>
            ${ub:i18n("Run Secondary Process")}
          </div>
        </c:when>
        <c:otherwise>
          <div onclick="alert(i18n('BuildLifeCanNotRunSecondaryProcessError', '${buildLife.archived ? 'archived' : 'inactive'}')); return false;">
            <img alt="" src="${fn:escapeXml(imgUrl)}/btn_sec_process_disabled.gif" style="padding-bottom: 5px;"/><br/>
            ${ub:i18n("Run Secondary Process")}
          </div>
        </c:otherwise>
      </c:choose>
    </div>
    <div id="secondaryProcessRow"></div>
  </div>
  <div style="clear:both"></div>
</div>

<div id="statusNotNeededToggleButton" style="display: none; float: right; padding-top: 8px; font-size: x-small;">
  <a href="javascript:toggleDisplayForElementsWithClass('status-not-needed');">${fn:toUpperCase(ub:i18n("ShowHideNotNeededJobs"))}</a>
</div>
<br/>

<div id = "buildLifeContent"></div>
<div id = "buildLifeError"></div>

<script type="text/javascript">
  /* <![CDATA[ */

var clientSession = new UC_CLIENT_SESSION( { 'clientSessionSetPropUrl': '${ah3:escapeJs(setPropertyUrl)}' });
var clientSessionKeyPrefix = "${ah3:escapeJs(clientSessionKeyPrefix)}";

function toggleWorkflowAll(link) {
    var _link = $(link);
    var workflowDiv = _link.up('div.bl_workflow_case_bg');
    var workflowDivId = workflowDiv.id;
    var open = _link.down('img').src.endsWith('${iconPlusUrl}');
    if (open) {
        _link.down('img').src = '${iconMinusUrl}';
        $(workflowDivId).down('tbody').down('img').src = '${iconMinusUrl}';
        clientSession.setProperty(clientSessionKeyPrefix + workflowDivId, 'true');
    } else {
        _link.down('img').src = '${iconPlusUrl}';
        $(workflowDivId).down('tbody').down('img').src = '${iconPlusUrl}';
        clientSession.removeProperty(clientSessionKeyPrefix + workflowDivId);
    }
    $$('tbody[id^=' + workflowDivId + '_job]').each(function(childTBody) {
        if (open) {
            childTBody.show();
            if (!childTBody.hasClassName('step-visible') && !childTBody.hasClassName('step-hidden'))  {
                childTBody.down('img').src = '${iconMinusUrl}';
            }
            if (childTBody.hasClassName('step-hidden'))  {
                childTBody.removeClassName('step-hidden');
                childTBody.addClassName('step-visible');
            }
        } else {
            childTBody.hide();
            if (!childTBody.hasClassName('step-visible') && !childTBody.hasClassName('step-hidden'))  {
                childTBody.down('img').src = '${iconPlusUrl}';
            }
            if (childTBody.hasClassName('step-visible'))  {
                childTBody.removeClassName('step-visible');
                childTBody.addClassName('step-hidden');
            }
        }
    });
}

function toggleWorkflowJobs(link) {
    var _link = $(link);
    var workflowDiv = _link.up('div.bl_workflow_case_bg');
    var workflowDivId = workflowDiv.id;
    var open = _link.down('img').src.endsWith('${iconPlusUrl}');
    if (open) {
        _link.down('img').src = '${iconMinusUrl}';
        clientSession.setProperty(clientSessionKeyPrefix + workflowDivId, 'true');
    } else {
        _link.down('img').src = '${iconPlusUrl}';
        clientSession.removeProperty(clientSessionKeyPrefix + workflowDivId);
    }
    $$('tbody[id^=' + workflowDivId + '_job]').each(function(jobTBody) {
        if (open) {
            if (!jobTBody.hasClassName('step-hidden'))  {
                jobTBody.show();
            }
        } else {
            jobTBody.hide();
        }
    });
}

function toggleJobSteps(link) {
    var _link = $(link);
    var jobTBody = _link.up('tbody');
    var jobTBodyId = jobTBody.id;
    var open = _link.down('img').src.endsWith('${iconPlusUrl}');
    if (open) {
        _link.down('img').src = '${iconMinusUrl}';
        clientSession.setProperty(clientSessionKeyPrefix + jobTBodyId, 'true');
    } else {
        _link.down('img').src = '${iconPlusUrl}';
        clientSession.removeProperty(clientSessionKeyPrefix + jobTBodyId);
    }
    $$('tbody[id^=' + jobTBodyId + '_step]').each(function(stepTBody) {
        if (open) {
            if (stepTBody.hasClassName('step-hidden')) {
                stepTBody.removeClassName('step-hidden');
                stepTBody.addClassName('step-visible');
                stepTBody.show();
            }
            else {
                stepTBody.show();
            }
        } else {
            if (stepTBody.hasClassName('step-visible')) {
                stepTBody.removeClassName('step-visible');
                stepTBody.addClassName('step-hidden');
            }
            stepTBody.hide();
        }
    });
}

function showLogViewer(viewLogUrl) {
    if( typeof(countdownVar) != 'undefined'){
        clearTimeout(countdownVar);
    };
    showPopup(viewLogUrl, windowWidth() - 100, windowHeight() - 100);
    return false;
}

 /* ]]> */
</script>

<c:import url="buildLifeFooter.jsp"/>
