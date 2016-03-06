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
<%@attribute name="id"       required="false" %>
<%@attribute name="selectedValue" required="false" %>
<%@attribute name="unselectedText"  required="false" %>
<%@attribute name="enabled"  required="false" type="java.lang.Boolean"%>
<%@attribute name="canUnselect"  required="false" type="java.lang.Boolean"%>
<%@attribute name="defaultValue" required="false" %>

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

<c:if test="${empty selectedValue || selectedValue == null}">
    <c:set var="selectedValue" value="${defaultValue}"/>
</c:if>

<c:choose>
  <c:when test="${empty name}">
    <span style="font-weight: bold; color:red">${fn:toUpperCase(ub:i18n("ErrorWithColon"))} ${fn:toUpperCase(ub:i18n("NameAttributeEmpty"))}</span>
  </c:when>

  <c:otherwise>
    <select name="${fn:escapeXml(name)}" <c:if test="${not empty id}">id="${fn:escapeXml(id)}"</c:if> class="${fn:escapeXml(cssClass)}"${fn:escapeXml(disabled)}>
      <c:if test="${canUnselect || selectedValue == null}">
        <c:choose>
          <c:when test="${fn:length(unselectedText) > 0}">
            <option selected="selected" value="">${fn:escapeXml(unselectedText)}</option>
          </c:when>

          <c:otherwise>
            <option selected="selected" value="">--&nbsp;${ub:i18n("MakeSelection")}&nbsp;--</option>
          </c:otherwise>
        </c:choose>
      </c:if>

      <c:forEach var="item" items="${list}">
        <c:choose>
          <c:when test="${item == selectedValue}">
            <c:set var="selected" value="selected=\"selected\""/>
            <c:set var="foundValue" value="${foundValue || selected}" scope="page"/><%-- track if we have found the selectedValue --%>
          </c:when>

          <c:otherwise>
            <c:set var="selected" value=""/>
          </c:otherwise>
        </c:choose>
        <option ${fn:escapeXml(selected)} value="${fn:escapeXml(item)}">${ub:i18n(fn:escapeXml(item.name))}</option>
      </c:forEach>
    </select>
    
    <c:if test="${!foundSelected && selectedObject != null}">
      <span class="error">${ub:i18n("InvalidSelection")} ${ub:i18n(fn:escapeXml(selectedObject.name))}</span>
    </c:if>
  </c:otherwise>
</c:choose>
