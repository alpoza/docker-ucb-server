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
<%@page import="org.apache.log4j.Logger" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%
    BuildRequest buildRequest = (BuildRequest) pageContext.findAttribute(WebConstants.BUILD_REQUEST);
%>
<c:set var="workspaceDate" value="${ah3:formatDate(longDateTimeFormat, buildRequest.workspaceDate)}"/>

<c:set var="project" value="${buildRequest.buildProfile.project}"/>
<c:if test="${project == null && buildRequest.buildLife != null}">
  <c:set var="project" value="${buildRequest.buildLife.profile.project}"/>
</c:if>

<%-- URLs --%>

<c:url var="imgUrl" value="/images"/>

<c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
   <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${buildRequest.buildLife.id}"/>
</c:url>
<c:url var="mergedBuildRequestUrl" value="${BuildRequestTasks.viewBuildRequest}">
    <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${buildRequest.mergedRequestId}"/>
</c:url>
<c:url var="workflowCaseUrl" value="${WorkflowCaseTasks.viewWorkflowCase}">
    <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${buildRequest.workflowCase.id}"/>
</c:url>
<c:url var="requestGraphUrl" value="${BuildRequestTasks.viewBuildRequestGraph}">
    <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${buildRequest.id}"/>
</c:url>

<c:url var="spacerImage" value="/images/spacer.gif"/>
<c:url var="logImage" value="/images/icon_note_file.gif"/>
<c:url var="outputImage" value="/images/icon_output.gif"/>

<%-- *** CONTENT *** --%>
<jsp:include page="/WEB-INF/snippets/react.jsp"/>
<c:set var="onDocumentLoad" scope="request">renderBuildRequest();</c:set>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="BuildRequest" />
  <jsp:param name="selected" value="projects" />
</jsp:include>

<script type="text/javascript">
  /* <![CDATA[ */
  var buildRequestRestUrl = "/rest2/processRequests/${buildRequest.id}?extended=true";
  var viewLogUrl = "/tasks/logs/ViewLogTasks/viewLog";
  var spacerImage = "${spacerImage}";
  var logImage = "${logImage}";
  var outputImage = "${outputImage}";
  var buildLifeUrl = "${buildLifeUrl}";
  var mergedBuildRequestUrl = "${mergedBuildRequestUrl}";
  var workflowCaseUrl = "${workflowCaseUrl}";
  var statusImgUrl = "/images/icon_magnifyglass.gif";
  var errorImgUrl = "/images/icon_error_arrow.gif"
  /* ]]> */
</script>
<c:set var="dynamicRefreshCssUrl" value="/css/dynamicRefresh" />
<c:set var="dynamicRefreshJsUrl" value="/js/dynamicRefresh" />
<c:set var="dynamicRefreshBuildRequestJsUrl" value="${dynamicRefreshJsUrl}/buildRequest" />
<link rel="stylesheet" href="${dynamicRefreshCssUrl}/dynamicRefresh.css">
<script type="text/javascript" src="${dynamicRefreshBuildRequestJsUrl}/BuildRequest.js"></script>
<script type="text/javascript" src="${dynamicRefreshBuildRequestJsUrl}/BuildRequestStatus.js"></script>
<script type="text/javascript" src="${dynamicRefreshBuildRequestJsUrl}/BuildRequestProperty.js"></script>
<script type="text/javascript" src="${dynamicRefreshBuildRequestJsUrl}/BuildRequestSteps.js"></script>
<script type="text/javascript" src="${dynamicRefreshBuildRequestJsUrl}/BuildRequestErrors.js"></script>


<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('Request')}" href="" enabled="${false}" klass="selected tab"/>
  </ul>
