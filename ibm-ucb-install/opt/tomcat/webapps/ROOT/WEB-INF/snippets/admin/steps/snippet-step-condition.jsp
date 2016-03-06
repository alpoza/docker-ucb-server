<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.services.steps.StepCondition" %>
<%@ page import="com.urbancode.ubuild.domain.script.step.StepPreConditionScriptFactory" %>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="inEditMode" value="${mode == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>
<%
  pageContext.setAttribute("preConditionScripts", StepPreConditionScriptFactory.getInstance().restoreAll());
%>
<tr class="${fn:escapeXml(requestScope.curCssClass)}" id='stepConditionRow'>
  <td align="left" width="20%">
    <span class="bold">${ub:i18n("PreConditionScript")}</span>
  </td>
  <td align="left" width="20%">
    <ucf:idSelector
         id="preconditionscriptchooser"
         name="snippet_step_condition"
         list="${preConditionScripts}"
         selectedId="${param.curStepCondId}"
         enabled="${inEditMode}"
         entriesForAutocomplete="101"
         />
  </td>
  <td align="left">
    <span class="inlinehelp">
      ${ub:i18n("SnippetStepConditionPreConditionScriptDesc")}
    </span>
  </td>
</tr>
