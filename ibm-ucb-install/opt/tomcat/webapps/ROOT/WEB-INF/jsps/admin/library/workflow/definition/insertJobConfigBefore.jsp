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
<%@page import="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>

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

<c:url var="insertJobConfigBeforeUrl" value="${WorkflowDefinitionTasks.insertJobConfigBefore}"/>

<%-- CONTENT --%>
<form method="post" action="${fn:escapeXml(insertJobConfigBeforeUrl)}">
    <div class="system-helpbox">${ub:i18n("LibraryWorkflowInsertJobBeforeSystemHelpBox")}</div><br />
    <div style="text-align: right; border-top: 0px; vertical-align: bottom;">
     <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <input type="hidden" name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${selectedWorkflowDefinitionJobConfig.id}">
    <table class="property-table">
        <tbody>
            <tr class="${eo.next}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("LibraryWorkflowInsertJobBeforeWithColon")}</span></td>
                <td align="left" width="20%">
                    ${fn:escapeXml(selectedWorkflowDefinitionJobConfig.jobConfig.name)}
                </td>
                <td align="left">&nbsp;</td>
            </tr>

            <c:import url="/WEB-INF/jsps/admin/library/workflow/definition/addJobCommonFields.jsp">
              <c:param name="evenOdd" value="${eo.last}"/>
            </c:import>
        </tbody>
    </table>
    <br/>
    <ucf:button name="addJob" label="${ub:i18n('LibraryWorkflowInsertJob')}"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="window.parent.hidePopup();" submit="${false}"/>
</form>
