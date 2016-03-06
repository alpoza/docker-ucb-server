<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/admin/project/workflow/template/workflowTemplateHeader.jsp">
    <jsp:param name="selected" value="definition"/>
</jsp:include>

<div id="noteHolder" class="system-helpbox">${ub:i18n("LibraryWorkflowSystemHelpBox")}</div>

<br/>
<div>
    <jsp:include page="definition/workflowDefinition.jsp">
        <jsp:param name="mode" value="edit"/>
    </jsp:include>
</div>

<c:import url="/WEB-INF/snippets/footer.jsp"/>
