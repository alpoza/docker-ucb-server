<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authentication.AuthenticationRealmTasks" />

<c:choose> <%-- Overwrite the default class for the selected tab --%>
    <c:when test="${param.selected == 'authentication'}">
        <c:set var="authenticationClass" value="selected"/>
    </c:when>
    <c:when test="${param.selected == 'secondaryAuthentication'}">
        <c:set var="secondaryAuthenticationClass" value="selected"/>
    </c:when>
</c:choose>

<div class="tabManager" id="secondLevelTabs">
  <c:url var="authenticationUrl" value="${AuthenticationRealmTasks.viewList}"/>
  <ucf:link href="${authenticationUrl}" label="${ub:i18n('Authentication')}" enabled="${false}"
    klass="${fn:escapeXml(authenticationClass)} tab"/>
  
  <%-- 
  <c:url var="secondaryAuthenticationUrl" value="${AuthenticationRealmTasks.viewSecondaryList}"/>
  <li class="${fn:escapeXml(secondaryAuthenticationClass)}"><ucf:link href="${secondaryAuthenticationUrl}"
    label="${ub:i18n('SecondaryAuthentication')}" enabled="${!param.disabled}"/></li>
  --%>
</div>
