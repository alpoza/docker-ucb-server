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

<%@ page import="com.urbancode.ubuild.web.admin.agent.AgentTasks"%>
<%@ page import="com.urbancode.ubuild.main.UBuildAgentVersion"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentTasks" useConversation="false" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.agent.AgentStatusEnum"/>

<auth:checkAction var="hasWritePermission" action="${UBuildAction.AGENT_MANAGEMENT}"/>

<c:url var="viewAgentUrl" value='${AgentTasks.viewAgent}'/>
<c:url var="testAgentUrl" value='${AgentTasks.testAgentConnection}'/>

<c:url var="configuredAgentListUrl" value='${AgentTasks.configuredAgentList}'/>
<c:url var="ignoredAgentListUrl" value='${AgentTasks.ignoredAgentList}'/>
<c:url var="inactiveAgentListUrl" value='${AgentTasks.inactiveAgentList}'/>

<c:url var="ignoreAgentsUrl" value='${AgentTasks.ignoreAgents}'/>
<c:url var="activateIgnoredAgentsUrl" value='${AgentTasks.activateIgnoredAgents}'/>
<c:url var="deleteAgentsUrl" value='${AgentTasks.deleteAgents}'/>
<c:url var="restartAgentsUrl" value='${AgentTasks.restartAgents}'/>
<c:url var="upgradeAgentsUrl" value='${AgentTasks.upgradeAgents}'/>
<c:url var="configureAgentsUrl" value='${AgentTasks.configureAgents}'/>

<c:url var="setConfiguredAgentRowsPerPageUrl" value='${AgentTasks.setConfiguredAgentRowsPerPage}'/>
<c:url var="setIgnoredAgentRowsPerPageUrl" value='${AgentTasks.setIgnoredAgentRowsPerPage}'/>
<c:url var="setInactiveAgentRowsPerPageUrl" value='${AgentTasks.setInactiveAgentRowsPerPage}'/>

<c:url var="imgUrl" value="/images"/>

<jsp:useBean id="agentInfo" class="com.urbancode.ubuild.web.components.AgentInfo"/>

<%-- CONTENT --%>

<c:set var="onDocumentLoad" scope="request">
  /* <![CDATA[ */
  var configuredAgentRowsPerPage = <c:out default="25" value="${configuredAgentRowsPerPage}"/>;

  var agentListPageConfig = {
      imgUrl: "${ah3:escapeJs(imgUrl)}",
      viewAgentUrl:"${viewAgentUrl}",
      testAgentUrl:"${testAgentUrl}",
      configuredAgentRowsPerPage:configuredAgentRowsPerPage,
      configuredAgentListUrl:"${configuredAgentListUrl}?",
      setConfiguredAgentRowsPerPageUrl:"${setConfiguredAgentRowsPerPageUrl}",
      inactiveAgentRowsPerPage:<c:out default="25" value="${inactiveAgentRowsPerPage}"/>,
      inactiveAgentListUrl:"${inactiveAgentListUrl}?",
      setInactiveAgentRowsPerPageUrl:"${setInactiveAgentRowsPerPageUrl}",
      ignoredAgentRowsPerPage:<c:out default="25" value="${ignoredAgentRowsPerPage}"/>,
      ignoredAgentListUrl:"${ignoredAgentListUrl}?",
      setIgnoredAgentRowsPerPageUrl:"${setIgnoredAgentRowsPerPageUrl}",
      ignoreAgentsUrl:"${ignoreAgentsUrl}",
      restartAgentsUrl:"${restartAgentsUrl}",
      deleteAgentsUrl:"${deleteAgentsUrl}",
      upgradeAgentsUrl:"${upgradeAgentsUrl}",
      activateIgnoredAgentsUrl:"${activateIgnoredAgentsUrl}",
      configureAgentsUrl:"${configureAgentsUrl}",
      hasWritePermission: ${hasWritePermission}
  };

  agentListPage = new AgentListPage(agentListPageConfig);
  agentListPage.imgUrl = "${ah3:escapeJs(imgUrl)}";

  agentListPage.initializeTabs();
  var result = agentListPage.initializeConfiguredAgentsTable();
  var filter = YAHOO.util.Dom.get("conf_filter_input").value;
  var query = 'sort=Name&dir=asc&startIndex=0&results=' + configuredAgentRowsPerPage + (filter ? '&filter=' + filter : '');

  var dataTable = result.table;
  var callback = {
      success : dataTable.onDataReturnSetRows,
      failure : dataTable.onDataReturnSetRows,
      scope   : dataTable,
      argument: dataTable.getState()
  };

  result.dataSource.sendRequest(query, callback);
  /* ]]> */
