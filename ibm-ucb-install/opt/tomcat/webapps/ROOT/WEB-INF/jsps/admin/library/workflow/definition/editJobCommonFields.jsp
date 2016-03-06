<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.agentfilter.agentpool.AgentPoolFilter"%>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowDefinition"%>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowDefinitionJobConfig"%>
<%@page import="com.urbancode.ubuild.domain.agentfilter.AgentFilter" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowDefinitionJobConfigCleanupEnum"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="uiA" tagdir="/WEB-INF/tags/ui/admin/agentPool" %>
<%@taglib prefix="error" uri="error" %>

<c:url var="iconAddFixedAgentUrl" value="/images/icon_add.gif"/>
<c:url var="iconRemoveFixedAgentUrl" value="/images/icon_delete.gif"/>

<%
    EvenOdd eo = new EvenOdd();
    if ("odd".equalsIgnoreCase(request.getParameter("evenOdd"))) {
        eo.setOdd();
    }
    else {
        eo.setEven();
    }
    pageContext.setAttribute("eo", eo);

    WorkflowDefinitionJobConfig selectedWorkflowDefinitionJobConfig = (WorkflowDefinitionJobConfig) request.getAttribute("selectedWorkflowDefinitionJobConfig");
    WorkflowDefinition workflowDef = (WorkflowDefinition)request.getAttribute(WebConstants.WORKFLOW_DEFINITION);

    if (selectedWorkflowDefinitionJobConfig != null) {
        pageContext.setAttribute("preConditionScript", selectedWorkflowDefinitionJobConfig.getJobPreConditionScript());
        pageContext.setAttribute("lockForWorkflow", selectedWorkflowDefinitionJobConfig.isJobLockForWorkflow());
        pageContext.setAttribute("workDirScript", selectedWorkflowDefinitionJobConfig.getJobWorkDirScript());
        pageContext.setAttribute("useParentWorkDir", Boolean.valueOf(selectedWorkflowDefinitionJobConfig.isJobUsingParentWorkDir()));
        pageContext.setAttribute("useSourceWorkDirScript", Boolean.valueOf(selectedWorkflowDefinitionJobConfig.isJobUsingSourceWorkDirScript()));

        boolean isRootJob = workflowDef.getVertex(selectedWorkflowDefinitionJobConfig).getIncomingArcCount() == 0;
        pageContext.setAttribute("isRootJob", Boolean.valueOf(isRootJob));
    /*
        String agentFilterType = "prev";
        String agentFilterStr = "prev";
        AgentFilter agentFilter = selectedWorkflowDefinitionJobConfig.getJobAgentFilter();
        if(agentFilter instanceof AgentPoolFilter) {
            agentFilterType = "agentPool";
            agentFilterStr = "pool_" + ((AgentPoolFilter) agentFilter).getAgentPool().getId();
        }

        else if (selectedWorkflowDefinitionJobConfig.isAgentless()) {
            agentFilterType = "none";
            agentFilterStr = null;
        }
        pageContext.setAttribute("agentFilterStr", agentFilterStr);
        pageContext.setAttribute("agentFilterType", agentFilterType); */
    }
%>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.workflow.WorkflowDefinitionJobConfigCleanupEnum" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<error:field-error field="${WebConstants.JOB_PRE_CONDITION_ID}" cssClass="${eo.next}"/>
<tr class="${eo.last}" valign="top">
    <td align="left" width="20%"><span class="bold">${ub:i18n("PreConditionWithColon")} <span class="required-text">*</span></span></td>
    <td align="left" colspan="2">
        <c:set var="selectedId" value="<%= selectedWorkflowDefinitionJobConfig.getJobPreConditionScript().getId() %>"/>
        <ucf:idSelector name="${WebConstants.JOB_PRE_CONDITION_ID}"
                        list="${jobPreConditionList}"
                        onChange="preconditionScriptChanged();"
                        selectedId="${preConditionScript.id}"
                        />
      <br/>
      <div id="preconditionScriptDescription" class="inlinehelp" style="display: none; font-style: italic; margin-top: 1em;"></div>
      <br/>
        <span class="inlinehelp">${ub:i18n("LibraryWorkflowPreConditionDesc")}</span>
    </td>
