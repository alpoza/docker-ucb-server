<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.license.LicenseTasks" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.license.LicenseTasks" />

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'users'}">
    <c:set var="usersClass" value="selected"/>
  </c:when>
  <c:when test="${param.selected == 'usersOverTime'}">
    <c:set var="usersOverTimeClass" value="selected"/>
  </c:when>
</c:choose>
<c:url var="usersUrl" value='${LicenseTasks.viewUsers}'/>
<c:url var="usersOverTimeUrl" value='${LicenseTasks.viewUsersOverTime}'/>
<div class="tabManager" id="secondLevelTabs">
  <ucf:link href="${usersUrl}" label="${ub:i18n('LicenseCommitters')}" enabled="${!param.disabled}" klass="${usersClass} tab"/>
  <ucf:link href="${usersOverTimeUrl}" label="${ub:i18n('LicenseCommittersOverTime')}" enabled="${!param.disabled}" klass="${usersOverTimeClass} tab"/>
</div>
