<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>

<%@tag import="com.urbancode.air.i18n.TranslateMessage" %>

<%@attribute name="name"                required="true"  type="java.lang.String"%>
<%@attribute name="value"               required="true"%>
<%@attribute name="id"                  required="false" type="java.lang.String"%>
<%@attribute name="size"                required="false" type="java.lang.Integer"%>
<%@attribute name="enabled"             required="false" type="java.lang.Boolean"%>
<%@attribute name="confirm"             required="false" type="java.lang.Boolean"%>
<%@attribute name="autoconfirm"         required="false" type="java.lang.Boolean"%>
<%@attribute name="onPwdChange"         required="false" type="java.lang.String"%>
<%@attribute name="extraAttribs"        required="false" type="java.lang.String"%>
<%@attribute name="required"            required="false" type="java.lang.Boolean" %>
<%@attribute name="disableAutocomplete" required="false" type="java.lang.Boolean"%>
<%@attribute name="cssClass"            required="false" type="java.lang.String"%>


<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:if test="${autoconfirm}">
  <c:set var="confirm" value="true"/>
  <c:set var="confirmStyle" value="display: none;"/>
  <c:set var="onPwdChange" value="$('${fn:escapeXml(name)}Confirm').up('.confirmPasswordSection').show()"/>
</c:if>

<c:if test="${empty enabled || enabled}">
    <c:set var="enabled" value="${true}"/>
</c:if>

<c:if test="${empty disableAutocomplete || disableAutocomplete}">
  <c:set var="disableAutocomplete" value='${true}'/>
</c:if>

<c:if test="${empty size}"><c:set var="size" value="20"/></c:if>
<c:if test="${empty id}"><c:set var="id" value="${name}"/></c:if>
<c:if test="${empty confirm}"><c:set var="confirm" value="${false}"/></c:if>

<c:if test="${!empty value}">
  <c:set var="value" value="${WebConstants.DUMMY_PASSWORD}"/><%-- must match WebConstants.DUMMY_PASSWORD --%>
</c:if>

<c:if test="${empty name}">
  <% if (true) { throw new IllegalArgumentException(TranslateMessage.translate("NameAttributeCanNotBeEmpty"));} %>
</c:if>

<%-- build up space-separated list of css classes --%>
<c:set var="classes" value="${cssClass}"/>
<c:if test="${!enabled}">
  <c:set var="classes" value="${classes}${' '}inputdisabled"/>
</c:if>
<c:if test="${confirm}">
  <c:set var="classes" value="${classes}${' '}hasConfirm"/>
</c:if>

<%-- CONTENT --%>

<input type="password"
       name="${fn:escapeXml(name)}" 
       value="${fn:escapeXml(value)}" 
       size="${fn:escapeXml(size)}" 
       class="${classes}"
       <c:if test="${disableAutocomplete}">${' '}autocomplete="off"</c:if>
       <c:if test="${!enabled}">${' '}disabled="disabled"</c:if>
       <c:if test="${!empty id}">${' '}id="${fn:escapeXml(id)}"</c:if>
       <c:if test="${!empty onPwdChange}">${' '}onkeyup="if(this.value == '${value}') return; ${onPwdChange}; this.onkeyup=null; "</c:if>
       <c:if test="${!empty extraAttribs}">${' '}${extraAttribs}</c:if>
       />
       
<c:if test="${confirm}">
  <div style="padding-top: 5px; ${fn:escapeXml(confirmStyle)}" class="confirmPasswordSection">
    <span style="font-size: smaller">${ub:i18n("Confirm")}<br/></span>
    <input ${autocompleteattrib} 
         class="input${disabled}" 
         type="password" 
         id="${fn:escapeXml(name)}Confirm" 
         name="${fn:escapeXml(name)}Confirm" 
         value="" 
         ${extraAttribs} 
         size="${fn:escapeXml(size)}" 
         ${disabled}/>
   </div>
</c:if>


