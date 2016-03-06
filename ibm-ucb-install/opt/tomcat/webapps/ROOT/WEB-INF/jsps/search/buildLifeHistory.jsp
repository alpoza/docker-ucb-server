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
<%@ page import="com.urbancode.ubuild.domain.security.SystemFunction" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.project.*"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imgUrl" value="/images"/>

<c:import url="/WEB-INF/jsps/search/_header.jsp">
  <c:param name="selected" value="buildLifeHistory"/>
</c:import>

<%
  if (session.getAttribute(WebConstants.ERRORS) != null) {
      request.setAttribute(WebConstants.ERRORS, session.getAttribute(WebConstants.ERRORS));
      session.removeAttribute(WebConstants.ERRORS);
  }
  Map<Long, Boolean> writeProjects = new HashMap<Long, Boolean>();
  EvenOdd eo = new EvenOdd();
  boolean canDelete = SystemFunction.hasPermission(UBuildAction.DELETE_RUNTIME_HISTORY);
  pageContext.setAttribute("canDelete", Boolean.valueOf(canDelete));
%>
<div class="system-helpbox">${ub:i18n("BuildLifeHistoryHelp")}</div>
<br/>

<c:url var="actionUrl" value="${SearchTasks.viewBuildLifeHistory}"/>
<form method="get" action="${fn:escapeXml(actionUrl)}">
  <table style="margin-bottom:1em;" class="property-table">
    <tbody>
      <error:field-error field="${WebConstants.BUILD_LIFE_ID}" cssClass="${eo.next}"/>
      <tr class="even" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("ProjectWithColon")} </span></td>
        <td align="left">
           <ucf:autocomplete name="${WebConstants.PROJECT_ID}" list="${dash_key_projects}" emptyMessage="${ub:i18n('AnyProject')}"
                          selectedList="${project_list}"
                          selectedText="${searchtext}"
                          canUnselect="true"/>
        </td>
        <td><span class="inlinehelp">${ub:i18n("SearchProjectDesc")}</span></td>
      </tr>

      <tr class="odd" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("StampWithColon")} </span></td>
        <td align="left" width="20%">
          <ucf:text name="stamp" size="20" value="${param.stamp}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("SearchStampDesc")}</span>
        </td>
      </tr>

      <tr class="even" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("BuildLifeId")} </span></td>
        <td align="left" width="20%">
          <ucf:text name="buildLifeId" size="20" value="${param.buildLifeId}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("SearchBuildLifeIdDesc")}</span>
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
  <c:if test="${dash_key_workflows != null}">
      <br/>
      <br/>
      <%eo.setEven();%>
      <table class="property-table">
        <tbody>
          <tr class="<%= eo.getLast() %>" valign="top">
            <td align="left" width="15%"><span class="bold">${ub:i18n("RefineByBuildProcess")} </span></td>
            <td align="left" width="20%">
              <select name="workflowId">
                <option selected="selected" value="">--- ${ub:i18n("AllBuildProcesses")} ---</option>
                <c:forEach var="workflow" items="${dash_key_workflows}">
                  <c:choose>
                    <c:when test="${workflow.id == param.workflowId}">
                      <c:set var="selected" value="selected='selected'"/>
                    </c:when>
                    <c:otherwise>
                      <c:set var="selected" value=""/>
                    </c:otherwise>
                  </c:choose>
                  <option ${selected} value="${workflow.id}">${fn:escapeXml(workflow.name)}</option>
                </c:forEach>
              </select>
            </td>
            <td align="left">
              <ucf:button name="search" label="${ub:i18n('Refine')}"/>
            </td>
            <td>&nbsp;</td>
            </tr>
        </tbody>
      </table>
  </c:if>
</form>
<br/>

