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

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.template.WorkflowTemplateTasks"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/admin/project/workflow/template/workflowTemplateHeader.jsp">
  <jsp:param name="selected" value="artifacts"/>
</jsp:include>

  <div class="system-helpbox">${ub:i18n("ProcessTemplateArtifactsSystemHelpBox")}</div>
  <br/>
  <c:import url="artifact/artifactList.jsp"></c:import>

  <br/>
  <br/>

  <c:if test="${inEditMode}">
    <c:import url="artifact/artifactConfig.jsp"></c:import>
  </c:if>
  <br/>
  
<jsp:include page="/WEB-INF/jsps/admin/project/workflow/template/workflowTemplateFooter.jsp"/>