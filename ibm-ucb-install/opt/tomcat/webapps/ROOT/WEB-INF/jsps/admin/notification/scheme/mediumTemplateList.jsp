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
<%@page import="com.urbancode.ubuild.web.admin.notification.scheme.NotificationSchemeTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.notification.scheme.NotificationSchemeTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose>
  <c:when test='${mode != "edit" and notificationSchemeMediumTemplate == null}'>
    <c:set var="enableLinks" value="true"/>
  </c:when>
</c:choose>

<c:if test="${mediumTemplateList == null}">
  <c:set var="mediumTemplateList" value="${notificationSchemeWhoWhen.mediumTemplateArray}"/>
</c:if>

<c:url var="newUrl"   value="${NotificationSchemeTasks.newMediumTemplate}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%-- BEGIN MAIN CONTENT --%>

<div>
  <ucf:button href="${newUrl}" name="AddMediumTemplate" label="${ub:i18n('NotificationSchemeWhoWhenAddMediumTemplate')}" enabled="${enableLinks}"/>
</div>
<br />
<span class="inlinehelp">${ub:i18n("NotificationSchemeWhoWhenMediumTemplateDesc")}</span>
<br /> <br />
<table class="data-table">
  <thead>
    <tr>
      <th width="25%">${ub:i18n("NotificationSchemeWhoWhenNotificationMedium")}</th>
      <th width="60%">${ub:i18n("NotificationSchemeWhoWhenMessageTemplate")}</th>
      <th width="15%">${ub:i18n("Actions")}</th>
    </tr>
  </thead>
  <tbody>
    <c:if test="${empty mediumTemplateList}">
      <tr class="odd">
        <td colspan="3"><span class="error">${ub:i18n("NotificationSchemeWhoWhenNoneDefinedMessage")}</span></td>
      </tr>
    </c:if>
    <c:forEach var="mediumTemplate" items="${mediumTemplateList}" varStatus="status">
      <tr class="odd">
        <c:url var="viewUrlSeq" value="${NotificationSchemeTasks.editMediumTemplate}">
          <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
          <c:param name="${WebConstants.NOTIFICATION_SCHEME_MEDIUM_TEMPLATE_SEQ}" value="${status.index}"/>
        </c:url>
        <c:url var="removeUrlSeq" value="${NotificationSchemeTasks.deleteMediumTemplate}">
          <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
          <c:param name="${WebConstants.NOTIFICATION_SCHEME_MEDIUM_TEMPLATE_SEQ}" value="${status.index}"/>
        </c:url>

        <td width="25%"><c:out value="${ub:i18n(mediumTemplate.mediumEnum.name)}"/></td>
        <td width="60%"><c:out value="${ub:i18n(mediumTemplate.template.name)}"/></td>
        <td align="center" width="15%">
        	<c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
          <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
          <ucf:link href="${viewUrlSeq}" label="${ub:i18n('View')}" img="${iconMagnifyGlassUrl}" enabled="${enableLinks}"/> &nbsp;
          <ucf:confirmlink href="${removeUrlSeq}" message="${ub:i18n('NotificationSchemeWhoWhenMediumTemplateRemoveMessage')}"
                  label="${ub:i18n('Remove')}" img="${iconDeleteUrl}" enabled="${enableLinks}"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>
<br/>
