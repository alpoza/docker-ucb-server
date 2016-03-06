<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />

<c:if test="${param.disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
    <c:set var="summaryClass"   value="disabled"/>
</c:if>

<c:choose> <%-- Overwrite the default class for the selected tab --%>
  <c:when test="${param.selected == 'summary'}">
    <c:set var="summaryClass" value="selected"/>
  </c:when>
</c:choose>

<c:url var="summaryUrl" value="${JobTasks.viewBuildSummary}">
  <c:param name="job_trace_id" value="${jobTrace.id}"/>
</c:url>

<ucf:link label="${ub:i18n('JobExecution')}" href="${summaryUrl}" klass="${fn:escapeXml(summaryClass)} tab"/>
