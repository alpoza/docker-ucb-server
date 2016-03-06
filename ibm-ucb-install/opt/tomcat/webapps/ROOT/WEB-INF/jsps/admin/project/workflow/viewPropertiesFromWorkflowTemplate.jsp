<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyValue" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyTemplateValueHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplateProperty" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.template.WorkflowTemplatePropertyConfigurationHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.ScriptedWorkflowPropertyHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.DynamicWorkflowPropertyHelper" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.JobExecutionWorkflowPropertyHelper" %>
<%@ page import="com.urbancode.air.i18n.TranslateMessage" %>
<%@ page import="com.urbancode.ubuild.runtime.scripting.LookupContext" %>
<%@ page import="com.urbancode.ubuild.web.controller.Form" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.util.FormErrors" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="com.urbancode.air.property.prop_sheet.PropSheet" %>
<%@ page import="com.urbancode.air.property.prop_sheet.PropSheetFactoryRegistry" %>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
    Workflow workflow = (Workflow) pageContext.findAttribute(WebConstants.WORKFLOW);
    WorkflowTemplate workflowTemplate = (WorkflowTemplate) pageContext.findAttribute(WebConstants.WORKFLOW_TEMPLATE);
    /**
     *  The current configured properties on the project
     */
    Map<String, String> prop2WorkflowValue = new HashMap<String, String>();
    if (workflow != null) {
        if (workflowTemplate == null) {
            workflowTemplate = workflow.getTemplate();
        }
        for (PropertyTemplate templateProperty : workflowTemplate.getPropertyList()) {
            PropertyValue propertyValue = workflow.getPropertyValue(templateProperty.getName());
            if (propertyValue != null) {
                String value = propertyValue.getValue();
                if (templateProperty.getInterfaceType().isIntegrationPlugin() && !StringUtils.isBlank(value)) {
                    UUID propSheetId = UUID.fromString(value);
                    PropSheet propSheet = PropSheetFactoryRegistry.getFactory().getPropSheetForId(propSheetId);

                    if (propSheet != null) {
                        value = propSheet.getName();
                    }
                    else {
                        value = TranslateMessage.translate("PropertyInvalidPropGroupMessage");
                    }
                }
                prop2WorkflowValue.put(templateProperty.getName(), value);
            }
        }
    }
    pageContext.setAttribute("prop2WorkflowValue", prop2WorkflowValue);

    EvenOdd eo = new EvenOdd();
    if (Boolean.valueOf(request.getParameter("isEven"))) {
        eo.setEven();
    }
    else {
        eo.setOdd();
    }
    pageContext.setAttribute("workflowTemplate", workflowTemplate);
    pageContext.setAttribute("eo", eo);
%>

<%-- ======= --%>
<%-- CONTENT --%>
<%-- ======= --%>
<c:if test="${not workflow.inTemplateCompliance}">
  <div class="workflowDetailItem">
    <span class="error">${ub:i18n("ProcessViewOutOfComplianceMessage")}</span>
  </div>
</c:if>

<c:forEach var="property" items="${workflowTemplate.configurationPropertyList}" varStatus="propLoopStatus">
  <tr>
    <td width="15%">
      <span class="bold">
        <c:choose>
          <c:when test="${not empty property.label}">
            ${ub:i18nMessage('NounWithColon', ub:i18n(property.label))}
          </c:when>
          <c:otherwise>
            ${ub:i18nMessage('NounWithColon', property.name)}
          </c:otherwise>
        </c:choose>
        <c:if test="${property.required}">&nbsp;<span class="required-text">*</span></c:if>
      </span>
    </td>
    <td width="20%">
      <c:choose>
        <c:when test="${property.interfaceType.textSecure}">
          ${empty prop2WorkflowValue[property.name] ? '' : '****'}
        </c:when>
        <c:otherwise>
          ${fn:escapeXml(prop2WorkflowValue[property.name])}
        </c:otherwise>
      </c:choose>
    </td>
    <td><c:out value="${property.description}"/>&nbsp;</td>
  </tr>
</c:forEach>
