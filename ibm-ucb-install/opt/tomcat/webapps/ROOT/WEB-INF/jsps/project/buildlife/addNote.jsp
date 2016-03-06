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
<%@ page import="com.urbancode.ubuild.dashboard.StampSummary"%>
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLifeStamp"%>
<%@ page import="com.urbancode.ubuild.domain.project.Project"%>
<%@ page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.*" %>
<%@ page import="com.urbancode.ubuild.web.project.BuildLifeTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.ProjectTasks"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="java.util.Date" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="addNoteUrl" value="${BuildLifeTasks.saveNote}"/>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>
  <form method="post" action="${fn:escapeXml(addNoteUrl)}">
    <div class="popup_header">
        <ul>
            <li class="current"><a>${ub:i18n("AddNote")}</a></li>
        </ul>
    </div>
    <div class="contents">
      <input type="HIDDEN" name="${fn:escapeXml(WebConstants.BUILD_LIFE_ID)}" value="${fn:escapeXml(buildLife.id)}">
      <ucf:textarea name="note" value="" cols="120" rows="10"/>
      <br/>
      <br/>
      <ucf:button name="AddNote" label="${ub:i18n('AddNote')}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="javascript:parent.hidePopup();"/>
    </div>
  </form>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
