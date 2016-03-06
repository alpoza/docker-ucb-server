<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html" %>
<%@ page pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="error" uri="error" %>
<%@ taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.NewDashboardTasks"/>
<c:url var="basePluginContentUrl" value="${NewDashboardTasks.viewPluginContent}"/>
<c:choose>
  <c:when test="${empty plugin}">
    <c:url var="saveDashboardWidgetUrl" value="${NewDashboardTasks.selectNewDashboardWidgetPlugin}"/>
  </c:when>
  <c:otherwise>
    <c:url var="saveDashboardWidgetUrl" value="${NewDashboardTasks.createDashboardWidget}"/>
  </c:otherwise>
</c:choose>
<c:url var="cancelUrl" value="${NewDashboardTasks.editView}">
  <c:param name="dashboardId" value="${dashboard.id}"/>
</c:url>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="selected" value="dashboard" />
</c:import>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('NewDashboardWidget')}" href="" enabled="${false}" klass="selected tab"/>
</div>

<div class="contents">
  <div class="system-helpbox">${ub:i18n("DashboardPluginDescHelp")}</div>

  <form method="post" action="${saveDashboardWidgetUrl}">
    <ucf:hidden name="columnId" value="${dashboardColumn.id}"/>
    <div class="required-text" style="text-align: right;">${ub:i18n("RequiredField")}</div>
    <table class="property-table">
      <tbody>
        <error:field-error field="pluginId"/>
        <tr>
          <td width="15%"><span class="label">${ub:i18n("Plugin")} <span class="required-text">*</span></span></td>
          <td>
            <c:choose>
              <c:when test="${not empty plugin}">
                <ucf:hidden name="pluginId" value="${plugin.id}"/>
                <c:out value="${plugin.name}"/>
              </c:when>
              <c:otherwise>
                <ucf:idSelector list="${dashboardPlugins}" name="pluginId" selectedId="${plugin.id}"/>
              </c:otherwise>
            </c:choose>
          </td>
          <td>&nbsp;</td>
        </tr>
        <c:if test="${not empty plugin}">
          <error:field-error field="name"/>
          <tr>
            <td width="15%"><span class="label">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
            <td><ucf:text name="name" value="${param.name}" /></td>
            <td>&nbsp;</td>
          </tr>

          <c:forEach var="propDef" items="${plugin.dashboardPropSheetDef.propDefList}">
            <c:if test="${not propDef.hidden}">
              <c:set var="type" value="${fn:toLowerCase(propDef.type)}"/>
              <c:set var="key" value="${propDef.name}"/>
              <c:set var="customValue" value="${empty propLookup[key] ? propDef.defaultValue : propLookup[key]}"/>

              <error:field-error field="property:${key}" cssClass="${eo.next}"/>
              <tr class="${eo.last}">
                <td style="width:20%">
                  <span class="bold">
                    <c:choose>
                      <c:when test="${not empty propDef.label}">
                        ${ub:i18nMessage('NounWithColon', ub:i18n(propDef.label))}
                      </c:when>
                      <c:otherwise>
                        ${ub:i18nMessage('NounWithColon', propDef.name)}
                      </c:otherwise>
                    </c:choose>
                    <c:if test="${propDef.required}">&nbsp;<span class="required-text">*</span></c:if>
                  </span>
                </td>
                <c:choose>
                  <c:when test="${type == 'textarea'}">
                    <td colspan="2">
                      <span class="inlinehelp">${fn:escapeXml(propDef.description)}</span><br/>
                      <ucf:propertyDefinitionField propertyDefinition="${propDef}" customValue="${customValue}" fieldPrefix="property"/>
                    </td>
                  </c:when>
                  <c:otherwise>
                    <td style="width:20%">
                      <ucf:propertyDefinitionField propertyDefinition="${propDef}" customValue="${customValue}" fieldPrefix="property"/>
                    </td>
                    <td><span class="inlinehelp">${fn:escapeXml(propDef.description)}</span></td>
                  </c:otherwise>
                </c:choose>
              </tr>

              <c:remove var="type"/>
              <c:remove var="key"/>
              <c:remove var="customValue"/>
            </c:if>
          </c:forEach>
        </c:if>
      </tbody>
    </table>
    <br/>
    <ucf:button name="Save" label="${ub:i18n('Save')}"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
  </form>
</div>

<c:import url="/WEB-INF/snippets/footer.jsp"/>
