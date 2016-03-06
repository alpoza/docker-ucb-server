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
<%@page import="com.urbancode.ubuild.web.admin.agentpool.*" %>
<%@page import="com.urbancode.ubuild.domain.agentpool.rule.*" %>
<%@page import="com.urbancode.ubuild.domain.agentpool.rule.group.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.domain.agentpool.rule.RuleTypeEnum" %>
<%@page import="com.urbancode.ubuild.domain.agentpool.rule.RuleConditionEnum" %>

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
    DynamicAgentPool agentpool = (DynamicAgentPool) pageContext.findAttribute(WebConstants.AGENT_POOL);

  AgentPool[] agentPoolList = AgentPoolFactory.getInstance().restoreAll();
  pageContext.setAttribute("can_edit", Boolean.valueOf(Authority.getInstance().hasPermission(agentpool, UBuildAction.AGENT_POOL_EDIT)));
%>

<c:url var="saveUrl"   value="${AgentPoolTasks.saveDynamicAgentPool}"/>
<c:url var="cancelUrl" value="${AgentPoolTasks.cancelAgentPool}"/>
<c:url var="editUrl"   value="${AgentPoolTasks.editDynamicAgentPool}"/>
<c:url var="doneUrl"   value='<%=new AgentPoolTasks().methodUrl("viewAgentPoolList", false)%>'/>
<c:url var="agentPoolAgentListUrl" value='<%=new AgentPoolTasks().methodUrl("agentPoolAgentList", true) %>'>
  <c:param name="${WebConstants.AGENT_POOL_ID}" value="${agentPool.id}"/>
</c:url>
<c:url var="viewAgentUrl" value='<%=new AgentPoolTasks().methodUrl("viewAgent", true) %>'/>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('AgentsAgentPool')}"/>
  <c:param name="selected" value="agents"/>
  <c:param name="disabled" value="${inEditMode}"/>
</c:import>

  <div style="padding-bottom: 1em;">
      <c:import url="dynamicAgentPoolTabs.jsp">
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
        <br/>
        <div id="criteria-builder"></div>
        <c:url var="agentPoolAjaxUrl" value="/rest2/dynamicAgentPools/${agentPool.id}"/>
        <c:url var="ruleTypeUrl" value="/rest2/dynamicAgentPools/ruleTypes"/>
        <c:url var="ruleConditionUrl" value="/rest2/dynamicAgentPools/ruleConditions"/>
        <script type="text/javascript">
            var ruleTypeOptions = [];
            var ruleConditionOptions = [];
            var allowedConditions = [];
            <%
              for (RuleTypeEnum type : RuleTypeEnum.values()) {
                  pageContext.setAttribute("typeLabel", type.getName());
                  pageContext.setAttribute("typeValue", type.name());
            %>
                  ruleTypeOptions.push({
                      "label": "${typeLabel}",
                      "value": "${typeValue}"
                  });

                  ruleConditionOptions["${typeValue}"] = [];
            <%
                  for (RuleConditionEnum condition : type.getAllowedConditions()) {
                      pageContext.setAttribute("conditionLabel", condition.getName());
                      pageContext.setAttribute("conditionValue", condition.name());
            %>
                      ruleConditionOptions["${typeValue}"].push({
                          "label": "${conditionLabel}",
                          "value": "${conditionValue}"
                      });
            <%
                  }
              }
            %>

            require(["ubuild/module/UBuildApp", "ubuild/criteria_builder/CriteriaBuilder", "dojo/_base/xhr"],
                function(UBuildApp, CriteriaBuilder, xhr) {
                UBuildApp.util.i18nLoaded.then(function() {
                    var criteriaBuilder = null;
                    xhr.get({
                       url: "${agentPoolAjaxUrl}",
                       handleAs:"json",
                       load: function(data) {
                           criteriaBuilder = new CriteriaBuilder({"json": data, "ruleTypeOptions": ruleTypeOptions,
                           "ruleConditionOptions": ruleConditionOptions, "postUrl": "${agentPoolAjaxUrl}", disabled: ${not can_edit or inEditMode}});
                           criteriaBuilder.placeAt("criteria-builder");
                       }
                    });
                });
            });
        </script>
        <br />
        <div id="agents-in-env-paging" class="yui-skin-sam" style="float:right;padding-bottom:0px"></div>
        <div id="agents-in-env-table"></div>
        <script type="text/javascript">
          /* <![CDATA[ */
          /* ]]> */
        </script>
      </c:if>
      </div>
    </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
