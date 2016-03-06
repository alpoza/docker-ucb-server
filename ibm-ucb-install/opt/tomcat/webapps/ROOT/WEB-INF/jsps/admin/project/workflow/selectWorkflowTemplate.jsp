<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@ page import="com.urbancode.ubuild.domain.project.Project" %>
<%@ page import="com.urbancode.ubuild.domain.project.template.ProjectTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplateFactory" %>
<%@ page import="com.urbancode.ubuild.web.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="postUrl" value="${WorkflowTasks.selectWorkflowTemplate}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>
<c:url var="cancelUrl" value="${WorkflowTasks.cancelWorkflow}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:choose>
  <c:when test="${param.enabled}">
    <c:set var="disabled" value=""/>
  </c:when>

  <c:otherwise>
    <c:set var="disabled" value="disabled"/>
  </c:otherwise>
</c:choose>

<c:choose>
  <c:when test="${workflowType == 'Build'}">
    <c:set var="workflowTemplateList" value="${project.template.buildProcessTemplates}"/>
    <c:set var="workflowTypeName" value="NewBuildProcess"/>
  </c:when>
  <c:otherwise>
    <c:set var="workflowTemplateList" value="${project.template.secondaryProcessTemplates}"/>
    <c:set var="workflowTypeName" value="NewSecondaryProcess"/>
  </c:otherwise>
</c:choose>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18n(workflowTypeName)}</a></li>
    </ul>
  </div>

  <div class="contents">
    <div class="system-helpbox">${ub:i18n("ProcessSelectTemplateDesc")}</div>
    <br />
    <div align="right">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <form method="POST" action="${postUrl}">
      <ucf:hidden name="submitted" value="true"/>
      <table class="property-table">
        <tbody>
          <error:field-error field="${WebConstants.WORKFLOW_TEMPLATE_ID}"/>
          <tr valign="top">
            <td align="left" width="15%">
              <span class="bold">${ub:i18n("TemplateWithColon")} <span class="required-text">*</span></span>
            </td>

            <td align="left" width="20%">
              <ucf:idSelector name="${WebConstants.WORKFLOW_TEMPLATE_ID}" list="${workflowTemplateList}"/>
            </td>

            <td align="left">
              <span class="inlinehelp">${ub:i18n("ProcessSelectTemplateDesc")}</span>
            </td>
          </tr>
        </tbody>
      </table>
      <br/>
      <ucf:button name="Select" label="${ub:i18n('Select')}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
    </form>
  </div>

<jsp:include page="/WEB-INF/snippets/popupFooter.jsp"/>
