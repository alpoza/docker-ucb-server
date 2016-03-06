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
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLife"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="java.util.*"%>

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
<ah3:useEnum enum="com.urbancode.ubuild.domain.buildlife.BuildLifeLabelCascade"/>

<c:url var="actionUrl" value="${BuildLifeTasks.assignLabel}" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("Assign Label")}</a></li>
  </ul>
</div>
<div class="contents">
  <div class="system-helpbox">${ub:i18n("BuildLifeAssignLabelHelp")}</div>

  <br/>

  <c:choose>
    <c:when test="${buildLife.archived}">
      <span class="error">${ub:i18n("AssignLabelArchivedBuildLifeError")}</span>
      <br/><br/><br/>
      <ucf:button name="Close" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;" />
    </c:when>
    <c:when test="${buildLife.inactive}">
      <span class="error">${ub:i18n("AssignLabelInactiveBuildLifeError")}</span>
      <br/><br/><br/>
      <ucf:button name="Close" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;" />
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

            <error:field-error field="${WebConstants.LABEL_ID}" cssClass="${eo.next}" />
            <tr class="${eo.last}" valign="top">
              <td align="left" width="20%">
                <span class="bold">${ub:i18n("ExistingLabel")}</span>
              </td>

              <td align="left" width="25%">
                <ucf:idSelector name="${WebConstants.LABEL_ID}" list="${labelList}" selectedId="${param.labelId}"/>
              </td>

              <td align="left">
                <span class="inlinehelp">${ub:i18n("AssignLabelExistingLabelDesc")}</span>
              </td>
            </tr>

            <error:field-error field="${WebConstants.LABEL}" cssClass="${eo.next}" />
            <tr class="${eo.last}" valign="top">
              <td align="left" width="20%">
                <span class="bold">${ub:i18n("NewLabel")}</span>
              </td>

              <td align="left" width="25%">
                <ucf:text name="${WebConstants.LABEL}" value="${param.label}"/>
              </td>

              <td align="left">
                <span class="inlinehelp">${ub:i18n("AssignLabelNewLabelDesc")}</span>
              </td>
            </tr>

            <c:set var="directDependencies" value="${buildLife.nonCsDependencyBuildLives}"/>
            <c:set var="allDependencies" value="${buildLife.allNonCsDependencyBuildLives}"/>
            <c:set var="hasTransitiveDependencies" value="${fn:length(allDependencies) gt fn:length(directDependencies)}"/>

            <c:if test="${not empty directDependencies}">
              <tr class="${eo.next}" valign="top">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("AssignLabelLabelDependencies")}</span>
                </td>
                <td align="left" width="25%">
                  <input type="radio" name="labelDependencies" value="${BuildLifeLabelCascade.NONE}"
                    <c:if test="${empty param.labelDependencies}">checked="checked"</c:if>/>
                    ${ub:i18n("No")}<br/>
                  <input type="radio" name="labelDependencies" value="${BuildLifeLabelCascade.DIRECT}"
                    <c:if test="${param.labelDependencies eq 'direct'}">checked="checked"</c:if>/>
                    ${ub:i18n("DirectDependencies")}<br/>
                  <c:if test="${hasTransitiveDependencies}">
                    <input type="radio" name="labelDependencies" value="${BuildLifeLabelCascade.ALL}"
                      <c:if test="${param.labelDependencies eq 'all'}">checked="checked"</c:if>/>
                      ${ub:i18n("AllDependencies")}
                  </c:if>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("AssignLabelLabelDependenciesDesc")}</span>
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>

        <br/>
        <ucf:button name="Assign" label="${ub:i18n('Assign')}" />
        <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="javascript:parent.hidePopup();" />
      </form>
    </c:otherwise>
  </c:choose>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
