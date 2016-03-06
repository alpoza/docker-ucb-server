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
<%@page import="com.urbancode.ubuild.web.admin.security.authentication.sso.SingleSignOnAuthenticationRealmTasks" %>
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
<ah3:useConstants class="com.urbancode.security.authentication.sso.SingleSignOnAuthenticationProperties"/>
<ah3:useConstants class="com.urbancode.ubuild.web.admin.security.authentication.sso.SingleSignOnAuthenticationRealmTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.security.authentication.AuthenticationRealmConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.AuthenticationRealmType"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="textFieldAttributes" value="disabled='disabled' class='inputdisabled'"/>
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

<% EvenOdd eo = new EvenOdd(); %>

<div style="padding-bottom: 1em;">
    <c:import url="/WEB-INF/jsps/admin/security/authentication/securityAuthenticationSubTabs.jsp">
        <c:param name="selected" value="authentication"/>
        <c:param name="disabled" value="${inEditMode}"/>
    </c:import>
    <div class="contents">

      <div class="system-helpbox">
        ${ub:i18n("SSOAuthenticationRealmHelp")}
      </div>
      <br />
      <div align="right">
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
        <ucf:hidden name="${AuthenticationRealmConstants.TYPE_NAME}" value="${AuthenticationRealmType.SSO}"/>

          <table class="property-table">
            <tbody>
              <c:set var="fieldName" value="${SingleSignOnAuthenticationRealmTasks.NAME_FIELD}"/>
              <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.name}"/>
              <error:field-error field="${SingleSignOnAuthenticationRealmTasks.NAME_FIELD}" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
                </td>
                <td align="left" width="20%">
                  <ucf:text name="${SingleSignOnAuthenticationRealmTasks.NAME_FIELD}" value="${nameValue}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("AuthenticationRealmNameDesc")}</span>
                </td>
              </tr>

              <c:set var="fieldName" value="${SingleSignOnAuthenticationRealmTasks.DESCRIPTION_FIELD}"/>
              <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.description}"/>
              <error:field-error field="${SingleSignOnAuthenticationRealmTasks.DESCRIPTION_FIELD}" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
                </td>
                <td align="left" colspan="2">
                  <ucf:textarea name="${SingleSignOnAuthenticationRealmTasks.DESCRIPTION_FIELD}" value="${descriptionValue}" enabled="${inEditMode}" />
                </td>
              </tr>

              <error:field-error field="${SingleSignOnAuthenticationRealmTasks.USER_HEADER_FIELD}" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("SSOAuthenticationRealmUserHeader")} <span class="required-text">*</span></span>
                </td>
                <td align="left" width="20%">
                  <c:set var="userHeaderName" value="${authRealmProps[SingleSignOnAuthenticationProperties.USER_HEADER_PROPERTY]}"/>
                  <c:set var="fieldName" value="${SingleSignOnAuthenticationRealmTasks.USER_HEADER_FIELD}"/>
                  <c:set var="headerValue" value="${param[fieldName] != null ? param[fieldName] : userHeaderName}"/>
                  <ucf:text name="${SingleSignOnAuthenticationRealmTasks.USER_HEADER_FIELD}" value="${headerValue}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("SSOAuthenticationRealmUserHeaderDesc")}</span>
                </td>
              </tr>

              <error:field-error field="${SingleSignOnAuthenticationRealmTasks.LOGOUT_URL_FIELD}" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("SSOAuthenticationRealmLogoutUrl")} <span class="required-text">*</span></span>
                </td>
                <td align="left" width="20%">
                  <c:set var="logoutUrl" value="${authRealmProps[SingleSignOnAuthenticationProperties.LOGOUT_URL_PROPERTY]}"/>
                  <c:set var="fieldName" value="${SingleSignOnAuthenticationRealmTasks.LOGOUT_URL_FIELD}"/>
                  <c:set var="logoutValue" value="${param[fieldName] != null ? param[fieldName] : logoutUrl}"/>
                  <ucf:text name="${SingleSignOnAuthenticationRealmTasks.LOGOUT_URL_FIELD}" value="${logoutValue}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("SSOAuthenticationRealmLogoutUrlDesc")}</span>
                </td>
              </tr>

              <c:set var="fieldName" value="${SingleSignOnAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD}"/>
              <c:set var="authorizationRealmValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.authorizationRealm.id}"/>
              <error:field-error field="${SingleSignOnAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD}" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("AuthorizationRealmWithColon")} <span class="required-text">*</span></span>
                </td>
                <td align="left">
                  <ucf:idSelector name="${SingleSignOnAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD}"
                        list="${authorizationRealmList}"
                        enabled="${inEditMode}"
                        selectedId="${authorizationRealmValue}"
                        />
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("AuthenticationRealmAuthorizationRealmDesc")}</span>
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
          <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
        </c:if>

        <br/>

      </form>
      </div>
    </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
