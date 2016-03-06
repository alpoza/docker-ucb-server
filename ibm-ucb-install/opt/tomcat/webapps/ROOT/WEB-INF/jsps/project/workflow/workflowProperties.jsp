<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.buildconfiguration.BuildConfiguration" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.ProcessLevelPropertyTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.ScriptedWorkflowPropertyHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.DynamicWorkflowPropertyHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.JobExecutionWorkflowPropertyHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowUserOverrideablePropertyHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplateProperty" %>
<%@ page import="com.urbancode.ubuild.runtime.scripting.LookupContext" %>
<%@ page import="com.urbancode.ubuild.web.controller.Form" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.util.FormErrors" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.commons.util.StringUtil" %>
<%@ page import="com.urbancode.air.property.prop_sheet_def.PropSheetDef" %>
<%@ page import="com.urbancode.air.plugin.server.PluginFactory" %>
<%@ page import="com.urbancode.air.plugin.server.AutomationPlugin" %>
<%@ page import="java.util.*" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>
<%
    Workflow workflow = (Workflow) pageContext.findAttribute(WebConstants.WORKFLOW);
    BuildConfiguration buildConfig = (BuildConfiguration) pageContext.findAttribute(WebConstants.BUILD_CONFIGURATION);

    /**
     *  The current configured properties
     */
    Map<String, String> configuredPropertyValueMap = new HashMap<String, String>();
    pageContext.setAttribute("configuredPropertyValueMap", configuredPropertyValueMap);
    if (buildConfig != null) {
        for (String propName : buildConfig.getProperties().keySet()) {
            String configuredValue = buildConfig.getProperty(propName);
            if (configuredValue != null) {
                configuredPropertyValueMap.put(propName, configuredValue);
            }
        }
    }
%>

<%-- ======= --%>
<%-- CONTENT --%>
<%-- ======= --%>
<c:if test="${not empty buildConfigurationList}">

  <tr class="${eo.last}" valign="top">
    <td width="20%" nowrap="nowrap">
      <span class="bold">${ub:i18n("BuildConfigurationWithColon")}</span>
    </td>
    <td colspan="2">
        <select name="${WebConstants.BUILD_CONFIGURATION_ID}" onchange="buildConfigChanged();"
                id="${WebConstants.BUILD_CONFIGURATION_ID}">
          <option value="none">${ub:i18n("None")}</option>
          <c:forEach var="buildConfig" items="${buildConfigurationList}">
            <option value="${buildConfig.id}">${fn:escapeXml(buildConfig.name)}</option>
          </c:forEach>
        </select>
    </td>
  </tr>

  <script type="text/javascript">
    /* <![CDATA[ */
    var buildConfigs = {};
    var fieldValues = {};
    var propList = {};

    <c:forEach var="buildConfig" items="${buildConfigurationList}">
      buildConfigs["${buildConfig.id}"] = {};
      buildConfigs["${buildConfig.id}"].name = '${ah3:escapeJs(buildConfig.name)}';
      buildConfigs["${buildConfig.id}"].id = '${buildConfig.id}';
      buildConfigs["${buildConfig.id}"].properties = {};

      <c:forEach var="buildConfigProp" items="${buildConfig.safeProperties}">
        buildConfigs["${buildConfig.id}"].properties["${buildConfigProp.key}"] = {};
        buildConfigs["${buildConfig.id}"].properties["${buildConfigProp.key}"].name = '${ah3:escapeJs(buildConfigProp.key)}';
        buildConfigs["${buildConfig.id}"].properties["${buildConfigProp.key}"].value ='${ah3:escapeJs(buildConfigProp.value)}';
      </c:forEach>
    </c:forEach>

    var buildConfigChanged = function() {
        var selectElement = document.getElementById('${WebConstants.BUILD_CONFIGURATION_ID}');
        var buildConfigId = selectElement.options[selectElement.selectedIndex].value;
        if (buildConfigId !== 'none') {
          var buildConfig = buildConfigs[buildConfigId];

          // Check for properties that need to become editable
          for (propName in propList) {
            var prop = propList[propName];
            var fieldName = "property:" + prop.name;
            if (buildConfig.properties[prop.name] == null && fieldValues[fieldName] != null) {
              var element = document.getElementById(fieldName);
              element.innerHTML = fieldValues[fieldName];
              delete fieldValues[fieldName];
            }
            delete propList[propName];
          }

          // Replace configured property fields with static text
          for (propName in buildConfig.properties) {
            var prop = buildConfig.properties[propName];
            propList[propName] = prop;

            var fieldName = "property:" + prop.name;
            var fieldElement = document.getElementById(fieldName);

            if (fieldElement != null) {
              if (fieldValues[fieldName] == null) {
                fieldValues[fieldName] = fieldElement.innerHTML;
              }

              var newFieldVal = "<span>" + encodeHtml(prop.value) + "</span>";
              fieldElement.innerHTML = newFieldVal;
            }
          }
        }
        else {
          // Restore all property fields
          for (propName in propList) {
            var prop = propList[propName];
            var fieldName = "property:" + prop.name;
            if (fieldValues[fieldName] != null) {
              var element = document.getElementById(fieldName);
              element.innerHTML = fieldValues[fieldName];
              delete fieldValues[fieldName];
            }
            delete propList[propName];
          }
        }
    };

    var encodeHtml = function(str) {
      return str.replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
    };
    /* ]]> */
  </script>
</c:if>

<ucf:processLevelProperties isNew="true"
    workflow="${workflow}"
    propertyList="${workflow.requestPropertyList}"
    configuredPropertyValueMap="${configuredPropertyValueMap}"/>
