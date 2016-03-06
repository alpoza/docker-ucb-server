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

<%@page import="com.urbancode.ubuild.web.admin.project.workflow.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" useConversation="false" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ProjectTasks" />

<c:url var="newBuildProcessUrl" value='${WorkflowTasks.newBuildProcess}'>
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>
<c:url var="newSecondaryProcessUrl" value='${WorkflowTasks.newSecondaryProcess}'>
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<c:url var="viewInactivesUrl" value="${ProjectTasks.viewInactives}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>
<c:url var="viewActivesUrl" value="${ProjectTasks.viewProject}">
  <c:param name="${WebConstants.PROJECT_ID}" value="${project.id}"/>
</c:url>

<auth:check persistent="${WebConstants.PROJECT}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}"/>

<c:url var="iconEditFindUrl" value="/images/icon_page_view.gif"/>
<c:url var="iconEditCopyUrl" value="/images/icon_copy_project.gif"/>
<c:url var="iconEditDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconEditInactiveUrl" value="/images/icon_inactive.gif"/>
<c:url var="iconEditActiveUrl" value="/images/icon_active.gif"/>

<error:field-error field="${WebConstants.WORKFLOW}"/>
<div class="project-component">
  <div style="text-align: right;">
    <c:choose>
      <c:when test="${viewInactives}">
        <ucf:button name="ViewActiveProjectComponents" label="${ub:i18n('ViewActiveProjectComponents')}" id="viewActives" href="${viewActivesUrl}" />
      </c:when>
      <c:otherwise>
        <ucf:button name="ViewInactiveProjectComponents" label="${ub:i18n('ViewInactiveProjectComponents')}" id="viewInactives" href="${viewInactivesUrl}"/>
      </c:otherwise>
    </c:choose>
  </div>
  <br/>
  <div class="component-heading">
    <div style="float: right;">
      <c:if test='${param.enabled and not viewInactives and canEdit}'>
        <ucf:link label="${ub:i18n('New')}" href="#" onclick="showPopup('${ah3:escapeJs(newBuildProcessUrl)}', 800, 400); return false;" enabled="${param.enabled}"/>
      </c:if>
    </div>
    <c:choose>
      <c:when test="${viewInactives}">
        <c:out value="${ub:i18n('InactiveBuildProcesses')}"/>
      </c:when>
      <c:otherwise>
        <c:out value="${ub:i18n('BuildProcesses')}"/>
      </c:otherwise>
    </c:choose>
  </div>

  <c:choose>
    <c:when test="${viewInactives}">
      <c:set var="buildConfigList" value="${project.inactiveBuildProcessArray}"/>
    </c:when>
    <c:otherwise>
      <c:set var="buildConfigList" value="${project.buildProcessArray}"/>
    </c:otherwise>
  </c:choose>

  <table id="buildConfigurationTable" class="data-table">
    <tbody>
      <tr>
        <th scope="col" align="left" valign="middle" width="30%">${ub:i18n("Name")}</th>
        <th scope="col" align="left" valign="middle">${ub:i18n("Description")}</th>
        <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
      </tr>
      <c:if test="${fn:length(buildConfigList)==0}">
        <tr bgcolor="#ffffff">
          <td colspan="3">${ub:i18n("ProjectNoBuildProcessesMessage")}</td>
        </tr>
      </c:if>

      <c:forEach var="workflow" items="${buildConfigList}">

        <c:url var="viewUrlId" value='${WorkflowTasks.viewWorkflowMain}'>
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:url var="inactivateUrlId" value="${WorkflowTasks.inactivateWorkflow}">
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:url var="activateUrlId" value="${WorkflowTasks.activateWorkflow}">
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:url var="deleteUrlId" value='${WorkflowTasks.deleteWorkflow}'>
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:url var="dupeUrlId" value='${WorkflowTasks.duplicateWorkflow}'>
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:if test="${workflow.id!=null}">
          <tr bgcolor="#ffffff">
            <td align="left" height="1" nowrap="nowrap">
              <ucf:link href="${viewUrlId}" label="${workflow.name}" enabled="${param.enabled}"/>
            </td>

            <td align="left" height="1" ><c:out value="${workflow.description}"/></td>

            <td align="center" height="1" width="10%" nowrap="nowrap">
              <ucf:link href="${viewUrlId}" label="${ub:i18n('View')}" img="${iconEditFindUrl}" enabled="${param.enabled}"/>&nbsp;
              <c:if test="${canEdit}">
                <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(dupeUrlId)}', 800, 400); return false;"
                  label="${ub:i18n('CopyVerb')}" img="${iconEditCopyUrl}" enabled="${param.enabled}"/>&nbsp;
              </c:if>
              <c:choose>
                <c:when test="${not canEdit}">
                  <%-- Hide the button --%>
                </c:when>
                <c:when test="${viewInactives}">
                  <ucf:confirmlink href="${activateUrlId}" label="${ub:i18n('Activate')}"
                      img="${iconEditInactiveUrl}" enabled="${param.enabled}"
                      message="${ub:i18nMessage('ProcessActivateMessage', workflow.name)}"/>&nbsp;
                  <ucf:deletelink href="${deleteUrlId}" name="${workflow.name}" label="${ub:i18n('Delete')}"
                    img="${iconEditDeleteUrl}" enabled="${param.enabled}"/>
                </c:when>
                <c:otherwise>
                  <ucf:confirmlink href="${inactivateUrlId}" label="${ub:i18n('Inactivate')}"
                      img="${iconEditActiveUrl}" enabled="${param.enabled}"
                      message="${ub:i18nMessage('ProcessDeactivateMessage', workflow.name)}"/>&nbsp;
                </c:otherwise>
              </c:choose>
            </td>

          </tr>
        </c:if>
      </c:forEach>
    </tbody>
  </table>
  <br/>