<c:if test="${not empty dash_key_build_life_summaries}">
  <c:url var="baseUrl" value="${SearchTasks.viewBuildLifeHistory}">
    <c:param name="search" value="Search" />
    <c:param name="auto-complete" value="${searchtext}" />
    <c:param name="projectId" value="${param.projectId}" />
    <c:param name="stamp" value="${param.stamp}" />
    <c:param name="workflowId" value="${param.workflowId}" />
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
  <c:url var="actionUrl" value="${SearchTasks.deleteBuildLifeFromBuildLifeTab}">
    <c:param name="search" value="Search"/>
    <c:param name="auto-complete" value="${searchtext}"/>
    <c:param name="projectId" value="${param.projectId}"/>
    <c:param name="workflowId" value="${param.workflowId}"/>
    <c:param name="resultsPerPage" value="${param.resultsPerPage}" />
    <c:param name="stamp" value="${param.stamp}"/>
    <c:param name="page" value="${param.page}"/>
  </c:url>
  <form method="post" action="${fn:escapeXml(actionUrl)}">

    <div class="dashboard-region">
      <c:if test="${fn:length(dash_key_build_life_summaries)!=0}">
        <table class="data-table" width="100%">
        <tbody>
        <tr>
          <th scope="col"><ucf:checkbox name="selectAll" onclick="checkOrUncheckAll(this.form, 'buildLifeId', this.checked)"/></th>
          <th scope="col" align="left" valign="middle">${ub:i18n("Project")}</th>
          <th scope="col" align="left" valign="middle">${ub:i18n("BuildProcess")}</th>
          <th scope="col" align="left" valign="middle">${ub:i18n("Build")}</th>
          <th scope="col" align="left" valign="middle">${ub:i18n("DateCreated")}</th>
          <th scope="col" align="center" valign="middle">${ub:i18n("LatestStatus")}</th>
          <th scope="col" align="left" valign="middle">${ub:i18n("LatestStamp")}</th>
          <th scope="col" align="left" valign="middle">${ub:i18n("UsedIn")}</th>
        </tr>
        <% eo.setEven(); %>

        <c:forEach var="summary" items="${dash_key_build_life_summaries}">
          <c:url var="buildLifeUrlId" value="${BuildLifeTasks.viewBuildLife}">
            <c:param name="buildLifeId" value="${summary.buildLifeId}"/>
          </c:url>

          <c:url var="projectUrlId" value="${ProjectTasks.viewDashboard}">
            <c:param name="projectId" value="${summary.projectId}"/>
          </c:url>

          <c:url var="workflowUrlId" value="${WorkflowTasks.viewDashboard}">
            <c:param name="workflowId" value="${summary.workflowId}"/>
          </c:url>

          <c:url var="statusHistoryUrlName" value="${SearchTasks.viewStatusHistory}">
            <c:param name="search" value="-- Any Project --"/>
            <c:param name="statusName" value="${summary.latestStatusName}"/>
          </c:url>

          <c:set var="projectId" value="${summary.projectId}"/>
          <%
            Long projectId = (Long)pageContext.findAttribute("projectId");
            Boolean canWrite = writeProjects.get(projectId);
            if (projectId != null && canWrite == null) {
                boolean writePerm = Authority.getInstance().hasPermission(
                    new Handle(Project.class, projectId), UBuildAction.PROJECT_EDIT);
                canWrite = Boolean.valueOf(writePerm);
                writeProjects.put(projectId, canWrite);
            }
            pageContext.setAttribute("canWrite", canWrite);
          %>

          <tr class="<%=eo.getNext()%>">
            <td align="center">
              <c:choose>
                <c:when test="${fn:length(summary.activeParentBuildLifeHandleArray)>0}">
                  In Use
                </c:when>
                <c:when test="${canWrite != null and !canWrite}">
                  <%-- placehoder --%>&nbsp;
                </c:when>
                <c:when test="${!canDelete}">
                  <%-- placehoder --%>&nbsp;
                </c:when>
                <c:when test="${fn:length(summary.activeParentBuildLifeHandleArray)==0}">
                  <input type="checkbox" class="checkbox" name="buildLifeId" value="${summary.buildLifeId}"/>
                  <c:set var="showButtons" value="true"/>
                </c:when>
              </c:choose>
            </td>
            <td align="left" nowrap="nowrap"><a href="${fn:escapeXml(projectUrlId)}"><c:out value="${summary.projectName}" default="${ub:i18n('N/A')}"/></a></td>
            <td align="left" nowrap="nowrap"><a href="${fn:escapeXml(workflowUrlId)}"><c:out value="${summary.workflowName}" default="${ub:i18n('N/A')}"/></a></td>
            <td align="left" nowrap="nowrap">
              <c:if test="${summary.inactive}">
                <img alt="" src="${fn:escapeXml(imgUrl)}/tombstone-small.png">
              </c:if>
              <a href="${fn:escapeXml(buildLifeUrlId)}"><c:out value="${summary.buildLifeId}" default="${ub:i18n('N/A')}"/></a>
            </td>
            <td align="left" nowrap="nowrap">
              ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, summary.date))}
            </td>
            <td align="center" nowrap="nowrap" style="background: ${summary.latestStatusColor}">
               <c:choose>
                    <c:when test="${summary.latestStatusName!=null}">
                        <c:set var="style" value="${ub:isDarkColor(summary.latestStatusColor) ? 'color: #FFFFFF' : ''}"/>
                        <a style="${style}" href="${fn:escapeXml(statusHistoryUrlName)}"><c:out value="${ub:i18n(summary.latestStatusName)}" default="${ub:i18n('N/A')}"/></a>
                    </c:when>
                    <c:otherwise>${ub:i18n('N/A')}</c:otherwise>
               </c:choose>
            </td>
            <td align="left" nowrap="nowrap"><c:out value="${summary.latestStamp}" default="${ub:i18n('N/A')}"/></td>
            <td align="left">
              <c:choose>
                <c:when test="${summary.inactive}"><span style="color:red;">${ub:i18n("Inactive")}</span></c:when>
                <c:when test="${summary.parentBuildLifeHandleArray[0]==null}">${ub:i18n('N/A')}</c:when>
                <c:otherwise>
                <c:forEach var="parent" items="${summary.parentBuildLifeHandleArray}" varStatus="status">
                  <c:url var="parentUrlId" value="${BuildLifeTasks.viewBuildLife}">
                    <c:param name="buildLifeId" value="${parent.id}"/>
                  </c:url>
                  <c:if test="${!status.first}">| </c:if> <a href="${fn:escapeXml(parentUrlId)}">${parent.id}</a>
                </c:forEach>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
          </c:forEach>
        </tbody>
        </table>
      </c:if>
      <c:if test="${fn:length(dash_key_build_life_summaries)==0}">
        ${ub:i18n("NoResultsFound")}
      </c:if>
    </div>
    <c:if test="${showButtons}">
      <div>
        <ucf:button name="Inactivate" label="${ub:i18n('Inactivate')}" title="${ub:i18n('BuildLifeHistoryInactivateButtonDesc')}"/>
        <ucf:button name="Delete" label="${ub:i18n('Delete')}" title="${ub:i18n('BuildLifeHistoryDeleteButtonDesc')}"/>
      </div>
      <br/>
      <div class="system-helpbox">
        ${ub:i18n("BuildLifeHistoryInactivateHelp")}
        ${ub:i18n("BuildLifeHistoryDeleteHelp")}
      </div>
    </c:if>
  </form>
</c:if>
<c:import url="/WEB-INF/jsps/search/_footer.jsp"/>
