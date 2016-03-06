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
<%@attribute name="valueList"     required="true"  type="java.lang.Object"%>
<%@attribute name="selectedZone" required="false" type="java.util.TimeZone" %>
<%@attribute name="canUnselect" required="false" type="java.lang.Boolean" %>
<%@attribute name="enabled"  required="false" type="java.lang.Boolean"%>


<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="enabled" value="${empty enabled || enabled}"/>

<%-- build up space-separated list of css classes --%>
<c:set var="classes" value=""/>
<c:if test="${!enabled}">
  <c:set var="classes" value="${classes}${' '}inputdisabled"/>
</c:if>

<c:choose>
  <c:when test="${empty name}">
    <span style="font-weight: bold; color:red">${fn:toUpperCase(ub:i18n("ErrorWithColon"))} ${fn:toUpperCase(ub:i18n("NameAttributeEmpty"))}</b>
  </c:when>
  
  <c:otherwise>
    <select name="${name}" <c:if test="${!enabled}">disabled="disabled"</c:if> class="${classes}" >
      <c:choose>
        <c:when test="${canUnselect}">
          <option value="">-- ${ub:i18n("Default")} --</option>
        </c:when>
        <c:otherwise>
          <option value="">--&nbsp;${ub:i18n("MakeSelection")}&nbsp;--</option>
        </c:otherwise>
      </c:choose>
      <c:forEach var="item" items="${valueList}" varStatus="i">
        <c:set var="name" value="${!empty list[i.count-1] ? list[i.count-1] : item}"/>
        <option value="${fn:escapeXml(item.ID)}" <c:if test="${item.ID == selectedZone.ID}">selected="selected"</c:if> >
          <fmt:formatNumber type='number' pattern="+00.0;-00.0">${item.rawOffset div (60*60*1000)}</fmt:formatNumber> &nbsp;&nbsp; ${fn:escapeXml(name)}
        </option>
      </c:forEach>
    </select>
  </c:otherwise>
</c:choose>
