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
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowDefinition"%>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowDefinitionJobConfig"%>
<%@page import="com.urbancode.ubuild.domain.jobconfig.JobConfig"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.domain.agentfilter.AgentFilter" %>

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

  WorkflowDefinitionJobConfig selectedWorkflowDefinitionJobConfig = (WorkflowDefinitionJobConfig) request.getAttribute("selectedWorkflowDefinitionJobConfig");
  WorkflowDefinition workflowDef = (WorkflowDefinition)request.getAttribute(WebConstants.WORKFLOW_DEFINITION);
%>

<c:url var="saveJobConfigUrl" value="${WorkflowDefinitionTasks.saveJobConfig}"/>

<%-- CONTENT --%>

<form method="post" action="${fn:escapeXml(saveJobConfigUrl)}">
    <div class="system-helpbox">${ub:i18n("LibraryWorkflowEditJobSystemHelpBox")}</div><br />
    <input type="hidden" name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${selectedWorkflowDefinitionJobConfig.id}">
    <div style="text-align: right; border-top: 0px; vertical-align: bottom;">
     <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <table class="property-table">
      <tbody>
        <tr class="${eo.next}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("JobWithColon")}</span></td>
            <td align="left" width="20%">
                ${fn:escapeXml(selectedWorkflowDefinitionJobConfig.jobConfig.name)}
            </td>
            <td align="left">
                <span class="inlinehelp">${ub:i18n("LibraryWorkflowEditJobDesc")}</span>
            </td>
        </tr>

        <c:import url="/WEB-INF/jsps/admin/library/workflow/definition/editJobCommonFields.jsp">
          <c:param name="evenOdd" value="${eo.last}"/>
        </c:import>
      </tbody>
    </table>
    <br/>
    <ucf:button name="setPreCondition" label="${ub:i18n('Save')}"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="window.parent.hidePopup();" submit="${false}"/>
</form>
