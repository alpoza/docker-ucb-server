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
	<c:when test='${fn:escapeXml(mode) == "edit" and notificationSchemeMediumTemplate == null}'>
	  <c:set var="inEditMode" value="true"/>
	</c:when>
	<c:otherwise>
	  <c:set var="inViewMode" value="true"/>
	</c:otherwise>
</c:choose>

<% EvenOdd eo = new EvenOdd(); %>

<c:url var="saveUrl"   value="${NotificationSchemeTasks.saveWhoWhen}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="cancelUrl" value="${NotificationSchemeTasks.cancelWhoWhen}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="editUrl"   value="${NotificationSchemeTasks.editWhoWhen}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<c:url var="listUrl"   value="${NotificationSchemeTasks.viewNotificationScheme}">
  <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${notificationScheme.id}"/>
</c:url>

<%
  pageContext.setAttribute(WebConstants.WORKFLOW_CASE_SELECTOR_LIST, ScriptedWorkflowCaseSelectorFactory.getInstance().restoreAll());
  pageContext.setAttribute(WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_LIST, NotificationRecipientGeneratorFactory.getInstance().restoreAll());
%>

<%-- BEGIN MAIN CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemNotificationSchemeWhoWhen')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
        <ucf:link label="${ub:i18n('WhoWhen')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
    <div class="system-helpbox">${ub:i18n("NotificationSchemeWhoWhenSystemHelpBox")}</div><br />
    <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
        <form method="post" action="${fn:escapeXml(saveUrl)}">
          <table class="property-table">

            <tbody>

              <error:field-error field="${WebConstants.WORKFLOW_CASE_SELECTOR_ID}" cssClass="<%=eo.getNext()%>"/>
              <tr class="<%=eo.getLast()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NotificationSchemeWhoWhenEventSelector")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                  <ucf:idSelector name="${WebConstants.WORKFLOW_CASE_SELECTOR_ID}"
                                  list="${workflowCaseSelectorList}"
                                  selectedId="${notificationSchemeWhoWhen.whenSelector.id}"
                                  enabled="${inEditMode}"
                                  />
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("NotificationSchemeWhoWhenEventSelectorDesc")}</span>
                </td>
              </tr>

              <error:field-error field="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" cssClass="<%=eo.getNext()%>"/>
              <tr class="<%=eo.getLast()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NotificationSchemeWhoWhenRecipientGenerator")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                  <ucf:idSelector name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}"
                                  list="${notificationRecipientGeneratorList}"
                                  selectedId="${notificationSchemeWhoWhen.whoGenerator.id}"
                                  enabled="${inEditMode}"
                                  />
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("NotificationSchemeWhoWhenRecipientGeneratorDesc")}</span>
                </td>
              </tr>

              <tr class="<%=eo.getNext()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NotificationSchemeWhoWhenCCRecipientGenerator")} </span></td>
                <td align="left" width="20%">
                  <ucf:idSelector name="${WebConstants.NOTIFICATION_RECIPIENT_CC_GENERATOR_ID}"
                                  list="${notificationRecipientGeneratorList}"
                                  selectedId="${notificationSchemeWhoWhen.whoCcGenerator.id}"
                                  enabled="${inEditMode}"
                                  />
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("NotificationSchemeWhoWhenCCRecipientGeneratorDesc")}</span>
                </td>
              </tr>

              <tr class="<%=eo.getNext()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NotificationSchemeWhoWhenBCCRecipientGenerator")} </span></td>
                <td align="left" width="20%">
                  <ucf:idSelector name="${WebConstants.NOTIFICATION_RECIPIENT_BCC_GENERATOR_ID}"
                                  list="${notificationRecipientGeneratorList}"
                                  selectedId="${notificationSchemeWhoWhen.whoBccGenerator.id}"
                                  enabled="${inEditMode}"
                                  />
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("NotificationSchemeWhoWhenBCCRecipientGeneratorDesc")}</span>
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
            <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" enabled="${notificationSchemeMediumTemplate == null}"/>
            <ucf:button name="Done" label="${ub:i18n('Done')}" href="${listUrl}" enabled="${notificationSchemeMediumTemplate == null}"/>
          </c:if>
        </form>

<c:if test="${not inEditMode}">
        <br />
        <ul class="navlist"></ul>
        <br/>

        <c:import url="mediumTemplateList.jsp"></c:import>

        <c:if test="${notificationSchemeMediumTemplate!= null}">
          <c:import url="mediumTemplate.jsp"/>
        </c:if>
</c:if>

  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
