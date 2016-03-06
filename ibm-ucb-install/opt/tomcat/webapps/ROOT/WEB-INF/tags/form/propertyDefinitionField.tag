<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag import="com.urbancode.air.property.prop_sheet_def.PropSheetDef"%>
<%@tag body-content="empty" %>
<%@tag import="java.util.*"%>
<%@tag import="com.urbancode.air.property.prop_def.PropDef"%>
<%@tag import="com.urbancode.air.property.prop_def.PropDef.PropDefType"%>
<%@tag import="org.apache.commons.lang3.StringUtils" %>

<%@attribute name="propertyDefinition" required="true" type="com.urbancode.air.property.prop_def.PropDef"%>
<%@attribute name="name"              required="false" type="java.lang.String"%>
<%@attribute name="fieldPrefix"       required="false" type="java.lang.String"%>
<%@attribute name="customValue"       required="true"  type="java.lang.String"%>
<%@attribute name="id"                required="false" type="java.lang.String"%>
<%@attribute name="enabled"           required="false" type="java.lang.Boolean"%>
<%@attribute name="required"          required="false" type="java.lang.Boolean"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:if test="${empty name}">
  <c:set var="name" value="${propertyDefinition.name}"/>
  <c:if test="${!empty fieldPrefix}">
    <c:set var="name" value="${fieldPrefix}:${name}"/>
  </c:if>
</c:if>

<c:set var="type" value="${propertyDefinition.type}"/>
<c:set var="required" value="${propertyDefinition.required}"/>
<c:set var="enabled" value="${empty enabled || enabled}"/>

<script type="text/javascript">
function integrationSelectionChanged() {
    var checkbox = $('propCheckbox');
    if (checkbox != null) {
        var checked = checkbox.checked;
        toggleElement($('listDiv'), !checked);
        toggleElement($('propDiv'), checked);
    }
}

function toggleElement(element, enabled) {
    element.disabled = !enabled;

    if (enabled) {
        element.removeClassName('inputdisabled');
        element.show();
    }
    else {
        element.addClassName('inputdisabled');
        element.hide();
    }
}
</script>

<%-- ::::::: --%>
<%-- CONTENT --%>
<%-- ::::::: --%>

<c:choose>
  <c:when test="${type == 'TEXT'}">
    <ucf:text     name="${name}" value="${customValue}" required="${required}" enabled="${enabled}" />
  </c:when>
  <c:when test="${type == 'SECURE'}">
    <ucf:password name="${name}" value="${customValue}" required="${required}" enabled="${enabled}" confirm="${true}" />
  </c:when>
  <c:when test="${type == 'TEXTAREA'}">
    <ucf:textarea name="${name}" value="${customValue}" required="${required}" enabled="${enabled}" />
  </c:when>
  <c:when test="${type == 'CHECKBOX'}">
    <ucf:checkbox name="${name}" value="true" checked="${customValue == 'true'}" enabled="${enabled}" />
  </c:when>
  <c:when test="${type == 'SELECT'}">
    <ucf:stringSelector name="${name}" required="${required}" enabled="${enabled}"
      list="${!empty propertyDefinition.allowedValueLabels ? propertyDefinition.allowedValueLabels : propertyDefinition.allowedValueStrings}"
      valueList="${propertyDefinition.allowedValueStrings}"
      selectedValue="${customValue}"
    />
  </c:when>
  <c:when test="${type == 'MULTI_SELECT'}">
    <ucf:multiselect name="${name}" enabled="${enabled}"
                     list="${propertyDefinition.allowedValueStrings}"
                     labels="${!empty propertyDefinition.allowedValueLabels ? propertyDefinition.allowedValueLabels : propertyDefinition.allowedValueStrings}"
                     selectedValues="${fn:split(customValue, ',')}"/>
  </c:when>
  <c:when test="${type == 'PROP_SHEET_REF'}">
    <c:set var="fieldName" value="${name}-property"/>
    <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : customValue}"/>

    <%
    boolean propCheckboxChecked = false;
    try {
        String customValue = (String) jspContext.getAttribute("value");

        if (!StringUtils.isBlank(customValue)) {
            UUID uuid = UUID.fromString(customValue);
        }
    }
    catch (IllegalArgumentException e) {
        // Not a UUID, disable id selector
        propCheckboxChecked = true;
    }
    jspContext.setAttribute("checked", propCheckboxChecked);

    PropSheetDef allowedPropSheetDef = propertyDefinition.getAllowedPropSheetDef();
    jspContext.setAttribute("allowedPropSheetList", allowedPropSheetDef.getPropSheetList());
    %>

    <div id="listDiv" style="${checked ? 'display: none;' : ''}">
      <ucf:idSelector id="integrationList"
                      name="${name}"
                      list="${allowedPropSheetList}"
                      selectedId="${!checked ? customValue : null}"
                      enabled="${enabled}"
                    />
    </div>
    <div id="propDiv" style="${checked ? '' : 'display: none;'}">
      <ucf:text id="integrationProperty"
                name="${name}-property"
                value="${checked ? value : ''}"
                enabled="${enabled}"
              />
    </div>
    <input id="propCheckbox"
        type="checkbox"
        name="bindPropertyCheckbox"
        value="true"
        onchange="integrationSelectionChanged();"
      <c:if test="${!enabled}">disabled=disabled</c:if>
      <c:if test="${checked}">checked=checked</c:if>
    />${ub:i18n("CheckToBindToProperty")}
  </c:when>
  <c:otherwise>
    ${ub:i18nMessage("UnknownType", type)}
  </c:otherwise>
</c:choose>
