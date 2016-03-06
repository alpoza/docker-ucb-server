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
<%@page import="com.urbancode.ubuild.domain.project.template.ProjectTemplate"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.project.ProjectTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imagesUrl" value="/images"/>
<c:url var="iconPencilUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconCopyUrl" value="/images/icon_copy_project.gif"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:url var="submitUrl" value="${ProjectTemplateTasks.saveProjectTemplate}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>

<c:url var="cancelUrl" value="${ProjectTemplateTasks.cancelProjectTemplate}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>

<c:url var="editUrl" value="${ProjectTemplateTasks.editProjectTemplate}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>

<c:url var="exportUrl" value="${ImportExportTasks.exportProjectTemplate2File}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>

<c:url var="listUrl" value='${ProjectTemplateTasks.viewList}'/>

<c:url var="viewProjectTemplateUrl" value='${ProjectTemplateTasks.viewProjectTemplate}'/>

<%
  ProjectTemplate project = (ProjectTemplate) pageContext.findAttribute(WebConstants.PROJECT_TEMPLATE);
  pageContext.setAttribute("eo", new EvenOdd());
%>

<auth:check persistent="${WebConstants.PROJECT_TEMPLATE}" var="canEdit" action="${UBuildAction.PROJECT_TEMPLATE_EDIT}"/>
<auth:check persistent="${WebConstants.PROJECT_TEMPLATE}" var="canView" action="${UBuildAction.PROJECT_TEMPLATE_VIEW}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/admin/project/template/projectTemplateHeader.jsp">
  <jsp:param name="disabled" value="${inEditMode}"/>
  <jsp:param name="selected" value="main"/>
</jsp:include>

  <form method="post" action="${fn:escapeXml(submitUrl)}">
    <ucf:hidden name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>

    <div style="text-align: right; border-top :0px; vertical-align: bottom; margin-top: 10px;">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <table class="property-table" style="width: 100%">
      <tbody>
        <c:set var="fieldName" value="name"/>
        <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : projectTemplate.name}"/>
        <error:field-error field="name" cssClass="${eo.next}"/>
        <tr class="${eo.last}" valign="top">
          <td width="20%"><span class="bold">${ub:i18n("NameWithColon")}&nbsp;<span class="required-text">*</span></span></td>
          <td colspan="2"><ucf:text name="name" value="${nameValue}" enabled="${inEditMode}" size="60"/></td>
        </tr>

        <c:set var="fieldName" value="description"/>
        <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : projectTemplate.description}"/>
        <error:field-error field="description" cssClass="${eo.next}"/>
        <tr class="${eo.last}" valign="top">
          <td width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
          <td colspan="2"><ucf:textarea name="description" value="${descriptionValue}" enabled="${inEditMode}"/></td>
        </tr>

        <tr>
          <td colspan="3">
            <c:if test="${inEditMode}">
              <c:if test="${canEdit}">
                <ucf:button name="Save" label="${ub:i18n('Save')}"/>
              </c:if>
              <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
            </c:if>
            <c:if test="${inViewMode}">
              <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}" enabled="${canEdit}"/>
              <ucf:button href="${exportUrl}" name="Export" label="${ub:i18n('Export')}" enabled="${canEdit}"/>
              <ucf:button href="${listUrl}" name="Done" label="${ub:i18n('Done')}"/>
            </c:if>
          </td>
        </tr>
      </tbody>
    </table>
  </form>

<jsp:include page="/WEB-INF/jsps/admin/project/template/projectTemplateFooter.jsp"/>
