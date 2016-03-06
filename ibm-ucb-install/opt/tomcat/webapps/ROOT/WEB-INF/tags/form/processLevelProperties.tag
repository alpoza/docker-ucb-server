<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ tag body-content="empty" %>
<%@ tag import="com.urbancode.air.plugin.server.PluginFactory" %>
<%@ tag import="com.urbancode.air.plugin.server.AutomationPlugin" %>
<%@ tag import="com.urbancode.air.property.prop_sheet_def.PropSheetDef" %>
<%@ tag import="com.urbancode.commons.util.CollectionUtil" %>
<%@ tag import="com.urbancode.commons.util.StringUtil" %>
<%@ tag import="com.urbancode.ubuild.domain.buildlife.BuildLife" %>
<%@ tag import="com.urbancode.ubuild.domain.project.Project" %>
<%@ tag import="com.urbancode.ubuild.domain.workflow.ComputedWorkflowPropertyState" %>
<%@ tag import="com.urbancode.ubuild.domain.workflow.ComputedWorkflowPropertyStateMap" %>
<%@ tag import="com.urbancode.ubuild.domain.workflow.ProcessLevelPropertyTemplate" %>
<%@ tag import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@ tag import="com.urbancode.ubuild.domain.workflow.WorkflowUserOverrideablePropertyHelper" %>
<%@ tag import="com.urbancode.ubuild.runtime.scripting.LookupContext" %>
<%@ tag import="com.urbancode.ubuild.web.WebConstants" %>
<%@ tag import="com.urbancode.ubuild.web.controller.Form" %>
<%@ tag import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ tag import="com.urbancode.ubuild.web.util.FormErrors" %>
<%@ tag import="java.util.*" %>
<%@ tag import="org.apache.commons.lang3.StringUtils" %>

<%@attribute name="isNew"                      required="true"  type="java.lang.Boolean"%>
<%@attribute name="workflow"                   required="true"  type="com.urbancode.ubuild.domain.workflow.Workflow"%>
<%@attribute name="buildLife"                  required="false"  type="com.urbancode.ubuild.domain.buildlife.BuildLife"%>
<%@attribute name="propertyList"               required="false" type="java.util.List"%>
<%@attribute name="configuredPropertyValueMap" required="false" type="java.util.Map"%>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%!
    protected String getFieldName(String propName) {
        return "property:" + propName;
    }
%>
<%
    EvenOdd eo = new EvenOdd();
    String eoStart = request.getParameter("eo");
    if ("odd".equals(eoStart)) {
        eo.setOdd();
    } else {
        eo.setEven();
    }
    
    jspContext.setAttribute("eo", eo);
    jspContext.setAttribute("inEditMode", request.getParameter("inEditMode"));

    FormErrors errors = (FormErrors) jspContext.findAttribute("errors");
    if (errors == null) {
        errors = new FormErrors();
    }
    
    Workflow workflow = (Workflow) jspContext.findAttribute("workflow");
    WorkflowUserOverrideablePropertyHelper myHelper = new WorkflowUserOverrideablePropertyHelper(workflow);
    
    LookupContext lookupContext = new LookupContext(workflow.getProject(), workflow);

    BuildLife buildLife = (BuildLife) jspContext.findAttribute("buildLife");
    if (buildLife != null) {
        myHelper.setBuildLife(buildLife);
        lookupContext.setBuildLife(buildLife);
    }
    
    LookupContext.bind(lookupContext);
    try {
        /**
         *  The current user-selected value for the property name
         */
        Map<String, String> prop2SelectedValue = new HashMap<String, String>();
                 
        // set the configured values
        prop2SelectedValue.putAll(configuredPropertyValueMap);

        // set the selected values from the last submission
        boolean hasUserValues = "post".equalsIgnoreCase(request.getMethod());
        if (hasUserValues) {
            List<ProcessLevelPropertyTemplate> propertyList =
                    (List<ProcessLevelPropertyTemplate>) jspContext.findAttribute("propertyList");
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
    
        jspContext.setAttribute("propertyName2State", derivedStates);
        jspContext.setAttribute("prop2SelectedValue", prop2SelectedValue);
    }
    finally {
        LookupContext.unbind();
    }

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
    }
%>

<ucf:templatedProperties propertyList="${propertyList}"
    propertyName2State="${propertyName2State}"
    prop2SelectedValue="${prop2SelectedValue}"
    configuredPropertyValueMap="${configuredPropertyValueMap}"
    isNew="${isNew}"
    inEditMode="true"/>
