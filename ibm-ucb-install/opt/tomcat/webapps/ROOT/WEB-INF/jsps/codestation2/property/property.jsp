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

<ah3:useTasks class="${taskClass}" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true" />
    <c:set var="fieldAttributes" value="" />
    <%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true" />
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'" />
  </c:otherwise>
</c:choose>

<c:url var="saveUrl" value="${CodestationTasks.saveProperty}" />
<c:url var="editUrl" value="${CodestationTasks.editProperty}" />
<c:url var="cancelUrl" value="${CodestationTasks.cancelProperty}" />
<c:url var="viewUrl" value="${CodestationTasks.viewProperty}" />
<c:url var="viewListUrl" value="${CodestationTasks.viewPropertyList}" />

<% EvenOdd eo = new EvenOdd(); %>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%-- CONTENT --%>

<div class="tab-content">
  <div style="text-align: right;"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
  <form method="post" action="${fn:escapeXml(saveUrl)}">
    <table class="property-table">
      <tbody>

        <error:field-error field="${WebConstants.NAME}" cssClass="<%= eo.getNext() %>" />
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
          <td align="left" width="20%"><ucf:text name="${WebConstants.NAME}" value="${csProjectProp.name}"
            enabled="${inEditMode}"/></td>
          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyNameDesc")}</span></td>
        </tr>

        <error:field-error field="value" cssClass="<%= eo.getNext() %>" />
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%"><span class="bold">${ub:i18n("ValueWithColon")} <span class="required-text">*</span></span></td>
          <td align="left" width="20%"><ucf:text name="value" value="${csProjectProp.value}" enabled="${inEditMode}" />
          </td>
          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyValueDesc")}</span></td>
        </tr>

      </tbody>
    </table>

    <br/>
    <c:if test="${inEditMode}">
      <ucf:button name="Save" label="${ub:i18n('Save')}" />
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
    </c:if>
    <c:if test="${inViewMode}">
      <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" />
      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${viewListUrl}" />
    </c:if>
  </form>
</div>
