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

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.UserTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'settings'}">
    <c:set var="currentUserClass" value="selected"/>
  </c:when>
</c:choose>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link href="#" label="${ub:i18n('ImportUser')}" enabled="${false}" klass="${fn:escapeXml(currentUserClass)} tab"/>
</div>