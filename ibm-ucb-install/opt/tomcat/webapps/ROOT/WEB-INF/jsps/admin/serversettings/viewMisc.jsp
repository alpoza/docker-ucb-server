<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.project.*"%>
<%@page import="com.urbancode.ubuild.domain.profile.*"%>
<%@page import="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettings"%>
<%@page import="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.commons.util.LocalNetworkResourceResolver"%>
<%@page import="com.urbancode.commons.xml.*"%>
<%@page import="com.urbancode.ubuild.domain.project.template.PreProcessType"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0"%>
<%@taglib prefix="error" uri="error"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" id="SSTasks" useConversation="false" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true" />
    <c:set var="textFieldAttributes" value="" />
    <%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true" />
    <c:set var="textFieldAttributes" value="disabled class='inputdissabled'" />
  </c:otherwise>
</c:choose>

<jsp:useBean id="server_settings" scope="request"
  type="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettings" />
<jsp:useBean id="logging_settings" scope="request" type="java.lang.String" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:url var="saveUrl" value="${ServerSettingsTasks.saveMiscServerSettings}" />
<c:url var="editUrl" value='${SSTasks.editMiscServerSettings}' />
<c:url var="cancelUrl" value="${ServerSettingsTasks.cancelMiscServerSettings}" />
<c:url var="doneUrl" value="${SystemTasks.viewIndex}" />

<%--  CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEditServerSettings')}" />
  <jsp:param name="selected" value="system" />
  <jsp:param name="disabled" value="${inEditMode}" />
</jsp:include>
<div style="padding-bottom: 1em;"><c:import url="tabs.jsp">
  <c:param name="selected" value="misc" />
  <c:param name="disabled" value="${inEditMode}" />
</c:import>
<div class="contents">
<div class="system-helpbox">${ub:i18n("SettingsMiscSystemHelpBox")}</div>
<br />
<div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
<input:form name="server-settings-form" bean="agent" method="post" action="${saveUrl}">
<%
    pageContext.setAttribute("eo", new EvenOdd());
%>
  <table class="property-table">
    <caption>${ub:i18n("BuildsWithColon")}</caption>
    <tbody>
      <error:field-error field="cacheTime" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscTriggerCacheWithColon")} <span
          class="required-text">*</span></span></td>
        <td align="left" width="20%"><input class="input" type="text" name="cacheTime"
          value="<%=server_settings.getRepositoryEventCacheTime()%>" ${textFieldAttributes} size="10" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsMiscTriggerCacheDesc")}</span></td>
      </tr>

      <error:field-error field="buildIfNoPriorSuccessfulBuilds" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscBuildWithColon")}</span></td>
        <td align="left" width="20%">
          <ucf:checkbox id="buildIfNoPriorSuccessfulBuilds"
                        name="buildIfNoPriorSuccessfulBuilds"
                        value="true"
                        checked="${server_settings.buildIfNoPriorSuccessfulBuilds}"
                        enabled="${inEditMode}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("SettingsMiscBuildDesc")}</span>
        </td>
      </tr>
    </tbody>
  </table>

  <br/><br/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
  pageContext.setAttribute("NO_TRIGGER", DependencyTriggerType.UseExisting);
  pageContext.setAttribute("PUSH_BUILD", DependencyTriggerType.Push);
  pageContext.setAttribute("PULL_BUILD", DependencyTriggerType.Pull);
%>
  <table class="property-table">
    <caption>${ub:i18n("CodeStation")} / ${ub:i18n("ArtifactsWithColon")}</caption>
    <tbody>
      <error:field-error field="digestAlgorithm" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscDigestAlgorithmWithColon")} </span></td>
        <td align="left" width="20%"><ucf:stringSelector name="digestAlgorithm"
          list="${server_settings.codestationDigestAlgorithmSelection}" selectedValue="${server_settings.codestationDigestAlgorithm}"
          canUnselect="true" enabled="${inEditMode}" /></td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsMiscDigestAlgorithmDesc")}</span></td>
      </tr>
    </tbody>
  </table>

  <br/><br/>

<%
    pageContext.setAttribute("eo", new EvenOdd());