</div>
<br/>
<div class="project-component">
  <div class="component-heading">
    <div style="float:right;">
      <c:if test='${param.enabled and not viewInactives and canEdit}'>
        <ucf:link label="${ub:i18n('New')}" enabled="${param.enabled}" href="#"
            onclick="showPopup('${ah3:escapeJs(newSecondaryProcessUrl)}', 800, 400); return false;"/>
      </c:if>
    </div>
    <c:choose>
      <c:when test="${viewInactives}">
        <c:out value="${ub:i18n('InactiveSecondaryProcesses')}"/>
      </c:when>
      <c:otherwise>
        <c:out value="${ub:i18n('SecondaryProcesses')}"/>
      </c:otherwise>
    </c:choose>
  </div>

  <c:choose>
    <c:when test="${viewInactives}">
      <c:set var="secondaryProcessList" value="${project.inactiveSecondaryProcessArray}"/>
    </c:when>
    <c:otherwise>
      <c:set var="secondaryProcessList" value="${project.secondaryProcessArray}"/>
    </c:otherwise>
  </c:choose>
  <table id="secondaryProcessTable" class="data-table">
    <tbody>
      <tr>
        <th scope="col" align="left" valign="middle" width="30%">${ub:i18n("Name")}</th>
        <th scope="col" align="left" valign="middle">${ub:i18n("Description")}</th>
        <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
      </tr>
      <c:if test="${fn:length(secondaryProcessList)==0}">
        <tr bgcolor="#ffffff">
          <td colspan="3">${ub:i18n("ProjectNoSecondaryMessage")}</td>
        </tr>
      </c:if>

      <c:forEach var="workflow" items="${secondaryProcessList}">

        <c:url var="viewUrlId" value='${WorkflowTasks.viewWorkflowMain}'>
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:url var="inactivateUrlId" value="${WorkflowTasks.inactivateWorkflow}">
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:url var="activateUrlId" value="${WorkflowTasks.activateWorkflow}">
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:url var="deleteUrlId" value='${WorkflowTasks.deleteWorkflow}'>
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:url var="dupeUrlId" value='${WorkflowTasks.duplicateWorkflow}'>
          <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
        </c:url>

        <c:if test="${workflow.id!=null}">
          <tr bgcolor="#ffffff">
            <td align="left" height="1" nowrap="nowrap">
              <ucf:link href="${viewUrlId}" label="${workflow.name}" enabled="${param.enabled}"/>
            </td>

            <td align="left" height="1" ><c:out value="${workflow.description}"/></td>

            <td align="center" height="1" width="10%" nowrap="nowrap">
              <ucf:link href="${viewUrlId}" label="${ub:i18n('View')}" img="${iconEditFindUrl}" enabled="${param.enabled}"/>&nbsp;
              <c:if test="${canEdit}">
                <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(dupeUrlId)}', 800, 400); return false;"
                  label="${ub:i18n('CopyVerb')}" img="${iconEditCopyUrl}" enabled="${param.enabled}"/>&nbsp;
              </c:if>
              <c:choose>
              <c:when test="${not canEdit}">
                  <%-- Hide the button --%>
              </c:when>
              <c:when test="${viewInactives}">
                <ucf:confirmlink href="${activateUrlId}" label="${ub:i18n('Activate')}"
                    img="${iconEditInactiveUrl}" enabled="${param.enabled}"
                    message="${ub:i18nMessage('ProcessActivateMessage', workflow.name)}"/>&nbsp;
                <ucf:deletelink href="${deleteUrlId}" name="${workflow.name}" label="${ub:i18n('Delete')}"
                  img="${iconEditDeleteUrl}" enabled="${param.enabled}"/>&nbsp;
              </c:when>
              <c:otherwise>
                <ucf:confirmlink href="${inactivateUrlId}" label="${ub:i18n('Inactivate')}"
                    img="${iconEditActiveUrl}" enabled="${param.enabled}"
                    message="${ub:i18nMessage('ProcessDeactivateMessage', workflow.name)}"/>&nbsp;
              </c:otherwise>
              </c:choose>
            </td>

          </tr>
        </c:if>
      </c:forEach>
    </tbody>
  </table>
  <br/>
</div>
