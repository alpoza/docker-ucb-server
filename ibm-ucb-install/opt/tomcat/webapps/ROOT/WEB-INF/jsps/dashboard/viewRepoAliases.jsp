<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.admin.security.*"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.UserProfileTasks"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks"%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildUser" %>
<%@ page import="com.urbancode.ubuild.domain.security.SecurityHelper" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.UserProfileTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
  </c:otherwise>
</c:choose>

<%
    UBuildUser user = LoginTasks.getCurrentUser(request);
    pageContext.setAttribute("allowUserMgmt", new SecurityHelper().isUserManagementAllowed(user));
    pageContext.setAttribute("allowPassMgmt", new SecurityHelper().isPasswordChangeAllowed(user));
  request.setAttribute(WebConstants.USER, user);
%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('YourProfileRepositoryAliases')}" />
  <jsp:param name="selected" value="User Profile" />
</jsp:include>

<div style="padding-bottom: 1em;">
  <c:import url="/WEB-INF/jsps/dashboard/profileSubTabs.jsp">
    <c:param name="selected" value="repoAliases"/>
  </c:import>

  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("RepositoryAliasesHelp")}
    </div>
    <br/>
    <c:import url="/WEB-INF/jsps/admin/security/userAliases.jsp">
      <c:param name="saveUsrRepoUrl" value="${UserProfileTasks.saveUserRepoName}"/>
      <c:param name="cancelUrl" value="${UserProfileTasks.viewRepoAliases}"/>
      <c:param name="addUsrRepoUrl" value="${UserProfileTasks.addUserRepo}"/>
      <c:param name="removeUsrRepoNameUrl" value="${UserProfileTasks.removeUserRepoName}"/>
    </c:import>
  </div>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
