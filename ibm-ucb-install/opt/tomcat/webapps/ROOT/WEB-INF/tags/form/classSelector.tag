<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>

<%@attribute name="name"     required="true"%>
<%@attribute name="list"     required="true"  type="java.lang.Object"%>
<%@attribute name="selectedValue" required="false" %>
<%@attribute name="enabled"  required="false" type="java.lang.Boolean"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:choose>
  <c:when test="${enabled == null || enabled}">
    <c:set var="cssClass" value="input"/>
    <c:set var="disabled" value=""/>
  </c:when>

  <c:otherwise>
    <c:set var="cssClass" value="inputdisabled"/>
    <c:set var="disabled" value=" disabled"/>
  </c:otherwise>
</c:choose>


<select class="${fn:escapeXml(cssClass)}" name="${fn:escapeXml(name)}"  ${disabled}>
  <%-- don't need a default if we're editing an existing task --%>
  <c:if test="${selectedValue == null or selectedValue == ''}">
    <option selected value="">--&nbsp;${ub:i18n("MakeSelection")}&nbsp;--</option>
  </c:if>

  <c:forEach var="class" items="${list}">
    <c:choose>
      <c:when test="${class == selectedValue}">
        <c:set var="selected" value="selected"/>
      </c:when>

      <c:otherwise>
        <c:set var="selected" value=""/>
      </c:otherwise>
    </c:choose>
    
    <c:set var="friendlyNameArray" value="${fn:split(class,'.')}"/>
    <c:forEach var="token" items="${friendlyNameArray}">
      <c:if test="${token!='class'}">
        <c:set var="friendlyName" value="${token}"/>
      </c:if>
    </c:forEach>

    <option ${selected} value="${fn:escapeXml(class)}">${fn:escapeXml(friendlyName)}</option>
  </c:forEach>
</select>