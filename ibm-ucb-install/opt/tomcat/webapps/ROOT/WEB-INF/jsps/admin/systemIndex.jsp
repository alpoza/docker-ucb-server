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
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.SystemFunction"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentrelay.AgentRelayTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.artifacts.ArtifactSetTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.cleanup.CleanupTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.plugin.PluginTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.plugin.automation.AutomationPluginTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTypeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.TeamTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerPropertiesTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.status.StatusTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authentication.AuthenticationRealmTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.GroupTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.RoleTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.UserTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.AuthTokenTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.integration.maven.MavenSettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.announcements.AnnouncementTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.schedules.ScheduleTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.proxy.ProxySettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.license.LicenseTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.mailserver.MailServerTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.im.IMTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.audit.AuditTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.lock.LockableResourceTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.repository.RepositoryTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.script.job.JobPreConditionScriptTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.script.postprocess.PostProcessScriptTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.script.step.StepPreConditionScriptTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.workdir.WorkDirScriptTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.notification.scheme.NotificationSchemeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.templates.TemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.notification.recipientgenerator.NotificationRecipientGeneratorTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.notification.caseselector.WorkflowCaseSelectorTasks" />

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="title" value="${ub:i18n('System')}"/>
    <jsp:param name="selected" value="system"/>
</jsp:include>

<c:url var="systemUrl" value="${SystemTasks.viewIndex}"/>

<c:url var="agentUrl"        value="${AgentTasks.viewList}"/>
<c:url var="environmentUrl"  value="${AgentPoolTasks.viewAgentPoolList}"/>

<c:url var="authenticationUrl" value="${AuthenticationRealmTasks.viewList}"/>
<c:url var="authorizationUrl" value="${AuthorizationRealmTasks.viewList}"/>
<c:url var="groupsUrl"   value="${GroupTasks.viewGroups}"/>
<c:url var="resourceTypesUrl"   value="${ResourceTypeTasks.viewResourceTypes}"/>
<c:url var="rolesUrl"   value="${RoleTasks.viewRoles}"/>
<c:url var="usersUrl"   value="${UserTasks.viewUsers}"/>
<c:url var="authTokensUrl" value="${AuthTokenTasks.viewAuthTokens}"/>
<c:url var="teamsUrl" value="${TeamTasks.viewTeams}"/>

<c:url var="mavenSettingsUrl" value="${MavenSettingsTasks.viewMavenSettings}"/>

<c:url var="announcementsUrl"          value="${AnnouncementTasks.viewAnnouncementList}"/>
<c:url var="scheduleUrl"      value="${ScheduleTasks.viewList}"/>
<c:url var="proxySettingsUrl"      value="${ProxySettingsTasks.viewProxySettings}"/>
<c:url var="serverSettingsUrl" value="${ServerSettingsTasks.viewServerSettings}"/>
<c:url var="licenseUrl"         value="${LicenseTasks.viewUsers}"/>

<c:url var="mailServerUrl" value="${MailServerTasks.viewMailServer}"/>
<c:url var="xmppImUrl"         value="${IMTasks.viewXmppIMSettings}"/>
<c:url var="auditUrl" value="${AuditTasks.viewAudit}"/>

<c:url var="lockableUrl"          value="${LockableResourceTasks.viewLockList}"/>
<c:url var="repositoryUrl"    value="${RepositoryTasks.viewList}"/>

<c:url var="jobPreConditionScriptUrl"      value="${JobPreConditionScriptTasks.viewScriptList}"/>
<c:url var="postProcessScriptUrl"      value="${PostProcessScriptTasks.viewScriptList}"/>
<c:url var="stepPreConditionScriptUrl"      value="${StepPreConditionScriptTasks.viewScriptList}"/>
<c:url var="workDirScriptUrl" value="${WorkDirScriptTasks.viewList}"/>

<c:url var="notificationSchemeUrl" value="${NotificationSchemeTasks.viewList}"/>
<c:url var="notificationTemplateUrl"  value="${TemplateTasks.viewList}"/>
<c:url var="recipientGeneratorUrl" value="${NotificationRecipientGeneratorTasks.viewList}"/>
<c:url var="caseSelectorUrl" value="${WorkflowCaseSelectorTasks.viewList}"/>

<c:url var="artifactSetsUrl"  value='${ArtifactSetTasks.viewList}'/>
<c:url var="cleanupUrl"  value='${CleanupTasks.viewCleanup}'/>
<c:url var="statusesUrl"  value='${StatusTasks.viewList}'/>

<%
boolean showAudit = false;
boolean showIntegration = true;
boolean showLocks = true;
boolean showNotification = true;
boolean showRepos = true;
boolean showSchedule = true;
boolean showScripts = true;
boolean showSecurity = false;
boolean showServer = true;
try {
    showAudit = SystemFunction.hasPermission(UBuildAction.AUDITING);
    showSecurity = SystemFunction.hasPermission(UBuildAction.SECURITY_ADMIN);
}
catch (Exception e) {
    e.printStackTrace();
}

pageContext.setAttribute("showServer", showServer);
pageContext.setAttribute("showIntegration", showIntegration);
%>

