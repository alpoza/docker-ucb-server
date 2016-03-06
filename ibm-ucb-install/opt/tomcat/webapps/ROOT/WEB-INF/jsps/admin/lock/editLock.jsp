<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.lock.LockableResourceTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@ page import="com.urbancode.ubuild.services.lock.LockManagerService" %>
<%@ page import="com.urbancode.ubuild.domain.lock.LockableResource" %>
<%@ page import="com.urbancode.commons.locking.LockManager" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.lock.LockableResourceTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="saveUrl"   value="${LockableResourceTasks.saveLock}"/>

<%
  EvenOdd eo = new EvenOdd();
  pageContext.setAttribute( "eo", eo );
  LockableResource res = (LockableResource) pageContext.findAttribute("lockRes");
  LockManager lpm = LockManagerService.getLockManager();
  pageContext.setAttribute("numLocksOnRes", Long.valueOf(lpm.getNumberOfLocksOnResource(res)));
%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <form method="post" action="${fn:escapeXml(saveUrl)}">
      <div>
          <div class="popup_header">
              <ul>
                  <li class="current"><a>${ub:i18n("LockableResourcesEditLock")}</a></li>
              </ul>
          </div>
          <div class="contents">
            <div class="system-helpbox">
              <c:choose>
                <c:when test="${numLocksOnRes gt lockRes.maxLockHolders}">
                  ${ub:i18n("LockableResourcesEditSystemHelpBoxFor1")}
                </c:when>
                <c:otherwise>
                  ${ub:i18nMessage("LockableResourcesEditSystemHelpBox", numLocksOnRes)}
                </c:otherwise>
              </c:choose>
            </div>

              <table class="property-table">
                <td align="right" style="border-top :0px; vertical-align: bottom;" colspan="4">
                   <span class="required-text">${ub:i18n("RequiredField")}</span>
                </td>
                  <tbody>
                      <c:set var="fieldName" value="name"/>
                      <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : lockRes.name}"/>
                      <error:field-error field="name" cssClass="${eo.next}"/>
                      <tr class="${fn:escapeXml(eo.last)}" valign="top">
                          <td align="left" width="25%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
                          <td align="left" width="20%">
                              <ucf:text name="name" value="${nameValue}"/>
                          </td>
                          <td align="left">
                              <span class="inlinehelp">${ub:i18n("LockableResourcesNameDesc")}</span>
                          </td>
                      </tr>

                      <c:set var="fieldName" value="description"/>
                      <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : lockRes.description}"/>
                      <error:field-error field="description" cssClass="${eo.next}"/>
                      <tr class="${fn:escapeXml(eo.last)}" valign="top">
                          <td align="left" width="25%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                          <td align="left" colspan="2">
                              <ucf:textarea name="description" value="${descriptionValue}"/>
                          </td>
                      </tr>

                      <c:set var="fieldName" value="${WebConstants.LOCK_MAX_HOLDERS}"/>
                      <c:set var="maxHoldersValue" value="${param[fieldName] != null ? param[fieldName] : lockRes.maxLockHolders}"/>
                      <error:field-error field="${WebConstants.LOCK_MAX_HOLDERS}" cssClass="${eo.next}"/>
                      <tr class="${fn:escapeXml(eo.last)}" valign="top">
                          <td align="left" width="25%"><span class="bold">${ub:i18n("LockableResourcesMaxLockHolders")} <span class="required-text">*</span></span></td>
                          <td align="left" width="20%">
                              <ucf:text name="${WebConstants.LOCK_MAX_HOLDERS}" value="${maxHoldersValue}" size="10"/>
                          </td>
                          <td align="left">
                              <span class="inlinehelp">${ub:i18n("LockableResourcesMaxLockHoldersDesc")}</span>
                          </td>
                      </tr>
                  </tbody>
              </table>
            <br/>
              <div>
                <ucf:button name="Save" label="${ub:i18n('Save')}"/>
                <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="javascript:parent.hidePopup();"/>
              </div>
          </div>
      </div>
  </form>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>