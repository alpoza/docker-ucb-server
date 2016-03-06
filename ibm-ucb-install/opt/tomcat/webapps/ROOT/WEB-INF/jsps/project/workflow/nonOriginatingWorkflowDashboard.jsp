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

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<c:url var="secondaryProcessActivityRestUrl" value="/rest2/projects/${workflow.project.id}/secondaryProcesses/${workflow.id}/dashboardActivity"/>

<c:set var="onDocumentLoad" scope="request">
  renderRecentActivity();
</c:set>

<jsp:include page="/WEB-INF/snippets/react.jsp"/>
<c:import url="/WEB-INF/jsps/home/project/workflow/header.jsp">
  <c:param name="selected" value="dashboard"/>
</c:import>

<c:set var="dynamicRefreshCssUrl" value="/css/dynamicRefresh" />
<c:set var="dynamicRefreshJsUrl" value="/js/dynamicRefresh" />
<c:set var="dynamicRefreshProcessJsUrl" value="${dynamicRefreshJsUrl}/process" />
<link rel="stylesheet" href="${dynamicRefreshCssUrl}/dynamicRefresh.css">
<script type="text/javascript" src="${dynamicRefreshJsUrl}/Utils.js"></script>
<script type="text/javascript" src="${dynamicRefreshProcessJsUrl}/SecondaryProcessDashboard.js"></script>
<script type="text/javascript" src="${dynamicRefreshJsUrl}/RecentActivity.js"></script>

<script type="text/javascript">
  /* <![CDATA[ */
  var secondaryProcessActivityRestUrl = "${secondaryProcessActivityRestUrl}";
  var buildLifeUrl = "/tasks/project/BuildLifeTasks/viewBuildLife?buildLifeId=";
  var processUrl = "/tasks/project/WorkflowTasks/viewDashboard?workflowId=";
  var thisProcessId = ${workflow.id};
  /* ]]> */
</script>

<table border="0" style="width: 100%;">
  <tbody>
    <tr class="align-top">
      <td style="padding-bottom: 1em" class="align-top">
        <c:import url="/WEB-INF/jsps/project/workflow/nonOriginatingWorkflowActivity.jsp"/>
      </td>
    </tr>
  </tbody>
</table>

<c:import url="/WEB-INF/jsps/home/project/workflow/footer.jsp"/>
