<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>

<%@page import="com.urbancode.ubuild.domain.repositoryusers.RepositoryCommitter" %>
<%@page import="com.urbancode.ubuild.services.repositoryusers.RepositoryUsersService" %>

<%@page import="com.urbancode.ubuild.services.license.rcl.RCLLicenseService" %>
<%@page import="com.urbancode.ubuild.services.license.rcl.RCLManager" %>
<%@page import="com.urbancode.ubuild.services.license.rcl.UCBLicenseType" %>
<%@page import="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettingsFactory" %>
<%@page import="com.ibm.rcl.ibmratl.LicenseControl" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@ taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input" %>
<%@ taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.license.LicenseTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="selected" value="teams"/>
  <jsp:param name="title" value="${ub:i18n('LicenseCommittersOverTime')}" />
</jsp:include>

<div style="padding-bottom: 1em;">
  <jsp:include page="licenseListTabs.jsp">
      <jsp:param name="selected" value="usersOverTime"/>
      <jsp:param name="disabled" value="${inEditMode}"/>
  </jsp:include>
  <div class="contents">
    <c:if test="${licenseService.evalPeriodExceeded}">
      <table class="dashboard-warning">
        <tr class="dashboard-region-title">
          <td>
            <span class="large-text" style="color:red; font-weight:bold;">
              ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
              ${ub:i18n("EvalPeriodExceededServerLock")}
            </span>
          </td>
        </tr>
      </table>
    </c:if>

    <c:if test="${licenseService.gracePeriodExceeded}">
      <table class="dashboard-warning">
        <tr class="dashboard-region-title">
          <td>
            <span class="large-text" style="color:red; font-weight:bold;">
              ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
              ${ub:i18n("GracePeriodExceededServerLock")}
            </span>
          </td>
        </tr>
      </table>
    </c:if>

    <c:if test="${licenseService.inEvalMode}">
      <table class="dashboard-region">
        <tr class="dashboard-region-title">
          <td>
            <span class="warningHeader">
              ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
              ${ub:i18n("ServerInEvalModeWarning")}
            </span>
          </td>
        </tr>
        <tr>
          <td><span class="warningHeader" style="font-weight:normal;">
              ${ub:i18nMessage("ServerLockWarning", licenseService.evalDaysRemaining)}
          </span></td>
        </tr>
      </table>
    </c:if>
    <c:if test="${licenseService.inGracePeriod}">
      <table class="dashboard-region">
        <tr class="dashboard-region-title">
          <td><span style="color:red;font-weight:bold;">${fn:toUpperCase(ub:i18n("Warning"))}<br/>
              ${ub:i18n("LicenseCommitterLimitExcededWarning")}</span>
          </td>
        </tr>
        <tr>
          <td><span style="color:red;font-weight:normal;">
              ${ub:i18nMessage("ServerLockWarning", licenseService.gracePeriodDaysRemaining)}
          </span></td>
        </tr>
      </table>
    </c:if>
    <br/>
    <b>${ub:i18nMessage("LicenseCommitterLengthMessage", committerStaleDays)}</b><br/>
    <br/>
    
    <c:url var="searchUrl" value="${LicenseTasks.viewUsersOverTime}"/>
    <form action="${searchUrl}" method="post">
      <div>
        <c:set var="endDate" value="${empty param.endDate ? requestScope.endDate : param.endDate}"/>
        <c:set var="dateRange" value="${empty param.dateRange ? requestScope.dateRange : param.dateRange}"/>
        <c:set var="showCommitters" value="${empty param.showCommitters ? requestScope.showCommitters : param.showCommitters}"/>
        <span class="label">${ub:i18n("DateWithColon")}</span> <ucf:text name="endDate" value="${endDate}" size="12"/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <span class="label">${ub:i18n("LicenseDaysToReport")}</span>
        <ucf:text name="dateRange" value="${dateRange}" size="5"/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <span class="label">${ub:i18n("LicenseShowCommitterNames")}</span>
        <ucf:checkbox name="showCommitters" checked="${showCommitters}"/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <ucf:button name="submit" label='${ub:i18n("Show")}'/>
      </div>
      <br/>
    </form>

    <table class="data-table">
      <thead>
        <tr>
          <th scope="col" nowrap="nowrap" width="10%">${ub:i18n("Date")}</th>
          <th scope="col" nowrap="nowrap" width="10%">${ub:i18n("LicenseCommitters")}</th>
          <c:if test="${showCommitters}">
            <th scope="col" nowrap="nowrap">${ub:i18n("LicenseCommitterName")}</th>
          </c:if>
        </tr>
      </thead>
      <tbody>

        <c:if test="${empty committersForDates}">
          <tr bgcolor="#ffffff">
            <td colspan="3" nowrap="nowrap">
              ${ub:i18n("LicenseNoCommittersMessage")}
            </td>
          </tr>
        </c:if>

        <c:forEach var="committersForDate" items="${committersForDates}">
            <tr>
              <td align="center" nowrap="nowrap">${fn:escapeXml(ah3:formatDate(shortDateFormat, committersForDate.date))}</td>
              <c:set var="committersUsed" value="${fn:length(committersForDate.committers)}"/>
              <c:set var="countBackground" value="#cce3a8"/>
              <c:if test="${committersUsed > committerLimit}">
                <c:set var="countBackground" value="#eccac3"/>
              </c:if>
              <td align="center" nowrap="nowrap" style="background-color: ${countBackground};">${committersUsed} / ${committerLimit}</td>
              <c:if test="${showCommitters}">
                <td><span class="small-text"><ucui:stringList list="${committersForDate.committers}"/></span></td>
              </c:if>
            </tr>
        </c:forEach>

      </tbody>
    </table>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
