<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${buildLifeTaskClass}" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "prop-edit"}'>
    <c:set var="inEditMode" value="true" />
    <c:set var="fieldAttributes" value="" />
    <%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true" />
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'" />
  </c:otherwise>
</c:choose>

<c:url var="saveUrl" value="${CodestationBuildLifeTasks.saveProperty}" />
<c:url var="editUrl" value="${CodestationBuildLifeTasks.editProperty}" />
<c:url var="cancelUrl" value="${CodestationBuildLifeTasks.cancelProperty}" />
<c:url var="doneUrl" value="${CodestationBuildLifeTasks.doneProperty}" />
<c:url var="viewUrl" value="${CodestationBuildLifeTasks.viewProperty}" />
<c:url var="viewListUrl" value="${CodestationBuildLifeTasks.viewPropertyList}" />

<% EvenOdd eo = new EvenOdd(); %>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%-- CONTENT --%>

<div class="tab-content">

  <form method="post" action="${fn:escapeXml(saveUrl)}">
    <table class="property-table">
      <td align="right" style="border-top: 0px; vertical-align: bottom;" colspan="4"><span class="required-text">${ub:i18n("RequiredField")}</span></td>
      <tbody>

        <error:field-error field="${WebConstants.NAME}" cssClass="<%= eo.getNext() %>" />
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></td>
          <td align="left" width="20%"><ucf:text name="${WebConstants.NAME}" value="${csBuildLifeProp.name}"
            enabled="${inEditMode}"/></td>
          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyNameDesc")}</span></td>
        </tr>

        <error:field-error field="value" cssClass="<%= eo.getNext() %>" />
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%"><span class="bold">${ub:i18n("ValueWithColon")} <span class="required-text">*</span></td>
          <td align="left" width="20%"><ucf:text name="value" value="${csBuildLifeProp.value}" enabled="${inEditMode}" />
          </td>
          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyValueDesc")}</span></td>
        </tr>

      </tbody>
    </table>

    <br/>

    <c:if test="${inEditMode}">
      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${doneUrl}" />
    </c:if>
    <c:if test="${inViewMode}">
      <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" />
      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}" />
    </c:if>
  </form>
</div>
