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
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imagesUrl" value="/images"/>
<c:url var="iconPencilUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:url var="submitUrl" value="${SourceConfigTemplateTasks.saveSourceConfigTemplate}">
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>

<c:url var="cancelUrl" value="${SourceConfigTemplateTasks.cancelSourceConfigTemplate}">
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>

<c:url var="editUrl" value="${SourceConfigTemplateTasks.editSourceConfigTemplate}">
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>

<c:url var="exportUrl" value="${ImportExportTasks.exportSourceTemplate2File}">
  <c:param name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" value="${sourceConfigTemplate.id}"/>
</c:url>

<c:url var="listUrl" value='${SourceConfigTemplateTasks.viewList}'/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<auth:check persistent="${WebConstants.SOURCE_CONFIG_TEMPLATE}" var="canEdit" action="${UBuildAction.SOURCE_TEMPLATE_EDIT}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/admin/project/source/template/sourceConfigTemplateHeader.jsp">
  <jsp:param name="disabled" value="${inEditMode}"/>
  <jsp:param name="selected" value="main"/>
</jsp:include>

<br/>
<br/>

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

      <tbody>
        <tr>
          <td colspan="3">
            <c:if test="${inEditMode}">
              <c:if test="${canEdit}">
                <ucf:button name="Save" label="${ub:i18n('Save')}"/>
              </c:if>
              <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
            </c:if>
            <c:if test="${inViewMode}">
              <c:if test="${canEdit}">
                <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${fn:escapeXml(editUrl)}" /><!--onclick="showPopup('${ah3:escapeJs(editUrl)}', 800, 400); return false;"/>-->
              </c:if>
              <ucf:button href="${exportUrl}" name="Export" label="${ub:i18n('Export')}" enabled="${canEdit}"/>
              <ucf:button href="${listUrl}" name="Done" label="${ub:i18n('Done')}"/>
            </c:if>
          </td>
        </tr>
      </tbody>
    </table>
  </form>

  <br/><br/>

<jsp:include page="/WEB-INF/jsps/admin/project/source/template/sourceConfigTemplateFooter.jsp"/>
