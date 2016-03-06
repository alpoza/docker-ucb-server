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

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />

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

<c:url var="backUrl" value='<%=new WorkflowTasks().methodUrl("viewTriggers", false)%>'>
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>

<c:url var="newUrl" value="${WorkflowTasks.newTrigger}">
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/home/project/workflow/header.jsp">
  <jsp:param name="selected" value="triggers"/>
</jsp:include>

<div class="contents">
<c:if test="${empty selectType && empty trigger}">
  <div class="system-helpbox">${ub:i18n("TriggerSystemHelpBox")}</div>
  <br/>
  <c:import url="trigger/triggerList.jsp">
    <c:param name="enabled" value="${inViewMode}"/>
  </c:import>

  <br/>
</c:if>

<c:choose>
  <c:when test="${selectType}">
    <jsp:include page="trigger/triggerTabs.jsp">
      <jsp:param name="selected" value="main"/>
    </jsp:include>
    <div class="tab-content">
      <form method="post" action="${fn:escapeXml(newUrl)}#trigger">
          <c:import url="trigger/triggerTypeSelector.jsp">
            <c:param name="enabled" value="${trigger==null}"/>
            <c:param name="backUrl" value="${backUrl}"/>
          </c:import>
      </form>
    </div>
  </c:when>
  <c:when test="${trigger!=null}">
    <div class="tab-content">
      <c:import url="trigger/trigger.jsp"></c:import>
    </div>
  </c:when>
</c:choose>
</div>

<jsp:include page="/WEB-INF/jsps/home/project/workflow/footer.jsp"/>
