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

<c:choose>
  <c:when test='${mode != "edit"}'>
    <c:set var="enableLinks" value="true"/>
  </c:when>
</c:choose>

<c:if test="${whoWhenList == null}">
  <c:set var="whoWhenList" value="${notificationScheme.whoWhenArray}"/>
</c:if>

<c:url var="newUrl"   value="${NotificationSchemeTasks.newWhoWhen}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%-- BEGIN MAIN CONTENT --%>
<br/>
<div>
  <ucf:button href="${newUrl}" name="AddWhoWhen" label="${ub:i18n('NotificationSchemeWhoWhenAddWhoWhen')}" enabled="${enableLinks}"/>
</div>
<br/>
<span class="inlinehelp">
${ub:i18n("NotificationSchemeWhoWhenDesc")}
</span>
<br/>
<br/>

  <table class="data-table" border="0">
    <thead>
      <tr>
        <th width="42%">${ub:i18n("NotificationSchemeRecipientGeneratorWho")}</th>
        <th width="43%">${ub:i18n("NotificationSchemeEventSelectorWhen")}</th>
        <th width="15%">${ub:i18n("Actions")}</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="whoWhen" items="${whoWhenList}" varStatus="status">
        <tr class="odd">
          <c:url var="viewUrlSeq" value="${NotificationSchemeTasks.viewWhoWhen}">
            <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
            <c:param name="${WebConstants.NOTIFICATION_SCHEME_WHO_WHEN_SEQ}" value="${status.index}"/>
          </c:url>
          <c:url var="removeUrlSeq" value="${NotificationSchemeTasks.deleteWhoWhen}">
            <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
            <c:param name="${WebConstants.NOTIFICATION_SCHEME_WHO_WHEN_SEQ}" value="${status.index}"/>
          </c:url>

          <td width="42%"><c:out value="${ub:i18n(whoWhen.whoGenerator.name)}"/></td>
          <td width="43%"><c:out value="${ub:i18n(whoWhen.whenSelector.name)}"/></td>
          <td align="center"  height="1" nowrap="nowrap" width="15%">
            <c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
            <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
            <ucf:link href="${viewUrlSeq}" label="${ub:i18n('View')}" img="${iconMagnifyGlassUrl}" enabled="${enableLinks}"/> &nbsp;
            <ucf:confirmlink href="${removeUrlSeq}" message="${ub:i18n('NotificationSchemeWhoWhenRemoveMessage')}" label="${ub:i18n('Remove')}" img="${iconDeleteUrl}" enabled="${enableLinks}"/>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
  <br/>
