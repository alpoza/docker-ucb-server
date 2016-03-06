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
<%@page import="com.urbancode.ubuild.domain.project.template.ProjectTemplate"%>
<%@page import="com.urbancode.ubuild.domain.source.template.SourceConfigTemplate"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.SourceConfigTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imagesUrl" value="/images"/>
<c:url var="iconPencilUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:url var="submitUrl" value="${SourceConfigTemplateTasks.saveSourceConfigTemplate}">
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<auth:check persistent="${WebConstants.SOURCE_CONFIG_TEMPLATE}" var="canEdit" action="${UBuildAction.SOURCE_TEMPLATE_EDIT}"/>

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
    <ul>
        <li class="current">
        <a>${empty sourceConfigTemplate ? ub:i18n("SourceConfigTemplateNew") : ub:i18n("SourceConfigTemplateEdit")}</a></li>
    </ul>
</div>
<div class="contents">
  <form method="post" action="${fn:escapeXml(submitUrl)}">
    <div style="text-align: right; border-top :0px; vertical-align: bottom;">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <table class="property-table" style="width: 100%">
      <tbody>
        <tr class="${eo.last}" valign="top">
          <td width="20%"><span class="bold">${ub:i18n("TypeWithColon")}</span></td>
          <td colspan="2"><c:out value="${sourceConfigTemplate.plugin.name}" default="${plugin.name}"/></td>
        </tr>
      </tbody>

      <c:set scope="request" var="sourceConfig" value="${sourceConfigTemplate.sourceConfig}"/>
      <c:set scope="request" var="sourceConfigForTemplate" value="true"/>
      <jsp:include page="/WEB-INF/jsps/admin/project/source/viewSourceConfig.jsp"/>

      <c:import url="/WEB-INF/snippets/admin/security/newSecuredObjectSecurityFields.jsp"/>

      <tbody>
        <tr>
          <td colspan="3">
            <ucf:button name="Save" label="${ub:i18n('Save')}"/>
            <c:url var="cancelUrl" value="${SourceConfigTemplateTasks.cancelSourceConfigTemplate}" />
            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
