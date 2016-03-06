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

<c:url var="submitUrl" value="${UserProfileTasks.saveUserViews}"/>
<c:url var="editUrl" value="${UserProfileTasks.editUserViews}"/>
<c:url var="doneUrl" value="${DashboardTasks.viewDashboard}"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('YourProfileViews')}" />
  <jsp:param name="selected" value="User Profile" />
</jsp:include>

<div style="padding-bottom: 1em;">

  <c:import url="/WEB-INF/jsps/dashboard/profileSubTabs.jsp">
    <c:param name="selected" value="views"/>
  </c:import>

  <div class="contents">
    <form method="post" action="${fn:escapeXml(submitUrl)}">
    <div id="userForm">
      <c:if test="${msg!=null}">
        <div>
          <span style="color:#0000AA;font-weight:bold;"><c:out value="${msg}"/></span>
        </div>
      </c:if>

      <div class="system-helpbox">
        ${ub:i18n("ManageUserViewsHelp")}
      </div>
      <br />

      <table class="property-table">
        <tbody>
          <tr class="even" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsViewMain")}</span></td>

            <td align="left" width="20%">
              <ucf:yesOrNo name="mainVisibility"
                value="${user.dashboardGraphVisibility}"
                enabled="${allowUserMgmt && inEditMode}"/>
               </td>
            <td align="left">
               <span class="inlinehelp">${ub:i18n("SettingsViewMainDesc")}</span>
               </td>
          </tr>

          <tr class="even" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsViewProject")}</span></td>

            <td align="left" width="20%">
              <ucf:yesOrNo name="projectVisibility"
                value="${user.dashboardProjectGraphVisibility}"
                enabled="${allowUserMgmt && inEditMode}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ManageUserViewsProjectDashboardGraphsDesc")}</span>
            </td>
          </tr>


          <tr class="even" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsViewWorkflow")}</span></td>

            <td align="left" width="20%">
              <ucf:yesOrNo name="workflowVisibility"
                value="${user.dashboardWorkflowGraphVisibility}"
                enabled="${allowUserMgmt && inEditMode}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ManageUserViewsProcessDashboardGraphsDesc")}</span>
            </td>
          </tr>

          <tr class="odd">
            <td colspan="3">
              <c:choose>
                <c:when test="${inEditMode}">
                  <ucf:button name="save-user"  label="${ub:i18n('Save')}"/>
                  <c:url var="manageUserViewsUrl" value="${UserProfileTasks.manageUserViews}"/>
                  <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${manageUserViewsUrl}"/>
                </c:when>
                <c:otherwise>
                  <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
                  <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    </form>
  </div>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
