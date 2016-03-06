<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>

<%@page import="com.urbancode.ubuild.domain.script.*"%>
<%@page import="com.urbancode.ubuild.domain.workdir.WorkDirScript"%>
<%@page import="com.urbancode.ubuild.domain.workdir.WorkDirScriptFactory"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.workdir.*"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error"%>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<ah3:useTasks class="com.urbancode.ubuild.web.admin.workdir.WorkDirScriptTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="saveUrl" value="${WorkDirScriptTasks.saveWorkDirScriptPopup}" />
<c:url var="cancelUrl" value="${WorkDirScriptTasks.cancelWorkDirScriptPopup}" />

<%
    pageContext.setAttribute("eo", new EvenOdd());

    WorkDirScriptFactory factory = WorkDirScriptFactory.getInstance();
    pageContext.setAttribute(WebConstants.WORK_DIR_SCRIPT_LIST, factory.restoreAll());
    WorkDirScript script = (WorkDirScript)pageContext.findAttribute(WebConstants.WORK_DIR_SCRIPT);

    String[] projectNameList = factory.getProjectNamesForWorkDirScript(script);
    pageContext.setAttribute("projectNameList", projectNameList);

    String[] jobNameList = factory.getActiveLibraryJobNamesForWorkDirScript(script);
    pageContext.setAttribute("jobConfigNameList", jobNameList);

    String[] sourceConfigNameList = factory.getSourceConfigTemplateNamesForWorkDirScript(script);
    pageContext.setAttribute("sourceConfigNameList", sourceConfigNameList);
%>


<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp" />

<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("Locations")}</a></li>
  </ul>
</div>
<div class="contents">
<form method="post" action="${fn:escapeXml(saveUrl)}">
<table class="property-table">
  <td align="right" style="border-top: 0px; vertical-align: bottom;" colspan="4"></td>
  <tbody>
    <tr class="${fn:escapeXml(eo.next)}" valign="top">
      <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")}</span></td>
      <td align="left" width="80%">${fn:escapeXml(workDirScript.name)}</td>
    </tr>

    <tr class="${fn:escapeXml(eo.next)}" valign="top">
      <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
      <td align="left" width="80%">${fn:escapeXml(workDirScript.description)}</td>
    </tr>

    <tr class="${fn:escapeXml(eo.next)}" valign="top">
      <td align="left" width="20%"><span class="bold">${ub:i18n("UsedInWithColon")}</span></td>
      <td align="left" width="80%">
        <c:if test="${!empty projectNameList}">
          ${ub:i18n("ScriptProjects")}
          <c:forEach var="name" items="${projectNameList}" varStatus="status">
            <c:if test="${!status.first}"> | </c:if>
            ${fn:escapeXml(name)}
          </c:forEach>
        </c:if>
        <c:if test="${!empty projectNameList and !empty jobConfigNameList}"><br/></c:if>
        <c:if test="${!empty jobConfigNameList}">
          ${ub:i18n("ScriptJobs")}
          <c:forEach var="name" items="${jobConfigNameList}" varStatus="status">
            <c:if test="${!status.first}"> | </c:if>
            ${fn:escapeXml(name)}
          </c:forEach>
        </c:if>
        <c:if test="${!empty projectNameList or !empty jobConfigNameList}"><br/></c:if>
        <c:if test="${!empty sourceConfigNameList}">
          ${ub:i18n("ScriptSourceConfigTemplates")}
          <c:forEach var="name" items="${sourceConfigNameList}" varStatus="status">
            <c:if test="${!status.first}"> | </c:if>
            ${fn:escapeXml(name)}
          </c:forEach>
        </c:if>
      </td>
    </tr>
  </tbody>
</table>
<br/>
<ucf:button name="Close" label="${ub:i18n('Close')}" href="${cancelUrl}" />
</form>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp" />
