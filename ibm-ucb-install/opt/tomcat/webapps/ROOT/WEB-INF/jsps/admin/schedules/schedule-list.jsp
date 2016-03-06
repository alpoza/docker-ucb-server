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
<%@page import="com.urbancode.ubuild.domain.schedule.Schedule" %>
<%@page import="com.urbancode.ubuild.web.admin.schedules.*" %>
<%@page import="com.urbancode.ubuild.web.dashboard.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="java.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<c:url var="imgUrl" value="/images"/>

<c:url var="refreshUrl" value="/images/icon_restart.gif"/>

<c:url var="newUrl"    value='<%=new ScheduleTasks().methodUrl("viewTypes", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="selected" value="system"/>
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('Schedules')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">
            ${ub:i18n("SchedulesSystemHelpBox")}
        </div>
        <br />
        <div>
            <ucf:button href="${newUrl}" name="CreateSchedule" label="${ub:i18n('CreateSchedule')}"/>
        </div>
        <br/>

        <error:field-error field="<%= ScheduleConstants.DELETE_FIELD %>"/>

        <div class="data-table_container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th scope="col">${ub:i18n("ScheduleName")}</th>
                        <th scope="col">${ub:i18n("Type")}</th>
                        <th scope="col">${ub:i18n("NextOccurrence")}</th>
                        <th scope="col">${ub:i18n("Description")}</th>
                        <th scope="col">${ub:i18n("Active")}</th>
                        <th scope="col" width="10%">${ub:i18n("Actions")}</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty scheduleList}">
                        <tr bgcolor="#ffffff">
                            <td colspan="5">
                                ${ub:i18n("SchedulesNoneConfiguredMessage")}
                            </td>
                        </tr>
                    </c:if>

                    <c:forEach var="schedule" items="${scheduleList}">
                        <c:if test="${schedule.id != null}">
                            <c:set var="nextOccurrence" value="${schedule.nextOccurrence}"/>
                            <c:url var="viewUrlId" value='<%=new ScheduleTasks().methodUrl("viewSchedule", false)%>'>
                                <c:param name="scheduleId" value="${schedule.id}"/>
                            </c:url>
                            <c:url var="activateSchedUrlIdx" value='<%=new ScheduleTasks().methodUrl("reactivateSchedule", false)%>'>
                                <c:param name="scheduleId" value="${schedule.id}"/>
                            </c:url>
                            <c:url var="deactivateSchedUrlIdx" value='<%=new ScheduleTasks().methodUrl("deactivateSchedule", false)%>'>
                                <c:param name="scheduleId" value="${schedule.id}"/>
                            </c:url>
                            <c:url var="deleteUrlId" value='<%=new ScheduleTasks().methodUrl("deleteSchedule", false)%>'>
                                <c:param name="scheduleId" value="${schedule.id}"/>
                            </c:url>
                            <%
                                Schedule schedule = (Schedule)pageContext.findAttribute("schedule");
                                String type = StringUtils.substringAfterLast(schedule.getClass().getName(),".");
                                pageContext.setAttribute("type", type);
                            %>
                            <tr bgcolor="#ffffff">
                                <td nowrap="nowrap">
                                    <ucf:link href="${viewUrlId}" label="${ub:i18n(schedule.name)}"/>
                                </td>
                                <td nowrap="nowrap" width="20%">${ub:i18n(type)}</td>
                                <td nowrap="nowrap">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, nextOccurrence))}</td>
                                <td style="white-space: pre">${fn:escapeXml(ub:i18n(schedule.description))}</td>
                                <td align="center" nowrap="nowrap" width="10%">
                                    <c:choose>
                                        <c:when test="${schedule.active}">
                                            ${ub:i18n("Yes")}
                                            &nbsp;<ucf:link href="${deactivateSchedUrlIdx}" img="${refreshUrl}" label="${ub:i18n('Inactivate')}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: red;">${ub:i18n("No")}</span>
                                            &nbsp;<ucf:link href="${activateSchedUrlIdx}" img="${refreshUrl}" label="${ub:i18n('Activate')}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td align="center" nowrap="nowrap">
                                    <ucf:link href="${viewUrlId}" label="${ub:i18n('View')}" img="${fn:escapeXml(imgUrl)}/icon_magnifyglass.gif"/> &nbsp;
                                    <ucf:deletelink href="${deleteUrlId}" name="${ub:i18n(schedule.name)}" label="${ub:i18n('Delete')}" img="${fn:escapeXml(imgUrl)}/icon_delete.gif"/>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>

            <br/>
            <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
