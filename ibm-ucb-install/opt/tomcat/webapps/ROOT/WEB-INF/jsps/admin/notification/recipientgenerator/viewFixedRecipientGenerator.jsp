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
<%@page import="com.urbancode.ubuild.web.admin.notification.recipientgenerator.NotificationRecipientGeneratorTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.notification.recipientgenerator.FixedNotificationRecipientGeneratorTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.notification.recipientgenerator.NotificationRecipientGeneratorTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.notification.recipientgenerator.FixedNotificationRecipientGeneratorTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
	<c:when test='${fn:escapeXml(mode) == "edit"}'>
	  <c:set var="inEditMode" value="true"/>
	</c:when>
	<c:when test='${fn:escapeXml(mode) == "editRecipients"}'>
	  <c:set var="inEditRecipientsMode" value="true"/>
	</c:when>
	<c:otherwise>
	  <c:set var="inViewMode" value="true"/>
	</c:otherwise>
</c:choose>

<% EvenOdd eo = new EvenOdd(); %>

<c:url var="imgUrl" value="/images"/>

<c:url var="saveUrl"   value="${FixedNotificationRecipientGeneratorTasks.saveGenerator}">
  <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${notificationRecipientGenerator.id}"/>
</c:url>

<c:url var="saveRecipientsUrl"   value="${FixedNotificationRecipientGeneratorTasks.saveFixedRecipients}">
  <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${notificationRecipientGenerator.id}"/>
</c:url>

<c:url var="cancelUrl" value="${NotificationRecipientGeneratorTasks.cancelNotificationRecipientGenerator}">
  <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${notificationRecipientGenerator.id}"/>
</c:url>

<c:url var="editUrl"   value="${FixedNotificationRecipientGeneratorTasks.editGenerator}">
  <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${notificationRecipientGenerator.id}"/>
</c:url>

<c:url var="editRecipientsUrl"   value="${FixedNotificationRecipientGeneratorTasks.editFixedRecipients}">
  <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${notificationRecipientGenerator.id}"/>
</c:url>

<c:url var="addUrl"   value="${FixedNotificationRecipientGeneratorTasks.addFixedRecipient}">
  <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${notificationRecipientGenerator.id}"/>
</c:url>

<c:url var="listUrl"   value='<%=new NotificationRecipientGeneratorTasks().methodUrl("viewList", false)%>'/>

