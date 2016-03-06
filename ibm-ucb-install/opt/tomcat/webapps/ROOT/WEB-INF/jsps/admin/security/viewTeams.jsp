<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.security.TeamTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.security.UserTasks"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub" uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.TeamTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.UserTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<c:set var="disableButtons" value="${team != null}"/>

<auth:checkAction var="canCreateAndDeleteTeams" action="${UBuildAction.SECURITY_ADMIN}"/>
<auth:checkAction var="canManageTeamResources" action="${UBuildAction.TEAM_RESOURCE_MANAGE}"/>
<auth:checkAction var="canManageTeamUsers" action="${UBuildAction.TEAM_USER_MANAGE}"/>
<auth:checkAction var="canManageUsers" action="${UBuildAction.USER_MANAGE}"/>


<c:set var="onDocumentLoad" scope="request">
/* <![CDATA[ */
  require(["ubuild/Formatters"], function(Formatters) {
      var formatters = Formatters;
      require(["ubuild/security/team/TeamManager"], function(TeamManager) {
              var d = dojo.xhr.get({
                url: bootstrap.restUrl + "/security/user",
                handleAs: "json",
                load: function(user) {
                  var teamManager = new TeamManager({
                    user: user,
                    formatters: Formatters
                  });
                  
                  var teamId = "${teamSpaceId}";
                  if (teamId) {
                    var team;
                    dojo.forEach(teamManager.entries, function(entry) {
                      if (teamId === entry.id) {
                        team = entry;
                      }
                    });
                    teamManager.selectedEntry = team;
                    teamManager.placeAt("teamManager");
                  }
                  else {
                    teamManager.placeAt("teamManager");
                  }
                }
          });
      });
  });
/* ]]> */
</c:set>
<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('SystemSecurityTeams')}"/>
    <c:param name="selected" value="teams"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>
<div>
    <div class="tabManager" id="secondLevelTabs">
        <c:url var="viewTeamsUrl" value="${TeamTasks.viewTeams}"/>
        <c:url var="viewUsersUrl" value="${UserTasks.viewUsers}"/>
        <c:url var="viewAuditUrl" value="${TeamTasks.viewAudit}"/>
        <ucf:link href="${viewTeamsUrl}" klass="selected tab" label="${ub:i18n('Teams')}" enabled="${!disableButtons}"/>
        <ucf:link href="${viewUsersUrl}" klass="tab" label="${ub:i18n('Users')}" enabled="${!disableButtons && canManageUsers}"/>
        <ucf:link href="${viewAuditUrl}" klass="tab" label="${ub:i18n('Auditing')}" enabled="${canManageUsers or canManageTeamResources}"/>
    </div>
    <div class="contents">
        <div class="team-manager" id="teamManager"></div>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
