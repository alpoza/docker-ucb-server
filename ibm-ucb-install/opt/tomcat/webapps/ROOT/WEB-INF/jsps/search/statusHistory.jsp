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
<%@ page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@ page import="com.urbancode.ubuild.domain.project.*"%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@ page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks"%>
<%@ page import="com.urbancode.ubuild.dashboard.StatusSummary"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.*"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imgUrl" value="/images"/>

<%-- CONTENT --%>

<c:import url="/WEB-INF/jsps/search/_header.jsp">
  <c:param name="selected" value="statusHistory"/>
</c:import>
<div class="system-helpbox">${ub:i18n("StatusHistoryHelp")}</div>
<br/>

<%
  if (session.getAttribute(WebConstants.ERRORS) != null) {
      request.setAttribute(WebConstants.ERRORS, session.getAttribute(WebConstants.ERRORS));
      session.removeAttribute(WebConstants.ERRORS);
  }
  Map<Long, Boolean> writeProjects = new HashMap<Long, Boolean>();
  StatusSummary[] statusSummaries = (StatusSummary[])request.getAttribute(DashboardTasks.KEY_STATUS_SUMMARIES);
  EvenOdd eo = new EvenOdd();
%>

<form method="get" action="${fn:escapeXml(statusHistoryUrl)}">
  <table style="margin-bottom:1em;" class="property-table">
    <tbody>
      <error:field-error field="${WebConstants.BUILD_LIFE_ID}" cssClass="${eo.next}"/>
      <tr class="even" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("ProjectWithColon")} </span></td>
        <td align="left" width="20%">
          <ucf:autocomplete name="${WebConstants.PROJECT_ID}" list="${dash_key_projects}" emptyMessage="${ub:i18n('AnyProject')}"
                          selectedList="${project_list}"
                          selectedText="${searchtext}"
                          canUnselect="true"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("SearchProjectDesc")}</span>
        </td>
      </tr>

      <tr class="odd" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("StatusWithColon")}</span></td>
        <td align="left" width="20%">
          <ucf:idSelector
              id="statusSelector"
              name="${WebConstants.STATUS_ID}"
              emptyMessage="${ub:i18n('AnyStatus')}"
              list="${dash_key_statuses}"
              canUnselect="true"
              selectedId="${statusId}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("StatusHistoryStatusDesc")}</span>
        </td>
      </tr>

      <tr class="even" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("ResultsPerPage")} </span></td>
        <td align="left" width="20%">
          <ucf:text id="resultsPerPage" name="resultsPerPage" size="20" value="${resultsPerPage}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("ResultsPerPageDesc")}</span>
        </td>
      </tr>
     </tbody>
   </table>
   <ucf:button name="search" label="${ub:i18n('Search')}"/>
</form>

