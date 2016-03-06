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
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>

<c:url var="imgUrl" value="/images"/>
<c:url var="spacerImage" value="/images/spacer.gif"/>
<c:url var="iconPlusUrl" value="/images/icon_plus_sign.gif"/>
<c:url var="iconMinusUrl" value="/images/icon_minus_sign.gif"/>
<c:url var="iconRestartUrl" value="/images/icon_restart.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconMagnifyUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconSuspendUrl" value="/images/icon_suspend.gif"/>
<c:url var="iconResumeUrl" value="/images/icon_resume.gif"/>
<c:url var="iconPriorityUrl" value="/images/icon_priority.gif"/>
<c:url var="logImage" value="/images/icon_note_file.gif"/>
<c:url var="outputImage" value="/images/icon_output.gif"/>
<c:url var="restartImage" value="/images/icon_restart.gif"/>

<%-- CONTENT --%>

<c:import url="workflowCaseHeader.jsp">
  <c:param name="selected" value="main"/>
</c:import>
<c:if test="${!empty errorMsg}"><div class="error">${fn:escapeXml(errorMsg)}</div><br/></c:if>

<script type="text/javascript">
<!--
function toggleWorkflowAll(link) {
    var _link = $(link);
    var workflowDiv = _link.up('div.bl_workflow_case_bg');
    var workflowDivId = workflowDiv.id;
    var open = _link.down('img').src.endsWith('${iconPlusUrl}');
    if (open) {
        _link.down('img').src = '${iconMinusUrl}';
        $(workflowDivId).down('tbody').down('img').src = '${iconMinusUrl}';
    } else {
        _link.down('img').src = '${iconPlusUrl}';
        $(workflowDivId).down('tbody').down('img').src = '${iconPlusUrl}';
    }
    $$('tbody[id^=' + workflowDivId + '_job]').each(function(childTBody) {
        if (open) {
            childTBody.show();
            if (!childTBody.hasClassName('commands-visible') && !childTBody.hasClassName('commands-hidden'))  {
                childTBody.down('img').src = '${iconMinusUrl}';
            }
            if (childTBody.hasClassName('step-hidden'))  {
                childTBody.removeClassName('step-hidden');
                childTBody.addClassName('step-visible');
            }
            else if (childTBody.hasClassName('commands-hidden'))  {
                childTBody.removeClassName('commands-hidden');
                childTBody.addClassName('commands-visible');
            }
        } else {
            childTBody.hide();
            if (!childTBody.hasClassName('commands-visible') && !childTBody.hasClassName('commands-hidden'))  {
                childTBody.down('img').src = '${iconPlusUrl}';
            }
            if (childTBody.hasClassName('step-visible'))  {
                childTBody.removeClassName('step-visible');
                childTBody.addClassName('step-hidden');
            }
            else if (childTBody.hasClassName('commands-visible'))  {
                childTBody.removeClassName('commands-visible');
                childTBody.addClassName('commands-hidden');
            }
        }
    });
}

function toggleWorkflowJobs(link) {
    var _link = $(link);
    var open = _link.down('img').src.endsWith('${iconPlusUrl}');
    if (open) {
        _link.down('img').src = '${iconMinusUrl}';
    } else {
        _link.down('img').src = '${iconPlusUrl}';
    }
    var workflowDiv = _link.up('div.bl_workflow_case_bg');
    var workflowDivId = workflowDiv.id;
    $$('tbody[id^=' + workflowDivId + '_job]').each(function(jobTBody) {
        if (open) {
            if (!jobTBody.hasClassName('step-hidden') && !jobTBody.hasClassName('commands-hidden'))  {
                jobTBody.show();
            }
        } else {
            jobTBody.hide();
        }
    });
}

function toggleJobSteps(link) {
    var _link = $(link);
    var open = _link.down('img').src.endsWith('${iconPlusUrl}');
    if (open) {
        _link.down('img').src = '${iconMinusUrl}';
    } else {
        _link.down('img').src = '${iconPlusUrl}';
    }
    var jobTBody = _link.up('tbody');
    var jobTBodyId = jobTBody.id;
    $$('tbody[id^=' + jobTBodyId + '_step]').each(function(stepTBody) {
        if (open) {
            if (stepTBody.hasClassName('step-hidden')) {
                stepTBody.removeClassName('step-hidden');
                stepTBody.addClassName('step-visible');
                stepTBody.show();
            } else if (!stepTBody.hasClassName('commands-hidden'))  {
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

function toggleStepCommands(link) {
    var _link = $(link);
    var open = _link.down('img').src.endsWith('${iconPlusUrl}');
    if (open) {
        _link.down('img').src = '${iconMinusUrl}';
    } else {
        _link.down('img').src = '${iconPlusUrl}';
    }
    var stepTBody = _link.up('tbody');
    var stepTBodyId = stepTBody.id;
    $$('tbody[id^=' + stepTBodyId + '_cmds]').each(function(commandsTBody) {
        if (open) {
            commandsTBody.removeClassName('commands-hidden');
            commandsTBody.addClassName('commands-visible');
            commandsTBody.show();
        } else {
            commandsTBody.removeClassName('commands-visible');
            commandsTBody.addClassName('commands-hidden');
            commandsTBody.hide();
        }
    });
}
//-->
</script>


<c:if test="${!empty showOkMessage}">
  <c:remove var="showOkMessage" scope="session"/>
  <div class="dashboard-contents"><span class="message">${ub:i18n("ProcessRestarted")}</span></div>
</c:if>

<div id="statusNotNeededToggleButton" style="display: none; text-align: right; padding-top: 8px; font-size: x-small;">
  <a href="javascript:toggleDisplayForElementsWithClass('status-not-needed');">${fn:toUpperCase(ub:i18n("ShowHideNotNeededJobs"))}</a>
</div>

<c:import url="/WEB-INF/jsps/project/workflowcase/workflowCaseTable.jsp">
  <c:param name="isExpanded" value="true"/>
</c:import>

<c:import url="/WEB-INF/jsps/project/errors.jsp"/>

<c:import url="workflowCaseFooter.jsp"/>
