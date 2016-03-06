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

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<jsp:include page="/WEB-INF/jsps/admin/project/source/template/sourceConfigTemplateHeader.jsp">
  <jsp:param name="disabled" value="${inEditMode}"/>
  <jsp:param name="selected" value="properties"/>
</jsp:include>

<div class="system-helpbox" style="margin-bottom: 12px">${ub:i18n("SourceConfigPropertySystemHelpBox")}</div>

<c:if test="${!creatingProperty and empty sourceConfigTemplateProp}">
  <c:import url="property/propertyList.jsp"/>
</c:if>
  
<jsp:include page="/WEB-INF/jsps/admin/project/source/template/sourceConfigTemplateFooter.jsp"/>
