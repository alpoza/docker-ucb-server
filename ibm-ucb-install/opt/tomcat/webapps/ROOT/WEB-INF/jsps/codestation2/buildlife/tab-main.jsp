<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.codestation2.domain.buildlife.CodestationBuildLife" %>
<%@ page import="com.urbancode.codestation2.domain.project.CodestationProject" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="${taskClass}"/>
<ah3:useTasks class="${buildLifeTaskClass}"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<c:if test="${view==null}">
  <c:set var="view" value="main"/>
</c:if>

<c:if test="${not empty origBuildLife}">
  <c:set var="origStamp" value = "${origBuildLife.stamp}"/>
</c:if>

<c:url var="saveUrl" value="${CodestationBuildLifeTasks.saveCodestationBuildLife}"/>
<c:url var="editUrl" value="${CodestationBuildLifeTasks.editCodestationBuildLife}"/>
<c:url var="cancelUrl" value="${CodestationBuildLifeTasks.cancelCodestationBuildLife}"/>
<c:url var="viewUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}"/>

<%
  EvenOdd eo = new EvenOdd();
%>

<c:choose>
  <c:when test="${not empty param.fromBuildLife}">
    <c:url var="doneUrl" value='${BuildLifeTasks.viewBuildLifeDependencies}'>
      <c:param name="buildLifeId" value="${param.fromBuildLife}"/>
    </c:url>
  </c:when>
  <c:otherwise>
    <c:url var="doneUrl" value='${CodestationTasks.viewCodestationProject}'>
      <c:param name="codestationProjectId" value="${codestationBuildLife.codestationProject.id}"/>
    </c:url>
  </c:otherwise>
</c:choose>

<div class="tab-content">
  <div class="system-helpbox">
    <c:choose>
      <c:when test="${empty codestationBuildLife || codestationBuildLife.new}">
        ${ub:i18n("CodeStationBuildLifeNewVersion")}
      </c:when>
      <c:otherwise>
        ${ub:i18n("CodeStationBuildLifeModifyVersion")}
      </c:otherwise>
    </c:choose>
  </div>
  <div align="right" style="vertical-align: bottom;">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>

  <form method="post" action="${fn:escapeXml(saveUrl)}">
    <table class="property-table">
      <tbody>

        <error:field-error field="stamp" cssClass="<%=eo.getNext() %>"/>
        <tr class="<%=eo.getLast() %>" valign="top">
          <td align="left" width="15%"><span class="bold">${ub:i18n("StampWithColon")} <span class="required-text">*</span></span></td>

          <td align="left" width="20%">
            <c:choose>
              <c:when test="${not empty origStamp}">
                <ucf:text name="stamp" value="${(ub:i18nMessage('CopyNoun', origStamp))}" enabled="${inEditMode}"/>
              </c:when>
              <c:otherwise>
                <ucf:text name="stamp" value="${codestationBuildLife.stamp}" enabled="${inEditMode}"/>
              </c:otherwise>
            </c:choose>
          </td>

          <td align="left">
            <span class="inlinehelp">${ub:i18n("CodeStationBuildLifeVersionDesc")}</span>
          </td>
        </tr>

        <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="<%=eo.getNext() %>"/>
        <tr class="<%=eo.getLast() %>" valign="top">
          <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>

          <td align="left" colspan="2">
            <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${codestationBuildLife.description}" enabled="${inEditMode}"/>
          </td>

        </tr>

        <tr>
          <td colspan="3">
            <c:choose>
              <c:when test="${!param.canWrite}">
                <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
              </c:when>
              <c:when test="${inEditMode}">
                <ucf:button name="Save" label="${ub:i18n('Save')}"/>
                <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
              </c:when>
              <c:when test="${inViewMode}">
                <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}"/>
                <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
              </c:when>
            </c:choose>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</div>
