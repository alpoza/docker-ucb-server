<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.integration.maven.MavenSettingsTasks"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.integration.maven.MavenSettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
<c:url var="createRepositoryUrl" value="${MavenSettingsTasks.newRepository}"/>
<c:url var="iconDeleteRepositoryUrl" value="/images/icon_delete.gif"/>

<div class="data-table_container">

  <table class="data-table">
    <caption>${ub:i18n("MavenRepositories")}</caption>
    <thead>
      <tr>
        <th scope="col" width="25%">${ub:i18n("Name")}</th>
        <th scope="col" width="25%">${ub:i18n("URL")}</th>
        <th scope="col" width="40%">${ub:i18n("Description")}</th>
        <th scope="col" width="10%">${ub:i18n("Actions")}</th>
      </tr>
    </thead>
    <tbody>
      <error:field-error field="error"/>
      <c:if test="${empty repositories}">
        <tr bgcolor="#ffffff"><td colspan="4">${ub:i18n("MavenNoMavenReposMessage")}</td></tr>
      </c:if>

      <c:forEach var="repo"items="${repositories}" varStatus="status" >
        <c:url var="viewRepositoryUrl" value="${MavenSettingsTasks.editRepository}">
          <c:param name="repoId" value="${repo.id}"/>
        </c:url>
                     
        <c:url var="deleteRepositoryUrl" value="${MavenSettingsTasks.deleteRepository}">
          <c:param name="repoId" value="${repo.id}"/>
        </c:url>
                      
        <tr bgcolor="#ffffff">
          <td style="white-space: nowrap">
            <ucf:link href="javascript:showPopup('${ah3:escapeJs(viewRepositoryUrl)}',800,500);" label="${repo.name}"/>
          </td>
          <td style="white-space: nowrap">${fn:escapeXml(repo.url)}</td>
          <td style="white-space: pre">${fn:escapeXml(repo.description)}</td>
          <td align="center">
            <ucf:deletelink href="${deleteRepositoryUrl}" img="${iconDeleteRepositoryUrl}" label="${ub:i18n('Delete')}" name="${repo.name}" enabled="${!param.disabled}"/>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
  <div style="margin: 1em 0em">
    <ucf:button name="CreateRepository" label="${ub:i18n('CreateRepository')}" submit="${false}"
                onclick="showPopup('${ah3:escapeJs(createRepositoryUrl)}',800,500)" 
                enabled="${!param.disabled}"/>
    <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </div>
</div>