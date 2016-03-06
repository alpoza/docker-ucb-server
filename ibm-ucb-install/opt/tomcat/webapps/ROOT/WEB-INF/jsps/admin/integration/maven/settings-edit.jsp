<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.ubuild.domain.profile.DependencyTriggerType"%>
<%@page import="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettingsFactory"%>
<%@page import="com.urbancode.ubuild.web.admin.integration.maven.MavenSettingsTasks"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="error" prefix="error"%>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.integration.maven.MavenSettingsTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.proxy.ProxySettingsTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.restlet.maven.Maven2Constants" />

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:url var="editUrl" value="${MavenSettingsTasks.editMavenSettings}"/>
<c:url var="saveUrl" value="${MavenSettingsTasks.saveMavenSettings}"/>
<c:url var="doneUrl" value="${MavenSettingsTasks.viewMavenSettings}"/>
<c:url var="cancelUrl" value="${MavenSettingsTasks.viewMavenSettings}"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemMaven')}" />
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<%
  pageContext.setAttribute("eo", new EvenOdd());
  pageContext.setAttribute("serverSettings", ServerSettingsFactory.getInstance().restore());
  pageContext.setAttribute("NO_TRIGGER", DependencyTriggerType.UseExisting);
  pageContext.setAttribute("PUSH_BUILD", DependencyTriggerType.Push);
  pageContext.setAttribute("PULL_BUILD", DependencyTriggerType.Pull);
%>

<div>

  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('Maven')}" href="" enabled="${false}" klass="selected tab"/>
  </div>
  <div class="contents">
    <div class="system-helpbox">${ub:i18n("MavenSystemHelpBox")}</div>
    <div style="margin: 1em 0em;">
      <c:url var="viewProxySettingsUrl" value="${ProxySettingsTasks.viewProxySettings}"/>
      ${ub:i18n("Configure")}&nbsp;[<ucf:link href="${viewProxySettingsUrl}" label="${ub:i18n('Proxies')}"/>].
    </div>

    <br/>
    <hr/>
    <br/>
    
    <form method="post" action="${fn:escapeXml(saveUrl)}">

      <table class="property-table">
        <caption>${ub:i18n("MavenSettings")}</caption>
        <tbody>

          <tr class="${eo.next}">
            <td width="25%"><span class="bold">${ub:i18n("DependencyTriggerType")}</span></td>
            <td width="20%">
              <c:set var="mavenDepTriggerType" value="${serverSettings.mavenDependencyTriggerType}"/>
              <div style="margin-bottom: 5px;">
                <input type="radio" name="mavenDepTriggerType" value="${NO_TRIGGER.id}"
                  <c:if test="${mavenDepTriggerType eq NO_TRIGGER}">checked="checked"</c:if>
                  <c:if test="${inViewMode}">disabled="disabled"</c:if>
                  /> ${ub:i18n("NoTrigger")}
              </div>
              <div style="margin-bottom: 5px;">
                <input type="radio" name="mavenDepTriggerType" value="${PUSH_BUILD.id}"
                  <c:if test="${mavenDepTriggerType eq PUSH_BUILD}">checked="checked"</c:if>
                  <c:if test="${inViewMode}">disabled="disabled"</c:if>
                  /> ${ub:i18n("Push")}
              </div>
              <div>
                <input type="radio" name="mavenDepTriggerType" value="${PULL_BUILD.id}"
                  <c:if test="${mavenDepTriggerType eq PULL_BUILD}">checked="checked"</c:if>
                  <c:if test="${inViewMode}">disabled="disabled"</c:if>
                  /> ${ub:i18n("Pull")}
              </div>
            </td>
            <td><span class="inlinehelp">${ub:i18n("MavenTriggerTypeDesc")}</span></td>
          </tr>
          
        </tbody>
      </table>
          
      <c:choose>
        <c:when test="${inEditMode}">
          <div style="margin: 5px 0px;">
            <ucf:button name="Save" label="${ub:i18n('Save')}"/>
            <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
          </div>
        </c:when>
        <c:otherwise>
          <div style="margin: 5px 0px;">
            <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
          </div>
        </c:otherwise>
      </c:choose>
    
    </form>

    <br/>
    <hr/>
    <br/>
      
    <jsp:include page="/WEB-INF/jsps/admin/integration/maven/repository-list.jsp">
      <jsp:param name="disabled" value="${inEditMode}"/>
      <jsp:param name="listMode" value="enabled-mode"/>
      <jsp:param name="leaveFieldsetOpen" value="false"/>
    </jsp:include>
    
  </div>
  
</div>
  
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
