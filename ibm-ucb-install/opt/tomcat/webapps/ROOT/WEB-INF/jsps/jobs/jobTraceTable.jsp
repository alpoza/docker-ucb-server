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
<%@page import="com.urbancode.ubuild.domain.buildrequest.BuildRequest" %>
<%@page import="com.urbancode.ubuild.domain.jobtrace.JobTrace" %>
<%@page import="com.urbancode.ubuild.domain.jobtrace.StepTrace" %>
<%@page import="com.urbancode.ubuild.domain.jobtrace.WorkflowDefinitionJobTrace"%>
<%@page import="com.urbancode.ubuild.domain.jobtrace.buildlife.BuildLifeJobTrace"%>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@page import="com.urbancode.ubuild.domain.security.SystemFunction" %>
<%@page import="com.urbancode.ubuild.runtime.paths.LogPathHelper" %>
<%@page import="com.urbancode.ubuild.services.file.FileInfo" %>
<%@page import="com.urbancode.ubuild.services.jobs.JobStatusEnum" %>
<%@page import="com.urbancode.ubuild.services.logging.LogNamingHelper" %>
<%@page import="com.urbancode.ubuild.services.logging.LoggingService" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.commons.util.Duration" %>
<%@page import="org.apache.log4j.Logger" %>
<%@page import="java.io.File" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.services.jobs.JobStatusEnum" />
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />

<%
  try {
    JobTrace jobTrace = (JobTrace) pageContext.findAttribute(WebConstants.JOB_TRACE);
    Date jobStartDate = jobTrace.getStartDate();
    LogPathHelper logPathHelper = LogPathHelper.getInstance();
    LogNamingHelper logNamingHelper = LogNamingHelper.getInstance();
    String baseLogPath = logPathHelper.getBaseLogPath();
%>

<c:set var="project" value="${jobTrace.project}"/>

<c:url var="plusImage" value="/images/icon_plus_jobtrace.gif"/>
<c:url var="minusImage" value="/images/icon_minus_jobtrace.gif"/>
<c:url var="spacerImage" value="/images/spacer.gif"/>
<c:url var="logImage" value="/images/icon_note_file.gif"/>
<c:url var="outputImage" value="/images/icon_output.gif"/>

<%-- CONTENT --%>
<div class="table_wrapper">
  <table class="data-table">
    <thead>
      <tr>
        <th scope="col" valign="middle" style="text-align: left;">${ub:i18n("Step")}</th>
        <th scope="col" align="center" valign="middle" width="15%">${ub:i18n("Agent")}</th>
        <th scope="col" align="center" valign="middle" width="15%">${ub:i18n("Status")}</th>
        <th scope="col" align="center" valign="middle" width="15%">${ub:i18n("StartOffset")}</th>
        <th scope="col" align="center" valign="middle" width="15%">${ub:i18n("Duration")}</th>
        <th scope="col" align="center" valign="middle" width="8%">${ub:i18n("Actions")}</th>
      </tr>
    </thead>

    <c:forEach var="step" items="${jobTrace.stepTraceArray}" varStatus="stepLoop">
      <c:set var="startDate" value="${step.startDate}"/>
      <c:set var="endDate" value="${step.endDate}"/>
      <c:set var="isStepDone" value="${endDate != null}"/>

      <%
        StepTrace step = (StepTrace)pageContext.findAttribute("step");

        Date stepStartDate = (Date) pageContext.findAttribute("startDate");
        String stepOffset = jobStartDate == null ? "-" : new Duration(jobStartDate, stepStartDate).toString();

        Date stepEndDate = (Date) pageContext.findAttribute("endDate");
        String stepDuration = stepStartDate == null ? "-" : new Duration(stepStartDate, stepEndDate).toString();
      %>


      <tbody>
        <tr bgcolor="#ffffff" id="step:${fn:escapeXml(stepLoop.index)}">
          <td align="left" nowrap="nowrap">
            <c:set var="stepHeader" value="${stepLoop.index+1}. ${step.name}"/>
            <img alt="" src="${fn:escapeXml(spacerImage)}" height="1" width="16"/> ${fn:escapeXml(stepHeader)}
          </td>
          <td align="left" nowrap="nowrap">${fn:escapeXml(jobTrace.agent.name)}</td>
          <td align="left" nowrap="nowrap"
            style="background-color: ${fn:escapeXml(step.status.color)}; color: ${fn:escapeXml(step.status.secondaryColor)};">
            ${fn:escapeXml(ub:i18n(step.status.name))}</td>
          <td align="left" nowrap="nowrap"><%= stepOffset %></td>
          <td align="left" nowrap="nowrap"><%= stepDuration %></td>
          <td align="left" nowrap="nowrap">
             <%
               List<FileInfo> stepLogFileInfoList = logPathHelper.getLogFileInfoList(step);
               for (int j = 0; j < stepLogFileInfoList.size(); j++) {
                 FileInfo logFileInfo = stepLogFileInfoList.get(j);
                 String logName = logNamingHelper.getName(logFileInfo.getName());
                 String logPath = logFileInfo.getUnresolvedPath().substring(baseLogPath.length() + 1);
                 if (j>0) {
                   out.write(" &nbsp;&nbsp; ");
                 }

                 pageContext.setAttribute("logPath", logPath);
                 pageContext.setAttribute("logName", logName);
                 pageContext.setAttribute("pathSeparator", File.separator);
                 %>
                   <c:url var="viewLogUrl" value="${ViewLogTasks.viewLog}">
                     <c:param name="${WebConstants.LOG_NAME}" value="${logPath}" />
                     <c:param name="${WebConstants.LOG_PATH_SEPARATOR}" value="${pathSeparator}"/>
                   </c:url>
                   <c:set var="viewLogUrl" value="${fn:escapeXml(viewLogUrl)}"/>
                     <a href="#" title="${ub:i18nMessage('ViewWithParam', fn:escapeXml(logName))}"
                        onclick="showPopup('${ah3:escapeJs(viewLogUrl)}', windowWidth() - 100, windowHeight() - 100)"
                      ><c:choose>
                         <c:when test="${logName == 'output'}">
                      <img alt="${ub:i18n('Output')}" src="${fn:escapeXml(outputImage)}" border="0"/>
                         </c:when>
                         <c:otherwise>
                      <img alt="${ub:i18n('Log')}" src="${fn:escapeXml(logImage)}" border="0"/>
                         </c:otherwise>
                      </c:choose></a>
                 <%
               }
             %>
            </td>
          </tr>
        </tbody>
    </c:forEach>
  </table>
</div>
<%
  } catch (Exception e) {
    Logger.getLogger("com.urbancode.jobTraceTable").error(e.getMessage(), e);
  }
%>
