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
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.notification.recipientgenerator.NotificationRecipientGeneratorTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="cancelUrl" value="${NotificationRecipientGeneratorTasks.viewList}"/>

<%-- BEGIN MAIN CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemRecipientGenerators')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
        <ucf:link label="${ub:i18n('NewRecipientGenerator')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("NotificationRecipientGeneratorsNewSystemHelpBox")}
            <ul>
                <li>${ub:i18n("NotificationRecipientGeneratorsNewFixedSystemHelpBox")}</li>
                <li>${ub:i18n("NotificationRecipientGeneratorsNewGroupSystemHelpBox")}</li>
                <li>${ub:i18n("NotificationRecipientGeneratorsNewScriptedSystemHelpBox")}</li>
            </ul>
        </div>
        <br />

        <c:url var="actionUrl" value="${NotificationRecipientGeneratorTasks.newNotificationRecipientGenerator}"/>
        <form name="select-generator-form" method="post" action="${fn:escapeXml(actionUrl)}">
            <table class="property-table">
                <tbody>
                    <tr class="even">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("TypeWithColon")}</span>
                        </td>
                        <td align="left">
                            <select name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_TYPE}">
                                <%
                                DomainImpl[] typeArray = DomainUtil.getInstance().getDomainImplsForType("NotificationRecipientGenerator");
                                for (int i = 0; i < typeArray.length; i++) {
                                    String typeName = typeArray[i].getProperty("type-name");
                                    pageContext.setAttribute("typeName", typeName);
                                %>
                                <option value="${fn:escapeXml(typeName)}">${fn:escapeXml(ub:i18n(typeName))}</option>
                                <%
                                }
                                %>
                            </select>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("NotificationRecipientGeneratorsType")}</span>
                        </td>
                    </tr>
                </tbody>
            </table>
            <br/>
            <ucf:button name="Set" label="${ub:i18n('Set')}"/>
            <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
        <form>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>

