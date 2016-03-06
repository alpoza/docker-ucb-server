<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.air.property.prop_sheet_def.PropSheetDef"%>
<%@page import="com.urbancode.air.plugin.server.PluginFactory"%>
<%@page import="com.urbancode.air.plugin.server.AutomationPlugin"%>
<%@page import="com.urbancode.air.property.prop_sheet.PropSheet"%>
<%@page import="com.urbancode.air.property.prop_sheet.PropSheetFactory"%>
<%@page import="com.urbancode.air.property.prop_sheet.PropSheetFactoryRegistry"%>
<%@page import="com.urbancode.ubuild.domain.agentpool.AgentPool" %>
<%@page import="com.urbancode.ubuild.domain.agentpool.AgentPoolFactory" %>
<%@page import="com.urbancode.ubuild.domain.buildconfiguration.BuildConfiguration" %>
<%@page import="com.urbancode.ubuild.domain.workflow.ComputedWorkflowPropertyState" %>
<%@page import="com.urbancode.ubuild.domain.workflow.ComputedWorkflowPropertyStateMap" %>
<%@page import="com.urbancode.ubuild.domain.workflow.ProcessLevelPropertyTemplate" %>
<%@page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowUserOverrideablePropertyHelper" %>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowProperty" %>
<%@page import="com.urbancode.ubuild.runtime.scripting.LookupContext" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.domain.workflow.ProcessLevelPropertyTemplate" %>
<%@page import="com.urbancode.ubuild.web.controller.Form" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.commons.lang3.StringUtils" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.domain.property.PropertyValue"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imagesUrl" value="/images"/>
<c:url var="iconPencilUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconAddUrl" value="/images/icon_add.gif"/>

<c:url var="submitUrl" value="${WorkflowTasks.saveBuildConfiguration}">
  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
  <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${buildConfiguration.id}"/>
</c:url>

<c:url var="cancelUrl" value="${WorkflowTasks.cancelBuildConfiguration}">
  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
  <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${buildConfiguration.id}"/>
</c:url>

<c:url var="editUrl" value="${WorkflowTasks.editBuildConfiguration}">
  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
  <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${buildConfiguration.id}"/>
</c:url>

<c:url var="doneUrl" value="${WorkflowTasks.viewWorkflow}">
  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
</c:url>

<c:url var="viewWorkflowUrl" value='${WorkflowTasks.viewWorkflow}'/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:set var="project" value="${workflow.project}"/>
<auth:check persistent="${project}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}"/>

<%!
    protected String getFieldName(String propName) {
        return "property:" + propName;
    }
%>

<%
Workflow workflow = (Workflow) pageContext.findAttribute(WebConstants.WORKFLOW);
BuildConfiguration buildConfig = (BuildConfiguration) pageContext.findAttribute(WebConstants.BUILD_CONFIGURATION);
LookupContext lookupContext = new LookupContext(workflow.getProject(), workflow);
WorkflowUserOverrideablePropertyHelper myHelper = new WorkflowUserOverrideablePropertyHelper(workflow);

LookupContext.bind(lookupContext);
try {
    /**
     *  The current user-selected value for the property name
     */
    Map<String, String> prop2SelectedValue = new HashMap<String, String>();

    //
    // Read all currently selected values from request
    //
    boolean hasUserValues = "post".equalsIgnoreCase(request.getMethod());
    if (hasUserValues) {
        List<ProcessLevelPropertyTemplate> propertyList =
                (List<ProcessLevelPropertyTemplate>) pageContext.findAttribute("buildConfigurationProperties");
        for (ProcessLevelPropertyTemplate prop : propertyList) {
            Set<String> userValues = new LinkedHashSet<String>();
            String[] valueArray = Form.getStringValues(request, getFieldName(prop.getName()));
            if (valueArray != null) {
                Collections.addAll(userValues, valueArray);
            }
            userValues.remove("");
            userValues.remove(null);
            prop2SelectedValue.put(prop.getName(), StringUtils.join(userValues, ","));
        }
    }

    ComputedWorkflowPropertyStateMap derivedStates = myHelper.calculateAllFieldStates(prop2SelectedValue);

    // Loop through the properties. Update any computed states for Integration properties to show the name of the
    // integration instead of the UUID
    for (Map.Entry<String, ComputedWorkflowPropertyState> entry : derivedStates.entrySet()) {
        ComputedWorkflowPropertyState propState = entry.getValue();
        if (propState != null && propState.getPropertyTemplate().getInterfaceType().isIntegrationPlugin()) {
            String propValue = (String) propState.getValue();
            if (!StringUtils.isBlank(propValue)) {
                UUID pluginId = UUID.fromString(propValue);
                PropSheet pluginPropSheet = PropSheetFactoryRegistry.getFactory().getPropSheetForId(pluginId);
                propState.setValue(pluginPropSheet.getName());
                derivedStates.put(entry.getKey(), propState);
            }
        }
    }

    pageContext.setAttribute("propertyName2State", derivedStates);
    pageContext.setAttribute("prop2SelectedValue", prop2SelectedValue);
}
finally {
    LookupContext.unbind();
}
%>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/home/project/workflow/header.jsp">
  <jsp:param name="selected" value="configuration"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

  <%-- The main page content --%>
