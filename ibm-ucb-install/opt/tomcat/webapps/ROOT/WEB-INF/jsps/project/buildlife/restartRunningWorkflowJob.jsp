<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.jobtrace.StepTrace" %>
<%@page import="com.urbancode.ubuild.domain.jobtrace.buildlife.BuildLifeJobTrace" %>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowCase" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@page import="com.urbancode.commons.util.Duration" %>
<%@page import="java.util.Date" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error"  uri="error" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="restartJobUrl"  value="${BuildLifeTasks.restartRunningWorkflowJob}">
  <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
  <c:param name="${WebConstants.JOB_TRACE_ID}" value="${jobTrace.id}"/>
</c:url>

<%
    BuildLifeJobTrace jobTrace = (BuildLifeJobTrace) pageContext.findAttribute(WebConstants.JOB_TRACE);
    WorkflowCase workflow_case = (WorkflowCase) pageContext.findAttribute(WebConstants.WORKFLOW_CASE);
%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18nMessage("RestartProcessLabel", fn:escapeXml(jobTrace.name))}</a></li>
    </ul>
  </div>
  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("RestartRunningProcessHelp")}
    </div>
    <br/>
    <div style="text-align: right;" class="required-text">${ub:i18n("RequiredField")}</div>

    <form action="${fn:escapeXml(restartJobUrl)}" method="post">
      <table class="property-table">
        <tbody>
          <error:field-error field="agentSelection"/>
          <tr class="odd" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("AgentSelection")} <span class="required-text">*</span></span></td>

            <td align="left" colspan="2">
              <input type="radio" name="agentSelection" value="existing" <c:if test="${param.agentSelection eq 'existing'}">checked="true"</c:if>
                onclick="$('restartAllStepsMessage').hide();$('restartStepSelection').show();"/>
              ${ub:i18nMessage("RestartRunningProcessWithSameAgent", fn:escapeXml(jobTrace.agent.name))}
              <br/><br/>
              <input type="radio" name="agentSelection" value="new" <c:if test="${param.agentSelection eq 'new'}">checked="true"</c:if>
                onclick="$('restartStepSelection').hide();$('restartAllStepsMessage').show();$('restartButton').removeClassName('buttondisabled').addClassName('button').enable();"/>
              ${ub:i18n("RestartRunningProcessWithNewAgent")}
            </td>
          </tr>
        </tbody>
        <tbody id="restartStepSelection" <c:if test="${param.agentSelection ne 'existing'}">style="display: none;"</c:if>>
          <error:field-error field="restartStepIndex"/>
          <tr class="odd" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("StepSelection")} <span class="required-text">*</span></span></td>

            <td align="left" colspan="2">
              ${ub:i18n("RestartRunningProcessDesc")}
            </td>
          </tr>
          <tr class="odd" valign="top">
            <td colspan="3">
              <table class="data-table" width="100%">
                <thead>
                  <tr class="bl_workflow_case_title_bar">
                    <th style="width: 10%;">${ub:i18n("Restart")}</th>
                    <th style="width: 45%;">${ub:i18n("Step")}</th>
                    <th style="width: 20%;">${ub:i18n("Start")} / ${ub:i18n("Offset")}</th>
                    <th style="width: 10%;">${ub:i18n("Duration")}</th>
                    <th style="width: 15%;">${ub:i18n("Status")}</th>
                  </tr>
                </thead>

                <tbody>
                  <%
                    pageContext.setAttribute("step_eo", new EvenOdd());
                    Date jobStartDate = jobTrace.getStartDate();
                  %>
                  <c:forEach var="step" items="${jobTrace.stepTraceArray}" varStatus="stepLoop">
                    <c:set var="startDate" value="${step.startDate}"/>
                    <c:set var="endDate" value="${step.endDate}"/>
                    <c:set var="isStepDone" value="${endDate != null}"/>
                    
                    <c:set var="stepOpen" value="${!isStepDone || !step.status.success}"/>
                        
                    <%
                      StepTrace step = (StepTrace) pageContext.findAttribute("step");
                        
                      Date stepStartDate = (Date) pageContext.findAttribute("startDate");
                      String stepOffset = jobStartDate == null ? "-" : new Duration(jobStartDate, stepStartDate).toString();

                      Date stepEndDate = (Date) pageContext.findAttribute("endDate");
                      String stepDuration = stepStartDate == null ? "-" : new Duration(stepStartDate, stepEndDate).toString();
                    %>
                      
                    <tr class="${step_eo.next}">
                      <td style="text-align: center;">
                        <input type="radio" name="restartStepIndex" value="${stepLoop.index}"
                          onclick="$('restartButton').removeClassName('buttondisabled').addClassName('button').enable();"/>
                      </td>
                      <td align="left" nowrap="nowrap">${stepLoop.index+1}. ${fn:escapeXml(step.name)}</td>
                      <td align="center" nowrap="nowrap"><%= stepOffset %></td>
                      <td align="center" nowrap="nowrap"><%= stepDuration %></td>
                      <td align="center" nowrap="nowrap"
                        style="background-color: ${fn:escapeXml(step.status.color)}; color: ${fn:escapeXml(step.status.secondaryColor)};">
                        ${fn:escapeXml(step.status.name)}</td>
                    </tr>
                    
                  </c:forEach>
                </tbody>
              </table>
            
          </td>
        </tr>
      </tbody>
      <tbody id="restartAllStepsMessage" <c:if test="${param.agentSelection ne 'new'}">style="display: none;"</c:if>>
        <tr class="odd" valign="top">
          <td colspan="3">
            <span class="bold">${ub:i18n("RestartRunningProcessRestartAllStepsDesc")}</span>
          </td>
        </tr>
      </tbody>
    </table>
    <br/>
    <ucf:button name="Restart" label="${ub:i18n('Restart')}" id="restartButton" enabled="false"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="parent.hidePopup(); return false;"/>
  </form>

  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
