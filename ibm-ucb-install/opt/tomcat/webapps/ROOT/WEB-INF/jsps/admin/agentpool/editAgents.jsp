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
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" useConversation="false" />

<c:url var="imgUrl" value="/images"/>
<c:url var="agentPoolAgentListUrl" value='${AgentPoolTasks.agentPoolAgentList}'>
  <c:param name="${WebConstants.AGENT_POOL_ID}" value="${agentPool.id}"/>
</c:url>
<c:url var="addAgentsListUrl"   value="${AgentPoolTasks.addAgentsList}">
  <c:param name="${WebConstants.AGENT_POOL_ID}" value="${agentPool.id}"/>
</c:url>
<c:url var="saveAgentsUrl" value='${AgentPoolTasks.saveAgentsInAgentPool}'>
  <c:param name="${WebConstants.AGENT_POOL_ID}" value="${agentPool.id}"/>
</c:url>
<c:url var="viewAgentPoolUrl" value='${AgentPoolTasks.viewAgentPool}'>
  <c:param name="${WebConstants.AGENT_POOL_ID}" value="${agentPool.id}"/>
</c:url>

<c:set var="headContent">
  <style type="text/css">
  .yui-dt table {
    border-bottom: solid 1px #76a3b9;
  }

  .yui-dt-scrollable {
    width: 100%;
  }

  .yui-dt-scrollable .selectCol {
    width: 5%;
  }

  .yui-dt-scrollable .nameCol {
    width: 15%;
  }

  .yui-dt-scrollable .hostCol {
    width: 40%;
  }

  .yui-dt-scrollable .descCol {
    width: 40%;
  }

  #addAgents {
    display: inline-block;
    width: 50px;
    height: 35px;
    background: url("${ah3:escapeJs(imgUrl)}/arrow-up-button.gif") no-repeat 0 0;
  }

  #addAgents:hover {
    background-position: 0 -35px;
  }

  #addAgents span {
    display: none;
  }

  #removeAgents {
    display: inline-block;
    width: 50px;
    height: 35px;
    background: url("${ah3:escapeJs(imgUrl)}/arrow-down-button.gif") no-repeat 0 0;
  }

  #removeAgents:hover {
    background-position: 0 -35px;
  }

  #removeAgents span {
    display: none;
  }
  </style>
</c:set>

  <%-- CONTENT --%>
<c:set var="onDocumentLoad" scope="request">
  environmentForm = new EnvironmentForm("${viewAgentPoolUrl}");
  environmentForm.initializeAgentsInEnvironmentTable(true, "${agentPoolAgentListUrl}");
  environmentForm.initializeAddAgentsTable(true, "${addAgentsListUrl}");
  </c:set>
<c:set var="headContent" scope="request">
  ${headContent}
  <script type="text/javascript">
    var environmentForm = null;
  </script>
</c:set>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div id="snippet_padding">
  <div class="popup_header">
      <ul>
          <li class="current">
              <a>${ub:i18n("AgentPoolsAddRemoveAgents")}</a>
        </li>
    </ul>
  </div>

  <div class="contents">
    <div class="table_wrapper" style="height: 800px;">
      <form id="addAgentsForm" action="${saveAgentsUrl}" method="post" onsubmit="environmentForm.preSaveAction()">
        <input id="${AgentPoolTasks.AGENT_IDS}" type="hidden" name="${AgentPoolTasks.AGENT_IDS}" value="" />
        <div style="margin:0 2em 0 1em">
          <div><h2>${ub:i18nMessage("AgentPoolsAgentsIn", agentPool.name)}</h2></div>
          <div id="agents-in-env-paging" class="yui-skin-sam" style="margin:3px 0 5px 0; text-align:right;"></div>
          <div id="agents-in-env-table" style="width:100%"></div>
        </div>
        <div style="text-align:center; margin: 10px 0 10px 0;">
          <a id="addAgents" title="${ub:i18n('AgentPoolsAddAgents')}" onclick="environmentForm.addSelectedAgents()" style="cursor: pointer;"><span>${ub:i18n("AgentPoolsAddAgents")}</span></a>
          <a id="removeAgents" title="${ub:i18n('AgentPoolsRemoveAgents')}" onclick="environmentForm.removeSelectedAgents()" style="cursor: pointer;"><span>${ub:i18n("AgentPoolsRemoveAgents")}</span></a>
        </div>
        <div style="margin:0 2em 0 1em">
          <div><h2>${ub:i18n("AgentPoolsPotentialAgents")}</h2></div>
            <div id="autocomplete" style="margin: 3px 0 5px 0; text-align:left;">
              <label for="query_input"><b>${ub:i18n("FilterWithColon")}</b></label><ucf:text id="query_input" name="query" value="" size="10"/>
              <div id="dt_ac_container"></div>
            </div>
            <div id="add-agents-table" style="width:100%"></div>
            <div id="add-agents-paging" class="yui-skin-sam" style="margin: 5px 0 0 0; text-align:right;"></div>
        </div>
        <div style="margin:7px 0 0 0">
          <ucf:button name="Save" label="${ub:i18n('Save')}" submit="${true}"/>
          <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="environmentForm.cancelAgentsTable(); return false"/>
        </div>
      </form>
    </div>
  </div>
  </div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
