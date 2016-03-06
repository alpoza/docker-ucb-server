<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.security.authentication.AuthenticationRealmTasks" %>
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
<ah3:useConstants class="com.urbancode.ubuild.domain.security.SecurityHelper"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('SystemAuthentication')}"/>
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
<c:url var="createUrl" value='<%=new AuthenticationRealmTasks().methodUrl("viewTypes", false)%>'/>
<c:url var="moveRealmUrl" value='<%=new AuthenticationRealmTasks().methodUrl("moveRealm", false)%>'>
   <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${realm.id}"/>
</c:url>
<c:url var="viewListUrl" value='<%=new AuthenticationRealmTasks().methodUrl("viewList")%>'/>

<div style="padding-bottom: 1em;">
  <c:import url="/WEB-INF/jsps/admin/security/authentication/securityAuthenticationSubTabs.jsp">
    <c:param name="selected" value="authentication"/>
    <c:param name="disabled" value="${disableButtons}"/>
  </c:import>
  <style type="text/css">
    table.data-table td.realm_row_even {
	    background-color: #ffffff;
    }
    table.data-table td.realm_row_odd {
	    background-color: #f9f8f7;
    }
  </style>
  <script type="text/javascript">
      function refresh() {
            goTo('${ah3:escapeJs(viewListUrl)}');
    }
    function moveRealm(old, newinx) {
         goTo("${ah3:escapeJs(moveRealmUrl)}&old="+old+"&new="+newinx);
    }
  </script>
  <div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("AuthenticationRealmListHelp")}
    </div>

    <c:set value="off" var="autoComplete" scope="page"/>
    <c:if test="<%=ServerSettingsTasks.isAllowAutoComplete()%>">
      <c:set value="on" var="autoComplete" scope="page"/>
    </c:if>
    <form method="post" action="${fn:escapeXml(saveUrl)}" autocomplete="${autoComplete}">
      <div id="createBtnDiv" style="margin-top:1em; margin-bottom:2em;">
        <ucf:link href="${createUrl}" klass="button" label="${ub:i18n('CreateAuthenticationRealm')}" enabled="${!disableButtons}"/>
      </div>

      <c:url var="iconViewUrl" value="/images/icon_magnifyglass.gif"/>
      <c:url var="iconUpUrl" value="/images/icon_up_arrow.gif"/>
      <c:url var="iconDownUrl" value="/images/icon_down_arrow.gif"/>
      <c:url var="iconActiveUrl" value="/images/icon_active.gif"/>
      <c:url var="iconInactiveUrl" value="/images/icon_inactive.gif"/>
      <c:url var="grabberIconUrl" value="/images/icon_grabber.gif"/>

      <br/>

      <%--                                          --%>
      <%-- DISPLAY THE ACTIVE AUTHENTICATION REALMS --%>
      <%--                                          --%>
      <table id="activeRealmTable" class="data-table">
        <caption>${ub:i18n("ActiveAuthenticationRealms")}</caption>
        <tbody>
        <tr>
          <th scope="col" align="left" valign="middle" width="25%">${ub:i18n("RealmName")}</th>
          <th scope="col" align="left" valign="middle" width="25%">${ub:i18n("Authorization Realm")}</th>
          <th scope="col" align="left" valign="middle" width="40%">${ub:i18n("Description")}</th>
          <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
        </tr>

        <c:forEach var="realm" items="${keyActiveRealms}" varStatus="realmStatus">
          <c:set var="rowStyle" value="${realmStatus.index % 2 == 0 ? 'realm_row_even' : 'realm_row_odd'}"/>
          <c:url var="viewRealmUrl" value='<%=new AuthenticationRealmTasks().methodUrl("viewAuthenticationRealm", false)%>'>
            <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${realm.id}"/>
          </c:url>

          <c:url var="deactivateRealmUrl"
                 value='<%=new AuthenticationRealmTasks().methodUrl("deactivateAuthenticationRealm", false)%>'>
            <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${realm.id}"/>
          </c:url>

          <c:url var="moveRealmUpUrlIdx" value='<%=new AuthenticationRealmTasks().methodUrl("moveRealmUp", false)%>'>
            <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${realm.id}"/>
          </c:url>

          <c:url var="moveRealmDownUrlIdx" value='<%=new AuthenticationRealmTasks().methodUrl("moveRealmDown", false)%>'>
            <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${realm.id}"/>
          </c:url>


          <tr bgcolor="#ffffff" id="realm-row-${realmStatus.index}">
            <td align="left" height="1" nowrap="nowrap" class="${fn:escapeXml(rowStyle)}">
              <script type="text/javascript">
                  Element.observe(window, 'load', function(event) {
                             new UC_REALM_ROW("realm-row-${realmStatus.index}", "${realm.id}");
                  });
              </script>
              <div style="float: right;" align="right"><img style="cursor:move;" id="grabber${realmStatus.index}"
                title="${ub:i18n('Reorder')}" alt="${ub:i18n('Reorder')}" src="${grabberIconUrl}"/></div>
              <ucf:link href="${viewRealmUrl}" label="${ub:i18n(realm.name)}" enabled="${!disableButtons}"/>
            </td>

            <td align="left" height="1" nowrap="nowrap" class="${fn:escapeXml(rowStyle)}">
                ${fn:escapeXml(ub:i18n(realm.authorizationRealm.name))}
            </td>

            <td align="left" height="1" class="${fn:escapeXml(rowStyle)}">
              <c:out value="${ub:i18n(realm.description)}"/>
            </td>

            <td align="center" height="1" width="200px" nowrap="nowrap" class="${fn:escapeXml(rowStyle)}">
              <c:set var="deletable" value="${realm.id != SecurityHelper.UBUILD_AUTHENTICATION_REALM_ID}"/>
              <ucf:link href="${viewRealmUrl}" img="${iconViewUrl}" label="${ub:i18n('View')}" enabled="${!disableButtons}"/>&nbsp;
              <ucf:confirmlink href="${deactivateRealmUrl}" img="${iconActiveUrl}"
                               message="${ub:i18nMessage('AuthenticationRealmDeactivateConfirm', ub:i18n(realm.name))}"
                               label="${ub:i18n('Inactivate')}" enabled="${!disableButtons && deletable}"/>
            </td>
          </tr>
        </c:forEach>

        </tbody>
      </table>

      <%--                                            --%>
      <%-- DISPLAY THE INACTIVE AUTHENTICATION REALMS --%>
      <%--                                            --%>
      <c:choose>
        <c:when test="${! empty keyInactiveRealms}">
          <br/>
          <table id="inactiveRealmTable" class="data-table">
            <caption>${ub:i18n("InactiveAuthenticationRealms")}</caption>
            <tbody>
            <tr>
              <th scope="col" align="left" valign="middle" width="25%">${ub:i18n("RealmName")}</th>
              <th scope="col" align="left" valign="middle" width="25%">${ub:i18n("Authorization Realm")}</th>
              <th scope="col" align="left" valign="middle" width="40%">${ub:i18n("Description")}</th>
              <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
            </tr>

            <c:forEach var="realm" items="${keyInactiveRealms}" varStatus="realmStatus">
              <c:url var="viewRealmUrl" value='<%=new AuthenticationRealmTasks().methodUrl("viewAuthenticationRealm", false)%>'>
                <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${realm.id}"/>
              </c:url>
              <c:url var="activateRealmUrl"
                     value='<%=new AuthenticationRealmTasks().methodUrl("activateAuthenticationRealm", false)%>'>
                <c:param name="${WebConstants.AUTHENTICATION_REALM_ID}" value="${realm.id}"/>
              </c:url>

              <tr bgcolor="#ffffff">
                <td align="left" height="1" nowrap="nowrap">
                  <ucf:link href="${viewRealmUrl}" label="${realm.name}" enabled="${!disableButtons}"/>
                </td>
                <td align="left" height="1" nowrap="nowrap">
                    ${fn:escapeXml(realm.authorizationRealm.name)}
                </td>

                <td align="left" height="1">
                  <c:out value="${realm.description}"/>
                </td>
                <td align="center" height="1" width="200px" nowrap="nowrap">
                  <ucf:link href="${viewRealmUrl}" img="${iconViewUrl}" label="${ub:i18n('View')}" enabled="${!disableButtons}"/>&nbsp;
                  <ucf:confirmlink href="${activateRealmUrl}" img="${iconInactiveUrl}"
                                   message="${ub:i18nMessage('AuthenticationRealmActivateConfirm', realm.name)}"
                                   label="${ub:i18n('Activate')}" enabled="${!disableButtons}"/>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </c:when>
        <c:otherwise>
          <%-- No Inactive Authentication Realms --%>
        </c:otherwise>
      </c:choose>
      <br/>
      <ucf:link href="${doneUrl}" klass="button" label="${ub:i18n('Done')}" enabled="${!disableButtons}"/>
  </form>
</div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
