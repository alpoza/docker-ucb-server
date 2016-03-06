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

<ah3:useTasks class="com.urbancode.ubuild.web.changeset.ChangeSetTasks" />
<c:url var="formUrl" value="${ChangeSetTasks.viewProjectChangeSets}"/>

<c:import url="/WEB-INF/jsps/home/project/header.jsp">
   <c:param name="selected" value="changeSet"/>
</c:import>

<div class="contents">
  <form id="changeSetsForm" action="${fn:escapeXml(formUrl)}" method="get">
    <input type="hidden" id="projectId" name="projectId" value="${fn:escapeXml(project.id)}"/>
    <c:import url="/WEB-INF/jsps/changeset/changes.jsp" />
  </form>
</div>

<c:import url="/WEB-INF/jsps/home/project/footer.jsp" />
