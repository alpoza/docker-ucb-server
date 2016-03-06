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

<%@page import="com.urbancode.ubuild.domain.script.*"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@page import="com.urbancode.ubuild.web.admin.script.postprocess.PostProcessScriptTasks"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.script.postprocess.PostProcessScriptTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%@taglib prefix="error" uri="error" %>
<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconCopyUrl" value="/images/icon_copy_project.gif"/>

<c:set var="editUrlBase" value='<%=new PostProcessScriptTasks().methodUrl("viewScriptPopup", false)%>'/>
<c:set var="deleteUrlBase" value='<%=new PostProcessScriptTasks().methodUrl("deleteScript", false)%>'/>

<c:url var="newUrl" value='<%=new PostProcessScriptTasks().methodUrl("newScriptPopup", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%
  PostProcessScriptFactory factory = PostProcessScriptFactory.getInstance();
  pageContext.setAttribute(WebConstants.SCRIPT_LIST, factory.restoreAll());

  boolean canEdit = (Authority.getInstance().hasPermission(UBuildAction.SCRIPT_ADMINISTRATION));
  pageContext.setAttribute("canEdit", Boolean.valueOf(canEdit));
%>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemScriptableResourceList')}"/>
  <jsp:param name="selected" value="system"/>
</jsp:include>

<script type="text/javascript">
  function refresh() {
     window.location.reload();
  }
</script>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('PostProcessingScripts2')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">
            ${ub:i18n("PostProcessingScriptsSystemHelpBox")}
        </div>
      <c:if test="${!empty error}">
        <br/><div class="error">${fn:escapeXml(error)}</div>
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
        <table class="data-table">
          <tbody>
            <tr>
              <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
              <th scope="col" align="left">${ub:i18n("Description")}</th>
              <th scope="col" align="left">${ub:i18n("UsedIn")}</th>
              <th scope="col" align="left" width="10%">${ub:i18n("Actions")}</th>
            </tr>

            <c:choose>
              <c:when test="${empty scriptList}">
                <tr bgcolor="#ffffff">
                  <td colspan="4">${ub:i18n("PostProcessScriptNoneConfiguredMessage")}</td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="tempscript" items="${scriptList}">
                  <%
                    PostProcessScript script = (PostProcessScript)pageContext.findAttribute("tempscript");

                    String[] projectNameList = factory.getActiveProjectNamesForPostProcessScript(script);
                    pageContext.setAttribute("projectNameList", projectNameList);

                    String[] jobNameList = factory.getActiveLibraryJobNamesForPostProcessScript(script);
                    pageContext.setAttribute("jobConfigNameList", jobNameList);
                  %>

                  <c:url var='editUrlIdx' value="${editUrlBase}">
                    <c:param name="${WebConstants.SCRIPT_ID}" value="${tempscript.id}"/>
                  </c:url>

                  <c:url var="copyScriptUrl" value="${PostProcessScriptTasks.copyScript}">
                    <c:param name="${WebConstants.SCRIPT_ID}" value="${tempscript.id}"/>
                  </c:url>

                  <c:url var='deleteUrlId' value="${deleteUrlBase}">
                    <c:param name="${WebConstants.SCRIPT_ID}" value="${tempscript.id}"/>
                  </c:url>

                  <tr bgcolor="#ffffff">
                    <td align="left" height="1" nowrap="nowrap">
                      <ucf:link href="javascript:showPopup('${ah3:escapeJs(editUrlIdx)}',1000,400);" label="${ub:i18n(tempscript.name)}" enabled="${canEdit}"/>
                    </td>

                    <td align="left" height="1">
                      ${fn:escapeXml(ub:i18n(tempscript.description))}
                    </td>

                    <td>
                      <c:if test="${!empty projectNameList}">
                        <span class="bold">${ub:i18n("ScriptProjectsWithColon")}</span>
                        <c:forEach var="projectName" items="${projectNameList}" varStatus="status">
                          <c:if test="${!status.first}"> | </c:if>
                            <c:out value="${projectName}"/>
                        </c:forEach>
                      </c:if>
                      <c:if test="${!empty projectNameList and !empty jobConfigNameList}"><br/></c:if>
                      <c:if test="${!empty jobConfigNameList}">
                        <span class="bold">${ub:i18n("ScriptJobsWithColon")}</span>
                        <c:forEach var="name" items="${jobConfigNameList}" varStatus="status">
                          <c:if test="${!status.first}"> | </c:if>
                          ${fn:escapeXml(name)}
                        </c:forEach>
                      </c:if>
                    </td>

                    <td align="center" height="1"  width="10%">
                      <ucf:link href="javascript:showPopup('${fn:escapeXml(editUrlIdx)}',1000,400);"
                          label="${ub:i18n('View')}" img="${iconMagnifyGlassUrl}"
                          enabled="${canEdit}"/>&nbsp;
                      <ucf:link href="${copyScriptUrl}" img="${iconCopyUrl}" label="${ub:i18n('CopyVerb')}" enabled="${canEdit}"/>
                      <c:if test="${tempscript.deletable && canEdit}">
                          &nbsp;
                          <ucf:deletelink href="${deleteUrlId}"
                            label="${ub:i18n('Delete')}" img="${iconDeleteUrl}"
                            name="${ub:i18n(tempscript.name)}"
                            enabled="${empty projectNameList && empty jobConfigNameList}"/>
                      </c:if>
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
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
