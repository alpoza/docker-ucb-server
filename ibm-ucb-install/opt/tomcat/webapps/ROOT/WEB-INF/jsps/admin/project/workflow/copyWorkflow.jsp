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

<%@page import="com.urbancode.ubuild.web.util.FormErrors"%>
<%@page import="com.urbancode.ubuild.web.util.FieldError"%>
<%@page import="com.urbancode.ubuild.domain.agentpool.FixedAgentPool"%>
<%@page import="com.urbancode.ubuild.domain.agentpool.AgentPoolFactory"%>
<%@page import="com.urbancode.ubuild.domain.lock.LockableResourceFactory"%>
<%@page import="com.urbancode.ubuild.domain.notification.*"%>
<%@page import="com.urbancode.ubuild.domain.script.priority.WorkflowPriorityScriptFactory" %>
<%@page import="com.urbancode.ubuild.domain.workflow.*"%>
<%@page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplate"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="java.util.ArrayList"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
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

<c:url var="submitWorkflowUrl" value="${WorkflowTasks.saveCopiedWorkflow}"/>

<%
  Workflow workflow = (Workflow) request.getAttribute(WebConstants.WORKFLOW);

  // determine originating or not
  boolean isOriginating = false;
  if (workflow == null) {
      WorkflowTemplate template = (WorkflowTemplate) pageContext.findAttribute(WebConstants.WORKFLOW_TEMPLATE);

      isOriginating = template.isOriginating();
  }
  else {
      isOriginating = workflow.isOriginating();
      pageContext.setAttribute(WebConstants.LOCKABLE_RESOURCE_LIST, LockableResourceFactory.getInstance().restoreAll());
  }
  pageContext.setAttribute("isOriginating", isOriginating);

  pageContext.setAttribute("eo", new EvenOdd());
%>

<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18n("CopyProcess")}</a></li>
    </ul>
  </div>

  <div class="contents">
    <br />
    <div align="right">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>

    <form method="post" action="${fn:escapeXml(submitWorkflowUrl)}">
      <table class="property-table">

        <tbody>
          <tr class="${eo.next}" valign="top">

            <td align="left" width="20%"><span class="bold">${ub:i18n("TemplateWithColon")}</span></td>
            <td align="left" width="20%">
              ${fn:escapeXml(workflowTemplate.name)}
            </td>

            <td align="left">
              <span class="inlinehelp">${ub:i18n("CopyProjectTemplateDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="name"/>
          <c:set var="name" value="${ub:i18nMessage('CopyNoun', workflow.name)}"/>
          <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : name}"/>
          <error:field-error field="name" cssClass="${eo.next}"/>
          <tr class="${eo.last}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
            <td align="left" width="20%">
              <ucf:text name="name" value="${nameValue}" enabled="${task == null && inEditMode}" size="60"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ProcessNameDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="description"/>
          <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : workflow.description}"/>
          <error:field-error field="description" cssClass="${eo.next}"/>
          <tr class="${eo.last}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
            <td align="left" colspan="2">
              <ucf:textarea name="description" value="${descriptionValue}" enabled="${task == null  && inEditMode}"/>
            </td>
          </tr>
        </tbody>
      </table>

      <br/>

      <c:url var="cancelUrl" value="${WorkflowTasks.cancelCopyWorkflow}"/>
      <ucf:button name="saveWorkflow" label="${ub:i18n('Save')}" enabled="${task == null}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
    </form>
  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
