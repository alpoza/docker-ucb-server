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
<%@page import="com.urbancode.ubuild.domain.trigger.Trigger" %>
<%@page import="com.urbancode.ubuild.domain.trigger.scheduled.ScheduledTrigger" %>
<%@page import="com.urbancode.ubuild.domain.trigger.postprocess.PostProcessTrigger" %>
<%@page import="com.urbancode.ubuild.domain.trigger.postprocess.PostProcessTriggerConditionEnum" %>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowPriorityEnum"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@ page import="com.urbancode.air.i18n.TranslateMessage" %>
<%@ page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ page import="com.urbancode.ubuild.web.util.FormErrors" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.urbancode.commons.util.CollectionUtil" %>

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

    Trigger trigger = (Trigger)pageContext.findAttribute(WebConstants.TRIGGER);
    pageContext.setAttribute("conditionsList", PostProcessTriggerConditionEnum.values());
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
  <span class="bold">${ub:i18n("PostProcessTrigger")}</span>
  <c:set var="triggerSecondaryProcess" value="${trigger.secondaryProcess != null ? trigger.secondaryProcess : triggerSecondaryProcess}"/>
  <div style="text-align: right;" class="required-text">${ub:i18n("RequiredField")}</div>
  <table class="property-table">
    <tbody>
      <c:choose>
        <c:when test="${triggerSecondaryProcess == null}">
          <error:field-error field="triggerSecondaryProcessId" cssClass="<%=eo.getNext()%>"/>
          <tr class="<%=eo.getLast() %>" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("SecondaryProcessWithColon")} <span class="required-text">*</span></span></td>
            <td align="left" width="20%">
              <%
                List<Workflow> secondaryProcesses = new ArrayList<Workflow>(Arrays.asList(trigger.getProject().getSecondaryProcessArray()));
                // If this is a trigger from a secondary process, we want to remove it from the list of secondary processes
                if (secondaryProcesses.contains(trigger.getWorkflow())) {
                    secondaryProcesses.remove(trigger.getWorkflow());
                }

                pageContext.setAttribute("secondaryProcessList", secondaryProcesses);
              %>
                <ucf:idSelector name="triggerSecondaryProcessId"
                    canUnselect="${false}"
                    list="${secondaryProcessList}"
                    selectedId="${trigger.secondaryProcess.id}"
                    enabled="${inEditMode}"
                    />
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("TriggerSecondaryDesc")}</span>
            </td>
            <ucf:hidden name="submitted" value="true"/>
            <ucf:hidden name="enabled" value="true"/>
          </tr>
        </c:when>
        <c:otherwise>
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

          <tr class="<%=eo.getLast() %>" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("SecondaryProcessWithColon")} <span class="required-text">*</span></span></td>
            <ucf:hidden name="triggerSecondaryProcessId" value="${triggerSecondaryProcess.id}"/>
            <td align="left" width="20%">${triggerSecondaryProcess.name}</td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("TriggerSecondaryDesc")}</span>
            </td>
          </tr>

          <error:field-error field="condition" cssClass="<%=eo.getNext()%>"/>
          <tr class="<%=eo.getLast() %>" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("Condition")} <span class="required-text">*</span></span></td>
            <td align="left" width="20%">
                <ucf:enumSelector name="condition"
                    canUnselect="${false}"
                    list="${conditionsList}"
                    selectedValue="${param.condition != null ? param.condition : trigger.condition}"
                    enabled="${inEditMode}"
                    />
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("TriggerConditionDesc")}</span>
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

          <c:import url="/WEB-INF/jsps/admin/project/workflow/trigger/postprocess/triggerProperties.jsp">
            <c:param name="inEditMode" value="${inEditMode}"/>
            <c:param name="eo" value="${eo.last}"/>
          </c:import>
        </c:otherwise>
      </c:choose>

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
