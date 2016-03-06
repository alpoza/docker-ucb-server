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
<%@page import="com.urbancode.ubuild.domain.jobtrace.*" %>
<%@page import="com.urbancode.ubuild.domain.jobtrace.vanilla.VanillaJobTrace"%>
<%@page import="com.urbancode.ubuild.domain.buildrequest.BuildRequest"%>
<%@page import="com.urbancode.commons.util.Duration" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.services.jobs.JobStatusEnum" %>
<%@page import="com.urbancode.ubuild.services.logging.*" %>
<%@page import="java.io.File" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />

<c:set var="project" value="${jobTrace.project}"/>

<c:url var="dashboardUrl" value="${DashboardTasks.viewDashboard}"/>

<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
  <c:param name="projectId" value="${project.id}"/>
</c:url>

<c:url var="summaryUrl" value="${JobTasks.viewJobTrace}">
  <c:param name="job_trace_id" value="${jobTrace.id}"/>
</c:url>

<c:url var="abortUrl" value="${JobTasks.abortBuildRequest}">
  <c:param name="job_trace_id" value="${jobTrace.id}"/>
</c:url>

<c:url var="plusImage" value="/images/plus.gif"/>
<c:url var="minusImage" value="/images/minus.gif"/>
<%
    JobTrace jobTrace = (JobTrace) pageContext.findAttribute(WebConstants.JOB_TRACE);
    if (JobStatusEnum.RUNNING.equals(jobTrace.getStatus()) ||
        JobStatusEnum.QUEUED.equals(jobTrace.getStatus()) ||
        JobStatusEnum.WAITING_ON_AGENTS.equals(jobTrace.getStatus()) ||
        JobStatusEnum.ABORTING.equals(jobTrace.getStatus()) ||
        JobStatusEnum.RESUMING.equals(jobTrace.getStatus())) {
        pageContext.setAttribute("showRefresh", true);
    }
    else {
        pageContext.setAttribute("showRefresh", false);
    }
%>

<%-- CONTENT --%>
<c:if test="${showRefresh}">
  <c:import var="refreshJs" url="/WEB-INF/snippets/refreshJs.jsp">
    <c:param name="refresh" value="30" />
    <c:param name="refreshDefault" value="true" />
    <c:param name="sessionKey" value="jobtrace-refresh" />
  </c:import>
</c:if>
<c:set var="onDocumentLoad" value="${refreshJs}" scope="request"/>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="JobTrace" />
  <jsp:param name="selected" value="projects" />
</jsp:include>

<div style="">

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('Summary')}" href="${summaryUrl}" enabled="${false}" klass="selected tab"/>
</div>

<c:if test="${showRefresh}">
  <div style="float: right; position: relative; text-align: right;">
    <br/>
    <c:import url="/WEB-INF/snippets/refresh.jsp"/>
  </div>
</c:if>

<div class="contents">
    <%
    if (jobTrace instanceof VanillaJobTrace) {
        VanillaJobTrace trace = (VanillaJobTrace) jobTrace;

        if (trace.getRequester() instanceof BuildRequest) {
            if (!trace.getStatus().isDone()) {
                pageContext.setAttribute("fromBuildRequest", true);
            }
        }
    }
    %>

    <c:if test="${jobTrace.status != null}">
      <c:set var="statusStyle" value="background-color: ${jobTrace.status.color};
        color: ${fn:escapeXml(jobTrace.status.secondaryColor)};"/>
    </c:if>

    <table style="width: 100%;">
        <tr valign="top">
            <td style="width:34%; padding: 10px;">
                <table class="property-table" style="width: 100%">
                    <caption>Job ${fn:escapeXml(jobTrace.id)}</caption>
                    <tr>
                        <td align="left" width="50%" nowrap="nowrap"><b>${ub:i18n("StatusWithColon")}</b></td>
                        <td align="left" style="${fn:escapeXml(statusStyle)}" width="50%">
                          <c:out value="${jobTrace.status.name}" default="${ub:i18n('None')}"/>
                          <c:if test="${fromBuildRequest}">
                            <a href="${fn:escapeXml(abortUrl)}">${ub:i18n("AbortLowercaseInParentheses")}</a>
                          </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" nowrap="nowrap"><b>${ub:i18n("ProjectWithColon")}</b></td>
                        <td align="left"><a href="${fn:escapeXml(projectUrl)}">${fn:escapeXml(project.name)}</a></td>
                    </tr>
                    <tr>
                        <td align="left" nowrap="nowrap"><b>${ub:i18n("StartDateWithColon")}</b></td>
                        <td align="left">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, jobTrace.startDate))}</td>
                    </tr>
                    <tr>
                        <td align="left" nowrap="nowrap"><b>${ub:i18n("DurationWithColon")}</b></td>
                        <td align="left"><c:out value="${jobTrace.duration}" default=""/></td>
                    </tr>
                    <tr>
                        <td align="left" nowrap="nowrap"><b>${ub:i18n("RequestType")}</b></td>
                        <td align="left"><c:out value="${jobTrace.requesterType}"/></td>
                    </tr>
                    <tr>
                        <td align="left" nowrap="nowrap"><b>${ub:i18n("RequesterWithColon")}</b></td>
                        <td align="left"><c:out value="${jobTrace.requester.name}" default="${ub:i18n('N/A')}"/></td>
                    </tr>
                    <tr>
                        <td align="left" nowrap="nowrap"><b>${ub:i18n("AgentWithColon")}</b></td>
                        <td align="left"><c:out value="${jobTrace.agent.name}" default="${ub:i18n('None')}"/></td>
                    </tr>
                    <tr>
                        <td align="left" nowrap="nowrap"><b>${ub:i18n("LogWithColon")}</b></td>
                        <td align="left">
                          <c:set var="jobTrace" value="${jobTrace}" scope="request"/>
                          <c:import url="/WEB-INF/jsps/jobs/jobLogLink.jsp"/>
                        </td>
                    </tr>
                </table>
            </td>
            <td style="width:66%; padding: 10px;">
              <c:import url="/WEB-INF/jsps/jobs/jobProperties.jsp"/>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="padding: 10px;">
                <c:import url="/WEB-INF/jsps/jobs/jobTraceTable.jsp"/>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="padding: 10px;">
                <c:import url="/WEB-INF/jsps/jobs/errors.jsp"/>
            </td>
        </tr>
    </table>

</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
