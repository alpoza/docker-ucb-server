<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ tag body-content="empty" %>
<%@ tag import="com.urbancode.air.plugin.server.PluginFactory" %>
<%@ tag import="com.urbancode.air.plugin.server.AutomationPlugin" %>
<%@ tag import="com.urbancode.air.property.prop_sheet_def.PropSheetDef" %>
<%@ tag import="com.urbancode.commons.util.CollectionUtil" %>
<%@ tag import="com.urbancode.commons.util.StringUtil" %>
<%@ tag import="com.urbancode.ubuild.domain.agentpool.AgentPool" %>
<%@ tag import="com.urbancode.ubuild.domain.agentpool.AgentPoolFactory" %>
<%@ tag import="com.urbancode.ubuild.domain.buildlife.BuildLife" %>
<%@ tag import="com.urbancode.ubuild.domain.property.PropertyTemplate" %>
<%@ tag import="com.urbancode.ubuild.domain.project.Project" %>
<%@ tag import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@ tag import="com.urbancode.ubuild.domain.workflow.WorkflowUserOverrideablePropertyHelper" %>
<%@ tag import="com.urbancode.ubuild.runtime.scripting.LookupContext" %>
<%@ tag import="com.urbancode.ubuild.web.WebConstants" %>
<%@ tag import="com.urbancode.ubuild.web.controller.Form" %>
<%@ tag import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ tag import="com.urbancode.ubuild.web.util.FormErrors" %>
<%@ tag import="java.util.*" %>

<%@attribute name="isNew"                      required="true"  type="java.lang.Boolean"%>
<%@attribute name="inEditMode"                 required="true"  type="java.lang.Boolean"%>
<%@attribute name="propertyList"               required="true" type="java.util.List"%>
<%@attribute name="propertyName2State"         required="true"  type="java.util.Map"%>
<%@attribute name="prop2SelectedValue"         required="false" type="java.util.Map"%>
<%@attribute name="configuredPropertyValueMap" required="false" type="java.util.Map"%>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<error:field-error field="properties" cssClass="${eo.last}"/>

