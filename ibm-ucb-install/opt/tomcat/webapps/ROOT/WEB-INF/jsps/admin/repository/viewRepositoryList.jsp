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
<%@page import="com.urbancode.air.plugin.server.Plugin"%>
<%@page import="com.urbancode.air.plugin.server.PluginFactory"%>
<%@page import="com.urbancode.ubuild.domain.source.SourceConfigFactory"%>
<%@page import="com.urbancode.ubuild.domain.repository.Repository" %>
<%@page import="com.urbancode.ubuild.domain.repository.RepositoryFactory" %>
<%@page import="com.urbancode.ubuild.web.admin.repository.RepositoryTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="java.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.repository.RepositoryTasks" />

<c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

<c:url var="cancelUrl" value="${SystemTasks.viewIndex}"/>

<auth:checkAction var="canCreateRepository" action="${UBuildAction.REPO_CREATE}"/>

<%
  pageContext.setAttribute("pluginList", PluginFactory.getInstance().getLatestPlugins());
  RepositoryFactory factory = RepositoryFactory.getInstance();
%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
<jsp:param name="selected" value="system" />
<jsp:param name="title" value="${ub:i18n('SystemRepositories')}" />
</jsp:include>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('Repositories')}" href="" enabled="${false}" klass="selected tab"/>
  </div>
  <div class="contents">
    <div class="system-helpbox">${ub:i18n("RepositorySystemHelpBox")}</div>
    <c:if test="${error!=null}">
      <br />
      <div class="error">${fn:escapeXml(error)}</div>
    </c:if>
    <br />
    <c:if test="${canCreateRepository}">
    <div>
      <c:url var="newUrl" value='${RepositoryTasks.newRepository}' />
      <ucf:button name="Create New" label="${ub:i18n('CreateNewRepository')}" href="${newUrl}" />
    </div>
    <br />
    </c:if>
    <div class="data-table_container">

      <table class="data-table">
        <tbody>
          <tr>
            <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("Type")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("Description")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("UsedInProjects")}</th>
            <th scope="col" align="left" valign="middle">${ub:i18n("Actions")}</th>
          </tr>

          <c:forEach var="repo" items="${repository_list}">
            <auth:check persistent="repo" var="canEditOrDeleteRepository" action="${UBuildAction.REPO_EDIT}"/>

            <c:url var="viewUrl" value='${RepositoryTasks.viewRepository}'>
              <c:param name="repositoryId" value="${repo.id}" />
            </c:url>

            <%
              Repository repo = (Repository) pageContext.findAttribute("repo");
              pageContext.setAttribute("usedIn", factory.getActiveProjectNamesForRepository(repo));
            %>

            <tr bgcolor="#ffffff">
              <td nowrap="nowrap"><a href="${fn:escapeXml(viewUrl)}">${fn:escapeXml(repo.name)}</a></td>
              <td>${fn:escapeXml(repo.plugin.name)}</td>
              <td>${fn:escapeXml(repo.description)}</td>
              <td><c:forEach var="projectName" items="${usedIn}" varStatus="status">
                  <c:if test="${!status.first}"> | </c:if>
                  <c:out value="${projectName}" />
                </c:forEach></td>
              <td align="center" nowrap="nowrap"><ucf:link href="${viewUrl}" img="${iconMagnifyGlassUrl}"
                  label="${ub:i18n('View')}" />
                  <c:if test="${canEditOrDeleteRepository}">
                    <c:url var="deleteUrl" value='${RepositoryTasks.deleteRepository}'>
                      <c:param name="repositoryId" value="${repo.id}" />
                    </c:url>
                    &nbsp;<ucf:deletelink href="${deleteUrl}" name="${repo.name}" label="${ub:i18n('Delete')}"
                    img="${iconDeleteUrl}" enabled="${empty usedIn}" />
                  </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <c:if test="${hasInactiveRepo}">
        <div class="error" style="margin-top: 0.5em">${ub:i18n("RepositoryInactivePluginMessage")}</div>
      </c:if>
    </div>
    <br />
    <div>
      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${cancelUrl}" />
    </div>
    <br />
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
