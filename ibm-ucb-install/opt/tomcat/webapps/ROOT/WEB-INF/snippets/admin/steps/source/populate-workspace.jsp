<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>

<%@ page import="com.urbancode.ubuild.domain.source.PopulateWorkspaceStepConfig"%>
<%@ page import="com.urbancode.ubuild.web.admin.project.source.*"%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.util.*" %>

<%@ taglib uri="error" prefix="error" %>
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

<%
  PopulateWorkspaceStepConfig stepConfig = (PopulateWorkspaceStepConfig) request.getAttribute(WebConstants.STEP_CONFIG);
  pageContext.setAttribute("stepConfig", stepConfig);
  pageContext.setAttribute("eo", new EvenOdd());
%>

<div class="snippet_form">

  <input type="HIDDEN" name="<%=SnippetBase.SNIPPET_METHOD%>" value="saveMainTab"/>

  <div class="system-helpbox">${ub:i18n("PopulateStepHelp")}</div><br />

  <div align="right"> 
    <span class="required-text">*denotes required field</span>
  </div>

  <table class="property-table" border="0">
    
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
        <td align="left">
          <span class="inlinehelp">${ub:i18n("StepNameDesc")}</span>
        </td>
      </tr>

      <c:set var="fieldName" value="${PopulateWorkspaceSnippet.DATE_STRING_FIELD}"/>
      <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
      <tr class="${eo.last}">
        <td align="left" width="20%">
          <span class="bold">${ub:i18n("DateString")}</span>
        </td>
        <td align="left" width="20%">
          <c:set var="dateValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.workspaceDateScript}"/>
          <ucf:text name="<%=PopulateWorkspaceSnippet.DATE_STRING_FIELD%>" value="${dateValue}" enabled="${inEditMode}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("PopulateStepDateStringDesc")}</span>
        </td>
      </tr>

      <c:if test="${not param.releasePriorWorkDirDisabled}">
        <c:set var="fieldName" value="releasingPriorLocks"/>
        <tr class="${eo.next}">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("ReleasePriorWorkDirs")} </span>
          </td>
          <td colspan="2" align="left" width="20%">
            <c:set var="releaseValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.releasingPriorLocks}"/>
            <input type=CHECKBOX class="checkbox" <c:if test="${releaseValue}">checked="true"</c:if> name="releasingPriorLocks" value="true" ${fieldAttributes}>
            <span class="inlinehelp">${ub:i18n("ReleasePriorWorkDirsDesc")}</span>
          </td>
        </tr>
      </c:if>

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
  <br/>

  <c:if test="${inEditMode}">
    <ucf:button name="Save" label="${ub:i18n('Save')}"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${param.cancelUrl}"/>
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </c:if>

</div>
