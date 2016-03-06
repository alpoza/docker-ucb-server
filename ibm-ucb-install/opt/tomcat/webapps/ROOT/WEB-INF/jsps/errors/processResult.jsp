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
<%@page import="com.urbancode.ubuild.exception.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<% 
  ProcessResultException exception = (ProcessResultException) pageContext.findAttribute(WebConstants.EXCEPTION);
  boolean hasWarn = false;
  if (exception != null) {
      pageContext.setAttribute("hasError", exception.hasError());
%>

<c:if test="${fn:length(exception.processResults) ne 0}">
  <c:choose>
    <c:when test="${hasError}">
      <c:set var="divClass" value="error"/>
    </c:when>
    <c:otherwise>
      <c:set var="divClass" value="warning"/>
    </c:otherwise>
  </c:choose>
  <div class="${divClass}">
    <% 
      if (!exception.hasError()) {
          hasWarn = true;
    %>
      ${ub:i18n("ImportWithWarnings")}<br/>
    <%
      }
      else {
    %>
      ${ub:i18n("ImportWithErrors")}<br/>
    <% } %>
    <ul>
    <c:forEach var="processResult" items="${exception.processResults}">
      <li>${fn:escapeXml(processResult.description)}</li>
    </c:forEach>
    </ul>
  </div>
</c:if>
<%
    session.removeAttribute(WebConstants.EXCEPTION);
  }
  
  Boolean att = (Boolean)request.getSession().getAttribute("hasWarn");
  if (att != null && att) {
      request.getSession().setAttribute("hadWarn", new Boolean(true));
      request.getSession().setAttribute("hasWarn", new Boolean(false));
  }
  
  if (hasWarn) {
      request.getSession().setAttribute("hasWarn", new Boolean(true));
      request.getSession().setAttribute("hadWarn", new Boolean(true));
  }
%>