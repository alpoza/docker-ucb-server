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

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:set var="project" value="${buildRequest.buildProfile.project}"/>
<c:if test="${project == null && buildRequest.buildLife != null}">
  <c:set var="project" value="${buildRequest.buildLife.profile.project}"/>
</c:if>

<%-- URLs --%>

<c:url var="iconWorkflowUrl" value="/images/workflow.gif"/>
<c:url var="iconPrioritizeUrl" value="/images/icon_priority.gif"/>
<c:set var="viewRequestUrl" value="${BuildRequestTasks.viewBuildRequest}"/>

<%-- *** CONTENT *** --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('BuildRequest')}" />
  <jsp:param name="selected" value="projects" />
</jsp:include>

  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('RequestContext')}" href="" enabled="${false}" klass="selected tab"/>
  </div>
  <div class="contents">

    <div style="margin: 10px;margin-bottom: 25px;">

      <div class="system-helpbox" style="float:right; width:63%;">${ub:i18n("RequestContextHelp")}</div>

      <table class="data-table" style="width: 33%">
        <tr>
            <th colspan="2" align="left">${ub:i18nMessage("RequestContextId", buildRequest.requestBatchId)}</th>
        </tr>
        <tr>
          <c:set var="background_color"
            value="style='background-color: ${contextStatus.color}; color: ${contextStatus.secondaryColor};'"/>
          <td align="left" nowrap="nowrap"><span class="bold">${ub:i18n("StatusWithColon")}</span></td>
          <td align="left" ${background_color}><c:out value="${ub:i18n(contextStatus.name)}" default="${ub:i18n('N/A')}"/></td>
        </tr>
        <tr>
          <td align="left" nowrap="nowrap"><span class="bold">${ub:i18n("RequestedBy")}</span></td>
          <td align="left">
            <c:forEach var="vertex" items="${requestGraph.vertexArray}">
              <c:if test="${vertex.data.requestSource ne 'Dependency'}">
                <c:set var="requester" value="${vertex.data.user.name} (${ub:i18n(vertex.data.requestSource)})"/>
              </c:if>
            </c:forEach>
            <c:out value="${requester}" default="${ub:i18n('N/A')}"/>
          </td>
        </tr>
        <c:choose>
          <c:when test="${param.prioritizationSuccess}">
            <tr>
              <td colspan="2" align="center" style="padding: 10px;background: #f0f0f0;">
                <span class="success">${ub:i18n("RequestContextAllRequestsHighPriority")}</span>
              </td>
            </tr>
          </c:when>
          <c:when test="${not contextStatus.complete and buildRequest.workflowCase.prioritizationPermission}">
            <tr>
              <td align="left" nowrap="nowrap"><span class="bold">${ub:i18n("ActionsWithColon")}</span></td>
              <td align="left">
                <c:url var="prioritizeUrl" value="${BuildRequestTasks.prioritizeRequestContext}">
                  <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${buildRequest.id}"/>
                </c:url>
                <ucf:confirmlink href="${prioritizeUrl}" img="${iconPrioritizeUrl}" label="${ub:i18n('RequestContextPrioritizeContext')}"
                        forceLabel="true" message="${ub:i18n('RequestContextPrioritizeContextConfirm')}"/>
              </td>
            </tr>
          </c:when>
        </c:choose>
      </table>
      <br/>
      <br/>

      <div style="overflow: auto;">
        <table class="requestContext-table" align="center">
          <c:forEach var="vertexList" items="${requestGraph.verticesByDepth}" varStatus="depth">
            <tr>
              <c:forEach var="vertex" items="${vertexList}">
                <c:set var="contextRequest" value="${vertex.data}"/>
                <td align="center" class='requestContext<c:if test="${contextRequest eq buildRequest}">-selected</c:if>'
                    nowrap="nowrap" colspan="${vertex.width}" rowspan="${vertex.height}"
                    <c:if test="${contextRequest.status.name eq 'Failed'}">
                    style="background-color: ${contextRequest.status.color};
                           color: ${fn:escapeXml(contextRequest.status.secondaryColor)};"
                    </c:if>
                    <c:if test="${contextRequest.workflowCase.status.name eq 'Failed'}">
                    style="background-color: ${contextRequest.workflowCase.status.color};
                           color: ${fn:escapeXml(contextRequest.workflowCase.status.secondaryColor)};"
                    </c:if>
                    >
                  <c:if test="${depth.index gt 0}"><div class="requestContext-join">${fn:toUpperCase(ub:i18n("Created"))}</div></c:if>

                  <c:url var="tempViewRequestUrl" value="${viewRequestUrl}">
                    <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${vertex.data.id}"/>
                  </c:url>

                  <ucf:link href="${tempViewRequestUrl}" img="${iconWorkflowUrl}" label="${ub:i18n('ViewRequest')}"/>
                  <br/>
                  ${ub:i18nMessage("RequestContextRequestLabel", contextRequest.id)}<br/>
                  <div class="requestContext-details">
                    ${ub:i18n("ProjectWithColon")} <c:out value="${contextRequest.project.name}"/><br/>
                    ${ub:i18n("ProcessWithColon")} <c:out value="${contextRequest.workflow.name}"/><br/>
                    ${ub:i18n("StatusWithColon")} <c:out value="${ub:i18n(contextRequest.status.name)}"/>
                    <c:if test="${contextRequest.status.complete and contextRequest.status.name ne 'Failed'}">
                      <c:set var="requestWorkflowCase" value="${contextRequest.workflowCase}"/>
                      <c:if test="${not empty requestWorkflowCase}">
                        ->
                        <c:choose>
                          <c:when test="${contextRequest.status.name == 'Created New Build Life'}">
                            <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
                               <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${contextRequest.buildLife.id}"/>
                            </c:url>
                            <ucf:link href="${buildLifeUrl}" label="${ub:i18n(requestWorkflowCase.status.name)}" title="${ub:i18n('ViewBuildLife')}"/>
                          </c:when>
                          <c:when test="${not empty(contextRequest.buildLife) && contextRequest.status.name == 'Started Workflow'}">
                            <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
                               <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${contextRequest.buildLife.id}"/>
                            </c:url>
                            <ucf:link href="${buildLifeUrl}" label="${ub:i18n(requestWorkflowCase.status.name)}" title="${ub:i18n('ViewBuildLife')}"/>
                          </c:when>
                          <c:when test="${empty(contextRequest.buildLife) && contextRequest.status.name == 'Started Workflow'}">
                            <c:url var="workflowCaseUrl" value="${WorkflowCaseTasks.viewWorkflowCase}">
                               <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${contextRequest.workflowCase.id}"/>
                            </c:url>
                            <ucf:link href="${workflowCaseUrl}" label="${ub:i18n(requestWorkflowCase.status.name)}" title="${ub:i18n('ViewCreatedProcess')}"/>
                          </c:when>
                          <c:otherwise>${ub:i18n(requestWorkflowCase.status.name)}</c:otherwise>
                        </c:choose>
                      </c:if>
                    </c:if>
                    <br/>
                    ${ub:i18n("PriorityWithColon")} <c:out value="${ub:i18n(contextRequest.priority.name)}"/><br/>
                    ${ub:i18n("DateWithColon")} ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, contextRequest.workspaceDate))}<br/>
                  </div>
                </td>

              </c:forEach>
            </tr>
          </c:forEach>
        </table>
      </div>
    </div>
  </div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
