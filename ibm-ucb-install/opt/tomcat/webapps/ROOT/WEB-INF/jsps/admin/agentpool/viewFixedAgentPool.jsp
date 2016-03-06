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
<%@page import="com.urbancode.ubuild.domain.agent.*" %>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@page import="com.urbancode.ubuild.domain.agentpool.*" %>
<%@page import="com.urbancode.ubuild.services.license.*" %>
<%@page import="com.urbancode.ubuild.web.admin.agentpool.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentpool.AgentPoolTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

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
    FixedAgentPool agentpool = (FixedAgentPool) pageContext.findAttribute(WebConstants.AGENT_POOL);

  AgentPool[] agentPoolList = AgentPoolFactory.getInstance().restoreAll();
  pageContext.setAttribute("can_edit", Boolean.valueOf(Authority.getInstance().hasPermission(agentpool, UBuildAction.AGENT_POOL_EDIT)));
%>

<c:url var="saveUrl"   value="${AgentPoolTasks.saveFixedAgentPool}"/>
<c:url var="cancelUrl" value="${AgentPoolTasks.cancelAgentPool}"/>
<c:url var="editUrl"   value="${AgentPoolTasks.editFixedAgentPool}"/>
<c:url var="doneUrl"   value='<%=new AgentPoolTasks().methodUrl("viewAgentPoolList", false)%>'/>
<c:url var="agentPoolAgentListUrl" value='<%=new AgentPoolTasks().methodUrl("agentPoolAgentList", true) %>'>
  <c:param name="${WebConstants.AGENT_POOL_ID}" value="${agentPool.id}"/>
</c:url>
<c:url var="viewAgentUrl" value='<%=new AgentPoolTasks().methodUrl("viewAgent", true) %>'/>
<c:url var="editAgentsUrl" value='<%=new AgentPoolTasks().methodUrl("editAgents", true) %>'>
  <c:param name="${WebConstants.AGENT_POOL_ID}" value="${agentPool.id}"/>
