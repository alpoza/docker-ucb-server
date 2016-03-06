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

<%@page import="com.urbancode.ubuild.dashboard.*"%>
<%@page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@page import="com.urbancode.ubuild.domain.project.*"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="java.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildRequestTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imgUrl" value="/images"/>

<c:import url="/WEB-INF/jsps/search/_header.jsp">
  <c:param name="selected" value="buildRequest" />
</c:import>

<%
    Map<Long, Boolean> writeProjects = new HashMap<Long, Boolean>();
    pageContext.setAttribute("eo", new EvenOdd());
%>
<div class="system-helpbox">${ub:i18n("RequestHistoryHelp")}</div>
<br/>

<c:url var="actionUrl1" value="${SearchTasks.viewBuildRequests}" />
<form method="get" action="${fn:escapeXml(actionUrl1)}">
  <table style="margin-bottom: 1em;" class="property-table">
    <tbody>
      <tr class="${eo.next}" valign="top">
        <td width="15%"><span class="bold">${ub:i18n("ProjectWithColon")} </span></td>
        <td width="20%">
          <ucf:autocomplete name="${WebConstants.PROJECT_ID}" list="${dash_key_projects}" emptyMessage="${ub:i18n('AnyProject')}" 
                    selectedList="${project_list}" selectedText="${searchtext}" canUnselect="true"
                    autoCompleteId="projectSearch"/>
        </td>
        <td><span class="inlinehelp">${ub:i18n("SearchProjectDesc")}</span></td>
      </tr>
  
      <tr class="${eo.next}" valign="top">
        <td width="15%"><span class="bold">${ub:i18n("ResultWithColon")}</span></td>
        <td width="20%">
          <select name="${WebConstants.STATUS_NAME}">
            <option selected="selected" value="">--- ${ub:i18n("AnyStatus")} ---</option>
  
            <c:forEach var="status" items="${dash_key_statuses}">
              <c:choose>
                <c:when test="${status.name == param.statusName}">
                  <c:set var="selected" value="selected='selected'" />
                </c:when>
  
                <c:otherwise>
                  <c:set var="selected" value="" />
                </c:otherwise>
              </c:choose>
  
              <option ${selected} value="${fn:escapeXml(status.name)}">${ub:i18n(fn:escapeXml(status.name))}</option>
            </c:forEach>
          </select>
        </td>
        <td><span class="inlinehelp">${ub:i18n("RequestHistoryResultDesc")}</span></td>
      </tr>
  
      <tr class="${eo.next}" valign="top">
        <td width="15%"><span class="bold">${ub:i18n("ResultsPerPage")} </span></td>
        <td width="20%">
          <ucf:text id="resultsPerPage" name="resultsPerPage" size="20" value="${resultsPerPage}"/>
        </td>
        <td>
          <span class="inlinehelp">${ub:i18n("ResultsPerPageDesc")}</span>
        </td>
      </tr>
  
    </tbody>
  </table>
  <ucf:button name="search" label="${ub:i18n('Search')}" />
</form>

