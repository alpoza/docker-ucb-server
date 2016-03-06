<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="java.util.*" %>
<%@page import="com.urbancode.security.AuthToken"%>
<%@page import="com.urbancode.ubuild.domain.authtoken.AuthTokenWrapperFactory"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildUser"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.runtime.scripting.helpers.DateHelper" %>
<%@page import="java.text.DateFormat" %>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="error" prefix="error"%>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
    </c:otherwise>
</c:choose>
<%
    UBuildUser user = (UBuildUser) pageContext.findAttribute(WebConstants.USER);
    List<AuthToken> tokenlist = AuthTokenWrapperFactory.getInstance().restoreAllAuthTokensForUser(user);
    pageContext.setAttribute("tokens", tokenlist);
%>

<c:url var="cancelUrl" value="${requestScope.cancelUrl}"/>
<c:url var="addAuthTokenUrl" value="${requestScope.addAuthTokenUrl}"/>

<tr class="odd">
  <td colspan="3">
    <div>
      <ucf:button name="AddAuthToken" label="${ub:i18n('AddAuthToken')}" href="${addAuthTokenUrl}" enabled='${inViewMode && add_auth == null}'/>
    </div>
    <br/>
    <br/>
     <table id="publisherTable" class="data-table">
       <thead>
        <tr>
          <th scope="col" align="center" valign="middle">${ub:i18n("Description")}</th>
          <th scope="col" align="center" valign="middle">${ub:i18n("Value")}</th>
          <th scope="col" align="center" valign="middle">${ub:i18n("Expiration")}</th>
          <th scope="col" align="center" valign="middle">${ub:i18n("Actions")}</th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${fn:length(tokens)==0}">
           <tr bgcolor="#ffffff"><td colspan="4">${ub:i18n('NoAuthTokens')}</td></tr>
        </c:if>
        <c:url var="iconRemoveUrl" value="/images/icon_delete.gif"/>
        <c:forEach var="authToken" items="${tokens}" varStatus="status">
          <c:url var="tempRemoveAuthTokenUrl" value="${requestScope.removeAuthTokenUrl}">
            <c:param name="authTokenId" value="${authToken.id}"/>
          </c:url>

          <tr bgcolor="#ffffff">
            <td align="left" height="1" nowrap="nowrap"><c:out value="${authToken.description}"/></td>
              <%
                AuthToken token = (AuthToken) pageContext.getAttribute("authToken");
                if (token.getExpiration() == Long.MAX_VALUE) {
                    pageContext.setAttribute("expire", "Never");
                }
                else {
                pageContext.setAttribute("expire",
                                    DateHelper.getInstance().getLongDateTimeFormat().format(token.getExpiration()));
                }
              %>
            <td align="left" height="1" nowrap="nowrap"><c:out value="${authToken.token}"/></td>
            <td align="left" height="1" nowrap="nowrap">
              <c:choose>
                <c:when test="${expire eq 'Never'}">
                  ${fn:toUpperCase(ub:i18n(expire))}
                </c:when>
                <c:otherwise>
                  ${expire}
                </c:otherwise>
              </c:choose>
            </td>
            <td align="center" height="1" nowrap="nowrap">
              <ucf:confirmlink href="${tempRemoveAuthTokenUrl}" 
                               label="${ub:i18n('Remove')}" 
                               img="${iconRemoveUrl}"
                               message="${ub:i18nMessage('AuthTokenDeleteConfirm', authToken.token)}"
                               enabled="${inViewMode && add_auth == null}"/>
            </td>
          </tr>
        </c:forEach>
       </tbody>
     </table>
     <c:if test="${add_auth != null}">
       <br/>
       <table class="property-table">
           
         <error:field-error field="duration" cssClass="odd"/>
         <tr class="odd" valign="top">
           <td align="left" width="20%"><span class="bold">${ub:i18n("ExpirationWithColon")}</span></td>
           <td align="left" width="20%"><ucf:text name="duration" value="${requestScope.duration}" enabled="${inEditMode}"/></td>
           <td align="left">
             <span class="inlinehelp">${ub:i18n("AuthTokenExpirationDesc")}</span>
           </td>
         </tr> 
         
         <error:field-error field="description" cssClass="odd"/>
         <tr class="odd" valign="top">
           <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
           <td align="left" width="20%"><ucf:text name="description" value="${requestScope.description}" enabled="${inEditMode}"/></td>
           <td align="left">
             <span class="inlinehelp">${ub:i18n("AuthTokenDescriptionDesc")}</span>
           </td>
         </tr>
       </table>
       <br/>
       <ucf:button name="addAuthToken" label="${ub:i18n('Add')}"/>
       <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
     </c:if>
  </td>
</tr>
