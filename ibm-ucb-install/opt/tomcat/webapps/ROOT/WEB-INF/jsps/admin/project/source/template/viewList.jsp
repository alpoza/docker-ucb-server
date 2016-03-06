<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.security.TeamTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.TeamTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<c:url var="iconEditUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconCopyUrl" value="/images/icon_copy_project.gif"/>
<c:url var="iconUsageUrl" value="/images/icon_magnifyglass.gif"/>

<c:set var="disableButtons" value="${team != null}"/>

<auth:checkAction var="canCreateTemplates" action="${UBuildAction.PROCESS_TEMPLATE_CREATE}"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
        <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
        <c:set var="inViewMode" value="true"/>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/jsps/admin/config/mainConfigurationTabsHeader.jsp">
  <jsp:param name="title" value="${ub:i18n('SourceTemplates')}"/>
  <jsp:param name="selected" value="Source"/>
</jsp:include>

<c:url var="templateTasksUrl" value="/tasks/admin/project/source/template/SourceConfigTemplateTasks"/>

    <div class="contents">
      <br/>
        <error:field-error field="${WebConstants.ERRORS}" cssClass="${eo.next}"/>
        <div class="component-heading">
          <div style="float: right;">
            <c:if test="${canCreateTemplates}">
              <c:url var="createTemplateUrl" value="${SourceConfigTemplateTasks.newSourceConfigTemplate}"/>
              <ucf:link href="#" klass="button" onclick="showPopup('${createTemplateUrl}', 800, 400); return false;"
                        label="${ub:i18n('Create')}" enabled="${!disableButtons}"/>
              <c:url var="importTemplateUrl" value="${ImportExportTasks.viewImportForm}"/>
              <ucf:link href="#" klass="button" onclick="showPopup('${importTemplateUrl}', 800, 400); return false;"
                        label="${ub:i18n('Import')}" enabled="${!disableButtons}"/>
            </c:if>
          </div>
          ${ub:i18n("SourceTemplates")}
        </div>
        <div id="sourceConfigTemplateList"></div>
        <script type="text/javascript">
            require(["ubuild/module/UBuildApp", "ubuild/table/SourceTemplatesTable"], function(UBuildApp, SourceTemplatesTable) {
                UBuildApp.util.i18nLoaded.then(function() {
                    var table = new SourceTemplatesTable({ "tasksUrl": "${templateTasksUrl}" });
                    table.placeAt("sourceConfigTemplateList");
                });
            });
        </script>
        <br/>
    </div>
<jsp:include page="/WEB-INF/jsps/admin/config/mainConfigurationTabsFooter.jsp" />
