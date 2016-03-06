<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowCase" %>
<%@ page import="com.urbancode.ubuild.services.logging.LogNamingHelper" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.commons.logfile.ILogFile" %>
<%@ page import="com.urbancode.commons.logfile.RemoteLogFileFactory" %>
<%@ page import="java.io.File" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<%
    WorkflowCase workflowCaseForLog = (WorkflowCase) pageContext.findAttribute(WebConstants.WORKFLOW_CASE);
    File workflowLogFile = LogNamingHelper.getInstance().createRelativeLogFile(workflowCaseForLog);
    ILogFile workflowRemoteLogFile = RemoteLogFileFactory.getInstance(workflowLogFile.getPath(), false);
    pageContext.setAttribute("workflowLogNotEmpty", !workflowRemoteLogFile.isEmpty());
    pageContext.setAttribute("workflowLogName", workflowLogFile.getPath());
    pageContext.setAttribute("pathSeparator", File.separator);
%>
<c:url var="viewWorkflowLogIconUrl" value="/images/icon_workflow_log.gif"/>
<c:url var="viewWorkflowLogUrl" value="${ViewLogTasks.viewLog}">
    <c:param name="log_name" value="${workflowLogName}" />
    <c:param name="pathSeparator" value="${pathSeparator}"/>
</c:url>
<c:set var="viewWorkflowLogUrl" value="${fn:escapeXml(viewWorkflowLogUrl)}"/>
<ucf:link href="#"
          onclick="showPopup('${ah3:escapeJs(viewWorkflowLogUrl)}', windowWidth() - 100, windowHeight() - 100); return false;"
          label="${ub:i18n('ShowLog')}"
          disabledLabel="${ub:i18n('NoLog')}"
          enabled="${workflowLogNotEmpty}"
          img="${viewWorkflowLogIconUrl}"/>