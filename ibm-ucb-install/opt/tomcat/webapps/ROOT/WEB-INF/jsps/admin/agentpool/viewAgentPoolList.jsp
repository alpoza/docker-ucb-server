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

<%@page import="com.urbancode.ubuild.domain.agentpool.*" %>
<%@page import="com.urbancode.ubuild.web.*" %>

<%@page import="java.util.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<%
    AgentPool[] agentPoolList = AgentPoolFactory.getInstance().restoreAll();
    request.setAttribute(WebConstants.AGENT_POOL_LIST, agentPoolList);
%>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/admin/agent/mainAgentTabsHeader.jsp">
  <jsp:param name="title" value="${ub:i18n('AgentPoolsList')}"/>
  <jsp:param name="selected" value="Environment"/>
</jsp:include>
<div class="contents">
    <div class="system-helpbox">${ub:i18n("AgentPoolsSystemHelpBox")}</div>
    <c:if test="${error!=null}">
        <br/><div class="error">${fn:escapeXml(error)}</div>
    </c:if>
    <br/>

    <div>
        <c:url var="newFixedUrl" value="${AgentPoolTasks.newFixedAgentPool}"/>
        <c:url var="newDynamicUrl" value="${AgentPoolTasks.newDynamicAgentPool}"/>
        <ucf:button href="${newFixedUrl}" name="CreateFixed" label="${ub:i18n('AgentPoolsCreateFixedAgentPool')}"/>
        <ucf:button href="${newDynamicUrl}" name="CreateDynamic" label="${ub:i18n('AgentPoolsCreateDynamicAgentPool')}"/>
    </div>
    <br/>

    <div class="data-table_container">
        <table class="data-table">
            <tbody>
                <tr>
                    <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
                    <th scope="col" align="left" width="5%">${ub:i18n("Type")}</th>
                    <th scope="col" align="left">${ub:i18n("Description")}</th>
                    <th scope="col" align="left" width="10%">${ub:i18n("Actions")}</th>
                </tr>

                <c:if test="${agentPoolList[0]==null}">
                    <tr bgcolor="#ffffff">
                        <td colspan="3">${ub:i18n("AgentPoolsNoAgentPoolsConfiguredMessage")}</td>
                    </tr>
                </c:if>

                <c:forEach var="agentPool" items="${agentPoolList}">
                    <%
                        AgentPool sg = (AgentPool) pageContext.findAttribute("agentPool");
                    %>

                    <c:url var="viewPoolUrl" value="${AgentPoolTasks.viewAgentPool}">
                        <c:param name="agentPoolId" value="${agentPool.id}"/>
                    </c:url>

                    <c:url var="deleteUrl" value="${AgentPoolTasks.deleteAgentPool}">
                        <c:param name="agentPoolId" value="${agentPool.id}"/>
                    </c:url>

                    <tr bgcolor="#ffffff">
                        <td align="left" nowrap="nowrap">
                            <a href="${fn:escapeXml(viewPoolUrl)}">
                                ${fn:escapeXml(ub:i18n(agentPool.name))}
                            </a>
                        </td>

                        <td align="center" nowrap="nowrap">
                            ${fn:escapeXml(agentPool.dynamic ? ub:i18n("AgentPoolsTypeDynamic") : ub:i18n("Fixed"))}
                        </td>

                        <td align="left">
                            ${fn:escapeXml(ub:i18n(agentPool.description))}
                        </td>

                        <td align="center" nowrap="nowrap" width="10%">
                            <c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
                            <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
                            <ucf:link href="${viewPoolUrl}" img="${iconMagnifyGlassUrl}" label="${ub:i18n('ViewAgentPool')}"/>&nbsp;
                            <ucf:deletelink href="${deleteUrl}" name="${agentPool.name}" label="${ub:i18n('Delete')}" img="${iconDeleteUrl}" enabled="${fn:length(nameList)==0 && fn:length(usedIn)==0}"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<jsp:include page="/WEB-INF/jsps/admin/agent/mainAgentTabsFooter.jsp" />
