<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.admin.link.BuildLifeLinkSnippet"%>
<%@ page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib uri="error" prefix="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

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

<%-- CONTENT --%>
<div class="snippet_form">

  <% EvenOdd eo = new EvenOdd(); %>


  <input type="hidden" name="<%= SnippetBase.SNIPPET_METHOD%>" value="saveMainTab">

  <div class="system-helpbox">${ub:i18n('Add a URL link to the build.')}</div><br />
  <div style="text-align: right;"><span class="required-text">${ub:i18n('RequiredField')}</span></div>
  <table class="property-table">
    <tbody>
      <c:set var="fieldName" value="${WebConstants.NAME}"/>
      <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
      <tr class="<%= eo.getLast() %>">
        <td align="left" width="20%">
          <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
        </td>
        <td align="left" width="20%">
          <c:set var="nameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.name}"/>
          <ucf:text name="${WebConstants.NAME}" value="${nameValue}" enabled="${inEditMode}"/>
        </td>
        <td align="left">&nbsp;</td>
      </tr>

      <c:set var="fieldName" value="${BuildLifeLinkSnippet.LINK_NAME_FIELD}"/>
      <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
      <tr class="<%= eo.getLast() %>">
        <td align="left" width="20%">
          <span class="bold">${ub:i18n("LinkName")} <span class="required-text">*</span></span>
        </td>
        <td align="left" width="20%">
          <c:set var="linkNameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.linkName}"/>
          <ucf:text name="<%= BuildLifeLinkSnippet.LINK_NAME_FIELD %>" value="${linkNameValue}" enabled="${inEditMode}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n('AddBuildLinkNameDesc')}</span>
        </td>
      </tr>

      <c:set var="fieldName" value="${BuildLifeLinkSnippet.LINK_DESC_FIELD}"/>
      <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
      <tr class="<%= eo.getLast() %>">
        <td align="left" width="20%">
          <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
        </td>
        <td align="left" colspan="2">
          <c:set var="linkDescValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.linkDescription}"/>
          <ucf:textarea id="<%= BuildLifeLinkSnippet.LINK_DESC_FIELD %>"
                        name="<%= BuildLifeLinkSnippet.LINK_DESC_FIELD %>"
                        value="${linkDescValue}"
                        rows="4"
                        cols="80"
                        enabled="${inEditMode}"/>
        </td>
      </tr>

      <c:set var="fieldName" value="${BuildLifeLinkSnippet.LINK_URL_SCRIPT_FIELD}"/>
      <error:field-error field="${fieldName}" cssClass="<%= eo.getLast() %>"/>
      <tr class="<%= eo.getLast() %>">
        <td align="left" width="20%">
          <span class="bold">${ub:i18n("URLWithColon")} <span class="required-text">*</span></span>
        </td>
        <td colspan="2" align="left" valign="top" nowrap="nowrap">
          <c:set var="urlValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.linkUrlScript}"/>
          <ucf:textarea id="<%= BuildLifeLinkSnippet.LINK_URL_SCRIPT_FIELD %>"
                        name="<%= BuildLifeLinkSnippet.LINK_URL_SCRIPT_FIELD %>"
                        value="${urlValue}"
                        rows="4"
                        cols="80"
                        enabled="${inEditMode}"/>
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
