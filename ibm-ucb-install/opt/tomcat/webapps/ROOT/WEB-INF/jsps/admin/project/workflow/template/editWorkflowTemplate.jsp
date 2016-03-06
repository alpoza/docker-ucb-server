<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page language="java" contentType="text/html"
    pageEncoding="UTF-8"%>

<%@page import="java.util.*"%>
<%@page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@page import="com.urbancode.ubuild.domain.project.template.ProjectTemplate"%>
<%@page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplate"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.lock.LockableResourceTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%
  EvenOdd eo = new EvenOdd();
  pageContext.setAttribute( "eo", eo );

  Boolean isOriginating = (Boolean)request.getAttribute("isOriginating");
  pageContext.setAttribute("isOriginating", isOriginating);
%>

<c:url var="saveUrl" value="${WorkflowTemplateTasks.saveWorkflowTemplate}"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<form method="post" action="${fn:escapeXml(saveUrl)}">
  <div>
    <div class="popup_header">
        <ul>
            <li class="current">
            <a>${empty workflowTemplate ? ub:i18n("ProcessTemplateNew") : ub:i18n("ProcessTemplateEdit")}</a></li>
        </ul>
    </div>
    <div class="contents">
      <div class="system-helpbox">${ub:i18n("ProcessTemplateEditSystemHelpBox")}</div>

        <div style="border-top :0px; vertical-align: bottom; text-align: right;">
           <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>
        <table class="property-table">
            <tbody>
                <c:set var="fieldName" value="name"/>
                <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : workflowTemplate.name}"/>
                <error:field-error field="name" cssClass="${eo.next}"/>
                <tr class="${fn:escapeXml(eo.last)}" valign="top">
                    <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
                    <td align="left" width="20%">
                        <ucf:text name="name" value="${nameValue}" enabled="true" size="60"/>
                    </td>
                    <td align="left">
                        <span class="inlinehelp">${ub:i18n("ProcessTemplateNameDesc")}</span>
                    </td>

                </tr>

                <c:set var="fieldName" value="description"/>
                <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : workflowTemplate.description}"/>
                <error:field-error field="description" cssClass="${eo.next}"/>
                <tr class="${fn:escapeXml(eo.last)}" valign="top">
                    <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                    <td align="left" colspan="2">
                        <ucf:textarea name="description" value="${descriptionValue}" enabled="true"/>
                    </td>
                </tr>

                <c:if test="${empty workflowTemplate}">
                  <tr class="${fn:escapeXml(eo.last)}" valign="top">
                      <td align="left" width="20%"><span class="bold">${ub:i18n("TypeWithColon")} <span class="required-text">*</span></span></td>
                      <td align="left" width="20%">
                          <div><input type="radio" name="isOriginating" value="true" checked="checked"/> ${ub:i18n("BuildProcess")}</div>
                          <div><input type="radio" name="isOriginating" value="false"/> ${ub:i18n("SecondaryProcess")}</div>
                      </td>
                      <td align="left">&nbsp;</td>
                  </tr>
                </c:if>

                <c:import url="/WEB-INF/snippets/admin/security/newSecuredObjectSecurityFields.jsp"/>

            </tbody>
        </table>
      <br/>
      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
      <c:url var="cancelUrl" value="${WorkflowTemplateTasks.cancelWorkflowTemplate}" />
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
    </div>
  </div>
</form>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
