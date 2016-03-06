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
<%@page import="com.urbancode.ubuild.web.admin.security.authentication.AuthenticationRealmTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.security.authentication.ldap.LDAPAuthenticationRealmTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useConstants class="com.urbancode.security.authentication.ldap.LdapAuthenticationProperties"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
        <c:set var="inEditMode" value="true"/>
        <c:set var="textFieldAttributes" value="class='radio'"/>
    </c:when>
    <c:otherwise>
        <c:set var="inViewMode" value="true"/>
        <c:set var="textFieldAttributes" value="disabled='disabled' class='radio inputdisabled'"/>
    </c:otherwise>
</c:choose>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="fieldName" value="${LdapAuthenticationProperties.USER_BASE_PROPERTY}"/>
<c:set var="userBaseValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.USER_BASE_PROPERTY]}"/>

<error:field-error field="${LdapAuthenticationProperties.USER_BASE_PROPERTY}"/>
<tr>
  <td><span class="bold">${ub:i18n("LDAPAuthenticationRealmUserBase")} </span></td>
  <td>
    <ucf:text name="${LdapAuthenticationProperties.USER_BASE_PROPERTY}" size="60"
        value="${userBaseValue}"
        enabled="${inEditMode}"/></td>
  <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmUserBaseDesc")}</span></td>
</tr>

<c:set var="fieldName" value="${LdapAuthenticationProperties.USER_SEARCH_PROPERTY}"/>
<c:set var="userSearchValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.USER_SEARCH_PROPERTY]}"/>
<error:field-error field="${LdapAuthenticationProperties.USER_SEARCH_PROPERTY}"/>
<tr>
  <td><span class="bold">${ub:i18n("LDAPAuthenticationRealmUserSearch")} </span></td>
  <td>
    <ucf:text name="${LdapAuthenticationProperties.USER_SEARCH_PROPERTY}" size="60"
        value="${userSearchValue}"
        enabled="${inEditMode}"/></td>
  <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmUserSearchDesc")}</span></td>
</tr>
<tr>
  <td><span class="bold">${ub:i18n("LDAPAuthenticationRealmSearchUserTree")} </span></td>
  <td>
    <c:set var="fieldName" value="${LdapAuthenticationProperties.USER_SEARCH_SUBTREE_PROPERTY}"/>
    <c:set var="subtreeValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.USER_SEARCH_SUBTREE_PROPERTY]}"/>
    <input type="radio" name="${LdapAuthenticationProperties.USER_SEARCH_SUBTREE_PROPERTY}"
        <c:if test="${subtreeValue}">checked="true"</c:if>
        value="true" ${textFieldAttributes}/>&nbsp;${ub:i18n("true")}<br/>
    <input type="radio" name="${LdapAuthenticationProperties.USER_SEARCH_SUBTREE_PROPERTY}"
        <c:if test="${!subtreeValue}">checked="true"</c:if>
        value="false"  ${textFieldAttributes}/>&nbsp;${ub:i18n("false")}
  </td>
  <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmSearchUserTreeDesc")}</span></td>
</tr>

<tr>
  <td colspan="3">
    <c:set var="fieldName" value="${LdapAuthenticationProperties.CONNECTION_NAME_PROPERTY}"/>
    <c:set var="connectionNameValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.CONNECTION_NAME_PROPERTY]}"/>
    <ucf:checkbox name="useConnectionUser"
        checked="${not empty connectionNameValue}"
        enabled="${inEditMode}"
       onclick="this.checked ? $('useConnectionUserTable').show() : $('useConnectionUserTable').hide();"/>
    <span class="bold">${ub:i18n("LDAPAuthenticationRealmUseConnectionNameAndPassword")}</span>
  </td>
</tr>

<tbody id="useConnectionUserTable" <c:if test="${empty connectionNameValue}">style="display: none;"</c:if>>
  <error:field-error field="${LdapAuthenticationProperties.CONNECTION_NAME_PROPERTY}"/>
  <tr>
    <td><span class="bold">${ub:i18n("LDAPAuthenticationRealmConnectionName")} </span></td>
    <td>
      <ucf:text name="${LdapAuthenticationProperties.CONNECTION_NAME_PROPERTY}"
          value="${connectionNameValue}"
          enabled="${inEditMode}" size="60"/>
    </td>
    <td>
      <span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmConnectionNameDesc")}</span>
    </td>
  </tr>
  
  <error:field-error field="${LdapAuthenticationProperties.CONNECTION_PASSWORD_PROPERTY}"/>
  <tr>
    <td><span class="bold">${ub:i18n("LDAPAuthenticationRealmConnectionPassword")} </span></td>
    <td>
      <ucf:password name="${LdapAuthenticationProperties.CONNECTION_PASSWORD_PROPERTY}"
          value="${authRealmProps[LdapAuthenticationProperties.CONNECTION_PASSWORD_PROPERTY] != null ? authRealmProps[LdapAuthenticationProperties.CONNECTION_PASSWORD_PROPERTY] : ''}"
          enabled="${inEditMode}"/></td>
    <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmConnectionPasswordDesc")}</span></td>
  </tr>
</tbody>
