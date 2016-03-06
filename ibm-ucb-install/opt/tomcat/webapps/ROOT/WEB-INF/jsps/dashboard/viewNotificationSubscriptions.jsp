<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.urbancode.ubuild.web.dashboard.UserProfileTasks"%>
<%@page import="com.urbancode.ubuild.domain.subscription.SubscriptionEventEnum"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
  pageContext.setAttribute("subscriptionEventJson", SubscriptionEventEnum.getJson().toString());
%>

<c:url var="notificationSubscriptionURL" value="/rest2/notificationSubscriptions"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('YourProfileSubscriptions')}" />
  <jsp:param name="selected" value="User Profile" />
</jsp:include>

<div style="padding-bottom: 1em;">
  <c:import url="/WEB-INF/jsps/dashboard/profileSubTabs.jsp">
    <c:param name="selected" value="subscriptions"/>
  </c:import>

  <div class="contents">
    <div id="userSubscriptions"></div>
    <script type="text/javascript">
      require(["ubuild/module/UBuildApp", "ubuild/NotificationSubscriptionEditor"], function(UBuildApp, NotificationSubscriptionEditor) {
        UBuildApp.util.i18nLoaded.then(function() {
          var editor = new NotificationSubscriptionEditor({
            projectNotificationSubscriptionsURL: '${notificationSubscriptionURL}',
            notificationSubscriptionURL: '${notificationSubscriptionURL}',
            subscriptionEventJson:${subscriptionEventJson}
          });
          editor.placeAt("userSubscriptions");
        });
      });
    </script>
  </div>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
