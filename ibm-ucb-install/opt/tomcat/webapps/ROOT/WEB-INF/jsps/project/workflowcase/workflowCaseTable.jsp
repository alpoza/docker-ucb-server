<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.StepTrace" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.JobTrace" %>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@ page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@ page import="com.urbancode.ubuild.domain.security.SystemFunction" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.Workflow"%>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowCase" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowStatusEnum"%>
<%@ page import="com.urbancode.ubuild.runtime.paths.LogPathHelper" %>
<%@ page import="com.urbancode.ubuild.services.file.FileInfo" %>
<%@ page import="com.urbancode.ubuild.services.jobs.JobStatusEnum" %>
<%@ page import="com.urbancode.ubuild.services.logging.LogNamingHelper" %>
<%@ page import="com.urbancode.ubuild.services.logging.LoggingService" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.commons.logfile.ILogFile" %>
<%@ page import="com.urbancode.commons.logfile.RemoteLogFileFactory" %>
<%@ page import="com.urbancode.commons.util.Duration" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>

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

<c:url var="setPropertyUrl" value="${ClientSessionTasks.setProperty}"/>

<%
  LogPathHelper logPathHelper = LogPathHelper.getInstance();
  LogNamingHelper logNamingHelper = LogNamingHelper.getInstance();
  String baseLogPath = logPathHelper.getBaseLogPath();

  WorkflowCase workflow_case = (WorkflowCase) request.getAttribute(WebConstants.WORKFLOW_CASE);
  WorkflowStatusEnum status = workflow_case == null ? null : workflow_case.getStatus();

  boolean canWrite = Authority.getInstance().hasPermission(workflow_case.getProject(), UBuildAction.PROJECT_EDIT);
  pageContext.setAttribute("canWrite", Boolean.valueOf(canWrite));
  
  Boolean canExecute = Boolean.FALSE;
  if (Authority.getInstance().hasPermission(workflow_case.getWorkflow(), UBuildAction.WORKFLOW_RUN)) {
      canExecute = Boolean.TRUE;
  }
  pageContext.setAttribute("canExecute", canExecute);

  boolean canDelete = canExecute && SystemFunction.hasPermission(UBuildAction.DELETE_RUNTIME_HISTORY);
  pageContext.setAttribute("canDelete", Boolean.valueOf(canDelete));

  pageContext.setAttribute("isOriginating", workflow_case.getWorkflow().isOriginating());
  
  boolean isComplete = workflow_case == null ? false : workflow_case.isComplete();
  pageContext.setAttribute("isComplete", Boolean.valueOf(isComplete));

  boolean isRunning = status != null && WorkflowStatusEnum.RUNNING.equals(status);
  pageContext.setAttribute("isRunning", Boolean.valueOf(isRunning));

  boolean isQueued = status != null && WorkflowStatusEnum.QUEUED.equals(status);
  pageContext.setAttribute("isQueued", Boolean.valueOf(isQueued));

  boolean isSuspended = status != null && WorkflowStatusEnum.SUSPENDED.equals(status);
  pageContext.setAttribute("isSuspended", Boolean.valueOf(isSuspended));

  boolean isPriority = workflow_case == null ? false : workflow_case.getPriority().isHigh();
  pageContext.setAttribute("isPriority", Boolean.valueOf(isPriority));

  boolean isOperation = workflow_case.getBuildLife() == null;
  pageContext.setAttribute("isOperation", Boolean.valueOf(isOperation));
%>

<%-- CONTENT --%>
<c:set var="wcDivId" value="blwc_${workflow_case.id}"/>
<c:set var="wcClientSessionKey" value="${clientSessionKeyPrefix}${wcDivId}"/>
<c:set var="isExpanded" value="${param.isExpanded || clientSession[wcClientSessionKey]}"/>
<c:set var="clientSessionKeyPrefix" value="activity:"/>

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

