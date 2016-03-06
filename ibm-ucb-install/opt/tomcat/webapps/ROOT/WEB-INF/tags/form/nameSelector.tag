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

<%@attribute name="autocomplete" required="false" type="java.lang.Boolean" %><%-- Whether the select should change to an autocomplete after x entries. Defaults to true. --%>
<%@attribute name="entriesForAutocomplete" required="false" type="java.lang.Integer"%><%-- The number of entries needed to convert to autocomplete. Defaults to 10. --%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:set var="autocomplete" value="${empty autocomplete ? true : autocomplete}"/>
<c:set var="entriesForAutocomplete" value="${(empty entriesForAutocomplete or entriesForAutocomplete le 0) ? WebConstants.AUTOCOMPLETE_DEFAULT_MIN : entriesForAutocomplete}"/>

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

<c:choose>
  <c:when test="${empty name}">
    <span class="error">ERROR: NAME ATTRIBUTE IS EMPTY</span>
  </c:when>

  <c:otherwise>
    <c:choose>
      <c:when test="${not autocomplete or (autocomplete and fn:length(list) lt entriesForAutocomplete) or multiple}">
        <select name="${fn:escapeXml(name)}" <c:if test="${not empty id}">id="${fn:escapeXml(id)}"</c:if> class="${fn:escapeXml(cssClass)}"${fn:escapeXml(disabled)}>
          <c:choose>
            <c:when test="${fn:length(unselectedText) > 0}">
              <option selected value="">${fn:escapeXml(unselectedText)}</option>
            </c:when>

            <c:otherwise>
              <option selected value="">--&nbsp;${ub:i18n("MakeSelection")}&nbsp;--</option>
            </c:otherwise>
          </c:choose>

          <c:forEach var="item" items="${list}">
            <c:choose>
              <c:when test="${item.name == selectedValue}">
                <c:set var="selected" value="selected"/>
              </c:when>

              <c:otherwise>
                <c:set var="selected" value=""/>
              </c:otherwise>
            </c:choose>

            <option ${fn:escapeXml(selected)} value="${fn:escapeXml(item.name)}">${fn:escapeXml(ub:i18n(item.name))}</option>
          </c:forEach>
        </select>
      </c:when>
      <c:otherwise>
        <ucf:autocomplete name="${fn:escapeXml(name)}" list="${list}"
          enabled="${enabled}"
          id="${id}"
          valueType="name"
        />
      </c:otherwise>
    </c:choose>
  </c:otherwise>
</c:choose>
