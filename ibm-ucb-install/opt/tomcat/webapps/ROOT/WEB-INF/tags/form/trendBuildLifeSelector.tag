<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@tag import="com.urbancode.ubuild.domain.status.StatusFactory"%>

<%@attribute name="sinceId"       required="true"  type="java.lang.Long"%>
<%@attribute name="buildLifeList" required="true"  type="java.util.List"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<select name="${fn:escapeXml(WebConstants.BUILD_LIFE_SINCE_ID)}">
  <c:forEach var="optionBuildLife" items="${buildLifeList}">
    <option value="${fn:escapeXml(optionBuildLife.id)}" <c:if test="${optionBuildLife.id eq sinceId}">selected</c:if>>
      <c:choose>
        <c:when test="${not empty optionBuildLife.latestStampValue}">${fn:escapeXml(optionBuildLife.latestStampValue)}</c:when>
        <c:otherwise>${optionBuildLife.id}</c:otherwise>
      </c:choose>
      <c:if test="${not empty optionBuildLife.latestStatusName}"> (${fn:escapeXml(optionBuildLife.latestStatusName)})</c:if>
    </option>
  </c:forEach>
</select>