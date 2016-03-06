<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.project.BuildLifeTasks"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Properties" %>


<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page buffer="256kb"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18n("SourceChanges")}</a></li>
    </ul>
  </div>
  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("ChangeTrendsHelp")}
    </div>

    <form action="${fn:escapeXml(actionUrl)}" method="get">
      <input type="hidden" name="${WebConstants.BUILD_LIFE_ID}" value="${fn:escapeXml(buildLife.id)}"/>

      <table class="property-table">
        <tbody>
          <tr><td align="right" style="border-top :0px; vertical-align: bottom;" colspan="4">
            <span class="required-text">${ub:i18n("RequiredField")}</span>
          </td></tr>

          <error:field-error field="${WebConstants.BUILD_LIFE_SINCE_ID}" cssClass="odd"/>
          <tr class="odd" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("Since")} <span class="required-text">*</span></span></td>

            <td align="left" width="20%">
              <ucf:trendBuildLifeSelector sinceId="${changeTrend.since.id}" buildLifeList="${buildLifeList}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ChangeTrendsSinceBuildLifeDesc")}</span>
            </td>
          </tr>
          <tr class="even" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("IncludeDependencies")}</span></td>
            <td align="left" width="20%">
              <ucf:checkbox name="changeTrendsIncludeDependencies" checked="${changeTrend.includeDependencies}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("IncludeDependenciesDesc")}</span>
            </td>
          </tr>
        </tbody>
      </table>
      <br/>
      <ucf:button name="Select" label="${ub:i18n('Select')}"/>
      <ucf:button name="close1" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;"/>
      <br/>
      <br/>
      <c:if test="${not empty changeTrend}">
        <c:choose>
          <c:when test="${changeTrend.preInitializeTimedOut}">
            <div class="changeTrend-error">
              ${ub:i18n("TrendsTimeout")}
            </div>
          </c:when>
          <c:otherwise>
            <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
              <c:param name="buildLifeId" value="${changeTrend.first.id}"/>
            </c:url>

            <div id="changelog_${changeTrend.first.id}" class="changeTrend-buildLife">
              <h3><ui:buildLifeLabel bl="${changeTrend.first}"/></h3>
              <ui:changelog changeSets="${changeTrend.changeSets}"/>
            </div>
      
            <c:if test="${changeTrend.includeDependencies}">
              <div class="changeTrend-dependencies">
                  <br/>
                  <c:choose>
                    <c:when test="${not empty changeTrend.dependencyTrends}">
                      <h3>${ub:i18n("DependencyChanges")}</h3>
                    </c:when>
                    <c:otherwise>
                      <div class="system-helpbox">${ub:i18n("ChangeTrendsNoDependencyChanges")}</div>
                    </c:otherwise>
                  </c:choose>
      
                <c:forEach var="dependency" items="${changeTrend.dependencyTrends}">
                  <c:url var="dependencyUrl" value="${BuildLifeTasks.viewBuildLife}">
                    <c:param name="buildLifeId" value="${dependency.first.id}"/>
                  </c:url>
              
                  <div  id="changelog_${dependency.first.id}" class="changeTrend-dependency">
                    <h3>
                      <a href="${fn:escapeXml(dependencyUrl)}" target="_top"><ui:buildLifeLabel bl="${dependency.first}"/></a>
                    </h3>
                    <ui:changelog changeSets="${dependency.changeSets}"/>
                  </div>
                </c:forEach>
              </div>
            </c:if>
          </c:otherwise>
        </c:choose>
        <br/>
        <ucf:button name="close2" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;"/>
      </c:if>
    </form>
  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
