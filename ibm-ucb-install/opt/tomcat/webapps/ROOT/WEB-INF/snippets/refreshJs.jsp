<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.refresh.RefreshTasks" />
<c:url var="pauseUrl" value="${RefreshTasks.pauseRefresh}"/>
<c:url var="unpauseUrl" value="${RefreshTasks.unpauseRefresh}"/>
<c:url var="enableUrl" value="${RefreshTasks.enableRefresh}"/>
<c:url var="disableUrl" value="${RefreshTasks.disableRefresh}"/>
var screenRefresh = new ScreenRefresh( 
    <c:choose>
        <c:when test="${sessionScope.refreshEnabled}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>, 
    <c:choose>
        <c:when test="${sessionScope.refreshPaused}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>,
    30,
    '${ah3:escapeJs(pauseUrl)}',
    '${ah3:escapeJs(unpauseUrl)}',
    '${ah3:escapeJs(enableUrl)}',
    '${ah3:escapeJs(disableUrl)}'
);