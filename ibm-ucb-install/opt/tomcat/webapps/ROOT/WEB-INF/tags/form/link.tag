<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>

<%@attribute name="href"        required="true"%>
<%@attribute name="label"       required="true"%>
<%@attribute name="forceLabel"  required="false" type="java.lang.Boolean"%>
<%@attribute name="onclick"     required="false" type="java.lang.String"%>
<%@attribute name="klass"       required="false" type="java.lang.String"%>
<%@attribute name="enabled"     required="false" type="java.lang.Boolean"%>
<%@attribute name="img"         required="false" type="java.lang.String"%>
<%@attribute name="imgStyle"    required="false" type="java.lang.String"%>
<%@attribute name="imgAlign"    required="false" type="java.lang.String"%>
<%@attribute name="disabledimg" required="false" type="java.lang.String"%>
<%@attribute name="disabledLabel" required="false" type="java.lang.String"%>
<%@attribute name="title"       required="false" type="java.lang.String"%>
<%@attribute name="target"      required="false" type="java.lang.String"%>
<%@attribute name="id"          required="false" type="java.lang.String"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:if test="${enabled == null}">
  <c:set var="enabled" value="${true}"/>
</c:if>

<c:set var="altLabel" value="${label}"/>
<c:if test="${not enabled}">
  <c:choose>
    <c:when test="${empty disabledLabel}">
      <c:set var="altLabel" value="${ub:i18nMessage('ObjectDisabled', label)}"/>
    </c:when>
    <c:otherwise>
      <c:set var="label" value="${disabledLabel}"/>
      <c:set var="altLabel" value="${disabledLabel}"/>
    </c:otherwise>
  </c:choose>
</c:if>

<c:if test="${forceLabel == null}">
    <c:set var="forceLabel" value="${false}"/>
</c:if>

<c:set var="additionalAttributes" value=""/>

<c:if test="${empty title && not empty img}">
  <c:set var="title" value="${label}"/>
</c:if>

<c:set var="additionalAttributes" value=""/>
<c:if test="${not empty title}">
  <c:set var="additionalAttributes" value="${additionalAttributes} title='${fn:escapeXml(title)}'"/>
</c:if>

<c:if test="${!empty target}">
  <c:set var="additionalAttributes" value="${additionalAttributes} target='${fn:escapeXml(target)}'"/>
</c:if>

<c:if test="${!empty id}">
  <c:set var="additionalAttributes" value="${additionalAttributes} id='${fn:escapeXml(id)}'"/>
</c:if>

<%-- This is somewhat ugly code, but if you put the </c:when> on a new line, the generated link will have extra tail whitespace --%>
<c:choose>
    <c:when test="${img!=null}">
        <c:choose>
            <c:when test="${enabled == null || enabled}">
              <a <c:if test="${href ne '#' || !empty onclick}"> href="${fn:escapeXml(href)}"</c:if>
                <c:if test="${!empty klass}"> class="${klass}"</c:if>
                <c:if test="${!empty onclick}"> onclick="${onclick}"</c:if>
                 ${additionalAttributes}><img border="0" src="${fn:escapeXml(img)}" title="${fn:escapeXml(altLabel)}" alt="${fn:escapeXml(altLabel)}"<c:if test="${imgStyle != null}"> style="${imgStyle}"</c:if><c:if test="${not empty imgAlign}"> align="${imgAlign}"</c:if>/><c:if test="${forceLabel}">&nbsp;<c:out value="${label}"/></c:if></a></c:when>
            <c:otherwise>
                <c:if test="${disabledimg == null}">
                    <%
                    String tempImg = (String) jspContext.getAttribute( "img" );
                    int index = tempImg.lastIndexOf(".");
                    if (index >= 0) { // No substring.
                        String base = tempImg.substring(0, index);
                        String suffix = tempImg.substring(index, tempImg.length());
                        jspContext.setAttribute( "disabledimg", base + "_disabled" + suffix );
                    }
                    %>
                </c:if>
                <c:choose>
                    <c:when test="${disabledimg != null}">
                        <img src="${fn:escapeXml(disabledimg)}" alt="${fn:escapeXml(altLabel)}" title="${fn:escapeXml(altLabel)}"
                            <c:if test="${imgStyle != null}"> style="${imgStyle}"</c:if>
                            <c:if test="${not empty imgAlign}"> align="${imgAlign}"</c:if> border="0"/>
                        <c:if test="${forceLabel}">&nbsp;${fn:escapeXml(label)}</c:if>
                    </c:when>
                    <c:otherwise>
                        <a <c:if test="${klass != null}"> class="${klass}disabled"</c:if>
                            ${additionalAttributes}>${fn:escapeXml(label)}</a>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${enabled == null || enabled}">
                <a href="${fn:escapeXml(href)}"
                    <c:if test="${klass != null}"> class="${klass}"</c:if>
                    <c:if test="${onclick != null}"> onclick="${onclick}"</c:if>
                    ${additionalAttributes}>${fn:escapeXml(label)}</a>
            </c:when>
            <c:otherwise>
                <a <c:if test="${klass != null}"> class="${klass} disabled"</c:if>
                    ${additionalAttributes}>${fn:escapeXml(label)}</a>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
