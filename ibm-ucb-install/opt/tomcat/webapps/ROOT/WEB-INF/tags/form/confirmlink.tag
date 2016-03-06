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
<%@attribute name="message"     required="true"%>
<%@attribute name="label"       required="false" type="java.lang.String"%>
<%@attribute name="forceLabel"  required="false" type="java.lang.Boolean"%>
<%@attribute name="img"         required="false" type="java.lang.String"%>
<%@attribute name="disabledimg" required="false" type="java.lang.String"%>
<%@attribute name="enabled"     required="false" type="java.lang.Boolean"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:if test="${label==null}">
    <c:set var="label" value="Delete"/>
</c:if>

<c:choose>
    <c:when test="${img!=null}">
        <c:choose>
            <c:when test="${enabled == null || enabled}">
                <a title="${fn:escapeXml(label)}" onclick="return basicConfirm(${fn:escapeXml(ah3:toJson(message))});" href="${fn:escapeXml(href)}"><img src="${fn:escapeXml(img)}" alt="${fn:escapeXml(label)}" title="${fn:escapeXml(label)}" border="0"/><c:if test="${forceLabel}">&nbsp;${label}</c:if></a>
            </c:when>
            <c:otherwise>
                <c:if test="${disabledimg == null}">
                    <%-- Why doesn't fn taglib have ${fn:lastIndexOf()} ... --%>
                    <%
                    int index = img.lastIndexOf(".");
                    if (index >= 0) { // No substring.
                        String base = img.substring(0, index);
                        String suffix = img.substring(index,img.length());
                        disabledimg = base + "_disabled" + suffix;
                        jspContext.setAttribute( "disabledimg", disabledimg );
                    }
                    %>
                </c:if>
                <c:choose>
                    <c:when test="${disabledimg != null}">
                        <img src="${fn:escapeXml(disabledimg)}" alt="${ub:i18nMessage('ObjectDisabled', label)}" title="${ub:i18nMessage('ObjectDisabled', label)}" border="0"/>
                    </c:when>
                    <c:otherwise>
                        <span style="color:gray">${fn:escapeXml(label)}</span>
                    </c:otherwise>
                </c:choose>
                <c:if test="${forceLabel}">&nbsp;${label}</c:if>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${enabled == null || enabled}">
                <a title="${fn:escapeXml(label)}" onclick="return basicConfirm('${ah3:escapeJs(message)}');" href="${fn:escapeXml(href)}">${fn:escapeXml(label)}</a>
            </c:when>
            <c:otherwise>
                <span style="color:gray">${fn:escapeXml(label)}</span>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
