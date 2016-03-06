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

<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.plugin.PluginTasks" useConversation="false"/>

<c:url var="doneUrl" value="${PluginTasks.viewPluginList}"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%
  pageContext.setAttribute("eo", new EvenOdd()); 
%>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemPlugin')}"/>
  <jsp:param name="selected" value="system"/>
</jsp:include>
   
  <div>
  
    <div class="tabManager" id="secondLevelTabs">
        <ucf:link label="${plugin.name}" href="#" enabled="${false}" klass="selected tab"/>
    </div>

    <div class="contents">


      <div class="system-helpbox">${ub:i18n("PluginViewSystemHelpBox")}</div>

      <br/>

      <%@ include file="pluginDetails.jsp" %>

      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>

    </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
