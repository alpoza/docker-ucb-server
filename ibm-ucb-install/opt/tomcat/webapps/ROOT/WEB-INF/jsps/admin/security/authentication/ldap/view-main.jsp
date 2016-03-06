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

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authentication.AuthenticationRealmTasks" />
<ah3:useConstants class="com.urbancode.security.authentication.ldap.LdapAuthenticationProperties"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.security.authentication.AuthenticationRealmConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.AuthenticationRealmType"/>

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

<c:url var="doneUrl"   value="${AuthenticationRealmTasks.doneAuthenticationRealm}"/>
<c:url var="editUrl"   value="${AuthenticationRealmTasks.editAuthenticationRealm}">
  <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${authenticationRealm.id}"/>
</c:url>
<c:url var="cancelUrl" value="${AuthenticationRealmTasks.cancelAuthenticationRealm}"/>
<c:url var="saveUrl"   value="${AuthenticationRealmTasks.saveAuthenticationRealm}"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="selected" value="system"/>
    <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
pageContext.setAttribute("eo", new EvenOdd());
%>

<div style="padding-bottom: 1em;">
    <c:import url="/WEB-INF/jsps/admin/security/authentication/securityAuthenticationSubTabs.jsp">
        <c:param name="selected" value="authentication"/>
        <c:param name="disabled" value="${inEditMode}"/>
    </c:import>
    <div class="contents">

      <div class="system-helpbox">
        ${ub:i18n("LDAPAuthenticationRealmHelp")}
      </div>

      <br/>

      <div style="text-align: right;">
       <span class="required-text">${ub:i18n("RequiredField")}</span>
      </div>

      <c:if test="${not empty authenticationRealm}">
        <div class="translatedName"><c:out value="${ub:i18n(authenticationRealm.name)}"/></div>
        <c:if test="${not empty authenticationRealm.description}">
          <div class="translatedDescription"><c:out value="${ub:i18n(authenticationRealm.description)}"/></div>
        </c:if>
      </c:if>
      <form id="formX" name="formX" method="post" action="${fn:escapeXml(saveUrl)}">
        <ucf:hidden name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${authenticationRealm.id}"/>
        <ucf:hidden name="${AuthenticationRealmConstants.TYPE_NAME}" value="${AuthenticationRealmType.LDAP}"/>

        <table class="property-table">
          <tbody>
            <c:set var="fieldName" value="<%= LDAPAuthenticationRealmTasks.NAME_FIELD %>"/>
            <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.name}"/>
            <error:field-error field="<%= LDAPAuthenticationRealmTasks.NAME_FIELD %>" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td align="left" width="20%">
                  <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
              </td>
              <td align="left" width="20%">
                  <ucf:text name="<%= LDAPAuthenticationRealmTasks.NAME_FIELD %>" value="${nameValue}" enabled="${inEditMode}"/>
              </td>
              <td align="left">
                <span class="inlinehelp">${ub:i18n("AuthenticationRealmNameDesc")}</span>
              </td>
            </tr>

            <c:set var="fieldName" value="<%= LDAPAuthenticationRealmTasks.DESCRIPTION_FIELD %>"/>
            <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.description}"/>
            <error:field-error field="<%= LDAPAuthenticationRealmTasks.DESCRIPTION_FIELD %>" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td align="left" width="20%">
                <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
              </td>
              <td align="left" colspan="2">
                <ucf:textarea name="<%= LDAPAuthenticationRealmTasks.DESCRIPTION_FIELD %>" value="${descriptionValue}" enabled="${inEditMode}" />
              </td>
            </tr>

            <c:set var="fieldName" value="<%= LDAPAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD %>"/>
            <c:set var="authorizationRealmValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.authorizationRealm.id}"/>
            <error:field-error field="<%= LDAPAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD %>" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td align="left" width="20%">
                <span class="bold">${ub:i18n("AuthorizationRealmWithColon")} <span class="required-text">*</span></span>
              </td>
              <td align="left">
                <ucf:idSelector name="<%= LDAPAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD %>"
                      list="${authorizationRealmList}"
                      enabled="${inEditMode}"
                      selectedId="${authorizationRealmValue}"
                      />
              </td>
              <td align="left">
                <span class="inlinehelp">${ub:i18n("AuthenticationRealmAuthorizationRealmDesc")}</span>
              </td>
            </tr>

            <c:set var="fieldName" value="${LdapAuthenticationProperties.CONTEXT_FACTORY_PROPERTY}"/>
            <c:set var="contextFactoryValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.CONTEXT_FACTORY_PROPERTY]}"/>
            <error:field-error field="${LdapAuthenticationProperties.CONTEXT_FACTORY_PROPERTY}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("LDAPAuthenticationRealmContextFactory")} <span class="required-text">*</span></span></td>
              <td>
                <ucf:text name="${LdapAuthenticationProperties.CONTEXT_FACTORY_PROPERTY}"
                    value="${contextFactoryValue}"
                    enabled="${inEditMode}" size="60"/>
              </td>
              <td>
                <span class="inlinehelp">${ub:i18nMessage("LDAPAuthenticationRealmContextFactoryDesc", LdapAuthenticationProperties.DEFAULT_CONTEXT_FACTORY)}</span>
              </td>
            </tr>

            <c:set var="fieldName" value="${LdapAuthenticationProperties.URL_PROPERTY}"/>
            <c:set var="urlValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.URL_PROPERTY]}"/>
            <error:field-error field="${LdapAuthenticationProperties.URL_PROPERTY}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("LDAPAuthenticationRealmLDAPUrl")} <span class="required-text">*</span></span></td>
              <td>
                <ucf:text name="${LdapAuthenticationProperties.URL_PROPERTY}"
                    value="${urlValue}"
                    enabled="${inEditMode}" size="60"/>
              </td>
              <td>
                <span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmLDAPUrlDesc")}</span>
              </td>
            </tr>

            <c:choose>
              <c:when test="${empty userPatternValue}">
                <c:import url="ldapSearchConfig.jsp"/>
              </c:when>
              <c:otherwise>
              <tr class="${eo.next}">
                <td colspan="3">
                  <c:set var="fieldName" value="${LdapAuthenticationProperties.USER_BASE_PROPERTY}"/>
                  <c:set var="userBaseValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.USER_BASE_PROPERTY]}"/>
                      <input type="radio" name="userDefinition" class="checkbox <c:if test="${!inEditMode}">inputdisabled</c:if>"
                          <c:if test="${!inEditMode}">disabled="disabled"</c:if>
                          <c:if test="${not empty userBaseValue}">checked="true"</c:if>
                         onclick="$('useUserSearchTable').show(); $('useUserPatternTable').hide();"/>
                      <ucf:hidden name="userDefinition" value="true"/>
                  <span class="bold">${ub:i18n("LDAPAuthenticationRealmUsernameSearch")}</span>

                  <div id="useUserSearchTable" style="margin-left: 25px;
                      <c:if test="${empty userBaseValue}">display: none;</c:if>"
                    >
                    <table>
                      <c:import url="ldapSearchConfig.jsp"/>
                    </table>
                  </div>

                <c:if test="${not empty authenticationRealm && not empty userPatternValue}">
                  <br/><br/>

                  <c:set var="fieldName" value="${LdapAuthenticationProperties.USER_PATTERN_PROPERTY}"/>
                  <c:set var="userPatternValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.USER_PATTERN_PROPERTY]}"/>
                  <input type="radio" name="userDefinition" class="checkbox inputdisabled"
                      disabled="disabled"
                      <c:if test="${not empty userPatternValue}">checked="true"</c:if>
                     onclick="$('useUserPatternTable').show(); $('useUserSearchTable').hide();"/>
                  <span class="bold">${ub:i18n("LDAPAuthenticationRealmUsersInSingleDirectory")}</span>

                  <div id="useUserPatternTable" style="margin-left: 25px;
                      <c:if test="${empty userPatternValue}">display: none;</c:if>"
                    >
                    <table>
                      <error:field-error field="${LdapAuthenticationProperties.USER_PATTERN_PROPERTY}"/>
                      <tr>
                        <td width="20%" style="border-top: none;"><span class="bold">${ub:i18n("LDAPAuthenticationRealmUserPattern")} </span></td>
                        <td width="20%" style="border-top: none;">
                          <ucf:text name="${LdapAuthenticationProperties.USER_PATTERN_PROPERTY}" size="60"
                          value="${userPatternValue}"
                          enabled="${false}"/></td>
                        <td style="border-top: none;"><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmUserPatternDesc")}</span></td>
                      </tr>
                    </table>
                  </div>
                </c:if>
              </td>
            </tr>
              </c:otherwise>
            </c:choose>

            <tr class="${eo.next}">
              <td width="20%"><span class="bold">${ub:i18n("LDAPAuthenticationRealmManualUserImport")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthenticationProperties.MANUAL_USER_IMPORT_PROPERTY}"/>
                <c:set var="userImportValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.MANUAL_USER_IMPORT_PROPERTY]}"/>
                <input type="radio" name="${LdapAuthenticationProperties.MANUAL_USER_IMPORT_PROPERTY}"
                    <c:if test="${userImportValue}">checked="true"</c:if>
                    value="true" ${textFieldAttributes}/>&nbsp;${ub:i18n("true")}<br/>
                <input type="radio" name="${LdapAuthenticationProperties.MANUAL_USER_IMPORT_PROPERTY}"
                    <c:if test="${!userImportValue}">checked="true"</c:if>
                    value="false"  ${textFieldAttributes}/>&nbsp;${ub:i18n("false")}
              </td>
              <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmManualUserImportDesc")}</span></td>
            </tr>

            <tr class="${eo.next}">
              <td width="20%"><span class="bold">${ub:i18n("LDAPAuthenticationRealmCaseSensitiveUserNames")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthenticationProperties.USER_SEARCH_CASE_SENSITIVE_PROPERTY}"/>
                <c:set var="caseSensitiveValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.USER_SEARCH_CASE_SENSITIVE_PROPERTY]}"/>
                <input type="radio" name="${LdapAuthenticationProperties.USER_SEARCH_CASE_SENSITIVE_PROPERTY}"
                    <c:if test="${caseSensitiveValue}">checked="true"</c:if>
                    value="true" ${textFieldAttributes}/>&nbsp;${ub:i18n("true")}<br/>
                <input type="radio" name="${LdapAuthenticationProperties.USER_SEARCH_CASE_SENSITIVE_PROPERTY}"
                    <c:if test="${!caseSensitiveValue}">checked="true"</c:if>
                    value="false"  ${textFieldAttributes}/>&nbsp;${ub:i18n("false")}
              </td>
              <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmCaseSensitiveUserNamesDesc")}</span></td>
            </tr>

            <tr class="${eo.next}">
              <td width="20%"><span class="bold">${ub:i18n("LDAPAuthenticationRealmNameAttribute")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthenticationProperties.NAME_ATTRIBUTE_PROPERTY}"/>
                <c:set var="nameAttributeValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.NAME_ATTRIBUTE_PROPERTY]}"/>
                <ucf:text name="${LdapAuthenticationProperties.NAME_ATTRIBUTE_PROPERTY}"
                    value="${nameAttributeValue}"
                    enabled="${inEditMode}"/></td>
              <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmNameAttributeDesc")}</span></td>
            </tr>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("LDAPAuthenticationRealmEmailAttribute")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthenticationProperties.EMAIL_ATTRIBUTE_PROPERTY}"/>
                <c:set var="emailAttributeValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.EMAIL_ATTRIBUTE_PROPERTY]}"/>
                <ucf:text name="${LdapAuthenticationProperties.EMAIL_ATTRIBUTE_PROPERTY}"
                    value="${emailAttributeValue}"
                    enabled="${inEditMode}"/></td>
              <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmEmailAttributeDesc")}</span></td>
            </tr>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("LDAPAuthenticationRealmIMAttribute")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthenticationProperties.IM_ATTRIBUTE_PROPERTY}"/>
                <c:set var="imAttributeValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthenticationProperties.IM_ATTRIBUTE_PROPERTY]}"/>
                <ucf:text name="${LdapAuthenticationProperties.IM_ATTRIBUTE_PROPERTY}"
                  value="${imAttributeValue}"
                  enabled="${inEditMode}"/></td>
              <td><span class="inlinehelp">${ub:i18n("LDAPAuthenticationRealmIMAttributeDesc")}</span></td>
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
        <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
      </c:if>
      <br/>
    </form>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
