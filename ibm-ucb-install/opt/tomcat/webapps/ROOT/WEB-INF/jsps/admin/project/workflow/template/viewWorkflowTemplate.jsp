<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.lock.LockableResourceTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.lock.LockableResourceTasks" />
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imagesUrl" value="/images"/>
<c:url var="iconPencilUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconAddUrl" value="/images/icon_add.gif"/>
<c:url var="deleteIconUrl" value="/images/icon_delete.gif"/>

<c:url var="submitUrl" value="${WorkflowTemplateTasks.saveWorkflowTemplate}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
  <c:param name="isOriginating" value="${isOriginating}"/>
</c:url>

<c:url var="cancelUrl" value="${WorkflowTemplateTasks.cancelWorkflowTemplate}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>

<c:url var="addLockResUrl" value="${WorkflowTemplateTasks.addLockableResource}">
    <c:if test="${workflowTemplate.id != null}"><c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/></c:if>
</c:url>

<c:url var="editUrl" value="${WorkflowTemplateTasks.editWorkflowTemplate}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>

<c:url var="exportUrl" value="${ImportExportTasks.exportProcessTemplate2File}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>

<c:url var="viewLockableResourceUrl" value="${LockableResourceTasks.newLock}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>

<c:url var="viewLockUrl" value="${LockableResourceTasks.viewLock}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>

<c:url var="doneUrl" value='${WorkflowTemplateTasks.viewList}'/>
<c:url var="viewWorkflowTemplateUrl" value='${WorkflowTemplateTasks.viewWorkflowTemplate}'/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<auth:check persistent="${WebConstants.WORKFLOW_TEMPLATE}" var="canEdit" action="${UBuildAction.PROCESS_TEMPLATE_EDIT}"/>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/jsps/admin/project/workflow/template/workflowTemplateHeader.jsp">
  <jsp:param name="disabled" value="${inEditMode}"/>
  <jsp:param name="selected" value="main"/>
</jsp:include>

  <%-- The main page content --%>
  <br/>
  <br/>
  <table style="table-layout: fixed;">
    <tr valign="top">
      <td style="width:60%">
        <table class="property-table">
          <tbody>
            <tr>
              <td width="20%"><strong>${ub:i18n("NameWithColon")}</strong></td>
              <td colspan="2"><c:out value="${workflowTemplate.name}"/></td>
            </tr>
            <tr>
              <td width="20%"><strong>${ub:i18n("TypeWithColon")}</strong></td>
              <td colspan="2"><c:out value="${workflowTemplate.originating ? ub:i18n('BuildProcess') : ub:i18n('SecondaryProcess')}"/></td>
            </tr>
            <tr>
              <td width="20%"><strong>${ub:i18n("DescriptionWithColon")}</strong></td>
              <td colspan="2"><c:out value="${workflowTemplate.description}"/></td>
            </tr>
          </tbody>
        </table>
      </td>
      <td width="40%" style="text-align: left;vertical-align: top;">
        <div style="text-indent: -3em; margin-left: 3em;" >
          <div class="bold">
            <span class="bold" style="margin-right: 20px">${ub:i18n("ResourcesToLock")}&nbsp;</span>
            <ucf:link href="#" label="${ub:i18n('AddResource')}" forceLabel="true"
              onclick="showPopup('${ah3:escapeJs(addLockResUrl)}', 800, 400); return false;"
              img="${iconAddUrl}" title="${ub:i18n('AddResource')}" enabled="${canEdit}"/>
          </div>

          <div style="margin-left: 3em;">
            <c:if test="${empty workflowTemplate.lockableResourceRefs}">&lt;${ub:i18n("NoneLowercase")}&gt;<br/></c:if>
            <c:forEach var="lockResRef" items="${workflowTemplate.lockableResourceRefs}" varStatus="lockResRefStatus">
              <div>
                <c:url var="editLockResUrl" value="${WorkflowTemplateTasks.editLockableResource}">
                  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                  <c:param name="index" value="${lockResRefStatus.index}"/>
                </c:url>
                <c:url var="deleteLockResUrl" value="${WorkflowTemplateTasks.deleteLockableResource}">
                  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                  <c:param name="index" value="${lockResRefStatus.index}"/>
                </c:url>
                <c:choose>
                  <c:when test="${lockResRef.scripted}">
                    <ucf:link img="${iconPencilUrl}" label="${ub:i18n('EditScript')}" href="#"
                       onclick="showPopup('${ah3:escapeJs(editLockResUrl)}', 800, 400); return false"
                       enabled="${canEdit}"/>
                   &nbsp;
                   <ucf:deletelink href="${deleteLockResUrl}" img="${deleteIconUrl}"
                       name="Scripted Resource" enabled="${canEdit}"/>
                   &nbsp;
                   <span title="${fn:escapeXml(lockResRef.script)}">${ub:i18n("ScriptedResource")}</span>
                   <c:if test="${lockResRef.exclusive}"> (exclusive)</c:if>
                 </c:when>
                 <c:otherwise>
                   <ucf:link img="${iconPencilUrl}" label="${ub:i18n('EditResource')}" href="#"
                       onclick="showPopup('${ah3:escapeJs(editLockResUrl)}', 800, 400); return false"
                       enabled="${canEdit}"/>
                   &nbsp;
                   <ucf:deletelink href="${deleteLockResUrl}" img="${deleteIconUrl}"
                       name="${lockResRef.lockableResource.name}" enabled="${canEdit}"/>
                   &nbsp;
                   <c:out value="${lockResRef.lockableResource.name}" default="${ub:i18n('NoneLowercaseInBrackets')}"/>
                   <c:if test="${lockResRef.exclusive}">&nbsp;${ub:i18n("ProcessTemplateResourceExclusive")}</c:if>
                 </c:otherwise>
                </c:choose>
              </div>
            </c:forEach>
          </div>
        </div>
      </td>
  </table>
  <br/><br/>
  <c:if test ="${canEdit}">
    <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="#" onclick="showPopup('${ah3:escapeJs(editUrl)}', 800, 400); return false;"/>
  </c:if>
  <ucf:button href="${exportUrl}" name="Export" label="${ub:i18n('Export')}" enabled="${canEdit}"/>
  <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
  <br/>

<jsp:include page="/WEB-INF/jsps/admin/project/workflow/template/workflowTemplateFooter.jsp"/>

