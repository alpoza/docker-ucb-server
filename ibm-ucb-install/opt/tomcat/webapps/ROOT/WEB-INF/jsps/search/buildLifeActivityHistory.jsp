<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks"%>
<%@ page import="com.urbancode.ubuild.dashboard.StatusSummary"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.*"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@ page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@ page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@ page import="com.urbancode.ubuild.domain.project.*"%>
<%@ page import="com.urbancode.ubuild.dashboard.BuildLifeActivitySummary" %>
<%@ page import="com.urbancode.ubuild.web.search.SearchTasks" %>
<%@ page import="com.urbancode.ubuild.dashboard.BuildLifeWorkflowCaseSummary" %>
<%@ page import="java.util.*"%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imgUrl" value="/images"/>

<c:import url="/WEB-INF/jsps/search/_header.jsp">
   <c:param name="selected" value="buildLifeActivityHistory"/>
</c:import>

<%
  if (session.getAttribute(WebConstants.ERRORS) != null) {
      request.setAttribute(WebConstants.ERRORS, session.getAttribute(WebConstants.ERRORS));
      session.removeAttribute(WebConstants.ERRORS);
  }
  EvenOdd eo = new EvenOdd();
%>
<div class="system-helpbox">${ub:i18n("BuildLifeActivityHistorySearchHelp")}</div>
<br/>

<c:url var="actionUrl" value="${SearchTasks.viewBuildLifeActivityHistory}"/>
<form method="get" action="${fn:escapeXml(actionUrl)}">
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
        <td><span class="inlinehelp">${ub:i18n("SearchProjectDesc")}</span></td>
      </tr>
      
      <tr class="odd" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("SearchWithColon")}</span></td>
        <td align="left" width="20%">
          <ucf:enumSelector 
              id="statusSelector"
              unselectedText="-- ${ub:i18n('AnyStatus')} --"
              name="${WebConstants.STATUS}"
              list="${dash_key_statuses}"
              canUnselect="true"
              selectedValue="${status}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("SearchStatusDesc")}</span>
        </td>
      </tr>

      <tr class="odd" valign="top">
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
<c:if test="${dash_key_build_life_workflow_summaries != null}">
  <c:url var="baseUrl" value="${SearchTasks.viewBuildLifeActivityHistory}">
    <c:param name="search" value="Search" />
    <c:param name="auto-complete" value="${searchtext}" />
    <c:param name="projectId" value="${param.projectId}" />
    <c:param name="status" value="${param.status}" />
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

  <c:set var="showButtons" value="false"/>
  <c:url var="deleteBuildLifeUrl" value="${SearchTasks.deleteBuildLifeFromProcessTab}">
    <c:param name="search" value="${searchtext}"/>
    <c:param name="${WebConstants.PROJECT_ID}" value="${param.projectId}"/>
    <c:param name="${WebConstants.STATUS}" value="${status}"/>
    <c:param name="${WebConstants.RESULTS_PER_PAGE}" value="${param.resultsPerPage}" />
    <c:param name="${WebConstants.PAGE}" value="${param.page}"/>
  </c:url>
  <form method="post" action="${fn:escapeXml(deleteBuildLifeUrl)}">
    <div class="dashboard-region">
      <c:choose>
        <c:when test="${empty dash_key_build_life_workflow_summaries}">
          
        </c:when>
        <c:otherwise>
          <table class="data-table" width="100%">
            <tbody>
              <tr>
                <th scope="col"><ucf:checkbox name="selectAll" onclick="checkOrUncheckAll(this.form, '${WebConstants.WORKFLOW_CASE_ID}', true)"/></th>
                <th scope="col" align="left" valign="middle" width="10%">${ub:i18n("Build")}</th>
                <th scope="col" align="left" valign="middle" width="24%">${ub:i18n("Project")}</th>
                <th scope="col" align="left" valign="middle" width="24%">${ub:i18n("Process")}</th>
                <th scope="col" align="left" valign="middle" width="17%">${ub:i18n("LatestStamp")}</th>
                <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("ProcessStatus")}</th>
                <th scope="col" align="left" valign="middle" width="15%">${ub:i18n("EndDate")}</th>
              </tr>
              <% eo.setEven(); %>
              <%
                Map writeProjects = new HashMap();
                BuildLifeWorkflowCaseSummary[] summaries = (BuildLifeWorkflowCaseSummary[])request.getAttribute(SearchTasks.KEY_BUILD_LIFE_WORKFLOW_SUMMARIES);
                for (int i = 0; i < summaries.length; i++) {
                    BuildLifeWorkflowCaseSummary curBLS = summaries[i];
                    Long projectId = curBLS.getProjectId();
                    Boolean canWrite = (Boolean)writeProjects.get(projectId);
                    if (projectId != null && canWrite == null) {
                        Handle projectHandle = new Handle(Project.class, projectId);
                        boolean writePerm = Authority.getInstance().hasPermission(projectHandle, UBuildAction.PROJECT_EDIT);
                        canWrite = Boolean.valueOf(writePerm);
                        writeProjects.put(projectId, canWrite);
                    }
                    pageContext.setAttribute("canWrite", canWrite);
                }
              %>
              <c:forEach var="curBLS" items="${dash_key_build_life_workflow_summaries}">
                <c:url var="buildLifeUrlId" value="${BuildLifeTasks.viewBuildLife}">
                  <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${curBLS.buildLifeId}"/>
                </c:url>

                <c:url var="projectUrlId" value="${ProjectTasks.viewDashboard}">
                  <c:param name="${WebConstants.PROJECT_ID}" value="${curBLS.projectId}"/>
                </c:url>

                <c:url var="workflowUrl" value="${WorkflowTasks.viewDashboard}">
                  <c:param name="workflowId" value="${curBLS.workflowId}"/>
                </c:url>

                <tr class="<%=eo.getNext()%>">
                  <td align="center" nowrap="nowrap">
                    <c:choose>
                      <c:when test="${canWrite != null and !canWrite}">
                        <%-- placeholder --%>&nbsp;
                      </c:when>
                      <c:when test="${not empty curBLS.parentBuildLives}">
                        In Use
                      </c:when>
                      <c:when test="${empty curBLS.parentBuildLives}">
                        <input type="checkbox" class="checkbox" name="${WebConstants.WORKFLOW_CASE_ID}" value="${curBLS.caseId}"/>
                        <c:set var="showButtons" value="true"/>
                      </c:when>
                      <c:otherwise>
                        In Use
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td align="left">
                    <c:if test="${!curBLS.buildLifeActive}">
                      <img alt="" src="${fn:escapeXml(imgUrl)}/tombstone-small.png">
                    </c:if>
                    <a href="${fn:escapeXml(buildLifeUrlId)}">${curBLS.buildLifeId}</a>
                  </td>
                  <td align="left"><a href="${fn:escapeXml(projectUrlId)}"><c:out value="${curBLS.projectName}"/></a></td>
                  <td align="left">
                      <a href="${fn:escapeXml(workflowUrl)}"><c:out value="${curBLS.workflowName}"/></a>
                  </td>
                  <td align="left"><c:out value="${curBLS.latestStamp}"/></td>
                  <td align="center" style="background-color: <c:out value="${curBLS.statusColor}"/>;"><c:out value="${ub:i18n(curBLS.status.name)}"/></td>
                  <td align="left">
                    ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, curBLS.endDate))}
                  </td>
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
<c:import url="/WEB-INF/jsps/search/_footer.jsp"/>
