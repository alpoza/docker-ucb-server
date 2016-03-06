<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildUser"%>
<%@page import="com.urbancode.ubuild.persistence.UnitOfWork" %>
<%@page import="com.urbancode.ubuild.web.*"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.ubuild.web.admin.security.LoginTasks"%>
<%@page import="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks"%>
<%@page import="com.urbancode.commons.webext.util.InstalledVersion"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants id="LoginConsts" class="com.urbancode.ubuild.web.admin.security.LoginTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.main.server.ServerConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.LoginTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.codestation2.CodestationTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.plugin.PluginTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.TeamTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.currentactivity.CurrentActivityTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.NewDashboardTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.UserProfileTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.reporting.ReportingTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.radiator.RadiatorTasks" />

<c:url var="imagesUrl" value="/images"/>
<c:set var="uBuildLogoImg" value="${imagesUrl}/uBuild_logo.png"/>

<c:url var="rootPageUrl" value="/"/>
<c:url var="authenticateUrl" value="${LoginTasks.authenticate}"/>
<c:url var="logoutUrl" value="${LoginTasks.logout}"/>
<c:url var="loginUrl" value="${LoginTasks.login}"/>
<c:set var="isGuest" value="${key_current_user.name == 'guest'}"/>
<c:url var="announcementsUrl" value="${UserProfileTasks.viewAnnouncements}"/>

<%-- nav-urls for top-level tabs --%>
<c:url var="projectsUrl" value="${DashboardTasks.viewDashboard}"/>
<c:url var="currentActivityUrl" value="${CurrentActivityTasks.viewCurrentActivity}"/>
<c:url var="searchUrl" value="${SearchTasks.viewSearch}"/>
<c:url var="reportingUrl" value="${ReportingTasks.viewReportList}"/>
<c:url var="codestationUrl" value="${CodestationTasks.viewList}"/>
<c:url var="templatesUrl" value="${ProjectTemplateTasks.viewList}"/>
<c:url var="teamsUrl" value="${TeamTasks.viewTeams}"/>
<c:url var="agentsUrl" value="${AgentTasks.viewList}"/>
<c:url var="systemUrl" value="${SystemTasks.viewIndex}"/>
<c:url var="profileUrl" value="${UserProfileTasks.viewCurrentUser}"/>
<c:url var="radiatorUrl" value="${RadiatorTasks.viewRadiator}"/>
<c:url var="helpCenterUrl" value="http://www.ibm.com/support/knowledgecenter/SS8NMD_6.1.2"/>
<c:url var="toolsUrl" value="/tools"/>

<c:choose>
  <c:when test="${param.selected == 'projects'}">
    <c:set var="dashboardClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'currentActivity'}">
    <c:set var="currentActivityClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'search'}">
    <c:set var="searchClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'system'}">
    <c:set var="systemClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'agents'}">
    <c:set var="agentsClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'reporting'}">
    <c:set var="reportingClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'teams'}">
    <c:set var="teamsClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'codestation'}">
    <c:set var="codestationClass" value="selected"/>
  </c:when>

  <c:when test="${param.selected == 'template'}">
    <c:set var="templatesClass" value="selected"/>
  </c:when>
</c:choose>

