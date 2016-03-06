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
<%@page import="java.util.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.security.AuthTokenTasks" %>
<%@page import="com.urbancode.security.AuthToken"%>
<%@page import="com.urbancode.security.SecurityConfiguration" %>
<%@page import="com.urbancode.security.persistence.AuthTokenFactory"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildUser" %>
<%@page import="com.urbancode.ubuild.domain.security.UBuildUserFactory" %>
<%@page import="com.urbancode.ubuild.runtime.scripting.helpers.DateHelper" %>
<%@page import="java.text.DateFormat" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.AuthTokenTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>
<c:set var="disableButtons" value="${add_auth != null}"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
        <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
        <c:set var="inViewMode" value="true"/>
    </c:otherwise>
</c:choose>

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('SystemAuthTokens')}"/>
    <c:param name="selected" value="system"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<%
   AuthTokenFactory tokenFactory = SecurityConfiguration.getAuthTokenFactory();
   List<AuthToken> tokenList = tokenFactory.getAllAuthTokens();
   pageContext.setAttribute("authTokenList", tokenList);
%>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <c:url var="authTokensUrl" value="${AuthTokenTasks.viewAuthTokens}"/>
      <ucf:link href="${authTokensUrl}" label="${ub:i18n('AuthTokens')}" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <c:if test="${add_auth == null}">
            <div id="createBtnDiv" style="margin-top:1em;">
                <c:url var="createAuthTokenUrl" value="${AuthTokenTasks.createAuthToken}"/>
                <ucf:button href="${createAuthTokenUrl}" name="Create Auth Token" label="${ub:i18n('CreateAuthToken')}" enabled="${!disableButtons}"/>
            </div>
            <br />
            <c:if test="${empty authTokenList}">
                <strong>${ub:i18n("AuthTokenNoneDefinedMessage")}</strong><br/>
            </c:if>

            <c:if test="${! empty authTokenList}">
               <table id="authTokenTable" class="data-table">
               <caption>${ub:i18n("AuthTokens")}<br /><br /></caption>
                    <tbody>
                        <tr>
                            <th scope="col" align="left" valign="middle">${ub:i18n("UserName")}</th>
                            <th scope="col" align="left" valign="middle">${ub:i18n("Description")}</th>
                            <th scope="col" align="center" valign="middle">${ub:i18n("Value")}</th>
                            <th scope="col" align="center" valign="middle">${ub:i18n("Expiration")}</th>
                            <th scope="col" align="center" valign="middle">${ub:i18n("Actions")}</th>
                        </tr>

                        <c:forEach var="token" items="${authTokenList}" varStatus="status">
                            <c:url var="removeTokenUrl" value="${AuthTokenTasks.removeAuthToken}">
                                <c:param name="authTokenId" value="${token.id}"/>
                            </c:url>

                            <tr bgcolor="#ffffff">
                              <%
                                  AuthToken token = (AuthToken) pageContext.getAttribute("token");
                                  pageContext.setAttribute("userName", token.getSystemUser());
                                  if (token.getExpiration() == Long.MAX_VALUE) {
                                      pageContext.setAttribute("expire", "Never");
                                  }
                                  else {
                                      pageContext.setAttribute("expire",
                                              DateHelper.getInstance().getLongDateTimeFormat().format(token.getExpiration()));
                                  }
                              %>
                                <td align="left" nowrap="nowrap">${userName }</td>
                                <td align="center" nowrap="nowrap">${token.description}</td>
                                <td align="center" nowrap="nowrap">${token.token}</td>
                                <td align="center" nowrap="nowrap">
                                  <c:choose>
                                    <c:when test="${expire eq 'Never'}">
                                      ${fn:toUpperCase(ub:i18n(expire))}
                                    </c:when>
                                    <c:otherwise>
                                      ${expire}
                                    </c:otherwise>
                                  </c:choose>
                                </td>
                                <td align="center" nowrap="nowrap">
                                    <ucf:confirmlink href="${removeTokenUrl}" label="${ub:i18n('DeleteToken')}" 
                                        message="${ub:i18n('AuthTokenDeleteMessage')}" 
                                        img="${iconDeleteUrl}" enabled="${!disableButtons}"/>
                                </td>
                            </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        </c:if>
        <br/>
        <c:choose>
          <c:when test="${add_auth != null}">
            <br/>
            <c:url var="saveUrl" value="${AuthTokenTasks.saveAuthToken}"/>
            <form method="post" action="${fn:escapeXml(saveUrl)}">
              <table class="property-table">
                <error:field-error field="userName" cssClass="odd"/>
                <tr class="odd" valign="top">
                  <td align="left" width="20%"><span class="bold">${ub:i18n("UserWithColon")}</span></td>
                  <td align="left" width="20%"><ucf:text name="userName" value="${param.userName}" enabled="${inViewMode}"/></td>
                  <td align="left">
                    <span class="inlinehelp">${ub:i18n("AuthTokenUserDesc")}</span>
                  </td>
                </tr>
               
                <error:field-error field="duration" cssClass="odd"/>
                <tr class="odd" valign="top">
                  <td align="left" width="20%"><span class="bold">${ub:i18n("ExpirationWithColon")}</span></td>
                  <td align="left" width="20%"><ucf:text name="duration" value="${param.duration}" enabled="${inViewMode}"/></td>
                  <td align="left">
                    <span class="inlinehelp">${ub:i18n("AuthTokenExpirationDesc")}</span>
                  </td>
                </tr>
                
                <error:field-error field="description" cssClass="odd"/>
                <tr class="odd" valign="top">
                  <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                  <td align="left" width="20%"><ucf:text name="description" value="${param.description}" enabled="${inViewMode}"/></td>
                  <td align="left">
                    <span class="inlinehelp">${ub:i18n("AuthTokenDescriptionDesc")}</span>
                  </td>
                </tr>
               
              </table>
              <ucf:button name="addAuthToken" label="${ub:i18n('AddAuthToken')}"/>
              <c:url var="cancelUrl" value="${AuthTokenTasks.viewAuthTokens}"/>
              <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
            </form>
          </c:when>

          <c:otherwise>
            <div>
              <c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
              <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
            </div>
          </c:otherwise>

        </c:choose>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
