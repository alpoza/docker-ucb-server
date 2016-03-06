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
      <li class="current"><a>${ub:i18n("Issues")}</a></li>
    </ul>
  </div>
  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("IssueTrendsHelp")}
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
              <ucf:trendBuildLifeSelector sinceId="${issueTrend.since.id}" buildLifeList="${buildLifeList}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("IssueTrendsSinceBuildLifeDesc")}</span>
            </td>
          </tr>
          <tr class="even" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("IncludeDependencies")}</span></td>
            <td align="left" width="20%">
              <ucf:checkbox name="issueTrendsIncludeDependencies" checked="${issueTrend.includeDependencies}"/>
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

      <c:if test="${not empty issueTrend}">
        <c:choose>
          <c:when test="${issueTrend.preInitializeTimedOut}">
            <div class="issueTrend-error">
              ${ub:i18n("TrendsTimeout")}
            </div>
          </c:when>
          <c:otherwise>
            <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
              <c:param name="buildLifeId" value="${issueTrend.first.id}"/>
            </c:url>
            
            <div id="issue_${issueTrend.first.id}" class="issueTrend-buildLife">
            <br/>
              <c:set var="sinceBuildLife" value="${not empty issueTrend.since.latestStampValue ? 
                issueTrend.since.latestStampValue : issueTrend.since.id}"/>
              <c:set var="toBuildLife" value="${not empty buildLife.latestStampValue ? buildLife.latestStampValue : buildLife.id}"/>
              <ui:issueList issueList="${issueTrend.issueList}" since="${sinceBuildLife}" buildLife="${toBuildLife}" 
                workflow="${buildLife.profile.workflow.name}" project="${buildLife.profile.project.name}"/>
            </div>
      
            <c:if test="${issueTrend.includeDependencies}">
              <div class="issueTrend-dependencies">
                <div class="issueTrend-dependenciesHeader">
                  <br/>
                  <c:choose>
                    <c:when test="${not empty issueTrend.dependencyTrends}">
                      ${ub:i18n("ChangedDependencies")}
                    </c:when>
                    <c:otherwise>
                      ${ub:i18n("IssueTrendsNoDependenciesChanged")}
                    </c:otherwise>
                  </c:choose>
                </div>
      
                <c:forEach var="dependency" items="${issueTrend.dependencyTrends}">
                  <c:url var="dependencyUrl" value="${BuildLifeTasks.viewBuildLife}">
                    <c:param name="buildLifeId" value="${dependency.first.id}"/>
                  </c:url>
              
                  <div  id="issue_${dependency.first.id}" class="issueTrend-dependency">
                    <div class="issueTrend-changelogHeader">
                      <a href="${fn:escapeXml(dependencyUrl)}" target="_top"><ui:buildLifeLabel bl="${dependency.first}"/></a>
                    </div>
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
