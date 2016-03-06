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
<%@page import="com.urbancode.ubuild.domain.schedule.Schedule" %>
<%@page import="com.urbancode.ubuild.domain.schedule.ScheduleFactory" %>
<%@page import="com.urbancode.ubuild.domain.trigger.Trigger" %>
<%@page import="com.urbancode.ubuild.domain.trigger.remoterequest.repository.RepositoryRequestTrigger" %>
<%@page import="com.urbancode.ubuild.domain.trigger.remoterequest.repository.workflow.RepositoryRequestRunWorkflowTrigger" %>
<%@ page import="com.urbancode.ubuild.domain.trigger.scheduled.ScheduledTrigger" %>
<%@ page import="com.urbancode.ubuild.domain.trigger.scheduled.workflow.ScheduledRunWorkflowTrigger" %>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowPriorityEnum"%>
<%@ page import="com.urbancode.air.i18n.TranslateMessage" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ page import="com.urbancode.ubuild.web.util.FormErrors" %>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<%
    FormErrors errors = ((FormErrors)pageContext.findAttribute(WebConstants.ERRORS));
    if (errors==null) {
        errors = new FormErrors();
        request.setAttribute(WebConstants.ERRORS, errors);
    }

    EvenOdd eo = new EvenOdd();
    pageContext.setAttribute("eo", eo);

    // add schedule list
    Schedule[] scheduleList = ScheduleFactory.getInstance().restoreAll();
    if (scheduleList.length == 0) {
        String errorMessage = TranslateMessage.translate("TriggerNoSchedulesError");
        errors.addFieldError(WebConstants.SCHEDULE_ID, errorMessage);
    }
    pageContext.setAttribute(WebConstants.SCHEDULE_LIST, scheduleList);
%>

<%-- URLs --%>
<c:url var="cancelUrl" value="${WorkflowTasks.cancelTrigger}"></c:url>
<c:url var="saveUrl"   value="${WorkflowTasks.saveTrigger}"/>
<c:url var="editUrl"   value="${WorkflowTasks.editTrigger}">
  <c:param name="triggerId" value="${trigger.id}"/>
</c:url>
<c:url var="backUrl"   value="${WorkflowTasks.viewTriggers}">
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>

<%-- *** CONTENT *** --%>
<br/>
<form method="post" action="${fn:escapeXml(saveUrl)}#trigger">
  <ucf:hidden name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
  <span class="bold">${ub:i18n("ScheduledTrigger")}</span>
  <div style="text-align: right;" class="required-text">${ub:i18n("RequiredField")}</div>
  <table class="property-table">
    <tbody>

      <error:field-error field="${WebConstants.NAME}" cssClass="<%=eo.getNext()%>"/>
      <tr class="<%=eo.getLast() %>" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
        <td align="left" width="20%">
          <ucf:text name="${WebConstants.NAME}" value="${trigger.name}" enabled="${inEditMode}"/>
        </td>

        <td align="left">
          <span class="inlinehelp">${ub:i18n("TriggerNameDesc")}</span>
        </td>
      </tr>

      <error:field-error field="priority" cssClass="<%=eo.getNext()%>"/>
      <tr class="<%=eo.getLast() %>" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("PriorityWithColon")} </span></td>
        <td align="left" width="20%">
            <%
              pageContext.setAttribute("priorityNames", new String[]{
                      TranslateMessage.translate(WorkflowPriorityEnum.LOW.getName()),
                      TranslateMessage.translate(WorkflowPriorityEnum.NORMAL.getName()),
                      TranslateMessage.translate(WorkflowPriorityEnum.HIGH.getName()),
                  });
              pageContext.setAttribute("priorityValues", new String[]{
                      String.valueOf(WorkflowPriorityEnum.LOW.getId()),
                      String.valueOf(WorkflowPriorityEnum.NORMAL.getId()),
                      String.valueOf(WorkflowPriorityEnum.HIGH.getId())
                  });
            %>
            <ucf:stringSelector name="priority" canUnselect="${false}"
                list="${priorityNames}"
                valueList="${priorityValues}"
                selectedValue="${trigger.priority.id}"
                enabled="${inEditMode}"
                />
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("TriggerPriorityDesc")}</span>
        </td>
      </tr>

      <error:field-error field="enabled" cssClass="<%=eo.getNext()%>"/>
      <tr class="<%=eo.getLast() %>" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("EnabledWithColon")} </span></td>
        <td align="left" width="20%">
          <ucf:checkbox name="enabled" value="true" checked="${trigger.enabled}" enabled="${inEditMode}"/>
        </td>

        <td align="left">
          <span class="inlinehelp">${ub:i18n("TriggerEnabledDesc")}</span>
        </td>
      </tr>

      <error:field-error field="${WebConstants.SCHEDULE_ID}" cssClass="<%=eo.getNext() %>"/>
      <tr class="<%=eo.getLast() %>">
        <td align="left" width="20%"><span class="bold">${ub:i18n("ScheduleWithColon")} <span class="required-text">*</span></span></td>
        <td align="left" width="20%">
          <ucf:idSelector name="${WebConstants.SCHEDULE_ID}"
                        list="${scheduleList}"
                        selectedId="${trigger.schedule.id}"
                        enabled="${inEditMode}"/>
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("TriggerScheduleDesc")}</span>
        </td>
      </tr>

      <error:field-error field="${WebConstants.SCHEDULE_BUILD_LIFE_SCRIPT}" cssClass="<%=eo.getNext() %>"/>
      <tr class="<%=eo.getLast() %>">
        <td align="left" width="20%"><span class="bold">${ub:i18n("BuildLifeScript")} <span class="required-text">*</span></span></td>
        <td align="left" colspan="2">
          <span class="inlinehelp">${ub:i18n("TriggerBuildLifeScriptDesc")}<br/>
            &nbsp;&nbsp;&nbsp;${ub:i18nMessage("TriggerBuildLifeScriptDescProject", fn:escapeXml(trigger.workflow.project.name))}<br/>
            &nbsp;&nbsp;&nbsp;${ub:i18nMessage("TriggerBuildLifeScriptDescWorkflow", fn:escapeXml(trigger.workflow.name))}<br/>
          <br/>
          ${ub:i18n("TriggerBuildLifeScriptDescExample")}<br/>
            <br/>
            <span class="code">import com.urbancode.ubuild.domain.buildlife.*;<br/>
<br/>
profile = project.getWorkflow("Build Workflow").getBuildProfile();<br/>
status = project.getStatusGroup().getSuccessStatus();<br/>
<br/>
return BuildLifeFactory.getInstance().restoreMostRecentCompletedForProfileAndStatusAndStampValue(profile, status, null);</span>
            <br/>
          </span><br/>
          <ucf:textarea name="${WebConstants.SCHEDULE_BUILD_LIFE_SCRIPT}" value="${trigger.script}"
                      cols="80" rows="5"
                      enabled="${inEditMode}"/>
        </td>
      </tr>

      <c:import url="/WEB-INF/jsps/admin/project/workflow/trigger/triggerProperties.jsp">
        <c:param name="inEditMode" value="${inEditMode}"/>
        <c:param name="eo" value="${eo.last}"/>
      </c:import>

      <tr>
        <td colspan="3">
          <c:if test="${inEditMode}">
            <ucf:button name="saveTrigger" label="${ub:i18n('Save')}"/>
            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}#trigger"/>
          </c:if>
          <c:if test="${inViewMode}">
            <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}#trigger"/>
        <ucf:button name="Done" label="${ub:i18n('Done')}" href="${backUrl}"/>
          </c:if>
        </td>
      </tr>
    </tbody>
  </table>
</form>
