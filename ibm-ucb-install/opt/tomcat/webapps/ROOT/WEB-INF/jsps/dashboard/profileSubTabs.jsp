<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.UserProfileTasks" />

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'general'}">
    <c:set var="currentUserClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'subscriptions'}">
    <c:set var="subscriptionsClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'views'}">
    <c:set var="viewsClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'announcements'}">
    <c:set var="announcementsClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'repoAliases'}">
    <c:set var="repoAliasesClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'authTokens'}">
    <c:set var="authTokensClass" value="selected"/>
  </c:when>
</c:choose>

<div class="tabManager" id="secondLevelTabs">
  <c:url var="currentUserUrl" value="${UserProfileTasks.viewCurrentUser}"/>
  <c:url var="subscriptionsUrl" value="${UserProfileTasks.viewSubscriptions}"/>
  <c:url var="manageViewsUrl" value="${UserProfileTasks.manageUserViews}"/>
  <c:url var="announcementsUrl" value="${UserProfileTasks.viewAnnouncements}"/>
  <c:url var="viewRepoAliasesUrl" value="${UserProfileTasks.viewRepoAliases}"/>
  <c:url var="viewAuthTokensUrl" value="${UserProfileTasks.viewAuthTokens}"/>
  <ucf:link href="${currentUserUrl}" label="${ub:i18n('General')}" klass="${fn:escapeXml(currentUserClass)} tab"/>
  <ucf:link href="${subscriptionsUrl}" label="${ub:i18n('Subscriptions')}" klass="${fn:escapeXml(subscriptionsClass)} tab"/>
  <ucf:link href="${manageViewsUrl}" label="${ub:i18n('Views')}" klass="${fn:escapeXml(viewsClass)} tab"/>
  <ucf:link href="${announcementsUrl}" label="${ub:i18n('Announcements')}" klass="${fn:escapeXml(announcementsClass)} tab"/>
  <ucf:link href="${viewRepoAliasesUrl}" label="${ub:i18n('RepositoryAliases')}" klass="${fn:escapeXml(repoAliasesClass)} tab"/>
  <ucf:link href="${viewAuthTokensUrl}" label="${ub:i18n('AuthTokens')}" klass="${fn:escapeXml(authTokensClass)} tab"/>
</div>
