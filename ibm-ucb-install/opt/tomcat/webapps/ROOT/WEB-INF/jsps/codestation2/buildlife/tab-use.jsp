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
<%@page import="com.urbancode.ubuild.domain.buildlife.*" %>
<%@page import="com.urbancode.ubuild.domain.persistent.*" %>
<%@page import="com.urbancode.codestation2.domain.buildlife.*" %>
<%@page import="com.urbancode.ubuild.web.*" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@page import="java.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${buildLifeTaskClass}" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />

<%
  EvenOdd eo = new EvenOdd();
  eo.setEven();

  CodestationBuildLife buildlife = (CodestationBuildLife)pageContext.findAttribute(WebConstants.CODESTATION_BUILD_LIFE);
  Handle[] parentshandles = BuildLifeFactory.getInstance().restoreAllParentsForBuildLife(new Handle(buildlife));

  HashSet parentSet = new HashSet();
  for (int i = 0; i < parentshandles.length; i++) {
      parentSet.add(parentshandles[i].dereference());
  }
  
  BuildLife[] buildLifeArray = new BuildLife[ parentSet.size() ];
  parentSet.toArray( buildLifeArray ); parentSet = null;
  Arrays.sort( buildLifeArray, new CodestationCompatibleBuildLifeProjectNameComparator() );
  pageContext.setAttribute("parents", buildLifeArray);
%>

<c:url var="codestationBuildLifeUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}"/>

<%-- CONTENT --%>
<div class="tab-content">

  <div class="data-table_container">
        <div class="system-helpbox">${ub:i18n("CodeStationBuildLifeDependenciesHelp")}</div>
        <br/>

        <table class="data-table" >
          <tbody>
          <tr>
            <th scope="col" align="left" valign="middle">${ub:i18n("Project")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("BuildLifeDependenciesBuildDate")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("Build")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("LatestStatus")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("LatestStamp")}</th>
          </tr>
          <% eo.setEven(); %>

          <c:if test="${fn:length(parents)==0}">
            <tr class="<%=eo.getNext() %>"><td colspan="5">${ub:i18n("BuildLifeDependenciesNotInUse")}</td></tr>
          </c:if>

          <c:forEach var="life" items="${parents}">
            <c:url var="buildLifeUrlId" value="${BuildLifeTasks.viewBuildLife}">
              <c:param name="buildLifeId" value="${life.id}"/>
            </c:url>

            <c:url var="projectUrlId" value="${ProjectTasks.viewDashboard}">
              <c:param name="projectId" value="${life.profile.project.id}"/>
            </c:url>

            <tr class="<%=eo.getNext()%>">
              <td align="left" nowrap="nowrap"><a href="${fn:escapeXml(projectUrlId)}">  <c:out value="${life.codestationProject.name}" default="${ub:i18n('N/A')}"/></a></td>
              <td align="left" nowrap="nowrap">${fn:escapeXml(life.startDate)}</td>
              <td align="center" nowrap="nowrap"><a href="${fn:escapeXml(buildLifeUrlId)}"><c:out value="${life.id}" default="${ub:i18n('N/A')}"/></a></td>
              <td align="center" nowrap="nowrap">
                <c:if test="${life.latestStatus!=null}">
                  <c:out value="${life.latestStatus.status.name}" default="${ub:i18n('N/A')}"/>
                </c:if>
                <c:if test="${life.latestStatus==null}">${ub:i18n('N/A')}</c:if>
              </td>
              <td align="center" nowrap="nowrap"><c:out value="${life.latestStamp.stampValue}" default="${ub:i18n('N/A')}"/></td>
            </tr>
            </c:forEach>
          </tbody>
        </table>
    </div>
</div>
