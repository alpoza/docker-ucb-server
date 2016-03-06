<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>

<%@attribute name="name"           required="true"%>
<%@attribute name="list"           required="true"  type="java.lang.Object"%><!-- Must be a List or Array -->
<%@attribute name="valueList"      required="false" type="java.lang.Object"%>
<%@attribute name="selectedValue"  required="false" type="java.lang.Object"%><%-- can by any Iterable or Array  --%>
<%@attribute name="selectedValues" required="false" type="java.lang.Object"%><%-- can by any Iterable or Array  --%>
<%@attribute name="emptyMessage"   required="false" type="java.lang.String"%>
<%@attribute name="emptyMessageDisabled" required="false" type="java.lang.Boolean"%>
<%@attribute name="canUnselect"    required="false" type="java.lang.Boolean" %>
<%@attribute name="multiple"       required="false" type="java.lang.Boolean" %>
<%@attribute name="enabled"        required="false" type="java.lang.Boolean"%>
<%@attribute name="id"             required="false" type="java.lang.String"%>
<%@attribute name="onChange"       required="false" type="java.lang.String"%>
<%@attribute name="required"       required="false" type="java.lang.Boolean" %>

<%@attribute name="autocomplete" required="false" type="java.lang.Boolean" %><%-- Whether the select should change to an autocomplete after x entries. Defaults to true. --%>
<%@attribute name="entriesForAutocomplete" required="false" type="java.lang.Integer"%><%-- The number of entries needed to convert to autocomplete. Defaults to 10. --%>


<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<%
   boolean iterable = Iterable.class.isInstance(selectedValue)  || (selectedValue != null && selectedValue.getClass().isArray());
   jspContext.setAttribute("isIterable", iterable);
%>

<c:set var="enabled" value="${empty enabled || enabled}"/>

<c:if test="${canUnselect && emptyMessage == null}">
  <c:set var="emptyMessage" value="${ub:i18n('None')}"/>
</c:if>

<c:if test="${empty valueList}">
  <c:set var="valueList" value="${list}"/>
</c:if>

<c:set var="autocomplete" value="${empty autocomplete ? true : autocomplete}"/>
<c:set var="entriesForAutocomplete" value="${(empty entriesForAutocomplete or entriesForAutocomplete le 0) ? WebConstants.AUTOCOMPLETE_DEFAULT_MIN : entriesForAutocomplete}"/>

<%-- build up space-separated list of css classes --%>
<c:set var="classes" value=""/>
<c:if test="${!enabled}">
  <c:set var="classes" value="${classes}${' '}inputdisabled"/>
</c:if>

<%-- CONTENT --%>

<c:choose>
  <c:when test="${not autocomplete or multiple or (autocomplete and fn:length(list) lt entriesForAutocomplete)}">
  <%-- <c:when test="${true}"> --%>
    <select name="${fn:escapeXml(name)}"
        class="${classes}" style="min-width: 10em"
        <c:if test="${!empty id}">id="${fn:escapeXml(id)}"</c:if>
        <c:if test="${multiple}">multiple="multiple"</c:if>
        <c:if test="${!enabled}">disabled="disabled"</c:if>
        <c:if test="${!empty onChange}">onchange="${onChange}"</c:if>
      >

      <c:if test="${not multiple}">
        <option <c:if test="${empty selectedValue && empty selectedValues}">selected='selected'</c:if> value="" ${(emptyMessageDisabled)?"disabled=\"disabled\"":""}>-- <c:out value="${emptyMessage}" default="${ub:i18n('MakeSelection')}"/> --</option>
      </c:if>

      <c:forEach var="value" items="${valueList}" varStatus="i">
        <c:set var="label" value="${!empty list[i.count-1] ? list[i.count-1] : value}"/>

        <c:remove var="selected" scope="page"/>
        <c:choose>
           <c:when test="${!isIterable}"><c:set var="selected" value="${value == selectedValue}" scope="page"/></c:when>
           <c:otherwise>
              <c:forEach var="tmpSelectedValue" items="${selectedValue}">
                 <c:if test="${value == tmpSelectedValue}">
                    <c:set var="selected" value="${true}" scope="page"/>
                 </c:if>
              </c:forEach>
           </c:otherwise>
        </c:choose>
        <c:forEach var="tmpSelectedValue" items="${selectedValues}">
          <c:if test="${value == tmpSelectedValue}">
            <c:set var="selected" value="${true}" scope="page"/>
          </c:if>
        </c:forEach>

        <c:set var="foundValue" value="${foundValue || selected}" scope="page"/><%-- track if we have found the selectedValue --%>

        <option <c:if test="${selected}">selected="selected"</c:if> value="${fn:escapeXml(value)}">${fn:escapeXml(ub:i18n(label))}</option>
      </c:forEach>

    </select>

    <%-- Deal with a selected value which is not in our values list, we will display it as the last option in italics --%>
    <c:choose>
      <c:when test="${foundValue or empty selectedValue}">
        <%-- Do nothing --%>
      </c:when>
      <c:when test="${isIterable}">
        <c:forEach var="tmpSelectedValue" items="${selectedValue}">
          <c:if test="${!empty tmpSelectedValue}">
            <span class="error">${ub:i18nMessage('InvalidSelectionMessage', fn:escapeXml(tmpSelectedValue))}</span>
          </c:if>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <span class="error">${ub:i18nMessage('InvalidSelectionMessage', fn:escapeXml(selectedValue))}</span>
      </c:otherwise>
    </c:choose>
  </c:when>
  <c:otherwise>
    <ucf:autocomplete name="${fn:escapeXml(name)}" list="${list}"
      canUnselect="${false}"
      selectedList="${selectedValues}"
      selectedObject="${selectedValue}"
      onChange="${onChange}"
      emptyMessage="${emptyMessage}"
      enabled="${enabled}"
      id="${id}"
      size="${size}"
      valueType="string"
    />
  </c:otherwise>
</c:choose>
