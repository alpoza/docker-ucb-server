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
<%@ page import="com.urbancode.ubuild.domain.persistent.Handle"%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@ page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@ page import="com.urbancode.ubuild.domain.workflow.Workflow"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.project.WorkflowTasks"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="imsg" tagdir="/WEB-INF/tags/ui/admin/inactiveMessage" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
    Workflow workflow = (Workflow) request.getAttribute("workflow");
    if (!Authority.getInstance().hasPermission(workflow, UBuildAction.WORKFLOW_RUN)) {
%>

<div class="dashboard-contents">
  <div class="dashboard-contents-header" style="border-bottom: 1px solid #d3d3cf;">Run '${fn:escapeXml(workflow.name)}'</div>
  <div class="error" style="padding: 5px;">${ub:i18n("BuildWorkflowNoExecutePermissionError")}</div>
</div>

<%
    }
    else {
        EvenOdd eo = new EvenOdd();
        eo.setEven();
        pageContext.setAttribute("eo", eo);
%>

<div class="dashboard-contents">
  <div class="dashboard-contents-header" style="border-bottom: 1px solid #d3d3cf;">${ub:i18nMessage("BuildWorkflowRunProcess", fn:escapeXml(workflow.name))}</div>
  <c:url var="actionUrl" value="${WorkflowTasks.buildProject}"/>
  <form action="${fn:escapeXml(actionUrl)}" method="post">
    <input type="hidden" name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>

<c:set var="project" value="${workflow.project}"/>
<c:choose>
  <c:when test="${not project.inTemplateCompliance and not workflow.inTemplateCompliance}">
    <div class="workflowDetailItem">
      <span class="error">${ub:i18n("BuildWorkflowOutOfComplianceWithProjectAndTemplateError")}</span>
    </div>
  </c:when>
  <c:when test="${not workflow.inTemplateCompliance}">
    <div class="workflowDetailItem">
      <span class="error">${ub:i18n("ProcessViewOutOfComplianceMessage")}</span>
    </div>
  </c:when>
  <c:when test="${not project.inTemplateCompliance}">
    <div class="workflowDetailItem">
      <span class="error">${ub:i18n("BuildWorkflowOutOfComplianceWithProjectError")}</span>
    </div>
  </c:when>
</c:choose>

    <table class="property-table">

      <error:field-error field="invalidServerGroup" cssClass="${eo.last}"/>
      
      <c:import url="/WEB-INF/jsps/project/workflow/administrativeLockWarning.jsp"/>
      
      <tr class="${eo.next}" valign="top">
        <td width="20%" nowrap="nowrap">
          <span class="bold">${ub:i18n("Force")}</span>
        </td>
        <td colspan="2">
          <input type="checkbox" class="checkbox" name="forced" <c:if test="${empty nonforced}">checked="checked"</c:if>/>
        </td>
      </tr>

      <error:field-error field="delayDateTime" cssClass="${eo.next}"/>
      <tr class="${eo.last}" valign="top">
        <td width="20%" nowrap="nowrap">
          <span class="bold">${ub:i18n("DelayBuild")}</span>
        </td>
        <td colspan="2">
          <input type="checkbox" class="checkbox" name="delayed" ${delayed}
            onclick="if (this.checked) { showLayer('delayBuild'); } else { hideLayer('delayBuild'); }"/>
          <div id="delayBuild" <c:if test="${delayed == null}">style="display: none;visibility: visibility;"</c:if>>
          <table class="dashboard-text">
              <tr>
                <td>
                  <ucf:text name="delayDateTime" value="${delayDateTime}" size="20"/>  &nbsp;
                  <select name="delayMeridiem">
                      <option value="AM" <c:if test="${delayMeridiem == 'AM'}">selected</c:if>>AM</option>
                      <option value="PM" <c:if test="${delayMeridiem == 'PM'}">selected</c:if>>PM</option>
                  </select><br/>
                  <i>(mm/dd/yyyy hh:mm)</i>
                </td>
              </tr>
          </table>
          </div>
        </td>
      </tr>

      <c:import url="/WEB-INF/jsps/project/workflow/workflowProperties.jsp">
        <c:param name="isEven" value="${eo.even}"/>
      </c:import>

      <tr>
        <td colspan="3" style="border-top: none;">
          <div id="buildButtons">
              <table class="build-table">
                  <tr valign="top">
                      <td width="20%">
                      </td>
                      <td colspan="2">
                      
                          <c:if test="${not empty buildableErrorMessage}">
                            <div id="workflowBuildCheck" class="error" style="padding: 5px;">${buildableErrorMessage}</div>
                          </c:if>
                          
                          <ucf:button name="Build" label="${ub:i18n('Build')}" enabled="${workflow.inTemplateCompliance && project.inTemplateCompliance && (empty buildableErrorMessage) && workflow.active && project.active}"/>
                      </td>
                  </tr>
                  <tr>
                    <td colspan="3">
                      <imsg:inactiveMessage isActive="${workflow.active}" message="${ub:i18n('BuildWorkflowProcessDeactivatedError')}"/>
                      <imsg:inactiveMessage isActive="${not (workflow.active and not workflow.project.active)}" message="${ub:i18n('BuildWorkflowProcessProjectDeactivatedError')}"/>
                    </td>
                  </tr>
              </table>
          </div>
        </td>
      </tr>
    </table>
  </form>
</div>
<%
    }
%>
