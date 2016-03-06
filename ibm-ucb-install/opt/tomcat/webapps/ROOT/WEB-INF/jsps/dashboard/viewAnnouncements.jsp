<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="com.urbancode.ubuild.web.admin.security.*"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error"%>

<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildUser"%>
<%@page import="com.urbancode.ubuild.domain.announcements.UserAnnouncement"%>
<%@page import="com.urbancode.ubuild.domain.announcements.UserAnnouncementFactory"%>
<%@page import="com.urbancode.ubuild.web.dashboard.UserAnnouncementTasks"%>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%
    EvenOdd eo = new EvenOdd();
    eo.getNext();

    UBuildUser currentUser = (UBuildUser)session.getAttribute(LoginTasks.KEY_CURRENT_USER);
    UserAnnouncement[] userAnnouncements = UserAnnouncementFactory.getInstance().restoreAllForUser(currentUser);
  pageContext.setAttribute("userAnnouncements", userAnnouncements);
%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="title" value="${ub:i18n('YourAnnouncements')}" />
    <jsp:param name="selected" value="User Profile" />
  <jsp:param name="hideAnnouncements" value="true" />
</jsp:include>

<div style="padding-bottom: 1em;">

  <c:import url="/WEB-INF/jsps/dashboard/profileSubTabs.jsp">
    <c:param name="selected" value="announcements"/>
  </c:import>

    <div class="contents">
        <div class="system-helpbox">
          ${ub:i18n("YourAnnouncementsHelp")}
        </div>
        <br/>
        <div id="announcementForm">
            <c:if test="${msg!=null}">
                <div>
                    <span style="color: #0000AA; font-weight: bold;">
                        <c:out value="${msg}" />
                    </span>
                </div>
            </c:if>
            <br />
            
            <div class="data-table_container">
            <table class="data-table">
              <tbody>
                <tr>
                  <th scope="col" align="left" width="15%">${ub:i18n("Created")}</th>
                  <th scope="col" align="left">${ub:i18n("Message")}</th>
                </tr>
                <c:if test="${fn:length(userAnnouncements) == 0}">
                    <tr class="<%= eo.getNext() %>">
                        <td colspan="2">${ub:i18n("NoAnnouncements")}</td>
                    </tr>
                </c:if>
                <c:forEach var="userAnnouncement" items="${userAnnouncements}">
                    <c:set var="priority" scope="page" value="${userAnnouncement.announcement.priority.name}"/>

                    <tr class="<%= eo.getNext() %>">
                        <td nowrap="nowrap">
                            ${fn:escapeXml(ah3:formatDate(longDateTimeFormat, userAnnouncement.announcement.createdTime))}
                        </td>
                        <td class="announcement-text-${fn:toLowerCase(priority)}" width="100%">
                            ${fn:escapeXml(userAnnouncement.announcement.message)}
                        </td>
                    </tr>
                    <c:remove var="priority" scope="page" />
                </c:forEach>
              </tbody>
            </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp" />
