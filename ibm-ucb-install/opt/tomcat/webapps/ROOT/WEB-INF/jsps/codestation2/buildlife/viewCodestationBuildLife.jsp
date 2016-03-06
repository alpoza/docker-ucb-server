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
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.codestation2.domain.buildlife.CodestationBuildLife" %>
<%@ page import="com.urbancode.codestation2.domain.project.CodestationProject" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${taskClass}"/>
<ah3:useTasks class="${buildLifeTaskClass}"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:choose>
	<c:when test='${fn:escapeXml(mode) == "edit"}'>
	  <c:set var="inEditMode" value="true"/>
	</c:when>
	<c:otherwise>
	  <c:set var="inViewMode" value="true"/>
	  <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
	</c:otherwise>
</c:choose>

<c:if test="${view==null}">
  <c:set var="view" value="main"/>
</c:if>

<%
  CodestationBuildLife codestationBuildLife = (CodestationBuildLife)pageContext.findAttribute(WebConstants.CODESTATION_BUILD_LIFE);
  CodestationProject project = (CodestationProject) codestationBuildLife.getCodestationProject();
  boolean canWrite = Authority.getInstance().hasPermission(project, UBuildAction.CODESTATION_EDIT);
  pageContext.setAttribute("canWrite", new Boolean(canWrite));

  EvenOdd eo = new EvenOdd();
%>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="CodeStation: ${ub:i18n('Build')}"/>
  <jsp:param name="selected" value="codestation"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<c:import url="buildLifeTabs.jsp">
  <c:param name="disabled" value="${inEditMode}"/>
  <c:param name="selected" value="${view}"/>
</c:import>

      <c:import url="tab-${view}.jsp">
        <c:param name="enabled" value="${inViewMode}"/>
        <c:param name="canWrite" value="${canWrite}"/>
      </c:import>
    </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
