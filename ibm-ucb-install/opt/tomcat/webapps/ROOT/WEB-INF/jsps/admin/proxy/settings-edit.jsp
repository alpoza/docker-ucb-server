<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.proxy.ProxySettingsTasks"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.integration.maven.MavenSettingsTasks" />
<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemMavenSettings')}" />
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<div>
    <div class="tabManager" id="secondLevelTabs">
        <ucf:link label="${ub:i18n('ProxySettings')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">
            ${ub:i18n("ProxySettingsSystemHelpBox")}
        </div>
        <br/>
        <div>
          <c:url var="mavenUrl" value="${MavenSettingsTasks.viewMavenSettings}"/>
          ${ub:i18n("Configure")} [<a href="${fn:escapeXml(mavenUrl)}">${ub:i18n("MavenIntegration")}</a>].
        </div>
        <br/>
        <jsp:include page="/WEB-INF/jsps/admin/proxy/proxy-list.jsp">
            <jsp:param name="disabled" value="${inEditMode}"/>
            <jsp:param name="listMode" value="enabled-mode"/>
            <jsp:param name="leaveFieldsetOpen" value="false"/>
        </jsp:include>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
