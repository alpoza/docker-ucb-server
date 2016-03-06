<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:import url="/WEB-INF/snippets/popupHeader.jsp" />

<div style="padding-bottom: 3em;">
  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18n("SourceConfigTemplateUsage")}</a></li>
    </ul>
  </div>

  <div class="contents">
    <div style="float: right;">
      <ucf:button name="Close" label="${ub:i18n('Close')}" submit="false" onclick="parent.hidePopup(); return false;"/>
    </div>
    <div style="font-size: 16px; margin: 10px 5px;">${ub:i18nMessage("UsageFor", fn:escapeXml(sourceConfigTemplate.name))}</div>

    <div id="tableHolder" class="claro">
      <c:url var="workflowTasksUrl" value="/tasks/admin/project/workflow/WorkflowTasks" />
      <div id="templateUsage" style="width: 100%; height: 700px"></div>
      <script type="text/javascript">
          require(["ubuild/module/UBuildApp", "ubuild/table/SourceConfigTemplateUsageTable"],
              function(UBuildApp, SourceConfigTemplateUsageTable) {
              UBuildApp.util.i18nLoaded.then(function() {
                  var table = new SourceConfigTemplateUsageTable({ "tasksUrl": "${workflowTasksUrl}", "templateId": "${sourceConfigTemplate.id}"});
                  table.placeAt("templateUsage");
              });
          });
      </script>
    </div>
  </div>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp" />
