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

<c:set var="disableButtons" value="${user != null && fn:escapeXml(mode) == 'edit'}"/>
<c:url var="submitUrl" value="${UserTasks.newUser}" />

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('UsersSettings')}"/>
    <c:param name="selected" value="teams"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<div style="padding-bottom: 1em;">

  <c:choose>
    <c:when test="${user == null}">
      <c:import url="newUserTabs.jsp">
        <c:param name="selected" value="settings"/>
        <c:param name="disabled" value="${fn:escapeXml(mode) == 'edit'}"/>
      </c:import>
    </c:when>
    <c:otherwise>
      <c:import url="userSubTabs.jsp">
        <c:param name="selected" value="settings"/>
        <c:param name="disabled" value="${fn:escapeXml(mode) == 'edit'}"/>
      </c:import>
    </c:otherwise>
  </c:choose>

  <div class="contents">
    <c:choose>
      <c:when test="${authenticationRealmId != null || user != null}">
        <div class="system-helpbox">
          ${ub:i18n("UsersViewSystemHelpBox")}
        </div>
        <br/>
        <c:import url="userForm.jsp"/>
        <br/>
      </c:when>
      <c:otherwise>
        <br/>
        <%-- Select Authentication Realm --%>
        <form method="post" action="${fn:escapeXml(submitUrl)}">
          <table class="property-table">
            <tbody>
              <tr class="odd">
                <td align="left" width="20%"><span class="bold">${ub:i18n("AuthenticationRealmWithColon")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%"><ucf:idSelector name="${WebConstants.AUTHENTICATION_REALM_ID}"
                    list="${authenticationRealmList}" selectedId="${authenticationRealm.id}" /></td>
                <td><span class="inlinehelp">${ub:i18n("UsersViewAuthRealmDesc")}</span>
                </td>
              </tr>
              <tr class="odd">
                <td colspan="3"><ucf:button name="Set" label="${ub:i18n('Select')}" /></td>
              </tr>
            </tbody>
          </table>
        </form>
      </c:otherwise>
    </c:choose>
  </div>
</div>
    
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
