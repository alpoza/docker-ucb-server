<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.web.admin.security.UserTasks"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.UserTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="disableButtons" value="${user != null && fn:escapeXml(mode) == 'edit'}"/>
<c:url var="submitUrl" value="${UserTasks.saveImportUser}" />
<c:url var="backUrl" value="${UserTasks.viewUsers}" />

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('UsersSettings')}"/>
    <c:param name="selected" value="teams"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<div style="padding-bottom: 1em;">

  <c:import url="importUserTabs.jsp">
    <c:param name="selected" value="settings"/>
    <c:param name="disabled" value="${fn:escapeXml(mode) == 'edit'}"/>
  </c:import>

  <div class="contents">
    <div class="system-helpbox">${ub:i18n("ImportUsersHelp")}</div>
    <br/>
    <div style="text-align: right;">
     <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <br/>
    <%-- Select Authentication Realm --%>
    <form method="post" action="${fn:escapeXml(submitUrl)}">
      <table class="property-table">
        <tbody>
          <tr>
            <error:field-error field="${WebConstants.AUTHENTICATION_REALM}" cssClass="${eo.next}"/>
            <td align="left" width="20%"><span class="bold">${ub:i18n("AuthenticationRealmWithColon")} <span class="required-text">*</span></span></td>
            <td align="left" width="20%"><ucf:idSelector name="${WebConstants.AUTHENTICATION_REALM_ID}"
                list="${authenticationRealmList}" selectedId="${authenticationRealm.id}" optimizeOne="true"/></td>
            <td><span class="inlinehelp">${ub:i18n("ImportUsersAuthenticationRealmDesc")}</span>
            </td>
          </tr>
          <tr>
            <c:set var="fieldName" value="${WebConstants.USER}"/>
            <c:set var="userValue" value="${param[fieldName] != null ? param[fieldName] : ''}"/>
            <error:field-error field="${WebConstants.USER}" cssClass="${eo.next}"/>
            <td align="left" width="20%"><span class="bold">${ub:i18n("ImportUsersNameImportPattern")} <span class="required-text">*</span></span></td>
            <td align="left" width="20%"><ucf:text name="${WebConstants.USER}" value="${userValue}"/></td>
            <td><span class="inlinehelp">${ub:i18n("ImportUsersNameImportPatternDesc")}</span>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <ucf:button name="Import" label="${ub:i18n('Import')}" />
              <ucf:button href="${backUrl}" name="Done" label="${ub:i18n('Done')}" />
            </td>
          </tr>
          <c:if test="${userList != null}">
            <tr>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
              <td align="left" width="20%"><span class="bold">${ub:i18n("ImportedUsers")}</span></td>
              <td align="left" colspan="2">
                <c:if test="${empty userList}">
                  ${ub:i18n("ImportUsersNoUsersFound")}
                </c:if>
                <c:forEach  var="user" items="${userList}">
                  ${fn:escapeXml(user.name)}
                  <c:if test="${not empty user.actualName}">
                    &nbsp;(${fn:escapeXml(user.actualName)})
                  </c:if>
                  <br/>
                </c:forEach>
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </form>
  </div>
</div>

<c:remove var="userList" scope="session"/>
<c:remove var="authenticationRealm" scope="session"/>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
