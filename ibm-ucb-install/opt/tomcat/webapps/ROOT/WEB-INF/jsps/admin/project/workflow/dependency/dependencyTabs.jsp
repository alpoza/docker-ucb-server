<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.ubuild.domain.profile.*"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="mainClass"         value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'main'}">
    <c:set var="mainClass" value="current"/>
  </c:when>
</c:choose>

<c:url var="mainUrl" value='<%=new WorkflowTasks().methodUrl("viewDependency", false) %>'>
    <c:param name="workflowId" value="${workflow.id}"/>
    <c:param name="buildProfileDependencyId" value="${buildProfileDependency.id}"/>
</c:url>