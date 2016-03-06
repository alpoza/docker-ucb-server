<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.admin.project.ImportExportTasks"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />

<jsp:include page="/WEB-INF/snippets/popupHeader.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemProjectList')}" />
  <jsp:param name="selected" value="system" />
</jsp:include>

<div style="padding-bottom: 1em;">
  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18n("Import")}</a></li>
    </ul>
  </div>
  <div class="contents">
    <div class="system-helpbox">${ub:i18n("ImportSystemHelpBox1")}<br/>
    <br/>
    ${ub:i18n("ImportSystemHelpBox2")}
    </div>
    <c:set var="hadWarn" value="false" scope="session"/>
    <jsp:include page="/WEB-INF/jsps/errors/processResult.jsp"/>
    <br/>
    <c:url var="xmlfileUploadUrl" value="${ImportExportTasks.doImport}"/>
    <form enctype='multipart/form-data' method='POST' action="${fn:escapeXml(xmlfileUploadUrl)}">
        <INPUT TYPE='FILE' NAME='xmlFileTemplate'>
        <br/><br/>${fn:toUpperCase(ub:i18n("Or"))}<br/><br/>
        <textarea name="<%=ImportExportTasks.XML_PARAMETER%>" rows="20" cols="80">${fn:escapeXml(requestScope.xml)}</textarea>
        <br/><br/>
        <div>
            <ucf:button name="Import" label="${ub:i18n('Import')}"/>
            <c:choose>
                <c:when test="${hadWarn}">
                    <ucf:button onclick="javascript:parent.hidePopupRefresh();" name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}"/>
                </c:when>
                <c:otherwise>
                    <ucf:button onclick="javascript:parent.hidePopup();" name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}"/>
                </c:otherwise>
            </c:choose>
        </div>
    </form>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/popupFooter.jsp"/>
