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
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.domain.lock.LockableResourceFactory" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
  <c:when test="${empty lockResRef}">
    <c:set var="lockResList" value="${workflowTemplate.availableLockableResources}"/>
    <c:url var="submitUrl" value="${WorkflowTemplateTasks.addLockableResource}">
      <c:if test="${workflowTemplate.id != null}"><c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/></c:if>
    </c:url>
  </c:when>
  <c:otherwise>
    <%
      pageContext.setAttribute("lockResList", LockableResourceFactory.getInstance().restoreAll());
    %>
    <c:url var="submitUrl" value="${WorkflowTemplateTasks.updateLockableResource}">
      <c:if test="${workflowTemplate.id != null}"><c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/></c:if>
      <c:param name="index" value="${param.index}"/>
    </c:url>
  </c:otherwise>
</c:choose>

<%
  EvenOdd eo = new EvenOdd();
%>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
    <ul>
        <li class="current"><a>${ub:i18n("ProcessTemplateAddLock")}</a></li>
    </ul>
</div>
<div class="contents">
  <div class="system-helpbox">
    ${ub:i18n("ProcessTemplateAddLockSystemHelpBox")}
  </div><br/>
  <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>

  <form method="post" action="${fn:escapeXml(submitUrl)}">
    <table class="property-table">

      <tbody>
          <error:field-error field="${WebConstants.LOCKABLE_RESOURCE_ID}" cssClass="<%= eo.getNext() %>"/>
          <tr class="<%= eo.getLast() %>" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("ExplicitResource")}</span></td>

            
            <c:set var="selectedResource" value="${lockResRef.scripted ? null : lockResRef.lockablResource.id}"/>
            <td align="left" width="20%">
              <ucf:idSelector name="${WebConstants.LOCKABLE_RESOURCE_ID}"
                              selectedId="${selectedResource}"
                              list="${lockResList}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ProcessTemplateLockExplicitDesc")}</span>
            </td>
          </tr>
          
          <error:field-error field="script" cssClass="<%= eo.getNext() %>"/>
          <tr class="<%= eo.getLast() %>" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("ScriptedResourceWithColon")}</span></td>

            <td align="left" colspan="2">
              <span class="inlinehelp">${ub:i18n("ProcessTemplateLockScriptedDesc")}</span><br/>
              <ucf:textarea name="script" cols="60" rows="3" value="${lockResRef.script}"/>
            </td>
          </tr>

        <error:field-error field="exclusive" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>" valign="top">
          <td align="left" width="20%"><span class="bold">${ub:i18n("Exclusive")}</span></td>

          <td align="left" width="20%">
            <ucf:yesOrNo name="exclusive" value="${lockResRef.exclusive}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("ProcessTemplateLockExclusiveDesc")}</span>
          </td>
        </tr>
      </tbody>
    </table>

    <br/>

    <ucf:button name="saveWorkflow" label="${ub:i18n('Save')}" enabled="${task == null}"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="javascript:parent.hidePopup();"/>
  </form>
</div>

<jsp:include page="/WEB-INF/snippets/popupFooter.jsp"/>
