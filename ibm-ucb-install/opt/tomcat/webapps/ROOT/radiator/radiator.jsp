<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.radiator.RadiatorTasks" />

<c:url var="viewRadiatorUrl" value="${RadiatorTasks.viewRadiator}"/>
<c:redirect url="${viewRadiatorUrl}"/>
