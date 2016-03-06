<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<auth:check var="canEdit" persistent="${workflowTemplate}" action="${UBuildAction.PROCESS_TEMPLATE_EDIT}"/>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="fieldAttributes" value=""/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<c:url var="newArtifactConfigUrl" value='${WorkflowTemplateTasks.newArtifactConfig}'>
  <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<div>
  <ucf:button name="NewArtifactConfig" label="${ub:i18n('NewArtifactConfig')}" href="${newArtifactConfigUrl}"
    enabled="${inViewMode and buildProfileArtifactConfig==null and canEdit}"/>
  <br/><br/>
</div>
<div class="project-component">
  <div class="component-heading">
    ${ub:i18n("ArtifactConfigurations")}
  </div>

  <table id="ArtifactConfigTable" class="data-table">
    <thead>
      <tr>
        <th scope="col" align="left" valign="middle" width="20%"  >${ub:i18n("ArtifactSet")}</th>
        <th scope="col" align="left" valign="middle"              >${ub:i18n("BaseDirectory")}</th>
        <th scope="col" align="left" valign="middle"              >${ub:i18n("Include")}</th>
        <th scope="col" align="left" valign="middle"              >${ub:i18n("Exclude")}</th>
        <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty workflowTemplate.artifactDeliverPatterns}">
          <tr bgcolor="#ffffff">
            <td colspan="5">
              ${ub:i18n("ProcessTemplateArtifactsNoneConfiguredMessage")}
            </td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="artifactConfig" items="${workflowTemplate.artifactDeliverPatterns}">
            <c:url var="removeArtifactConfigUrlName" value='${WorkflowTemplateTasks.removeArtifactConfig}'>
              <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
              <c:param name="${WebConstants.ARTIFACT_CONFIG_ID}" value="${artifactConfig.id}"/>
            </c:url>

            <c:url var="viewArtifactConfigUrlName" value='${WorkflowTemplateTasks.editArtifactConfig}'>
              <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
              <c:param name="${WebConstants.ARTIFACT_CONFIG_ID}" value="${artifactConfig.id}"/>
            </c:url>

            <tr bgcolor="#ffffff">
              <td align="left" height="1" nowrap="nowrap" width="20%">
                <ucf:link href="${viewArtifactConfigUrlName}#artifactConfig" label="${ub:i18n(artifactConfig.artifactSet.name)}" enabled="${canEdit}"/>
              </td>

              <td align="left" height="1" nowrap="nowrap">
                ${fn:escapeXml(artifactConfig.baseDirectory)}
              </td>

              <td align="left" height="1">
                <c:forEach var="includePattern" items="${artifactConfig.artifactPatternArray}">
                  ${fn:escapeXml(includePattern)}<br/>
                </c:forEach>
              </td>

              <td align="left" height="1">
                <c:forEach var="excludePattern" items="${artifactConfig.artifactExcludePatternArray}">
                  ${fn:escapeXml(excludePattern)}<br/>
                </c:forEach>
              </td>

              <td align="center" height="1" nowrap="nowrap" width="10%">
                <c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
                <c:url var="iconRemoveUrl" value="/images/icon_remove.gif"/>
                <ucf:link href="${viewArtifactConfigUrlName}#artifactConfig" label="${ub:i18n('View')}"
                        img="${iconMagnifyGlassUrl}" enabled="${canEdit}"/> &nbsp;
                <ucf:deletelink href="${removeArtifactConfigUrlName}" name="${ub:i18n(artifactConfig.artifactSet.name)}"
                        label="${ub:i18n('Remove')}" img="${iconRemoveUrl}" enabled="${canEdit}"/>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>