<script type="text/javascript">
  /* <![CDATA[ */

    // Automatin Plugins and Maven
    var integrationLinks = new Array();

    integrationLinks.push(new Element('a', {href:'${ah3:escapeJs(mavenSettingsUrl)}'}).update('Maven'));
    <c:forEach var="plugin" items="${pluginList}">
      <c:url var="viewPluginListUrl" value="${AutomationPluginTasks.viewPluginList}">
        <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
      </c:url>
    integrationLinks.push(new Element('a', {href:'${ah3:escapeJs(viewPluginListUrl)}'}).update("${ah3:escapeJs(plugin.name)}"));
    </c:forEach>

    // sort the integration links
    integrationLinks.sort(function(link1, link2){
        var link1Name = (link1.innerText || link1.textContent).toLowerCase();
        var link2Name = (link2.innerText || link2.textContent).toLowerCase();
        return link1Name < link2Name ? -1 : (link1Name > link2Name ? 1 : 0);
    });

    // attach the links to the IntegrationPane when page loaded
    document.observe("dom:loaded", function() { // no need to put in the header, no JS i18n used
        var integrationListElement = $('integrationListElement');

        // remove existing child elements (should be the loading message)
        integrationListElement.update();

        // adding integration links (in reverse order so that list is physically scrolled to the top initially)
        integrationLinks.reverse().each(function(link){
        <c:if test="${!showIntegration}">
            link.removeAttribute('href');
            link.style.color='#c0c0c0';
            link.title="${ub:i18n('SystemRequiresIntegrationAdminMessage')}";
        </c:if>
        integrationListElement.insert({top:new Element('li', {style: 'white-space: nowrap;'}).update(link)});
    });
  });

  /* ]]> */
