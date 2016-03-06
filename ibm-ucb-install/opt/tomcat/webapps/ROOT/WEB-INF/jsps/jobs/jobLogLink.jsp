<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.services.logging.LogNamingHelper" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.JobTrace" %>
<%@ page import="java.io.File" %>
<%@ page import="com.urbancode.commons.logfile.ILogFile" %>
<%@ page import="com.urbancode.commons.logfile.RemoteLogFileFactory" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<%
    JobTrace jobTraceForLog = (JobTrace) pageContext.findAttribute(WebConstants.JOB_TRACE);
    File jobLogFile = LogNamingHelper.getInstance().createRelativeLogFile(jobTraceForLog);
    ILogFile jobRemoteLogFile = RemoteLogFileFactory.getInstance(jobLogFile.getPath(), false);
    pageContext.setAttribute("jobLogNotEmpty", !jobRemoteLogFile.isEmpty());
    pageContext.setAttribute("jobLogName", jobLogFile.getPath());
    pageContext.setAttribute("pathSeparator", File.separator);
%>
<c:url var="viewJobLogIconUrl" value="/images/icon_job_log.gif"/>
<c:url var="viewJobLogUrl" value="${ViewLogTasks.viewLog}">
    <c:param name="log_name" value="${jobLogName}"/>
    <c:param name="pathSeparator" value="${pathSeparator}"/>
</c:url>
<c:set var="viewJobLogUrl" value="${fn:escapeXml(viewJobLogUrl)}"/>
<ucf:link href="#"
          onclick="showPopup('${ah3:escapeJs(viewJobLogUrl)}', windowWidth() - 100, windowHeight() - 100); return false;"
          label="${ub:i18n('ShowLog')}"
          disabledLabel="${ub:i18n('NoLog')}"
          enabled="${jobLogNotEmpty}"
          img="${viewJobLogIconUrl}"/>