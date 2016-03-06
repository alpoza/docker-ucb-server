<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.util.*"%>

<%@ taglib uri="error" prefix="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:choose>
  <c:when test='${mode == "edit"}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="fieldAttributes" value=""/><%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<% EvenOdd eo = new EvenOdd(); %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%-- CONTENT --%>
<div class="snippet_form">

  <input type="hidden" name="<%= SnippetBase.SNIPPET_METHOD%>" value="saveMainTab">

  <table class="property-table" border="0">
    <div class="system-helpbox">${ub:i18n("SetVarDesc")}</div><br />

    <div align="right"> 
    <span class="required-text">${ub:i18n("RequiredField")}</span></div>
    
    
      <tbody>
          <c:set var="fieldName" value="name"/>
          <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
          <tr class="<%= eo.getLast() %>">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
            </td>
            <td align="left" width="20%">
              <c:set var="nameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.name}"/>
              <ucf:text name="name" value="${nameValue}" enabled="${inEditMode}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("StepNameDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="varname"/>
          <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
          <tr class="<%= eo.getLast() %>">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("VariableName")} <span class="required-text">*</span></span>
            </td>
            <td align="left" width="20%">
              <c:set var="varnameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.varName}"/>
              <ucf:text name="varname" value="${varnameValue}" enabled="${inEditMode}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("VariableNameDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="varvalue"/>
          <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
          <tr class="<%= eo.getLast() %>">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("ValueWithColon")} </span>
            </td>
            <td align="left" width="20%">
              <c:set var="varvalueValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.varValue}"/>
              <ucf:text name="varvalue" value="${varvalueValue}" enabled="${inEditMode}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ValueDesc")}</span>
            </td>
          </tr>

          <tr class="<%=eo.getNext()%>">
            <td colspan="3">
              <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-advanced.jsp">
                <jsp:param name="editUrl" value="${param.editUrl}"/>
                <jsp:param name="showAdvanced" value="${param.showAdvanced}"/>
              </jsp:include>
            </td>
          </tr>

    </tbody>
  </table>
  <br/>
  <c:if test="${inEditMode}">
    <ucf:button name="Save" label="${ub:i18n('Save')}"/>
    <ucf:button href='${param.cancelUrl}' name="Cancel" label="${ub:i18n('Cancel')}"/>
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </c:if>

</div>
