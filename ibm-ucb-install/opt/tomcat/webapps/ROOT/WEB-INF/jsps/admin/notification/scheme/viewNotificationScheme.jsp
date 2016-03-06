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
	<c:when test='${fn:escapeXml(mode) == "edit"}'>
	  <c:set var="inEditMode" value="true"/>
	</c:when>
	<c:otherwise>
	  <c:set var="inViewMode" value="true"/>
	</c:otherwise>
</c:choose>

<% EvenOdd eo = new EvenOdd(); %>

<c:url var="saveUrl"   value="${NotificationSchemeTasks.saveNotificationScheme}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="cancelUrl" value="${NotificationSchemeTasks.cancelNotificationScheme}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="editUrl"   value="${NotificationSchemeTasks.editNotificationScheme}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="listUrl"   value='<%= new NotificationSchemeTasks().methodUrl("viewList", false) %>'/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%-- BEGIN MAIN CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemNotificationScheme')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>
<div>
    <div class="tabManager" id="secondLevelTabs">
        <c:set var="schemeName" value="${not empty notificationScheme.name ? notificationScheme.name : ub:i18n('NotificationSchemeNewNotificationScheme')}"/>
        <ucf:link label="${schemeName}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
    <div class="system-helpbox"> ${ub:i18n("NotificationSchemeViewSystemHelpBox")}</div><br />
    <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>

          <c:if test="${not empty notificationScheme}">
            <div class="translatedName"><c:out value="${ub:i18n(notificationScheme.name)}"/></div>
            <c:if test="${not empty notificationScheme.description}">
              <div class="translatedDescription"><c:out value="${ub:i18n(notificationScheme.description)}"/></div>
            </c:if>
          </c:if>
          <form method="post" action="${fn:escapeXml(saveUrl)}">
          <table class="property-table">
            <tbody>
              <error:field-error field="name" cssClass="<%=eo.getNext()%>"/>
              <tr class="<%=eo.getLast()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
                <td align="left" colspan="2">
                  <ucf:text name="name" value="${notificationScheme.name}" enabled="${inEditMode}"/>
                </td>
              </tr>

              <error:field-error field="description" cssClass="<%=eo.getNext()%>"/>
              <tr class="<%=eo.getLast()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                <td align="left" colspan="2">
                  <ucf:textarea name="description" value="${notificationScheme.description}" enabled="${inEditMode}"/>
                </td>
              </tr>

            </tbody>
          </table>
          <br/>

          <c:choose>
            <c:when test="${inViewMode}">
              <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" />
              <ucf:button name="Done" label="${ub:i18n('Done')}" href="${listUrl}" />
            </c:when>
            <c:otherwise>
              <ucf:button name="Save" label="${ub:i18n('Save')}"/>
              <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
            </c:otherwise>
          </c:choose>
        </form>

        <ul class="navlist"></ul>

        <c:import url="whoWhenList.jsp"></c:import>

      </div>
    </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>

