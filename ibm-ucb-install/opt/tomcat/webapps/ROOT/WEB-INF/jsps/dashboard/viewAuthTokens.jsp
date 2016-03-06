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
<%@ page import="com.urbancode.ubuild.web.dashboard.UserProfileTasks"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.UserProfileTasks" />

<c:url var="saveAuthTokenUrl" value="${UserProfileTasks.saveAuthToken}">
  <c:param name="userId" value="${user.id}"/>
</c:url>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('YourProfileAuthTokens')}" />
  <jsp:param name="selected" value="User Profile" />
</jsp:include>

<div style="padding-bottom: 1em;">
  <c:import url="/WEB-INF/jsps/dashboard/profileSubTabs.jsp">
    <c:param name="selected" value="authTokens"/>
  </c:import>

  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("DashboardViewAuthTokensHelp")}
    </div>
    <br/>
    <form method="post" action="${fn:escapeXml(saveAuthTokenUrl)}">
      <table border="0">
        <tbody>
          <c:set var="cancelUrl" value="${UserProfileTasks.viewAuthTokens}" scope="request"/>
          <c:set var="addAuthTokenUrl" value="${UserProfileTasks.addAuthToken}" scope="request"/>
          <c:set var="removeAuthTokenUrl" value="${UserProfileTasks.removeAuthToken}" scope="request"/>
          <c:import url="/WEB-INF/jsps/admin/security/authTokens.jsp"/>
        </tbody>
      </table>
    </form>
  </div>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