</c:set>
<c:import url="/WEB-INF/jsps/admin/agent/mainAgentTabsHeader.jsp">
  <c:param name="title" value="${ub:i18n('AgentList')}"/>
  <c:param name="selected" value="Agent"/>
</c:import>

<script type="text/javascript">
  var agentListPage;
</script>

<div class="contents">
    <div class="system-helpbox">
      ${ub:i18n("AgentListSystemHelpbox")}
      <%
        pageContext.setAttribute("ucbAgentVersion", UBuildAgentVersion.getInstance());
      %>
      <span style="margin-left: 20px;"><strong>${ub:i18n("AcceptableAgentVersion")}</strong> ${fn:escapeXml(ucbAgentVersion.minAgentVersion)}*</span>
      <span style="margin-left: 20px;"><strong>${ub:i18n("CurrentAgentVersion")}</strong> ${fn:escapeXml(ucbAgentVersion.availableAgentVersion)}</span>
    </div>

    <%-- AGENT WARNINGS --%>
    <c:if test="${agentInfo.badVersionAgentCount > 0}">
      <div class="warningHeader">
        <c:if test="${agentInfo.badVersionAgentCount == 1}">
        ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
        ${ub:i18n("AgentListAgentVersionInvalidMessage")}<br/>
        ${ub:i18n("AgentListAgentVersionUpdateMessage")}
        </c:if>

        <c:if test="${agentInfo.badVersionAgentCount > 1}">
        ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
        ${ub:i18nMessage("AgentListMultipleAgentVersionInvalidMessage", agentInfo.badVersionAgentCount)}<br/>
        ${ub:i18n("AgentListMultipleAgentVersionUpdateMessage")}
        </c:if>
      </div>
    </c:if>
    <c:if test="${agentInfo.configuredAgentCount == 0}">
      <div class="warningHeader">
        ${fn:toUpperCase(ub:i18n("Warning"))}<br/>
        ${ub:i18n("AgentListNoAgentConfiguredMessage")}
      </div>
    </c:if>

    <c:if test="${!empty okMessage}">
      <br/>
      <div class="dashboard-contents"><span class="message">${okMessage}</span></div>
      <c:remove var="okMessage" scope="session" />
    </c:if>

    <c:if test="${not empty errorMessage}">
      <br/>
      <div class="error"><c:out value="${errorMessage}"/></div>
      <c:remove var="errorMessage" scope="session" />
    </c:if>

      <c:forEach var="error" items="${errors}">
        <br/>
        <div class="error">
          ${fn:escapeXml(error)}
        </div>
      </c:forEach>
      <div id="messageDiv" class="system-helpbox" style="display: none; margin-top: 1em; margin-bottom: 1em;"></div>
      <div id="agentTabs" class="yui-navset">
        <div class="tab_agents">
            <ul class="tabs yui-nav"> 
              <li class="current selected">
                <a href="#tab1" title="${ub:i18n('AgentListConfiguredButtonTitle')}">${ub:i18n("Configured")}
                  <img border="0" alt="${ub:i18n('Configured')}" src="${fn:escapeXml(imgUrl)}/icon_configured.gif"/>
                </a>
              </li> 
              <li>
                <a href="#tab2" title="${ub:i18n('AgentListAvailableButtonTitle')}">${ub:i18n("Available")}&nbsp;<img border="0" alt="${ub:i18n('Available')}" src="${fn:escapeXml(imgUrl)}/icon_available.gif"/></a>
              </li>
              <li>
                <a href="#tab3" title="${ub:i18n('AgentListIgnoredButtonTitle')}">${ub:i18n("Ignored")}&nbsp;<img border="0" alt="${ub:i18n('Ignored')}" src="${fn:escapeXml(imgUrl)}/icon_ignored.gif"/></a>
                </li> 
            </ul>
        </div>
        <div class="yui-content">
            <div id="configuredTab">
              <div>
                <div id="configured-agents-paging" class="yui-skin-sam" style="margin: 20px 0 5px 0; text-align:right; width:50%; float:right;"></div>
                <div id="configured-filter" style="margin: 0 0 5px 0; text-align:left; float:left; width:50%;">
                  <table class="no-padding">
                    <tr>
                      <td><label for="conf_filter_input">${ub:i18n("FilterWithColon")}</label></td>
                      <td><label for="conf_status_input">${ub:i18n("StatusWithColon")}</label></td>
                      <c:if test="${hasWritePermission}">
                        <td><label>${ub:i18n("ActionsWithColon")}</label></td>
                      </c:if>
                    </tr>
                    <tr>
                      <td><ucf:text id="conf_filter_input" name="filter" value="" size="20"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td>
                        <select id="conf_status_input" name="status" >
                          <option value="">${ub:i18n("All")}</option>
                          <c:forEach var="enum" items="${AgentStatusEnum.values}">
                              <option value="${enum.name}">${ub:i18n(enum.displayName)}</option>
                          </c:forEach>
                        </select>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      </td>
                      <c:if test="${hasWritePermission}">
                        <td>
                          <a title="${ub:i18n('IgnoreAgents')}" onclick="agentListPage.ignoreAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('IgnoreAgents')}" src="${fn:escapeXml(imgUrl)}/icon_ignore_agent.gif"/></a>
                          <a title="${ub:i18n('DeleteAgents')}" onclick="agentListPage.deleteConfiguredAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('DeleteAgents')}" src="${fn:escapeXml(imgUrl)}/icon_delete.gif"/></a>
                          <a title="${ub:i18n('RestartAgents')}" onclick="agentListPage.restartAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('RestartAgents')}" src="${fn:escapeXml(imgUrl)}/icon_restart.gif"/></a>
                          <a title="${ub:i18n('UpgradeAgents')}" onclick="agentListPage.upgradeAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('UpgradeAgents')}" src="${fn:escapeXml(imgUrl)}/icon_upgrade.gif"/></a>
                          <a title="${ub:i18n('UnselectAgents')}" onclick="agentListPage.clearConfiguredSelectedAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('UnselectAgents')}" src="${fn:escapeXml(imgUrl)}/icon_deselectAll.gif"/></a>
                          <span id="confSelected" ></span>
                        </td>
                      </c:if>
                    </tr>
                  </table>
                  <div id="configured_ac_container"></div>
                </div>
                <div style="clear:both;"></div>
              </div>
              <div id="configured-agents"></div>
            </div> 
            <div id="availableTab">
              <div>
                <div id="available-agents-paging" class="yui-skin-sam" style="margin: 20px 0 5px 0; text-align:right; width:50%; float:right;"></div>
                <div id="available-filter" style="margin: 0 0 5px 0; text-align:left; float:left; width:50%;">
                  <table class="no-padding">
                    <tr>
                      <td><label for="avail_filter_input">${ub:i18n("FilterWithColon")}</label></td>
                      <td><label for="avail_status_input">${ub:i18n("StatusWithColon")}</label></td>
                      <c:if test="${hasWritePermission}">
                        <td><label>${ub:i18n("ActionsWithColon")}</label></td>
                      </c:if>
                    </tr>
                    <tr>
                      <td><ucf:text id="avail_filter_input" name="filter" value="" size="20"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td>
                        <select id="avail_status_input" name="status">
                          <option value="">${ub:i18n("All")}</option>
                          <c:forEach var="enum" items="${AgentStatusEnum.values}">
                              <option value="${enum.name}">${ub:i18n(enum.displayName)}</option>
                          </c:forEach>
                        </select>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      </td>
                      <c:if test="${hasWritePermission}">
                        <td>
                          <a title="${ub:i18n('ConfigureAgents')}" onclick="agentListPage.configureAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('ConfigureAgents')}" src="${fn:escapeXml(imgUrl)}/icon_availToConfig.gif"/></a>
                          <a title="${ub:i18n('UpgradeAgents')}" onclick="agentListPage.upgradeAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('UpgradeAgents')}" src="${fn:escapeXml(imgUrl)}/icon_upgrade.gif"/></a>
                          <a title="${ub:i18n('UnselectAgents')}" onclick="agentListPage.clearAvailableSelectedAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('UnselectAgents')}" src="${fn:escapeXml(imgUrl)}/icon_deselectAll.gif"/></a>
                          <span id="availSelected" ></span>
                        </td>
                      </c:if>
                    </tr>
                  </table>
                  <div id="available_ac_container"></div>
                </div>
                <div style="clear:both;"></div>
              </div>
              <div id="inactive-agents"></div>
            </div>
            <div id="ignoredTab">
              <div>
                <div id="ignored-agents-paging" class="yui-skin-sam" style="margin: 20px 0 5px 0; text-align:right; width:50%; float:right;"></div>
                <div id="ignored-filter" style="margin: 0 0 5px 0; text-align:left; float:left; width:50%;">
                  <table class="no-padding">
                    <tr>
                      <td><label for="ign_filter_input">${ub:i18n("FilterWithColon")}</label></td>
                      <td><label for="ign_status_input">${ub:i18n("StatusWithColon")}</label></td>
                      <c:if test="${hasWritePermission}">
                        <td><label>${ub:i18n("ActionsWithColon")}</label></td>
                      </c:if>
                    </tr>
                    <tr>
                      <td>
                        <ucf:text id="ign_filter_input" name="filter" value="" size="20"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      </td>
                      <td>
                        <select id="ign_status_input" name="status">
                          <option value="">${ub:i18n("All")}</option>
                          <c:forEach var="enum" items="${AgentStatusEnum.values}">
                              <option value="${enum.name}">${ub:i18n(enum.displayName)}</option>
                          </c:forEach>
                        </select>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      </td>
                      <c:if test="${hasWritePermission}">
                        <td>
                          <a title="${ub:i18n('ActivateAgents')}" onclick="agentListPage.activateAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('ActivateAgents')}" src="${fn:escapeXml(imgUrl)}/icon_reconfig.gif"/></a>
                          <a title="${ub:i18n('DeleteAgents')}" onclick="agentListPage.deleteIgnoredAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('DeleteAgents')}" src="${fn:escapeXml(imgUrl)}/icon_delete.gif"/></a>
                          <a title="${ub:i18n('UnselectAgents')}" onclick="agentListPage.clearIgnoredSelectedAgents()" style="cursor:pointer;"><img border="0" alt="${ub:i18n('UnselectAgents')}" src="${fn:escapeXml(imgUrl)}/icon_deselectAll.gif"/></a>
                          <span id="ignSelected" ></span>
                        </td>
                      </c:if>
                    </tr>
                  </table>
                  <div id="ignored_ac_container"></div>
                </div>
                  <div style="clear:both;"></div>
              </div>
                <div id="ignored-agents"></div>
            </div> 
        </div>
      </div>
      

</div>
<jsp:include page="/WEB-INF/jsps/admin/agent/mainAgentTabsFooter.jsp" />
