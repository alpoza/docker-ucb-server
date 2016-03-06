<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty"%>

<%@attribute name="name" required="true"%>
<%@attribute name="value" required="false"%>
<%@attribute name="renderNull" required="false" type="java.lang.Boolean"%>
<%@attribute name="id"      required="false" type="java.lang.String"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:if test="${empty value}">
  <c:set var="value" value="${requestScope[name]}" />
</c:if>
<c:if test="${empty value}">
  <c:set var="value" value="${param[name]}" />
</c:if>

<c:if test="${renderNull or !empty value}">
	<input type="hidden" <c:if test="${!empty id}">id="${id}"</c:if> name="${fn:escapeXml(name)}" value="${fn:escapeXml(value)}" />
</c:if>