<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:choose>
    <c:when test='${mode == "edit"}'>
      <c:set var="inEditMode" value="true"/>
      <c:set var="textFieldAttributes" value=""/><%--normal attributes for text fields--%>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="textFieldAttributes" value="disabled class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<tr class="${fn:escapeXml(requestScope.curCssClass)}" id='stepRunInParallel'>
  <td align="left" width="20%">
    <span class="bold">${ub:i18n("LibraryWorkflowIterationRunInParallel")}</span>
  </td>
  <td align="left" width="20%">
    <div>
        <ucf:yesOrNo name="runInParallel" value="${param.runInParallel}" enabled="${inEditMode}"/>
    </div>
  </td>
  <td align="left">
    <span class="inlinehelp">
      ${ub:i18n("SnippetStepRunInParallelDesc")}
    </span>
  </td>
</tr>
