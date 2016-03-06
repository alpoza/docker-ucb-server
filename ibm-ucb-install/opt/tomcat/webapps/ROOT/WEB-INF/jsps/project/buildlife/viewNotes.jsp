<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page import="com.urbancode.ubuild.dashboard.StampSummary"%>
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLifeStamp"%>
<%@ page import="com.urbancode.ubuild.domain.project.Project"%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@ page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.*" %>
<%@ page import="com.urbancode.ubuild.web.project.BuildLifeTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="java.util.Date" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="project" value="${buildLife.profile.project}"/>
<%
   Project project = (Project) pageContext.findAttribute("project");
   pageContext.setAttribute("hasWrite", Boolean.valueOf(Authority.getInstance().hasPermission(project, UBuildAction.PROJECT_VIEW)));
%>

<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
  <c:param name="projectId" value="${project.id}"/>
</c:url>

<c:url var="addNoteUrl" value="${BuildLifeTasks.addNote}">
  <c:param name="buildLifeId" value="${buildLife.id}"/>
</c:url>


<%-- CONTENT --%>

<c:import url="buildLifeHeader.jsp">
    <c:param name="selected" value="notes"/>
</c:import>

<br/>
<table class="data-table">
    <tr>
        <th style="text-align: left;">${ub:i18n("Note")}</th>
        <th width="15%">${ub:i18n("User")}</th>
        <th width="15%">${ub:i18n("Date")}</th>
    </tr>
  <c:if test="${fn:length(buildLife.notes)==0}">
      <tr><td colspan="3" align="left">${ub:i18n('NoNotesOnBuildLife')}</td></tr>
  </c:if>
  <c:forEach var="note" items="${buildLife.notes}" varStatus="status">
    <tr>
        <td style="text-align: left;">${fn:escapeXml(note.content)}</td>
        <td style="white-space: nowrap; text-align: center;">${fn:escapeXml(note.author.name)}</td>
        <td style="white-space: nowrap; text-align: center;">
           ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, note.creationDate))}
        </td>
    </tr>
  </c:forEach>
</table>

<c:if test="${hasWrite}">
<br/>
<ucf:button name="addNote" submit="${false}" onclick="showPopup('${addNoteUrl}'); return false;" label="${ub:i18n('AddNote')}"/>
</c:if>

<c:import url="buildLifeFooter.jsp"/>
