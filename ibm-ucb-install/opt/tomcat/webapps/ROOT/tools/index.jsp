<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.urbancode.ubuild.web.util.*" %>
<%@ page import="com.urbancode.ubuild.runtime.scripting.helpers.UrlHelper" %>
<%@ page import="com.urbancode.ubuild.persistence.UnitOfWork" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:url var="jsUrl" value="/js"/>
<c:url var="imgUrl" value="/images"/>
<c:url var="dashboardUrl" value="/"/>

<%
  EvenOdd eo = new EvenOdd();
  eo.getNext();
  pageContext.setAttribute("eo", eo);
%>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('Tools')}" />
  <c:param name="selected" value="Tools" />
  <c:param name="disabled" value="${disableButtons}" />
</c:import>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('Tools')}" href="" klass="selected tab" enabled="${false}"/>
  </div>
  <div class="contents">
    <br/>
    <table class="data-table">
      <caption>${ub:i18n("DevelopmentTools")}</caption>
      <tbody>
        <tr class="row-${eo.next}">
          <td class="label nowrap">${ub:i18n("AgentInstaller")}</td>
          <td width="30%"><a href="agentinstaller/ibm-ucb-agent.zip">ibm-ucb-agent.zip</a></td>
          <td class="helpinfo">
            ${ub:i18n("AgentInstallerDesc")}
          </td>
        </tr>

        <tr class="row-${eo.next}">
          <td class="label nowrap">${ub:i18n("CodeStationClient")}</td>
          <td width="30%"><a href="codestation/ibm-ucb-codestation-client.zip">ibm-ucb-codestation-client.zip</a></td>
          <td class="helpinfo">
            ${ub:i18n("CodeStationClientDesc")}
          </td>
        </tr>

        <tr class="row-${eo.next}">
          <td class="label nowrap">${ub:i18n("PreflightClient")}</td>
          <td width="30%"><a href="preflight/preflight-app.zip">preflight-app.zip</a><br /><a href="preflight/preflight-app.tar.gz">preflight-app.tar.gz</a></td>
          <td class="helpinfo">
            ${ub:i18n("PreflightClientDesc")}
          </td>
        </tr>

        <tr class="row-${eo.next}">
          <td class="label nowrap">${ub:i18n("ScriptingAPI")}</td>
          <td width="30%"><a href="scripting/ibm-ucb-scripting" target="_blank">${ub:i18n("ViewAPI")}</a><%-- (<a href="scripting/ibm-ucb-scripting.zip">download</a>) --%></td>
          <td class="helpinfo">
            ${ub:i18n("ScriptingAPIDesc")}
          </td>
        </tr>

        <%
            UnitOfWork uow = UnitOfWork.createSystemUnitOfWork();
            String externalUrl = UrlHelper.getBaseUrl();
            String updateSiteUrl = externalUrl + "/tools/eclipse";
            pageContext.setAttribute("updateSiteUrl", updateSiteUrl);
            uow.close();
        %>
        <tr class="row-${eo.next}">
          <td class="label nowrap">${ub:i18n("uBuildEclipsePlugin")}</td>
          <td width="30%">${updateSiteUrl}</td>
          <td class="helpinfo">
            ${ub:i18n("uBuildEclipsePluginDesc")}
          </td>
        </tr>
        
      </tbody>
    </table>
    <br/>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
