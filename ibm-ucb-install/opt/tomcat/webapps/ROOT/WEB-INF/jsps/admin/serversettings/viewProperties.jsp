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
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@ page import="com.urbancode.commons.util.LocalNetworkResourceResolver"%>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input" %>
<%@taglib uri="error" prefix="error" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerPropertiesTasks" />
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>
<c:url var="imgUrl" value="/images"/>
<c:url var="viewUrl" value="${ServerPropertiesTasks.viewProperties}"/>

<%-- CONTENT  --%>
<c:set var="onDocumentLoad" scope="request">
  new UC_CustomPropertyForm('integrationPropForm', {
      imgUrl: '${ah3:escapeJs(imgUrl)}'
  });
</c:set>
<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('SystemEditServerSettings')}"/>
  <c:param name="selected" value="system"/>
  <c:param name="disabled" value="${inEditMode}"/>
</c:import>

  <div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link href="${viewUrl}" label="${ub:i18n('Properties')}" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
      <br/>
      <c:import url="propertyList.jsp"></c:import>
    </div>
  </div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
