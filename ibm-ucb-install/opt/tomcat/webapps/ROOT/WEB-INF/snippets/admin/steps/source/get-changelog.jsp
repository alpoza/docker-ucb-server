<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.jobconfig.*"%>
<%@ page import="com.urbancode.ubuild.domain.source.GetChangelogStepConfig"%>
<%@ page import="com.urbancode.ubuild.domain.status.*"%>
<%@ page import="com.urbancode.ubuild.web.admin.project.source.*"%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib uri="error" prefix="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

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

<% EvenOdd eo = new EvenOdd(); %>

<%
  GetChangelogStepConfig stepConfig = (GetChangelogStepConfig) request.getAttribute(WebConstants.STEP_CONFIG);
  pageContext.setAttribute("statusList", StatusFactory.getInstance().restoreAll());
%>

  <div class="snippet_form">
  <div class="system-helpbox">
    ${ub:i18n("ChangelogStepHelp")}
  </div>

  <br />

  <div align="right">
    <span class="required-text">*denotes required field</span>
  </div>

  <input type="HIDDEN" name="<%=SnippetBase.SNIPPET_METHOD%>" value="saveMainTab"/>

  <table class="property-table" border="0">

      <tbody>

          <c:set var="fieldName" value="${WebConstants.NAME}"/>
          <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
          <tr class="${eo.last}">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
            </td>
            <td align="left" colspan="2">
              <c:set var="nameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.name}"/>
              <ucf:text name="${WebConstants.NAME}" value="${nameValue}" enabled="${inEditMode}"/>
            </td>
          </tr>

          <c:set var="fieldName" value="${WebConstants.STATUS_NAME}"/>
          <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
          <tr class="${eo.last}">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("ChangelogStepStartStatus")}</span>
            </td>
            <td align="left" width="20%">
              <c:set var="statusValue" value="${stepConfig.startStatus.name ? param[fieldName] : stepConfig.startStatus.name}"/>
              <ucf:nameSelector name="${WebConstants.STATUS_NAME}"
                              list="${statusList}"
                              selectedValue="${statusValue}"
                              enabled="${inEditMode}"
                              />
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ChangelogStepStartStatusDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="${WebConstants.STAMP_VALUE}"/>
          <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
          <tr class="${eo.last}">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("ChangelogStepStartStampPattern")}</span>
            </td>
            <td align="left" width="20%">
              <c:set var="stampValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.startStampPattern}"/>
              <ucf:text name="${WebConstants.STAMP_VALUE}" value="${stampValue}" enabled="${inEditMode}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ChangelogStepStartStampPatternDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="${WebConstants.PERSISTING_CHANGES}"/>
          <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
          <tr class="${eo.last}">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("SaveChangesInDatabase")}</span>
            </td>
            <td align="left" width="20%">
              <c:set var="persistValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.persistingChanges}"/>
              <ucf:checkbox name="${WebConstants.PERSISTING_CHANGES}"
                              checked="${empty stepConfig ? true : persistValue}"
                              enabled="${inEditMode}"
                              />
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("SaveChangesInDatabaseDesc")}</span>
            </td>
          </tr>

          <tr class="${eo.next}">
            <td colspan="3">
              <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-advanced.jsp">
                <jsp:param name="editUrl" value="${param.editUrl}"/>
                <jsp:param name="showAdvanced" value="${param.showAdvanced}"/>
              </jsp:include>
            </td>
          </tr>

    </tbody>
  </table>

  <c:if test="${inEditMode}">
    <ucf:button name="Save" label="${ub:i18n('Save')}"/>
    <ucf:button href="${param.cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </c:if>

  </div>
