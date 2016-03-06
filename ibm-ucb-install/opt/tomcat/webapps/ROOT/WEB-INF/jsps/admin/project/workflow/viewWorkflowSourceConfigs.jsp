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
<%@page import="com.urbancode.ubuild.domain.property.Property" %>
<%@page import="com.urbancode.ubuild.domain.source.template.SourceConfigTemplateProperty" %>
<%@page import="com.urbancode.ubuild.domain.property.PropertyTemplateValueHelper" %>
<%@page import="com.urbancode.ubuild.domain.source.template.SourceConfigTemplate" %>
<%@page import="com.urbancode.ubuild.domain.source.template.TemplatedSourceConfig" %>
<%@page import="com.urbancode.ubuild.domain.workflow.*"%>
<%@page import="com.urbancode.ubuild.domain.repository.*"%>
<%@page import="com.urbancode.air.i18n.TranslateMessage "%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>
<%@page import="com.urbancode.ubuild.web.*" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@page import="java.util.*" %>
<%@page import="com.urbancode.air.property.prop_sheet.PropSheet" %>
<%@page import="com.urbancode.air.property.prop_sheet.PropSheetFactoryRegistry" %>
<%@page import="org.apache.commons.lang3.StringUtils" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.SourceConfigTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.repository.RepositoryTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:set var="buildProfile" value="${workflow.buildProfile}"/>

<c:url var="upImg" value="/images/icon_up_arrow.gif"/>
<c:url var="downImg" value="/images/icon_down_arrow.gif"/>
<c:url var="delImg" value="/images/icon_delete.gif"/>
<c:url var="editImg" value="/images/icon_pencil_edit.gif"/>

<c:url var="icon_del" value="/images/icon_delete.gif"/>
<c:url var="icon_edit" value="/images/icon_pencil_edit.gif"/>
<c:url var="icon_add" value="/images/icon_add.gif"/>

<c:url var="deleteSourceConfigUrl" value="${SourceConfigTasks.deleteSourceConfigAjax}"/>
<c:url var="moveSourceConfigUrl" value="${SourceConfigTasks.moveSourceConfigAjax}"/>


<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<auth:check persistent="${workflow.project}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}"/>

<%-- CONTENT --%>

<script type="text/javascript">
  /* <![CDATA[ */
  function deleteSourceConfig(sourceConfigId) {
      if (!confirm(i18n("ProcessSourceConfigDeleteMessage"))) {
          return false;
      }
      new Ajax.Request('${ah3:escapeJs(deleteSourceConfigUrl)}', {
          method:      'post',
          parameters:  {
             '${WebConstants.SOURCE_CONFIG_ID}': sourceConfigId
          },
          onSuccess:   function(resp)  { window.location.reload(); },
          onFailure:   function(resp)  { alert(i18n("ProcessSourceConfigDeleteError")); },
          onException: function(resp,e){ throw e }
      });
  }

  function moveSourceConfig(sourceConfigId, newSeq) {
      new Ajax.Request('${ah3:escapeJs(moveSourceConfigUrl)}', {
          method:      'post',
          parameters:  {
              '${WebConstants.SOURCE_CONFIG_ID}': sourceConfigId,
              'sequence': newSeq
          },
          onSuccess:   function(resp)  { window.location.reload(); },
          onFailure:   function(resp)  { alert(i18n("ProcessSourceConfigMoveError")); },
          onException: function(resp,e){ throw e }
      });
  }

  window.deleteSourceConfig = deleteSourceConfig;
  window.moveSourceConfig = moveSourceConfig;
  /* ]]> */