<c:if test="${dash_key_status_summaries != null}">
  <c:url var="baseUrl" value="${SearchTasks.viewStatusHistory}">
    <c:param name="search" value="Search" />
    <c:param name="auto-complete" value="${searchtext}" />
    <c:param name="projectId" value="${param.projectId}" />
    <c:param name="statusId" value="${param.statusId}" />
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
  <ucui:carousel id="pagination" methodName="searchRequest" currentPage="${param.page == null || param.page < 0 ? 0 : param.page}" numberOfPages="${numPages}"/>
  <br/><br/><br/>

  <c:url var="deleteBuildLifeUrl" value="${SearchTasks.deleteBuildLifeFromStatusTab}">
    <c:param name="search" value="${searchtext}"/>
    <c:param name="${WebConstants.PROJECT_ID}" value="${param.projectId}"/>
    <c:param name="${WebConstants.STATUS_ID}" value="${param.statusId}"/>
    <c:param name="${WebConstants.RESULTS_PER_PAGE}" value="${param.resultsPerPage}" />
    <c:param name="${WebConstants.PAGE}" value="${param.page}"/>
  </c:url>
  <c:set var="showButtons" value="false"/>
  <form method="post" action="${fn:escapeXml(deleteBuildLifeUrl)}">

      <div class="dashboard-region">
        <% if (statusSummaries.length > 0) { %>
          <table class="data-table">
          <tbody>
          <tr>
            <th scope="col"><ucf:checkbox name="selectAll" onclick="checkOrUncheckAll(this.form, \'buildLifeId\', this.checked)"/></th>
            <th scope="col" align="center" valign="middle">${ub:i18n("Status")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("Project")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("BuildProcess")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("Build")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("LatestStamp")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("Job")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("DateAssigned")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("UsedIn")}</th>
          </tr>
          <% eo.setEven(); %>
          <% for (int i = 0; i < statusSummaries.length; i++) {
            StatusSummary curSS = statusSummaries[i];
            pageContext.setAttribute("curSS", curSS);
            pageContext.setAttribute("jobTraceId", curSS.getJobTraceId());
            pageContext.setAttribute("projectId", curSS.getProjectId());
            pageContext.setAttribute("buildLifeId", curSS.getBuildLifeId());

            Long projectId = curSS.getProjectId();
            Boolean canWrite = (Boolean)writeProjects.get(projectId);
            if (projectId != null && canWrite == null) {
                Handle projectHandle = new Handle(Project.class, projectId);
                boolean writePerm = Authority.getInstance().hasPermission(projectHandle, UBuildAction.PROJECT_EDIT);
                canWrite = Boolean.valueOf(writePerm);
                writeProjects.put(projectId, canWrite);
            }
            pageContext.setAttribute("canWrite", canWrite);
            %>
            <c:url var="jobTraceUrlId" value="${JobTasks.viewJobTrace}">
              <c:param name="job_trace_id" value="${curSS.jobTraceId}"/>
            </c:url>
            <c:url var="projectUrlId" value="${ProjectTasks.viewDashboard}">
              <c:param name="projectId" value="${curSS.projectId}"/>
            </c:url>
            <c:url var="workflowUrlId" value="${WorkflowTasks.viewDashboard}">
              <c:param name="workflowId" value="${curSS.workflowId}"/>
            </c:url>
            <c:url var="buildLifeUrlId" value="${BuildLifeTasks.viewBuildLife}">
              <c:param name="projectId" value="${curSS.projectId}"/>
              <c:param name="buildLifeId" value="${curSS.buildLifeId}"/>
            </c:url>
            <tr class="<%=eo.getNext()%>">
              <c:url var="statusHistoryUrlName" value="${SearchTasks.viewStatusHistory}">
                <c:param name="statusName" value="${curSS.statusName}"/>
              </c:url>

              <td align="center" nowrap="nowrap">
                <c:choose>
                  <c:when test="${canWrite != null and !canWrite}">
                    <%-- placeholder --%>&nbsp;
                  </c:when>
                  <c:when test="${fn:length(curSS.parentBuildLifeHandleArray)>0}">
                    ${ub:i18n("InUse")}
                  </c:when>
                  <c:when test="${fn:length(curSS.parentBuildLifeHandleArray)==0}">
                    <input type="checkbox" class="checkbox" name="buildLifeId" value="${buildLifeId}"/>
                    <c:set var="showButtons" value="true"/>
                  </c:when>
                  <c:otherwise>
                    ${ub:i18n("InUse")}
                  </c:otherwise>
                </c:choose>
              </td>
              <c:set var="style" value="${ub:isDarkColor(curSS.statusColor) ? 'color: #FFFFFF' : ''}"/>
              <td align="center" style="background-color: ${fn:escapeXml(curSS.statusColor)}; ${style}" nowrap="nowrap">
                <c:out value="${ub:i18n(curSS.statusName)}"/>
              </td>
              <c:if  test="${curSS.buildLifeId != null}">
                <td align="left" nowrap="nowrap"><a href="${fn:escapeXml(projectUrlId)}"><c:out value="${curSS.projectName}" default="${ub:i18n('N/A')}"/></a></td>
                <td align="left" nowrap="nowrap"><a href="${fn:escapeXml(workflowUrlId)}"><c:out value="${curSS.workflowName}" default="${ub:i18n('N/A')}"/></a></td>
                <td align="left" nowrap="nowrap">
                  <c:if test="${curSS.buildLifeInactive}">
                    <img alt="" src="${fn:escapeXml(imgUrl)}/tombstone-small.png">
                  </c:if>
                  <a href="${fn:escapeXml(buildLifeUrlId)}"><c:out value="${curSS.buildLifeId}" default="${ub:i18n('N/A')}"/></a>
                </td>
                <td align="left" nowrap="nowrap"><c:out value="${curSS.latestStamp}" default="${ub:i18n('N/A')}"/></td>
                <td align="left" nowrap="nowrap"><a href="${fn:escapeXml(jobTraceUrlId)}"> <c:out value="${curSS.jobTraceId}" default="${ub:i18n('N/A')}"/></a></td>
                <td align="left" nowrap="nowrap">
                  ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, curSS.dateAssigned))}
                </td>
                <td align="left">
                  <c:if test="${fn:length(curSS.parentBuildLifeHandleArray)==0}">${ub:i18n('N/A')}</c:if>
                  <c:forEach var="parent" items="${curSS.parentBuildLifeHandleArray}" varStatus="status">
                    <c:url var="parentUrlId" value="${BuildLifeTasks.viewBuildLife}">
                      <c:param name="buildLifeId" value="${parent.id}"/>
                    </c:url>
                    <c:if test="${status.index != 0}">| </c:if> <a href="${fn:escapeXml(parentUrlId)}">${parent.id}</a>
                  </c:forEach>
                </td>
              </c:if>
              <c:if test="${curSS.buildLifeId==null}">
                <td align="left">${ub:i18n('N/A')}</td>
                <td align="left">${ub:i18n('N/A')}</td>
                <td align="left">${ub:i18n('N/A')}</td>
                <td align="left">${ub:i18n('N/A')}</td>
                <td align="left">${ub:i18n('N/A')}</td>
                <td align="left">${ub:i18n('N/A')}</td>
              </c:if>
            </tr>
            <% } %>
          </tbody>
          </table>
        <% } else { %>
          ${ub:i18n("NoResultsFound")}
        <% } %>
      </div>
      <c:if test="${showButtons}">
        <div>
          <br/><ucf:button name="Delete" label="${ub:i18n('Delete')}"/>
        </div>
      </c:if>
  </form>
</c:if>
<c:import url="/WEB-INF/jsps/search/_footer.jsp"/>
