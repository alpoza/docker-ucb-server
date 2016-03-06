<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>

<%@tag import="com.urbancode.air.i18n.TranslateMessage" %>

<%@attribute name="name" required="true"%>
<%@attribute name="value" required="true"%>
<%@attribute name="id" required="false"%>
<%@attribute name="size" required="false" type="java.lang.Integer"%>
<%@attribute name="enabled" required="false" type="java.lang.Boolean"%>
<%@attribute name="required" required="false" type="java.lang.Boolean" %>
<%@attribute name="onChange" required="false"%>
<%@attribute name="onBlur" required="false"%>
<%@attribute name="style" required="false"%>
<%@attribute name="title" required="false"%>
<%@attribute name="cssClass" required="false" type="java.lang.String"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:if test="${empty size}">
  <c:set var="size" value="30"/>
</c:if>

<c:set var="enabled" value="${empty enabled || enabled}"/>

<c:if test="${empty name}">
  <% if (true) throw new IllegalArgumentException(TranslateMessage.translate("NameAttributeCanNotBeEmpty")); %>
</c:if>

<%-- build up space-separated list of css classes --%>

<c:set var="classes" value="${cssClass}"/>

<c:if test="${!enabled}">
  <c:set var="classes" value="${classes}${' '}inputdisabled"/>
</c:if>

<%-- CONTENT --%>

<input type="text"
    <c:if test="${!empty onChange}">onchange="${onChange}"${' '}</c:if>
    <c:if test="${!empty onBlur}">onblur="${onBlur}"${' '}</c:if>
    <c:if test="${!empty id}">id="${fn:escapeXml(id)}"${' '}</c:if>
    name="${fn:escapeXml(name)}"
    value="${fn:escapeXml(value)}"
    size="${fn:escapeXml(size)}"
    class="${fn:escapeXml(classes)}"
    <c:if test="${!enabled}">${' '}disabled="disabled"</c:if>
    <c:if test="${!empty style}">style="${fn:escapeXml(style)}"</c:if>
    <c:if test="${!empty title}">title="${fn:escapeXml(title)}"</c:if>
  />

