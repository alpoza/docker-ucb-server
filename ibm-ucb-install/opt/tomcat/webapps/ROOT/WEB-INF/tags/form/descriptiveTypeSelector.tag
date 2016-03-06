<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="error" prefix="error"%>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%@attribute name="name"     required="true"%>
<%@attribute name="list"     required="true"  type="java.lang.Object"%>
<%@attribute name="selectedValue" required="false" %>
<%@attribute name="enabled"  required="false" type="java.lang.Boolean"%>
<%@attribute name="rowClass"     required="false"%>
<%@attribute name="onclick"  required="false"%>

<c:choose>
  <c:when test="${enabled == null || enabled}">
    <c:set var="cssClass" value="button"/>
    <c:set var="disabled" value=""/>
  </c:when>

  <c:otherwise>
    <c:set var="cssClass" value="buttondisabled"/>
    <c:set var="disabled" value=" disabled='disabled'"/>
  </c:otherwise>
</c:choose>

<!-- selected = ${selectedValue} -->
<table class="radio-table" border="0" cellpadding="2" cellspacing="0">
  <error:field-error field="${name}"/>

  <c:forEach var="item" items="${list}">
    <!-- item type = ${item.type} -->
    <c:choose>
      <c:when test="${item.type.name == selectedValue}">
        <c:set var="checked" value="checked='checked'"/>
      </c:when>
  
      <c:otherwise>
        <c:set var="checked" value=""/>
      </c:otherwise>
    </c:choose>
    
    <c:remove scope="page" var="itemElemId"/>
    <c:set scope="page" var="itemElemId" value="${fn:replace(item.name, ' ', '_')}"/>
    
    <tr valign="top"<c:if test="${rowClass != null}"> class="${rowClass}"</c:if>>
      <td><input style="cursor: pointer;" id="radio-button-${fn:escapeXml(itemElemId)}" type="radio" class="radio" onclick="${onclick}" name="${fn:escapeXml(name)}" ${checked} value="${fn:escapeXml(item.type.name)}" ${disabled}/> </td>
      <td><label style="cursor: pointer;" for="radio-button-${fn:escapeXml(itemElemId)}">${fn:escapeXml(item.name)}</label></td>
      <td> ${fn:escapeXml(item.description)}</td>  
    </tr>
  </c:forEach>
  <!-- here -->
</table>
