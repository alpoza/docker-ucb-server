<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLife" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyTemplateValueHelper" %>
<%@ page import="com.urbancode.ubuild.domain.project.Project" %>
<%@ page import="com.urbancode.ubuild.domain.project.prop.ProjectProperty" %>
<%@ page import="com.urbancode.ubuild.domain.project.template.ProjectTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.project.template.ProjectTemplateProperty" %>
<%@ page import="com.urbancode.ubuild.domain.project.template.ProjectTemplatePropertyConfigurationHelper" %>
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
<%@page import="com.urbancode.air.property.prop_sheet.PropSheet" %>
<%@page import="com.urbancode.air.property.prop_sheet.PropSheetFactoryRegistry" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="updateDerivedPropertiesUrl" value="${ProjectTasks.updateDerivedPropertiesAjax}"/>
<%
    Project project = (Project) pageContext.findAttribute(WebConstants.PROJECT);
    ProjectTemplate projectTemplate = project.getTemplate();
    /**
     *  The current configured properties on the project
     */
    Map<String, String> prop2ProjectValue = new HashMap<String, String>();
    if (project != null) {
        for (PropertyTemplate templateProperty : projectTemplate.getPropertyList()) {
            ProjectProperty projectProperty = project.getProperty(templateProperty.getName());
            if (projectProperty != null) {
                String value = projectProperty.getValue();
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
                prop2ProjectValue.put(templateProperty.getName(), value);
            }
        }
    }
    pageContext.setAttribute("prop2ProjectValue", prop2ProjectValue);

    EvenOdd eo = new EvenOdd();
    if (Boolean.valueOf(request.getParameter("isEven"))) {
        eo.setEven();
    }
    else {
        eo.setOdd();
    }
    pageContext.setAttribute("projectTemplate", projectTemplate);
    pageContext.setAttribute("eo", eo);
%>

<%-- ======= --%>
<%-- CONTENT --%>
<%-- ======= --%>
<c:if test="${not project.inTemplateCompliance}">
  <tr class="${eo.next}">
    <td colspan="3">
      <span class="error">${ub:i18n("ProjectViewOutOfComplianceMessage")}</span>
    </td>
  </tr>
</c:if>

<c:forEach var="property" items="${projectTemplate.propertyList}" varStatus="propLoopStatus">
  <tr class="${eo.next}">
    <td>
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
    <c:choose>
      <c:when test="${property.interfaceType.textSecure}">
        <td>${empty prop2ProjectValue[property.name] ? '' : '****'}</td>
        <td><c:out value="${property.description}"/></td>
      </c:when>
      <c:when test="${property.interfaceType.checkbox}">
        <td>
          <ucf:checkbox name="${property.name}" value="true" checked="${prop2ProjectValue[property.name]}" enabled="false"/>
        </td>
        <td><c:out value="${property.description}"/></td>
      </c:when>
      <c:otherwise>
        <td>
           ${fn:escapeXml(prop2ProjectValue[property.name])}
        </td>
        <td><c:out value="${property.description}"/></td>
      </c:otherwise>
    </c:choose>
  </tr>
</c:forEach>
