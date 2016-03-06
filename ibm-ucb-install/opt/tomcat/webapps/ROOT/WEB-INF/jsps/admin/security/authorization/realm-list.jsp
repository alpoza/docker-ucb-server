<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" %>
<%@page contentType="text/html; charset=UTF-8" %>
<%@page pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>


<%@page import="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" useConversation="false"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('SystemAuthorization')}"/>
  <c:param name="selected" value="system"/>
  <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="textFieldAttributes" value="disabled='disabled' class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
<c:url var="createUrl" value='${AuthorizationRealmTasks.viewTypes}'/>

<div style="padding-bottom: 1em;">
  <c:import url="/WEB-INF/jsps/admin/security/authorization/securityAuthorizationSubTabs.jsp">
    <c:param name="disabled" value="${inEditMode}"/>
  </c:import>
  <div class="contents">
    <div class="system-helpbox">${ub:i18n("AuthorizationSystemHelpBox")}</div>

    <c:set value="off" var="autoComplete" scope="page"/>
    <%
      pageContext.setAttribute("allowAutoComplete", ServerSettingsTasks.isAllowAutoComplete());
    %>
    <c:if test="${allowAutoComplete}">
      <c:set value="on" var="autoComplete" scope="page"/>
    </c:if>

    <br/>
    <ucf:button href="${createUrl}" name="NewRealm" label="${ub:i18n('CreateAuthorizationRealm')}" enabled="${!disableButtons}"/>

    <c:url var="iconViewUrl" value="/images/icon_magnifyglass.gif"/>

    <br/><br/>

    <c:if test="${! empty keyActiveRealms}">
      <table id="activeRealmTable" class="data-table">
        <caption>${ub:i18n("AuthorizationRealms")}</caption>
        <tbody>
        <tr>
          <th scope="col" align="left" valign="middle" width="30%">${ub:i18n("RealmName")}</th>
          <th scope="col" align="left" valign="middle" width="50%">${ub:i18n("Description")}</th>
          <th scope="col" align="center" valign="middle" width="20%">${ub:i18n("Actions")}</th>
        </tr>

        <c:forEach var="realm" items="${keyActiveRealms}" varStatus="realmStatus">
          <c:url var="viewRealmUrl" value='${AuthorizationRealmTasks.viewAuthorizationRealm}'>
            <c:param name="${WebConstants.AUTHORIZATION_REALM_ID}" value="${realm.id}"/>
          </c:url>

          <tr bgcolor="#ffffff">
            <td align="left" height="1" nowrap="nowrap">
              <ucf:link href="${viewRealmUrl}" label="${ub:i18n(realm.name)}" enabled="${!disableButtons}"/>
            </td>

            <td align="left" height="1">
              <c:out value="${ub:i18n(realm.description)}"/>
            </td>

            <td align="center" height="1" width="200px" nowrap="nowrap">
              <ucf:link href="${viewRealmUrl}" img="${iconViewUrl}" label="${ub:i18n('View')}" enabled="${!disableButtons}"/>
            </td>
          </tr>
        </c:forEach>

        </tbody>
      </table>
    </c:if>
    <div>
      <br/>
      <ucf:link href="${doneUrl}" klass="button" label="${ub:i18n('Done')}" enabled="${!disableButtons}"/>
    </div>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
