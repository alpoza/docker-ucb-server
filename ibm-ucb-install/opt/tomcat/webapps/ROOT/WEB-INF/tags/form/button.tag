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
<%@attribute name="label"    required="true"%>
<%@attribute name="id"       required="false"%>
<%@attribute name="href"     required="false"%>
<%@attribute name="onclick"  required="false"%>
<%@attribute name="submit"   required="false"%>
<%@attribute name="enabled"  required="false" type="java.lang.Boolean"%>
<%@attribute name="cssclass" required="false"%>
<%@attribute name="style"    required="false"%>
<%@attribute name="title"    required="false"%>
<%@attribute name="confirmMessage" required="false" type="java.lang.String"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:if test="${label==null}">
  <c:set var="label" value="${name}"/>
</c:if>

<c:if test="${enabled==null}">
 <c:set var="enabled"  value="true"/>
</c:if>

<c:if test="${cssclass==null}">
 <c:set var="cssclass"  value="button"/>
</c:if>

<c:if test="${not empty confirmMessage}">
  <c:set var="onclick" value="if (!basicConfirm(${fn:escapeXml(ah3:toJson(confirmMessage))})) { return false; }; ${onclick}"/>
</c:if>

<c:choose>
  <c:when test="${empty name}">
    <span class="error">${fn:toUpperCase(ub:i18n("ErrorWithColon"))} ${fn:toUpperCase(ub:i18n("NameAttributeEmpty"))}</span>
  </c:when>
  
  <c:otherwise>
    <c:choose>
      <c:when test="${!enabled}">
        <input type="${empty submit || submit ? 'submit' : 'button'}" 
          <c:if test="${!empty id}">id="${fn:escapeXml(id)}"</c:if> 
          name="${fn:escapeXml(name)}" value="${fn:escapeXml(label)}" class="${cssclass}disabled"
          <c:if test="${!empty title}">title="${fn:escapeXml(title)}"</c:if>
          <c:if test="${!empty style}">style="${fn:escapeXml(style)}"</c:if> disabled="disabled"/>
      </c:when>
      <c:when test="${href==null}">
        <input type="${empty submit || submit ? 'submit' : 'button'}" 
          <c:if test="${!empty id}">id="${fn:escapeXml(id)}"</c:if> 
          name="${fn:escapeXml(name)}" value="${fn:escapeXml(label)}" class="${cssclass}"
          <c:if test="${!empty title}">title="${fn:escapeXml(title)}"</c:if>
          <c:if test="${!empty onclick}">onclick="${onclick}"</c:if>
          <c:if test="${!empty style}">style="${fn:escapeXml(style)}"</c:if>/>
      </c:when>
      <c:otherwise>
        <input type="button" class="${cssclass}" <c:if test="${!empty id}">id="${fn:escapeXml(id)}"</c:if>
        name="${fn:escapeXml(name)}" value="${fn:escapeXml(label)}"
        <c:if test="${!empty title}">title="${fn:escapeXml(title)}"</c:if>
        onclick="${onclick}; goTo('${fn:escapeXml(href)}')"
        <c:if test="${!empty style}">style="${fn:escapeXml(style)}"</c:if>/>
      </c:otherwise>
    </c:choose>
  </c:otherwise>
</c:choose>