</script>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('System')}" href="${systemUrl}" enabled="${false}" klass="selected tab"/>
</div>
<div class="new-container">
  <div class="new-anthill-portal-page">

    <div class="system-page-window">
        <div class="system-page-window-titlebar">${ub:i18n("Integration")}</div>
        <div class="system-page-window-content">
            <ul class="left-nav" id="integrationListElement">
                <li>${ub:i18n("LoadingEllipsis")}</li>
            </ul>
        </div>
    </div>

    <div class="system-page-window">
        <div class="system-page-window-titlebar">${ub:i18n("Notification")}</div>
        <div class="system-page-window-content">
            <ul class="left-nav">
              <% if (showNotification) { %>
                <li><a href="${fn:escapeXml(mailServerUrl)}">${ub:i18n("MailServer")}</a></li>
                <li><a href="${fn:escapeXml(xmppImUrl)}">${ub:i18n("XMPPIM")}</a></li>
                <li><hr size="1"/></li>
                <li><a href="${fn:escapeXml(notificationSchemeUrl)}">${ub:i18n("NotificationSchemes")}</a></li>
                <li><a href="${fn:escapeXml(notificationTemplateUrl)}">${ub:i18n("NotificationTemplates")}</a></li>
                <li><a href="${fn:escapeXml(recipientGeneratorUrl)}">${ub:i18n("RecipientGenerators")}</a></li>
                <li><a href="${fn:escapeXml(caseSelectorUrl)}">${ub:i18n("EventSelectors")}</a></li>
              <% } else { %>
                <li><a title="${ub:i18n('SystemRequiresNotificationAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("MailServer")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresNotificationAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("XMPPIM")}</a></li>
                <li><hr size="1"/></li>
                <li><a title="${ub:i18n('SystemRequiresNotificationAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("NotificationSchemes")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresNotificationAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("NotificationTemplates")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresNotificationAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("RecipientGenerators")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresNotificationAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("EventSelectors")}</a></li>
              <% } %>
            </ul>
        </div>
    </div>

    <div class="system-page-window">
        <div class="system-page-window-titlebar">${ub:i18n("ProjectSupport")}</div>
        <div class="system-page-window-content">
            <ul class="left-nav">
                <li><a href="${fn:escapeXml(artifactSetsUrl)}">${ub:i18n("ArtifactSets")}</a></li>
                <li><a href="${fn:escapeXml(cleanupUrl)}">${ub:i18n("Cleanup")}</a></li>
                <% if (showLocks) { %>
                <li><a href="${fn:escapeXml(lockableUrl)}">${ub:i18n("LockableResources")}</a></li>
                <% } else { %>
                <li><a title="${ub:i18n('SystemRequiresProjectAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("LockableResources")}</a></li>
                <% } %>
                <% if (showRepos) { %>
                <li><a href="${fn:escapeXml(repositoryUrl)}">${ub:i18n("Repositories")}</a></li>
                <% } else { %>
                <li><a title="${ub:i18n('SystemRequiresRepoAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Repositories")}</a></li>
                <% } %>
                <% if (showSchedule) { %>
                <li><a href="${fn:escapeXml(scheduleUrl)}">${ub:i18n("Schedules")}</a></li>
                <% } else { %>
                <li><a title="${ub:i18n('SystemRequiresScheduleAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Schedules")}</a></li>
                <% } %>
                <li><a href="${fn:escapeXml(statusesUrl)}">${ub:i18n("Statuses")}</a></li>
            </ul>
        </div>
    </div>

    <div class="system-page-window">
        <div class="system-page-window-titlebar">${ub:i18n("ScriptLibrary")}</div>
        <div class="system-page-window-content">
            <ul class="left-nav">
              <% if (showScripts) { %>
              <li><a href="${fn:escapeXml(jobPreConditionScriptUrl)}">${ub:i18n("JobPreCondition")}</a></li>
              <li><a href="${fn:escapeXml(postProcessScriptUrl)}">${ub:i18n("PostProcessing")}</a></li>
              <li><a href="${fn:escapeXml(stepPreConditionScriptUrl)}">${ub:i18n("StepPreCondition")}</a></li>
              <li><a href="${fn:escapeXml(workDirScriptUrl)}">${ub:i18n("WorkDir")}</a></li>
              <% } else { %>
              <li><a title="${ub:i18n('SystemRequiresScriptAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("JobPreCondition")}</a></li>
              <li><a title="${ub:i18n('SystemRequiresScriptAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("PostProcessing")}</a></li>
              <li><a title="${ub:i18n('SystemRequiresScriptAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("StepPreCondition")}</a></li>
              <li><a title="${ub:i18n('SystemRequiresScriptAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("WorkDir")}</a></li>
              <% } %>
            </ul>
        </div>
    </div>

    <div class="system-page-window">
        <div class="system-page-window-titlebar">${ub:i18n("SecurityWithColon")}</div>
        <div class="system-page-window-content">
            <ul class="left-nav">
              <% if (showAudit) { %>
              <li><a href="${fn:escapeXml(auditUrl)}">${ub:i18n("Audit")}</a></li>
              <% } else { %>
              <li><a title="${ub:i18n('SystemRequiresAuditAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Audit")}</a></li>
              <% } %>
              <% if (showSecurity) { %>
              <li><a href="${fn:escapeXml(authenticationUrl)}">${ub:i18n("Authentication")}</a></li>
              <li><a href="${fn:escapeXml(authorizationUrl)}">${ub:i18n("Authorization")}</a></li>
              <li><a href="${fn:escapeXml(authTokensUrl)}">${ub:i18n("AuthTokens")}</a></li>
              <li><a href="${fn:escapeXml(groupsUrl)}">${ub:i18n("Groups")}</a></li>
              <li><a href="${fn:escapeXml(resourceTypesUrl)}">${ub:i18n("ResourceTypes")}</a></li>
              <li><a href="${fn:escapeXml(rolesUrl)}">${ub:i18n("Roles")}</a></li>
              <% } else { %>
              <li><a title="${ub:i18n('SystemRequiresSecurityAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Authentication")}</a></li>
              <li><a title="${ub:i18n('SystemRequiresSecurityAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Authorization")}</a></li>
              <li><a title="${ub:i18n('SystemRequiresSecurityAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("AuthTokens")}</a></li>
              <li><a title="${ub:i18n('SystemRequiresSecurityAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Groups")}</a></li>
              <li><a title="${ub:i18n('SystemRequiresSecurityAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("ResourceTypes")}</a></li>
              <li><a title="${ub:i18n('SystemRequiresSecurityAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Roles")}</a></li>
              <% } %>
            </ul>
        </div>
    </div>

    <div class="system-page-window">
        <div class="system-page-window-titlebar">${ub:i18n("ServerWithColon")}</div>
        <div class="system-page-window-content">
            <ul class="left-nav">
              <c:if test="${showServer}">
                <%-- <li><a href="<c:url value='${AgentRelayTasks.viewList}'/>">${ub:i18n("AgentRelays")}</a></li> --%>
                <li><a href="${fn:escapeXml(announcementsUrl)}">${ub:i18n("Announcements")}</a></li>
                <li><a href="${fn:escapeXml(licenseUrl)}">${ub:i18n("Licenses")}</a></li>
                <li><a href="<c:url value="${PluginTasks.viewPluginList}"/>">${ub:i18n("Plugins")}</a></li>
                <li><a href="<c:url value="${ServerPropertiesTasks.viewProperties}"/>">${ub:i18n("Properties")}</a></li>
                <li><a href="${fn:escapeXml(proxySettingsUrl)}">${ub:i18n("ProxySettings")}</a></li>
                <li><a href="${fn:escapeXml(serverSettingsUrl)}">${ub:i18n("ServerSettings")}</a></li>
              </c:if>
              <c:if test="${!showServer}">
                <%-- <li><a title="${ub:i18n('SystemRequiresServerAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("AgentRelays")}</a></li> --%>
                <li><a title="${ub:i18n('SystemRequiresServerAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Announcements")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresServerAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Licenses")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresServerAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Plugins")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresServerAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("Properties")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresServerAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("ProxySettings")}</a></li>
                <li><a title="${ub:i18n('SystemRequiresServerAdminMessage')}" style="color: #c0c0c0;">${ub:i18n("ServerSettings")}</a></li>
              </c:if>
            </ul>
        </div>
    </div>

  </div>
</div>
<br class="newline"/>
<br/>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
