<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLife" %>
<%@ page import="com.urbancode.ubuild.domain.project.Project" %>
<%@ page import="com.urbancode.ubuild.domain.property.ComputedPropertyTemplateStateMap" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyValue" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyTemplateValueHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplateProperty" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplatePropertyConfigurationHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@ page import="com.urbancode.ubuild.runtime.scripting.LookupContext" %>
<%@ page import="com.urbancode.ubuild.web.controller.Form" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.util.FormErrors" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="com.urbancode.air.property.prop_sheet_def.PropSheetDef" %>
<%@ page import="com.urbancode.air.plugin.server.PluginFactory" %>
<%@ page import="com.urbancode.air.plugin.server.AutomationPlugin" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="updateDerivedPropertiesUrl" value="${ProjectTasks.updateDerivedPropertiesAjax}"/>
<%!
    protected String getFieldName(PropertyTemplate prop) {
        return getFieldName(prop.getName());
    }

    protected String getFieldName(String propName) {
        return "property:" + propName;
    }
%>
<%
    FormErrors errors = (FormErrors) pageContext.findAttribute("errors");
    if (errors == null) {
        errors = new FormErrors();
    }

    Workflow workflow = (Workflow) pageContext.findAttribute(WebConstants.WORKFLOW);
    WorkflowTemplate workflowTemplate = (WorkflowTemplate) pageContext.findAttribute(WebConstants.WORKFLOW_TEMPLATE);

    LookupContext lookupContext = new LookupContext();
    if (workflow != null) {
        lookupContext.setProject(workflow.getProject());
        lookupContext.setWorkflow(workflow);
    }
    else {
        lookupContext.setProject((Project) pageContext.findAttribute(WebConstants.PROJECT));
    }

    WorkflowTemplatePropertyConfigurationHelper configHelper =
            new WorkflowTemplatePropertyConfigurationHelper(workflowTemplate);

    LookupContext.bind(lookupContext);
    try {
        /**
         *  The current user-selected value for the property name
         */
        Map<String, String> prop2SelectedValue = new HashMap<String, String>();

        /**
         *  The current configured properties
         */
        Map<String, String> configuredPropertyValueMap = new HashMap<String, String>();
                 
        if (workflow != null) {
            if (workflowTemplate == null) {
                workflowTemplate = workflow.getTemplate();
            }
            for (PropertyTemplate templateProperty : workflowTemplate.getConfigurationPropertyList()) {
                PropertyValue propertyValue = workflow.getPropertyValue(templateProperty.getName());
                if (propertyValue != null) {
                    configuredPropertyValueMap.put(templateProperty.getName(), propertyValue.getValue());
                    prop2SelectedValue.put(templateProperty.getName(), propertyValue.getValue());
                }
            }
        }

        //
        // Read all currently selected values from request
        //
        boolean hasUserValues = "post".equalsIgnoreCase(request.getMethod());
        if (hasUserValues) {
            for (PropertyTemplate prop : workflowTemplate.getPropertyList()) {
                Set<String> userValues = new LinkedHashSet<String>();
                String[] valueArray = Form.getStringValues(request, getFieldName(prop));
                if (valueArray != null) {
                    Collections.addAll(userValues, valueArray);
                }
                userValues.remove("");
                userValues.remove(null);

                prop2SelectedValue.put(prop.getName(), StringUtils.join(userValues, ","));
            }
        }

        //
        // Calculate form state for properties
        //
        ComputedPropertyTemplateStateMap derivedStates = configHelper.calculateAllFieldStates(prop2SelectedValue);

        pageContext.setAttribute("propertyName2State", derivedStates);
        pageContext.setAttribute("prop2SelectedValue", prop2SelectedValue);
        pageContext.setAttribute("configuredPropertyValueMap", configuredPropertyValueMap);
    }
    finally {
        LookupContext.unbind();
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
    }

    EvenOdd eo = new EvenOdd();
    if (Boolean.valueOf(request.getParameter("isEven"))) {
        eo.setEven();
    }
    else {
        eo.setOdd();
    }
    pageContext.setAttribute("eo", eo);
%>

<%-- ======= --%>
<%-- CONTENT --%>
<%-- ======= --%>

<ucf:templatedProperties propertyList="${workflowTemplate.configurationPropertyList}"
    propertyName2State="${propertyName2State}"
    prop2SelectedValue="${prop2SelectedValue}"
    configuredPropertyValueMap="${configuredPropertyValueMap}"
    isNew="${empty workflow or workflow.new}"
    inEditMode="true"/>
