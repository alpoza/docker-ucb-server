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

<c:url var="restartWorkflowUrl"  value="${BuildLifeTasks.restartWorkflow}">
  <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${workflow_case.id}"/>
</c:url>

<%
    WorkflowCase workflow_case = (WorkflowCase) pageContext.findAttribute(WebConstants.WORKFLOW_CASE);
%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<script type="text/javascript">
<!--
function toggleJobSteps(input) {
    var _input = $(input);
    var open = _input.checked;
    var jobTBody = _input.up('tbody');
    var jobTBodyId = jobTBody.id;
    var stepTBody = $(jobTBodyId + '_steps');
    if (stepTBody) {
        if (open) {
            stepTBody.show();
        } else {
            stepTBody.hide();
        }
    }
}
//-->
</script>
  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18nMessage("RestartProcessLabel", fn:escapeXml(workflow_case.name))}</a></li>
    </ul>
  </div>
  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("RestartProcessHelp")}
    </div>
    <br/>

    <form action="${fn:escapeXml(restartWorkflowUrl)}" method="post">
      <table class="property-table">
        <tbody>
          <error:field-error field="restartSelection"/>
          <tr class="odd" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("JobStepSelection")}</span></td>

            <td align="left" colspan="2">
              ${ub:i18n("RestartProcessDesc")}
            </td>
          </tr>
          <tr class="odd" valign="top">
            <td colspan="3">
              <table class="data-table" width="100%">
                <thead>
                  <tr class="bl_workflow_case_title_bar">
                    <th style="width: 10%;">${ub:i18n("Restart")}</th>
                    <th style="width: 35%;">${ub:i18n("Job")} / ${ub:i18n("Step")}</th>
                    <th style="width: 20%;">${ub:i18n("Agent")}</th>
                    <th style="width: 10%;">${ub:i18n("Start")} / ${ub:i18n("Offset")}</th>
                    <th style="width: 10%;">${ub:i18n("Duration")}</th>
                    <th style="width: 15%;">${ub:i18n("Status")}</th>
                  </tr>
                </thead>

                <%-- JOBS --%>
                <%
                  pageContext.setAttribute("job_eo", new EvenOdd());
                %>
                <c:forEach var="jobTrace" items="${workflow_case.jobTraceArray}" varStatus="traceLoop">
                  <%
                    BuildLifeJobTrace jobTrace = (BuildLifeJobTrace) pageContext.findAttribute("jobTrace");
                  %>
                  <tbody id="job_${jobTrace.id}">
                    <tr class="${job_eo.next}">
                      <td style="text-align: center;">
                        <%
                        pageContext.setAttribute("jobSelectedForRestart", Boolean.FALSE);
                        String[] restartJobIds = request.getParameterValues("restartJobId");
                        if (restartJobIds != null) {
                            for (String restartJobId : restartJobIds) {
                                if (String.valueOf(jobTrace.getId()).equals(restartJobId)) {
                                    pageContext.setAttribute("jobSelectedForRestart", Boolean.TRUE);
                                    break;
                                }
                            }
                        }
                        %>
                        <input type="checkbox" name="restartJobId" value="${jobTrace.id}" onclick="toggleJobSteps(this)"
                          <c:if test="${jobSelectedForRestart}">checked="true"</c:if>/>
                      </td>
                      <td>
                        ${fn:escapeXml(jobTrace.name)}
                      </td>
                      <td align="center">${fn:escapeXml(jobTrace.agent.name)}</td>
                      <td align="center">
                        <c:if test="${not empty workflow_case.startDate}">
                          <%=new Duration(workflow_case.getStartDate(), jobTrace.getStartDate())%>
                        </c:if>
                      </td>
                      <td align="center"><c:out value="${jobTrace.duration}" default=""/></td>
                      <td align="center" style="background-color: ${fn:escapeXml(jobTrace.status.color)};
                        color: ${fn:escapeXml(jobTrace.status.secondaryColor)};">${fn:escapeXml(ub:i18n(jobTrace.status.name))}</td>
                    </tr>
                  </tbody>

                  <tbody id="job_${jobTrace.id}_steps" <c:if test="${not jobSelectedForRestart}">style="display: none;"</c:if>>
                    <%
                      pageContext.setAttribute("step_eo", new EvenOdd());
                      Date jobStartDate = jobTrace.getStartDate();
                    %>
                    <tr class="sub_row_${step_eo.next}">
                      <td>&nbsp;</td>
                      <td align="left" colspan="5">
                        <%
                        pageContext.setAttribute("stepSelectedForRestart", "-1".equals(request.getParameter("restartStepIndex_" + jobTrace.getId())));
                        %>
                        <input type="radio" name="restartStepIndex_${jobTrace.id}" value="-1"
                          <c:if test="${stepSelectedForRestart}">checked="true"</c:if>/>
                        ${ub:i18n("RestartProcessRestartJobOnNewAgent")}
                      </td>
                    </tr>
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

                      <tr class="sub_row_${step_eo.next}">
                        <td>&nbsp;</td>
                        <td align="left" nowrap="nowrap">
                          <c:set var="stepIndex" value="${stepLoop.index}"/>
                          <%
                          String stepIndex = String.valueOf(pageContext.getAttribute("stepIndex"));
                          pageContext.setAttribute("stepSelectedForRestart", stepIndex.equals(request.getParameter("restartStepIndex_" + jobTrace.getId())));
                          %>
                          <input type="radio" name="restartStepIndex_${jobTrace.id}" value="${stepLoop.index}"
                            <c:if test="${stepSelectedForRestart}">checked="true"</c:if>/>
                          ${stepLoop.index+1}. ${fn:escapeXml(step.name)}
                        </td>
                        <td align="center">${fn:escapeXml(jobTrace.agent.name)}</td>
                        <td align="center" nowrap="nowrap"><%= stepOffset %></td>
                        <td align="center" nowrap="nowrap"><%= stepDuration %></td>
                        <td align="center" nowrap="nowrap" style="background-color: ${fn:escapeXml(step.status.color)};
                             color: ${fn:escapeXml(step.status.secondaryColor)};">${fn:escapeXml(ub:i18n(step.status.name))}</td>
                      </tr>

                    </c:forEach>
                  </tbody>
                </c:forEach>
              </table>

            </td>
          </tr>
        </tbody>
      </table>
      <br/>
      <ucf:button name="Restart" label="${ub:i18n('Restart')}" id="restartButton"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="parent.hidePopup(); return false;"/>
    </form>

  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
