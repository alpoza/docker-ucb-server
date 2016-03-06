<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@tag import="com.urbancode.ubuild.web.admin.step.StepDisplayName" %>
<%@attribute name="stepConfig" required="false" type="com.urbancode.ubuild.domain.step.StepConfig"%>
<%@attribute name="stepConfigClass" required="false" type="java.lang.Class"%>
<%@attribute name="pluginCommand" required="false" type="com.urbancode.air.plugin.server.PluginCommand"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    StepDisplayName displayNameHelper = new StepDisplayName();
    String displayName = null;
    if (stepConfig != null) {
        displayName = displayNameHelper.getDisplayName(stepConfig);
    }
    else if (pluginCommand != null) {
        displayName = displayNameHelper.getDisplayName(pluginCommand);
    }
    else {
        displayName = displayNameHelper.getDisplayName(stepConfigClass);
    }
    jspContext.setAttribute("displayName", displayName);
%>
<c:out value="${displayName}"/>
