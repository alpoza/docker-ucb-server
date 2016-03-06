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

<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@page import="com.urbancode.ubuild.domain.workdir.WorkDirScript"%>
<%@page import="com.urbancode.ubuild.domain.workdir.WorkDirScriptFactory"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.workdir.WorkDirScriptTasks"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<%@taglib prefix="error" uri="error" %>
<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.workdir.WorkDirScriptTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconCopyUrl" value="/images/icon_copy_project.gif"/>
<c:url var="iconActiveUrl" value="/images/icon_active.gif"/>
<c:url var="iconInactiveUrl" value="/images/icon_inactive.gif"/>

<c:set var="showWhereScriptIsUsedPopupBase" value='<%=new WorkDirScriptTasks().methodUrl("viewWhereScriptIsUsedPopup", false)%>'/>
<c:set var="editUrlBase" value='<%=new WorkDirScriptTasks().methodUrl("viewWorkDirScriptPopup", false)%>'/>
<c:set var='deleteUrlBase' value='<%=new WorkDirScriptTasks().methodUrl("deleteWorkDirScript", false)%>'/>

<c:url var="newUrl"    value='<%=new WorkDirScriptTasks().methodUrl("newWorkDirScriptPopup", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%
  WorkDirScriptFactory factory = WorkDirScriptFactory.getInstance();
  pageContext.setAttribute(WebConstants.WORK_DIR_SCRIPT_LIST, factory.restoreAll());

  boolean canEdit = (Authority.getInstance().hasPermission(UBuildAction.SCRIPT_ADMINISTRATION));
  pageContext.setAttribute("canEdit", Boolean.valueOf(canEdit));
%>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemWorkingDirectoryScriptList')}"/>
  <jsp:param name="selected" value="system"/>
</jsp:include>

<script type="text/javascript">
  function refresh() {
     window.location.reload();
  }
</script>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('WorkingDirectoryScripts')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">
          ${ub:i18n("WorkDirSystemHelpBox")}
        </div>
        <c:if test="${!empty param.error}">
            <br/><div class="error"><c:out value="${param.error}"/></div>
        </c:if>
        <br/>

      <error:field-error field="conflict"/>
      <c:if test="${canEdit}">
        <div>
          <ucf:button onclick="showPopup('${ah3:escapeJs(newUrl)}', 1000, 400)" name="Create New" label="${ub:i18n('CreateNewScript')}"/>
        </div>
        <br/>
      </c:if>

      <div class="data-table_container">
        <table id="workDirScriptTable" class="data-table">
          <tbody>
            <tr>
              <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
              <th scope="col" align="left">${ub:i18n("Description")}</th>
              <th scope="col" align="left">${ub:i18n("InUse")}</th>
              <th scope="col" align="left" width="10%">${ub:i18n("Actions")}</th>
            </tr>

            <c:choose>
              <c:when test="${fn:length(workDirScriptList)==0}">
                <tr bgcolor="#ffffff">
                  <td colspan="4">${ub:i18n("NoScriptsConfiguredMessage")}</td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="script" items="${workDirScriptList}">

                  <%
                    WorkDirScript script = (WorkDirScript)pageContext.findAttribute("script");

                    boolean isUsed = factory.isUsedWorkDirScript(script);
                    pageContext.setAttribute("isUsed",isUsed);
                  %>
                  <c:url var='showWhereScriptIsUsedPopup' value="${showWhereScriptIsUsedPopupBase}">
                    <c:param name="${WebConstants.WORK_DIR_SCRIPT_ID}" value="${script.id}"/>
                  </c:url>
                  <c:url var='editUrlIdx' value="${editUrlBase}">
                    <c:param name="${WebConstants.WORK_DIR_SCRIPT_ID}" value="${script.id}"/>
                  </c:url>
                  <c:url var="copyWorkDirUrl" value="${WorkDirScriptTasks.copyWorkDirScript}">
                    <c:param name="${WebConstants.WORK_DIR_SCRIPT_ID}" value="${script.id}"/>
                  </c:url>
                  <c:url var='deleteUrlId' value="${deleteUrlBase}">
                    <c:param name="${WebConstants.WORK_DIR_SCRIPT_ID}" value="${script.id}"/>
                  </c:url>

                  <tr bgcolor="#ffffff">
                    <td align="left" height="1" nowrap="nowrap">
                      <ucf:link href="javascript:showPopup('${ah3:escapeJs(editUrlIdx)}',1000,400);" label="${ub:i18n(script.name)}" enabled="${canEdit}"/>
                    </td>

                    <td align="left" height="1">
                      ${fn:escapeXml(ub:i18n(script.description))}
                    </td>

                    <td>
                      <%
                        String[] projectNameList = factory.getProjectNamesForWorkDirScript(script);
                        pageContext.setAttribute("projectNameList", projectNameList);

                        String[] jobNameList = factory.getActiveLibraryJobNamesForWorkDirScript(script);
                        pageContext.setAttribute("jobConfigNameList", jobNameList);

                        String[] sourceConfigNameList = factory.getSourceConfigTemplateNamesForWorkDirScript(script);
                        pageContext.setAttribute("sourceConfigNameList", sourceConfigNameList);
                      %>
                      <c:forEach var="name" items="${projectNameList}" varStatus="status">
                        <c:if test="${status.first}"><span class="bold">${ub:i18n("ScriptProjectsWithColon")}</span> </c:if> ${fn:escapeXml(name)} <c:if test="${!status.last}"> | </c:if>
                      </c:forEach>
                      <c:if test="${!empty projectNameList and !empty jobConfigNameList}"><br/></c:if>
                      <c:forEach var="name" items="${jobConfigNameList}" varStatus="status">
                        <c:if test="${status.first}"><span class="bold">${ub:i18n("ScriptJobsWithColon")}</span> </c:if> ${fn:escapeXml(name)} <c:if test="${!status.last}"> | </c:if>
                      </c:forEach>
                      <c:if test="${!empty projectNameList or !empty jobConfigNameList}"><br/></c:if>
                      <c:forEach var="name" items="${sourceConfigNameList}" varStatus="status">
                        <c:if test="${status.first}"><span class="bold">${ub:i18n("ScriptSourceConfigTemplates")}</span> </c:if> ${fn:escapeXml(name)} <c:if test="${!status.last}"> | </c:if>
                      </c:forEach>
                    </td>

                    <td align="center" height="1" nowrap="nowrap"  width="10%">
                      <ucf:link href="javascript:showPopup('${ah3:escapeJs(editUrlIdx)}',1000,400);" label="${ub:i18n('View')}"
                                img="${iconMagnifyGlassUrl}" enabled="${canEdit}"/>
                      &nbsp;&nbsp;
                      <ucf:link href="${copyWorkDirUrl}" img="${iconCopyUrl}" label="${ub:i18n('CopyVerb')}" enabled="${canEdit}"/>
                      &nbsp;&nbsp;
                      <ucf:deletelink href="${deleteUrlId}" label="${ub:i18n('Delete')}" img="${iconDeleteUrl}"
                                      name="${ub:i18n(script.name)}"
                                      enabled="${(not isUsed) && canEdit}"/>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
      <br/>
      <div>
      <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
	  </div>
    </div>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
