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
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="error" uri="error" %>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.urbancode.ubuild.web.admin.announcements.AnnouncementTasks"%>
<%@page import="com.urbancode.ubuild.domain.announcements.Priority"%>
<%@page import="com.urbancode.ubuild.domain.announcements.Announcement"%>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.announcements.AnnouncementTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
    EvenOdd eo = new EvenOdd();
    eo.getNext();

    ArrayList priorities = new ArrayList(Arrays.asList(Priority.getAll()));
    pageContext.setAttribute("priorities", priorities);
%>

<c:url var="saveUrl" value='${AnnouncementTasks.saveAnnouncement}'/>
<c:url var="cancelUrl" value='${AnnouncementTasks.cancelAnnouncement}'/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemAnnouncements')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="hideAnnouncements" value="true" />
</jsp:include>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('Announcements')}" href="" enabled="${false}" klass="selected tab" />
  </div>
  <div class="contents">
    <div class="system-helpbox">${ub:i18n("AnnouncementsSystemHelpBox")}</div>
    <br />
    <div align="right">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>

    <form method="post" name="announcement-form" action="${fn:escapeXml(saveUrl)}">
      <table class="property-table">
        <tbody>
          <c:set var="fieldName" value="announcementMessage" />
          <c:set var="messageValue" value="${param[fieldName] != null ? param[fieldName] : announcement.message}" />
          <error:field-error field="announcementMessage" />
          <tr class="<%= eo.getLast() %>">
            <td align="left" width="20%"><span class="bold">${ub:i18n("MessageWithColon")} <span
                class="required-text">*</span></span></td>
            <td align="left"><ucf:textarea name="announcementMessage" cols="60" rows="3" value="${messageValue}" />
            </td>
            <td align="left"><span class="inlinehelp">${ub:i18n("AnnouncementsMessageDesc")}</span></td>
          </tr>

          <c:set var="fieldName" value="announcementPriority" />
          <c:set var="priorityValue" value="${param[fieldName] != null ? param[fieldName] : announcement.priority.id}" />
          <error:field-error field="announcementPriority" cssClass="<%= eo.getNext() %>" />
          <tr class="<%= eo.getLast() %>">
            <td align="left" width="20%"><span class="bold">${ub:i18n("PriorityWithColon")} <span
                class="required-text">*</span></span></td>
            <td align="left"><ucf:idSelector name="announcementPriority" list="${priorities}"
                selectedId="${priorityValue}"/></td>
            <td align="left"><span class="inlinehelp">${ub:i18n("AnnouncementsPriorityDesc")}</span></td>
          </tr>
        </tbody>
      </table>
      <ucf:button name="save" label="${ub:i18n('Save')}" onclick="this.form.submit();" />
      <ucf:button href="${cancelUrl}" name="cancel" label="${ub:i18n('Cancel')}" />
    </form>

    <br /> <br /> <br />

  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
