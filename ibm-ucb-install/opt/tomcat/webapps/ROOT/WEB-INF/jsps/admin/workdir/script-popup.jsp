<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>

<%@page import="com.urbancode.ubuild.domain.script.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.workdir.*" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.workdir.WorkDirScriptTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="saveUrl"   value="${WorkDirScriptTasks.saveWorkDirScriptPopup}"/>
<c:url var="cancelUrl" value="${WorkDirScriptTasks.cancelWorkDirScriptPopup}"/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>


<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <li class="current">
        <a><c:out value="${ub:i18n(workDirScript.name)}" default="${ub:i18n('NewWorkDirScript')}"/></a>
      </li>
    </ul>
  </div>
  <div class="contents">
    <c:if test="${not empty workDirScript}">
      <div class="translatedName"><c:out value="${ub:i18n(workDirScript.name)}"/></div>
      <c:if test="${not empty workDirScript.description}">
        <div class="translatedDescription"><c:out value="${ub:i18n(workDirScript.description)}"/></div>
      </c:if>
    </c:if>
    <form method="post" action="${fn:escapeXml(saveUrl)}">
      <ucf:hidden name="${WebConstants.WORK_DIR_SCRIPT_ID}" value="${workDirScript.id}"/>

      <table class="property-table">
        <td align="right" style="border-top :0px; vertical-align: bottom;" colspan="4">
          <span class="required-text">${ub:i18n("RequiredField")}</span>
        </td>
        <tbody>
        <c:set var="fieldName" value="${WebConstants.NAME}"/>
        <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : workDirScript.name}"/>
        <error:field-error field="${WebConstants.NAME}" cssClass="${eo.next}"/>
          <tr class="${fn:escapeXml(eo.last)}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
            <td align="left" width="20%">
              <ucf:text name="${WebConstants.NAME}" value="${nameValue}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ScriptNameDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="${WebConstants.DESCRIPTION}"/>
          <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : workDirScript.description}"/>
          <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="${eo.next}"/>
          <tr class="${fn:escapeXml(eo.last)}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
            <td align="left" colspan="2">
              <span class="inlinehelp">${ub:i18n("ScriptDescriptionDesc")}</span><br/>
              <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${descriptionValue}"/>
            </td>
          </tr>

          <c:set var="fieldName" value="${WebConstants.SCRIPT}"/>
          <c:set var="scriptValue" value="${param[fieldName] != null ? param[fieldName] : workDirScript.pathScript}"/>
          <error:field-error field="${WebConstants.SCRIPT}" cssClass="${eo.next}"/>
          <tr class="${fn:escapeXml(eo.last)}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("ScriptWithColon")} <span class="required-text">*</span></span></td>
            <td align="left" colspan="2">
              <span class="inlinehelp">${ub:i18n("WorkDirScriptDesc")}</span><br/>
              <ucf:textarea name="${WebConstants.SCRIPT}" value="${scriptValue}"/>
            </td>
          </tr>
        </tbody>
      </table>
      <br/>

      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>

    </form>
  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
