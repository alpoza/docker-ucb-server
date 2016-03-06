<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.ubuild.domain.trigger.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.scheduled.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.scheduled.workflow.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.remoterequest.repository.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.remoterequest.repository.workflow.*" %>
<%@page import="com.urbancode.ubuild.domain.trigger.postprocess.*" %>
<%@page import="com.urbancode.ubuild.domain.workflow.*" %>
<%@page import="com.urbancode.air.i18n.TranslateMessage" %>
<%@page import="com.urbancode.ubuild.web.*" %>


<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input"%>
<%@ taglib uri="error" prefix="error"%>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="enabled" value="${trigger == null}"/>

<c:choose>
  <c:when test="${enabled}">
    <c:set var="selectDisabled" value=""/>
  </c:when>

  <c:otherwise>
    <c:set var="selectDisabled" value="disabled"/>
  </c:otherwise>
</c:choose>

<c:set var="selectedTriggerType" value="${trigger.class.name}"/>
<br />
<br />
<div class="bold">${ub:i18n("TriggerSelect")}</div>
<br/>
<%
  Trigger trigger = (Trigger)pageContext.findAttribute(WebConstants.TRIGGER);
  Workflow workflow = (Workflow)pageContext.findAttribute(WebConstants.WORKFLOW);
  if (workflow == null && trigger != null) {
      workflow = trigger.getWorkflow();
  }

  if (workflow.isOriginating()) {
      pageContext.setAttribute("triggerTypeList",
              new String[]{
                  ScheduledTrigger.class.getName(),
                  RepositoryRequestTrigger.class.getName(),
                  PostProcessTrigger.class.getName()
                  });
      pageContext.setAttribute("triggerTypeNameList",
              new String[]{
                  TranslateMessage.translate("ScheduledTrigger"),
                  TranslateMessage.translate("RepositoryRequestTrigger"),
                  TranslateMessage.translate("PostProcessTrigger")});
  }
  else {
      pageContext.setAttribute("triggerTypeList",
              new String[]{
                  ScheduledRunWorkflowTrigger.class.getName(),
                  RepositoryRequestRunWorkflowTrigger.class.getName(),
                  PostProcessTrigger.class.getName()
                  });
      pageContext.setAttribute("triggerTypeNameList",
              new String[]{
              TranslateMessage.translate("ScheduledTrigger"),
              TranslateMessage.translate("RepositoryRequestTrigger"),
              TranslateMessage.translate("PostProcessTrigger")});
  }
%>


<%-- CONTENT --%>

  <table class="property-table">
    <tbody>
      <error:field-error field="triggerType"/>
      <tr class="even" valign="top">
        <td align="left" width="20%">
          <span class="bold">${ub:i18n("TypeWithColon")}</span>
        </td>

        <td align="left" width="20%">
          <select name="triggerType" ${selectDisabled}>
            <c:forEach var="u" items="${triggerTypeList}" varStatus="status">
              <c:choose>
                <c:when test="${u == selectedTriggerType}">
                  <c:set var="selected" value='selected="selected"'/>
                </c:when>
                <c:otherwise>
                  <c:set var="selected" value=""/>
                </c:otherwise>
              </c:choose>

              <option ${selected} value="${fn:escapeXml(u)}">${fn:escapeXml(triggerTypeNameList[status.index])}</option>
            </c:forEach>
          </select>
        </td>

        <td align="left">
          <span class="inlinehelp">${ub:i18n("TriggerTypeDesc")}</span>
        </td>
      </tr>
    </tbody>
  </table>
  <br/>
  <ucf:button name="Select" label="${ub:i18n('Select')}" enabled="${enabled}"/>
  <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${param.backUrl}" enabled="${enabled}"/>
