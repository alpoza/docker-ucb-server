<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="com.urbancode.ubuild.web.util.*"%>
<%@ page import="com.urbancode.ubuild.web.admin.templates.TemplateTasks"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0"%>
<%@taglib prefix="error" uri="error"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.templates.TemplateTasks" />

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true" />
    <c:set var="textFieldAttributes" value="" />
    <%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true" />
    <c:set var="textFieldAttributes" value="disabled class='inputdisabled'" />
  </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEditTemplate')}" />
  <jsp:param name="selected" value="system" />
  <jsp:param name="disabled" value="${inEditMode}" />
</jsp:include>

<jsp:useBean id="template" scope="request" type="com.urbancode.ubuild.domain.template.Template" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<% EvenOdd eo = new EvenOdd(); %>

<div>
<div class="tabManager" id="secondLevelTabs">
  <c:set var="templateName" value="${not empty template.name ? template.name : ub:i18n('NotificationTemplateNewEmailTemplate')}"/>
  <ucf:link label="${templateName}" href="" enabled="${false}" klass="selected tab"/>
</div>
<div class="contents">
<div class="system-helpbox">${ub:i18n("NotificationTemplateViewSystemHelpBox")}</div>
<br />
<div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
<c:if test="${not empty template}">
  <div class="translatedName"><c:out value="${ub:i18n(template.name)}"/></div>
  <c:if test="${not empty template.description}">
    <div class="translatedDescription"><c:out value="${ub:i18n(template.description)}"/></div>
  </c:if>
</c:if>
<c:url var="actionUrl" value="${TemplateTasks.saveTemplate}" /> <input:form name="template-edit-form" bean="agent"
  method="post" action="${fn:escapeXml(actionUrl)}">
  <table class="property-table">
    <tbody>
      <error:field-error field="name" cssClass="<%= eo.getNext() %>" />
      <tr class="<%= eo.getLast() %>">
        <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
        <td align="left"><ucf:text name="name" value="${template.name}" enabled="${inEditMode}" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("NotificationTemplateNameDesc")}</span></td>
      </tr>

      <error:field-error field="description" cssClass="<%= eo.getNext() %>" />
      <tr class="<%= eo.getLast() %>">
        <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
        <td align="left" colspan="2"><span class="inlinehelp">${ub:i18n("NotificationTemplateDescriptionDesc")}</span><br />
        <ucf:textarea name="description" value="${template.description}" enabled="${inEditMode}" /></td>
      </tr>

      <error:field-error field="templateText" cssClass="<%= eo.getNext() %>" />
      <tr class="<%= eo.getLast() %>">
        <td align="left" width="20%"><span class="bold">${ub:i18n("NotificationTemplateTemplateText")} <span class="required-text">*</span></span></td>
        <td colspan="2" align="left"><span class="inlinehelp">${ub:i18n("NotificationTemplateTemplateTextDesc")}</span><br/>
        <span class="inlinehelp">${ub:i18n('NotificationTemplateVariablesAvailableInScript')}</span><br/>
        <input:textarea name="templateText" bean="template" default="## BEGIN SECTION Subject
-subject goes here-
## END SECTION Subject
## BEGIN SECTION Body
-body goes here-
## END SECTION Body" cols="90" rows="40" attributesText="${textFieldAttributes}" />
        </td>
      </tr>

    </tbody>
  </table>
  <br/>
  <c:if test="${inEditMode}">
    <ucf:button name="saveTemplate" label="${ub:i18n('Set')}"/>
    <c:url var="cancelUrl" value="${TemplateTasks.cancelTemplate}" />
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
  </c:if>
  <c:if test="${inViewMode}">
    <c:url var="editUrl" value="${TemplateTasks.editTemplate}" />
    <c:url var="doneUrl" value="${TemplateTasks.doneTemplate}" />
    <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" />
    <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}" />
  </c:if>
</input:form></div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp" />
