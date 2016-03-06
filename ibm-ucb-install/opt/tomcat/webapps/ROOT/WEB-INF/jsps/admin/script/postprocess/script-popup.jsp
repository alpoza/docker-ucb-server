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
<%@page import="com.urbancode.ubuild.runtime.scripting.ScriptEvaluator" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.script.postprocess.PostProcessScriptTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="saveUrl"   value="${PostProcessScriptTasks.saveScriptPopup}"/>
<c:url var="cancelUrl" value="${PostProcessScriptTasks.cancelScriptPopup}"/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>


<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="popup_header">
    <ul>
      <li class="current"><a><c:out value="${script.name}" default="${ub:i18n('NewPostProcessingScript')}"/></a></li>
    </ul>
  </div>
  <div class="contents">
  <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>
    <c:if test="${not empty script}">
      <div class="translatedName"><c:out value="${ub:i18n(script.name)}"/></div>
      <c:if test="${not empty script.description}">
        <div class="translatedDescription"><c:out value="${ub:i18n(script.description)}"/></div>
      </c:if>
    </c:if>
    <form method="post" action="${fn:escapeXml(saveUrl)}" id="scriptForm">
      <table class="property-table">

        <tbody>
          <c:set var="fieldName" value="${WebConstants.NAME}"/>
          <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : script.name}"/>
          <error:field-error field="${WebConstants.NAME}" cssClass="${eo.next}"/>
          <tr class="${fn:escapeXml(eo.last)}" valign="top">
            <td align="left" width="15%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
            <td align="left" width="20%">
              <ucf:text name="${WebConstants.NAME}" value="${nameValue}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("ScriptNameDesc")}</span>
            </td>
          </tr>

          <c:set var="fieldName" value="description"/>
          <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : script.description}"/>
          <error:field-error field="description" cssClass="${eo.next}"/>
          <tr class="${fn:escapeXml(eo.last)}" valign="top">
            <td align="left" width="15%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
            <td align="left" colspan="2">
              <span class="inlinehelp">${ub:i18n("ScriptDescriptionDesc")}</span><br/>
              <ucf:textarea name="description" value="${descriptionValue}"/>
            </td>
          </tr>

          <c:set var="fieldName" value="${WebConstants.SCRIPT}"/>
          <c:set var="scriptValue" value="${param[fieldName] != null ? param[fieldName] : script.body}"/>
          <error:field-error field="${WebConstants.SCRIPT}" cssClass="${eo.next}"/>
          <tr class="${fn:escapeXml(eo.last)}" valign="top">
            <td align="left" width="15%"><span class="bold">${ub:i18n("ScriptWithColon")} <span class="required-text">*</span></span></td>
            <td align="left" colspan="2">
              <span class="inlinehelp">
                  ${ub:i18n("PostProcessScriptDesc")}
              </span><br/>
              <ucf:scriptarea   id="${WebConstants.SCRIPT}"
                                language="javascript"
                                name="${WebConstants.SCRIPT}"
                                value="${scriptValue}"
                                rows="20" cols="80"/>
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
