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
<%@ taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.NewDashboardTasks"/>
<c:url var="basePluginContentUrl" value="${NewDashboardTasks.viewPluginContent}"/>
<c:url var="saveDashboardWidgetUrl" value="${NewDashboardTasks.saveDashboardWidget}"/>

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="selected" value="dashboard" />
</c:import>

<script type="text/javascript">
<!--
function saveDashboardWidget(formId) {
    var url = '${ah3:escapeJs(saveDashboardWidgetUrl)}';
    var form = $(formId);
    var formJson = form.serialize(true);
    new Ajax.Request(url,
      {
        'method': 'post',
        'parameters': formJson,
        'onSuccess': function(resp) {
          var response = resp.response;
          /*
          if (response.error) {
              for (i=0; i<response.error.fields.length; i++) {
                  console.log("ERROR: " + response.error.fields[i].message);
              }
          }
          console.log(response);
          console.log(response.message);
          */)
        },
        'onError': function(resp) {
            alert(i18n('DashboardWidgetSaveError'));
        }
      }
    );
}
//-->
</script>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${dashboard.name}" href="" enabled="${false}" klass="selected tab"/>
</div>

<br/>

<div style="text-align: right; padding-right: 5%;">
  <c:url var="viewUrl" value="${NewDashboardTasks.viewDashboard}">
    <c:param name="dashboardId" value="${dashboard.id}"/>
  </c:url>
  <ucf:button name="Done" label="${ub:i18n('Done')}" href="${viewUrl}"/>
</div>

<div class="dashboard clearfix">
  <c:forEach var="dashboardColumn" items="${dashboard.columns}">
    <div class="dashboard-column">
      <c:forEach var="dashboardWidget" items="${dashboardColumn.widgets}">
        <c:url var="deleteWidgetUrl" value="${NewDashboardTasks.deleteDashboardWidget}">
          <c:param name="dashboardId" value="${dashboard.id}"/>
          <c:param name="columnId" value="${dashboardColumn.id}"/>
          <c:param name="dashboardWidgetId" value="${dashboardWidget.id}"/>
        </c:url>
        <div class="dashboard-widget-header">
          <div class="dashboard-widget-header-content">
            <div style="float: right">
              <ucf:link href="left" label="${ub:i18n('Left')}"/>
              &nbsp;&nbsp;
              <ucf:link href="up" label="${ub:i18n('Up')}"/>
              &nbsp;&nbsp;
              <ucf:link href="down" label="${ub:i18n('Down')}"/>
              &nbsp;&nbsp;
              <ucf:link href="right" label="${ub:i18n('Right')}"/>
              &nbsp;&nbsp;
              <ucf:deletelink href="${deleteWidgetUrl}" name="${dashboardWidget.name}" label="${ub:i18n('Delete')}" img="/images/icon_delete.gif"/>
              &nbsp;&nbsp;
            </div>
            ${dashboardWidget.name}
          </div>
        </div>
        <div class="dashboard-widget clearfix">
          <c:set var="propSheetDef" value="${dashboardWidget.plugin.dashboardPropSheetDef}"/>
          <c:set var="propSheet" value="${dashboardWidget.propSheet}"/>
          <form id="${fn:escapeXml(dashboardWidget.id)}" method="POST">
            <ucf:hidden name="dashboardWidgetId" value="${dashboardWidget.id}"/>
            <table class="property-table">
              <tr>
                <td width="20%"><label>${ub:i18n("Plugin")}</label></td>
                <td colspan="2">${fn:escapeXml(dashboardWidget.plugin.name)}</td>
              </tr>
              <tr>
                <td width="20%"><label>${ub:i18n("NameWithColon")}</label></td>
                <td colspan="2"><ucf:text name="name" value="${dashboardWidget.name}"/></td>
              </tr>
              <c:forEach var="propDef" items="${propSheetDef.propDefList}">
                <tr>
                  <td width="20%">
                    <label>
                      <c:choose>
                        <c:when test="${not empty propDef.label}">
                          ${ub:i18nMessage('NounWithColon', ub:i18n(propDef.label))}
                        </c:when>
                        <c:otherwise>
                          ${ub:i18nMessage('NounWithColon', propDef.name)}
                        </c:otherwise>
                      </c:choose>
                      <c:if test="${propDef.required}"><span class="required">*</span></c:if>
                    </label>
                  </td>
                  <td>
                    <ucf:propertyDefinitionField
                        customValue="${propSheet.propMap[propDef.name]}"
                        propertyDefinition="${propDef}"/>
                  </td>
                  <td>${fn:escapeXml(propDef.description)}</td>
                </tr>
              </c:forEach>
              <tr>
                <td>&nbsp;</td>
                <td colspan="2"><ucf:button name="Save" label="${ub:i18n('Save')}" submit="${false}"
                    onclick="saveDashboardWidget('${ah3:escapeJs(dashboardWidget.id)}'); return false;"/></td>
              </tr>
            </table>
          </form>
        </div>
      </c:forEach>
      <br/>
      <div style="text-align: center;">
        <c:url var="newWidgetUrl" value="${NewDashboardTasks.newDashboardWidget}">
          <c:param name="dashboardId" value="${dashboard.id}"/>
          <c:param name="columnId" value="${dashboardColumn.id}"/>
        </c:url>
        <ucf:button name="AddWidget" label="${ub:i18n('AddWidget')}" href="${newWidgetUrl}"/>
      </div>
    </div>
  </c:forEach>
</div>

<c:import url="/WEB-INF/snippets/footer.jsp"/>
