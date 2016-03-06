<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page import="com.urbancode.ubuild.dashboard.BuildLifeActivitySummary" %>
<%@ page import="com.urbancode.ubuild.dashboard.ActiveJobDetail" %>
<%@ page import="com.urbancode.ubuild.domain.agent.*" %>
<%@ page import="com.urbancode.ubuild.domain.jobtrace.JobTrace" %>
<%@ page import="com.urbancode.ubuild.domain.schedule.Schedule" %>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowCase" %>
<%@ page import="com.urbancode.ubuild.services.agent.*"%>
<%@ page import="com.urbancode.ubuild.services.lock.LockManagerService" %>
<%@ page import="com.urbancode.ubuild.web.dashboard.*" %>
<%@ page import="com.urbancode.ubuild.web.currentactivity.CurrentActivityTasks"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>

<%@ page import="org.apache.commons.lang3.StringUtils" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.jobs.JobTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.currentactivity.CurrentActivityTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imgUrl" value="/images"/>


<c:url var="revokeUrl" value="${CurrentActivityTasks.revokeAgentDirectory}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/react.jsp"/>
<c:set var="onDocumentLoad" scope="request">renderCurrentActivityAgents();</c:set>

<c:import url="/WEB-INF/jsps/currentActivity/_header.jsp">
  <c:param name="selected" value="agents" />
  <c:param name="disabled" value="${inEditMode}"/>
</c:import>
<br/>

<div id="configured-agents-paging" class="yui-skin-sam" style="float:right;padding-top:14px"></div>
<div id="configured-agents"></div>


<c:url var="formUrl" value="/tasks/currentactivity/CurrentActivityTasks/viewAgents"/>
<c:url var="agentsRestUrl" value="/rest2/agents?pageNum="/>
<c:url var="currentActivityAgentDirLockRestUrl" value="/rest2/currentActivity/agentDirLocks"/>

<script type="text/javascript">
    /* <![CDATA[ */
    var baseRevokeUrl = "${revokeUrl}";
    var baseJobTraceUrl = "/tasks/jobs/JobTasks/viewJobTrace?job_trace_id=";
    var baseWorkflowUrl = "/tasks/project/WorkflowCaseTasks/viewWorkflowCase?workflow_case_id=";
    var jobImgUrl = "/images/icon_job.gif";
    /* ]]> */
</script>

<div class="contents">

  <form id="currentActivityForm" action="${fn:escapeXml(formUrl)}" method="get">
    <c:import url="/WEB-INF/jsps/currentActivity/requests.jsp">
      <c:param name="agentsRestUrl" value="${agentsRestUrl}"/>
      <c:param name="currentActivityAgentDirLockRestUrl" value="${currentActivityAgentDirLockRestUrl}"/>
    </c:import>
    <br/><br/>
  </form>
</div>




<jsp:include page="/WEB-INF/jsps/currentActivity/_footer.jsp"/>
