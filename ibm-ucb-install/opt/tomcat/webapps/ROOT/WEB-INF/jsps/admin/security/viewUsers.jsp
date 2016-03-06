<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.security.SecurityHelper"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.security.UserTasks"%>
<%@page import="com.urbancode.ubuild.web.admin.security.TeamTasks" %>
<%@page import="com.urbancode.security.AuthenticationRealm"%>
<%@page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildUser"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub" uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.UserTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.TeamTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:set var="disableButtons" value="${user != null && fn:escapeXml(mode) == 'edit'}" />

<c:url var="submitUrl" value="${UserTasks.viewUsers}" />
<c:url var="userTasksUrl" value="/tasks/admin/security/UserTasks"/>

<c:set var="onDocumentLoad" scope="request">
  /* <![CDATA[ */
  require(["ubuild/table/UsersTable"], function(UsersTable) {
      var table = new UsersTable({ "tasksUrl": "${userTasksUrl}" });
      table.placeAt("userList");
  });
  /* ]]> */
</c:set>
<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('UsersSecurityUsers')}" />
  <c:param name="selected" value="teams" />
  <c:param name="disabled" value="${disableButtons}" />
</c:import>

<div>

  <div class="tabManager" id="secondLevelTabs">
    <c:url var="viewTeamsUrl" value="${TeamTasks.viewTeams}"/>
    <c:url var="usersUrl" value="${UserTasks.viewUsers}" />
    <c:url var="auditUrl" value="${TeamTasks.viewAudit}"/>
    <ucf:link href="${viewTeamsUrl}" klass="tab" label="${ub:i18n('Teams')}" enabled="${!disableButtons}"/>
    <ucf:link href="${usersUrl}" klass="selected tab" label="${ub:i18n('Users')}" enabled="${!disableButtons}"/>
    <ucf:link href="${auditUrl}" klass="tab" label="${ub:i18n('Auditing')}" enabled="${!disableButtons}"/>
  </div>

  <div class="contents">
    <div class="system-helpbox">${ub:i18n("UsersHelpBox")}</div>
    <div id="createBtnDiv">
      <br />
      <%
        boolean isSecurityAdmin = Authority.getInstance().hasPermission(UBuildAction.SECURITY_ADMIN);
        boolean hasUserManage = Authority.getInstance().hasPermission(UBuildAction.USER_MANAGE);
        pageContext.setAttribute("canCreateUser", isSecurityAdmin || hasUserManage);
      %>
      <c:if test="${canCreateUser}">
        <c:url var="createUserUrl" value="${UserTasks.newUser}"/>
        <c:url var="importUserUrl" value="${UserTasks.importUser}"/>
        <ucf:link href="${createUserUrl}" klass="button" label="${ub:i18n('CreateUser')}" enabled="${!disableButtons}" />
        <ucf:link href="${importUserUrl}" klass="button" label="${ub:i18n('ImportUsers')}" enabled="${!disableButtons}" />
      </c:if>
    </div>
    <br />
    <%-- User List --%>
    <div id="userList"></div>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp" />
