<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@attribute name="name" required="true"%>
<%@attribute name="value" required="false"%>
<%@attribute name="id" required="false"%>
<%@attribute name="checked" required="false"%>
<%@attribute name="onclick" required="false"%>
<%@attribute name="enabled" required="false" type="java.lang.Boolean"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="enabled" value="${empty enabled || enabled}"/>

<c:if test="${empty value}">
  <c:set var="value" value="true"/>
</c:if>

<c:choose>
  <c:when test="${empty name}">
    <span style="font-weight: bold; color:red">${fn:toUpperCase(ub:i18n("ErrorWithColon"))} ${fn:toUpperCase(ub:i18n("NameAttributeEmpty"))}</b>
  </c:when>
  
  <c:otherwise>
    <input type="checkbox" name="${fn:escapeXml(name)}" value="${fn:escapeXml(value)}" 
       <c:if test="${!empty onclick}">onclick="${onclick}"</c:if> 
       class="checkbox <c:if test="${!enabled}">inputdisabled</c:if>" 
       <c:if test="${checked}">checked="checked"</c:if>
       <c:if test="${!empty id}">id="${fn:escapeXml(id)}"</c:if>
       <c:if test="${!enabled}">disabled="disabled"</c:if>
     />
  </c:otherwise>
</c:choose>

