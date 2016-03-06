<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>
<%@page import="com.urbancode.ubuild.web.admin.SystemTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.announcements.AnnouncementTasks"%>
<%@page import="com.urbancode.ubuild.domain.announcements.Announcement"%>
<%@page import="com.urbancode.ubuild.domain.announcements.AnnouncementFactory"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="error" uri="error" %>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="java.util.Date"%>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.announcements.AnnouncementTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="newUrl"            value='${AnnouncementTasks.newAnnouncement}'/>
<c:url var="doneUrl"        value="${SystemTasks.viewIndex}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemAnnouncements')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="hideAnnouncements" value="true" />
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('Announcements')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("AnnouncementsSystemHelpBox")}</div>
        <c:if test="${!empty errorMessage}">
            <br />
            <div class="error">
                <c:out value="${errorMessage}"/>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
        <br />

        <div class="data-table_container">
            <table class="data-table" style="table-layout: auto;">
              <tbody>
                <tr>
                  <th scope="col" align="left" width="15%">${ub:i18n("Date")}</th>
                  <th scope="col" align="left">${ub:i18n("Announcement")}</th>
                  <th scope="col" align="center" width="10%">${ub:i18n("Actions")}</th>
                </tr>
                    <%
                        EvenOdd eo = new EvenOdd();
                        Announcement[] announcements = AnnouncementFactory.getInstance().restoreAll();
                        pageContext.setAttribute("announcements", announcements);
                    %>
                    <c:if test="${fn:length(announcements) == 0}">
                        <tr class="<%= eo.getNext() %>">
                            <td colspan="3">${ub:i18n("AnnouncementsNoneExistMessage")}</td>
                        </tr>
                    </c:if>
                    <c:forEach var="announcement" items="${announcements}">
                        <c:set var="priority" scope="page" value="${announcement.priority.name}"/>
                        <c:url var="editUrl" value='${AnnouncementTasks.editAnnouncement}'>
                            <c:param name="<%= WebConstants.ANNOUNCEMENT_ID %>" value="${announcement.id}"/>
                        </c:url>
                        <c:url var="deleteUrl" value='${AnnouncementTasks.deleteAnnouncement}'>
                            <c:param name="<%= WebConstants.ANNOUNCEMENT_ID %>" value="${announcement.id}"/>
                        </c:url>

                        <tr class="<%= eo.getNext() %>">
                            <td width="15%" nowrap="nowrap" align="left">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, announcement.createdTime))}</td>
                            <td class="announcement-text-${fn:toLowerCase(priority)}">${announcement.message}</td>
                            <td width="10%" nowrap="nowrap" align="center">
                                <c:url var="iconEdit" value="/images/icon_pencil_edit.gif"/>
                                <c:url var="iconDelete" value="/images/icon_delete.gif"/>

                                <ucf:link href="${editUrl}" label="${ub:i18n('Edit')}" img="${iconEdit}"/>&nbsp;
                                <ucf:deletelink href="${deleteUrl}" label="${ub:i18n('Delete')}" name="${ub:i18n('ThisAnnouncement')}" img="${iconDelete}"/>&nbsp;
                            </td>
                        </tr>
                        <c:remove var="priority" scope="page" />
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <br />

        <ucf:button href="${newUrl}" name="new" label="${ub:i18n('New')}" />
        <ucf:button href="${doneUrl}" name="done" label="${ub:i18n('Done')}" />

        <br />
        <br />

        </div>
    </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>