<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.announcements.UserAnnouncementFactory"%>
<%@page import="com.urbancode.ubuild.domain.announcements.UserAnnouncement"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildUser"%>
<%@page import="com.urbancode.ubuild.persistence.UnitOfWork" %>
<%@page import="com.urbancode.ubuild.web.rest.announcements.UserAnnouncementJSONRenderer"%>
<%@page import="com.urbancode.ubuild.web.admin.security.LoginTasks"%>

<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.LoginTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.UserAnnouncementTasks" />


<c:if test="${not param.hideAnnouncements}">
<%
    UserAnnouncement[] userAnnouncements = null;
    UBuildUser currentUser = (UBuildUser) session.getAttribute(LoginTasks.KEY_CURRENT_USER);
    if (currentUser != null && UnitOfWork.hasCurrent()) {
        userAnnouncements = UserAnnouncementFactory.getInstance().restoreAllForUser(currentUser);
    }
    if (userAnnouncements != null) {
        UserAnnouncementJSONRenderer announcementsRenderer = new UserAnnouncementJSONRenderer();
        pageContext.setAttribute("userAnnouncements", announcementsRenderer.toJSON(userAnnouncements));
    }
%>
</c:if>

<c:if test="${!empty userAnnouncements}">

  <script type="text/javascript">
    /* <![CDATA[ */
    function hideAnnouncement(id) {
      var url = "<c:url value='${UserAnnouncementTasks.saveUserAnnouncements}'/>";
      new Ajax.Request(url, {
        method: "post",
        parameters: {'seen':id, 'single':true},
        onSuccess:   function(resp)  { $("announcement-" + id).remove();},
        onFailure:   function(resp)  { alert('${ah3:escapeJs(ub:i18n("ErrorWithColon"))} ' + resp.status + ' - ' + resp.statusText); },
        onException: function(req,e) { alert(e.name + ": " + e.message); throw e;}
      });
    }

    var announcements = ${userAnnouncements};

    document.observe("dom:loaded", function() { // no need to put in the header, no JS i18n used
      var tabHolder = $$('.tabManager')[0]
      if (tabHolder) {
        var announcementHtml = "";
        for (index = 0; index < announcements.length; index++) {
          var announcement = announcements[index];
          if (!announcement.seen) {
            var id = announcement.id;
            var priority = announcement.priority;
            var createdTime = announcement.createdTime;
            var message = announcement.message;
            announcementHtml += '<div id="announcement-' + id + '" class="announcement-text-' + priority.toLowerCase() +
              ' announcement-' + priority.toLowerCase() + '">' + createdTime + ' - ' + message +
              '<div style="text-align: right;">' +
              '<a href="javascript:void(0);" onclick="hideAnnouncement(\'' + id + '\'); return false;">${ah3:escapeJs(ub:i18n("Hide"))}</a>' +
              '</div></div>'
          }
        }

        if (announcementHtml.length > 0) {
          announcementHtml = '<div id="announcements" style="width: 90%; margin-left: auto; margin-right: auto;">' + announcementHtml + '</div>';
        }
        tabHolder.insert({ after : announcementHtml });
      }
    });
    /* ]]> */
  </script>

</c:if>
