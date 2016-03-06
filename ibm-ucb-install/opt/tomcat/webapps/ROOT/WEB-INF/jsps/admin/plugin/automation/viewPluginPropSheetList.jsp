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
<%@page import="java.util.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="error" prefix="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.plugin.automation.AutomationPluginTasks" />

<c:url var="viewPluginListUrl" value="${AutomationPluginTasks.viewPluginList}">
  <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
</c:url>
<c:url var="iconDel"             value="/images/icon_delete.gif"/>
<c:url var="iconView"            value="/images/icon_magnifyglass.gif"/>
<c:url var="iconGearActiveUrl"   value="/images/icon_active.gif"/>
<c:url var="iconGearInactiveUrl" value="/images/icon_inactive.gif"/>


<%-- CONTENT --%>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemHeader')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${false}"/>
</jsp:include>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <a href="${fn:escapeXml(viewPluginListUrl)}" class="selected tab">${fn:escapeXml(plugin.name)}</a>
  </div>
  <div class="contents">

    <c:if test="${!empty saveMessage}">
      <div style="color: green; margin-bottom: 10px" id="saveMessage">${fn:escapeXml(saveMessage)}</div>
      <c:remove var="saveMessage" scope="session"/>
      <script type="text/javascript">
        /* <![CDATA[ */
        setTimeout('$("saveMessage").remove()', 5000); // remove save message after 5 seconds
        /* ]]> */
      </script>
    </c:if>

    <c:set var="description" value="${propSheetDef.description}"/>
    <c:if test="${empty description}">
      <c:set var="description" value="${plugin.description}"/>
    </c:if>
    <c:if test="${!empty description}">
      <div class="system-helpbox" style="margin-bottom: 1em">${fn:escapeXml(ub:i18n(description))}</div>
    </c:if>

    <div style="margin-bottom: 1em">
      <c:url var="newUrl" value='${AutomationPluginTasks.newPlugin}'>
        <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
      </c:url>
      <ucf:button name="Create New" label="${ub:i18n('CreateNewIntegration')}" href="${newUrl}"/>
    </div>

    <div class="data-table_container">
      <table class="data-table">
        <thead>
          <tr>
            <th scope="col">${ub:i18n("Name")}</th>
            <th scope="col" width="20%">${ub:i18n("Actions")}</th>
          </tr>
        </thead>
        <tbody>
          <c:if test="${empty propSheetList}">
            <tr><td colspan="2">${ub:i18nMessage("PluginPropSheetNoIntegerationMessage", fn:escapeXml(plugin.name))}</td></tr>
          </c:if>

          <c:forEach var="propSheet" items="${propSheetList}">
             <c:url var="viewUrl" value='${AutomationPluginTasks.viewPlugin}'>
               <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
               <c:param name="${WebConstants.PROP_SHEET_ID}" value="${propSheet.id}"/>
             </c:url>

             <c:url var="deleteUrl" value="${AutomationPluginTasks.deletePlugin}">
               <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
               <c:param name="${WebConstants.PROP_SHEET_ID}" value="${propSheet.id}"/>
             </c:url>


             <tr bgcolor="#ffffff">
               <td align="left" height="1">
                 <a href="${fn:escapeXml(viewUrl)}">${fn:escapeXml(propSheet.name)}</a>
               </td>

               <td style="text-align: center; white-space:nowrap" width="20%">
                 <ucf:link href="${viewUrl}" img="${iconView}" label="${ub:i18n('View')}"/>&nbsp;
                 <ucf:deletelink href="${deleteUrl}" name="${propSheet.name}" label="${ub:i18n('Delete')}" img="${iconDel}"/>
               </td>
             </tr>
           </c:forEach>
         </tbody>
       </table>
     </div>

     <div style="margin-top: 1em">
       <c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
       <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
     </div>

  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
