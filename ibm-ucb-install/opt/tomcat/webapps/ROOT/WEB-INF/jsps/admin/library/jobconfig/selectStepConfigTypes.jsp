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
<%@ page import="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks"%>
<%@page import="com.urbancode.ubuild.web.*"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@ page import="com.urbancode.ubuild.domain.step.StepConfig"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="cancelUrl" value="${LibraryJobConfigTasks.cancelStep}">
  <c:if test="${jobConfig.id != null}">
    <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}" />
  </c:if>
</c:url>
<c:url var="newStepUrl" value="${LibraryJobConfigTasks.newStep}"/>

<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("Steps")}</a></li>
  </ul>
</div>
<div class="contents">
  <form method="post" action="${fn:escapeXml(newStepUrl)}">

    <ucf:hidden name="${WebConstants.JOB_CONFIG_ID}" value="${jobConfig.id}"/>
    <ucf:hidden name="${WebConstants.STEP_INDEX}" value="${stepIndex}"/>

    <c:import url="/WEB-INF/snippets/admin/steps/snippet-select-stepconfig.jsp">
      <c:param name="cancelUrl" value="${cancelUrl}"/>
    </c:import>
  </form>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
