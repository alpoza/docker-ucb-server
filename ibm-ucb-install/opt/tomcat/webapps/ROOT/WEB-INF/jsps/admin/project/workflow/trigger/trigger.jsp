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

<%@page import="com.urbancode.ubuild.domain.trigger.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.scheduled.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.postprocess.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.scheduled.workflow.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.remoterequest.repository.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.remoterequest.repository.workflow.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="error" prefix="error" %>

  <br/>
  <a id="trigger"></a>
<%
  Trigger trigger = (Trigger)pageContext.findAttribute(WebConstants.TRIGGER);

  if (trigger instanceof ScheduledRunWorkflowTrigger) {%>
      <c:import url="trigger/scheduled/workflow/trigger.jsp"/><%
  }
  else if (trigger instanceof ScheduledTrigger) {%>
      <c:import url="trigger/scheduled/trigger.jsp"/><%
  }
  else if (trigger instanceof RepositoryRequestRunWorkflowTrigger) {%>
      <c:import url="trigger/remoterequest/repository/workflow/trigger.jsp"/><%
  }
  else if (trigger instanceof RepositoryRequestTrigger) {%>
      <c:import url="trigger/remoterequest/repository/trigger.jsp"/><%
  }
  else if (trigger instanceof PostProcessTrigger) {%>
      <c:import url="trigger/postprocess/trigger.jsp"/><%
  }
  else {%>
  <%
  }%>