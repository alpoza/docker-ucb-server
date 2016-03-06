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

<%@page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@page import="com.urbancode.ubuild.domain.buildlife.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.codestation2.domain.project.*" %>
<%@page import="com.urbancode.codestation2.domain.buildlife.*" %>

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${buildLifeTaskClass}"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%
  CodestationProject codestationProject = (CodestationProject)pageContext.findAttribute(WebConstants.CODESTATION_PROJECT);

  if (codestationProject != null) {
    CodestationBuildLife[] buildlifeArray = CodestationBuildLifeFactory.getInstance().restoreAllForProject(codestationProject);
    pageContext.setAttribute(WebConstants.CODESTATION_BUILD_LIFE_LIST, buildlifeArray);
  }
%>

<c:url var="newUrl" value="${CodestationBuildLifeTasks.newCodestationBuildLife}">
  <c:param name="${WebConstants.CODESTATION_PROJECT_ID}" value="${codestationProject.id}"/>
</c:url>

<%-- CONTENT --%>

<div class="project-component">
  <div class="component-heading">
    <div style="float:right;">
      <c:if test='${param.canWrite && param.enabled}'>
        <ucf:link label="${ub:i18n('New')}" href="${newUrl}" enabled="${param.enabled}"/>
      </c:if>
    </div>
    ${ub:i18n("Versions")}
  </div>

  <table class="data-table">
    <tbody>
      <tr>
        <th scope="col" align="left" width="25%">${ub:i18n("Stamp")}</th>
        <th scope="col" align="left" width="35%">${ub:i18n("Description")}
        <th scope="col" align="left" width="15%">${ub:i18n("LatestStatus")}</th>
        <th scope="col" align="left" width="15%">${ub:i18n("Date")}</th>
        <th scope="col" align="center" width="10%">${ub:i18n("Actions")}</th>
      </tr>
      <c:if test="${fn:length(codestationBuildLifeList)==0}">
        <tr bgcolor="#ffffff">
          <td colspan="5">${ub:i18n("NoVersions")}</td>
        </tr>
      </c:if>

      <c:forEach var="buildlife" items="${codestationBuildLifeList}">
        <c:url var="viewIdUrl" value='${CodestationBuildLifeTasks.viewCodestationBuildLife}'>
          <c:param name="${WebConstants.CODESTATION_BUILD_LIFE_ID}" value="${buildlife.id}"/>
        </c:url>

        <c:url var="deleteIdUrl" value='${CodestationBuildLifeTasks.deleteCodestationBuildLife}'>
          <c:param name="${WebConstants.CODESTATION_BUILD_LIFE_ID}" value="${buildlife.id}"/>
        </c:url>

        <c:url var="copyIdUrl" value='${CodestationBuildLifeTasks.copyBuildLife}'>
          <c:param name="${WebConstants.CODESTATION_BUILD_LIFE_ID}copySource" value="${buildlife.id}"/>
        </c:url>

        <tr bgcolor="#ffffff">
          <td align="left" height="1" nowrap="nowrap">
            <ucf:link href="${viewIdUrl}" label="${buildlife.stamp}" enabled="${param.enabled}"/>
          </td>
          <td align="left" height="1">${fn:escapeXml(buildlife.description)}</td>
          <td align="center" height="1" style="background: ${fn:escapeXml(buildlife.latestStatus.status.color)};" >
            <c:choose>
              <c:when test="${buildlife.latestStatus != null}"><span>${fn:escapeXml(ub:i18n(buildlife.latestStatus.status.name))}</span></c:when>
              <c:otherwise><span style="color: gray ;">${fn:escapeXml(ub:i18n("NoneLowercaseInBrackets"))}</span></c:otherwise>
            </c:choose>
          </td>
          <td align="center" height="1">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, buildlife.startDate))}</td>
          <td align="center" height="1" nowrap="nowrap">
          <c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
          <ucf:link href="${viewIdUrl}" label="${ub:i18n('View')}" img="${iconMagnifyGlassUrl}" enabled="${param.enabled}"/>&nbsp;

          <c:url var="iconCopyUrl" value="/images/icon_copy_project.gif"/>
          <ucf:link href="${copyIdUrl}" label="${ub:i18n('CopyVerb')}" img="${iconCopyUrl}" enabled="${param.canWrite && param.enabled}"/>&nbsp;

          <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
          <ucf:deletelink href="${deleteIdUrl}" name="${buildlife.stamp}" label="${ub:i18n('Delete')}" img="${iconDeleteUrl}"
            enabled="${param.canWrite && param.enabled && !buildlife.inUse}"/>
          </td>
        </tr>
      </c:forEach>

    </tbody>
  </table>
  <br/>
</div>