<%-- BEGIN MAIN CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemRecipientGenerators')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
        <c:set var="generatorName" value="${not empty notificationRecipientGenerator.name ? notificationRecipientGenerator.name : ub:i18n('NewRecipientGenerator')}"/>
        <ucf:link label="${generatorName}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
    <div class="system-helpbox">${ub:i18n("NotificationRecipientGeneratorsFixedSystemHelpBox")}</div><br />
    <div align="right">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>

          <c:if test="${not empty notificationRecipientGenerator}">
            <div class="translatedName"><c:out value="${ub:i18n(notificationRecipientGenerator.name)}"/></div>
            <c:if test="${not empty notificationRecipientGenerator.description}">
              <div class="translatedDescription"><c:out value="${ub:i18n(notificationRecipientGenerator.description)}"/></div>
            </c:if>
          </c:if>
          <form method="post" action="${fn:escapeXml(saveUrl)}" id="generatorForm">
          <table class="property-table">
            <tbody>
              <error:field-error field="name" cssClass="<%=eo.getNext()%>"/>
              <tr class="<%=eo.getLast()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                  <ucf:text name="name" value="${notificationRecipientGenerator.name}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("NotificationRecipientGeneratorsNameDesc")}</span>
                </td>
              </tr>

              <error:field-error field="description" cssClass="<%=eo.getNext()%>"/>
              <tr class="<%=eo.getLast()%>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                <td align="left" colspan="2">
                  <span class="inlinehelp">${ub:i18n("NotificationRecipientGeneratorsDescriptionDesc")}</span><br/>
                  <ucf:textarea name="description" value="${notificationRecipientGenerator.description}" enabled="${inEditMode}"/>
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


      <c:choose>
        <c:when test="${inEditRecipientsMode}">
          <form method="post" action="${saveRecipientsUrl}" id="recipientsForm">
          <br/>
          <br/>
          <div class="data-table_container">
            <table class="data-table">
              <caption>${ub:i18n("Recipients")}</caption>
              <tbody>
                <tr>
                  <th scope="col" align="left" valign="middle">${ub:i18n("Email")}</th>
                  <th scope="col" align="left" valign="middle">XMPP</th>
                </tr>

                <c:if test="${fn:length(notificationRecipientGenerator.recipients) == 0}">
                  <tr bgcolor="#ffffff">
                    <td colspan="5">${ub:i18n("NotificationRecipientGeneratorsNoneDefinedMessage")}</td>
                  </tr>
                </c:if>
                <c:forEach var="recipient" items="${notificationRecipientGenerator.recipients}" varStatus="recipientStatus">
                  <tr bgcolor="#ffffff">
                    <td align="left" height="1"><ucf:text name="email${recipientStatus.index}" value="${recipient.emailAddress}"/></td>
                    <td align="left" height="1"><ucf:text name="xmpp${recipientStatus.index}" value="${recipient.imId}"/></td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
          <div>
            <ucf:button name="Save" label="${ub:i18n('Save')}"/>
            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
          </div>
          </form>
        </c:when>
        <c:when test="${inViewMode}">
          <br/>
          <br/>
          <div class="data-table_container">
            <form method="post" action="${fn:escapeXml(addUrl)}" id="recipientForm">
              <table class="data-table">
                <caption>${ub:i18n("Recipients")}</caption>
                <tbody>
                  <tr>
                    <th scope="col" align="left" valign="middle">${ub:i18n("Email")}</th>
                    <th scope="col" align="left" valign="middle">XMPP</th>
                    <th scope="col" align="center" valign="middle">${ub:i18n("Action")}</th>
                  </tr>

                  <c:if test="${fn:length(notificationRecipientGenerator.recipients) == 0}">
                    <tr bgcolor="#ffffff">
                      <td colspan="5">${ub:i18n("NotificationRecipientGeneratorsNoneDefinedMessage")}</td>
                    </tr>
                  </c:if>
                  <c:forEach var="recipient" items="${notificationRecipientGenerator.recipients}" varStatus="recipientStatus">
                    <c:url var="deleteUrlId" value='<%=new FixedNotificationRecipientGeneratorTasks().methodUrl("removeFixedRecipient")%>'>
                      <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${notificationRecipientGenerator.id}"/>
                      <c:param name="index" value="${recipientStatus.index}"/>
                    </c:url>

                    <tr bgcolor="#ffffff">
                      <td align="left" height="1"><c:out value="${recipient.emailAddress}"/></td>
                      <td align="left" height="1"><c:out value="${recipient.imId}"/></td>
                      <td align="center" height="1">
                        <ucf:deletelink href="${deleteUrlId}" name="the recipient" label="${ub:i18n('Delete')}" img="${fn:escapeXml(imgUrl)}/icon_delete.gif" enabled="${inViewMode}"/>
                      </td>
                    </tr>
                  </c:forEach>

                  <tr bgcolor="#ffffff">
                    <td align="left" height="1"><ucf:text name="email" value="${email}"/></td>
                    <td align="left" height="1"><ucf:text name="xmpp" value="${xmpp}"/></td>
                    <td align="center" height="1">
                      <ucf:button name="Add" label="${ub:i18n('Add')}"/>
                    </td>
                  </tr>
                </tbody>
              </table>
            </form>
          </div>
          <div>
            <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editRecipientsUrl}"/>
            <ucf:button name="Done" label="${ub:i18n('Done')}" href="${listUrl}"/>
          </div>
        </c:when>
    </c:choose>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>

