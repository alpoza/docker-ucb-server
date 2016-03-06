<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.label.AssignLabelCascadeMode"%>
<%@ page import="com.urbancode.ubuild.domain.label.LabelFactory"%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.admin.label.AssignLabelSnippet"%>
<%@ page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib uri="error" prefix="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.label.AssignLabelSnippet" />
<ah3:useConstants class="com.urbancode.ubuild.web.util.SnippetBase" />

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

<div class="snippet_form">

<%
  EvenOdd eo = new EvenOdd();
  pageContext.setAttribute("eo", eo);

  pageContext.setAttribute(WebConstants.LABEL_LIST, LabelFactory.getInstance().restoreAll());
  pageContext.setAttribute("AssignLabelCascadeMode", AssignLabelCascadeMode.values());
%>
  <%-- CONTENT --%>

    <input type="hidden" name="${SnippetBase.SNIPPET_METHOD}" value="saveMainTab">

    <div class="system-helpbox">${ub:i18n("AssignLabelHelp")}</div><br />

    <div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>

    <table class="property-table">

      <tbody>
        <c:set var="fieldName" value="${WebConstants.NAME}"/>
        <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
        <tr class="${eo.last}">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
          </td>
          <td align="left" width="20%">
            <c:set var="nameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.name}"/>
            <ucf:text name="${WebConstants.NAME}" value="${nameValue}" enabled="${inEditMode}"/>
          </td>
          <td align="left">&nbsp;</td>
        </tr>

        <c:set var="fieldName" value="${WebConstants.LABEL_ID}"/>
        <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
        <tr class="${eo.last}">
          <td align="left" width="20%" >
            <span class="bold">${ub:i18n("LabelWithColon")} </span>
          </td>
          <td align="left" width="20%">
            <c:set var="labelIdValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.label.id}"/>
            <input type="radio" class="radio" <c:if test="${!empty labelIdValue}">checked="true"</c:if> name="scripted" <c:if test="${inViewMode}">disabled</c:if>>
            <ucf:idSelector name="${WebConstants.LABEL_ID}"
                            list="${labelList}"
                            selectedId="${stepConfig.label.id}"
                            canUnselect="true"
                            enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("AssignLabelLabelDesc")}</span>
          </td>
        </tr>

        <c:set var="fieldName" value="${AssignLabelSnippet.LABEL_NAME_FIELD}"/>
        <error:field-error field="${fieldName}" cssClass="${eo.last}"/>
        <tr class="${eo.last}">
          <td align="left" width="20%"><span class="bold">${ub:i18n("AssignLabelLabelName")}</span></td>
          <td align="left" nowrap="nowrap">
            <c:set var="labelValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.labelName}"/>
            <input type="radio" class="radio" <c:if test="${empty labelIdValue}">checked="true"</c:if>  name="scripted" value="true" <c:if test="${inViewMode}">disabled</c:if>>
            <ucf:text id="${AssignLabelSnippet.LABEL_NAME_FIELD}"
                      name="${AssignLabelSnippet.LABEL_NAME_FIELD}"
                      value="${labelValue}"
                      size="30"
                      enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("AssignLabelLabelNameDesc")}</span><br/>
          </td>
        </tr>

        <c:set var="fieldName" value="${AssignLabelSnippet.CASCADE_MODE_FIELD}"/>
        <error:field-error field="${fieldName}" cssClass="${eo.last}"/>
        <tr class="${eo.last}">
          <td align="left" width="20%"><span class="bold">${ub:i18n("AssignLabelCascadeLabel")} <span class="required-text">*</span></span></td>
          <td align="left" nowrap="nowrap">
          <c:set var="cascadeValue" value="${param[fieldName] != null ? param[fieldName] : stepConfig.cascadeMode}"/>
              <ucf:enumSelector
                  name="${AssignLabelSnippet.CASCADE_MODE_FIELD}"
                  list="${AssignLabelCascadeMode}"
                  selectedValue="${cascadeValue}"
                  canUnselect="${false}"
                  enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("AssignLabelCascadeLabelDesc")}</span><br/>
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
