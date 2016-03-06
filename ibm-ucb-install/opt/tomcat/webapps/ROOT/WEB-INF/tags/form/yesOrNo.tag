<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>

<%--
  Syntax:
    <ucf:text name="name" value="value" enable="true">

  Output:
    <input type="text" name="name" value="value">
    <input type="text" name="name" value="value" disabled>
--%>

<%@tag import="com.urbancode.air.i18n.TranslateMessage" %>

<%@attribute name="name"     required="true"%>
<%@attribute name="value"    required="true"%>
<%@attribute name="checked"  required="false"  type="java.lang.Boolean"%>
<%@attribute name="enabled"  required="false"  type="java.lang.Boolean"%>
<%@attribute name="yesLabel" required="false" type="java.lang.String" %>
<%@attribute name="noLabel"  required="false"  type="java.lang.String" %>
<%@attribute name="yesClicked" required="false"%>
<%@attribute name="noClicked" required="false"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="xattribs" value=""/>
<c:set var="xattribsYes" value=""/>
<c:set var="xattribsNo" value=""/>

<c:if test="${!enabled && !empty enabled}">
  <c:set var="xattribs" value='${xattribs} disabled="disabled"'/>
</c:if>

<c:if test="${empty yesLabel}">
  <c:set var="yesLabel" value="${ub:i18n('Yes')}"/>
</c:if>

<c:if test="${empty noLabel}">
  <c:set var="noLabel" value="${ub:i18n('No')}"/>
</c:if>

<%-- detect which to have checked by default --%>
<c:choose>
  <c:when test="${value || checked}">
    <c:set var="xattribsYes" value='${xattribsYes} checked="checked"'/>
  </c:when>

  <c:otherwise>
    <c:set var="xattribsNo" value='${xattribsNo} checked="checked"'/>
  </c:otherwise>
</c:choose>


<c:if test="${empty name}">
  <% if (true) { throw new IllegalArgumentException(TranslateMessage.translate("NameAttributeCanNotBeEmpty")); }  %>
</c:if>
  
<input class="radio" type="radio" name="${fn:escapeXml(name)}" value="true" ${xattribsYes} ${xattribs} <c:if test="${!empty yesClicked}">onclick="${yesClicked}"</c:if>/> ${fn:escapeXml(yesLabel)}<br/>
<input class="radio" type="radio" name="${fn:escapeXml(name)}" value="false" ${xattribsNo} ${xattribs} <c:if test="${!empty noClicked}">onclick="${noClicked}"</c:if>/> ${fn:escapeXml(noLabel)}
