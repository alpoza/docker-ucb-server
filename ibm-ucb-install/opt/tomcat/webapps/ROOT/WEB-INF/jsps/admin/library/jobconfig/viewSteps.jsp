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
<%@page import="com.urbancode.ubuild.web.*"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.ubuild.domain.step.StepConfig"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="step" tagdir="/WEB-INF/tags/ui/admin/step" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<%
  StepConfig stepConfig = (StepConfig) request.getAttribute(WebConstants.STEP_CONFIG);
  Class<? extends StepConfig> stepConfigClass = (Class<? extends StepConfig>) request.getAttribute(WebConstants.STEP_CONFIG_CLASS);
  if (stepConfigClass == null && stepConfig != null) {
      stepConfigClass = stepConfig.getClass();
  }
  SnippetBase snippet = StepConfigSnippetRegistry.getSnippet(stepConfigClass);
  pageContext.setAttribute("stepConfigClass", stepConfigClass.getName());
  pageContext.setAttribute("snippetJspPath", snippet.getSnippetJspPath());
%>

<c:url var="viewStepUrl" value="${LibraryJobConfigTasks.viewStep}">
  <c:if test="${jobConfig.id != null}">
    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
  </c:if>
  <c:if test="${stepConfig.id != null}">
    <c:param name="${WebConstants.STEP_CONFIG_ID}" value="${stepConfig.id}"/>
  </c:if>
</c:url>

<c:url var="viewMainUrl" value="${LibraryJobConfigTasks.viewMain}">
  <c:if test="${jobConfig.id != null}">
    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
  </c:if>
</c:url>

<c:url var="editStepUrl" value="${LibraryJobConfigTasks.editStep}">
  <c:if test="${jobConfig.id != null}">
    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
  </c:if>
  <c:if test="${stepConfig.id != null}">
    <c:param name="${WebConstants.STEP_CONFIG_ID}" value="${stepConfig.id}"/>
  </c:if>
</c:url>

<c:url var="cancelStepUrl" value="${LibraryJobConfigTasks.cancelStep}">
  <c:if test="${jobConfig.id != null}">
    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
  </c:if>
</c:url>

<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
  <ul>
    <li class="current"><a><step:displayName stepConfig="${stepConfig}" stepConfigClass="${stepConfigClass}" pluginCommand="${pluginCommand}"/></a></li>
  </ul>
</div>

<div class="contents">

  <c:url var="saveStepUrl" value="${LibraryJobConfigTasks.saveStep}" />

  <form id="snippetForm" name="snippetForm" method="post" action="${fn:escapeXml(saveStepUrl)}">
    <ucf:hidden name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
    <ucf:hidden name="${WebConstants.STEP_CONFIG_ID}" value="${stepConfig.id}"/>
    <ucf:hidden name="${WebConstants.STEP_CONFIG_CLASS}" value="${stepConfigClass}"/>
    <ucf:hidden name="${WebConstants.STEP_INDEX}" value="${stepIndex}"/>
    <div>
    <c:import url="${snippetJspPath}">
      <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}" />
      <c:param name="disabled" value="${!inEditMode}" />
      <c:param name="viewUrl" value="${viewStepUrl}" />
      <c:param name="editUrl" value="${editStepUrl}" />
      <c:param name="cancelUrl" value="${cancelStepUrl}" />
      <c:param name="backUrl" value="${viewMainUrl}" />
    </c:import>
    </div>
  </form>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
