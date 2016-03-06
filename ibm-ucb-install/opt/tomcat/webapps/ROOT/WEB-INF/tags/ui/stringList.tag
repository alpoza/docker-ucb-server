<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty"%>
<%@attribute name="list" required="true" type="java.lang.Object"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:forEach var="value" items="${list}" varStatus="i">
  <c:if test="${not i.first}">, </c:if>
  <c:out value="${ub:i18n(value)}"/>
</c:forEach>
