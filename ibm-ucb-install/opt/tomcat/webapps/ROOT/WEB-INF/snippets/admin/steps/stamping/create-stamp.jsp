<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.admin.project.stamp.strategy.StampSnippet"%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.util.*"%>

<%@ taglib uri="error" prefix="error"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.project.stamp.strategy.StampSnippet" />
<ah3:useConstants class="com.urbancode.ubuild.web.util.SnippetBase" />

<c:choose>
  <c:when test='${mode == "edit"}'>
    <c:set var="inEditMode" value="true" />
    <c:set var="textFieldAttributes" value="" />
    <%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true" />
    <c:set var="textFieldAttributes" value="disabled class='inputdisabled'" />
  </c:otherwise>
</c:choose>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<div class="snippet_form">
<% EvenOdd eo = new EvenOdd(); %> <input type="hidden" name="<%= SnippetBase.SNIPPET_METHOD%>" value="saveMainTab">
<div class="system-helpbox">${ub:i18n("CreateStampStepDesc")}</div>
<br />
<div class="required-text" align="right">${ub:i18n("RequiredField")}</div>
<table class="property-table">
  <tbody>
    <c:set var="fieldName" value="${StampSnippet.NAME_FIELD}"/>
    <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>" />
    <tr class="<%= eo.getLast() %>">
      <c:set var="nameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.name}"/>
      <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
      <td align="left" width="20%"><ucf:text name="<%= StampSnippet.NAME_FIELD %>" value="${nameValue}"
        enabled="${inEditMode}" /></td>
      <td align="left"><span class="inlinehelp">${ub:i18n("StepNameDesc")}</span></td>
    </tr>

    <c:set var="fieldName" value="${StampSnippet.STAMP_VALUE_FIELD}"/>
    <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>" />
    <tr class="<%= eo.getLast() %>">
      <c:set var="stampValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.rawValue}"/>
      <td align="left" width="20%"><span class="bold">${ub:i18n("StampWithColon")} <span class="required-text">*</span></span></td>
      <td align="left">
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<ucf:text name="stampValue" size="60"
        value="${stampValue}" enabled="${inEditMode}" />
     </td>
     <td align="left">
     <span class="inlinehelp">${ub:i18n("StampStepStampDesc")}</span>
     </td>
    </tr>


    <tr class="<%=eo.getNext()%>">
      <td colspan="3"><jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-advanced.jsp">
        <jsp:param name="editUrl" value="${param.editUrl}" />
        <jsp:param name="showAdvanced" value="${param.showAdvanced}" />
      </jsp:include></td>
    </tr>

  </tbody>
</table>
<br/>

<c:if test="${inEditMode}">
  <ucf:button name="Save" label="${ub:i18n('Save')}"/>
  <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${param.cancelUrl}" />
</c:if>
<c:if test="${inViewMode}">
  <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
</c:if>
</div>
