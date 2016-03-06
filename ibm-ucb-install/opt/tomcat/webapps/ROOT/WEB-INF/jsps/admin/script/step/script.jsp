<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.script.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.script.step.StepPreConditionScriptTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.ubuild.runtime.scripting.ScriptEvaluator" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.script.step.StepPreConditionScriptTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="inEditMode" value="true"/>
<c:set var="textFieldAttributes" value=""/><%--normal attributes for text fields--%>

<c:url var="saveUrl"   value="${StepPreConditionScriptTasks.saveScript}"/>
<c:url var="cancelUrl" value="${StepPreConditionScriptTasks.cancelScript}"/>

<%
EvenOdd eo = new EvenOdd();
pageContext.setAttribute("eo",eo);
%>

<div align="right">
<span class="required-text">${ub:i18n("RequiredField")}</span>
</div>

<c:if test="${not empty script}">
  <div class="translatedName"><c:out value="${ub:i18n(script.name)}"/></div>
  <c:if test="${not empty script.description}">
    <div class="translatedDescription"><c:out value="${ub:i18n(script.description)}"/></div>
  </c:if>
</c:if>
<form id="scriptForm" method="post" action="${fn:escapeXml(saveUrl)}">
    <table class="property-table">
        <tbody>
            <error:field-error field="name" cssClass="${eo.next}"/>
            <tr class="${fn:escapeXml(eo.last)}" valign="top">
                <td align="left" width="15%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
                <td align="left" width="20%">
                    <ucf:text name="name" value="${script.name}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("ScriptNameDesc")}</span>
                </td>
            </tr>

            <error:field-error field="description" cssClass="${eo.next}"/>
            <tr class="${fn:escapeXml(eo.last)}" valign="top">
                <td align="left" width="15%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                <td align="left" colspan="2">
                  <ucf:textarea name="description" value="${script.description}" enabled="${inEditMode}"/>
                </td>
            </tr>

            <error:field-error field="${WebConstants.SCRIPT}" cssClass="${eo.next}"/>
            <tr class="${fn:escapeXml(eo.last)}" valign="top">
                <td align="left" width="15%"><span class="bold">${ub:i18n("ScriptWithColon")} <span class="required-text">*</span></span></td>
                <td align="left" colspan="2">
                    <span class="inlinehelp">
                        ${ub:i18n("ScriptFieldDesc")}
                    </span><br/>
                    <ucf:scriptarea   id="${WebConstants.SCRIPT}"
                    language="javascript"
                    name="${WebConstants.SCRIPT}"
                    value="${script.body}"
                    rows="20" cols="80"
                    enabled="${inEditMode}"/>
                </td>
            </tr>
        </tbody>
    </table>
    <br/>

    <ucf:button name="Save" label="${ub:i18n('Save')}"/>

    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
</form>
