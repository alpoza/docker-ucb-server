<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="scf" tagdir="/WEB-INF/tags/ui/admin/source" %>

<ah3:useConstants class="com.urbancode.ubuild.domain.plugin.SourcePluginConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.project.source.SourceConfigTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<%
    pageContext.setAttribute("eo", new com.urbancode.ubuild.web.util.EvenOdd());
%>

<c:if test="${empty sourceConfig}">
  <ucf:hidden name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}"/>
  <ucf:hidden name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
</c:if>
<ucf:hidden name="${WebConstants.SOURCE_CONFIG_ID}" value="${sourceConfig.id}"/>

<c:set var="fieldName" value="name"/>
<c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : sourceConfig.name}"/>
<error:field-error field="name" cssClass="${eo.next}"/>
<tr class="${eo.last}">
  <td style="width:20%">
    <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
  </td>
  <td style="width:20%">
    <ucf:text name="name" value="${nameValue}" required="${true}" enabled="${inEditMode}"/>
  </td>
  <td><span class="inlinehelp">${ub:i18n("SourceConfigNameDesc")}</span></td>
</tr>

<c:set var="fieldName" value="description"/>
<c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : sourceConfig.description}"/>
<error:field-error field="description" cssClass="${eo.next}"/>
<tr class="${eo.last}" valign="top">
  <td width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
  <td colspan="2"><ucf:textarea name="description" value="${descriptionValue}" enabled="${inEditMode}"/></td>
</tr>

<c:set var="fieldName" value="workDirScriptId"/>
<c:set var="scriptValue" value="${param[fieldName] != null ? param[fieldName] : sourceConfig.workDirScript.id}"/>
<scf:workDirSelector selectedId="${scriptValue}" sourceConfig="${sourceConfig}" eo="${eo}" disabled="${inViewMode}"/>

<c:set var="propMap" value="${sourceConfig.propSheet.propMap}"/>
<c:forEach var="propDef" items="${propSheetDef.propDefList}">
 <c:set var="hideRepoRefProp" value="${sourceConfigForTemplate && propDef.name == SourcePluginConstants.SOURCE_REPO_PROPERTY}"/>
 <c:if test="${not propDef.hidden && not hideRepoRefProp}">
   <c:set var="type" value="${fn:toLowerCase(propDef.type)}"/>
   <c:set var="key" value="${propDef.name}"/>
   <c:set var="fieldName" value="property:${key}"/>
   <c:set var="customValue" value="${empty propMap[key] ? propDef.defaultValue : propMap[key]}"/>
   <c:set var="customValue" value="${param[fieldName] != null ? param[fieldName] : customValue}"/>

   <error:field-error field="property:${key}" cssClass="${eo.next}"/>
   <tr class="${eo.last}">
     <td style="width:20%">
       <span class="bold">
         <c:choose>
           <c:when test="${not empty propDef.label}">
             ${ub:i18nMessage('NounWithColon', ub:i18n(propDef.label))}
           </c:when>
           <c:otherwise>
             ${ub:i18nMessage('NounWithColon', propDef.name)}
           </c:otherwise>
         </c:choose>
         <c:if test="${propDef.required}">&nbsp;<span class="required-text">*</span></c:if>
       </span>
     </td>
    <c:choose>
      <c:when test="${type == 'textarea'}">
        <td colspan="2">
          <span class="inlinehelp">${fn:escapeXml(ub:i18n(propDef.description))}</span><br/>
          <ucf:propertyDefinitionField propertyDefinition="${propDef}" customValue="${customValue}" fieldPrefix="property" enabled="${inEditMode}" />
        </td>
      </c:when>
      <c:otherwise>
        <c:if test="${type == 'select'}">
          <c:set var="customValue" value="${empty propMap[key] && param[fieldName] == null ? null : customValue}"/>
        </c:if>
        <td style="width:20%">
          <ucf:propertyDefinitionField propertyDefinition="${propDef}" customValue="${customValue}" fieldPrefix="property" enabled="${inEditMode}" />
        </td>
        <td><span class="inlinehelp">${fn:escapeXml(ub:i18n(propDef.description))}</span></td>
      </c:otherwise>
    </c:choose>
   </tr>

   <c:remove var="type"/>
   <c:remove var="key"/>
   <c:remove var="customValue"/>
 </c:if>
</c:forEach>