</tr>

<error:field-error field="${WebConstants.AGENT_POOL_ID}" cssClass="${eo.next}"/>
<tr class="${eo.last}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("AgentSelection")} <span class="required-text">*</span></span></td>
  <td align="left" colspan="2">
     <uiA:agentPoolSelector
        agentFilter="${agent_pool}"
        disabled="${inViewMode}"
        allowNoAgent="true"
        allowParentJobAgent="${not isRootJob}"
        useRadio="true"
        agentPoolList="${agentPoolList}"
    />
  </td>
</tr>

<tbody id="agentBasedJobFields">
<error:field-error field="${WebConstants.WORK_DIR_SCRIPT_ID}" cssClass="${eo.next}"/>
<tr class="${eo.last}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowWorkingDirectory")} <span class="required-text">*</span></span></td>
  <td align="left" colspan="2">
    <select id="${WebConstants.WORK_DIR_SCRIPT_ID}" name="${WebConstants.WORK_DIR_SCRIPT_ID}" class="input" onchange="workDirScriptChanged();">
      <option value="">--&nbsp;${ub:i18n("MakeSelection")}&nbsp;--</option>
      <optgroup label="${ub:i18n('BuiltIn')}">
        <c:if test="${not isRootJob}">
          <option value="prev" <c:if test="${useParentWorkDir}">selected=""</c:if>>${ub:i18n("ParentJobWorkingDirectory")}</option>
        </c:if>
        <option value="source" <c:if test="${useSourceWorkDirScript}">selected=""</c:if>>${ub:i18n("SourceConfigWorkDirectory")}</option>
      </optgroup>
      <optgroup label="${ub:i18n('Scripted')}">
        <c:forEach var="tmpWorkDirScript" items="${workDirScriptList}">
          <option value="script_${tmpWorkDirScript.id}" <c:if test="${workDirScript.id eq tmpWorkDirScript.id}">selected=""</c:if>><c:out value="${tmpWorkDirScript.name}"/></option>
        </c:forEach>
      </optgroup>
    </select>
    <br/>
    <div id="workDirScriptDescription" class="inlinehelp" style="display: none; font-style: italic; margin-top: 1em;"></div>
    <br/>
    <span class="inlinehelp">${ub:i18n("LibraryWorkflowWorkingDirectoryDesc")}
    </span>
  </td>
</tr>

<tr class="${eo.next}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowWorkingDirectoryCleanup")} </span></td>
  <td align="left" width="20%">
    <c:set var="cleanupSelection" value="<%= selectedWorkflowDefinitionJobConfig.getCleanupChoice() %>"/>
    <%
    pageContext.setAttribute("cleanupChoiceList", WorkflowDefinitionJobConfigCleanupEnum.values());
    %>
        <ucf:enumSelector name="${WebConstants.CLEANUP_CONFIG}"
                          list="${cleanupChoiceList}"
                          selectedValue="${cleanupSelection}"
                          defaultValue="${WorkflowDefinitionJobConfigCleanupEnum.NEVER}"/>
  </td>
  <td align="left">
    <span class="inlinehelp">${ub:i18n("LibraryWorkflowWorkingDirectoryCleanupDesc")}</span>
  </td>
</tr>

<tr class="${eo.next}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowLockWorkflow")} </span></td>
  <td align="left" width="20%">
      <ucf:yesOrNo name="lockForWorkflow" value="${lockForWorkflow}"/>
  </td>
  <td align="left">
    <span class="inlinehelp">${ub:i18n("LibraryWorkflowLockWorkflowDesc")}
    </span>
  </td>
</tr>
</tbody>
