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

<c:url var="actionUrl" value="${BuildLifeTasks.addStamp}" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("AddManualStamp")}</a></li>
  </ul>
</div>
<div class="contents">
  <div class="system-helpbox">${ub:i18n("AddStampHelp")}</div>

  <br/>
  
  <c:choose>
    <c:when test="${buildLife.archived}">
      <span class="error">${ub:i18n("AddStampArchivedBuildLifeError")}</span>
      <br/><br/><br/>
      <ucf:button name="Close" label="${ub:i18n('Close')}" href="javascript:parent.hidePopup();" />
    </c:when>
    <c:when test="${buildLife.inactive}">
      <span class="error">${ub:i18n("AddStampInactiveBuildLifeError")}</span>
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
            
            <error:field-error field="${WebConstants.STAMP_VALUE}" cssClass="${eo.next}" />
            <tr class="${eo.last}" valign="top">
              <td align="left" width="20%">
                <span class="bold">${ub:i18n("StampWithColon")} <span class="required-text">*</span></span>
              </td>

              <td align="left" width="25%">
                <ucf:text name="${WebConstants.STAMP_VALUE}" value="${param.stampValue}"/>
              </td>

              <td align="left">
                <span class="inlinehelp">${ub:i18n("AddStampStampDesc")}</span>
              </td>
            </tr>
          </tbody>

          <c:set var="directDependencies" value="${buildLife.nonCsDependencyBuildLives}"/>
          <c:set var="allDependencies" value="${buildLife.allNonCsDependencyBuildLives}"/>
          <c:set var="hasTransitiveDependencies" value="${fn:length(allDependencies) gt fn:length(directDependencies)}"/>
          
          <c:if test="${not empty directDependencies}">
          <tbody>
            <tr class="${eo.next}" valign="top">
              <td align="left" width="20%">
                <span class="bold">${ub:i18n("AddStampStampDependencies")}</span>
              </td>

              <td align="left" width="25%">
                <input type="radio" name="stampDependencies" value=""
                  <c:if test="${empty param.stampDependencies}">checked="checked"</c:if> />
                  ${ub:i18n("No")}<br/>
                <input type="radio" name="stampDependencies" value="direct"
                  <c:if test="${param.stampDependencies eq 'direct'}">checked="checked"</c:if> />
                  ${ub:i18n("DirectDependencies")}<br/>
                <c:if test="${hasTransitiveDependencies}">
                  <input type="radio" name="stampDependencies" value="all"
                    <c:if test="${param.stampDependencies eq 'all'}">checked="checked"</c:if>
                    />
                    ${ub:i18n("AllDependencies")}
                </c:if>
              </td>
              
              <td align="left">
                <span class="inlinehelp">${ub:i18n("AddStampStampDependenciesDesc")}</span>
              </td>
            </tr>
          </tbody>
          </c:if>

        </table>

        <br/>
        <ucf:button name="Add" label="${ub:i18n('Add')}" />
        <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="javascript:parent.hidePopup();" />
      </form>
    </c:otherwise>
  </c:choose>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
