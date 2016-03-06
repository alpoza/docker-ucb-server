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
<%@page import="com.urbancode.ubuild.web.admin.security.authentication.anthill.AnthillAuthenticationRealmTasks" %>
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
      ${ub:i18n("uBuildAuthenticationRealmHelp")}
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
        <ucf:hidden name="${AuthenticationRealmConstants.TYPE_NAME}" value="${AuthenticationRealmType.Internal}"/>

        <table class="property-table">
            <tbody>
              <c:set var="fieldName" value="<%= AnthillAuthenticationRealmTasks.NAME_FIELD %>"/>
              <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.name}"/>
              <error:field-error field="<%= AnthillAuthenticationRealmTasks.NAME_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                  <td align="left" width="20%">
                      <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span>
                  </td>
                  <td align="left" width="20%">
                      <ucf:text name="<%= AnthillAuthenticationRealmTasks.NAME_FIELD %>" value="${nameValue}" enabled="${inEditMode}"/>
                  </td>
                  <td align="left">
                      <span class="inlinehelp">${ub:i18n("AuthenticationRealmNameDesc")}</span>
                  </td>
              </tr>

              <c:set var="fieldName" value="<%= AnthillAuthenticationRealmTasks.DESCRIPTION_FIELD %>"/>
              <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.description}"/>
              <error:field-error field="<%= AnthillAuthenticationRealmTasks.DESCRIPTION_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
                </td>
                <td align="left" colspan="2">
                  <span class="inlinehelp">${ub:i18n("AuthenticationRealmDescriptionDesc")}</span><br/>
                  <ucf:textarea name="<%= AnthillAuthenticationRealmTasks.DESCRIPTION_FIELD %>" value="${descriptionValue}" enabled="${inEditMode}"/>
                </td>
              </tr>

              <c:set var="fieldName" value="<%= AnthillAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD %>"/>
              <c:set var="realmValue" value="${param[fieldName] != null ? param[fieldName] : authenticationRealm.authorizationRealm.id}"/>
              <error:field-error field="<%= AnthillAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("AuthorizationRealmWithColon")} <span class="required-text">*</span>
                </td>
                <td align="left">
                  <ucf:idSelector name="<%= AnthillAuthenticationRealmTasks.AUTHORIZATION_REALM_FIELD %>"
                        list="${authorizationRealmList}"
                        enabled="${inEditMode}"
                        selectedId="${realmValue}"
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
      </form>
    </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