</c:url>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('AgentsAgentPool')}"/>
  <jsp:param name="selected" value="agents"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

 <div style="padding-bottom: 1em;">
      <c:import url="fixedAgentPoolTabs.jsp">
        <c:param name="selected" value="main"/>
        <c:param name="disabled" value="${inEditMode}"/>
      </c:import>

    <div class="contents">

      <div align="right">
        <span class="required-text">${ub:i18n("RequiredField")}</span>
      </div>
      <c:if test="${not empty agentPool}">
        <div class="translatedName"><c:out value="${ub:i18n(agentPool.name)}"/></div>
        <c:if test="${not empty agentPool.description}">
          <div class="translatedDescription"><c:out value="${ub:i18n(agentPool.description)}"/></div>
        </c:if>
      </c:if>
      <form method="post" action="${fn:escapeXml(saveUrl)}">
        <table class="property-table">
          <tbody>
            <c:set var="fieldName" value="name"/>
            <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : agentPool.name}"/>
            <error:field-error field="name" cssClass="odd"/>
            <tr class="even" valign="top">
              <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>

              <td align="left" width="20%">
                <ucf:text name="name" value="${nameValue}" enabled="${inEditMode}"/>
              </td>

              <td align="left">
                <span class="inlinehelp">${ub:i18n("AgentPoolsNameDesc")}</span>
              </td>
            </tr>

            <c:set var="fieldName" value="description"/>
            <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : agentPool.description}"/>
            <error:field-error field="description" cssClass="odd"/>
            <tr class="even" valign="top">
              <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>

              <td align="left" colspan="2">
                <ucf:textarea name="description" value="${descriptionValue}" enabled="${inEditMode}"/>
              </td>
            </tr>

            <c:if test="${empty agentPool}">
              <c:import url="/WEB-INF/snippets/admin/security/newSecuredObjectSecurityFields.jsp"/>
            </c:if>

            <tr>
              <td colspan="3">
                <c:if test="${inEditMode}">
                  <ucf:button name="saveAgentPool" label="${ub:i18n('Save')}"/>
                  <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
                </c:if>
                <c:if test="${inViewMode}">
              <c:if test="${can_edit}">
                <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
              </c:if>
              <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
                </c:if>
              </td>
            </tr>
          </tbody>
        </table>
      </form>

      <c:if test="${not empty agentPool}">
        <br />
            <c:if test="${!empty saveMessage}">
              <div style="color: green; margin-bottom: 10px" id="saveMessage">${fn:escapeXml(saveMessage)}</div>
              <c:remove var="saveMessage" scope="session"/>
              <script type="text/javascript">
                /* <![CDATA[ */
                setTimeout('$("saveMessage").remove()', 5000); // remove save message after 5 seconds
                /* ]]> */
              </script>
            </c:if>

            <div id="agents-in-env-paging" class="yui-skin-sam" style="float:right;padding-bottom:0px"></div>
        <div id="agents-in-env-table"></div>
        <br/>
        <c:if test="${can_edit && !inEditMode}">
          <ucf:button name="AddRemoveAgents" label="${ub:i18n('AgentPoolsAddRemoveAgents')}" submit="false"
            onclick="showPopup('${editAgentsUrl}', 1000, 800);"/>
        </c:if>
        <script type="text/javascript">
          /* <![CDATA[ */
          require(["ubuild/module/UBuildApp"], function(UBuildApp) {
                UBuildApp.util.i18nLoaded.then(function() {

                    var EnvironmentForm = {
                            agentsInEnvironment: null,

                            initializeAgentsInEnvironmentTable: function() {
                                var myDatSource = null;

                                var nameFormatter = function(elLiner, oRecord, oColumn, oData) {
                                    var a = document.createElement("a");
                                    var id = oRecord.getData("AgentId");
                                    a.href = "${viewAgentUrl}&agent_id=" + id + "&agentPoolId=${agentPool.id}";
                                    a.appendChild(document.createTextNode(oRecord.getData("Name")));

                                    elLiner.innerHTML = "";
                                    elLiner.appendChild(a);
                                    if (oRecord.getData("Configured") == false) {
                                        elLiner.appendChild(document.createTextNode(" ${ub:i18n('AgentNotConfigured')}"));
                                    }
                                    if (oRecord.getData("Ignored") == true) {
                                        elLiner.appendChild(document.createTextNode(" ${ub:i18n('AgentIgnored')}"));
                                    }
                                };

                                var myColumnDefs = [
                                    { key: "Name", label:"${ub:i18n('Name')}", formatter:nameFormatter },
                                    { key: "Description", label: "${ub:i18n('Description')}" }
                                ];

                                this.myDataSource = new YAHOO.util.DataSource("${agentPoolAgentListUrl}");

                                this.myDataSource.responseSchema = {
                                        resultsList: "items",
                                        fields: [
                                            {key:"AgentId"},
                                            {key:"Name"},
                                            {key:"Description"},
                                            {key:"Configured"},
                                            {key:"Ignored"}
                                        ]
                                };

                                var agentsInEnvironmentTableConfigs = {
                                        caption:"${ub:i18n('AgentPoolsAgentsInPool')}",
                                        paginator : new YAHOO.widget.Paginator({
                                            rowsPerPage:25,
                                            template:YAHOO.widget.Paginator.TEMPLATE_ROWS_PER_PAGE,
                                            containers:"agents-in-env-paging",
                                            pageLinks:12,
                                            rowsPerPageOptions:[5, 25, 50, 100]
                                        }),
                                        MSG_EMPTY: i18n('No records found.'),
                                        MSG_LOADING: i18n('LoadingEllipsis')
                                };

                                this.agentsInEnvironment = new YAHOO.widget.DataTable("agents-in-env-table", myColumnDefs, this.myDataSource, agentsInEnvironmentTableConfigs);
                            }
                    };

                    YAHOO.util.Event.addListener(window,"load", EnvironmentForm.initializeAgentsInEnvironmentTable());
                });
            });
          /* ]]> */
        </script>
      </c:if>
      </div>
    </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
