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
<ah3:useConstants class="com.urbancode.ubuild.domain.script.priority.WorkflowPriorityScriptFactory" />
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

<c:url var="submitWorkflowUrl" value="${WorkflowTasks.saveWorkflow}"/>

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

  pageContext.setAttribute(WebConstants.NOTIFICATION_SCHEME_LIST, NotificationSchemeFactory.getInstance().restoreAll());
  pageContext.setAttribute("workflowPriorityScriptList", WorkflowPriorityScriptFactory.getInstance().restoreAll());
  pageContext.setAttribute("eo", new EvenOdd());
%>

<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <c:choose>
        <c:when test="${empty workflow}">
          <li class="current"><a>${ub:i18n("NewProcess")}</a></li>
        </c:when>
        <c:otherwise>
          <li class="current"><a>${ub:i18n("EditProcess")}</a></li>
        </c:otherwise>
      </c:choose>
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
              <span class="inlinehelp">${ub:i18n("ProcessTemplateDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="name"/>
          <c:set var="defaultName" value="${empty workflow or workflow.new ? workflowTemplate.name : workflow.name}"/>
          <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : defaultName}"/>
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

          <c:if test="${empty workflow}">
            <c:import url="/WEB-INF/snippets/admin/security/newSecuredObjectSecurityFields.jsp"/>
          </c:if>

          <c:set var="fieldName" value="notificationSchemeId"/>
          <c:set var="notificationSchemeValue" value="${param[fieldName] != null ? param[fieldName] : workflow.notificationScheme.id}"/>
          <error:field-error field="notificationSchemeId" cssClass="${eo.next}"/>
          <tr class="${eo.last}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("NotificationSchemeWithColon")} </span></td>
            <td align="left" width="20%">
              <ucf:idSelector name="notificationSchemeId"
                          list="${notificationSchemeList}"
                          selectedId="${notificationSchemeValue}"
                          canUnselect="true"
                          enabled="${task == null && inEditMode}"/>
            </td>

            <td align="left">
              <span class="inlinehelp">${ub:i18n("ProcessNotificationSchemeDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="${WebConstants.PRIORITY}"/>
          <c:set var="defaultPriority" value="${empty workflow ? WorkflowPriorityScriptFactory.NORMAL_PRIORITY_SCRIPT_ID : workflow.workflowPriorityScript.id}"/>
          <c:set var="priorityValue" value="${param[fieldName] != null ? param[fieldName] : defaultPriority}"/>
          <error:field-error field="${WebConstants.PRIORITY}" cssClass="${eo.next}"/>
          <tr class="${eo.last}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("PriorityWithColon")} </span></td>
            <td align="left" width="20%">
              <ucf:idSelector name="${WebConstants.PRIORITY}"
                          list="${workflowPriorityScriptList}"
                          selectedId="${priorityValue}"
                          canUnselect="false"
                          enabled="${task == null && inEditMode}"/>
            </td>

            <td align="left">
              <span class="inlinehelp">${ub:i18n("ProcessPriorityDesc")}</span>
            </td>

          </tr>
          <c:if test="${isOriginating}">
            <c:set var="fieldName" value="skipQuietPeriod"/>
            <c:set var="skipValue" value="${param[fieldName] != null ? param[fieldName] : workflow.skippingQuietPeriod}"/>
            <tr class="${eo.next}" valign="top">
              <td align="left" width="20%"><span class="bold">${ub:i18n("SkipPreProcessing")}</span></td>

              <td align="left" width="20%">
                <ucf:yesOrNo name="skipQuietPeriod"
                             value="${skipValue}"
                             enabled="${inEditMode}"/>
              </td>

              <td align="left">
                <span class="inlinehelp">${ub:i18n("ProcessSkipDesc")}</span>
              </td>
            </tr>
          </c:if>
          <ucf:hidden name="notificationSchemeId" value="${workflow.notificationScheme.id}"/>
          <ucf:hidden name="${WebConstants.PRIORITY}" value="${workflow.workflowPriorityScript.id}"/>
          <c:if test="${isOriginating}">
            <ucf:hidden name="skipQuietPeriod" value="${workflow.skippingQuietPeriod}"/>
          </c:if>

          <c:choose>
            <c:when test="${inEditMode}">
              <jsp:include page="/WEB-INF/jsps/admin/project/workflow/editPropertiesFromWorkflowTemplate.jsp"/>
            </c:when>
            <c:otherwise>
              <jsp:include page="/WEB-INF/jsps/admin/project/workflow/viewPropertiesFromWorkflowTemplate.jsp"/>
            </c:otherwise>
          </c:choose>

        </tbody>
      </table>

      <br/>

      <c:url var="cancelUrl" value="${WorkflowTasks.cancelWorkflow}"/>
      <c:if test="${inEditMode}">
        <ucf:button name="saveWorkflow" label="${ub:i18n('Save')}" enabled="${task == null}"/>
        <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="window.parent.location='${fn:escapeXml(cancelUrl)}';"/>
      </c:if>
      <c:if test="${inViewMode}">
        <c:url var="editUrl" value='<%=new WorkflowTasks().methodUrl("editWorkflow", false) %>'>
          <c:if test="${workflow.id != null}"><c:param name="workflowId" value="${workflow.id}"/></c:if>
        </c:url>

        <c:url var="doneUrl" value='<%=new WorkflowTasks().methodUrl("viewList", false) %>'>
          <c:if test="${workflow.id != null}"><c:param name="workflowId" value="${workflow.id}"/></c:if>
        </c:url>

        <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" enabled="${task == null}"/>
        <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}" enabled="${task == null}"/>
      </c:if>
    </form>
  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