</div>
<div class="contents">
  <br/>
  <c:set var="background_color" value="style='background-color: ${buildRequest.status.color}; color: ${buildRequest.status.secondaryColor};'"/>

  <table style="width: 100%;">
    <tr valign="top">
        <td style="width:34%; padding: 15px; vertical-align: top;">
            <table class="property-table">
                <caption>
                        ${ub:i18nMessage("BuildRequestLabel", buildRequest.id)}
                </caption>
                <tr>
                    <td align="left" nowrap="nowrap"><span class="bold">${ub:i18n("StatusWithColon")}</span></td>
                    <td align="left" id="buildRequestStatus"></td>
                </tr>
                <tr>
                    <td align="left"  nowrap="nowrap"><span class="bold">${ub:i18n("DateWithColon")}</span></td>
                    <td align="left"><c:out value="${workspaceDate}" default="${ub:i18n('N/A')}"/></td>
                </tr>
                <tr>
                    <td align="left" nowrap="nowrap"><span class="bold">${ub:i18n("RequestedBy")}</span></td>
                    <td align="left">${fn:escapeXml(buildRequest.user.name)} (${ub:i18n(fn:escapeXml(buildRequest.requestSource))})</td>
                </tr>
                <tr>
                    <td align="left" nowrap="nowrap"><span class="bold">${ub:i18n("RequesterWithColon")}</span></td>
                    <td align="left">${fn:escapeXml(buildRequest.requesterName)}</td>
                </tr>
                <tr>
                    <td align="left"  nowrap="nowrap"><span class="bold">${ub:i18n("ProjectWithColon")}</span></td>
                    <td align="left"><c:out value="${project.name}" default="${ub:i18n('N/A')}"/></td>
                </tr>
                <tr>
                    <td align="left"  nowrap="nowrap"><span class="bold">${ub:i18n("ProcessWithColon")}</span></td>
                    <td align="left"><c:out value="${buildRequest.workflow.name}" default="${ub:i18n('N/A')}"/></td>
                </tr>
                <tr>
                  <c:if test="${not empty buildRequest.buildConfiguration}">
                    <c:url var="buildConfigurationUrl" value="${WorkflowTasks.viewBuildConfiguration}">
                      <c:param name="${WebConstants.WORKFLOW_ID}" value="${buildRequest.workflow.id}" />
                      <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${buildRequest.buildConfiguration.id}"/>
                    </c:url>
                  </c:if>
                  <td align="left" nowrap="nowrap"><span class="bold">${ub:i18n("BuildConfigurationWithColon")}</span></td>
                  <td align="left">
                    <c:choose>
                      <c:when test="${not empty buildRequest.buildConfiguration}">
                        <a href="${buildConfigurationUrl}">${fn:escapeXml(buildRequest.buildConfiguration.name)}</a>
                      </c:when>
                      <c:otherwise>
                        ${ub:i18n('N/A')}
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              <tr>
                  <td align="left"  nowrap="nowrap"><span class="bold">${ub:i18n("PriorityWithColon")}</span></td>
                  <td align="left"><c:out value="${ub:i18n(buildRequest.priority.name)}" default="${ub:i18n('N/A')}"/></td>
              </tr>
              <c:if test="${not empty buildRequest.requestBatchId}">
                <tr>
                    <td align="left"  nowrap="nowrap"><span class="bold">${ub:i18n("ContextWithColon")}</span></td>
                    <td align="left">
                      <ucf:link href="${requestGraphUrl}" img="${fn:escapeXml(imgUrl)}/icon_magnifyglass.gif" imgStyle="vertical-align: bottom;" label="${ub:i18n('ViewAllRequestsInContext')}"/>
                    </td>
                </tr>
              </c:if>
              <tr>
                  <td align="left"  nowrap="nowrap"><span class="bold">${ub:i18n("LogWithColon")}</span></td>
                  <td align="left">
                    <c:set var="buildRequest" value="${buildRequest}" scope="request"/>
                    <c:import url="/WEB-INF/jsps/project/buildrequest/requestLogLink.jsp"/>
                  </td>
              </tr>
            </table>
        </td>
        <td style="width:66%; padding: 15px; vertical-align: top;" id="buildRequestProperty"></td>
    </tr>
    <c:if test="${buildRequest.jobTrace != null}">
      <tr>
        <td colspan="2" style="padding: 15px;">
          <div id="buildRequestSteps"></div>
          <c:set var="jobTrace" value="${buildRequest.jobTrace}" scope="request"/>
        </td>
      </tr>
      <tr>
        <td colspan="2" style="padding: 15px;">
          <div id="buildRequestErrors"></div>
        </td>
      </tr>
    </c:if>
  </table>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
