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

<%@attribute name="name"         required="true" type="java.lang.String"%>

<%@attribute name="selectedId"     required="false" type="java.lang.Object"%><%-- must use object because Long gets a 0 when the value is null --%>
<%@attribute name="selectedObject" required="false" type="java.lang.Object"%><%-- items with getName and getId --%>
<%@attribute name="selectedList"   required="false" type="java.lang.Object"%><%-- list of seletedObjects --%>

<%@attribute name="excludedId"   required="false" type="java.lang.Long"%>
<%@attribute name="emptyMessage" required="false" type="java.lang.String"%>
<%@attribute name="canUnselect"  required="false" type="java.lang.Boolean"%>
<%@attribute name="enabled"      required="false" type="java.lang.Boolean"%>
<%@attribute name="multiple"     required="false" type="java.lang.Boolean"%>
<%@attribute name="size"		 required="false" type="java.lang.Long"%>
<%@attribute name="style" 		 required="false" type="java.lang.String"%>
<%@attribute name="cssClass" 	 required="false" type="java.lang.String"%>

<%@attribute name="id"           required="false" type="java.lang.String"%>
<%@attribute name="onChange"     required="false" type="java.lang.String"%>
<%@attribute name="optimizeOne"  required="false" type="java.lang.Boolean"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="enabled" value="${enabled == null || enabled}"/>
<c:if test="${empty emptyMessage}"><c:set var="emptyMessage" value="${canUnselect ? ub:i18n('None') : ub:i18n('MakeSelection')}"/></c:if>
<c:if test="${empty id}"><c:set var="id" value="${name}"/></c:if>

<c:if test="${selectedObject != null}"><c:set var="selectedId" value="${selectedObject.id}"/></c:if>

<%
  jspContext.setAttribute("list", StatusFactory.getInstance().restoreAll());
%>
<%-- CONTENT --%>


<c:choose>
  
  <%--::::::::::::::::::::::::::::::::::::::::: --%>
  <%-- Optimize as a Hidden input for 1 element --%>
  <%--::::::::::::::::::::::::::::::::::::::::: --%>
  
  <%-- we have list of 0 but we have a selectedObject --%>
  <c:when test="${optimizeOne && empty list && selectedObject != null}">
    <c:set var="item" value="${selectedObject}"/>
    <input type="hidden" class="input<c:if test="${!empty cssClass}"> ${cssClass}</c:if>" id="${fn:escapeXml(id)}" name="${fn:escapeXml(name)}" value="${fn:escapeXml(item.id)}"/>
    ${fn:escapeXml(item.name)}
  </c:when>
  
  <%-- we have list of 1 and selected item is null, OR list of 1 and that item is the selectedObject --%>
  <c:when test="${optimizeOne && fn:length(list) == 1 && ( selectedObject == null || list[0].id == selectedObject.id )}">
    <c:set var="item" value="${list[0]}"/>
    <input type="hidden" class="input<c:if test="${!empty cssClass}"> ${cssClass}</c:if>" id="${fn:escapeXml(id)}" name="${fn:escapeXml(name)}" value="${fn:escapeXml(item.id)}"/>
    ${fn:escapeXml(item.name)}
  </c:when>
  
  <%--::::::::::::::::::::::::::::::::::::::::: --%>
  <%-- Select input                             --%>
  <%--::::::::::::::::::::::::::::::::::::::::: --%>
  <c:otherwise>
    <select id="${fn:escapeXml(id)}" class="${enabled ? 'input' : 'inputdisabled'}<c:if test="${!empty cssClass}">${' '}${cssClass}</c:if>" name="${fn:escapeXml(name)}"  
        <c:if test="${!enabled}"> disabled="disabled"</c:if>
        <c:if test="${multiple}"> multiple="multiple"</c:if>
        <c:if test="${!empty onChange}"> onChange="${onChange}"</c:if>
        <c:if test="${!empty size}"> size="${size}"</c:if>
        <c:if test="${!empty style}"> style="${style}"</c:if>
      >
      
      <c:if test="${not multiple}">
        <option value="">-- ${fn:escapeXml(emptyMessage)} --</option>
      </c:if>

      <c:forEach var="item" items="${list}">
        <c:remove var="selected" scope="page"/>
        <c:choose>
          <c:when test="${!empty selectedList}">
            <c:forEach var="selectedItem" items="${selectedList}">
              <c:set var="selected" value="${selected || selectedItem.id == item.id}" scope="page"/>
            </c:forEach>
          </c:when>
          <c:when test="${not empty selectedId}">
            <c:set var="selected" value="${item.id == selectedId}" scope="page"/>
          </c:when>
          <c:when test="${selected != null}">
            <c:set var="selected" value="${item.id == selectedId}" scope="page"/>
          </c:when>
        </c:choose>

        <c:if test="${excludedId == null || excludedId != item.id}">
          <option <c:if test="${selected}">selected="selected"</c:if> value="${item.id}">${fn:escapeXml(item.name)}</option>
        </c:if>
        
        <c:set var="foundSelected" value="${foundSelected || selected}" scope="page"/>
      </c:forEach>
      
      <%-- if selected object was not in list, then add to end of select drop-down --%>
      <c:if test="${!foundSelected && selectedObject != null}">
        <option class="restrictedItem" style="font-style:italic;" selected="selected" value="${selectedObject.id}">${fn:escapeXml(selectedObject.name)}</option>
      </c:if>
      
    </select>
  </c:otherwise>
  
</c:choose>