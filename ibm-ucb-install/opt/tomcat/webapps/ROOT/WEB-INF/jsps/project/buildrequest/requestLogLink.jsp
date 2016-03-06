<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.buildrequest.BuildRequest" %>
<%@ page import="com.urbancode.ubuild.services.logging.LogNamingHelper" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.commons.logfile.ILogFile" %>
<%@ page import="com.urbancode.commons.logfile.RemoteLogFileFactory" %>
<%@ page import="java.io.File" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks"/>
<%
  Long requestIdForLog = (Long) pageContext.findAttribute(WebConstants.BUILD_REQUEST_ID);
  BuildRequest requestForLog = (BuildRequest) pageContext.findAttribute(WebConstants.BUILD_REQUEST);
  if (requestForLog != null) {
    requestIdForLog = requestForLog.getId();
  }
  File requestLogFile = LogNamingHelper.getInstance().createRelativeRequestLogFile(requestIdForLog);
  ILogFile requestRemoteLogFile = RemoteLogFileFactory.getInstance(requestLogFile.getPath(), false);
  pageContext.setAttribute("requestLogNotEmpty", !requestRemoteLogFile.isEmpty());
  pageContext.setAttribute("requestLogName", requestLogFile.getPath());
  pageContext.setAttribute("pathSeparator", File.separator);
%>
<c:url var="viewRequestLogIconUrl" value="/images/icon_note_file.gif"/>
<c:url var="viewRequestLogUrl" value="${ViewLogTasks.viewLog}">
  <c:param name="log_name" value="${requestLogName}"/>
  <c:param name="pathSeparator" value="${pathSeparator}"/>
</c:url>
<ucf:link href="#"
          onclick="showPopup('${fn:escapeXml(viewRequestLogUrl)}', windowWidth() - 100, windowHeight() - 100); return false;"
          label="${ub:i18n('ShowLog')}"
          disabledLabel="${ub:i18n('NoLog')}"
          enabled="${requestLogNotEmpty}"
          img="${viewRequestLogIconUrl}"/>