<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@attribute name="value" required="true"%>
<%@attribute name="alternate" required="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:choose>
  <c:when test="${empty value}">
    <c:out value="${alternate}"/>
  </c:when>
  <c:otherwise>
    <c:out value="${value}"/>
  </c:otherwise>
</c:choose>