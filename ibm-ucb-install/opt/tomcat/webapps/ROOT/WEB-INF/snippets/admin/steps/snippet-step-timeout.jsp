<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="inEditMode" value="${mode == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>

<tr class="${fn:escapeXml(requestScope.curCssClass)}" id='stepTimeoutRow'>
  <td align="left" width="20%">
    <span class="bold">${ub:i18n("TimeoutWithColon")}</span>
  </td>
  <td align="left" width="20%">
    <div>
        <ucf:text name="timeout" value='<%=String.valueOf(Long.parseLong(request.getParameter("timeout"))/60/1000)%>' size="10" enabled="${inEditMode}"/>
    </div>
  </td>
  <td align="left">
    <span class="inlinehelp">
      ${ub:i18n("SnippetStepTimeoutDesc")}
    </span>
  </td>
</tr>
