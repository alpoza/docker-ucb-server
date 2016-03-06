<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:set var="actionUrl" value="${BuildLifeTasks.runNonOriginatingWorkflowStep1}" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("Run Secondary Process")}</a></li>
  </ul>
</div>
<div class="contents">
  <div class="system-helpbox">${ub:i18n("RunSecondaryProcessHelp")}</div>

  <br/>

  <c:choose>
    <c:when test="${buildLife.archived}">
      <span class="error">${ub:i18n("RunSecondaryProcessArchivedBuildLifeError")}</span>
      <br/><br/><br/>
      <ucf:button name="Close" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;" />
    </c:when>
     <c:otherwise>
      <c:choose>
        <c:when test="${buildLife.inactive}">
          <span class="error">${ub:i18n("RunSecondaryProcessInactiveBuildLifeError")}</span>
          <br/><br/><br/>
          <ucf:button name="Close" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;" />
        </c:when>
        <c:when	test="${fn:length(key_secondary_workflows) == 0}">
          <span class="error">${ub:i18n("RunSecondaryProcessNoSecondaryProcessesError")}</span>
          <br/><br/><br/>
          <ucf:button name="Close" label="${ub:i18n('Close')}" href="javascript:parent.hidePopup();" />
        </c:when>
        <c:otherwise>
          <%
            pageContext.setAttribute("eo", new EvenOdd());
          %>
          <form action="${fn:escapeXml(actionUrl)}" method="post">
            <input type="hidden" name="${fn:escapeXml(WebConstants.BUILD_LIFE_ID)}" value="${fn:escapeXml(buildLife.id)}"/>

            <div style="text-align: right;"><span class="required-text">${ub:i18n("RequiredField")}</span></div>

            <table class="property-table">
              <tbody>
                <c:import url="/WEB-INF/jsps/project/workflow/administrativeLockWarning.jsp"/>

                <error:field-error field="${WebConstants.WORKFLOW_ID}" cssClass="${eo.next}" />
                <tr class="${eo.last}" valign="top">
                  <td align="left" width="20%">
                    <span class="bold">${ub:i18n("ProcessWithColon")} <span class="required-text">*</span></span>
                  </td>

                  <td align="left" width="25%">
                    <ucf:idSelector
                      name="${WebConstants.WORKFLOW_ID}"
                      list="${key_secondary_workflows}"
                      selectedId="${workflow.id}"/>
                  </td>

                  <td align="left">
                    <span class="inlinehelp">${ub:i18n("RunSecondaryProcessProcessDesc")}</span>
                  </td>
                </tr>
              </tbody>
            </table>
            <br/>
            <ucf:button name="Next" label="${ub:i18n('Next')}"/>
            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="javascript:parent.hidePopup();" />
          </form>
        </c:otherwise>
      </c:choose>
    </c:otherwise>
  </c:choose>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
