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
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error"%>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "prop-edit"}'>
      <c:set var="inEditMode" value="true"/>
      <c:set var="fieldAttributes" value=""/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<div class="tab-content">

  <div class="system-helpbox">${ub:i18n("CodeStationBuildLifePropertiesHelp")}</div>
  <br/>
  
  <c:import url="property/propertyList.jsp"></c:import>

  <br/>

  <c:if test="${param.canWrite && csBuildLifeProp != null}">
    <hr size="1"/>
    <c:import url="property/property.jsp"></c:import>
  </c:if>
  <br/>
</div>
