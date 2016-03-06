<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.artifacts.ArtifactSetFactory" %>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.urbancode.ubuild.domain.artifacts.ArtifactSet" %>


<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="fieldAttributes" value=""/><%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<c:set var="stepConfig" value="${key_snippet_ui.stepConfig}"/>
<c:set var="deliver" value="${stepConfig.objectWithStepConfig}"/>

<c:url var="editUrl" value="${WorkflowTemplateTasks.editArtifactConfig}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
  <c:param name="seq" value="${param.seq}"/>
</c:url>

<c:url var="doneUrl" value="${WorkflowTemplateTasks.viewArtifactConfigs}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>

<c:url var="cancelUrl" value="${WorkflowTemplateTasks.cancelArtifactConfig}">
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
  <c:param name="seq" value="${param.seq}"/>
</c:url>

<c:url var="saveUrl" value="${WorkflowTemplateTasks.saveArtifactConfig}"/>

<%
EvenOdd eo = new EvenOdd();
List<ArtifactSet> artifactSetList = Arrays.asList(ArtifactSetFactory.getInstance().restoreAllActive());
pageContext.setAttribute("artifactSetList", artifactSetList);
%>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%-- CONTENT --%>

<a id="artifactConfig"></a>



<div class="tab-content">
  <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>

  <form method="post" action="${fn:escapeXml(saveUrl)}#artifactConfig">

  <c:if test="${artifactConfig != null}">
    <input type="hidden" name="${WebConstants.ARTIFACT_CONFIG_ID}" value="${artifactConfig.id}"/>
  </c:if>

  <table class="property-table">
      <tbody>

        <error:field-error field="configName" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("ArtifactSetWithColon")} <span class="required-text">*</span></span>
          </td>
          <td align="left" width="20%">
            <ucf:idSelector name="artifactSetId" canUnselect="${false}"
                list="${artifactSetList}"
                selectedId="${artifactConfig.artifactSet.id}"
                enabled="${inEditMode}"
                />
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("ProcessTemplateArtifactSetDesc")}</span>
          </td>
        </tr>

        <error:field-error field="baseDir" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("BaseDirectoryWithColon")} <span class="required-text">*</span></span>
          </td>
          <td align="left" width="20%">
            <ucf:text name="baseDir" value='${empty artifactConfig ? "." : artifactConfig.baseDirectory}' enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("ProcessTemplateArtifactsBaseDirDesc")}</span>
          </td>
        </tr>

        <error:field-error field="artifactPatterns" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("IncludeArtifacts")} <span class="required-text">*</span></span>
          </td>
          <td align="left" width="20%">
            <ucf:textarea rows="4" cols="30"
                          name="artifactPatterns"
                          value='${empty artifactConfig ? "*" : artifactConfig.artifactPatternsString}'
                          enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("ProcessTemplateArtifactsIncludeDesc")}</span>
          </td>
        </tr>

        <error:field-error field="artifactExcludePatterns" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("ExcludeArtifacts")}</span>
          </td>
          <td align="left" width="20%">
            <ucf:textarea rows="4" cols="30"
                          name="artifactExcludePatterns"
                          value="${artifactConfig.artifactExcludePatternsString}"
                          enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("ProcessTemplateArtifactsExcludeDesc")}</span>
          </td>
        </tr>

    </tbody>
  </table>

  <br/>
  <c:if test="${inEditMode}">
    <ucf:button name="Save" label="${ub:i18n('Save')}"/>
    <ucf:button href="${cancelUrl}#artifactConfig" name="Cancel" label="${ub:i18n('Cancel')}"/>
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button href="${editUrl}#artifactConfig" name="Edit" label="${ub:i18n('Edit')}"/>
    <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </c:if>
  </form>
</div>

