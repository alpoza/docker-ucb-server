<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.cleanup.CleanupConfig" %>
<%@page import="com.urbancode.ubuild.domain.schedule.*" %>
<%@page import="com.urbancode.ubuild.domain.status.Status" %>
<%@page import="com.urbancode.ubuild.domain.persistent.Handle" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.cleanup.CleanupTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="submitUrl" value="${CleanupTasks.saveCleanupBuildLivesPopup}"/>
<%
    EvenOdd eo = new EvenOdd();
    pageContext.setAttribute("eo", eo);
%>

<c:set var="statusName" value="${status.name}"/>

<%-- BEGIN PAGE --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<div style="padding-bottom: 1em;">
    <div class="popup_header">
        <ul>
            <li class="current">
                <a>
                <c:choose>
                  <c:when test="${statusName != null}">
                    ${ub:i18nMessage("CleanupObject", fn:escapeXml(statusName))}
                  </c:when>
                  <c:otherwise>
                    <c:choose>
                      <c:when test="${isDeactiveSetting}">
                        ${ub:i18n("CleanupDeactivatedBuildLives")}
                      </c:when>
                      <c:otherwise>
                        ${ub:i18n("CleanupAllBuildLives")}
                      </c:otherwise>
                    </c:choose>
                  </c:otherwise>
                </c:choose>
                </a>
            </li>
        </ul>
    </div>
    <div class="contents">
    <div class="system-helpbox">
      <c:choose>
        <c:when test="${statusName != null}">
          ${ub:i18nMessage("CleanupBuildLivesPopupSystemHelpBoxWithStatus", fn:escapeXml(statusName))}
        </c:when>
        <c:otherwise>
          ${ub:i18n("CleanupBuildLivesPopupSystemHelpBox")}
        </c:otherwise>
      </c:choose>
    </div><br />
        <form method="post" action="${fn:escapeXml(submitUrl)}">
            <ucf:hidden name="deactiveSettings" value="${param.deactiveSettings}"/>
            <ucf:hidden name="${WebConstants.STATUS_ID}" value="${status.id}"/>
            <table class="property-table">
                <tbody>
                    <error:field-error field="keepDays" cssClass="${eo.next}"/>
                    <tr class="${fn:escapeXml(eo.last)}">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("KeepDaysWithColon")}</span></td>
                        <td align="left">
                            <ucf:text name="keepDays" value="${keepDays}"/><br/>

                            <span class="inlinehelp">
                                <c:choose>
                                  <c:when test="${statusName != null}">
                                    ${ub:i18nMessage("CleanupBuildLivesPopupKeepDaysDescWithStatus", fn:escapeXml(statusName))}
                                  </c:when>
                                  <c:otherwise>
                                    ${ub:i18n("CleanupBuildLivesPopupKeepDaysDesc")}
                                  </c:otherwise>
                                </c:choose>
                                <br/><span class="bold">
                                  <c:choose>
                                    <c:when test="${statusName != null}">
                                      ${ub:i18nMessage("CleanupBuildLivesPopupKeepDaysDescWithStatus2",fn:escapeXml(statusName))}
                                    </c:when>
                                    <c:otherwise>
                                      ${ub:i18n("CleanupBuildLivesPopupKeepDaysDesc2")}
                                    </c:otherwise>
                                  </c:choose>
                                </span>
                            </span>
                        </td>
                    </tr>
                    <error:field-error field="keepYoungest" cssClass="${eo.next}"/>
                    <tr class="${eo.last}">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("KeepLatestWithColon")}</span></td>
                        <td align="left">
                            <ucf:text name="keepYoungest" value="${keepYoungest}"/><br/>

                            <span class="inlinehelp">
                              <c:choose>
                                <c:when test="${statusName != null}">
                                  ${ub:i18n("CleanupBuildLivesPopupKeepLatestDescWithStatus")}
                                </c:when>
                                <c:otherwise>
                                  ${ub:i18n("CleanupBuildLivesPopupKeepLatestDesc")}
                                </c:otherwise>
                              </c:choose>
                            </span>
                        </td>
                    </tr>
                  <error:field-error field="cleanupType" cssClass="${eo.next}"/>
                  <tr class="${fn:escapeXml(eo.last)}">
                      <td align="left" width="20%"><span class="bold">${ub:i18n("CleanupType")}</span></td>
                      <td align="left">
                        <% pageContext.setAttribute("cleanupTypes", CleanupConfig.getCleanupTypeArray()); %>
                          <ucf:idSelector name="cleanupType" list="${cleanupTypes}" selectedId="${cleanupType}" />
                          <br/>
                          <span class="inlinehelp">
                              ${ub:i18n("CleanupTypeDesc")}
                          </span>
                      </td>
                  </tr>
                    <tr>
                        <td colspan="3">
                            <ucf:button name="save" label="${ub:i18n('Save')}"/>
                            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="parent.hidePopup(); return false;"/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </div>
</div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
