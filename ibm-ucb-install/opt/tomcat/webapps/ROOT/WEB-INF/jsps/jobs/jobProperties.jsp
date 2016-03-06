<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>

<%@ page import="com.urbancode.ubuild.web.util.*"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.JobTrace" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<%-- CONTENT --%>
<jsp:useBean id="eo" class="com.urbancode.ubuild.web.util.EvenOdd"/>

<%
    JobTrace jobTrace = (JobTrace) pageContext.findAttribute(WebConstants.JOB_TRACE);
%>

<table class="data-table">
    <caption>${ub:i18n("Properties")}</caption>
    <tr>
        <th>${ub:i18n("Property")}</th>
        <th>${ub:i18n("Value")}</th>
    </tr>
    <tbody>
      <c:choose>
        <c:when test="${empty jobTrace.propertyNames}">
          <tr class="odd">
            <td colspan="3" align="left">${ub:i18n("NoJobProperties")}</td>
        </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="name" items="${jobTrace.propertyNames}" >
            <%
              String name = (String)pageContext.findAttribute("name");
              pageContext.setAttribute("displayValue", jobTrace.getPropertyValue(name).getDisplayedValue());
            %>
            <tr class="odd">
              <td nowrap="nowrap"><c:out value="${name}"/></td>
              <td>${fn:escapeXml(displayValue)}</td>
        </tr>
    </c:forEach>
        </c:otherwise>
     </c:choose>
    </tbody>
</table>