%>
  <table class="property-table">
    <caption>${ub:i18n("DependenciesWithColon")}</caption>
    <tbody>
      <error:field-error field="dependencyConflictDetection" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscDependencyConflictsWithColon")} <span class="required-text">*</span></span></td>
        <td align="left" width="20%"><input type="radio" class="radio" name="dependencyConflictDetection"
          value="<%= ServerSettings.DEP_CONFLICT_DETECT_ALL %>"
          ${textFieldAttributes} <c:if test="${server_settings.dependencyConflictDetectionAll}">checked="true"</c:if>>
            ${fn:toUpperCase(ub:i18n("DetectAll"))}</input><br/>
        <input type="radio" class="radio" name="dependencyConflictDetection"
          value="<%= ServerSettings.DEP_CONFLICT_DETECT_RESOLVED %>"
          ${textFieldAttributes} <c:if test="${server_settings.dependencyConflictDetectionResolved}">checked="true"</c:if>>
            ${fn:toUpperCase(ub:i18n("DetectResolved"))}</input><br/>
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsMiscDependencyConflictsDesc")}<br/>
        </span></td>
      </tr>

      <error:field-error field="cascadePropsToDeps" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscCascadeWithColon")}</span></td>
        <td align="left" width="20%">
          <ucf:checkbox id="cascadePropsToDeps"
                        name="cascadePropsToDeps"
                        value="true"
                        checked="${server_settings.cascadingPropertiesToDependencies}"
                        enabled="${inEditMode}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("SettingsMiscCascadeDesc")}
         </span>
        </td>
      </tr>

      <error:field-error field="defaultDependencyType" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscDefaultDependencyWithColon")} <span class="required-text">*</span></span></td>
        <td align="left" width="20%">
          <%
            pageContext.setAttribute("depTypeValueList", DependencyTriggerType.values());
          %>
          <ucf:idSelector id="defaultDependencyType"
                        name="defaultDependencyType"
                        list="${depTypeValueList}"
                        selectedObject="${server_settings.defaultDependencyType}"
                        enabled="${inEditMode}"
                        canUnselect="false"
                        />
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("SettingsMiscDefaultDependencyDesc")}
         </span>
        </td>
      </tr>

      <error:field-error field="fileDepTriggerType" cssClass="${eo.next}"/>
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscFileDependency")}</span></td>
        <td align="left" width="20%">
          <div style="margin-bottom: 5px;">
            <input type="radio" name="fileDepTriggerType" value="${NO_TRIGGER.id}"
              <c:if test="${server_settings.fileDependencyTriggerType eq NO_TRIGGER}">checked="checked"</c:if>
              <c:if test="${inViewMode}">disabled="disabled"</c:if>
              /> ${ub:i18n("NoTrigger")}
          </div>
          <div style="margin-bottom: 5px;">
            <input type="radio" name="fileDepTriggerType" value="${PUSH_BUILD.id}"
              <c:if test="${server_settings.fileDependencyTriggerType eq PUSH_BUILD}">checked="checked"</c:if>
              <c:if test="${inViewMode}">disabled="disabled"</c:if>
              /> ${ub:i18n("Push")}
          </div>
          <div>
            <input type="radio" name="fileDepTriggerType" value="${PULL_BUILD.id}"
              <c:if test="${server_settings.fileDependencyTriggerType eq PULL_BUILD}">checked="checked"</c:if>
              <c:if test="${inViewMode}">disabled="disabled"</c:if>
              /> ${ub:i18n("Pull")}
          </div>
        </td>
        <td><span class="inlinehelp">${ub:i18n("SettingsMiscFileDependencyDesc")}</span></td>
      </tr>


      <error:field-error field="mergeManualBuilds" cssClass="${eo.next}"/>
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscMergeWithColon")}</span></td>
        <td align="left" width="20%">
          <ucf:checkbox  name="mergeManualBuilds" checked="${server_settings.mergingManualBuildRequests}" enabled="${inEditMode}" />
        </td>
        <td align="left">
         <span class="inlinehelp">${ub:i18n("SettingsMiscMergeDesc")}</span>
        </td>
      </tr>


    </tbody>
  </table>

  <br/><br/>

<%
    pageContext.setAttribute("eo", new EvenOdd());
%>

  <table class="property-table">
    <caption>${ub:i18n("Logging")}</caption>
    <tbody>

      <error:field-error field="logging" cssClass="${eo.next}" />
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("SettingsMiscLoggingLevel")} <span class="required-text">*</span></span></td>
        <td align="left" width="20%">
        <!--
        <input type="radio" class="radio" name="logging" value="ALL"
          ${textFieldAttributes} <%= "ALL".equals(logging_settings)?"checked":""%>>ALL</input><br/>
        <input type="radio" class="radio" name="logging" value="DEBUG"
          ${textFieldAttributes} <%= "DEBUG".equals(logging_settings)?"checked":""%>>DEBUG</input><br/>
           -->
        <input type="radio" class="radio" name="logging" value="INFO"
          ${textFieldAttributes} <%= "INFO".equals(logging_settings)?"checked":""%>>${fn:toUpperCase(ub:i18n("Info"))}</input><br/>
        <input type="radio" class="radio" name="logging" value="WARN"
          ${textFieldAttributes} <%= "WARN".equals(logging_settings)?"checked":""%>>${fn:toUpperCase(ub:i18n("Warn"))}</input><br/>
        <input type="radio" class="radio" name="logging" value="ERROR"
          ${textFieldAttributes} <%= "ERROR".equals(logging_settings)?"checked":""%>>${fn:toUpperCase(ub:i18n("Error"))}</input><br/>
          <!--
        <input type="radio" class="radio" name="logging" value="FATAL"
          ${textFieldAttributes} <%= "FATAL".equals(logging_settings)?"checked":""%>>FATAL</input><br/>
        <input type="radio" class="radio" name="logging" value="OFF"
          ${textFieldAttributes} <%= "OFF".equals(logging_settings)?"checked":""%>>OFF</input><br/>
           -->
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("SettingsMiscLoggingLevelDesc")}</span></td>
      </tr>

    </tbody>
  </table>

  <br/>
  <c:if test="${inEditMode}">
    <ucf:button name="saveServerSettings" label="${ub:i18n('Save')}"/>
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}" />
    <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}" />
  </c:if>
  <br/>
</input:form></div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp" />
