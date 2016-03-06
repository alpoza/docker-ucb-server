<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>

<%@ page import="com.urbancode.ubuild.domain.source.LabelStepConfig"%>
<%@ page import="com.urbancode.ubuild.web.admin.project.source.LabelSnippet"%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.util.*" %>

<%@ taglib uri="error" prefix="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.project.source.LabelSnippet" />

<c:choose>
  <c:when test='${mode == "edit"}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="textFieldAttributes" value=""/><%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="textFieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<% EvenOdd eo = new EvenOdd(); %>
<%
  LabelStepConfig stepConfig = (LabelStepConfig) request.getAttribute(WebConstants.STEP_CONFIG);
%>

<div class="snippet_form">

  <input type="HIDDEN" name="<%=SnippetBase.SNIPPET_METHOD%>" value="saveMainTab"/>

  <table class="property-table" border="0">
    <div class="system-helpbox">${ub:i18n("LabelStepHelp")}</div><br />

      <div align="right"> 
      <span class="required-text">${ub:i18n("RequiredField")}</span>
      </div>
      <tbody>

          <c:set var="fieldName" value="${WebConstants.NAME}"/>
          <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
          <tr class="<%= eo.getLast() %>">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span>
            </td>
            <td align="left" width="20%">
              <c:set var="nameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.name}"/>
              <ucf:text name="${WebConstants.NAME}" value="${nameValue}" enabled="${inEditMode}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("StepNameDesc")}</span>
            </td>
          </tr>

        <c:set var="fieldName" value="${LabelSnippet.LABEL_STRING_FIELD}"/>
        <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("LabelWithColon")} <span class="required-text">*</span></span>
          </td>
          <td align="left" width="20%">
            <c:set var="labelStringDefault" value="${not empty stepConfig.labelString ? stepConfig.labelString : '${p:buildlife/latestStamp}'}"/>
            <c:set var="labelStringValue" value="${not empty param[fieldName] ? param[fieldName] : labelStringDefault}"/>
            <ucf:text name="<%=LabelSnippet.LABEL_STRING_FIELD%>" value="${labelStringValue}" enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("LabelStepLabelDesc")}<br/></span>
          </td>
        </tr>

        <c:set var="fieldName" value="${LabelSnippet.MESSAGE_FIELD}"/>
        <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("MessageWithColon")} <span class="required-text">*</span></span>
          </td>
          <td align="left" width="20%">
            <c:set var="labelMessageValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.message}"/>
            <ucf:textarea name="<%=LabelSnippet.MESSAGE_FIELD%>" value="${labelMessageValue}" required="true" enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("LabelStepMessageDesc")}<br/></span>
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
    <ucf:button href="${param.cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </c:if>

</div>
