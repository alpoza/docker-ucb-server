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
<%@page import="com.urbancode.ubuild.web.admin.license.LicenseTasks" %>
<%@page import="com.urbancode.ubuild.services.license.rcl.RCLLicenseService" %>
<%@page import="com.urbancode.ubuild.services.license.rcl.RCLManager" %>
<%@page import="com.urbancode.ubuild.services.license.rcl.UCBLicenseType" %>
<%@page import="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettingsFactory" %>
<%@page import="com.ibm.rcl.ibmratl.LicenseControl" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input" %>
<%@ taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.license.LicenseTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="selected" value="system"/>
  <jsp:param name="title" value="${ub:i18n('LicenseCommitters')}" />
</jsp:include>

<div style="padding-bottom: 1em;">
    <jsp:include page="licenseListTabs.jsp">
        <jsp:param name="selected" value="users"/>
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
            
            <table class="property-table">
              <tr class="${fn:escapeXml(eo.next)}" valign="top">
                <c:set var="overLicenseCount" value="${licensesNeeded > licensesAvailable}"/>
                <td align="left" nowrap="nowrap"><span class="bold">${ub:i18n("LicensedCommitterUtilization")}</span></td>
                <td align="left" width="80%">
                    <c:if test="${overLicenseCount}"><span class="error"></c:if>
                      ${licensesNeeded} / ${licensesAvailable}
                    <c:if test="${overLicenseCount}"></span></c:if>
                </td>
              </tr>
            </table>
            <c:if test="${not overLicenseCount}">
              <br/>
            </c:if>
            
            <table class="data-table">
              <thead>
                <tr>
                  <th scope="col" align="left" valign="middle" nowrap="nowrap">${ub:i18n("LicenseCommitterName")}</th>
                  <th scope="col" align="center" nowrap="nowrap">${ub:i18n("LicenseUsingLicense")}</th>
                  <th scope="col" align="center" nowrap="nowrap">${ub:i18n("LicenseLastCommit")}</th>
                </tr>
              </thead>
              <tbody>

                    <c:if test="${empty committers}">
                      <tr bgcolor="#ffffff">
                        <td colspan="3" nowrap="nowrap">
                          ${ub:i18n("LicenseNoCommittersMessage")}
                        </td>
                      </tr>
                    </c:if>

                    <c:forEach var="committer" items="${committers}">
                        <tr bgcolor="#ffffff">
                          <td align="left" height="1" nowrap="nowrap">${fn:escapeXml(committer.name)}</td>
                          <c:choose>
                            <c:when test="${committer.licenseNeeded}">
                              <c:choose>
                                <c:when test="${committer.licensed}">
                                  <td width="20%" align="center" nowrap="nowrap"style="background-color:#cce3a8;">
                                    ${ub:i18n("Yes")}
                                  </td>
                                </c:when>
                                <c:otherwise>
                                  <td width="20%" align="center" nowrap="nowrap"
                                      style="background-color:#eccac3;">
                                    ${ub:i18n("No")}
                                  </td>
                                </c:otherwise>
                              </c:choose>
                            </c:when>
                            <c:otherwise>
                              <td width="20%" align="center" nowrap="nowrap">
                                ${ub:i18n("Not Needed")}
                              </td>
                            </c:otherwise>
                          </c:choose>
                          <td width="20%" nowrap="nowrap">
                            ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, committer.lastCommitDate))}
                          </td>
                        </tr>
                    </c:forEach>

              </tbody>
            </table>
      </div>
    </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
