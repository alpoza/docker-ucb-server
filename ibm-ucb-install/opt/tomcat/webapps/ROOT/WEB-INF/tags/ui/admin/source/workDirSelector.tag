<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag import="com.urbancode.ubuild.domain.workdir.WorkDirScriptFactory" %>
<%@tag import="com.urbancode.ubuild.web.WebConstants"%>

<%@attribute name="sourceConfig" type="java.lang.Object" required="true"%>
<%@attribute name="disabled" type="java.lang.Boolean"%>
<%@attribute name="eo" type="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@attribute name="selectedId" required="false" type="java.lang.Object"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<error:field-error field="workDirScriptId" cssClass="${eo.next}"/>
<tr class="${fn:escapeXml(eo.last)}" valign="top">
  <%
    jspContext.setAttribute("workDirScriptArray", WorkDirScriptFactory.getInstance().restoreAll());
  %>
  <td align="left" width="20%">
    <span class="bold">${ub:i18n("WorkDirScriptWithColon")}&nbsp;<span class="required-text">*</span></span>
  </td>

  <td align="left" width="20%">
    <ucf:idSelector
        id="workdirscriptchooser"
        name="workDirScriptId"
        list="${workDirScriptArray}"
        selectedId="${selectedId != null ? selectedId : sourceConfig.workDirScript.id}"
        canUnselect="${false}"
        enabled="${!disabled}"/>
  </td>

  <td align="left">
    <span class="inlinehelp">${ub:i18n("WorkingDirectoryScriptDesc")}</span>
    <c:set var="chooserId" value="workdirscriptchooser" scope="request"/>
    <c:import url="/WEB-INF/snippets/popup/workdir/script-links.jsp">
      <c:param name="enabled" value="${!disabled}"/>
    </c:import>
  </td>
</tr>
