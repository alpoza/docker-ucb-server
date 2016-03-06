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

<%@taglib prefix="jwr" uri="http://jawr.net/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.radiator.RadiatorTasks" />

<c:url var="buildLifeUrl" value="/tasks/project/BuildLifeTasks/viewBuildLife?buildLifeId="/>
<c:url var="processUrl" value="/tasks/project/WorkflowTasks/viewDashboard?workflowId="/>
<!DOCTYPE html>
<html>
  <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
  <head>
    <c:url var="viewRadiatorUrl" value="${RadiatorTasks.viewRadiator}"/>
    <c:url var="baseUrl" value="/" />
    <c:set var="libUrl" value="${baseUrl}lib" />
    <c:set var="radiatorUrl" value="${baseUrl}radiator" />
    <script src="${libUrl}/es5-shim/es5-shim.min.js"></script>
    <script src="${libUrl}/es5-shim/es5-sham.min.js"></script>
    <script src="${libUrl}/jquery/jquery.min.js"></script>
    <script src="${libUrl}/jquery/jquery.ui.sortable.js"></script>
    <script src="${libUrl}/react/react.min.js"></script>
    <script src="${libUrl}/react-bootstrap/react-bootstrap.min.js"></script>
    <script src="${libUrl}/bootstrap/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="${libUrl}/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="${radiatorUrl}/radiator.css">

    <script type="text/javascript">
      var radiatorRestUrl = "/rest2/radiator";
      var viewRadiatorUrl = "${viewRadiatorUrl}";
      var buildLifeUrl = "${buildLifeUrl}";
      var processUrl = "${processUrl}";

      var showTimeSinceBuild = ${param.showTimeSinceBuild ? true : false};
      var failureCol = checkNum("${param.failureCol}");
      var runningCol = checkNum("${param.runningCol}");
      var successCol = checkNum("${param.successCol}");
      var abortedCol = checkNum("${param.abortedCol}");
      var urlProcessList = "${param.processList}";
      var sortOrder = "${param.sortOrder}";
      var currentUser = "${user}";
      // add check for positive integer
      function checkNum(input){
        var result = parseInt(input);
        if (isNaN(result) || result <= 0) {
          result = 4;
        }
        return result;
      }
    </script>

    <script type="text/javascript" src="${radiatorUrl}/StepInfo.js"></script>
    <script type="text/javascript" src="${radiatorUrl}/Process.js"></script>
    <script type="text/javascript" src="${radiatorUrl}/Selector.js"></script>
    <script type="text/javascript" src="${radiatorUrl}/Checkbox.js"></script>
    <script type="text/javascript" src="${radiatorUrl}/AddRemoveProcess.js"></script>
    <script type="text/javascript" src="${radiatorUrl}/Settings.js"></script>
    <script type="text/javascript" src="${radiatorUrl}/Radiator.js"></script>
    <script type="text/javascript" src="${radiatorUrl}/SortOrder.js"></script>

    <c:set var="onDocumentLoad" scope="request">renderRadiator();</c:set>
    <jsp:include page="/WEB-INF/snippets/dojo.jsp"/>
  </head>
  <body>
    <div id="radiator"></div>
  </body>
</html>
