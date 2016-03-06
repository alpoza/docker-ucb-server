<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.project.template.ProjectTemplate"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.agentfilter.*"%>
<%@page import="com.urbancode.ubuild.domain.jobconfig.JobConfig" %>
<%@page import="com.urbancode.ubuild.domain.project.Project"%>
<%@page import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowComparator" %>
<%@page import="com.urbancode.ubuild.domain.subscription.NotificationSubscription"%>
<%@page import="com.urbancode.ubuild.domain.subscription.SubscriptionEventEnum"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.project.ProjectTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.commons.xml.XMLUtils" %>
<%@page import="javax.servlet.jsp.JspWriter"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ProjectTasks" useConversation="false" id="PTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />

<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.subscription.SubscriptionEventEnum"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imagesUrl" value="/images"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:url var="submitUrl" value="${ProjectTasks.saveProject}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="exportUrl" value="${ImportExportTasks.exportProject2File}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="copyUrl" value="${ProjectTasks.copyProject}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="cancelUrl" value="${ProjectTasks.cancelProject}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="editUrl" value="${ProjectTasks.editProject}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="doneUrl" value='${PTasks.viewList}'/>
<c:url var="viewProjectUrl" value='${PTasks.viewProject}'/>

<c:url var="deactivateUrl" value="${ProjectTasks.deactivateProject}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="deleteUrl" value="${ProjectTasks.deleteProject}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="activateUrl" value="${ProjectTasks.activateProject}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<%
  Project project = (Project) pageContext.findAttribute(WebConstants.PROJECT);
  // pageContext.setAttribute("environmentGroupList", EnvironmentGroupFactory.getInstance().restoreAll());
  pageContext.setAttribute("eo", new EvenOdd());
  pageContext.setAttribute("isNew", project == null || project.isNew());

  Boolean canCopy = (Boolean)pageContext.findAttribute("canCopy");
  pageContext.setAttribute("canCopy", canCopy);

  NotificationSubscription subscription = (NotificationSubscription)request.getAttribute(WebConstants.PROJECT_SUBSCRIPTION);
  pageContext.setAttribute("subscription", subscription);

  pageContext.setAttribute("subscriptionEventJson", SubscriptionEventEnum.getJson().toString());
%>

<auth:check persistent="${WebConstants.PROJECT}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}" resultWhenNotFound="true"/>
<auth:check persistent="${WebConstants.PROJECT_TEMPLATE}" var="canViewTemplate" action="${UBuildAction.PROJECT_TEMPLATE_VIEW}"/>

<%-- CONTENT --%>

<c:if test="${!empty migrationError}">
    <div><br/><br/><pre class="error">${fn:escapeXml(migrationError)}</pre></div>
    <c:remove scope="session" var="migrationError"/>
</c:if>
<c:if test="${! empty migrationSuccess}">
    <div><br/><br/><pre class="success">${fn:escapeXml(migrationSuccess)}</pre></div>
    <c:remove scope="session" var="migrationSuccess"/>
