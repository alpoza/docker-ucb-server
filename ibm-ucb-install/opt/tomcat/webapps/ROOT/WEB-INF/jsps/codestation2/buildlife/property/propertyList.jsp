<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.codestation2.buildlife.CodestationBuildLifeTasks"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="${buildLifeTaskClass}" />
<ah3:useConstants id="CSBuildlifeConsts" class="com.urbancode.ubuild.web.codestation2.buildlife.CodestationBuildLifeTasks" />

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:url var="newPropertyUrl"    value="${CodestationBuildLifeTasks.newProperty}"/>
<br/>
<ucf:button name="New Property" label="${ub:i18n('NewProperty')}" href="${newPropertyUrl}"
    enabled="${param.canWrite && inViewMode and csBuildLifeProp==null}"/>
<br/><br/>
<table id="PropertyTable" class="data-table">
  <tbody>
    <tr>
      <th scope="col" align="left" valign="middle" >${ub:i18n("PropertyName")}</th>
      <th scope="col" align="left" valign="middle" >${ub:i18n("Value")}</th>
      <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
    </tr>
    <c:if test="${fn:length(codestationBuildLife.propertyArray)==0}">
        <tr bgcolor="#ffffff">
          <td colspan="3">
            ${ub:i18n("PropertyNoPropertiesMessage")}
          </td>
        </tr>
    </c:if>

    <c:forEach var="property" items="${codestationBuildLife.propertyArray}" varStatus="status">
      <c:url var="viewPropertyUrlSeq" value="${CodestationBuildLifeTasks.editProperty}">
        <c:param name="${CSBuildlifeConsts.CS_BUILD_LIFE_PROP_SEQ}" value="${status.index}"/>
      </c:url>

      <c:url var="removePropertyUrlSeq" value="${CodestationBuildLifeTasks.removeProperty}">
        <c:param name="${CSBuildlifeConsts.CS_BUILD_LIFE_PROP_SEQ}" value="${status.index}"/>
      </c:url>

      <tr bgcolor="#ffffff">
        <td align="left" height="1" nowrap="nowrap" width="35%">
          ${fn:escapeXml(property.name)}
        </td>

        <td align="left" height="1" nowrap="nowrap" width="45%">
          ${fn:escapeXml(property.value)}
        </td>

        <td align="center" height="1" nowrap="nowrap" width="20%">
          <c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
          <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

          <ucf:link href="${viewPropertyUrlSeq}" img="${iconMagnifyGlassUrl}" label="${ub:i18n('Edit')}" enabled="${param.canWrite && csBuildLifeProp==null}"/>&nbsp;
          <ucf:deletelink href="${removePropertyUrlSeq}" img="${iconDeleteUrl}" name="${property.name}" label="${ub:i18n('Remove')}" enabled="${param.canWrite && csBuildLifeProp==null}"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>