<c:forEach var="property" items="${propertyList}" varStatus="propLoopStatus">
  <%-- clear values from prior loops (c:set of null leaves prior non-null value untouched) --%>
  <c:remove var="propName" scope="page"/>
  <c:remove var="fieldName" scope="page"/>
  <c:remove var="isDerivedPropSource" scope="page"/>
  <c:remove var="allowedValues" scope="page"/>
  <c:remove var="rowHidden" scope="page"/>
  <c:remove var="fieldTextValue" scope="page"/>
  <c:remove var="fieldChecked" scope="page"/>

  <c:set var="propName" value="${property.name}"/>
  <c:set var="fieldName" value="property:${property.name}"/>

  <%-- is a property which other props will be derived from --%>
  <c:set var="isDerivedPropSource" value="${true}"/><%--  TODO --%>

  <%-- for select and multi-select elements only --%>
  <c:set var="allowedValues" value="${propertyName2State[propName].allowedValues != null ? propertyName2State[propName].allowedValues : property.allowedValues}"/>

  <%-- for text-based elements only --%>
  <%-- start with the derived state or the default template value --%>
  <c:set var="fieldTextValue" value="${!empty propertyName2State[propName].value ? propertyName2State[propName].value : property.value}"/>
  <%-- if the configuration exists, use the configured value --%>
  <c:set var="fieldTextValue" value="${isNew ? fieldTextValue : configuredPropertyValueMap[propName]}"/>
  <%-- if a value was submitted, use that --%>
  <c:set var="fieldTextValue" value="${!empty prop2SelectedValue[propName] ? prop2SelectedValue[propName] : fieldTextValue}"/>
  <%-- if we have no value and the property is required, go back to the default --%>
  <c:set var="fieldTextValue" value="${(empty fieldTextValue && property.required) ? property.value : fieldTextValue}"/>
  <c:if test="${property.interfaceType.multiSelect}">
    <c:set var="fieldTextValue" value="${fn:split(fieldTextValue, ',')}"/>
  </c:if>

  <%-- ROW --%>
  <c:set var="rowHidden" value="${(property.interfaceType.multiValued && empty allowedValues)
                                  || (property.interfaceType.text && propertyName2State[propName] == null)
                                  || (property.interfaceType.textArea && propertyName2State[propName] == null)
                                  || (property.interfaceType.checkbox && propertyName2State[propName] == null)}"/>
  <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
  <tr class="${eo.last} ${isDerivedPropSource ? ' derivedSourceProperty' : ''}" valign="top" <c:if test="${rowHidden}">style="display:none;"</c:if>>
    <td>
      <%--
        Script tags can not appear as children of tbody/table elements, so include it in the tr[0]td[0]
      --%>
      <c:if test="${propLoopStatus.first}">
        <%-- NOT HANDLING DERIVED PROPERTIES RIGHT NOW
        <script type="text/javascript">
          var propList = {};
          propList["${propName}"] = {};
          propList["${propName}"].name = "${propName}";
          propList["${propName}"].type = "${property.interfaceType.name}";
        </script>
        <script type="text/javascript">
          /* <![CDATA[ */
          // set up event listeners for the forms
          document.observe("dom:loaded", function() { // no need to put in the header, no JS i18n used
            $$('form').each(function(form){  new UC_WORKFLOW_PROPS(form); });
          });
          /* ]]> */
        </script>
        --%>
      </c:if>
      <span class="bold">
        <c:choose>
          <c:when test="${not empty property.label}">
            ${ub:i18nMessage('NounWithColon', ub:i18n(property.label))}
          </c:when>
          <c:otherwise>
            ${ub:i18nMessage('NounWithColon', property.name)}
          </c:otherwise>
        </c:choose>
        <c:if test="${property.required}">&nbsp;<span class="required-text">*</span></c:if>
      </span>
      <c:if test="${!property.interfaceType.textSecure}">
          <ucf:hidden name="default:${fieldName}" value="${property.value}"/>
      </c:if>
    </td>
    <c:choose>
      <c:when test="${property.interfaceType.text}">
        <td id="${fieldName}">
           <ucf:text name="${fieldName}" value="${fieldTextValue}" required="${property.required}" enabled="${inEditMode}"/>
        </td>
        <td><c:out value="${property.description}"/></td>
      </c:when>
      <c:when test="${property.interfaceType.textSecure}">
        <td id="${fieldName}">
          <ucf:password name="${fieldName}" value="${fieldTextValue}" required="${property.required}" enabled="${inEditMode}" autoconfirm="true"/>
        </td>
        <td><c:out value="${property.description}"/></td>
      </c:when>
      <c:when test="${property.interfaceType.textArea}">
        <td colspan="2" id="${fieldName}">
          <c:if test="${not empty property.description}">
            <c:out value="${property.description}"/><br/>
          </c:if>
          <ucf:textarea name="${fieldName}" value="${fieldTextValue}" required="${property.required}" rows="4" cols="40" enabled="${inEditMode}"/>
        </td>
      </c:when>
      <c:when test="${property.interfaceType.checkbox}">
        <td id="${fieldName}">
          <ucf:checkbox name="${fieldName}" value="true" checked="${fieldTextValue}" enabled="${inEditMode}"/>
        </td>
        <td><c:out value="${property.description}"/></td>
      </c:when>
      <c:when test="${property.interfaceType.select || property.interfaceType.multiSelect}">
        <td id="${fieldName}">
          <ucf:stringSelector
            name="${fieldName}"
            list="${allowedValues}"
            selectedValue="${fieldTextValue}"
            canUnselect="${!property.required}"
            required="${property.required}"
            multiple="${property.interfaceType.multiSelect}"
            enabled="${inEditMode}"/>
        </td>
        <td><c:out value="${property.description}"/></td>
      </c:when>
      <c:when test="${property.interfaceType.integrationPlugin}">
        <%
            PropertyTemplate property = (PropertyTemplate) jspContext.getAttribute("property");
            UUID pluginId = UUID.fromString(property.getPluginType());
            AutomationPlugin plugin = (AutomationPlugin) PluginFactory.getInstance().getPluginForId(pluginId);
            PropSheetDef propSheetDef = plugin.getAutomationPropSheetDef();
            jspContext.setAttribute("propertyGroupList", propSheetDef.getPropSheetList());
        %>
        <td id="${fieldName}">
          <ucf:idSelector name="${fieldName}"
                          list="${propertyGroupList}"
                          selectedId="${fieldTextValue}"
                          canUnselect="${!property.required}"
                          enabled="${inEditMode}"/>
        </td>
        <td><c:out value="${property.description}"/></td>
      </c:when>
      <c:when test="${property.interfaceType.agentPool}">
        <%
          AgentPool[] agentPools = AgentPoolFactory.getInstance().restoreAll();
          List<String> list = new ArrayList<String>();
          for (AgentPool pool : agentPools) {
              list.add(pool.getName());
          }
          jspContext.setAttribute("agentPoolList", list);
        %>
        <td id="${fieldName}">
          <ucf:stringSelector
            name="${fieldName}"
            list="${agentPoolList}"
            selectedValue="${fieldTextValue}"
            canUnselect="${!property.required}"
            required="${property.required}"
            enabled="${inEditMode}"/>
        </td>
        <td><c:out value="${property.description}"/></td>
      </c:when>
    </c:choose>
  </tr>
</c:forEach>
