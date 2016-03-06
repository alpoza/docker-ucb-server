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

<%@ page import="com.urbancode.ubuild.domain.project.Project" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.ProcessLevelPropertyTemplate" %>
<%@ page import="com.urbancode.ubuild.runtime.scripting.LookupContext" %>
<%@ page import="com.urbancode.ubuild.web.controller.Form" %>
<%@ page import="com.urbancode.commons.util.StringUtil" %>
<%@ page import="com.urbancode.air.property.prop_sheet_def.PropSheetDef" %>
<%@ page import="com.urbancode.air.plugin.server.PluginFactory" %>
<%@ page import="com.urbancode.air.plugin.server.AutomationPlugin" %>
<%@page import="com.urbancode.ubuild.domain.trigger.Trigger" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@page import="com.urbancode.ubuild.web.util.FormErrors" %>
<%@page import="com.urbancode.commons.util.CollectionUtil" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowUserOverrideablePropertyHelper" %>
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLife" %>
<%@page import="java.util.*" %>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>
<%
    Trigger trigger = (Trigger) pageContext.findAttribute(WebConstants.TRIGGER);

    /**
     *  The current configured properties
     */
    Map<String, String> configuredPropertyValueMap = new HashMap<String, String>();
    pageContext.setAttribute("configuredPropertyValueMap", configuredPropertyValueMap);
    if (trigger != null) {
        for (String propName : trigger.getPropertyNames()) {
            String configuredValue = trigger.getProperty(propName);
            if (configuredValue != null) {
                configuredPropertyValueMap.put(propName, configuredValue);
            }
        }
    }
%>
<ucf:processLevelProperties isNew="${trigger == null || trigger.new}"
    workflow="${trigger.workflow}"
    propertyList="${trigger.workflow.requestPropertyList}"
    configuredPropertyValueMap="${configuredPropertyValueMap}"/>
