<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.security.ResourceTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub" uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" useConversation="false"/>

<c:url var="securityUrl" value='${ResourceTasks.viewResource}'/>

<c:set var="onDocumentLoad" scope="request">
  /* <![CDATA[ */
    require(["ubuild/module/UBuildApp", "ubuild/template/TemplateManager"], function(UBuildApp, TemplateManager) {
      UBuildApp.util.i18nLoaded.then(function() {
        var url = bootstrap.restUrl + "/templates";
        var d = dojo.xhr.get({
          url: url,
          handleAs: "json",
          load: function(data) {
            oldWidget = new TemplateManager({
              templates: data,
              url: url,
              securityUrl: "${securityUrl}",
              canCreate: true,
              canEdit: true,
              canView: true
            });
            oldWidget.placeAt("templateManager");
          }
        });
      });
    });
  /* ]]> */
</c:set>

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('Templates')}"/>
    <c:param name="selected" value="projects"/>
    <c:param name="headContent">
        <script type="text/javascript">
            var oldWidget;
        </script>
    </c:param>
</c:import>

<script type="text/javascript">
function selectTemplates(type) {
    var url;
    switch (type) {
        case "project" :
            url = bootstrap.restUrl + "/templates";
            break;
        case "buildProcess" :
            url = bootstrap.restUrl + "/buildProcessTemplates";
            break;
        case "secondaryProcess" :
            url = bootstrap.restUrl + "/secondaryProcessTemplates";
            break;
        case "sourceConfig" :
            url = bootstrap.restUrl + "/sourceTemplates";
            break;
        case "workflow" :
            url = bootstrap.restUrl + "/workflows";
            break;
    }

    createTemplateManager(type, url);
}

function createTemplateManager(type, url) {
    require(["ubuild/module/UBuildApp", "dojo/dom-construct", "ubuild/template/TemplateManager"],
        function(UBuildApp, domConstruct, TemplateManager) {
        UBuildApp.util.i18nLoaded.then(function() {
            if (!!oldWidget) {
                oldWidget.destroy();
                oldWidget = null;
            }

            var d = dojo.xhr.get({
                url: url,
                handleAs: "json",
                load: function(data) {
                    oldWidget = new TemplateManager({
                        templates: data,
                        type: type,
                        url: url,
                        securityUrl: "${securityUrl}",
                        canCreate: true,
                        canEdit: true,
                        canView: true
                    });
                    oldWidget.placeAt("templateManager");
                }
            });
        });
    });
}
</script>

<div>
    <div class="tabManager" id="secondLevelTabs">
        <c:url var="viewProjectTemplatesUrl" value="${ProjectTasks.viewTemplates}" />
        <ucf:link href="#project" klass="selected tab" label="Project" onclick="selectTemplates('project')"/>
        <ucf:link href="#buildProcess" klass="${type == 'buildProcess' ? 'selected tab' : 'tab'}" label="Build Process" onclick="selectTemplates('buildProcess')"/>
        <ucf:link href="#secondaryProcess" klass="${type == 'secondaryProcess' ? 'selected tab' : 'tab'}" label="Secondary Process" onclick="selectTemplates('secondaryProcess')"/>
        <ucf:link href="#sourceConfig" klass="${type == 'sourceConfig' ? 'selected tab' : 'tab'}" label="Source Config" onclick="selectTemplates('sourceConfig')"/>
        <ucf:link href="#workflow" klass="${type == 'workflow' ? 'selected tab' : 'tab'}" label="Workflow" onclick="selectTemplates('workflow')"/>
    </div>

    <div class="contents"><br/>
        <!--<div class="component-heading">${ub:i18n("ProjectTemplates")}</div>-->
        <div class="template-manager" id="templateManager"></div>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
