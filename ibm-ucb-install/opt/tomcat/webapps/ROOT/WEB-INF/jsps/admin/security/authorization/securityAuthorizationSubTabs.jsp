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
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" />

<div class="tabManager" id="secondLevelTabs">
  <c:url var="authorizationUrl" value="${AuthorizationRealmTasks.viewList}"/>
  <ucf:link href="${authorizationUrl}" label="${ub:i18n('Authorization')}" enabled="${false}" klass="selected tab"/>
</div>