</script>
<div class="project-component" id="workflowSourceConfigs">
  <div class="component-heading">
    <div style="float: right;">
      <c:url var="createSourceConfigUrl" value="${SourceConfigTasks.newTemplatedSourceConfig}">
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
      </c:url>
      <ucf:link href="#" label="${ub:i18n('Create')}" title="${label}" forceLabel="true" enabled="${canEdit}"
        onclick="showPopup('${ah3:escapeJs(createSourceConfigUrl)}', 800, 600); return false;"/>
    </div>
    ${ub:i18n("SourceConfiguration")}
  </div>
  <div>
    <c:set var="sourceConfigs" value="${buildProfile.sourceConfigs}"/>
    <c:choose>
      <c:when test="${not empty sourceConfigs}">
      <table class="data-table">
        <thead>
          <tr>
            <th width="15%">${ub:i18n("SourceName")}</th>
            <th width="10%">${ub:i18n("Type")}</th>
            <th width="25%">${ub:i18n("SourceConfigSourceTemplate")}</th>
            <th width="40%">${ub:i18n("Repository")}</th>
            <th width="10%">${ub:i18n("Actions")}</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="sourceConfig" items="${sourceConfigs}" varStatus="i">
            <c:set var="propSheet" value="${sourceConfig.propSheet}"/>
            <c:set var="propMap" value="${propSheet.propMap}"/>
            <c:url var="viewSourceConfigUrl" value="${SourceConfigTasks.editOrCreateTemplatedSourceConfig}">
              <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
              <c:param name="${WebConstants.SOURCE_CONFIG_ID}" value="${sourceConfig.id}"/>
            </c:url>
            <c:url var="deleteSourceConfigUrl" value="${SourceConfigTasks.deleteSourceConfigAjax}">
              <c:param name="${WebConstants.SOURCE_CONFIG_ID}" value="${sourceConfig.id}"/>
            </c:url>

            <c:if test="${not sourceConfig.inTemplateCompliance}">
              <tr><td colspan="5" style="border-bottom: none;">
                <span class="error">${ub:i18n("SourceConfigViewOutOfComplianceMessage")}</span>
              </td></tr>
            </c:if>

            <tr bgcolor="#ffffff">
              <td nowrap="nowrap">
                <ucf:link label="${propSheet.name}" href="#" enabled="${canEdit}"
                  onclick="showPopup('${ah3:escapeJs(viewSourceConfigUrl)}', 800, 600); return false;"/>
              </td>
              <td nowrap="nowrap">${fn:escapeXml(sourceConfig.plugin.name)}</td>

              <c:url var="sourceConfigTemplateUrl" value="${SourceConfigTemplateTasks.viewSourceConfigTemplate}">
                <c:param name="sourceConfigTemplateId" value="${sourceConfig.template.id}" />
              </c:url>

              <auth:check persistent="${sourceConfig.template}" var="canViewSourceTemplate" action="${UBuildAction.SOURCE_TEMPLATE_EDIT}"/>

              <td nowrap="nowrap">
                <div class="workflowDetailItem">
                  <ucf:link href="${sourceConfigTemplateUrl}" label="${sourceConfig.template.name}" enabled="${canViewSourceTemplate}" />
                </div>
                <c:if test="${not empty sourceConfig.template.description}">
                  <div class="workflowDetailItem" style="margin-left: 15px; font-style: italic;">
                    ${fn:escapeXml(sourceConfig.template.description)}
                  </div>
                </c:if>
              </td>

              <td nowrap="nowrap">
            <%
                TemplatedSourceConfig sourceConfig = (TemplatedSourceConfig) pageContext.findAttribute(WebConstants.SOURCE_CONFIG);
                SourceConfigTemplate sourceConfigTemplate = sourceConfig.getTemplate();
                /**
                 *  The current configured properties on the project
                 */
                Map<String, String> prop2SourceConfigValue = new HashMap<String, String>();
                if (sourceConfig != null) {
                    for (SourceConfigTemplateProperty templateProperty : sourceConfigTemplate.getPropertyList()) {
                        Property property = sourceConfig.getProperty(templateProperty.getName());
                        if (property != null) {
                            String value = property.getValue();
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
                            prop2SourceConfigValue.put(templateProperty.getName(), value);
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

            <c:url var="repositoryUrl" value="${RepositoryTasks.viewRepository}">
              <c:if test="${not empty sourceConfig.repository.id}">
                <c:param name="${WebConstants.REPO_ID}" value="${sourceConfig.repository.id}" />
              </c:if>
            </c:url>

            <auth:check persistent="${sourceConfig.repository}" var="canViewRepository" action="${UBuildAction.REPO_EDIT}"/>

            <div class="workflowDetailItem">
              <span class="bold">${ub:i18n("RepositoryWithColon")}</span>
              <ucf:link href="${repositoryUrl}" label="${sourceConfig.repository.name}" enabled="${canViewRepository}"/>
            </div>
            <c:if test="${not empty sourceConfig.repository.description}">
              <div class="workflowDetailItem" style="margin-left: 15px; font-style: italic;">
                <c:out value="${sourceConfig.repository.description}"/>
              </div>
            </c:if>

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
                    ${empty prop2SourceConfigValue[property.name] ? '' : '****'}
                  </c:when>
                  <c:otherwise>
                    ${fn:escapeXml(prop2SourceConfigValue[property.name])}
                  </c:otherwise>
                </c:choose>
              </div>
            </c:forEach>
              </td>

              <td align="center" nowrap="nowrap">
                <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(viewSourceConfigUrl)}', 800, 600); return false;" label="${ub:i18n('Edit')}" img="${editImg}" enabled="${canEdit}"/>
                &nbsp;
                <c:if test="${!i.first}">
                  <c:set var="prevSeq" value="${sourceConfigs[i.index-1].sequence}" scope="page"/>
                </c:if>
                <c:if test="${!i.last}">
                  <c:set var="nextSeq" value="${sourceConfigs[i.index+1].sequence}" scope="page"/>
                </c:if>
                <ucf:link href="#" onclick="moveSourceConfig(${sourceConfig.id}, ${prevSeq}); return false;" label="${ub:i18n('MoveUp')}" img="${upImg}" enabled="${!i.first and canEdit}"/>
                &nbsp;
                <ucf:link href="#" onclick="moveSourceConfig(${sourceConfig.id}, ${nextSeq}); return false;" label="${ub:i18n('MoveDown')}" img="${downImg}" enabled="${!i.last and canEdit}"/>
                &nbsp;
                <ucf:link href="#" onclick="deleteSourceConfig(${sourceConfig.id}); return false;" label="${ub:i18n('Delete')}" img="${delImg}" enabled="${canEdit}"/>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
      </c:when>
      <c:otherwise>
        <span class="error">${ub:i18n("ProcessNoSourceConfigError")}</span>
      </c:otherwise>
    </c:choose>
  </div>
</div>
