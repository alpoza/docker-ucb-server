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
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.security.GroupTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.GroupTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="iconEditUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

<c:set var="disableButtons" value="${group != null}"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
        <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
        <c:set var="inViewMode" value="true"/>
    </c:otherwise>
</c:choose>

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('SystemSecurityGroups')}"/>
    <c:param name="selected" value="system"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <c:url var="rolesUrl" value="${GroupTasks.viewGroups}"/>
      <ucf:link href="${groupsUrl}" label="${ub:i18n('Groups')}" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <br/>
        <div id="createBtnDiv" style="margin-top:1em;">
            <c:url var="createGroupUrl" value="${GroupTasks.viewGroup}"/>
            <ucf:button href="${createGroupUrl}" name="Create Group" label="${ub:i18n('CreateGroup')}" enabled="${!disableButtons}"/>
        </div>
        <br />
        <c:if test="${empty groupList}">
            <strong>${ub:i18n("GroupsNoneCreatedMessage")}</strong><br/>
        </c:if>

        <c:if test="${! empty groupList}">
            <table id="activeGroupsTable" class="data-table">
                <caption>${ub:i18n("UserGroups")}</caption>
                <tbody>
                    <tr>
                        <th scope="col" align="left" valign="middle" width="65%">${ub:i18n("GroupName")}</th>
                        <th scope="col" align="left" valign="middle" width="25%">${ub:i18n("Authorization Realm")}</th>
                        <th scope="col" align="center" valign="middle" width="10%"></th>
                    </tr>

                    <c:forEach var="group" items="${groupList}" varStatus="groupStatus">
                        <c:url var="viewGroupUrl" value="${GroupTasks.viewGroup}">
                            <c:param name="${WebConstants.GROUP_ID}" value="${group.id}"/>
                        </c:url>
                        
                        <c:url var="authorizationRealmUrl" value="${AuthorizationRealmTasks.viewAuthorizationRealm}">
                            <c:param name="${WebConstants.AUTHORIZATION_REALM_ID}" value="${group.authorizationRealm.id}"/>
                        </c:url>

                        <c:url var="deleteGroupUrl" value="${GroupTasks.deleteGroup}">
                            <c:param name="${WebConstants.GROUP_ID}" value="${group.id}"/>
                        </c:url>

                        <tr bgcolor="#ffffff">
                            <td align="left" nowrap="nowrap">
                                <ucf:link href="${viewGroupUrl}" label="${group.name}" enabled="${!disableButtons}"/>
                            </td>
                            
                            <td align="left" nowrap="nowrap">
                                <ucf:link href="${authorizationRealmUrl}" label="${group.authorizationRealm.name}" enabled="${!disableButtons}"/>
                            </td>

                            <td align="center" nowrap="nowrap">
                                <ucf:link href="${viewGroupUrl}" label="${ub:i18n('Edit')}" img="${iconEditUrl}" enabled="${!disableButtons}"/>&nbsp;
                                <ucf:confirmlink href="${deleteGroupUrl}" label="${ub:i18n('DeleteGroup')}"
                                  message="${ub:i18n('GroupsDeleteMessage')} ${ah3:ch('n')}${ah3:ch('n')} ${ub:i18nMessage('DeleteConfirm', group.name)}"
                                  img="${iconDeleteUrl}"
                                  enabled="${!disableButtons and group.authorizationRealm.authorizationModuleClassName eq 'com.urbancode.security.authorization.internal.InternalAuthorizationModule'}"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        <br/>
        <div>
            <c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
            <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