<%
  // err on the side of caution - when this page is used in the error page
  // certain exceptions may cause these statements to fail
  try {
      Authority authority = Authority.getInstance();
      pageContext.setAttribute("showSystemTab", authority.hasPermission(UBuildAction.SYSTEM_TAB));
      pageContext.setAttribute("showAgentsTab", authority.hasPermission(UBuildAction.AGENT_VIEW));
      pageContext.setAttribute("showTeamsTab", authority.hasPermission(UBuildAction.SYSTEM_TAB) ||
          authority.hasPermission(UBuildAction.TEAM_RESOURCE_MANAGE) ||
          authority.hasPermission(UBuildAction.TEAM_USER_MANAGE));
      pageContext.setAttribute("showCodestationTab", authority.hasPermission(UBuildAction.CODESTATION_VIEW));
      pageContext.setAttribute("showConfigurationTab", authority.hasPermission(UBuildAction.PROJECT_TEMPLATE_VIEW));
      pageContext.setAttribute("showReportingTab", authority.hasPermission(UBuildAction.REPORT_RUN) ||
          authority.hasPermission(UBuildAction.REPORT_EDIT) ||
          authority.hasPermission(UBuildAction.REPORT_CREATE));

      pageContext.setAttribute("allowAutocomplete", ServerSettingsTasks.isAllowAutoComplete());
      pageContext.setAttribute("allowLoginCookie", LoginTasks.isAllowLoginCookie());
  }
  catch (Exception e) {
      // do nothing
  }

  try {
      String uBuildVersion = InstalledVersion.getInstance().getVersion();
      request.setAttribute("uBuildVersion", uBuildVersion);
      request.setAttribute("uBuildVersionIsDev", uBuildVersion != null && (uBuildVersion.endsWith("dev") ||
          uBuildVersion.endsWith("_dev")));
  }
  catch (Exception e) {
      // do nothing
  }
