<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.repository.RepositoryTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imgUrl" value="/images"/>

<c:url var="triggerTypeUrl" value='<%=new WorkflowTasks().methodUrl("viewTriggerTypes", false)%>'>
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>

<auth:check persistent="${workflow.project}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}"/>

<div>
    <ucf:button name="New" label="${ub:i18n('NewTrigger')}" href="${triggerTypeUrl}" enabled="${param.enabled && trigger==null && canEdit}"/><br/><br/>
</div>

<table id="triggerTable" class="data-table">
  <tbody>
    <tr>
      <th scope="col" align="left" valign="middle" width="5%">${ub:i18n("On")}</th>
      <th scope="col" align="left" valign="middle" width="40%">${ub:i18n("Name")}</th>
      <th scope="col" align="left" valign="middle" width="45%">${ub:i18n("Type")}</th>
      <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
    </tr>

    <c:forEach var="sourceConfig" items="${workflow.buildProfile.sourceConfigs}">
      <c:if test="${not empty sourceConfig.repository.repositoryTrigger}">
        <c:set var="repository" value="${sourceConfig.repository}"/>
        <c:set var="repositoryTrigger" value="${sourceConfig.repository.repositoryTrigger}"/>
        <tr bgcolor="#ffffff">
          <td align="center" height="1" width="5%" nowrap="nowrap">
            <c:choose>
              <c:when test="${!sourceConfig.ignoringRepositoryTrigger && repositoryTrigger.triggerable && workflow.active && workflow.project.active}">
                <img alt="${ub:i18n('Active')}" title="${ub:i18n('TriggerActive')}" src="${fn:escapeXml(imgUrl)}/icon_active.gif"/>
              </c:when>
              <c:otherwise>
                <c:set var="inactiveReason" value=""/>
                <c:if test="${sourceConfig.ignoringRepositoryTrigger}"><c:set var="inactiveReason" value="${ub:i18n('TriggerIgnoring')}"/></c:if>
                <c:if test="${!workflow.active}">
                  <c:if test="${not empty inactiveReason}"><c:set var="inactiveReason" value="${inactiveReason}, "/></c:if>
                  <c:set var="inactiveReason" value="${inactiveReason}${ub:i18n('TriggerWorkflowInactive')}"/>
                </c:if>
                <c:if test="${!workflow.project.active}">
                  <c:if test="${not empty inactiveReason}"><c:set var="inactiveReason" value="${inactiveReason}, "/></c:if>
                  <c:set var="inactiveReason" value="${inactiveReason}${ub:i18n('TriggerProjectInactive')}"/>
                </c:if>
                <img alt="${ub:i18n('Inactive')}" title="${ub:i18nMessage('TriggerInactiveBecause', inactiveReason)}" src="${fn:escapeXml(imgUrl)}/icon_inactive.gif"/>
              </c:otherwise>
            </c:choose>
          </td>

          <td align="left" height="1" width="40%" nowrap="nowrap">
              <c:url var="repositoryTriggerUrl" value="${RepositoryTasks.viewRepositoryTrigger}">
                  <c:param name="repositoryId" value="${repository.id}"/>
              </c:url>
              <c:out value="${repository.name}"/> - <c:out value="${sourceConfig.name}"/>
          </td>

          <td align="left" height="1" width="45%" nowrap="nowrap">${ub:i18n("TriggerRepositoryTriggerOnRepositoryDesc")}</td>

          <td align="center" height="1" width="10%" nowrap="nowrap">
            <c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
            <ucf:link href="${repositoryTriggerUrl}" label="${ub:i18n('ViewRepositoryTrigger')}" img="${iconMagnifyGlassUrl}" enabled="${param.enabled && canEdit}"/> &nbsp;

            <c:choose>
                <c:when test="${sourceConfig.ignoringRepositoryTrigger}">
                    <c:url var="useRepoTriggerUrl" value="${WorkflowTasks.setIgnoringRepositoryTrigger}">
                        <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
                        <c:param name="ignoringRepositoryTrigger" value="false"/>
                    </c:url>
                    <ucf:link href="${useRepoTriggerUrl}" label="${ub:i18n('UseRepositoryTrigger')}" img="${fn:escapeXml(imgUrl)}/icon_inactive.gif" enabled="${param.enabled && canEdit}"/> &nbsp;
                </c:when>
                <c:otherwise>
                    <c:url var="ignoreRepoTriggerUrl" value="${WorkflowTasks.setIgnoringRepositoryTrigger}">
                        <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
                        <c:param name="ignoringRepositoryTrigger" value="true"/>
                    </c:url>
                    <ucf:link href="${ignoreRepoTriggerUrl}" label="${ub:i18n('IgnoreRepositoryTrigger')}" img="${fn:escapeXml(imgUrl)}/icon_active.gif" enabled="${param.enabled && canEdit}"/> &nbsp;
                </c:otherwise>
            </c:choose>
            <c:url var="iconDeleteUrl" value="/images/icon_delete_disabled.gif"/>
            <img alt="${ub:i18n('DeleteDisabled')}" src="${iconDeleteUrl}"/>
          </td>
        </tr>
      </c:if>
    </c:forEach>
    
    <c:forEach var="trigger" items="${workflow.triggerArray}" varStatus="status">

      <c:url var="viewUrl" value="${WorkflowTasks.viewTrigger}">
        <c:param name="${WebConstants.TRIGGER_ID}" value="${trigger.id}"/>
      </c:url>

      <c:url var="deleteUrl" value="${WorkflowTasks.deleteTrigger}">
        <c:param name="${WebConstants.TRIGGER_ID}" value="${trigger.id}"/>
      </c:url>

      <tr bgcolor="#ffffff">
        <td align="center" height="1" width="5%" nowrap="nowrap">
          <c:choose>
            <c:when test="${trigger.triggerable}">
              <img alt="${ub:i18n('Active')}" title="${ub:i18n('Active')}" src="${fn:escapeXml(imgUrl)}/icon_active.gif"/>
            </c:when>
            <c:otherwise>
              <c:set var="inactiveReason" value=""/>
              <c:if test="${!trigger.enabled}"><c:set var="inactiveReason" value="${ub:i18n('TriggerDisabled')}"/></c:if>
              <c:if test="${!trigger.workflow.active}">
                <c:if test="${not empty inactiveReason}"><c:set var="inactiveReason" value="${inactiveReason}, "/></c:if>
                <c:set var="inactiveReason" value="${inactiveReason}${ub:i18n('TriggerWorkflowInactive')}"/>
              </c:if>
              <c:if test="${!trigger.project.active}">
                <c:if test="${not empty inactiveReason}"><c:set var="inactiveReason" value="${inactiveReason}, "/></c:if>
                <c:set var="inactiveReason" value="${inactiveReason}${ub:i18n('TriggerProjectInactive')}"/>
              </c:if>
              <img alt="${ub:i18n('Inactive')}" title="${ub:i18nMessage('TriggerInactiveBecause', inactiveReason)}" src="${fn:escapeXml(imgUrl)}/icon_inactive.gif"/>
            </c:otherwise>
          </c:choose>
        </td>

        <td align="left" height="1" width="40%" nowrap="nowrap">
          <ucf:link href="${viewUrl}" label="${trigger.name}" enabled="${param.enabled && canEdit}"/>
        </td>

        <td align="left" height="1" width="45%" nowrap="nowrap">${ub:i18n(fn:escapeXml(trigger.class.simpleName))}</td>

        <td align="center" height="1" width="10%" nowrap="nowrap">
            <c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
            <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
            <ucf:link href="${viewUrl}" label="${ub:i18n('View')}" img="${iconMagnifyGlassUrl}" enabled="${param.enabled && canEdit}"/> &nbsp;
            <c:choose>
                <c:when test="${trigger.enabled}">
                    <c:url var="setEnabledWorkflowTriggerUrl" value="${WorkflowTasks.setEnabledWorkflowTrigger}">
                        <c:param name="triggerId" value="${trigger.id}"/>
                        <c:param name="enabled" value="false"/>
                    </c:url>
                    <ucf:link href="${setEnabledWorkflowTriggerUrl}" label="${ub:i18n('TriggerDisable')}" img="${fn:escapeXml(imgUrl)}/icon_active.gif" enabled="${param.enabled && canEdit}"/> &nbsp;
                </c:when>
                <c:otherwise>
                    <c:url var="setEnabledWorkflowTriggerUrl" value="${WorkflowTasks.setEnabledWorkflowTrigger}">
                        <c:param name="triggerId" value="${trigger.id}"/>
                        <c:param name="enabled" value="true"/>
                    </c:url>
                    <ucf:link href="${setEnabledWorkflowTriggerUrl}" label="${ub:i18n('TriggerEnable')}" img="${fn:escapeXml(imgUrl)}/icon_inactive.gif" enabled="${param.enabled && canEdit}"/> &nbsp;
                </c:otherwise>
            </c:choose>
            <ucf:deletelink href="${deleteUrl}" name="${trigger.name}" label="${ub:i18n('Delete')}" img="${iconDeleteUrl}" enabled="${param.enabled && canEdit}"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>
<br/>
