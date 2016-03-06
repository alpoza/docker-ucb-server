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
<%@page import="com.urbancode.ubuild.domain.repository.RepositoryTrigger" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.repository.RepositoryTasks" %>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib uri="error" prefix="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.repository.RepositoryTasks"/>

<c:url var="iconDel" value="/images/icon_delete.gif"/>

<%-- used for Done button --%>
<c:set var="viewList" value="${RepositoryTasks.viewList}"/>

<%-- Currently used to relaod page on successful save --%>
<c:url var="viewRepositoryUrl" value="${RepositoryTasks.viewRepository}">
  <c:param name="${WebConstants.REPO_ID}" value="${repo.id}"/>
</c:url>

<c:url var="viewTriggerUrl" value="${RepositoryTasks.viewRepositoryTrigger}">
  <c:param name="${WebConstants.REPO_ID}" value="${repo.id}"/>
</c:url>

<c:url var="deactivateUrl" value="${RepositoryTasks.deactivateRepositoryTrigger}">
  <c:param name="${WebConstants.REPO_ID}" value="${repo.id}"/>
</c:url>

<c:url var="activateUrl" value="${RepositoryTasks.activateRepositoryTrigger}">
  <c:param name="${WebConstants.REPO_ID}" value="${repo.id}"/>
</c:url>

<c:url var="deleteUrl" value="${RepositoryTasks.deleteRepositoryTrigger}">
  <c:param name="${WebConstants.REPO_ID}" value="${repo.id}"/>
</c:url>

<c:url var="createUrl" value="${RepositoryTasks.createRepositoryTrigger}">
  <c:param name="${WebConstants.REPO_ID}" value="${repo.id}"/>
</c:url>

<%
    pageContext.setAttribute("eo", new EvenOdd());
%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemRepositoryTrigger')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${false}"/>
</jsp:include>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${repo.name}" href="${viewRepositoryUrl}" enabled="${false}" klass="tab"/>
    <ucf:link label="${ub:i18n('Trigger')}" href="${viewTriggerUrl}" klass="selected tab"/>
  </div>
  <div class="contents">


    <div class="system-helpbox">${ub:i18n("RepositoryTriggerSystemHelpBox")}
    </div>
    <br/>

    <error:field-error field="error"/>
    <error:field-error field="trigger"/>

    <c:choose>

      <c:when test='${repo_trigger == null}'>
        <p><span class="bold">${ub:i18n("RepositoryTriggerNoTriggerMessage")}</span></p>
        <p>${ub:i18n("RepositoryTriggerCreateMesage")}</p>
        <br/>
      </c:when>

      <c:otherwise>
        <p>${ub:i18n("RepositoryTriggerExistsMessage")}
        <span class="bold"><c:if test="${!repo_trigger.active}">&nbsp;${fn:toUpperCase(ub:i18n("Not"))}</c:if>&nbsp;${fn:toUpperCase(ub:i18n("Active"))}</span>.</p>
        <span class="bold">${ub:i18n("RepositoryTriggerCode")} ${repo_trigger.code}</span>
        <div class="system-helpbox">
          <%-- allows for formatting in the plugin.xml --%>
          <pre>${fn:trim(triggerDescription)}</pre>
        </div>
      </c:otherwise>
    </c:choose>

    <c:set var="deleteMessage" value="${ub:i18n('TheRepositoryTrigger')}" />
    <div style="margin-top: 10px; <c:if test="${repo_trigger != null}">display: none;</c:if>" class="createButtons">
      <ucf:button name="CreateTrigger" label="${ub:i18n('CreateTrigger')}" submit="${false}" href="${createUrl}"/>
      <ucf:button name="Done" label="${ub:i18n('Done')}" submit="${false}" href="${viewList}"/>
    </div>
    <div style="margin-top: 10px; <c:if test="${repo_trigger == null || repo_trigger.active}">display: none;</c:if>" class="activateButtons">
      <ucf:button name="Activate" label="${ub:i18n('Activate')}" submit="${false}" href="${activateUrl}"/>
      <ucf:link label="${ub:i18n('Delete')}" onclick="return confirmDelete('${deleteMessage}');" href="${deleteUrl}" klass="button"/>
      <ucf:button name="Done" label="${ub:i18n('Done')}" submit="${false}" href="${viewList}"/>
    </div>
    <div style="margin-top: 10px; <c:if test="${repo_trigger == null || !repo_trigger.active}">display: none;</c:if>" class="deactivateButtons">
      <ucf:button name="Inactivate" label="${ub:i18n('Inactivate')}" submit="${false}" href="${deactivateUrl}"/>
      <ucf:link label="${ub:i18n('Delete')}" onclick="return confirmDelete('${deleteMessage}');" href="${deleteUrl}" klass="button"/>
      <ucf:button name="Done" label="${ub:i18n('Done')}" submit="${false}" href="${viewList}"/>
    </div>

  </div>

</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
