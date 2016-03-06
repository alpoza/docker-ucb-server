<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error"%>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" id="SSTasks" useConversation="false" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}" />
<c:set var="inViewMode" value="${!inEditMode}" />

<c:url var="saveUrl" value="${ServerSettingsTasks.saveSecurityServerSettings}" />
<c:url var="editUrl" value='${SSTasks.editSecurityServerSettings}' />
<c:url var="cancelUrl" value="${ServerSettingsTasks.cancelSecurityServerSettings}" />
<c:url var="doneUrl" value="${SystemTasks.viewIndex}" />

<%
    pageContext.setAttribute( "eo", new com.urbancode.ubuild.web.util.EvenOdd() );
    pageContext.setAttribute( "NL", "\n" );
%>

<%--  CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEditServerSettings')}" />
  <jsp:param name="selected" value="system" />
  <jsp:param name="disabled" value="${inEditMode}" />
</jsp:include>
<div style="padding-bottom: 1em;"><c:import url="tabs.jsp">
  <c:param name="selected" value="security" />
  <c:param name="disabled" value="${inEditMode}" />
</c:import>
<div class="contents">
<div class="system-helpbox">${ub:i18n("SettingsSecuritySystemHelpBox")}</div>
<br />
<div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
<form name="server-settings-form" method="post" action="${saveUrl}">
  <table class="property-table">
    <tbody>
      <error:field-error field="isAudited" cssClass="${eo.next}" />
      <error:field-error field="excludedClasses" cssClass="${eo.last}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsSecurityAudit")} </span></td>
        <td align="left" width="20%">
          <ucf:checkbox name="isAudited" value="true" checked="${server_settings.audited}" enabled="${inEditMode}" id="auditCheckbox"/>
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsSecurityAuditDesc")}</span></td>
      </tr>

      <error:field-error field="allowDualSessions" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsSecurityMultipleSessionsWithColon")} </span></td>
        <td align="left" width="20%"><ucf:checkbox name="allowDualSessions" value="true"
          checked="${server_settings.allowDualSessions}" enabled="${inEditMode}" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsSecurityMultipleSessionsDesc")}</span></td>
      </tr>

      <error:field-error field="allowLoginCookie" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsSecurityLoginCookieWithColon")} </span></td>
        <td align="left" width="20%"><ucf:checkbox name="allowLoginCookie" value="true"
          checked="${server_settings.allowLoginCookie}" enabled="${inEditMode}" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsSecurityLoginCookieDesc")}</span></td>
      </tr>

      <error:field-error field="allowAutoComplete" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsSecurityAutoCompleteWithColon")} </span></td>
        <td align="left" width="20%"><ucf:checkbox name="allowAutoComplete" value="true"
          checked="${server_settings.allowAutoComplete}" enabled="${inEditMode}" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsSecurityAutoCompleteDesc")}</span></td>
      </tr>

      <error:field-error field="allowGuest" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsSecurityGuestWithColon")} </span></td>
        <td align="left" width="20%"><ucf:checkbox name="allowGuest" value="true"
          checked="${server_settings.allowGuest}" enabled="${inEditMode}" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsSecurityGuestDesc")}</span></td>
      </tr>

      <error:field-error field="showingErrorTracesInUI" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsSecurityErrorTraceWithColon")} </span></td>
        <td align="left" width="20%"><ucf:checkbox name="showingErrorTracesInUI" value="true"
          checked="${server_settings.showingErrorTracesInUI}" enabled="${inEditMode}" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsSecurityErrorTraceDesc")}</span></td>
      </tr>

      <error:field-error field="uniqueNamesAcrossAllAuthRealms" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsSecurityUniqueNamesWithColon")} </span></td>
        <td align="left" width="20%"><ucf:checkbox name="uniqueNamesAcrossAllAuthRealms" value="true"
          checked="${server_settings.uniqueNamesAcrossAllAuthRealms}" enabled="${inEditMode}" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsSecurityUniqueNamesDesc")}</span></td>
      </tr>
      
      <error:field-error field="allowedAddresses" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsSecurityRepoAddressesWithColon")} </span></td>
        <td align="left" colspan="2">
          <span class="inlinehelp">${ub:i18n("SettingsSecurityRepoAddressesDesc")}</span>
          <br/>
          <ucf:textarea id="allowedAddresses" name="allowedAddresses" value="${server_settings.allowedAddresses}" enabled="${inEditMode}"/>
        </td>
      </tr>
      

    </tbody>
  </table>

  <br/>
  <c:if test="${inEditMode}">
    <ucf:button name="saveServerSettings" label="${ub:i18n('Save')}" />
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" />
    <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}" />
  </c:if>
  <br/>
</form></div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp" />
