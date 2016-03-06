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
<%@page import="java.util.*" %>
<%@page import="com.urbancode.ubuild.domain.agent.Agent" %>
<%@page import="com.urbancode.ubuild.domain.persistent.*" %>
<%@page import="com.urbancode.ubuild.web.admin.agent.*" %>
<%@page import="com.urbancode.ubuild.web.*" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@page import="com.urbancode.commons.xml.*" %>
<%@page import="com.urbancode.ubuild.domain.agentpool.AgentPool"%>
<%@page import="com.urbancode.ubuild.domain.agentpool.AgentPoolFactory"%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@ page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@ page import="com.urbancode.ubuild.domain.security.SystemFunction" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />

<auth:checkAction var="agentPoolEdit" action="${UBuildAction.AGENT_POOL_EDIT}"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<%
    pageContext.setAttribute("eo", new EvenOdd());
%>

<%
  Agent agent = (Agent)pageContext.findAttribute("agent");
  pageContext.setAttribute("hasWritePermission", Boolean.valueOf(agent.isUserEditable()));
  pageContext.setAttribute(WebConstants.AGENT_POOL_LIST, AgentPoolFactory.getInstance().restoreAll());
%>

<c:url var="cancelUrl" value="${AgentTasks.cancelAgent}">
  <c:param name="agent_id" value="${agent.id}"></c:param>
</c:url>
<c:url var="editUrl" value="${AgentTasks.editAgent}">
  <c:param name="agent_id" value="${agent.id}"></c:param>
</c:url>
<c:url var="saveUrl" value="${AgentTasks.saveAgent}">
  <c:param name="agent_id" value="${agent.id}"></c:param>
</c:url>
<c:url var="doneUrl" value="${AgentTasks.doneAgent}">
  <c:param name="agent_id" value="${agent.id}"></c:param>
  <c:if test="${not empty param.agentPoolId}">
    <c:param name="agentPoolId" value="${param.agentPoolId}"/>
  </c:if>
</c:url>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEditAgent')}"/>
  <jsp:param name="selected" value="agents"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div style="padding-bottom: 1em;">
<jsp:include page="/WEB-INF/jsps/admin/agent/agentTabs.jsp">
  <jsp:param name="selected" value="Main"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div class="contents">
<div class="system-helpbox">
  ${ub:i18n("AgentSystemHelpBox")}
</div>
<br/>

<div align="right">
  <span class="required-text">${ub:i18n("RequiredField")}</span>
