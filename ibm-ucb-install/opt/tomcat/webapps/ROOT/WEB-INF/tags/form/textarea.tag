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

<%@attribute name="name"     required="true"%>
<%@attribute name="value"    required="true"%>
<%@attribute name="enabled"  required="false" type="java.lang.Boolean"%>
<%@attribute name="cols"     required="false" type="java.lang.Integer"%>
<%@attribute name="rows"     required="false" type="java.lang.Integer"%>
<%@attribute name="id"       required="false" type="java.lang.String"%>
<%@attribute name="onChange" required="false"%>
<%@attribute name="required" required="false" type="java.lang.Boolean" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="enabled" value="${empty enabled || enabled}"/>

<c:if test="${empty cols}">
    <c:set var="cols" value="60"/>
</c:if>

<c:if test="${empty rows}">
    <c:set var="rows" value="5"/>
</c:if>

<c:if test="${empty name}">
  <% if (true) { throw new IllegalArgumentException(TranslateMessage.translate("NameAttributeCanNotBeEmpty")); } %>
</c:if>

<%-- build up space-separated list of css classes --%>
<c:set var="classes" value=""/>
<c:if test="${!enabled}">
  <c:set var="classes" value="${classes}${' '}inputdisabled"/>
</c:if>

<%-- CONTENT --%>

<textarea 
    class="${classes}"
    name="${fn:escapeXml(name)}" 
    cols="${fn:escapeXml(cols)}" 
    rows="${fn:escapeXml(rows)}" 
    <c:if test="${!empty id}">id="${id}"${' '}</c:if> 
    <c:if test="${!empty onChange}">onkeyup="if(this.value == this.defaultValue) return; ${onChange}; "${' '}</c:if>
    <c:if test="${!enabled}">disabled="disabled"${' '}</c:if>
  >${fn:escapeXml(value)}</textarea>

