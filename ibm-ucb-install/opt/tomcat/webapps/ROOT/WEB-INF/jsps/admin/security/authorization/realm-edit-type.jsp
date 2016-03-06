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
<%@page import="com.urbancode.ubuild.domain.security.AuthorizationRealmType" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@ page import="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useConstants class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" />
<%
  pageContext.setAttribute("eo", new EvenOdd());
  pageContext.setAttribute("authorizationRealmTypes", AuthorizationRealmType.values());
%>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="selected" value="system"/>
</jsp:include>

<c:url var="actionUrl" value="${AuthorizationRealmTasks.newAuthorizationRealm}"/>
<div style="padding-bottom: 1em;">
  <c:import url="/WEB-INF/jsps/admin/security/authorization/securityAuthorizationSubTabs.jsp">
      <c:param name="disabled" value="${inEditMode}"/>
  </c:import>
  <div class="contents">
    <div class="system-helpbox">${ub:i18n("AuthorizationSelectSystemHelpBox")}</div>
    <br />
    <input:form name="schedule-edit-form" method="post" action="${fn:escapeXml(actionUrl)}">
      <table class="property-table">
          <tbody>
            <c:forEach var="authorizationRealmType" items="${authorizationRealmTypes}">
              <tr class="${eo.last}" style="vertical-align: bottom;">
                  <td align="left"/>
                      <c:choose>
                          <c:when test="${authorizationRealmType == param.selectedType}">
                              <c:set var="checked" value="checked"/>
                          </c:when>
                          <c:otherwise>
                              <c:set var="checked" value=""/>
                          </c:otherwise>
                      </c:choose>
                      <input type="radio" class="radio" name="${AuthorizationRealmConstants.TYPE_NAME}" ${disabled}
                             value="<c:out value="${authorizationRealmType}"/>"  ${checked}/>
                  </td>
                  <td width="100%">
                      <strong>${ub:i18n(authorizationRealmType.name)}</strong> - <c:out value="${ub:i18n(authorizationRealmType.description)}"/>
                  </td>
              </tr>
            </c:forEach>
            <tr class="${eo.last}">
                <td colspan="2">
                    <ucf:button name="Select" label="${ub:i18n('Select')}"/>
                    <c:url var="cancelUrl" value="${AuthorizationRealmTasks.cancelTypes}"/>
                    <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
                </td>
            </tr>
          </tbody>
      </table>
    </input:form>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
