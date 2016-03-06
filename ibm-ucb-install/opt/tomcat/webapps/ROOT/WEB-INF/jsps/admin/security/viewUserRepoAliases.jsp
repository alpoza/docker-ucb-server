<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.UserTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="saveUsrRepoUrl" value="${UserTasks.addUserRepoName}">
  <c:param name="${WebConstants.USER_ID}" value="${user.id}"/>
</c:url>
<c:url var="cancelUrl" value="${UserTasks.viewUserRepoAliases}">
  <c:param name="${WebConstants.USER_ID}" value="${user.id}"/>
</c:url>
<c:url var="addUsrRepoUrl" value="${UserTasks.addUserRepo}">
  <c:param name="${WebConstants.USER_ID}" value="${user.id}"/>
</c:url>

<c:set var="disableButtons" value="${user != null && fn:escapeXml(mode) == 'edit'}"/>

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('UsersRepositoryAliases')}"/>
    <c:param name="selected" value="teams"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<div style="padding-bottom: 1em;">

  <c:import url="userSubTabs.jsp">
    <c:param name="selected" value="repoAliases"/>
  </c:import>

  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("UsersRepoSystemHelpBox")}
    </div>
    <br/>
    <c:import url="userAliases.jsp">
      <c:param name="saveUsrRepoUrl" value="${saveUsrRepoUrl}"/>
      <c:param name="cancelUrl" value="${cancelUrl}"/>
      <c:param name="addUsrRepoUrl" value="${addUsrRepoUrl}"/>
      <c:param name="removeUsrRepoNameUrl" value="${UserTasks.removeUserRepoName}"/>
    </c:import>
    <br/>
  </div>
</div>
    
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
