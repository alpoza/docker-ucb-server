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

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.myactivity.MyActivityTasks" />
<c:url var="formUrl" value="${MyActivityTasks.viewMyWorkflowActivity}"/>
<c:set var="workflowId" value="${fn:escapeXml(workflow.id)}"/>
<c:url var="myActivityRestUrl" value="/rest2/myactivity/workflow/${workflowId}?pageIndex="/>

<jsp:include page="/WEB-INF/snippets/react.jsp"/>
<c:set var="onDocumentLoad" scope="request">renderMyActivity();</c:set>

<c:import url="/WEB-INF/jsps/home/project/workflow/header.jsp">
  <c:param name="selected" value="myActivity" />
</c:import>

<div class="contents">

  <form id="myActivityForm" action="${fn:escapeXml(formUrl)}" method="get">
    <input type="hidden" id="workflowId" name="workflowId" value="${workflowId}" />
    <c:import url="/WEB-INF/jsps/myactivity/requests.jsp">
      <c:param name="myActivityRestUrl" value="${myActivityRestUrl}"/>
    </c:import>
    <br/><br/>
  </form>
</div>

<c:import url="/WEB-INF/jsps/home/project/workflow/footer.jsp" />