<c:if test="${dash_key_BLR_summaries != null}">
  <c:url var="baseUrl" value="${SearchTasks.viewBuildRequests}">
    <c:param name="search" value="Search" />
    <c:param name="auto-complete-projectSearch" value="${searchtext}" />
    <c:param name="projectId" value="${param.projectId}" />
    <c:param name="statusName" value="${param.statusName}" />
  </c:url>

  <script type="text/javascript">
    /* <![CDATA[ */
    function searchRequest(page) {
      var resultsPerPageElement = document.getElementById("resultsPerPage");
      var request = '${ah3:escapeJs(baseUrl)}';
      request = request + "&page=" + page + "&resultsPerPage=" + resultsPerPageElement.value;
      goTo(request);
    }
    /* ]]> */
  </script>

  <ucui:carousel
      id="pagination"
      methodName="searchRequest"
      currentPage="${param.page == null || param.page < 0 ? 0 : param.page}"
      numberOfPages="${numPages}" />

  <br/>
  <br/>
  <br/>

  <c:set var="showButtons" value="false" />
  <c:url var="actionUrl2" value="${SearchTasks.deleteBuildRequests}">
    <c:param name="search" value="Search" />
    <c:param name="auto-complete-projectSearch" value="${searchtext}" />
    <c:param name="projectId" value="${param.projectId}" />
    <c:param name="statusName" value="${param.statusName}" />
    <c:param name="page" value="${param.page}" />
    <c:param name="resultsPerPage" value="${param.resultsPerPage}" />
    <c:param name="search" value="true" />
  </c:url>

  <form method="post" id="deleteRequestForm" action="${fn:escapeXml(actionUrl2)}">
    <div class="dashboard-region">
      <c:choose>
        <c:when test="${empty dash_key_BLR_summaries}">
          ${ub:i18n("NoBuildLifeRequestsFound")}
        </c:when>

        <c:otherwise>
          <table class="data-table" width="100%">
            <thead>
              <tr>
                <th scope="col" align="center" valign="middle" width="7%"><ucf:checkbox name="selectAll" onclick="checkOrUncheckAll(this.form, '${ah3:escapeJs(WebConstants.BUILD_REQUEST_ID)}', this.checked)"/></th>
                <th scope="col" align="center" valign="middle" width="15%">${ub:i18n("BuildRequest")}</th>
                <th scope="col" align="left" valign="middle" width="13%">${ub:i18n("BuildLifeProcess")}</th>
                <th scope="col" align="left" valign="middle" width="20%">${ub:i18n("Project")}</th>
                <th scope="col" align="left" valign="middle" width="20%">${ub:i18n("RequestedProcess")}</th>
                <th scope="col" align="left" valign="middle" width="13%">${ub:i18n("RequestDate")}</th>
                <th scope="col" align="left" valign="middle" width="5%">${ub:i18n("Log")}</th>
                <th scope="col" align="left" valign="middle" width="7%">${ub:i18n("Details")}</th>
              </tr>
            </thead>
            <tbody>
              <%
              pageContext.setAttribute("eo", new EvenOdd());
              %>

              <c:forEach var="curBLRS" items="${dash_key_BLR_summaries}">
                <c:set var="projectId" value="${curBLRS.projectId}" />

                <%
                  Long projectId = (Long) pageContext.findAttribute("projectId");
                  Boolean canWrite = (Boolean) writeProjects.get(projectId);
                  if (projectId != null && canWrite == null) {
                      Handle projectHandle = new Handle(Project.class, projectId);
                      boolean writePerm = Authority.getInstance().hasPermission(projectHandle, UBuildAction.PROJECT_EDIT);
                      canWrite = Boolean.valueOf(writePerm);
                      writeProjects.put(projectId, canWrite);
                  }
                  pageContext.setAttribute("canWrite", canWrite);

                  BuildLifeRequestSummary blrs = (BuildLifeRequestSummary) pageContext.getAttribute("curBLRS");
                %>

                <c:url var="projectUrlId" value="${ProjectTasks.viewDashboard}">
                  <c:param name="projectId" value="${curBLRS.projectId}" />
                </c:url>

                <c:url var="workflowUrlId" value="${WorkflowTasks.viewDashboard}">
                  <c:param name="workflowId" value="${curBLRS.workflowId}" />
                </c:url>

                <c:url var="buildLifeUrlId" value="${BuildLifeTasks.viewBuildLife}">
                  <c:param name="buildLifeId" value="${curBLRS.buildLifeId}" />
                </c:url>

                <c:url var="workflowCaseUrlId" value="${WorkflowCaseTasks.viewWorkflowCase}">
                  <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${curBLRS.workflowCaseId}" />
                </c:url>

                <c:url var="abortRequestUrl" value="${SearchTasks.abortBuildRequest}">
                  <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${curBLRS.requestId}" />
                  <c:param name="search" value="Search" />
                  <c:param name="auto-complete-projectSearch" value="${searchtext}" />
                  <c:param name="${WebConstants.PROJECT_ID}" value="${param.projectId}" />
                  <c:param name="${WebConstants.PAGE}" value="${param.page}" />
                  <c:param name="${WebConstants.RESULTS_PER_PAGE}" value="${resultsPerPage}" />
                  <c:param name="statusName" value="${param.statusName}" />
                </c:url>

                <c:url var="requestUrl" value="${BuildRequestTasks.viewBuildRequest}">
                  <c:param name="${WebConstants.BUILD_REQUEST_ID}" value="${curBLRS.requestId}" />
                </c:url>

                <tr class="${eo.next}">
                  <td align="center">
                    <c:choose>
                      <c:when test="${canWrite != null and !canWrite}">
                        <%-- placehoder --%>&nbsp;
                      </c:when>

                      <c:when test="${curBLRS.buildLifeId != null || curBLRS.workflowCaseId != null }">
                        ${ub:i18n("InUse")}
                      </c:when>

                      <c:when test="${curBLRS.buildLifeId == null }">
                        <input type="checkbox" class="checkbox" name="${WebConstants.BUILD_REQUEST_ID}"
                          value="${curBLRS.requestId}"/>
                        <c:set var="showButtons" value="true" />
                      </c:when>
                      <c:otherwise>
                        ${ub:i18n("InUseByBuildLife")}
                      </c:otherwise>

                    </c:choose>
                  </td>

                  <td align="center" nowrap="nowrap" style="background: ${curBLRS.status.color};">
                    ${ub:i18n(fn:escapeXml(curBLRS.status.name))}
                    <c:if test="${!curBLRS.status.complete}">
                     (<ucf:confirmlink href="${abortRequestUrl}" label="${ub:i18n('Abort')}" message="${ub:i18n('AbortRequestConfirm')}" />)
                    </c:if>
                  </td>

                  <td align="left">
                    <c:choose>
                      <c:when test="${curBLRS.buildLifeId!=null}">
                        <c:if test="${curBLRS.buildLifeInactive}">
                          <img alt="" src="${fn:escapeXml(imgUrl)}/tombstone-small.png">
                        </c:if>
                        <a href="${fn:escapeXml(buildLifeUrlId)}">${curBLRS.buildLifeId}</a>
                      </c:when>

                      <c:otherwise>${ub:i18n("N/A")}</c:otherwise>
                    </c:choose>
                    /
                    <c:choose>
                      <c:when test="${curBLRS.workflowCaseId!=null}">
                        <a href="${fn:escapeXml(workflowCaseUrlId)}">${curBLRS.workflowCaseId}</a>
                      </c:when>
                      <c:otherwise>${ub:i18n("N/A")}</c:otherwise>
                    </c:choose>
                  </td>

                  <td><a href="${fn:escapeXml(projectUrlId)}">${fn:escapeXml(curBLRS.projectName)}</a></td>

                  <td><a href="${fn:escapeXml(workflowUrlId)}">${fn:escapeXml(curBLRS.workflowName)}</a></td>

                  <td align="left">
                    ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, curBLRS.date))}
                  </td>

                  <td align="left">
                    <c:set var="buildRequestId" value="${curBLRS.requestId}" scope="request"/>
                    <c:import url="/WEB-INF/jsps/project/buildrequest/requestLogLink.jsp"/>
                  </td>

                  <td align="left"><a href="${fn:escapeXml(requestUrl)}">${curBLRS.requestId}</a></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>

    <c:if test="${showButtons}">
    <div>
      <ucf:button name="Delete" label="${ub:i18n('Delete')}" />
    </div>
    </c:if>
  </form>
</c:if>

<c:import url="/WEB-INF/jsps/search/_footer.jsp" />
