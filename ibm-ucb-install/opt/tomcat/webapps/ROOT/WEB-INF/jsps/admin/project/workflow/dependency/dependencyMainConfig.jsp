<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.profile.*"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks"%>
<%@page import="com.urbancode.ubuild.web.*" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useTasks id="WorkflowTasksNoConversation" class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" useConversation="false"/>
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="editConflictStratUrl" value="${WorkflowTasksNoConversation.editConflictStrat}">
  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
</c:url>

<c:url var="saveConflictStratUrl"   value="${WorkflowTasks.saveConflictStrat}"/>
<c:url var="cancelUrl" value="${WorkflowTasks.cancelConflictStrat}"/>

<auth:check persistent="${workflow.project}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}"/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<form method="post" action="${fn:escapeXml(saveConflictStratUrl)}">

  <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>

  <table class="property-table">
    <tbody>
      <error:field-error field="conflictStrat" cssClass="${eo.next}"/>
      <tr class="${eo.last}" valign="top">
        <%
          pageContext.setAttribute("stratEnumList", BuildProfile.ConflictStratEnum.getEnumTypes());
        %>
        <td align="left" width="15%"><span class="bold">${ub:i18n("DependencyConflictStrategy")} <span class="required-text">*</span></span></td>

        <td align="left" width="20%">
          <ucf:nameSelector name="conflictStrat"
                       list="${stratEnumList}"
                       selectedValue="${workflow.buildProfile.dependencyConflictStrategy.name}"
                       enabled="${param.enabled && editConflict}"
                       />
        </td>

        <td align="left">
          <div class="inlinehelp">
            ${ub:i18n("DependencyConflictStrategyDesc")}<br/>
            <ul>
              <li>${ub:i18n("DependencyConflictStrategyFailDesc")}</li>
              <li>${ub:i18n("DependencyConflictStrategyFavorOldDesc")}</li>
              <li>${ub:i18n("DependencyConflictStrategyFavorNewDesc")}</li>
            </ul>
          </div>
        </td>
      </tr>

      <error:field-error field="triggerOnlyDependencies" cssClass="${eo.next}"/>
      <tr class="${eo.last}" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("TriggerOnlyDependencies")}</span></td>

        <td align="left" width="20%">
          <ucf:checkbox name="triggerOnlyDependencies"
                        checked="${workflow.buildProfile.triggerOnlyDependencies}"
                        enabled="${param.enabled && editConflict}"
                        value="true"/>
        </td>

        <td align="left">
          <div class="inlinehelp">${ub:i18n("DependencyTriggerDesc")}</div>
        </td>
      </tr>

      <tr>
        <td colspan="3">
          <c:choose>
            <c:when test="${param.enabled && editConflict}">
              <ucf:button name="Save" label="${ub:i18n('Save')}" enabled="${canEdit}"/>
              <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
            </c:when>
            <c:otherwise>
              <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editConflictStratUrl}" enabled="${param.enabled && canEdit}"/>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </tbody>
  </table>

</form>