</c:if>
  <form method="post" action="${fn:escapeXml(submitUrl)}">

    <div style="text-align: right; border-top :0px; vertical-align: bottom;">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <table class="property-table" style="width: 100%">
      <tbody>
        <c:set var="fieldName" value="name"/>
        <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : project.name}"/>
        <error:field-error field="name" cssClass="${eo.next}"/>
        <tr class="${eo.last}" valign="top">
          <td width="20%"><span class="bold">${ub:i18n("NameWithColon")}&nbsp;<span class="required-text">*</span></span></td>
          <td width="30%"><ucf:text name="name" value="${nameValue}" enabled="${inEditMode}" size="60"/></td>
          <td><span class="inlinehelp">${ub:i18n("ProjectCreationNameDesc")}</span></td>
        </tr>

        <c:set var="fieldName" value="description"/>
        <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : project.description}"/>
        <error:field-error field="description" cssClass="${eo.next}"/>
        <tr class="${eo.last}" valign="top">
          <td width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
          <td colspan="2"><ucf:textarea name="description" value="${descriptionValue}" enabled="${inEditMode}"/></td>
        </tr>

        <tr class="${eo.next}" valign="top">
          <td width="20%"><span class="bold">${ub:i18n("TemplateWithColon")}</span></td>
          <td width="30%">
            <c:url var="templateUrl" value="${ProjectTemplateTasks.viewProjectTemplate}" />
            <ucf:link href="${templateUrl}" label="${projectTemplate.name}" enabled="${canViewTemplate and not isNew}"/>
            <br />
            <div style="font-style: italic; margin-top: 5px; margin-left: 15px;">${fn:escapeXml(projectTemplate.description)}</div>
          </td>
          <td>
            <span class="inlinehelp">${ub:i18n("ProjectCreationTemplateDesc")}</span>
          </td>
        </tr>

        <tr class="${eo.next}" valign="top">
          <td width="20%"><span class="bold">${ub:i18n("Tags")}</span></td>
          <td width="30%">
            <c:set var="fieldName" value="tag"/>
            <c:set var="existingTags" value="${paramValues[fieldName] != null ? paramValues[fieldName] : project.tags}"/>
            <ucf:tagSelector id="tagSelector" name="tagSelector" existingTags="${existingTags}" enabled="${inEditMode}"/>
          </td>
          <td>
            <span class="inlinehelp">${ub:i18n("ProjectTags")}</span>
          </td>
        </tr>
        <c:if test="${inViewMode}">
        <tr class="${eo.next}" valign="top">
          <td width="20%"><span class="bold">${ub:i18n("NotificationSubscriptionWithColon")}</span></td>
          <td width="30%">
            <c:set var="currentSubscription" value="${subscription.event != null ? subscription.event : SubscriptionEventEnum.DEFAULT}"/>
            <c:set var="subscriptionID" value="${subscription.id != null ? subscription.id : -1}"/>
            <c:url var="projectNotificationSubscriptionsUrl" value="/rest2/projects/${project.id}/notificationSubscriptions"/>
            <c:url var="notificationSubscriptionURL" value="/rest2/notificationSubscriptions"/>
            <div id="subscribeButton"></div>
                <script type="text/javascript">
                    require(["ubuild/module/UBuildApp", "ubuild/NotificationSubscriptionEditor"], function(UBuildApp, NotificationSubscriptionEditor) {
                        UBuildApp.util.i18nLoaded.then(function() {
                            var button = new NotificationSubscriptionEditor({
                              ID: ${project.id},
                              projectNotificationSubscriptionsURL: '${projectNotificationSubscriptionsUrl}',
                              notificationSubscriptionURL: '${notificationSubscriptionURL}',
                              currentStatus: '${currentSubscription.name}',
                              currentStatusLabel: '${currentSubscription.displayName}',
                              subscriptionID: ${subscriptionID},
                              isProject: true,
                              subscriptionEventJson:${subscriptionEventJson},
                              isButton: true
                            });
                            button.placeAt("subscribeButton");
                        });
                    });
                </script>
          </td>
          <td>
            <span class="inlinehelp"></span>
          </td>
        </tr>
        </c:if>
        <%-- I don't think this will ever be used. --%>
        <c:import url="/WEB-INF/snippets/admin/security/newSecuredObjectSecurityFields.jsp"/>

        <c:choose>
          <c:when test="${inEditMode}">
            <jsp:include page="/WEB-INF/jsps/admin/project/editPropertiesFromProjectTemplate.jsp">
              <jsp:param name="isEven" value="${eo.even}"/>
            </jsp:include>
          </c:when>
          <c:otherwise>
            <jsp:include page="/WEB-INF/jsps/admin/project/viewPropertiesFromProjectTemplate.jsp">
              <jsp:param name="isEven" value="${eo.even}"/>
            </jsp:include>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
    <br/>
    <c:if test="${inEditMode}">
      <c:if test="${canEdit}">
        <ucf:button name="saveProject" label="${ub:i18n('Save')}"/>
      </c:if>
      <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
    </c:if>
    <c:if test="${inViewMode}">
      <c:if test="${canEdit}">
        <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
        <ucf:button href="${exportUrl}" name="Export" label="${ub:i18n('Export')}"/>
          <c:if test="${canCopy}">
            <ucf:button name="Copy" label="${ub:i18n('CopyVerb')}" href="#" submit="${false}"
                onclick="showPopup('${ah3:escapeJs(copyUrl)}', 800, 400); return false;"/>
          </c:if>
        <c:choose>
          <c:when  test="${project.active}">
            <ucf:button href="${deactivateUrl}" name="Inactivate" label="${ub:i18n('Inactivate')}"
                confirmMessage="${ub:i18nMessage('ProjectDeactivateMessage', project.name)}"/>
          </c:when>
          <c:otherwise>
            <ucf:button href="${activateUrl}" name="Activate" label="${ub:i18n('Activate')}"
                confirmMessage="${ub:i18nMessage('ProjectActivateMessage', project.name)}"/>
            <ucf:button href="${deleteUrl}" name="Delete" label="${ub:i18n('Delete')}"
                confirmMessage="${ub:i18nMessage('DeleteConfirm', project.name)}"/>
          </c:otherwise>
        </c:choose>
      </c:if>
      <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
    </c:if>
  </form>

  <br/><br/>