<div id="${wcDivId}" class="bl_workflow_case_bg ${isOriginating? 'bl_workflow_case_originating' : '' }">
  <c:url var="viewRequestUrl" value="${BuildRequestTasks.viewBuildRequest}">
    <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${workflow_case.request.id}"/>
  </c:url>
  <c:url var="viewRequestContextUrl" value="${BuildRequestTasks.viewBuildRequestGraph}">
    <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${workflow_case.request.id}"/>
  </c:url>
  <c:url var="viewWorkflowUrl" value="${WorkflowTasks.viewWorkflow}">
    <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow_case.workflow.id}"/>
  </c:url>
  <div class="large-text" style="padding-bottom: 10px;">
  <c:choose>
    <c:when test="${isOriginating}">
      <img src="${fn:escapeXml(imgUrl)}/icon_orig_process.gif" alt=""/>${fn:escapeXml(workflow_case.name)}
    </c:when>
    <c:otherwise>
      <img src="${fn:escapeXml(imgUrl)}/icon_workflow.gif" alt=""/>${fn:escapeXml(workflow_case.name)}
    </c:otherwise>
  </c:choose>
    <span class="small-text" style="padding-left: 10px;">( ${ub:i18n(fn:escapeXml(workflow_case.request.requestSource))}&nbsp;${ub:i18n("RequestBy")}&nbsp;
    ${fn:escapeXml(workflow_case.request.user.name)},
    <c:if test="${not empty workflow_case.request.buildConfiguration}">
      <c:url var="viewBuildConfigUrl" value="${WorkflowTasks.viewBuildConfiguration}">
        <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow_case.workflow.id}"/>
        <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${workflow_case.request.buildConfiguration.id}"/>
      </c:url>
      ${ub:i18n("UsingBuildConfiguration")}&nbsp;
      <ucf:link href="${viewBuildConfigUrl}" label="${workflow_case.request.buildConfiguration.name}" forceLabel="true"/>,
    </c:if>
    <ucf:link href="${viewRequestUrl}" label="${ub:i18n('ViewRequest')}" img="${iconMagnifyUrl}" forceLabel="true"/>
    <c:if test="${not isOperation}">,
      <ucf:link href="${viewRequestContextUrl}" label="${ub:i18n('ViewContext')}" img="${iconMagnifyUrl}" forceLabel="true"/>
    </c:if>
    <c:if test="${canWrite}">,
      <ucf:link href="${viewWorkflowUrl}" label="${ub:i18n('ViewConfiguration')}" img="${iconMagnifyUrl}" forceLabel="true"/>
    </c:if>
    )</span>
    <c:if test="${workflow_case.priority.high}">&nbsp;
      <span class="small-text bold">( <img src="${fn:escapeXml(imgUrl)}/icon_priority.gif" alt=""/> ${ub:i18n('HighPriority')} )</span>
    </c:if>

  </div>

  <table class="data-table">
    <thead>
      <tr class="bl_workflow_case_title_bar">
        <th style="width: 28%;">
          <div style="float: left;">
            <ucf:link href="#" label="${ub:i18n('ShowHideAll')}" img="${iconPlusUrl}" onclick="toggleWorkflowAll(this); return false;"/>
          </div>
          ${ub:i18n("Process")} / ${ub:i18n("Job")} / ${ub:i18n("Step")}
        </th>
        <th style="width: 20%;">${ub:i18n("Agent")}</th>
        <th style="width: 20%;">${ub:i18n("Start")} / ${ub:i18n("Offset")}</th>
        <th style="width: 10%;">${ub:i18n("Duration")}</th>
        <th style="width: 10%;">${ub:i18n("Status")}</th>
        <th style="width: 12%;">${ub:i18n("Actions")}</th>
      </tr>
    </thead>

    <%-- WORKFLOW --%>
    <tbody class="workflow_row">
      <tr class="bl_workflow_row<c:if test="${workflow_case.priority.high}"> priority</c:if>">
        <td  style="align: left; text-align: left;">
          <c:choose>
            <c:when test="${isExpanded || empty workflow_case.jobTraceArray}">
              <ucf:link href="#" label="${ub:i18n('ShowHideJobs')}" img="${iconMinusUrl}" onclick="toggleWorkflowJobs(this); return false;"/>
            </c:when>
            <c:otherwise>
              <ucf:link href="#" label="${ub:i18n('ShowHideJobs')}" img="${iconPlusUrl}" onclick="toggleWorkflowJobs(this); return false;"/>
            </c:otherwise>
          </c:choose>
          ${fn:escapeXml(workflow_case.name)}
        </td>
        <td align="center"><c:out value="" default="[${ub:i18n('Unspecified')}]"/></td>
        <td align="center">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, workflow_case.startDate))}</td>
        <td align="center">
          <c:if test="${not empty workflow_case.startDate}">
            <%=new Duration(workflow_case.getStartDate(), workflow_case.getEndDate())%>
          </c:if>
        </td>
        <td align="center" style="background-color: ${fn:escapeXml(workflow_case.status.color)};
            color: ${fn:escapeXml(workflow_case.status.secondaryColor)};">${ub:i18n(fn:escapeXml(workflow_case.status.name))}</td>
        <td style="align: left; text-align: left;">
          <c:set var="workflow_case" value="${workflow_case}" scope="request"/>
          <c:import url="/WEB-INF/jsps/project/workflowcase/workflowLogLink.jsp"/>

          <c:if test="${workflow_case.abortOrSuspendPermission and not isComplete}">
            &nbsp;
            <c:url var="abortUrl" value="${WorkflowCaseTasks.abortWorkflow}">
              <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
            </c:url>
            <c:set var="abortMsg" value="${ub:i18n('BuildLifeAbortConfirm')}"/>
            <ucf:confirmlink href="${abortUrl}"
                       message="${abortMsg}"
                       img="${iconDeleteUrl}"
                       label="${ub:i18n('Abort')}"
                       enabled="${true}"/>
            <c:choose>
              <c:when test="${isSuspended}">
                &nbsp;
                <c:url var="resumeUrl" value="${WorkflowCaseTasks.resumeWorkflow}">
                  <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
                </c:url>
                <c:set var="resumeMsg" value="${ub:i18n('BuildLifeResumeConfirm')}"/>
                <ucf:confirmlink href="${resumeUrl}"
                           message="${resumeMsg}"
                           img="${iconResumeUrl}"
                           label="${ub:i18n('Resume')}"
                           enabled="${true}"/>
              </c:when>
              <c:when test="${isRunning}">
                &nbsp;
                <c:url var="suspendUrl" value="${WorkflowCaseTasks.suspendWorkflow}">
                  <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
                </c:url>
                <c:set var="suspendMsg" value="${ub:i18n('BuildLifeSuspendConfirm')}"/>
                <ucf:confirmlink href="${suspendUrl}"
                           message="${suspendMsg}"
                           img="${iconSuspendUrl}"
                           label="${ub:i18n('Suspend')}"
                           enabled="${true}"/>
              </c:when>
            </c:choose>
          </c:if>
          <c:if test="${workflow_case.prioritizationPermission and not workflow_case.complete and not workflow_case.priority.high and not ('Suspended' eq workflow_case.status.name)}">
            &nbsp;
            <c:url var="prioritizeUrl" value="${WorkflowCaseTasks.prioritizeWorkflow}">
              <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
            </c:url>
            <c:set var="prioritizeMsg" value="${ub:i18n('BuildLifePrioritizeConfirm')}"/>
            <ucf:confirmlink href="${prioritizeUrl}"
                       message="${prioritizeMsg}"
                       img="${iconPriorityUrl}"
                       label="${ub:i18n('Prioritize')}"
                       enabled="${true}"/>
          </c:if>

          <%-- Extra actions for those that can execute this particular workflow --%>
          <c:if test="${canExecute and workflow_case.status.done}">

            <%-- Delete Workflow Action --%>
            <c:if test="${canDelete}">
              <c:choose>
                <c:when test="${workflow_case.workflow.buildProfile == null}">
                  &nbsp;
                  <c:url var="deleteWorkflowUrl"  value="${WorkflowCaseTasks.deleteWorkflowCase}">
                    <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
                  </c:url>
                  <c:set var="deleteMsg" value="${ub:i18n('BuildLifeProcessDeleteConfirm')}"/>
                  <ucf:confirmlink href="${deleteWorkflowUrl}"
                             message="${deleteMsg}"
                             img="${iconDeleteUrl}"
                             label="${ub:i18n('Delete')}"
                             enabled="${true}"/>
                </c:when>
                <c:otherwise>
                    &nbsp;
                    <img alt="" src="${fn:escapeXml(spacerImage)}" width="16" height="16" style="border: 0" />
                </c:otherwise>
              </c:choose>
            </c:if>
            
            <c:if test="${not isOperation}">
              <%-- Restart Workflow Action --%>
              <c:choose>
                <c:when test="${canExecute && workflow_case.restartable}">
                  &nbsp;
                  <c:url var="restartWorkflowUrl"  value="${BuildLifeTasks.popupRestartWorkflow}">
                    <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
                    <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${buildLife.id}"/>
                  </c:url>
                  <ucf:link href="#" img="${iconRestartUrl}" label="${ub:i18n('Restart')}"
                      onclick="showPopup('${fn:escapeXml(restartWorkflowUrl)}',800,640); return false;"/>
                </c:when>
                <c:otherwise>
                    &nbsp;
                    <img alt="" src="${fn:escapeXml(spacerImage)}" width="16" height="16" style="border: 0" />
                </c:otherwise>
              </c:choose>
            </c:if>

          </c:if>
        </td>
      </tr>
    </tbody>


    <%-- JOBS --%>
    <%
      pageContext.setAttribute("job_eo", new EvenOdd());
    %>
    <c:forEach var="jobTrace" items="${workflow_case.jobTraceArray}" varStatus="traceLoop">
      <%
        JobTrace jobTrace = (JobTrace) pageContext.findAttribute("jobTrace");
      %>
      <c:set var="row_class" value=""/>
      <c:set var="row_style" value=""/>
      <c:if test="${fn:containsIgnoreCase(jobTrace.status.name,'not needed')}">
        <c:set var="row_class" value="status-not-needed"/>
        <c:set var="row_style" value="display: none;"/>
        <script type="text/javascript">
            /* <![CDATA[ */
            $('statusNotNeededToggleButton').show();
            /* ]]> */
        </script>
      </c:if>
      <c:if test="${not isExpanded}">
        <c:set var="row_style" value="display: none;"/>
      </c:if>
      <c:set var="jtDivId" value="${wcDivId}_job_${jobTrace.id}"/>
      <c:set var="jtClientSessionKey" value="${clientSessionKeyPrefix}${jtDivId}"/>
      <c:set var="isJobExpanded" value="${clientSession[jtClientSessionKey] or !jobTrace.done}"/>

      <tbody id="${jtDivId}" class="${row_class}" style="${row_style}">
      <tr class="bl_workflow_row_tr even">
        <c:url var="detailsUrl" value="${JobTasks.viewJobTrace}">
            <c:param name="job_trace_id" value="${jobTrace.id}"/>
        </c:url>
        <td style="align: left; text-align: left;">
          <span style="padding-left: 15px;">
            <ucf:link href="#" label="${ub:i18n('ShowHideSteps')}" img="${isJobExpanded ? iconMinusUrl : iconPlusUrl}"
                onclick="toggleJobSteps(this); return false;"/>
            <a href="${fn:escapeXml(detailsUrl)}" title="${ub:i18n('ViewJob')}">${fn:escapeXml(jobTrace.name)}</a>
          </span>
        </td>
        <td align="center">${fn:escapeXml(jobTrace.agent.name)}</td>
        <td align="center">
          <c:if test="${not empty workflow_case.startDate}">
            <%=new Duration(workflow_case.getStartDate(), jobTrace.getStartDate())%>
          </c:if>
        </td>
        <td align="center"><c:out value="${jobTrace.duration}" default=""/></td>
        <td align="center" style="background-color: ${fn:escapeXml(jobTrace.status.color)};
            color: ${fn:escapeXml(jobTrace.status.secondaryColor)};">${ub:i18n(fn:escapeXml(jobTrace.status.name))}</td>
        <td style="align: left; text-align: left;">
          <%-- View Log Action --%>
          <c:set var="jobTrace" value="${jobTrace}" scope="request"/>
          <c:import url="/WEB-INF/jsps/jobs/jobLogLink.jsp"/>

          &nbsp;

          <%-- View Job Action --%>
          <a href="${fn:escapeXml(detailsUrl)}" title="${ub:i18n('ViewJob')}">
            <img src="${fn:escapeXml(iconMagnifyUrl)}" alt="${ub:i18n('ViewJob')}" width="16" height="16" style="border: 0"/>
          </a>

          <%-- Restart Job while Workflow is running --%>
          <%-- Uncomment this block when restart is ready
          <c:if test="${canExecute && jobTrace.restartable}">
            <c:url var="restartJobUrl"  value="${BuildLifeTasks.popupRestartRunningWorkflowJob}">
              <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
              <c:param name="${WebConstants.JOB_TRACE_ID}" value="${jobTrace.id}"/>
            </c:url>
            &nbsp;
            <ucf:link href="javascript:showPopup('${ah3:escapeJs(restartJobUrl)}', 800, 640);"
                        img="${iconRestartUrl}"
                        label="${ub:i18n('Restart')}"
                        enabled="${canExecute}"/>
          </c:if>
          --%>
        </td>
      </tr>
      </tbody>


      <%-- STEPS --%>
      <%
        pageContext.setAttribute("step_eo", new EvenOdd());
      %>
      <c:forEach var="step" items="${jobTrace.stepTraceArray}" varStatus="stepLoop">
        <%
          StepTrace step = (StepTrace) pageContext.findAttribute("step");
        %>
        <c:set var="stDivId" value="${jtDivId}_step_${stepLoop.index}"/>
        <c:set var="stClientSessionKey" value="${clientSessionKeyPrefix}${stDivId}"/>
        <c:set var="isStepDone" value="${not empty step.endDate}"/>
        <c:set var="isStepExpanded" value="${!isStepDone || !step.status.success || clientSession[stClientSessionKey]}"/>
        <c:set var="row_class" value="step-hidden"/>
        <c:if test="${isStepExpanded}">
            <c:set var="row_class" value="step-visible"/>
        </c:if>
        <c:set var="row_style" value="display: none;"/>
        <c:if test="${isExpanded and isJobExpanded}">
            <c:set var="row_style" value=""/>
        </c:if>

        <tbody id="${stDivId}" class="${row_class}" style="${row_style}">
          <tr class="sub_row_${step_eo.next}">
            <td align="left" nowrap="nowrap">
              <span style="padding-left: 30px;">
                <c:set var="stepHeader" value="${stepLoop.index+1}. ${step.name}"/>
                <img alt="" src="${fn:escapeXml(spacerImage)}" height="1" width="12"/>
                ${fn:escapeXml(stepHeader)}
              </span>
            </td>
            <td align="left">&nbsp;</td>
            <td align="center" nowrap="nowrap">${fn:escapeXml(step.offset)}</td>
            <td align="center" nowrap="nowrap">${fn:escapeXml(step.duration)}</td>
            <td align="center" nowrap="nowrap" style="background-color: ${fn:escapeXml(step.status.color)};
                color: ${fn:escapeXml(step.status.secondaryColor)};">${fn:escapeXml(step.status.name)}</td>
            <td style="align: left; text-align: left;">
               <%
                 List<FileInfo> stepLogFileInfoList = logPathHelper.getLogFileInfoList(step);
                 for (int j = 0; j < stepLogFileInfoList.size(); j++) {
                   FileInfo logFileInfo = stepLogFileInfoList.get(j);
                   String logName = logNamingHelper.getName(logFileInfo.getName());
                   String logPath = logFileInfo.getUnresolvedPath().substring(baseLogPath.length() + 1);

                   if (j>0) {
                     out.write(" &nbsp;&nbsp; ");
                   }

                   pageContext.setAttribute("logPath", logPath);
                   pageContext.setAttribute("logName", logName);
                   pageContext.setAttribute("pathSeparator", File.separator);
               %>
               <c:url var="viewLogUrl" value="${ViewLogTasks.viewLog}">
                 <c:param name="log_name" value="${logPath}" />
                 <c:param name="pathSeparator" value="${pathSeparator}"/>
               </c:url>
               <c:set var="viewLogUrl" value="${fn:escapeXml(viewLogUrl)}"/>
               <c:choose>
                 <c:when test="${logName == 'output'}">
                   <ucf:link href="#" label="${ub:i18n('View')} ${logName}" disabledLabel="${ub:i18n('No')} ${logName}"
                        img="${outputImage}" enabled="${true}" onclick="showLogViewer('${ah3:escapeJs(viewLogUrl)}'); return false;"/>
                 </c:when>
                 <c:otherwise>
                   <ucf:link href="#" label="${ub:i18n('View')} ${logName}" disabledLabel="${ub:i18n('No')} ${logName}"
                        img="${logImage}" enabled="${true}" onclick="showLogViewer('${ah3:escapeJs(viewLogUrl)}'); return false;"/>
                 </c:otherwise>
               </c:choose>
               <%
                 }
               %>
              </td>
            </tr>
          </tbody>

      </c:forEach>

    </c:forEach>
  </table>

  <div style="clear: both;"></div>

</div>
