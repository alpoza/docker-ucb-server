<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag import="com.urbancode.ubuild.web.WebConstants"%>

<%@attribute name="isActive" type="java.lang.Boolean"%>
<%@attribute name="message" type="java.lang.String"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${not isActive}">
  <div class="inactive-warning">
    <c:out value="${message}"/>
  </div>
</c:if>