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
<%@page import="com.urbancode.security.Action" %>
<%@page import="com.urbancode.security.ResourceForTeam" %>
<%@page import="com.urbancode.security.Role" %>
<%@page import="com.urbancode.security.SecurityConfiguration" %>
<%@page import="com.urbancode.security.SecurityResource" %>
<%@page import="com.urbancode.security.SecurityResourceRole" %>
<%@page import="com.urbancode.security.TeamSpace" %>
<%@page import="com.urbancode.security.SecurityUser" %>
<%@page import="java.util.List" %>
<%@ page import="com.urbancode.air.i18n.TranslateMessage" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub" uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<jsp:useBean id="eo" class="com.urbancode.ubuild.web.util.EvenOdd"/>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<%
SecurityResource resource = (SecurityResource) pageContext.findAttribute(WebConstants.RESOURCE);
%>
<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("ResourceSecurity")}</a></li>
  </ul>
</div>

<div class="contents">
  <div style="float: right;">
    <ucf:button name="Close" label="${ub:i18n('Close')}" onclick="parent.hidePopup(); return false;"/>
  </div>
  <c:set var="popupTitle" value="${fn:escapeXml(ub:i18n(resource.resourceType.name))}|${fn:escapeXml(resource.name)}"/>
  <div style="font-size: 20px; margin: 10px 5px;">${fn:escapeXml(ub:i18nMessage('SecurityPopupTitle', popupTitle))}</div>
  <hr size="1"/>
  <c:forEach var="teamSpace" items="${resource.teamSpaces}">
    <%
    TeamSpace teamSpace = (TeamSpace) pageContext.findAttribute(WebConstants.TEAM_SPACE);
    pageContext.setAttribute("resourceForTeams",
        SecurityConfiguration.getResourceFactory().getAllResourcesForTeamByResource(teamSpace, resource));
    %>
    <div class="team_title">${ub:i18n("TeamWithColon")}&nbsp;${fn:escapeXml(ub:i18n(teamSpace.name))}</div>
    <c:forEach var="action" items="${resource.resourceType.actions}">
      <%
      Action action = (Action) pageContext.getAttribute(WebConstants.ACTION);
      %>
      <div class="panel_1">
        <p class="role_title">${ub:i18n("ActionWithColon")}&nbsp;${fn:escapeXml(ub:i18n(action.name))}</p><br/>
        <c:forEach var="role" items="${teamSpace.roles}">
          <%
          Role role = (Role) pageContext.getAttribute(WebConstants.ROLE);
          pageContext.setAttribute("roleHasAction", Boolean.FALSE);
          %>
          <c:forEach var="resourceForTeam" items="${resourceForTeams}">
            <%
            ResourceForTeam resourceForTeam = (ResourceForTeam) pageContext.findAttribute("resourceForTeam");
            SecurityResourceRole resourceRole = resourceForTeam.getResourceRole();
            if (role.hasAction(action, resourceRole) || role.hasAction(action, null)) {
                pageContext.setAttribute("roleHasAction", Boolean.TRUE);
                break;
            }
            %>
          </c:forEach>
          <c:if test="${roleHasAction}">
            <div class="panel_2 wrapped">
                <%
                List<SecurityUser> users = teamSpace.getUsersInRole(role);
                String allUserName = "";
                for (int i = 0; i < users.size(); i++) {
                    if (i != 0) {
                        allUserName += ", ";
                    }
                    allUserName += users.get(i).getName();
                }
                String params = TranslateMessage.translate(role.getName()) + "|" + TranslateMessage.translate(action.getName()) + "|" + allUserName;
                pageContext.setAttribute("params", params);
                %>
                ${ub:i18nMessage("GrantActionToUser", params)}
            </div>
          </c:if>
        </c:forEach>
      </div>
    </c:forEach>
    <hr size="1"/>
  </c:forEach>
  <div style="float: right;">
    <ucf:button name="Close" label="${ub:i18n('Close')}" onclick="parent.hidePopup(); return false;"/>
  </div>
  <br/><br/>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
