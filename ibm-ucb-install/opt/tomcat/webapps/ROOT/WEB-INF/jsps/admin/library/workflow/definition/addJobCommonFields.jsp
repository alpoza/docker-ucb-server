<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
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

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.workflow.WorkflowDefinitionJobConfigCleanupEnum" />

<c:url var="iconAddFixedAgentUrl" value="/images/icon_add.gif"/>
<c:url var="iconRemoveFixedAgentUrl" value="/images/icon_delete.gif"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<script type="text/javascript">
<!--
var jobDescHash = new Hash();
<c:forEach var="jobConfig" items="${jobConfigList}">
<c:if test="${fn:length(jobConfig.description) > 0}">
jobDescHash.set('<c:out value="${jobConfig.id}"/>', '<c:out value="${ah3:escapeJs(jobConfig.description)}"/>');
</c:if>
</c:forEach>

function jobChanged() {
    var selectedIndex = $('${WebConstants.JOB_CONFIG_ID}').selectedIndex;
    var selectedFilter = selectedIndex == null ? null : $('${WebConstants.JOB_CONFIG_ID}').options[selectedIndex].value;
    var description = jobDescHash.get(selectedFilter);
    $('jobDescription').update("${ub:i18nMessage("SelectedItem", description)}");
    if (description) {
        $('jobDescription').show();
    }
    else {
        $('jobDescription').hide();
    }
}

Event.observe(window, 'load', function() { jobChanged(); });
-->
</script>

<%
    EvenOdd eo = new EvenOdd();
    if ("odd".equalsIgnoreCase(request.getParameter("evenOdd"))) {
        eo.setOdd();
    }
    else {
        eo.setEven();
    }
    pageContext.setAttribute("eo", eo);
%>

<c:set var="fieldName" value="${WebConstants.JOB_CONFIG_ID}"/>
<error:field-error field="${WebConstants.JOB_CONFIG_ID}" cssClass="${eo.next}"/>
<tr class="${fn:escapeXml(eo.last)}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("JobWithColon")} <span class="required-text">*</span></span></td>
  <td align="left" colspan="2">
    <c:set var="jobConfigValue" value="${not empty param[fieldName] ? param[fieldName] : null}"/>
    <ucf:idSelector name="${fn:escapeXml(WebConstants.JOB_CONFIG_ID)}" selectedId="${jobConfigValue}" list="${jobConfigList}" onChange="jobChanged();"/>
    <br/>
    <div id="jobDescription" class="inlinehelp" style="display: none; font-style: italic; margin-top: 1em;"></div>
  </td>
</tr>

<c:set var="fieldName" value="${WebConstants.JOB_PRE_CONDITION_ID}"/>
<error:field-error field="${WebConstants.JOB_PRE_CONDITION_ID}" cssClass="${eo.next}"/>
<tr class="${eo.last}" valign="top">
    <td align="left" width="20%"><span class="bold">${ub:i18n("PreConditionWithColon")} <span class="required-text">*</span></span></td>
    <td align="left" colspan="2">
      <c:set var="preConditionValue" value="${not empty param[fieldName] ? param[fieldName] : null}"/>
      <ucf:idSelector name="${WebConstants.JOB_PRE_CONDITION_ID}"
                      list="${jobPreConditionList}"
                      onChange="preconditionScriptChanged();"
                      selectedId="${preConditionValue}"
                      />
      <br/>
      <div id="preconditionScriptDescription" class="inlinehelp" style="display: none; font-style: italic; margin-top: 1em;"></div>
      <br/>
      <span class="inlinehelp">${ub:i18n("LibraryWorkflowPreConditionDesc")}</span>
    </td>
</tr>


<c:set var="fieldName" value="agent_pool"/>
<error:field-error field="${WebConstants.AGENT_POOL_ID}" cssClass="${eo.next}"/>
<tr class="${eo.last}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("AgentSelection")} <span class="required-text">*</span></span></td>
  <td align="left" colspan="2">
    <c:set var="agentFilterValue" value="${not empty param[fieldName] ? param[fieldName] : null}"/>
    <uiA:agentPoolSelector
        agentFilter="${agentFilterValue}"
        disabled="${inViewMode}"
        allowNoAgent="true"
        allowParentJobAgent="${not isRootJob}"
        useRadio="true"
        agentPoolList="${agentPoolList}"
    />
  </td>
</tr>

<tbody id="agentBasedJobFields">
<c:set var="fieldName" value="${WebConstants.WORK_DIR_SCRIPT_ID}"/>
<error:field-error field="${WebConstants.WORK_DIR_SCRIPT_ID}" cssClass="${eo.next}"/>
<tr class="${eo.last}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowWorkingDirectory")} <span class="required-text">*</span></span></td>
  <td align="left" colspan="2">
    <select id="${WebConstants.WORK_DIR_SCRIPT_ID}" name="${WebConstants.WORK_DIR_SCRIPT_ID}" class="input" onchange="workDirScriptChanged();">
      <option value="">-- ${ub:i18n('MakeSelection')} --</option>
      <optgroup label="${ub:i18n('BuiltIn')}">
        <c:set var="workDirScriptValue" value="${not empty param[fieldName] ? param[fieldName] : null}"/>
        <c:if test="${not isRootJob}">
          <option value="prev" <c:if test="${workDirScriptValue eq 'prev'}">selected=""</c:if>>${ub:i18n('ParentJobWorkingDirectory')}</option>
        </c:if>
        <option value="source" <c:if test="${workDirScriptValue eq 'source'}">selected=""</c:if>>${ub:i18n('SourceConfigWorkDirectory')}</option>
      </optgroup>
      <optgroup label="${ub:i18n('Scripted')}">
        <c:forEach var="tmpWorkDirScript" items="${workDirScriptList}">
          <c:set var="tmpWorkDirScriptId" value="script_${tmpWorkDirScript.id}"/>
          <option value="${tmpWorkDirScriptId}" <c:if test="${tmpWorkDirScriptId eq workDirScriptValue}">selected=""</c:if>><c:out value="${tmpWorkDirScript.name}"/></option>
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

<c:set var="fieldName" value="${WebConstants.CLEANUP_CONFIG}"/>
<tr class="${eo.next}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowWorkingDirectoryCleanup")} </span></td>
  <td align="left" width="20%">
    <c:set var="cleanupSelection" value="${not empty param[fieldName] ? param[fieldName] : ''}"/>
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

<c:set var="fieldName" value="lockForWorkflow"/>
<tr class="${eo.next}" valign="top">
  <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowLockWorkflow")} </span></td>
  <td align="left" width="20%">
      <c:set var="lockForWorkflow" value="${not empty param[fieldName] ? param[fieldName] : false}"/>
      <ucf:yesOrNo name="lockForWorkflow" value="${lockForWorkflow}"/>
  </td>
  <td align="left">
    <span class="inlinehelp">${ub:i18n("LibraryWorkflowLockWorkflowDesc")}
    </span>
  </td>
</tr>
</tbody>
