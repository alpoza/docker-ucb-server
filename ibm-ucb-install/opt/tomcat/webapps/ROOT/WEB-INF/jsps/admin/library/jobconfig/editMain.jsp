<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@ page import="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true" />
    <c:set var="textFieldAttributes" value="" />
    <%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true" />
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'" />
  </c:otherwise>
</c:choose>

<c:url var="cancelUrl" value="${LibraryJobConfigTasks.cancelMain}">
  <c:if test="${jobConfig.id != null}">
    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}" />
  </c:if>
</c:url>

<c:url var="editUrl" value="${LibraryJobConfigTasks.editMain}">
  <c:if test="${jobConfig.id != null}">
    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}" />
  </c:if>
</c:url>

<c:url var="submitUrl" value="${LibraryJobConfigTasks.saveMain}">
  <c:if test="${jobConfig.id != null}">
    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}" />
  </c:if>
</c:url>

<%
pageContext.setAttribute("eo", new EvenOdd());
%>

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<form method="post" action="${fn:escapeXml(submitUrl)}">
  <div>
    <div class="popup_header">
      <ul>
        <li class="current"><a>${ub:i18n("LibraryJobCreateAJob")}</a></li>
      </ul>
    </div>
    <div class="contents">
      <div style="text-align: right;"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
      <table class="property-table">
        <tbody>
          <c:set var="fieldName" value="name"/>
          <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : jobConfig.name}"/>
          <error:field-error field="name" cssClass="${eo.next}" />
          <tr class="${eo.last}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
            <td align="left" width="20%"><ucf:text name="name" value="${nameValue}" enabled="${inEditMode}" /></td>
            <td align="left"><span class="inlinehelp">${ub:i18n("LibraryJobNameDesc")}</span></td>
          </tr>

          <c:set var="fieldName" value="${WebConstants.DESCRIPTION}"/>
          <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : jobConfig.description}"/>
          <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="${eo.next}" />
          <tr class="${eo.last}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
            <td align="left" colspan="2"><ucf:textarea name="${WebConstants.DESCRIPTION}"
              value="${descriptionValue}" cols="40" rows="5" enabled="${inEditMode}" /></td>
          </tr>

            <c:import url="/WEB-INF/snippets/admin/security/newSecuredObjectSecurityFields.jsp"/>

          <tr class="${eo.last}">
            <td colspan="3"><c:if test="${inEditMode}">
              <ucf:button name="Save" label="${ub:i18n('Save')}"/>
              <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
            </c:if> <c:if test="${inViewMode}">
              <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" />
              <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}" />
            </c:if></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</form>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>