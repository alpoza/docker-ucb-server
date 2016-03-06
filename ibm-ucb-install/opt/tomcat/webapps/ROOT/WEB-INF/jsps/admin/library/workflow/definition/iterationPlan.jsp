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
<%@page import="com.urbancode.ubuild.domain.workflow.FixedJobIterationPlan" %>
<%@page import="com.urbancode.ubuild.domain.workflow.AgentPoolJobIterationPlan" %>
<%@page import="com.urbancode.ubuild.domain.workflow.JobIterationPlan" %>
<%@page import="com.urbancode.ubuild.domain.workflow.PropertyJobIterationPlan" %>
<%@page import="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks" %>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<c:url var="saveJobIterationPlanUrl" value="${WorkflowDefinitionTasks.saveJobIterationPlan}"/>

<%-- CONTENT --%>

<script type="text/javascript">
<!--
function iterationTypeChanged() {
  var fixedIterationRadio = $('fixedIterationRadio');
  var agentPoolIterationRadio = $('agentPoolIterationRadio');
  var propertyIterationRadio = $('propertyIterationRadio');

  if ($('fixedIterationRadio').checked) {
      $('agentPoolIterationFields').hide();
      $('propertyIterationFields').hide();
      $('fixedIterationFields').show();
      $('uniqueAgentField').show();
  }
  else if ($('agentPoolIterationRadio').checked) {
      $('agentPoolIterationFields').show();
      $('propertyIterationFields').hide();
      $('fixedIterationFields').hide();
      $('uniqueAgentField').hide();
  }
  else if ($('propertyIterationRadio').checked) {
      $('agentPoolIterationFields').hide();
      $('propertyIterationFields').show();
      $('fixedIterationFields').hide();
      $('uniqueAgentField').show();
  }
}
Event.observe(window, 'load', function() { iterationTypeChanged(); });
-->
</script>

<%
    String iterationType = (String) pageContext.findAttribute("iterationType");
    if ("AgentPool".equals(iterationType)) {
        pageContext.setAttribute("agentPoolChecked", "checked='checked'");
    }
    else if ("Property".equals(iterationType)) {
        pageContext.setAttribute("propertyChecked", "checked='checked'");
    }
    else {
        pageContext.setAttribute("fixedChecked", "checked='checked'");
    }
%>

<form method="post" action="${fn:escapeXml(saveJobIterationPlanUrl)}">
    <input type="hidden" name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${fn:escapeXml(selectedWorkflowDefinitionJobConfig.id)}">

    <div class="system-helpbox">${ub:i18n("LibraryWorkflowIterationPlanSystemHelpBox")}</div>
    <br/>
    <div align="right">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <table class="property-table">

        <tbody>
            <error:field-error field="${WebConstants.WORKFLOW_DEFINITION_JOB_CONFIG_ID}" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("JobWithColon")}</span></td>
                <td align="left" width="20%">
                    ${fn:escapeXml(selectedWorkflowDefinitionJobConfig.jobConfig.name)}
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("LibraryWorkflowIterationPlanJobDesc")}</span>
                </td>
            </tr>

            <tr class="${eo.next}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowIterationType")} <span class="required-text">*</span></span></td>
                <td align="left" colspan="2">
                    <input id="fixedIterationRadio" name="iterationType" type="radio" value="Fixed"
                       onchange="iterationTypeChanged();" ${fixedChecked}>${ub:i18n("Fixed")}
                    <div class="inlinehelp" style="margin: 5px 25px 10px 25px;">
                      ${ub:i18n("LibraryWorkflowIterationTypeFixedDesc")}
                    </div>
                    <input id="agentPoolIterationRadio" name="iterationType" type="radio" value="AgentPool"
                       onchange="iterationTypeChanged();" ${agentPoolChecked}>${ub:i18n("Agent Pool")}
                    <div class="inlinehelp" style="margin: 5px 25px 10px 25px;">
                      ${ub:i18n("LibraryWorkflowIterationTypeAgentPoolDesc")}
                    </div>
                    <input id="propertyIterationRadio" name="iterationType" type="radio" value="Property"
                       onchange="iterationTypeChanged();" ${propertyChecked}>${ub:i18n("Property")}
                    <div class="inlinehelp" style="margin: 5px 25px 10px 25px;">
                      ${ub:i18n("LibraryWorkflowIterationTypePropertyDesc")}
                    </div>
                </td>
            </tr>
        </tbody>

        <tbody id="fixedIterationFields">
            <error:field-error field="${WebConstants.ITERATIONS}" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowIterations")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                    <ucf:text name="${WebConstants.ITERATIONS}" size="10" value="${iterations}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("LibraryWorkflowIterationsDesc")}</span>
                </td>
            </tr>
        </tbody>

        <tbody id="agentPoolIterationFields">
            <error:field-error field="requireAllAgents" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("AllAgents")} </span></td>
                <td align="left" width="20%">
                    <ucf:yesOrNo name="requireAllAgents" value="${requireAllAgents}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("LibraryWorkflowIterationAllAgentsDesc")}</span>
                </td>
            </tr>
        </tbody>

        <tbody id="propertyIterationFields">
            <error:field-error field="propertyName" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("PropertyWithColon")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                    <ucf:text name="propertyName" value="${propertyName}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("LibraryWorkflowIterationPropertyDesc")}</span>
                </td>
            </tr>
        </tbody>

        <%-- Fixed and Property iteration types --%>
        <tbody id="uniqueAgentField">
            <error:field-error field="runningOnUniqueAgents" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowIterationUniqueAgents")} </span></td>
                <td align="left" width="20%">
                    <ucf:yesOrNo name="runningOnUniqueAgents" value="${runningOnUniqueAgents}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("LibraryWorkflowIterationUniqueAgentsDesc")}</span>
                </td>
            </tr>
        </tbody>

        <%-- All iteration types --%>
        <tbody id="parallelIterationField">
            <error:field-error field="${WebConstants.IS_PARALLEL}" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowIterationRunInParallel")} </span></td>
                <td align="left" width="20%">
                    <ucf:yesOrNo name="${WebConstants.IS_PARALLEL}" value="${isParallel}"
                      yesClicked="showLayer('maxParallelJobs');"
                      noClicked="hideLayer('maxParallelJobs');"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("LibraryWorkflowIterationRunInParallelDesc")}</span>
                </td>
            </tr>
        </tbody>

        <%-- Parallel iterations --%>
        <tbody id="maxParallelJobs" <c:if test="${!isParallel}">style="display: none;visibility: visibility;"</c:if>>
            <error:field-error field="${WebConstants.MAX_PARALLEL_JOBS}" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowIterationMaxParallel")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                    <ucf:text name="${WebConstants.MAX_PARALLEL_JOBS}" size="10" value="${maxParallelJobs}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("LibraryWorkflowIterationMaxParallelDesc")}</span>
                </td>
            </tr>
        </tbody>

    </table>
    <br/>
    <ucf:button name="iterateJob" label="${ub:i18n('LibraryWorkflowSetIteration')}" enabled="${viewJsp == null}"/>
    <c:if test="${showRemoveButton == true}">
        <ucf:button name="removeJobIteration" label="${ub:i18n('LibraryWorkflowRemoveIteration')}" enabled="${viewJsp == null}"/>
    </c:if>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="window.parent.hidePopup();" submit="${false}"/>
</form>
