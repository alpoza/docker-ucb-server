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
<%@page import="com.urbancode.ubuild.domain.jobtrace.buildlife.BuildLifeJobTrace" %>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@page import="com.urbancode.ubuild.domain.security.SystemFunction"%>
<%@page import="com.urbancode.commons.util.Duration" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:set var="project" value="${jobTrace.buildProfile.project}"/>

<%
    BuildLifeJobTrace jobTrace = (BuildLifeJobTrace) pageContext.findAttribute(WebConstants.JOB_TRACE);

    boolean showJobConfigLink = false;
    if (jobTrace.getJobConfig() == null) {
        showJobConfigLink = false;
    }
    else {
        showJobConfigLink = Authority.getInstance().hasPermission(jobTrace.getJobConfig(), UBuildAction.JOB_EDIT);
    }
    pageContext.setAttribute("showLink", Boolean.valueOf(showJobConfigLink));
%>

<c:url var="plusImage" value="/images/plus.gif"/>
<c:url var="minusImage" value="/images/minus.gif"/>

<c:choose>
  <c:when test="${!showLink}">
  </c:when>
  <c:otherwise>
    <c:url var="jobConfigUrl" value="${LibraryJobConfigTasks.viewJobConfig}">
      <c:param name="jobConfigId" value="${jobTrace.jobConfig.id}"/>
    </c:url>
  </c:otherwise>
</c:choose>

<%-- CONTENT --%>
<c:import url="/WEB-INF/jsps/jobs/builds/jobHeader.jsp">
    <c:param name="selected" value="summary"/>
</c:import>

<c:if test="${jobTrace.status != null}">
  <c:set var="statusStyle" value="background-color: ${jobTrace.status.color};
    color: ${fn:escapeXml(jobTrace.status.secondaryColor)};"/>
</c:if>
<c:if test="${jobTrace.status == null}">
  <c:set var="statusStyle" value=""/>
</c:if>

<table style="width: 100%;">
    <tr valign="top">
        <td style="width:34%; padding: 10px;">
            <table class="property-table" style="width: 100%">
                <caption>
                  <c:set var="jobExecution" value="${fn:escapeXml(jobTrace.id)}|${fn:escapeXml(jobTrace.name)}"/>
                  ${ub:i18nMessage("JobExecutionTitle", jobExecution)}
                  &nbsp;
                  <c:if test="${!empty jobConfigUrl}">
                    <c:url var="glassUrl" value="/images/icon_magnifyglass.gif"/>
                    <ucf:link href="${jobConfigUrl}"
                              label="${ub:i18n('ShowJobConfiguration')}"
                              img="${glassUrl}"
                              enabled="${true}"
                              />
                  </c:if>
                </caption>
                <tr>
                    <td align="left" width="50%" nowrap="nowrap"><b>${ub:i18n("StatusWithColon")}</b></td>
                    <td align="left" style="${fn:escapeXml(statusStyle)}" width="50%">
                      <c:out value="${ub:i18n(jobTrace.status.name)}" default="${ub:i18n('None')}"/>
                    </td>
                </tr>
                <tr>
                    <td align="left" nowrap="nowrap"><b>${ub:i18n("StartDateWithColon")}</b></td>
                    <td align="left">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, jobTrace.startDate))}</td>
                </tr>
                <tr>
                    <td align="left" nowrap="nowrap"><b>${ub:i18n("DurationWithColon")}</b></td>
                    <td align="left"><%
                        if (jobTrace.getStartDate() != null) {
                        out.print(new Duration(jobTrace.getStartDate(), jobTrace.getEndDate()).getLeastUnit(true, false));
                        }
                        else {
                        out.print(" ");
                        }
                    %></td>
                </tr>
                <tr>
                    <td align="left" nowrap="nowrap"><b>${ub:i18n("LogWithColon")}</b></td>
                    <td align="left">
                      <c:set var="jobTrace" value="${jobTrace}" scope="request"/>
                      <c:import url="/WEB-INF/jsps/jobs/jobLogLink.jsp"/>
                    </td>
                </tr>
                <tr>
                    <td align="left" nowrap="nowrap"><b>${ub:i18n("AgentWithColon")}</b></td>
                    <td align="left">${fn:escapeXml(jobTrace.agent.name)}</td>
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

<jsp:include page="/WEB-INF/jsps/jobs/builds/jobFooter.jsp"/>
