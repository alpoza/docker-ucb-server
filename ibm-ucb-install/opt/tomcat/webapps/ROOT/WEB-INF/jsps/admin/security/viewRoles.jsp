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
<%@page import="com.urbancode.ubuild.web.admin.security.RoleTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub" uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.RoleTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:set var="disableButtons" value="${role != null || roleMapping != null}"/>

<c:set var="onDocumentLoad" scope="request">
/* <![CDATA[ */
require(["ubuild/security/role/RoleManager"], function(RoleManager) {
    var roleManager = new RoleManager();

    var roleId = "${roleId}";
    if (roleId) {
      var role;
      dojo.forEach(roleManager.entries, function(entry) {
        if (roleId === entry.id) {
          role = entry;
        }
      });
      roleManager.selectedEntry = role;
      roleManager.placeAt("roleManager");
    }
    else {
      roleManager.placeAt("roleManager");
    }
});
/* ]]> */
</c:set>
<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title"    value="${ub:i18n('SystemSecurityRoles')}"/>
  <c:param name="selected" value="system"/>
  <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <c:url var="rolesUrl" value="${RoleTasks.viewRoles}"/>
      <ucf:link href="${rolesUrl}" label="${ub:i18n('Roles')}" enabled="${false}" klass="selected tab"/>
    </div>
    
    <div class="contents"><br/>
        <div id="roleManager"></div>
        <c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
        <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
    </div>
    
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
