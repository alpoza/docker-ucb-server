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
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.domain.subscription.NotificationSubscription"%>
<%@page import="com.urbancode.ubuild.domain.subscription.SubscriptionEventEnum"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="imsg" tagdir="/WEB-INF/tags/ui/admin/inactiveMessage" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.SourceConfigTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.subscription.SubscriptionEventEnum"/>

<auth:check persistent="${workflow.project}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}"/>
<auth:check persistent="${workflow.template}" var="canViewLibWorkflow" action="${UBuildAction.PROCESS_TEMPLATE_VIEW}"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="buildProfile" value="${workflow.buildProfile}"/>

<c:url var="imgUrl" value="/images"/>

<c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconPencilEditUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconInactiveUrl" value="/images/icon_inactive.gif"/>
<c:url var="iconActiveUrl" value="/images/icon_active.gif"/>

<c:url var="doneUrl" value="${ProjectTasks.viewProject}">
    <c:param name="${WebConstants.PROJECT_ID}" value="${workflow.project.id}"/>
</c:url>

<c:url var="editWorkflowUrl" value="${WorkflowTasks.editWorkflow}">
    <c:if test="${workflow.id != null}"><c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/></c:if>
</c:url>

<c:url var="workflowTemplateUrl" value="${WorkflowTemplateTasks.viewWorkflowTemplate}">
    <c:if test="${workflow.template.id != null}"><c:param name="workflowTemplateId" value="${workflow.template.id}" /></c:if>
</c:url>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/home/project/workflow/header.jsp">
  <jsp:param name="selected" value="configuration"/>
  <jsp:param name="disabled" value="${workflow==null || workflow.new}"/>
</jsp:include>

<div class="contents">

<%-- auto-open main popup on new workflow --%>
<c:if test="${empty workflow}">
  <c:url var="viewWorkflowUrl" value="${WorkflowTasks.viewWorkflow}"></c:url>
  <script type="text/javascript">
    /* <![CDATA[ */
      function editWorkflow() {
          showPopup('${ah3:escapeJs(editWorkflowUrl)}', 800, 400);
      }

      Element.observe(window, 'load', editWorkflow);

      <%-- If the workflow is new, we want to reload this page when they complete filling out the main form--%>
      function refresh() {
          goTo('${ah3:escapeJs(viewWorkflowUrl)}');
      }
      /* ]]> */
  </script>
</c:if>
<%
NotificationSubscription subscriptionOfWorkflow = (NotificationSubscription)request.getAttribute(WebConstants.WORKFLOW_SUBSCRIPTION);
pageContext.setAttribute("subscriptionOfWorkflow", subscriptionOfWorkflow);
NotificationSubscription subscriptionOfProject = (NotificationSubscription)request.getAttribute(WebConstants.PROJECT_SUBSCRIPTION);
pageContext.setAttribute("subscriptionOfProject", subscriptionOfProject);

