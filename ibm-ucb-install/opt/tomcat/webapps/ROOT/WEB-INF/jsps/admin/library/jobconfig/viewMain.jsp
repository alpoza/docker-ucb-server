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
<%@page import="com.urbancode.air.plugin.server.Plugin" %>
<%@page import="com.urbancode.air.plugin.server.PluginCommand" %>
<%@page import="com.urbancode.ubuild.domain.agentfilter.AgentFilter" %>
<%@page import="com.urbancode.ubuild.domain.jobconfig.JobConfig" %>
<%@page import="com.urbancode.ubuild.domain.plugin.PluginCommandStepConfig" %>
<%@page import="com.urbancode.ubuild.domain.step.StepConfig" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks"%>
<%@page import="com.urbancode.ubuild.web.util.StepConfigSnippetRegistry"%>
<%@page import="com.urbancode.ubuild.web.util.TypeDescriptor" %>
<%@page import="com.urbancode.commons.util.StringUtil" %>
<%@page import="java.util.regex.Pattern" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="step" tagdir="/WEB-INF/tags/ui/admin/step" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.ClientSessionTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="grabberIconUrl"      value="/images/icon_grabber.gif"/>
<c:url var="iconCopyUrl"         value="/images/icon_copy_project.gif" />
<c:url var="upArrowIconUrl"      value="/images/icon_up_arrow.gif"/>
<c:url var="downArrowIconUrl"    value="/images/icon_down_arrow.gif"/>
<c:url var="iconGearActiveUrl"   value="/images/icon_active.gif"/>
<c:url var="iconDeleteUrl"       value="/images/icon_delete.gif" />
<c:url var="iconGearInactiveUrl" value="/images/icon_inactive.gif"/>
<c:url var="iconGearInactiveDisabledUrl" value="/images/icon_inactive_disabled.gif"/>
<c:url var="iconPlusUrl" value="/images/plus.gif"/>
<c:url var="iconMinusUrl" value="/images/minus.gif"/>
<c:url var="iconEditUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconInsertBeforeUrl" value="/images/icon_insert_before.gif"/>
<c:url var="iconInsertAfterUrl" value="/images/icon_insert_after.gif"/>

<c:url var="doneUrl" value="${LibraryJobConfigTasks.viewList}"/>

<c:url var="viewMainUrl" value="${LibraryJobConfigTasks.viewMain}">
    <c:if test="${jobConfig.id != null}">
        <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
    </c:if>
</c:url>

<c:url var="moveStepUrl" value="${LibraryJobConfigTasks.moveStep}">
    <c:if test="${jobConfig.id != null}">
        <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
    </c:if>
</c:url>

<c:url var="editMainUrl" value="${LibraryJobConfigTasks.editMain}">
    <c:if test="${jobConfig.id != null}">
        <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
    </c:if>
    <c:if test="${projectId != null}">
        <c:param name="${WebConstants.PROJECT_ID}" value="${projectId}"/>
    </c:if>
</c:url>

<c:url var="pasteFromClipboardUrl" value='${LibraryJobConfigTasks.pasteFromClipboard}'>
    <c:if test="${jobConfig.id != null}">
        <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
    </c:if>
</c:url>

<c:url var="pasteAndRemoveFromClipboardUrl" value='${LibraryJobConfigTasks.pasteAndRemoveFromClipboard}'>
    <c:if test="${jobConfig.id != null}">
        <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
    </c:if>
</c:url>
<c:set var="groupParamName" value="${WebConstants.CLIPBOARD_PARAM_GROUP_NAME}" />

<auth:check persistent="jobConfig" var="canEdit" action="${UBuildAction.JOB_EDIT}"/>
<auth:check persistent="jobConfig" var="canView" action="${UBuildAction.JOB_VIEW}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="title" value="${ub:i18n('AdministrationLibraryJobConfiguration')}" />
    <jsp:param name="selected" value="template" />
    <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('Main')}" href="${viewMainUrl}" enabled="${false}" klass="selected tab"/>
</div>