</div>
<form method="post" action="${fn:escapeXml(saveUrl)}">
<input name="to" type="hidden" value=""/>
<table class="property-table">

  <tbody>


    <c:if test="${!empty agentVersionWarning}">
      <span style="color:red">${fn:escapeXml(agentVersionWarning)}</span>
    </c:if>

    <c:set var="fieldName" value="name"/>
    <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : agent.name}"/>
    <error:field-error field="name" cssClass="${eo.next}"/>
    <tr class="${eo.last}">
      <td align="left" width="20%">
        <span class="bold">${ub:i18n("NameWithColon")}</span>
      </td>
      <td align="left" colspan="2">
        ${fn:escapeXml(nameValue)}
      </td>
    </tr>

    <c:set var="fieldName" value="description"/>
    <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : agent.description}"/>
    <error:field-error field="description" cssClass="${eo.next}"/>
    <tr class="${eo.last}">
      <td align="left" width="20%">
        <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
      </td>
      <td align="left" colspan="2">
        <ucf:textarea name="description" value="${fn:escapeXml(descriptionValue)}" enabled="${inEditMode}"/>
      </td>
    </tr>

    <tr class="${eo.last}">
      <td align="left" width="20%">
        <span class="bold">${ub:i18n("ConfiguredWithColon")} </span>
      </td>
      <td align="left" width="20%">
        <ucf:checkbox id="configured" name="configured" checked="${agent.configured}" value="true" enabled="${inEditMode}"/>
      </td>
      <td align="left">
        <span class="inlinehelp">${ub:i18n("AgentConfiguredCheckBoxDesc")}</span>
      </td>
    </tr>

    <c:set var="fieldName" value="throughputMetric"/>
    <c:set var="throughputValue" value="${param[fieldName] != null ? param[fieldName] : agent.throughputMetric}"/>
    <error:field-error field="throughputMetric" cssClass="${eo.next}"/>
    <tr class="${eo.last}">
      <td align="left" width="20%">
        <span class="bold">${ub:i18n("AgentThroughputMetricWithColon")} <span class="required-text">*</span></span>
      </td>
      <td align="left" width="20%">
        <ucf:text name="throughputMetric" value="${fn:escapeXml(throughputValue)}" enabled="${inEditMode}" size="10"/>
      </td>
      <td align="left">
        <span class="inlinehelp">${ub:i18n("AgentThroughPutDesc")}</span>
      </td>
    </tr>

    <c:set var="fieldName" value="maxJobs"/>
    <c:set var="maxJobsValue" value="${param[fieldName] != null ? param[fieldName] : agent.maxJobs}"/>
    <error:field-error field="maxJobs" cssClass="${eo.next}"/>
    <tr class="${eo.last}">
      <td align="left" width="20%">
        <span class="bold">${ub:i18n("AgentMaxNumJobs")} <span class="required-text">*</span></span>
      </td>
      <td align="left" width="20%">
        <ucf:text name="maxJobs" value="${fn:escapeXml(maxJobsValue)}" enabled="${inEditMode}" size="10"/>
      </td>
      <td align="left">
        <span class="inlinehelp">${ub:i18n("AgentMaxNumJobsDesc")}</span>
      </td>
    </tr>

    <error:field-error field="agentPoolList" cssClass="${eo.next}"/>
    <tr class="${eo.last}">
      <td align="left" width="20%">
        <span class="bold">${ub:i18n("AgentPoolsWithColon")} </span>
      </td>
      <td align="left" width="20%" style="white-space: nowrap;">
        <c:forEach var="group" items="${agentPoolList}">
          <%
              AgentPool group = (AgentPool) pageContext.findAttribute("group");
              if (group.containsAgent(agent)) {
                pageContext.setAttribute("checked", Boolean.TRUE);
              }
              else {
                pageContext.setAttribute("checked", Boolean.FALSE);
              }
          %>
          <c:choose>
            <c:when test="${inEditMode}">
              <c:set var="dynamicPoolMessage" value="${ub:i18n('DynamicPoolAddAgentMessage')}"/>
              <c:set var="agentPoolEditMessage" value="${ub:i18n('AgentPoolPermissionMessage')}"/>
              <c:set var="selectedMessage" value="${not agentPoolEdit ? agentPoolEditMessage : dynamicPoolMessage}"/>
              <div title="${(group.dynamic || not agentPoolEdit) ? selectedMessage : ''}">
                <ucf:checkbox id="serverGroup_${fn:escapeXml(group.id)}" name="serverGroup:${fn:escapeXml(group.id)}"
                    checked="${checked}" value="true" enabled="${inEditMode && not group.dynamic && agentPoolEdit}"/>
                <label for="serverGroup_${fn:escapeXml(group.id)}"><c:out value="${group.name}"/></label><br/>
              </div>
            </c:when>
            <c:when test="${checked}">
              <ucf:checkbox id="serverGroup_${fn:escapeXml(group.id)}" name="serverGroup:${fn:escapeXml(group.id)}"
                    checked="${checked}" value="true" enabled="${inEditMode}"/>
              <label for="serverGroup_${fn:escapeXml(group.id)}"><c:out value="${group.name}"/></label><br/>
            </c:when>
            <c:otherwise/>
          </c:choose>
        </c:forEach>
      </td>
      <td align="left">
        <span class="inlinehelp">${ub:i18n("AgentIncludeAgentPoolDesc")}</span>
      </td>
    </tr>

  </tbody>
</table>
<br/>
<c:if test="${inEditMode}">
  <ucf:button name="saveAgent" label="${ub:i18n('Save')}"/>
  <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
</c:if>
<c:if test="${inViewMode}">
  <c:if test="${hasWritePermission}">
    <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
  </c:if>
  <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
</c:if>
</form>
</div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
