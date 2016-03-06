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

<%@ page import="com.urbancode.ubuild.persistence.UnitOfWork"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.commons.util.ssl.StoredX509Cert"%>
<%@ page import="java.security.cert.X509Certificate"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.broker.BrokerTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="restartUrl" value="${BrokerTasks.restartBroker}"/>

<%
    pageContext.setAttribute("isAdmin", UnitOfWork.getCurrent().getUser().isAdmin());
    pageContext.setAttribute("certDateFormat", new SimpleDateFormat("MM/dd/yyyy"));
%>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/jsps/admin/agent/mainAgentTabsHeader.jsp">
  <jsp:param name="title" value="${ub:i18n('Broker')}"/>
  <jsp:param name="selected" value="Broker"/>
</jsp:include>
<div class="contents">
    <div class="system-helpbox">${ub:i18n("AgentBrokerSystemHelpBox")}</div>
    <c:if test="${!empty restartBrokerErr}">
        <br/><div class="error">${fn:escapeXml(restartBrokerErr)}</div>
        <% session.removeAttribute("restartBrokerErr"); %>
    </c:if>
    <c:if test="${!empty restartBrokerMsg}">
        <br/><div class="note">${fn:escapeXml(restartBrokerMsg)}</div>
        <% session.removeAttribute("restartBrokerMsg"); %>
    </c:if>
    <c:if test="${!empty trustCertErr}">
    <br/><div class="error">${fn:escapeXml(trustCertErr)}</div>
        <% session.removeAttribute("trustCertErr"); %>
    </c:if>
    <c:if test="${!empty trustCertMsg}">
        <br/><div class="note">${fn:escapeXml(trustCertMsg)}</div>
        <% session.removeAttribute("trustCertMsg"); %>
    </c:if>
	<br/>
    <table class="property-table">
      <tbody>
        <tr class="even">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("AgentBrokerType")}</span>
          </td>
          <td align="left">
            <c:out value="${ub:i18n(broker.type)}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("AgentBrokerTypeDesc")}</span>
          </td>
        </tr>
      </tbody>
    </table>

    <c:if test="${isAdmin && broker.type.restartable}">
      <br/>
      <div class="note">
        ${ub:i18n("AgentBrokerRestartMessage")}<br/>
        <br/>
        <ucf:button href="${restartUrl}" name="RestartBroker" label="${ub:i18n('AgentBrokerRestartBroker')}"
          onclick="if (!basicConfirm('${ah3:escapeJs(ub:i18n('AgentBrokerRestartConfirmMessage'))}')) { return; }"/>
      </div>
    </c:if>

    <br/>
</div>
<jsp:include page="/WEB-INF/jsps/admin/agent/mainAgentTabsFooter.jsp" />
