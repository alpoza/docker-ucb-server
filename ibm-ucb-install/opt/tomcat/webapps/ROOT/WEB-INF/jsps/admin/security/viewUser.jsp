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

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('UsersAccess')}"/>
    <c:param name="selected" value="teams"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<div style="padding-bottom: 1em;">

  <c:import url="userSubTabs.jsp">
    <c:param name="selected" value="general"/>
    <c:param name="disabled" value="${disableButtons}"/>
  </c:import>
  <br/>
  <br/>
  <div class="contents">
    <table class="property-table">
      <tr>
        <td style="width: 85px; nowrap: nowrap;"><label>${ub:i18n("UserWithColon")}</label></td>
        <td>${fn:escapeXml(user.name)}</td>
      </tr>
      <c:if test="${not empty user.actualName}">
        <tr>
          <td style="width: 85px; nowrap: nowrap;"><label>${ub:i18n("NameWithColon")}</label></td>
          <td><c:out value="${user.actualName}" escapeXml="true"/></td>
        </tr>
      </c:if>
      <c:if test="${not empty user.emailAddress}">
        <tr>
          <td style="width: 85px; nowrap: nowrap;"><label>${ub:i18n("EmailWithColon")}</label></td>
          <td><c:out value="${user.emailAddress}" escapeXml="true"/></td>
        </tr>
      </c:if>
    </table>
    <table style="width: 100%;">
      <tbody>
        <tr>
          <td width="50%" style="vertical-align: top;">
            <div style="margin-top: 2em; padding: 10px" class="panel_1">
              <div><h2>${ub:i18n("Membership")}</h2></div>

              <ul style="list-style:none" class="panel_2">
                <c:forEach var="teamSpace" items="${teamSpaceList}">
                  <c:url var="teamUrl" value="${urlLookup[teamSpace]}"/>
                  <li>
                    <h3>${ub:i18n("TeamWithColon")}&nbsp;<ucf:link href="${teamUrl}" label="${teamSpace.name}"/></h3>
                    <ul style="list-style:none">
                      <c:forEach var="role" items="${teamToRoles[teamSpace]}">
                        <c:url var="roleUrl" value="${urlLookup[role]}"/>
                        <li><ucf:link href="${roleUrl}" label="${role.name}"/></li>
                      </c:forEach>
                   </ul>
                  </li>
                </c:forEach>
              </ul>
            </div>
          </td>

          <td width="50%" style="vertical-align: top;">
            <div style="margin-top: 2em; padding: 10px" class="panel_1">
              <div><h2>${ub:i18n("Resources")}</h2></div>

              <ul style="list-style:none;" class="panel_2">
                <c:forEach var="resourceEntry" items="${resourcesMap}">
                  <li><h3>${ub:i18n("ResourceType")}&nbsp;${fn:escapeXml(resourceEntry.key.name)}</h3>
                     <ul>
                       <c:forEach var="resource" items="${resourceEntry.value}">
                         <c:choose>
                           <c:when test="${!empty  urlLookup[resource]}">
                             <c:url var="resourceUrl" value="${urlLookup[resource]}"/>
                             <li style="list-style:none"><ucf:link href="${resourceUrl}" label="${resource.name}"/></li>
                           </c:when>
                           <c:otherwise><li style="list-style:none">${fn:escapeXml(resource.name)}</li></c:otherwise>
                         </c:choose>
                       </c:forEach>
                     </ul>
                  </li>
                </c:forEach>
              </ul>

            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
