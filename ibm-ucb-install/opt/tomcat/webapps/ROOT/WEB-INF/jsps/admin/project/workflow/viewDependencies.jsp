<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
      <c:set var="fieldAttributes" value=""/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<c:url var="selectDependencyProjectUrl"    value="${WorkflowTasks.selectDependencyProject}">
  <c:if test="${workflow.id != null}"><c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/></c:if>
</c:url>

<c:url var="viewListUrl"         value="${WorkflowTasks.viewDependencies}">
  <c:if test="${workflow.id != null}"><c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/></c:if>
</c:url>

<jsp:include page="/WEB-INF/jsps/home/project/workflow/header.jsp">
  <jsp:param name="selected" value="dependencies"/>
  <jsp:param name="showYuiMenu" value="true"/>
</jsp:include>

<div class="contents">
<div class="system-helpbox">${ub:i18n("DependencySystemHelpBox")}</div>

<br/>

<c:import url="dependency/dependencyMainConfig.jsp">
  <c:param name="enabled" value="${buildProfileDependency==null && show_project_list == null}"/>
</c:import>

<c:import url="dependency/dependencyList.jsp"/>

<c:choose>
  <c:when test="${buildProfileDependency!=null || show_project_list != null}">
    <br/>
  <br/>
  <c:import url="dependency/dependency.jsp"/>
  </c:when>
  <c:otherwise>
  </c:otherwise>
</c:choose>

<br/>
</div>

<jsp:include page="/WEB-INF/jsps/home/project/workflow/footer.jsp"/>
