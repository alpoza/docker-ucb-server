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
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>



<%-- CONTENT --%>
<jsp:include page="/WEB-INF/snippets/react.jsp"/>
<c:set var="onDocumentLoad" scope="request">renderCurrentActivityLockableResource();</c:set>

<c:import url="/WEB-INF/jsps/currentActivity/_header.jsp">
  <c:param name="selected" value="lockableResources" />
  <c:param name="disabled" value="${inEditMode}"/>
</c:import>
<script type="text/javascript">
    /* <![CDATA[ */
    var currentActivityLockableResourcesRestUrl = "/rest2/currentActivity/lockableResources";
    var baseWorkflowUrl = "/tasks/project/WorkflowCaseTasks/viewWorkflowCase?workflow_case_id=";
    /* ]]> */
</script>

<c:set var="dynamicRefreshCssUrl" value="/css/dynamicRefresh" />
<c:set var="dynamicRefreshJsUrl" value="/js/dynamicRefresh" />
<c:set var="dynamicRefreshCurrentActivityJsUrl" value="${dynamicRefreshJsUrl}/currentActivity" />
<link rel="stylesheet" href="${dynamicRefreshCssUrl}/dynamicRefresh.css">
<script type="text/javascript" src="${dynamicRefreshCurrentActivityJsUrl}/CurrentActivityLockableResources.js"></script>


<br/>
<br/>
<br/>


 <div id="lockableResourcesTable"> </div>


<jsp:include page="/WEB-INF/jsps/currentActivity/_footer.jsp"/>
