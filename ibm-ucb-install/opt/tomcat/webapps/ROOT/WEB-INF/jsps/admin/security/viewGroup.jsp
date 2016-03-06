<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.admin.security.GroupTasks"%>
<%@ page import="com.urbancode.ubuild.web.admin.security.authentication.anthill.AnthillAuthenticationRealmTasks" %>

<%@taglib prefix="c"        uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"       uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"      tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error"    uri="error"%>
<%@taglib prefix="ah3"      uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.GroupTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.SecurityUserAdminTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<%
    pageContext.setAttribute("eo", new EvenOdd());
%>

<c:url var="cancelUrl" value="${GroupTasks.cancelGroup}"/>
<c:url var="editUrl" value="${GroupTasks.editGroup}"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('SystemSecurityGroups')}"/>
    <c:param name="selected" value="system"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <c:url var="rolesUrl" value="${GroupTasks.viewGroups}"/>
      <ucf:link href="${groupsUrl}" label="${ub:i18n('Groups')}" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
      <br/>
      <c:url var="submitUrl" value="${GroupTasks.saveGroup}"/>
      <form method="POST" action="${fn:escapeXml(submitUrl)}" style="margin-top:1em">
        <ucf:hidden name="${WebConstants.GROUP_ID}" value="${group.id}"/>
        
        <div style="text-align: right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
        <table class="property-table">
          <tbody>
            <error:field-error field="${WebConstants.GROUP_NAME}" cssClass="${eo.next}"/>
            <tr class="${fn:escapeXml(eo.last)}" valign="top">
              <td align="left" width="20%"><strong>${ub:i18n("GroupNameWithColon")}</strong><span class="required-text">*</span></td>

              <td align="left" width="20%">
                <ucf:text name="${WebConstants.GROUP_NAME}" value="${empty group ? name : group.name}"
                          enabled="${(isGroupManagementAllowed and inEditMode) or empty group}"/>
              </td>

              <td align="left">
                <span class="inlinehelp">${ub:i18n("GroupsNameDesc")}</span>
              </td>
            </tr>
            <error:field-error field="<%= WebConstants.AUTHORIZATION_REALM_ID %>" cssClass="${eo.next}"/>
            <tr class="${fn:escapeXml(eo.last)}" valign="top">
              <td align="left" width="20%">
                <span class="bold">${ub:i18n("AuthorizationRealmWithColon")} <span class="required-text">*</span></span>
              </td>
              <td align="left">
                <c:choose>
                  <c:when test="${not empty authorizationRealmList}">
                    <ucf:idSelector name="<%= WebConstants.AUTHORIZATION_REALM_ID %>"
                          list="${authorizationRealmList}"
                          selectedId="${authorizationRealmId}"/>
                  </c:when>
                  <c:when test="${not empty authorizationRealm}">
                    <c:out value="${authorizationRealm.name}" />
                  </c:when>
                </c:choose>
              </td>
              <td align="left">
                <span class="inlinehelp">${ub:i18n("GroupsRealmDesc")}</span>
              </td>
            </tr>
            <c:if test="${not empty group}">
              <tr class="${fn:escapeXml(eo.next)}" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("UsersWithColon")} </span></td>
                <td colspan="2" align="left">
                  <c:if test="${empty group.users}">
                    <span>${ub:i18n("GroupsNoUsersMessage")}</span>
                  </c:if>
                  <ul>
                    <c:forEach var="user" items="${group.users}">
                      <li>${fn:escapeXml(user.name)}
                        <c:if test="${not empty user.actualName}"> (${fn:escapeXml(user.actualName)})</c:if>
                      </li>
                    </c:forEach>
                  </ul>
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
        <br/>
        <c:choose>
          <c:when test="${(isGroupManagementAllowed and inEditMode) or empty group}">
            <ucf:button name="save-group" label="${ub:i18n('Save')}" />
            <ucf:button href="${cancelUrl}" name="cancel-group" label="${ub:i18n('Cancel')}"/>
          </c:when>
          <c:otherwise>
            <ucf:button href="${editUrl}" name="edit-group" label="${ub:i18n('Edit')}"/>
            <ucf:button href="${cancelUrl}" name="cancel-group" label="${ub:i18n('Done')}"/>
          </c:otherwise>
        </c:choose>
        <c:if test="${isGroupManagementAllowed and not empty group}">
          <c:url var="manageGroupUsersUrl" value="${SecurityUserAdminTasks.viewAddRemoveGroupUsers}">
            <c:param name="${WebConstants.GROUP_ID}" value="${group.id}"/>
          </c:url>
          <ucf:button submit="false" onclick="showPopup('${manageGroupUsersUrl}', 1000, 800);" name="ManageUsers" label="${ub:i18n('ManageUsers')}"/>
        </c:if>
      </form>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
      