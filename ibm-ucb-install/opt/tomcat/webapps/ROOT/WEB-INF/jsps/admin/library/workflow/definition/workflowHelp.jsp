<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>

<%
EvenOdd eo = new EvenOdd();
pageContext.setAttribute( "eo", eo );
%>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>
<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

    <div class="popup_header">
        <ul>
            <li class="current">
                <a>
                    ${ub:i18n("LibraryWorkflowWorkflowHelpConfiguration")}
                </a>
            </li>
        </ul>
    </div>

    <div class="contents" style="padding: 15px;">

        <table class="data-table" cellspacing="0" cellpadding="0" width="100%">
            <col width="150px"/>
            <col width="300px"/>
            <tr>
                <th>${ub:i18n("LibraryWorkflowHelpMenuItem")}</th>
                <th>${ub:i18n("Description")}</th>
            </tr>
            <tr class="${fn:escapeXml(eo.next)}">
              <td><strong>${ub:i18n("Edit")}</strong></td>
              <td>${ub:i18n("LibraryWorkflowEditDesc")}</td>
            </tr>
            <tr class="${fn:escapeXml(eo.next)}">
                <td><strong>${ub:i18n("LibraryWorkflowInsertJobAfter")}</strong></td>
                <td>${ub:i18n("LibraryWorkflowInsertJobAfterDesc")}</td>
            </tr>
            <tr class="${fn:escapeXml(eo.next)}">
                <td><strong>${ub:i18n("LibraryWorkflowInsertJobBefore")}</strong></td>
                <td>${ub:i18n("LibraryWorkflowInsertJobBeforeDesc")}</td>
            </tr>
            <tr class="${fn:escapeXml(eo.next)}">
                <td><strong>${ub:i18n("LibraryWorkflowAddParallelJob")}</strong></td>
                <td>${ub:i18n("LibraryWorkflowAddParallelJobDesc")}</td>
            </tr>
            <tr class="${fn:escapeXml(eo.next)}">
                <td><strong>${ub:i18n("LibraryWorkflowIterateJob")}</strong></td>
                <td>${ub:i18n("LibraryWorkflowIterateJobDesc")}</td>
            </tr>
            <tr class="${fn:escapeXml(eo.next)}">
                <td><strong>${ub:i18n("LibraryWorkflowIterationProperties")}</strong></td>
                <td>${ub:i18n("LibraryWorkflowIterationPropertiesDesc")}</td>
            </tr>
            <tr class="${fn:escapeXml(eo.next)}">
                <td><strong>${ub:i18n("Delete")}</strong></td>
                <td>${ub:i18n("LibraryWorkflowDeleteDesc")}</td>
            </tr>
        </table>

        <br/><br/>
        <ucf:button name="Close" label="${ub:i18n('Close')}" onclick="window.parent.hidePopup();" submit="${false}"/>
    </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