<script type="text/javascript">
  /* <![CDATA[ */
    function refresh() {
        goTo('${ah3:escapeJs(viewMainUrl)}');
    }
    function moveStep(old, newinx) {
        goTo("${ah3:escapeJs(moveStepUrl)}&old="+old+"&new="+newinx);
    }

    var pasteFromClipboardUrl = "${pasteFromClipboardUrl}";
    var pasteAndRemoveFromClipboardUrl = "${pasteAndRemoveFromClipboardUrl}";
    var groupParamName = "${groupParamName}";

    function pasteFromClipboard(groupName) {
        var url = pasteFromClipboardUrl + "&" + groupParamName + "=" + groupName;
        goTo(url);
    }

    function pasteAndRemoveFromClipboard(groupName) {
        var url = pasteAndRemoveFromClipboardUrl + "&" + groupParamName + "=" + groupName;
        goTo(url);
    }

    <c:if test="${empty jobConfig}">
        showPopup('${ah3:escapeJs(editMainUrl)}', 800, 400);
    </c:if>
  /* ]]> */
</script>
<br/>
<c:import url="clipboard.jsp">
  <c:param name="clipboard-param-show-for-paste-name-prefix" value="${WebConstants.CLIPBOARD_COPIED_STEPS}"/>
</c:import>
<br/>
<div class="contents">

      <div>
        <table class="property-table">
          <tr>
            <td style="text-align: left;vertical-align: top;" width="86%">
              <strong>${ub:i18n("NameWithColon")}</strong>
              <span id="jobName"><c:out value="${jobConfig.name}" default="${ub:i18n('NewJobConfig')}"/></span><br/>
              <c:if test="${!empty jobConfig.description}">
                <strong>${ub:i18n("DescriptionWithColon")}</strong> <span id="jobDescription">${fn:escapeXml(jobConfig.description)}</span><br/>
              </c:if>
              <br/>
            </td>
          </tr>
        </table>
      </div>
      <div>
        <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="#" enabled="${canEdit}" onclick="showPopup('${ah3:escapeJs(editMainUrl)}', 800, 400); return false;"/>
        <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
      </div>
      <br/>
      <c:choose>
        <c:when test="${not empty jobConfig.stepConfigArray}">
          <table class="data-table">
            <thead>
              <tr>
                <th width="40%" style="text-align: left;">${ub:i18n("Name")}</th>
                <th width="30%" style="text-align: left;">${ub:i18n("Type")}</th>
                <th width="10%">${ub:i18n("PreCondition")}</th>
                <th width="5%">${ub:i18n("Parallel")}</th>
                <th width="15%">${ub:i18n("Actions")}</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="step" items="${jobConfig.stepConfigArray}">

                <c:url var="insertStepAfterUrlIdx" value='${LibraryJobConfigTasks.selectStepType}'>
                  <c:if test="${jobConfig.id != null}">
                    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
                  </c:if>
                  <c:param name="${WebConstants.STEP_INDEX}" value="${step.seq + 1}"/>
                </c:url>

                <c:url var="insertStepBeforeUrlIdx" value='${LibraryJobConfigTasks.selectStepType}'>
                  <c:if test="${jobConfig.id != null}">
                    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
                  </c:if>
                  <c:param name="${WebConstants.STEP_INDEX}" value="${step.seq}"/>
                </c:url>

                <c:url var="activateStepUrlIdx" value='${LibraryJobConfigTasks.activateStep}'>
                  <c:if test="${jobConfig.id != null}">
                    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
                  </c:if>
                  <c:param name="${WebConstants.STEP_CONFIG_ID}" value="${step.id}"/>
                </c:url>

                <c:url var="deactivateStepUrlIdx" value='${LibraryJobConfigTasks.deactivateStep}'>
                  <c:if test="${jobConfig.id != null}">
                    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
                  </c:if>
                  <c:param name="${WebConstants.STEP_CONFIG_ID}" value="${step.id}"/>
                </c:url>

                <c:url var="deleteStepUrlIdx" value='${LibraryJobConfigTasks.deleteStep}'>
                  <c:if test="${jobConfig.id != null}">
                    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
                  </c:if>
                  <c:param name="${WebConstants.STEP_CONFIG_ID}" value="${step.id}"/>
                </c:url>

                <c:url var="editStepUrlIdx" value='${LibraryJobConfigTasks.viewStep}'>
                  <c:if test="${jobConfig.id != null}">
                    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
                  </c:if>
                  <c:param name="${WebConstants.STEP_CONFIG_ID}" value="${step.id}"/>
                </c:url>

                <c:url var="copyStepToClipboardUrlIdx" value='${LibraryJobConfigTasks.copyStepToClipboard}'>
                  <c:if test="${jobConfig.id != null}">
                    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
                  </c:if>
                  <c:param name="${WebConstants.STEP_CONFIG_ID}" value="${step.id}"/>
                </c:url>

                <c:set var="stepClass" value=""/>
                <c:if test="${!step.active}">
                    <c:set var="stepClass" value="step-disabled"/>
                </c:if>

                <tr id="step-row-${step.seq}" class="${stepClass}">
                  <td>
                    <script type="text/javascript">
                      Element.observe(window, 'load', function(event) {
                          new UC_STEP_ROW("step-row-${step.seq}", {clientSessionSetPropUrl: '${ClientSessionTasks.setProperty}'}, ${step.id});
                      });
                    </script>
                    <c:if test="${canEdit}">
                      <div style="float: left; padding-right: 15px;" align="right"><img style="cursor:move;"
                        id="grabber${step.seq}" alt="${ub:i18n('Reorder')}" title="${ub:i18n('Reorder')}"
                        src="${grabberIconUrl}"/></div>
                    </c:if>
                    <c:if test="${!step.active}">
                      ${ub:i18n("DisabledParentheses")} -
                    </c:if>
                    ${fn:escapeXml(step.name)}
                  </td>
                  <td><step:displayName stepConfig="${step}"/></td>
                  <td style="text-align: center;">${fn:escapeXml(ub:i18n(step.preConditionScript.name))}</td>
                  <c:set var="runInParallel" value="${step.runInParallel}"/>
                  <td style="text-align: center;">${ub:i18n(runInParallel)}</td>
                  <td style="text-align: center;">
                    <ucf:link href="#" onclick="showPopup('${fn:escapeXml(editStepUrlIdx)}', 1000, 400); return false;"
                      label="${ub:i18n('Edit')}" title="${ub:i18n('Edit')}" img="${iconEditUrl}" enabled="${canView}"/>&nbsp;
                    <ucf:link href="${copyStepToClipboardUrlIdx}"
                      label="${ub:i18n('LibraryJobCopyStep')}" title="${ub:i18n('LibraryJobCopyStep')}" img="${iconCopyUrl}" enabled="${canEdit}"/>&nbsp;
                    <ucf:link href="#" onclick="showPopup('${fn:escapeXml(insertStepBeforeUrlIdx)}', 1000, 600); return false;"
                      label="${ub:i18n('LibraryJobInsertBefore')}" title="${ub:i18n('LibraryJobInsertBefore')}" img="${iconInsertBeforeUrl}" enabled="${canEdit}"/>&nbsp;
                    <ucf:link href="#" onclick="showPopup('${fn:escapeXml(insertStepAfterUrlIdx)}', 1000, 600); return false;"
                      label="${ub:i18n('LibraryJobInsertAfter')}" title="${ub:i18n('LibraryJobInsertAfter')}" img="${iconInsertAfterUrl}" enabled="${canEdit}"/>&nbsp;
                    <c:choose>
                      <c:when test="${step.active}">
                        <ucf:link href="${deactivateStepUrlIdx}"
                          label="${ub:i18n('Disable')}" title="${ub:i18n('Disable')}" img="${iconGearActiveUrl}" enabled="${canEdit}"/>&nbsp;
                      </c:when>
                      <c:when test="${!step.active && plugin != null && !plugin.active}">
                        <ucf:link href="#" onclick="alert('This step can not be activated unless plugin &#34;${fn:escapeXml(plugin.name)}&#34; is reactivated'); return false;"
                          label="${ub:i18n('Activate')}" title="${ub:i18n('Activate')}" img="${iconGearInactiveUrl}" enabled="${canEdit}"/>&nbsp;
                      </c:when>
                      <c:otherwise>
                        <ucf:link href="${activateStepUrlIdx}"
                          label="${ub:i18n('Activate')}" title="${ub:i18n('Activate')}" img="${iconGearInactiveUrl}" enabled="${canEdit}"/>&nbsp;
                      </c:otherwise>
                    </c:choose>
                    <ucf:deletelink href="${deleteStepUrlIdx}" img="${iconDeleteUrl}" label="${ub:i18n('Delete')}"
                      name="${step.name}" enabled="${canEdit}"/>&nbsp;
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
      </c:when>
      <c:otherwise>
        <div align="center">
          <c:if test="${canEdit}">
            <c:url var="newStepUrl" value='${LibraryJobConfigTasks.selectStepType}'>
              <c:if test="${jobConfig.id != null}">
                <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
              </c:if>
            </c:url>
            <ucf:button name="Create Step" label="${ub:i18n('LibraryJobCreateStep')}"
                onclick="showPopup('${ah3:escapeJs(newStepUrl)}', 1100, 600); return false;" />
          </c:if>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
