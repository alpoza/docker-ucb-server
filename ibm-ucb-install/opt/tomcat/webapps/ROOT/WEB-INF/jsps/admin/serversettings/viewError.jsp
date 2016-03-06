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

<%@ page import="com.urbancode.ubuild.web.admin.serversettings.*" %>
<%@ page import="com.urbancode.ubuild.web.util.*" %>
<%@ page import="com.urbancode.commons.util.LocalNetworkResourceResolver"%>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input" %>
<%@taglib uri="error" prefix="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
<c:when test='${fn:escapeXml(mode) == "edit"}'>
<c:set var="inEditMode" value="true"/>
<c:set var="textFieldAttributes" value=""/><%--normal attributes for text fields--%>
</c:when>
<c:otherwise>
<c:set var="inViewMode" value="true"/>
<c:set var="textFieldAttributes" value="disabled class='inputdissabled'"/>
</c:otherwise>
</c:choose>

<c:url var="exportUrl" value="${ServerSettingsTasks.exportErrorLog}"/>

<% EvenOdd eo = new EvenOdd(); %>

<%-- CONTENT  --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
<jsp:param name="title" value="${ub:i18n('SystemEditServerSettings')}"/>
<jsp:param name="selected" value="system"/>
<jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<div style="padding-bottom: 1em;">
    <c:import url="tabs.jsp">
    <c:param name="selected" value="error"/>
    <c:param name="disabled" value="${inEditMode}"/>
    </c:import>
    <div class="contents">
        <br/><br/>
        <script type="text/javascript">
            function showErrorPage(page) {
                var request = '<%=new ServerSettingsTasks().methodUrl("viewError", false)%>';
                request = request + "?page=" + page;
                goTo(request);
            }
        </script>
        <ucui:carousel id="pagination" methodName="showErrorPage" currentPage="${page}" numberOfPages="${numPages}" numberShown="10" />
        <br/><ucf:link href="${exportUrl}" label="${ub:i18n('DownloadLog')}"/>
        <br/><br/>
        <pre style="border: solid 1px grey;">${fn:escapeXml(content)}</pre>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
