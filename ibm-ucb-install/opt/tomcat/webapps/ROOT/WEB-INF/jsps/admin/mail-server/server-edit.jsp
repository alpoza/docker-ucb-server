<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>
<%@page import="com.urbancode.ubuild.web.admin.mailserver.MailServerTasks"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input" %>
<%@taglib uri="error" prefix="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.mailserver.MailServerTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<c:url var="actionUrl" value="${MailServerTasks.saveMailServer}"/>
<c:url var="cancelUrl" value="${MailServerTasks.cancelMailServer}"/>
<c:url var="editUrl" value="${MailServerTasks.editMailServer}"/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="textFieldAttributes" value=""/><%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="textFieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>


<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEditMailServer')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('MailServer')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
             <div class="system-helpbox">${ub:i18n("MailServerSystemHelpBox")}</div>
      <jsp:useBean id="mail_server" scope="request" type="com.urbancode.ubuild.domain.singleton.mailserver.MailServer"/>

      <error:template page="/WEB-INF/snippets/errors/error.jsp"/>
      <% EvenOdd eo = new EvenOdd(); %>

      <input:form name="server-edit-form" bean="agent" method="post" action="${fn:escapeXml(actionUrl)}">
        <p></p><div>
            <table class="property-table">
                <tbody>
                    <error:field-error field="name" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("NameWithColon")}</span>
                        </td>
                        <td align="left">
                            <ucf:text name="name" value="${mail_server.name}" enabled="${inEditMode}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("MailServerNameDesc")}</span>
                        </td>
                    </tr>

                    <error:field-error field="host" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("MailServerMailHost")}</span>
                        </td>
                        <td align="left">
                            <ucf:text name="host" value="${mail_server.host}" enabled="${inEditMode}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("MailServerMailHostDesc")}</span>
                        </td>
                    </tr>

                    <error:field-error field="port" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("MailServerMailPort")}</span>
                        </td>
                        <td align="left">
                            <ucf:text name="port" value="${mail_server.port}" enabled="${inEditMode}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("MailServerMailPortDesc")}</span>
                        </td>
                    </tr>

                    <error:field-error field="sender" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("MailServerSender")}</span>
                        </td>
                        <td align="left">
                            <ucf:text name="sender" value="${mail_server.sender}" enabled="${inEditMode}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("MailServerSenderDesc")}</span>
                        </td>
                    </tr>

                    <error:field-error field="userName" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("UserNameWithColon")}</span>
                        </td>
                        <td align="left">
                            <ucf:text name="userName" value="${mail_server.userName}" enabled="${inEditMode}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("MailServerUserNameDesc")}</span>
                        </td>
                    </tr>

                    <error:field-error field="password" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("PasswordWithColon")}</span>
                        </td>
                        <td align="left">
                            <ucf:password name="password" value="${mail_server.password}" enabled="${inEditMode}" size="30"/>
                            <%--<input:password name="password" bean="mail_server" attributesText="${textFieldAttributes}"/>--%>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("MailServerPasswordDesc")}</span>
                        </td>
                    </tr>

                    <error:field-error field="use-tls" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("MailServerUseTLS")}</span>
                        </td>
                        <td align="left">
                            <ucf:checkbox name="use-tls" value="true" enabled="${inEditMode}" checked="${mail_server.useTls}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("MailServerUseTLSDesc")}</span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <br/>
        <c:if test="${inEditMode}">
        <ucf:button name="saveMailServer" label="${ub:i18n('Save')}"/>
        <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
        </c:if>
        <c:if test="${inViewMode}">
          <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
          <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
        </c:if>
        <br/>

      </input:form>
    </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
