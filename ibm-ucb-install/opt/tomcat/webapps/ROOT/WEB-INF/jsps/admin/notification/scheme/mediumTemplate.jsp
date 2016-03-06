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
<%@page import="com.urbancode.ubuild.domain.notification.*" %>
<%@page import="com.urbancode.ubuild.domain.template.*" %>
<%@page import="com.urbancode.ubuild.web.admin.notification.scheme.NotificationSchemeTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.notification.scheme.NotificationSchemeTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
	<c:when test='${fn:escapeXml(mode) == "edit"}'>
	  <c:set var="inEditMode" value="true"/>
	</c:when>
	<c:otherwise>
	  <c:set var="inViewMode" value="true"/>
	</c:otherwise>
</c:choose>

<% EvenOdd eo = new EvenOdd(); %>

<c:url var="saveUrl"   value="${NotificationSchemeTasks.saveMediumTemplate}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="cancelUrl" value="${NotificationSchemeTasks.cancelMediumTemplate}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="editUrl"   value="${NotificationSchemeTasks.editMediumTemplate}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="listUrl"   value="${NotificationSchemeTasks.viewWhoWhen}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<%
  pageContext.setAttribute(WebConstants.NOTIFICATION_MEDIUM_LIST, NotificationMediumEnum.getEnumArray());
  pageContext.setAttribute(WebConstants.TEMPLATE_LIST, TemplateFactory.getInstance().restoreAll());
%>

<%-- BEGIN MAIN CONTENT --%>

        <form method="post" action="${fn:escapeXml(saveUrl)}">
          <table class="property-table">
          <td align="right" style="border-top :0px; vertical-align: bottom;" colspan="4">
            <span class="required-text">${ub:i18n("RequiredField")}</span>
            </td>

            <tbody>
              <c:set var="fieldName" value="${WebConstants.NOTIFICATION_MEDIUM_NAME}"/>
              <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : notificationSchemeMediumTemplate.mediumEnum.name}"/>
              <error:field-error field="${WebConstants.NOTIFICATION_MEDIUM_NAME}" cssClass="<%=eo.getNext()%>"/>
              <tr class="<%=eo.getLast()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NotificationSchemeWhoWhenNotificationMediumWithColon")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                  <ucf:nameSelector name="${WebConstants.NOTIFICATION_MEDIUM_NAME}"
                                  list="${notificationMediumList}"
                                  selectedValue="${value}"
                                  enabled="${inEditMode}"
                                  />
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("NotificationSchemeWhoWhenNotificationMediumDesc")}</span>
                </td>
              </tr>

              <c:set var="fieldName" value="${WebConstants.TEMPLATE_ID}"/>
              <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : notificationSchemeMediumTemplate.template.id}"/>
              <error:field-error field="${WebConstants.TEMPLATE_ID}" cssClass="<%=eo.getNext()%>"/>
              <tr class="<%=eo.getLast()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NotificationSchemeWhoWhenMessageTemplateWithColon")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                  <ucf:idSelector name="${WebConstants.TEMPLATE_ID}"
                                  list="${template_list}"
                                  selectedId="${value}"
                                  enabled="${inEditMode}"
                                  />
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("NotificationSchemeWhoWhenMessageTemplateDesc")}</span>
                </td>
              </tr>

            </tbody>
          </table>
          <br/>

          <c:if test="${inEditMode}">
            <ucf:button name="Save" label="${ub:i18n('Save')}"/>
            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
          </c:if>
          <c:if test="${inViewMode}">
            <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}"/>
            <ucf:button name="Done" label="${ub:i18n('Done')}" href="${listUrl}"/>
          </c:if>
        </form>
