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

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="error" prefix="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.plugin.PluginTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconShieldUrl" value="/images/icon_shield.gif"/>

<c:set var="deleteUrlBase" value="${PluginTasks.deletePlugin}"/>
<c:set var="viewUrlBase" value="${PluginTasks.viewPlugin}"/>

<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemPluginList')}"/>
  <jsp:param name="selected" value="system"/>
</jsp:include>

<script type="text/javascript">
  /* <![CDATA[ */
  function refresh() {
     window.location.reload();
  }

  var PluginPage = {
    toggleButton: function (button, enable) {
       button = $(button);
       if (enable) {
         button.enable().addClassName('button').removeClassName('buttondisabled');
       }
       else {
         button.disable().addClassName('buttondisabled').removeClassName('button')
       }
    }
  };
  /* ]]> */
</script>

<div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('Plugins')}" href="" enabled="${false}" klass="selected tab"/>
</div>
<div class="contents">

  <div class="system-helpbox" style="margin-bottom: 1em">
    ${ub:i18n("PluginSystemHelpBox")}
    &nbsp;${ub:i18n("PluginSystemHelpBoxInfo")}&nbsp;
    <c:url var="docUrl" value="/help"/>
    <ucf:link href="${docUrl}" label="${ub:i18n('PluginHere')}" target="_help"/>.
  </div>

  <c:if test="${not empty pluginConfirmation}">
    <div class="system-helpbox" style="margin-bottom: 1em; background-color: #C0F5D5;">
      <c:out value="${pluginConfirmation}"/>
    </div>
  </c:if>


  <c:if test="${!empty error}">
    <div style="margin-bottom: 1em" class="error">${fn:escapeXml(error)}</div>
    <c:remove var="error" scope="session"/>
  </c:if>

  <br/>

  <div style="margin-botton: 2em">
    <h3>${ub:i18n("PluginLoadAPlugin")}</h3>
    <c:url var="loadPluginUrl" value="${PluginTasks.loadPlugin}"/>
    <form action="${fn:escapeXml(loadPluginUrl)}" method="post" enctype='multipart/form-data'>
      <div>
        <input type="file" name="file" onchange="var t = $(this); PluginPage.toggleButton(t.next(), (t.value != null))"/>
        &nbsp;
        <ucf:button name="Load" label="${ub:i18n('Load')}" enabled="${false}"/>
      </div>
    </form>
  </div>
  <br/>

  <div class="data-table-container">
    <table class="data-table">
      <caption>${ub:i18n("PluginLoadedPlugins")}</caption>
      <thead>
        <tr class="data-table-head">
          <th scope="col" width="25%">${ub:i18n("Name")}</th>
          <th scope="col" width="05%">${ub:i18n("Version")}</th>
          <th scope="col" width="10%">${ub:i18n("Type")}</th>
          <th scope="col" width="45%">${ub:i18n("Description")}</th>
          <%--
          <th scope="col" width="05%">Active</th>
           --%>
          <th scope="col" width="10%">${ub:i18n("Actions")}</th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${empty pluginList}">
          <tr bgcolor="#ffffff">
            <td colspan="6">${ub:i18n("PluginNoneLoadedMessage")}</td>
          </tr>
        </c:if>
        <c:forEach var="tempPlugin" items="${pluginList}">
          <c:url var='viewUrlId' value="${viewUrlBase}"><c:param name="${WebConstants.PLUGIN_ID}" value="${tempPlugin.plugin.id}"/> </c:url>
          <c:url var='deleteUrlId' value="${deleteUrlBase}"><c:param name="${WebConstants.PLUGIN_ID}" value="${tempPlugin.plugin.id}"/> </c:url>

          <tr bgcolor="#ffffff">
            <td style="white-space:nowrap">
              <ucf:link href="${viewUrlId}" label="${ub:i18n(tempPlugin.plugin.name)}" enabled="${true}"/>
            </td>
            <td style="white-space:nowrap; text-align: center;">
              <c:out value="${tempPlugin.plugin.releaseVersion}"/>
            </td>
            <td style="white-space:nowrap; text-align: center;">
              <c:out value="${ub:i18n(tempPlugin.plugin.class.simpleName)}"/>
            </td>
            <td>${fn:escapeXml(ub:i18n(tempPlugin.plugin.description))}</td>
            <td align="center"  width="10%" style="white-space:nowrap">
              <%-- Check perms? --%>
              <ucf:link href="${viewUrlId}" label="${ub:i18n('View')}" img="${iconMagnifyGlassUrl}" enabled="${true}"/>
              &nbsp;<ucf:link href="${deleteUrlId}" label="${ub:i18n('Delete')}" img="${iconDeleteUrl}" enabled="${tempPlugin.canBeDeleted}"/>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <div style="margin-top: 1em">
    <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </div>

</div><!-- contents -->

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
