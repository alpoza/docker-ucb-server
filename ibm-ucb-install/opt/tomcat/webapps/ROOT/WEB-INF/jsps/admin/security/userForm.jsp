<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.security.AuthenticationRealm"%>
<%@ page import="com.urbancode.security.Group"%>
<%@ page import="com.urbancode.ubuild.domain.security.SecurityHelper"%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildUser"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.admin.security.UserTasks"%>
<%@ page import="com.urbancode.ubuild.web.admin.security.LoginTasks" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang3.ObjectUtils" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.UserTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
  UBuildUser currentUser = (UBuildUser) session.getAttribute(LoginTasks.KEY_CURRENT_USER);
  UBuildUser user = (UBuildUser) pageContext.findAttribute(WebConstants.USER);
  pageContext.setAttribute("isUser", ObjectUtils.equals(currentUser, user));
  EvenOdd eo = new EvenOdd();
%>

<auth:checkAction var="isSecurityAdmin" action="${UBuildAction.SECURITY_ADMIN}"/>
<c:set var="canEditUserPassword" value="${isSecurityAdmin}"/>
<c:set var="canEditUser" value="${canEditUserPassword or isUser}"/>

<c:choose>
  <c:when test="${not empty user}">
    <c:set var="allowUserMgmt" value="${user.userManagementAllowed}"/>
    <c:set var="allowPassMgmt" value="${user.passwordChangeAllowed}"/>
    <c:set var="allowGroupMgmt" value="${user.groupManagementAllowed}"/>
  </c:when>
  <c:otherwise>
    <%
    AuthenticationRealm realm = (AuthenticationRealm) pageContext.findAttribute(WebConstants.AUTHENTICATION_REALM);
    SecurityHelper helper = new SecurityHelper();
    pageContext.setAttribute("allowUserMgmt", helper.isUserManagementAllowed(realm));
    pageContext.setAttribute("allowPassMgmt", helper.isPasswordChangeAllowed(realm));
    pageContext.setAttribute("allowGroupMgmt", helper.isGroupManagementAllowed(realm));
    %>
  </c:otherwise>
</c:choose>
<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
  </c:otherwise>
</c:choose>

<%-- URLs --%>

<c:url var="submitUrl" value="${UserTasks.saveUser}"/>
<c:url var="cancelUrl" value="${UserTasks.cancelUser}"/>
<c:url var="editUrl" value="${UserTasks.editUser}"/>
<c:url var="doneUrl" value="${UserTasks.viewUsers}">
  <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${authenticationRealm.id}" />
</c:url>
<c:url var="removeUsrRepoNameUrl" value="${UserTasks.removeUserRepoName}"/>
<c:url var="resetPasswordUrl" value="${UserTasks.beginResetPassword}"/>

<%--  begin content --%>

<div id="userForm" style="margin-top:2em;">

<c:if test="${allowUserMgmt && allowPassMgmt && not empty user}">
    <ucf:button name="ResetPassword" label="${ub:i18n('UserFormResetPassword')}" href="${resetPasswordUrl}"
        enabled="${inViewMode and (canEditUserPassword or isUser)}"/>
</c:if>

<div style="text-align: right;">
 <span class="required-text">${ub:i18n("RequiredField")}</span>
</div>

<form method="post" action="${fn:escapeXml(submitUrl)}">
  <ucf:hidden name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${authenticationRealm.id}"/>

  <table class="property-table">

    <tbody>
      <tr class="<%= eo.getNext() %>" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("AuthenticationRealmWithColon")}</span></td>

        <td align="left" width="20%">
          ${fn:escapeXml(authenticationRealm.name)}
        </td>

        <td align="left">
          <span class="inlinehelp">${ub:i18n("UserFormAuthenticationRealmDesc")}</span>
        </td>
      </tr>

      <error:field-error field="<%=UserTasks.PARAM_USER_NAME%>" cssClass="<%= eo.getNext() %>"/>
      <tr class="<%= eo.getLast() %>" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>

        <td align="left" width="20%">
          <c:set var="nameFieldEnabled" value="${(empty user or user.deleteable) and allowUserMgmt and inEditMode}" />
            
          <ucf:text name="<%=UserTasks.PARAM_USER_NAME%>" value="${user.name}" enabled="${nameFieldEnabled}"/>
          <c:if test="${!nameEnabled}">
            <ucf:hidden name="<%=UserTasks.PARAM_USER_NAME%>" value="${user.name}" />
          </c:if>
        </td>

        <td align="left">
          <span class="inlinehelp">${ub:i18n("UserFormNameDesc")}</span>
        </td>
      </tr>

      <c:if test="${empty user && allowPassMgmt}">
        <error:field-error field="<%=UserTasks.PARAM_USER_PASS%>" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>" valign="top">
          <td align="left" width="20%"><span class="bold">${ub:i18n("PasswordWithColon")} <span class="required-text">*</span></span></td>

          <td align="left" width="20%">
            <ucf:password name="<%=UserTasks.PARAM_USER_PASS%>" value="" enabled="${inEditMode}"/>
          </td>

          <td align="left">
            <span class="inlinehelp">
              ${ub:i18n("UserFormPasswordDesc")}
            </span>
          </td>
        </tr>

        <tr class="<%= eo.getNext() %>" valign="top">
          <td align="left" width="20%"><span class="bold">${ub:i18n("UpdatePasswordConfirmPassword")} <span class="required-text">*</span></span></td>

          <td align="left" width="20%">
            <ucf:password name="userPswdConfirm" value="" enabled="${inEditMode}"/>
          </td>

          <td align="left">
            <span class="inlinehelp">${ub:i18n("UpdatePasswordConfirmPasswordDesc")}</span>
          </td>
        </tr>
      </c:if>

      <tr class="<%= eo.getNext() %>" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("GroupsWithColon")}</span></td>

        <td align="left" width="20%">
          <%
          Set<Group> userGroups = user == null ? new HashSet<Group>() : user.getGroupSet();
          %>
          <c:forEach var="group" items="${groupList}">
            <c:if test="${group.authorizationRealm eq authenticationRealm.authorizationRealm}">
              <%
              Group group = (Group) pageContext.findAttribute("group");
              pageContext.setAttribute("checked", Boolean.valueOf(userGroups.contains(group)));
              pageContext.setAttribute("adminHasGroup", Boolean.valueOf(userGroups.contains(group) || currentUser.isAdmin()));
              %>
              <ucf:checkbox id="group-${group.id}" name="userGroup" value="${group.id}" checked="${checked}"
                enabled="${(empty user || user.guest || user.deleteable) && inEditMode && adminHasGroup && allowGroupMgmt}"/>
              <c:if test="${not adminHasGroup}"><span style="color: #808080" title="${ub:i18n('UserFormGroupAssignError')}"></c:if>
              <label for="group-${group.id}"><c:out value="${group.name}"/></label>
              <c:if test="${not adminHasGroup}"></span></c:if>
              <br>
            </c:if>
          </c:forEach>
        </td>

        <td align="left">
          <span class="inlinehelp">${ub:i18n("UserFormGroupsDesc")}</span>
        </td>
      </tr>

      <c:import url="userProfile.jsp"/>

      <tr class="odd">
        <td colspan="3">
          <c:choose>
            <c:when test="${inEditMode}">
              <ucf:button name="save-user"  label="${ub:i18n('Save')}"/>
              <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
            </c:when>
            <c:otherwise>
              <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}" enabled="${canEditUser}"/>
              <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>

    </tbody>
  </table>

</form>

</div>