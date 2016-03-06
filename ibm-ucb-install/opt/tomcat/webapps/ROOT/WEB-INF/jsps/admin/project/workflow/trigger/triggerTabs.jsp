<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="mainClass"         value="disabled"/>
    <c:set var="agentFiltersClass" value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'main'}">
    <c:set var="mainClass" value="current"/>
  </c:when>

  <c:when test="${param.selected == 'agentFilter'}">
    <c:set var="agentFiltersClass" value="current"/>
  </c:when>
</c:choose>


<c:choose>
  <c:when test="${param.disabled}">
  </c:when>

  <c:otherwise>
  </c:otherwise>
</c:choose>