%>
<%-- CONTENT --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="content-type"  content="text/html; charset=UTF-8"/>
    <meta http-equiv="Pragma"        content="no-cache"/>
    <meta http-equiv="Cache-Control" content="no-cache"/>

    <title>${ub:i18n("ProductNameWithColon")}&nbsp;<c:out value="${param.title}"/></title>
    <c:url var="iconImgUrl" value="/images/favicon.ico"/>
    <link rel="shortcut icon" href="${iconImgUrl}"/>

    <c:import url="/WEB-INF/snippets/includeCssAndScripts.jsp"/>

    <c:choose>
      <c:when test="${param.allowFraming}">
        <script type="text/javascript">
          /* <![CDATA[ */
          // only Anthill pages should be allowed to frame other Anthill pages
          var anthillContextUrl = self.location.protocol + '//' + self.location.host + '${fn:escapeXml(rootPageUrl)}';

          // String.startsWith is provided by the prototype.js library
          if ( top != self && !top.location.href.startsWith(anthillContextUrl)) {
            //alert('caution: potential cross-site-framing exploit attempt detected, probably followed an untrustworthy link');
            top.location = self.location;
          }
          /* ]]> */
        </script>
      </c:when>
      <c:otherwise>
        <%-- TODO: add a param to the url so that we can visually indicate that we did something wrong?--%>
        <script type="text/javascript">
          /* <![CDATA[ */
          if (top != self) {
            //alert('caution: potential cross-site-framing exploit attempt detected, probably followed an untrustworthy link');
            var orig = self.location.href;
            var queryIndex = orig.indexOf('?');
            var anchorIndex = orig.indexOf('#', Math.max(0, queryIndex));
            var extraParam = (queryIndex == -1 ? '?framed=true' : '&framed=true');
            var finalUrl = null;
            if (anchorIndex == -1) {
                finalUrl = orig + extraParam;
            }
            else {
                finalUrl = orig.substring(0, anchorIndex) + extraParam + orig.substring(anchorIndex);
            }

            <c:choose>
                <c:when test="${uBuildVersionIsDev}">
                    alert('Improper framing behavior detected');
                </c:when>
                <c:otherwise>
                    top.location.href = finalUrl;
                </c:otherwise>
            </c:choose>
          }
          /* ]]> */
        </script>
      </c:otherwise>
    </c:choose>

    <c:if test="${cookie['devMode'].value == 'true' || (uBuildVersionIsDev && cookie['devMode'].value != 'false')}">
      <script type="text/javascript">
        /* <![CDATA[ */
        Element.observe(window, 'load', function() {
            $(document.body).addClassName('devMode');
            if (document.compatMode==='BackCompat') {
                window.alert('Page rendered in Quirks-mode!!');
            }
        });
        /* ]]> */
      </script>
    </c:if>

    <!--[if gte IE 9]>
      <style type="text/css">
        .gradient {
           filter: none;
        }
      </style>
    <![endif]-->

    ${requestScope.headContent}

    <script type="text/javascript">
    /* <![CDATA[ */
    function toggleNav() {
        var navDropdown = $('nav_dropdown_menu');
        navDropdown.visible() ? navDropdown.hide() : navDropdown.show();
    }
    document.observe("dom:loaded", function() { // no need to put in the header, no JS i18n used
        jQuery('#nav_dropdown_menu').mouseleave(function() {
            jQuery('#nav_dropdown_menu').hide();
        });
    });
    /* ]]> */
    </script>

  </head>
  <c:set var="bodyOnLoad" value="onload='focusOnFirstField();'" />
  <c:if test="${param.doNotFocus}">
      <c:set var="bodyOnLoad" value="" />
  </c:if>

  <%
      UBuildUser user = (UBuildUser) session.getAttribute(LoginTasks.KEY_CURRENT_USER);
  %>
  <c:choose>
    <c:when test="${!empty key_current_user.actualName}">
      <c:set var="displayName" value="${key_current_user.actualName}"/>
    </c:when>
    <c:when test="${!empty key_current_user.name}">
      <c:set var="displayName" value="${key_current_user.name}"/>
    </c:when>
    <c:otherwise>
      <c:set var="displayName" value="${ub:i18n('Guest')}"/>
      <c:set var="isGuest" value="${true}"/>
    </c:otherwise>
  </c:choose>
  <body ${bodyOnLoad} class="oneui">
    <div id="header">
      <div id="container"></div>
      <div class="notification-content-container" id="notificationContainerNode"></div>
      <script>
        require(["dojo/ready",
                 "dojo/dom-style",
                 "dojo/dom-class",
                 "dojo/dom-construct",
                 "dojo/mouse",
                 "dojo/on",
                 "dojo/dom",
                 "idx/app/Header",
                 "dijit/Menu",
                 "dijit/MenuItem",
                 "dijit/PopupMenuBarItem",
                 "dijit/Dialog",
                 "dijit/form/Button",
                 "idx/widget/Menu",
                 "idx/widget/MenuDialog",
                 "idx/widget/MenuBar",
                 "js/util/ie/goTo"],
        function (ready, domStyle, domClass, domConstruct, mouse, on, dom, Header, Menu, MenuItem,
                  PopupMenuBarItem, Dialog, Button, SuperMenu, MenuDialog, MenuBar, goTo) {

            createUserMenu = function() {
                var userMenu = new Menu({});

                <c:choose>
                    <c:when test="${not isGuest}">
                        <%-- Header is doing something with these links. The on click is required and it opens them in a new tab --%>
                        var profileMenuItem = new MenuItem({label: '<a href="${ah3:escapeJs(profileUrl)}" class="header-link">${ah3:escapeJs(ub:i18n("EditProfile"))}</a>'});
                        on(profileMenuItem.domNode, "click", function() {
                            goTo("${ah3:escapeJs(profileUrl)}");
                        });

                        var logoutMenuItem = new MenuItem({label: '<a href="${ah3:escapeJs(logoutUrl)}" class="header-link">${ah3:escapeJs(ub:i18n("LogOut"))}</a>'});
                        on(logoutMenuItem.domNode, "click", function() {
                            goTo("${ah3:escapeJs(logoutUrl)}");
                        });

                        userMenu.addChild(profileMenuItem);
                        userMenu.addChild(logoutMenuItem);

                    </c:when>
                    <c:otherwise>
                        var loginMenuItem = new MenuItem({label: '<a href="${ah3:escapeJs(loginUrl)}" class="header-link">${ah3:escapeJs(ub:i18n("Login"))}</a>'});
                        on(loginMenuItem.domNode, "click", function() {
                            goTo("${ah3:escapeJs(loginUrl)}");
                        });
                        userMenu.addChild(loginMenuItem);
                    </c:otherwise>
                </c:choose>

                return userMenu;
            };

            createAboutMenu = function() {
                var aboutFrame = new Dialog({
                    className: "about-popup",
                    closeable: true
                });

                var aboutcloseButton = domConstruct.create("div", {
                    className: "close-popup-button",
                    title: "${ah3:escapeJs(ub:i18n('Close'))}"
                }, aboutFrame.titleNode);
                on(aboutcloseButton, "click", function(){
                    aboutFrame.hide();
                });

                var aboutProductName = domConstruct.create("div", {
                    className: "product-name",
                    innerHTML: "${ah3:escapeJs(ub:i18n('ProductName'))}"
                }, aboutFrame.containerNode);

                var aboutProductVersion = domConstruct.create("div", {
                    className: "product-version",
                    innerHTML: "${fn:escapeXml(ub:i18nMessage('ServerVersionLowercase', uBuildVersion))}"
                }, aboutFrame.containerNode);

                var aboutProductDescription = domConstruct.create("div", {
                    className: "product-description",
                    innerHTML:
                        "${ah3:escapeJs(ub:i18nMessage('Copyright', '2016'))}&nbsp;${ah3:escapeJs(ub:i18n('AllRightsReserved'))}"
                }, aboutFrame.containerNode);

                var aboutMenuItem = new MenuItem({label: "${ah3:escapeJs(ub:i18n('About'))}"});
                on(aboutMenuItem.domNode, "click", function(){
                    aboutFrame.show();
                    on(dom.byId("dijit_DialogUnderlay_0"), "click", function(){
                        aboutFrame.hide();
                    });
                });

                return aboutMenuItem;
            };

            createHelpMenu = function() {
                var helpMenu = new Menu({
                    openOnHover: true
                });

                var aboutMenuItem = createAboutMenu();

                <%-- Header is doing something with these links. The on click is required and it opens them in a new tab --%>
                var helpMenuItem = new MenuItem({label: '<a href="${ah3:escapeJs(helpCenterUrl)}" class="header-link">${ah3:escapeJs(ub:i18n("HelpCenter"))}</a>'});
                on(helpMenuItem.domNode, "click", function() {
                    window.open("${ah3:escapeJs(helpCenterUrl)}");
                });

                var radiatorMenuItem = new MenuItem({label: '<a href="${ah3:escapeJs(radiatorUrl)}" class="header-link">${ah3:escapeJs(ub:i18n("InfoRadiator"))}</a>'});
                on(radiatorMenuItem.domNode, "click", function() {
                    goTo("${ah3:escapeJs(radiatorUrl)}");
                });

                var toolsMenuItem = new MenuItem({label: '<a href="${ah3:escapeJs(toolsUrl)}" class="header-link">${ah3:escapeJs(ub:i18n("Tools"))}</a>'});
                on(toolsMenuItem.domNode, "click", function() {
                    goTo("${ah3:escapeJs(toolsUrl)}");
                });

                helpMenu.addChild(helpMenuItem);
                helpMenu.addChild(radiatorMenuItem);
                helpMenu.addChild(toolsMenuItem);
                helpMenu.addChild(aboutMenuItem);

                return helpMenu;
            };

            ready(function() {
                var containerNode = dom.byId("container");
                var headerContent = dom.byId("headerMainMenuContent");
                var notificationNode = dom.byId("notificationContainerNode");

                var helpMenu = createHelpMenu();
                var userMenu = createUserMenu();

                var navigation = new MenuBar({openOnHover: true});

                var mainMenu = new SuperMenu({});
                var userIcon = '<div class="resource-button user-icon"></div>';
                var header = new Header({
                    primaryTitle : '<a href="${ah3:escapeJs(projectsUrl)}">${ah3:escapeJs(ub:i18n("ProductName"))}</a>',
                    help: helpMenu,
                    user: {
                        messageName: userIcon + "${fn:escapeXml(displayName)}",
                        displayName: "${fn:escapeXml(displayName)}",
                        actions: userMenu
                    },
                    navigation: navigation
                }, containerNode);

            });
        });
      </script>

      <%-- flush header section to browser so it can start getting css and js resources  --%>
      <div class="tabManager topLevelTabs" id="topLevelTabs">
        <ul>
          <ucf:link label="${ub:i18n('Projects')}" href="${projectsUrl}" enabled="${!param.disabled}" klass="${dashboardClass} tab"/>
          <ucf:link label="${ub:i18n('CurrentActivity')}" href="${currentActivityUrl}" enabled="${!param.disabled}" klass="${currentActivityClass} tab"/>
          <ucf:link label="${ub:i18n('Search')}" href="${searchUrl}" enabled="${!param.disabled}" klass="${searchClass} tab"/>
          <c:if test="${showReportingTab}">
            <ucf:link label="${ub:i18n('Reporting')}" href="${reportingUrl}" enabled="${!param.disabled}" klass="${reportingClass} tab"/>
          </c:if>
          <c:if test="${showCodestationTab}">
            <ucf:link label="${ub:i18n('CodeStation')}" href="${codestationUrl}" enabled="${!param.disabled}" klass="${codestationClass} tab"/>
          </c:if>
          <c:if test="${showConfigurationTab}">
            <ucf:link label="${ub:i18n('Templates')}" href="${templatesUrl}" enabled="${!param.disabled}" klass="${templatesClass} tab"/>
          </c:if>
          <c:if test="${showTeamsTab}">
            <ucf:link label="${ub:i18n('Teams')}" href="${teamsUrl}" enabled="${!param.disabled}" klass="${teamsClass} tab"/>
          </c:if>
          <c:if test="${showAgentsTab}">
            <ucf:link label="${ub:i18n('Agents')}" href="${agentsUrl}" enabled="${!param.disabled}" klass="${agentsClass} tab"/>
          </c:if>
          <c:if test="${showSystemTab}">
            <ucf:link label="${ub:i18n('System')}" href="${systemUrl}" enabled="${!param.disabled}" klass="${systemClass} tab"/>
          </c:if>
        </ul>
      </div>
      <c:set var="breadCrumbKey" value="${WebConstants.BREAD_CRUMB}"/>
      <c:set var="breadCrumbTrail" value="${requestScope[breadCrumbKey]}"/>
      <div class="breadcrumbs">
        <c:if test="${location-id != null and not empty breadCrumbTrail}">
          <c:forEach items="${breadCrumbTrail}" var="crumb" varStatus="status">
            <c:if test="${!status.first}">&gt;</c:if>
            <c:choose>
              <c:when test="${not param.disabled and not empty crumb.url}">
                <c:url var="crumbUrl" value="${crumb.url}"/>
                <a href="${fn:escapeXml(crumbUrl)}">${fn:escapeXml(crumb.text)}</a>
              </c:when>
              <c:otherwise>
                <a>${fn:escapeXml(crumb.text)}</a>
              </c:otherwise>
            </c:choose>
          </c:forEach>
        </c:if>
      </div>
    </div>
    <div id="content">
    <c:if test="${!empty lastLoginMessage}">
      <script type="text/javascript">
        /* <![CDATA[ */
        var lastLoginMessage = '${ah3:escapeJs(lastLoginMessage)}';

        document.observe("dom:loaded", function() { // no need to put in the header, no JS i18n used
          var tabHolder = $$('.tabManager')[0];
          if (tabHolder) {
            var lastLoginMessageHtml = '<div style="width: 85%; margin-left: auto; margin-right: auto;" ' +
                ' class="announcement-high">' + lastLoginMessage + '</div>';
            tabHolder.insert({ after : lastLoginMessageHtml });
          }
        });
        /* ]]> */
      </script>
      <c:remove var="lastLoginMessage"/>
    </c:if>

    <jsp:include page="announcements.jsp" >
      <jsp:param name="hideAnnouncements" value="${param.hideAnnouncements}"/>
    </jsp:include>
