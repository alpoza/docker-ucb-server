<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.codestation2.CodestationTasks"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${taskClass}" />
<ah3:useConstants id="CSConsts" class="com.urbancode.ubuild.web.codestation2.CodestationTasks" />

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<c:url var="newPropertyUrl"    value="${CodestationTasks.newProperty}"/>

<ucf:button name="NewProperty" label="${ub:i18n('NewProperty')}" href="${newPropertyUrl}"
    enabled="${param.canWrite && inViewMode and csProjectProp==null}"/>
<br/><br/>

<table id="PropertyTable" class="data-table">
  <tbody>
    <tr>
      <th scope="col" align="left" valign="middle" width="35%">${ub:i18n("PropertyName")}</th>
      <th scope="col" align="left" valign="middle" width="45%">${ub:i18n("Value")}</th>
      <th scope="col" align="center" valign="middle" width="20%">${ub:i18n("Actions")}</th>
    </tr>
    <c:if test="${fn:length(codestationProject.propertyArray)==0}">
        <tr bgcolor="#ffffff">
          <td colspan="3">
          ${ub:i18n("PropertyNoPropertiesMessage")}
          </td>
        </tr>
    </c:if>

    <c:forEach var="property" items="${codestationProject.propertyArray}" varStatus="status">
      <c:url var="viewPropertyUrlSeqID" value="${CodestationTasks.editProperty}">
        <c:param name="${CSConsts.CS_PROJECT_PROP_SEQ}" value="${status.index}"/>
      </c:url>

      <c:url var="removePropertyUrlSeqID" value="${CodestationTasks.removeProperty}">
        <c:param name="${CSConsts.CS_PROJECT_PROP_SEQ}" value="${status.index}"/>
      </c:url>

      <tr bgcolor="#ffffff">
        <td align="left" height="1" nowrap="nowrap" width="35%">
          ${fn:escapeXml(property.name)}
        </td>

        <td align="left" height="1" nowrap="nowrap" width="45%">
          ${fn:escapeXml(property.value)}
        </td>

        <td align="center" height="1" nowrap="nowrap" width="20%">
          <c:url var="viewPropertyUrlSeq" value="/images/icon_magnifyglass.gif"/>
          <c:url var="removePropertyUrlSeq" value="/images/icon_delete.gif"/>
        
          <ucf:link href="${viewPropertyUrlSeqID}" img="${viewPropertyUrlSeq}" label="${ub:i18n('Edit')}" enabled="${param.canWrite && csProjectProp==null}"/>&nbsp;
          <ucf:deletelink href="${removePropertyUrlSeqID}" name="${property.name}" img="${removePropertyUrlSeq}" label="${ub:i18n('Remove')}" enabled="${param.canWrite && csProjectProp==null}"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>
