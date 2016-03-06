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
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.im.IMTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<%
    EvenOdd eo = new EvenOdd();
    eo.getNext();
%>

<c:url var="enableUrl" value="${IMTasks.enableXmppIM}"/>
<c:url var="cancelUrl" value="${IMTasks.cancelXmppIM}"/>
<c:url var="editUrl"   value="${IMTasks.editXmppIM}"/>
<c:url var="saveUrl"  value="${IMTasks.saveXmppIM}"/>
<c:url var="testUrl"  value="${IMTasks.testXmppIM}"/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="title" value="${ub:i18n('SystemEditXMPPSettings')}"/>
    <jsp:param name="selected" value="system"/>
    <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<script type="text/javascript" language="JavaScript"><!--
    function test() {
        document.forms[0].action = "${ah3:escapeJs(testUrl)}";
        document.forms[0].submit();
    }
--></script>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('XMPP')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("IMXMPPSystemHelpBox")}</div>
        <br />
        <div align="right">
        <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>


<form method="post" action="${saveUrl}">
    <table class="property-table">
        <tbody>
            <tr class="<%= eo.getNext() %>">
                <td style="border-top :0px" align="left" colspan="2">
                    <c:choose>
                        <c:when test="${xmpp_im_settings.used}">
                            <ucf:button href="${enableUrl}" name="Disable" label="${ub:i18n('Disable')}"/>
                        </c:when>
                        <c:otherwise>
                            <ucf:button href="${enableUrl}" name="Enable" label="${ub:i18n('Enable')}"/>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <error:field-error field="xmppName" cssClass="<%= eo.getNext() %>"/>
            <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                    <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span>
                </td>
                <td align="left">
                    <ucf:text name="xmppName" value="${xmpp_im_settings.name}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("IMXMPPNameDesc")}</span>
                </td>
            </tr>

            <error:field-error field="xmppHost" cssClass="<%= eo.getNext() %>"/>
            <tr class="<%= eo.getLast() %>">
                <td align="left">
                    <span class="bold">${ub:i18n("IMXMPPServerHost")} <span class="required-text">*</span>
                </td>
                <td align="left">
                    <ucf:text name="xmppHost" value="${xmpp_im_settings.host}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("IMXMPPServerHostDesc")}</span>
                </td>
            </tr>

            <error:field-error field="xmppPort" cssClass="<%= eo.getNext() %>"/>
            <tr class="<%= eo.getLast() %>">
                <td align="left">
                    <span class="bold">${ub:i18n("IMXMPPServerPort")} <span class="required-text">*</span>
                </td>
                <td align="left">
                    <ucf:text name="xmppPort" value="${xmpp_im_settings.port}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("IMXMPPServerPortDesc")}</span>
                </td>
            </tr>

            <error:field-error field="xmppDomain" cssClass="<%= eo.getNext() %>"/>
            <tr class="<%= eo.getLast() %>">
                <td align="left">
                    <span class="bold">${ub:i18n("IMXMPPDomain")} <span class="required-text">*</span>
                </td>
                <td align="left">
                    <ucf:text name="xmppDomain" value="${xmpp_im_settings.domain}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("IMXMPPDomainDesc")}</span>
                </td>
            </tr>

            <error:field-error field="xmppUserName" cssClass="<%= eo.getNext() %>"/>
            <tr class="<%= eo.getLast() %>">
                <td align="left">
                    <span class="bold">${ub:i18n("UserNameWithColon")} <span class="required-text">*</span></span>
                </td>
                <td align="left">
                    <ucf:text name="xmppUserName" value="${xmpp_im_settings.userName}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("IMXMPPUsernameDesc")}</span>
                </td>
            </tr>

            <error:field-error field="xmppPassword" cssClass="<%= eo.getNext() %>"/>
            <tr class="<%= eo.getLast() %>">
                <td align="left">
                    <span class="bold">${ub:i18n("PasswordWithColon")}</span>
                </td>
                <td align="left">
                    <ucf:password name="xmppPassword" value="${xmpp_im_settings.password}" enabled="${inEditMode}" size="30"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("IMXMPPPasswordDesc")}</span>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <c:choose>
                        <c:when test="${inEditMode}">
                            <ucf:button name="saveSettings" label="${ub:i18n('Save')}"/>
                            <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
                        </c:when>
                        <c:otherwise>
                            <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
                            <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
                <error:field-error field="testXmppUserId" cssClass="<%= eo.getNext() %>"/>
                <tr class="<%= eo.getLast() %>">
                    <td align="left">
                        <span class="bold">${ub:i18n("IMXMPPTestUserID")}</span>
                    </td>
                    <td align="left">
                        <ucf:text name="testXmppUserId" value="" enabled="${inViewMode && xmpp_im_settings.used}"/>
                    </td>
                    <td align="left">
                        <ucf:button name="testXmpp" label="${ub:i18n('Test')}" enabled="${inViewMode && xmpp_im_settings.used}"
                             submit="false" onclick="javascript:test(); return false;"/>
                    </td>
                </tr>
                <tr class="<%= eo.getNext() %>">
                    <td align="left">
                        <span class="bold">${ub:i18n("IMXMPPServiceStatus")}</span>
                    </td>
                    <td align="left">
                        ${fn:escapeXml(im_connection_status)}
                    </td>
                    <td align="left">
                        <span class="required-text">${fn:escapeXml(im_connection_error)}&nbsp;</span>
                    </td>
                </tr>
        </tbody>
    </table>
</form>

<br/>
<br/><br />

</div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