pageContext.setAttribute("subscriptionEventJson", SubscriptionEventEnum.getJson().toString());
%>
<%-- The main page content --%>
    <div class="system-helpbox">${ub:i18n("ProcessSystemHelpBox")}</div>
    <div class="required-text" style="text-align: right;">${ub:i18n("RequiredField")}</div>
    <table class="property-table">
      <tbody>
        <tr>
          <imsg:inactiveMessage isActive="${workflow.active}" message="${ub:i18n('BuildWorkflowProcessDeactivatedError')}"/>
        </tr>
        <tr>
          <td width="15%"><strong>${ub:i18n("NameWithColon")}</strong></td>
          <td width="20%"><c:out value="${workflow.name}"/></td>
          <td><c:out value="${workflow.description}"/>&nbsp;</td>
        </tr>
        <tr>
          <td width="15%"><strong>${ub:i18n("TemplateWithColon")}</strong></td>
          <td width="20%">
            <ucf:link href="${workflowTemplateUrl}" label="${workflow.template.name}" enabled="${canViewLibWorkflow}"/>
          </td>
          <td><c:out value="${workflow.template.description}"/>&nbsp;</td>
        </tr>
        <tr>
          <td width="15%"><strong>${ub:i18n("NotificationSchemeWithColon")}</strong></td>
          <td colspan="2"><c:out value="${workflow.notificationScheme.name}" default="${ub:i18n('None')}"/></td>
        </tr>
        <c:if test="${workflow.buildProfile != null}">
          <tr>
            <td width="15%"><strong>${ub:i18n("SkipPreProcessing")}</strong></td>
            <td colspan="2">${ub:i18n(workflow.skippingQuietPeriod)}</td>
          </tr>
        </c:if>
        <tr>
          <td width="15%"><strong>${ub:i18n("PriorityWithColon")}</strong></td>
          <td colspan="2"><c:out value="${ub:i18n(workflow.workflowPriorityScript.name)}" default="${ub:i18n('None')}"/></td>
        </tr>
        <tr>
            <td width="15%"><strong>${ub:i18n("NotificationSubscriptionWithColon")}</strong></td>
            <td width="20%">
            <c:set var="currentSubscription" value="${subscriptionOfWorkflow.event != null ? subscriptionOfWorkflow.event : SubscriptionEventEnum.DEFAULT}"/>
            <c:set var="subscriptionID" value="${subscriptionOfWorkflow.id != null ? subscriptionOfWorkflow.id : -1}"/>
            <c:url var="projectNotificationSubscriptionsUrl" value="/rest2/projects/${workflow.project.id}/notificationSubscriptions"/>
            <c:url var="notificationSubscriptionURL" value="/rest2/notificationSubscriptions"/>
            <div id="subscribeButton"></div>
              <script type="text/javascript">
                    require(["ubuild/module/UBuildApp", "ubuild/NotificationSubscriptionEditor"], function(UBuildApp, NotificationSubscriptionEditor) {
                        UBuildApp.util.i18nLoaded.then(function() {
                            var button = new NotificationSubscriptionEditor({
                                ID: ${workflow.id},
                                projectNotificationSubscriptionsURL: '${projectNotificationSubscriptionsUrl}',
                                notificationSubscriptionURL: '${notificationSubscriptionURL}',
                                currentStatus: '${currentSubscription.name}',
                                currentStatusLabel: '${currentSubscription.displayName}',
                                subscriptionID: ${subscriptionID},
                                isProject: false,
                                subscriptionEventJson:${subscriptionEventJson},
                                isButton: true
                            });
                            button.placeAt("subscribeButton");
                        });
                    });
                </script>
            </td>
            <td>&nbsp;</td>
            </tr>

        <c:import url="/WEB-INF/jsps/admin/project/workflow/viewPropertiesFromWorkflowTemplate.jsp"/>
      </tbody>
    </table>
    <br/>
      <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="#" enabled="${canEdit}" onclick="showPopup('${ah3:escapeJs(editWorkflowUrl)}', 800, 400); return false;"/>
      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
      <br/>
      <br/>

      <c:if test="${workflow.buildProfile != null}">
        <br/>
        <c:import url="/WEB-INF/jsps/admin/project/workflow/viewWorkflowSourceConfigs.jsp"/>
        <br />
      </c:if>

      <br />
      <div class="component-heading">
        <c:url var="newPropertyUrl" value="${WorkflowTasks.newProperty}">
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>
        <div style="float: right;">
          <ucf:link label="${ub:i18n('Create')}" href="${newPropertyUrl}" enabled="${canEdit}"/>
        </div>
        ${ub:i18n("Properties")}
      </div>
      <c:import url="/WEB-INF/jsps/admin/project/workflow/property/propertyList.jsp"/>
      <br />
      <br/>

      <c:if test="${buildProfile != null}">
        <error:field-error field="${WebConstants.BUILD_CONFIGURATION_LIST}"/>
        <div class="project-component">
          <div class="component-heading">
            <c:url var="viewActiveUrl" value="${WorkflowTasks.viewWorkflow}">
              <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
            </c:url>
            <c:url var="viewInactiveUrl" value="${WorkflowTasks.viewInactiveBuildConfigurations}">
              <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
            </c:url>
            <c:url var="newBuildConfigUrl" value="${WorkflowTasks.newBuildConfiguration}">
              <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
            </c:url>
            <div style="float: right;">
              <c:set var="viewActiveInactive" value="${viewInactive == true ? ub:i18n('ViewActive') : ub:i18n('ViewInactive')}"/>
              <ucf:link label="${viewActiveInactive}" href="${viewInactive ? viewActiveUrl : viewInactiveUrl}"/>
              <ucf:link label="${ub:i18n('Create')}" enabled="${canEdit}" href="${newBuildConfigUrl}"/>
            </div>
            ${ub:i18n("BuildConfigurations")}
          </div>
          <table class="data-table">
            <tbody>
              <tr>
                <th width="20%">${ub:i18n("Name")}</th>
                <th width="70%">${ub:i18n("Description")}</th>
                <th width="10%">${ub:i18n("Actions")}</th>
              </tr>
              <c:forEach var="buildConfig" items="${viewInactive ? buildProfile.inactiveBuildConfigurations : buildProfile.buildConfigurations}">
                <c:url var="viewBuildConfigUrl" value="${WorkflowTasks.viewBuildConfiguration}">
                  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
                  <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${buildConfig.id}"/>
                </c:url>
                <c:url var="inactivateBuildConfigUrl" value="${WorkflowTasks.inactivateBuildConfiguration}">
                  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
                  <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${buildConfig.id}"/>
                </c:url>
                <c:url var="activateBuildConfigUrl" value="${WorkflowTasks.activateBuildConfiguration}">
                  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
                  <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${buildConfig.id}"/>
                </c:url>
                <c:url var="deleteBuildConfigUrl" value="${WorkflowTasks.deleteBuildConfiguration}">
                  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
                  <c:param name="${WebConstants.BUILD_CONFIGURATION_ID}" value="${buildConfig.id}"/>
                </c:url>

                <tr bgcolor="#ffffff">
                  <td><ucf:link href="${viewBuildConfigUrl}" label="${buildConfig.name}"/></td>
                  <td>${buildConfig.description}</td>
                  <td align="center">
                    <ucf:link href="${viewBuildConfigUrl}" label="${ub:i18n('Edit')}" img="${iconPencilEditUrl}"/> &nbsp;
                    <c:choose>
                      <c:when test="${viewInactive}">
                        <ucf:confirmlink href="${activateBuildConfigUrl}" label="${ub:i18n('Activate')}"
                          img="${iconInactiveUrl}" enabled="${canEdit}" message="${ub:i18nMessage('ProcessActivateMessage', buildConfig.name)}"/>&nbsp;
                        <ucf:deletelink href="${deleteBuildConfigUrl}"
                                        name="Build Config: ${buildConfig.name}" img="${iconDeleteUrl}"
                                        enabled="${canEdit && buildConfig.deletable}"/> &nbsp;
                      </c:when>
                      <c:otherwise>
                        <ucf:confirmlink href="${inactivateBuildConfigUrl}" label="${ub:i18n('Inactivate')}"
                          img="${iconActiveUrl}" enabled="${canEdit}" message="${ub:i18nMessage('ProcessDeactivateMessage', buildConfig.name)}"/>&nbsp;
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${viewInactive ? empty buildProfile.inactiveBuildConfigurations : empty buildProfile.buildConfigurations}">
                <tr bgcolor="#ffffff">
                  <td colspan="3">${ub:i18n("ProcessNoBuildConfigsMessage")}</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </c:if>
</div>

<jsp:include page="/WEB-INF/jsps/home/project/workflow/footer.jsp"/>
