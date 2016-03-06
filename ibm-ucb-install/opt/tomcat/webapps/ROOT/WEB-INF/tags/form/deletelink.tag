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
<%@attribute name="name"        required="true"%>
<%@attribute name="label"       required="false" type="java.lang.String" %>
<%@attribute name="img"         required="false" type="java.lang.String" %>
<%@attribute name="disabledimg" required="false" type="java.lang.String" %>
<%@attribute name="enabled"     required="false" type="java.lang.Boolean"%>
<%@attribute name="onmouseover" required="false" type="java.lang.String" %>
<%@attribute name="onmouseout"  required="false" type="java.lang.String" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:if test="${label==null}">
    <c:set var="label" value="${ub:i18n('Delete')}"/>
</c:if>

<c:choose>
    <c:when test="${empty onmouseover}">
        <c:set var="onmouseover" value=""/>
    </c:when>
    <c:otherwise>
        <c:set var="onmouseover" value="onmouseover=\"${onmouseover}\""/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${empty onmouseout}">
        <c:set var="onmouseout" value=""/>
    </c:when>
    <c:otherwise>
        <c:set var="onmouseout" value="onmouseout=\"${onmouseout}\""/>
    </c:otherwise>
</c:choose>

<%
  // If message has any double-quotes in it, it will break the link
  name = name.replace('"', '\'');
  jspContext.setAttribute("name", name);
%>

<c:choose>
    <c:when test="${img!=null}">
        <c:choose>
            <c:when test="${enabled == null || enabled}">
                <a onclick="return confirmDelete('${ah3:escapeJs(name)}');" title="${fn:escapeXml(label)}" href="${fn:escapeXml(href)}" ${onmouseover} ${onmouseout}><img src="${fn:escapeXml(img)}" alt="${fn:escapeXml(label)}" title="${fn:escapeXml(label)}" border="0"/></a>
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
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${enabled == null || enabled}">
                <a onclick="return confirmDelete('${ah3:escapeJs(name)}');" href="${fn:escapeXml(href)}" ${onmouseover} ${onmouseout}>${fn:escapeXml(label)}</a>
            </c:when>
            <c:otherwise>
                <span style="color:gray">${fn:escapeXml(label)}</span>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
