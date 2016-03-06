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
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks"/>

<%
  Map<Long, Boolean> writeProjects = new HashMap<Long, Boolean>();
  EvenOdd eo = new EvenOdd();
%>

<c:url var="viewMiscJobsUrl" value="${SearchTasks.viewMiscJobs}"/>

<c:url var="deleteMiscJobsUrl" value="${SearchTasks.deleteMiscJobs}">
  <c:param name="search" value="Search" />
  <c:param name="auto-complete-projectSearch" value="${searchtext}" />
  <c:param name="projectId" value="${param.projectId}"/>
  <c:param name="page" value="${param.page}"/>
  <c:param name="resultsPerPage" value="${param.resultsPerPage}" />
</c:url>

<%-- CONTENT --%>

<c:import url="/WEB-INF/jsps/search/_header.jsp">
   <c:param name="selected" value="miscJobsHistory"/>
</c:import>

<div class="system-helpbox">${ub:i18n("MiscJobsHistoryHelp")}</div>
<br/>

<form method="get" action="${fn:escapeXml(viewMiscJobsUrl)}">
  <table style="margin-bottom:1em;" class="property-table">
    <tbody>
      <tr class="even" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("ProjectWithColon")} </span></td>
        <td align="left" width="20%">
          <ucf:autocomplete name="${WebConstants.PROJECT_ID}" list="${dash_key_projects}"
                   emptyMessage="${ub:i18n('AnyProject')}"
                   selectedList="${project_list}"
                   selectedText="${searchtext}"
                   canUnselect="true"/>
        </td>
        <td><span class="inlinehelp">${ub:i18n("SearchProjectDesc")}</span></td>
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
<c:if test="${dash_key_misc_jobs != null}">
  <c:url var="baseUrl" value="${SearchTasks.viewMiscJobs}">
    <c:param name="search" value="Search" />
    <c:param name="auto-complete" value="${searchtext}" />
    <c:param name="projectId" value="${param.projectId}" />
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
  <form method="post" action="${fn:escapeXml(deleteMiscJobsUrl)}">
    <div class="dashboard-region">
      <c:choose>
        <c:when test="${fn:length(dash_key_misc_jobs) > 0}">
          <table class="data-table" width="100%">
            <tbody>
              <tr>
                <th scope="col" align="center" valign="middle"><ucf:checkbox name="selectAll" onclick="checkOrUncheckAll(this.form, '${ah3:escapeJs(WebConstants.JOB_TRACE_ID)}', this.checked)"/></th>
                <th scope="col" align="left" valign="middle">${ub:i18n("Job")}</th>
                <th scope="col" align="left" valign="middle">${ub:i18n("Requester")}</th>
                <th scope="col" align="left" valign="middle">${ub:i18n("Project")}</th>
                <th scope="col" align="center" valign="middle">${ub:i18n("Status")}</th>
                <th scope="col" align="left" valign="middle">${ub:i18n("StartDate")}</th>
                <th scope="col" align="left" valign="middle">${ub:i18n("EndDate")}</th>
                <th scope="col" align="left" valign="middle">${ub:i18n("AgentName")}</th>
              </tr>
              <% eo.setEven(); %>

              <c:forEach var="jobTrace" items="${dash_key_misc_jobs}">
                <c:set var="projectId" value="${jobTrace.project.id}"/>
                <%
                  Long projectId = (Long)pageContext.findAttribute("projectId");
                  Boolean canWrite = (Boolean)writeProjects.get(projectId);
                  if (projectId != null && canWrite == null) {
                      Handle projectHandle = new Handle(Project.class, projectId);
                      boolean writePerm = Authority.getInstance().hasPermission(projectHandle, UBuildAction.PROJECT_EDIT);
                      canWrite = Boolean.valueOf(writePerm);
                      writeProjects.put(projectId, canWrite);
                  }
                  pageContext.setAttribute("canWrite", canWrite);
                %>

                <c:url var="jobTraceUrlId" value="${JobTasks.viewPlainJobTrace}">
                  <c:param name="job_trace_id" value="${jobTrace.id}"/>
                </c:url>



                <tr class="<%=eo.getNext()%>">
                  <td align="center" nowrap="nowrap" width="3%">
                    <c:choose>
                      <c:when test="${canWrite != null and !canWrite}">
                        <%-- placeholder --%>&nbsp;
                      </c:when>
                      <c:otherwise>
                        <input type="CHECKBOX" class="checkbox" name="${WebConstants.JOB_TRACE_ID}" value="${jobTrace.id}">
                        <c:set var="showButtons" value="true"/>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td align="left">
                    <a href="${jobTraceUrlId}">${jobTrace.id}
                    <c:if test="${not empty jobTrace.name}"> - ${fn:escapeXml(jobTrace.name)}</c:if>
                    </a>
                  </td>
                  <td align="left">
                    <c:out value="${jobTrace.requester.name}"/>
                  </td>
                  <td align="left">
                      ${fn:escapeXml(jobTrace.project.name)}
                  </td>
                  <td align="center" nowrap="nowrap" width="8%" style="background-color: ${fn:escapeXml(jobTrace.status.color)};">
                    <c:out value="${ub:i18n(jobTrace.status.name)}"/>
                  </td>
                  <td align="left" nowrap="nowrap" width="9%">
                    ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, jobTrace.startDate))}
                  </td>
                  <td align="left" nowrap="nowrap" width="9%">
                    ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, jobTrace.endDate))}
                  </td>
                  <td align="left" nowrap="nowrap" width="10%">
                    <c:out value="${jobTrace.agent.name}" default="${ub:i18n('Server')}"/>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:when>
        <c:otherwise>
          ${ub:i18n("NoResultsFound")}
        </c:otherwise>
      </c:choose>
    </div>
    <c:if test="${showButtons}">
      <div>
        <ucf:button name="Delete" label="${ub:i18n('Delete')}"/>
      </div>
    </c:if>
  </form>
</c:if>

<c:import url="/WEB-INF/jsps/search/_footer.jsp"/>