<div class="contents">
  <div class="system-helpbox" style="margin-bottom: 12px">${ub:i18n("BuildConfigSystemHelpBox")}</div>

  <%-- Field population --%>
  <c:set var="name" value="${name != null ? name : buildConfiguration.name}"/>
  <c:set var="description" value="${description != null ? description : buildConfiguration.description}"/>

  <form method="post" action="${fn:escapeXml(submitUrl)}" >
    <table class="property-table">
      <tbody>
        <error:field-error field="${WebConstants.NAME}"/>
        <tr>
          <td>
            <span class="bold">${ub:i18n("NameWithColon")}<span class="required-text">*</span></span>
          </td>
          <td colspan="3">
            <ucf:text size="60" name="name" value="${name}" enabled="${inEditMode}"/>
          </td>
        </tr>
        <error:field-error field="${WebConstants.DESCRIPTION}"/>
        <tr>
          <td>
            <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
          </td>
          <td colspan="3">
            <ucf:textarea name="description" value="${description}" enabled="${inEditMode}"/>
          </td>
        </tr>

        <tr><td colspan="4"><hr/></td></tr>

        <c:forEach var="prop" items="${buildConfigurationProperties}">

          <c:set var="propertyName" value="${prop.name}"/>
          <c:set var="propertyFieldName" value="property:${propertyName}"/>
          <c:set var="propertyDisplayName" value="${not empty prop.label ? prop.label : prop.name}"/>
          <c:set var="propertyValue" value="${not empty propertyValues[propertyFieldName]
                                              ? propertyValues[propertyFieldName]
                                              : buildConfigurationConfiguredProperties[prop.name]}"/>
          <c:choose>
            <c:when test="${prop.secure}">
              <c:if test="${not empty propertyName2State[propertyName].value}">
                <c:set var="propertyDefaultValue" value="${PropertyValue.SECURE_MASK}"/>
              </c:if>
            </c:when>
            <c:otherwise>
              <c:set var="propertyDefaultValue" value="${propertyName2State[propertyName].value}"/>
            </c:otherwise>
          </c:choose>
          <c:set var="propertyDescription" value="${prop.description}"/>
          <c:set var="propFieldEnabled" value="${inEditMode and empty buildConfigurationExpiringProperties[propertyName]}"/>

          <c:if test="${inEditMode or not empty propertyValue}">
          <error:field-error field="${propertyFieldName}"/>
            <tr>
              <td width="15%"><span class="bold">${fn:escapeXml(ub:i18nMessage('NounWithColon', propertyDisplayName))}</span></td>
              <td width="30%">

              <c:choose>
                <c:when test="${prop.interfaceType.text}">
                  <ucf:text name="${propertyFieldName}" value="${propertyValue}"
                                enabled="${propFieldEnabled}" size="60"/>
                </c:when>
                <c:when test="${prop.interfaceType.textArea}">
                  <ucf:textarea name="${propertyFieldName}" value="${propertyValue}"
                                enabled="${propFieldEnabled}" />
                </c:when>
                <c:when test="${prop.interfaceType.textSecure}">
                  <ucf:password name="${propertyFieldName}" value="${propertyValue}"
                                enabled="${propFieldEnabled}" size="30" confirm="${propFieldEnabled}"/>
                </c:when>
                <c:when test="${prop.interfaceType.select}">
                  <ucf:stringSelector name="${propertyFieldName}"
                                      list="${propertyName2State[propertyName].allowedValues}"
                                      canUnselect="true"
                                      enabled="${propFieldEnabled}"
                                      selectedValue="${propertyValue}"/>
                </c:when>
                <c:when test="${prop.interfaceType.multiSelect}">
                  <ucf:multiselect name="${propertyFieldName}"
                                   list="${propertyName2State[propertyName].allowedValues}"
                                   labels="${propertyName2State[propertyName].allowedValues}"
                                   enabled="${propFieldEnabled}"
                                   selectedValues="${not empty propertyValue ? fn:split(propertyValue, ',') : null}"/>
                </c:when>
                <c:when test="${prop.interfaceType.checkbox}">
                  <ucf:checkbox name="${propertyFieldName}" enabled="${propFieldEnabled}"
                                checked="${propertyValue}" />
                </c:when>
                <c:when test="${prop.interfaceType.integrationPlugin}">
                  <%
                    ProcessLevelPropertyTemplate property = (ProcessLevelPropertyTemplate) pageContext.getAttribute("prop");
                    UUID pluginId = UUID.fromString(property.getPluginType());
                    AutomationPlugin plugin = (AutomationPlugin) PluginFactory.getInstance().getPluginForId(pluginId);
                    PropSheetDef propSheetDef = plugin.getAutomationPropSheetDef();
                    pageContext.setAttribute("propertyGroupList", propSheetDef.getPropSheetList());
                  %>
                  <ucf:idSelector name="${propertyFieldName}"
                                  list="${propertyGroupList}"
                                  selectedId="${propertyValue}"
                                  canUnselect="true"
                                  enabled="${propFieldEnabled}"/>
                </c:when>
                <c:when test="${prop.interfaceType.agentPool}">
                  <%
                    AgentPool[] agentPools = AgentPoolFactory.getInstance().restoreAll();
                    pageContext.setAttribute("agentPoolList", agentPools);
                  %>
                  <ucf:idSelector name="${propertyFieldName}"
                                  list="${agentPoolList}"
                                  selectedId="${propertyValue}"
                                  canUnselect="true"
                                  enabled="${propFieldEnabled}"/>
                </c:when>
                <c:otherwise>
                  ${ub:i18n("BuildConfigUnrecognizedPropertyTypeError")}
                </c:otherwise>
              </c:choose>
              </td>
              <td width="10%">
                <c:if test="${not empty propertyDefaultValue}">
                  <span style="font-style:italic;">${ub:i18nMessage("BuildConfigDefaultValue", fn:escapeXml(propertyDefaultValue))}</span>
                </c:if>
              </td>
              <td width="45%">
                ${fn:escapeXml(propertyDescription)}
              </td>
          </tr>
          </c:if>
        </c:forEach>
        <c:choose>
          <c:when test="${inEditMode and empty buildConfigurationProperties}">
            <tr>
              <td colspan="4">${ub:i18n("BuildConfigNoRuntimePropsAvailableMessage")}</td>
            </tr>
          </c:when>
          <c:when test="${not inEditMode and empty buildConfigurationConfiguredProperties}">
            <tr>
              <td colspan="4">
                    ${ub:i18n("BuildConfigNoRuntimePropsConfiguredMessage")}
              </td>
            </tr>
          </c:when>
        </c:choose>

        <tr><td colspan="4"><hr/></td></tr>

        <tr>
          <td colspan="4">
            <c:choose>
              <c:when test="${inEditMode}">
                <ucf:button name="Save" label="${ub:i18n('Save')}"/>
                <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
              </c:when>
              <c:otherwise>
                <c:if test="${canEdit}"><ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}"/></c:if>
                <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>
      </tbody>
    </table>

  </form>
</div>
<jsp:include page="/WEB-INF/jsps/home/project/workflow/footer.jsp"/>

