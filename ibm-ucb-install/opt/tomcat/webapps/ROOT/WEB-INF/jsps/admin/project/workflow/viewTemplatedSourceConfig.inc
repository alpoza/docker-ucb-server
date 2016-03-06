<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLife" %>
<%@ page import="com.urbancode.ubuild.domain.property.Property" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyTemplateValueHelper" %>
<%@ page import="com.urbancode.ubuild.domain.source.template.SourceConfigTemplate" %>
<%@ page import="com.urbancode.ubuild.domain.source.template.SourceConfigTemplatePropertyConfigurationHelper" %>
<%@ page import="com.urbancode.ubuild.domain.source.template.TemplatedSourceConfig" %>
<%@ page import="com.urbancode.ubuild.runtime.scripting.LookupContext" %>
<%@ page import="com.urbancode.ubuild.web.controller.Form" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.util.FormErrors" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<%
    TemplatedSourceConfig sourceConfig = (TemplatedSourceConfig) pageContext.findAttribute(WebConstants.SOURCE_CONFIG);
    SourceConfigTemplate sourceConfigTemplate = sourceConfig.getTemplate();
    /**
     *  The current configured properties on the project
     */
    Map<String, String> prop2SourceConfigValue = new HashMap<String, String>();
    if (sourceConfig != null) {
        for (PropertyTemplate templateProperty : sourceConfigTemplate.getPropertyList()) {
            Property property = sourceConfig.getProperty(templateProperty.getName());
            if (property != null) {
                prop2SourceConfigValue.put(templateProperty.getName(), property.getValue());
            }
        }
    }
    pageContext.setAttribute("prop2SourceConfigValue", prop2SourceConfigValue);

    EvenOdd eo = new EvenOdd();
    if (Boolean.valueOf(request.getParameter("isEven"))) {
        eo.setEven();
    }
    else {
        eo.setOdd();
    }
    pageContext.setAttribute("sourceConfigTemplate", sourceConfigTemplate);
    pageContext.setAttribute("eo", eo);
%>

<%-- ======= --%>
<%-- CONTENT --%>
<%-- ======= --%>
<c:if test="${not sourceConfig.inTemplateCompliance}">
  <div class="workflowDetailItem">
    <span class="error">${ub:i18n("SourceConfigViewOutOfComplianceMessage")}/span>
  </div>
</c:if>

<div class="workflowDetailItem">
  <span class="bold">${ub:i18n("RepositoryWithColon")}</span> ${fn:escapeXml(sourceConfig.repository.name)}
</div>

<c:forEach var="property" items="${sourceConfigTemplate.propertyList}" varStatus="propLoopStatus">
  <div class="workflowDetailItem">
    <span class="bold">
      <c:choose>
        <c:when test="${not empty property.label}">
          ${ub:i18nMessage('NounWithColon', ub:i18n(property.label))}
        </c:when>
        <c:otherwise>
          ${ub:i18nMessage('NounWithColon', property.name)}
        </c:otherwise>
      </c:choose>
    </span>
    <c:choose>
      <c:when test="${property.interfaceType.textSecure}">
        ****
      </c:when>
      <c:otherwise>
        ${fn:escapeXml(prop2SourceConfigValue[property.name])}
      </c:otherwise>
    </c:choose>
  </div>
</c:forEach>
