<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.security.*"%>
<%@page import="com.urbancode.ubuild.domain.script.*"%>
<%@page import="com.urbancode.ubuild.domain.workdir.*"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.workdir.WorkDirScriptPopup" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="saveUrl"   value="${WorkDirScriptPopup.saveWorkDirScript}"/>
<c:url var="cancelUrl" value="${WorkDirScriptPopup.cancelPopup}"/>

<%
  EvenOdd eo = new EvenOdd();
  boolean canWrite = Authority.getInstance().hasPermission(UBuildAction.SCRIPT_ADMINISTRATION);
  pageContext.setAttribute("canWrite", Boolean.valueOf(canWrite));
%>

<%-- CONTENT --%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("Main")}</a></li>
  </ul>
</div>

<br/>
<div class="contents">
  <c:if test="${not empty script}">
    <div class="translatedName"><c:out value="${ub:i18n(script.name)}"/></div>
    <c:if test="${not empty script.description}">
      <div class="translatedDescription"><c:out value="${ub:i18n(script.description)}"/></div>
    </c:if>
  </c:if>
  <form method="post" action="${fn:escapeXml(saveUrl)}">
    <table class="property-table">
      <c:if test="${!canWrite}">
        <caption>
          <span class="error">${ub:i18n("ScriptEditPermissionError")}</span>
        </caption>
      </c:if>

      <tbody>
        <error:field-error field="${WebConstants.NAME}" cssClass="<%=eo.getNext()%>"/>
        <tr class="<%=eo.getLast()%>" valign="top">
          <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")}&nbsp;<span class="required-text">*</span></span></td>
          <td align="left" width="20%">
            <ucf:text name="${WebConstants.NAME}" value="${workDirScript.name}" enabled="${canWrite}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("ScriptNameDesc")}</span>
          </td>
        </tr>

        <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="<%=eo.getNext()%>"/>
        <tr class="<%=eo.getLast()%>" valign="top">
          <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
          <td align="left" colspan="2">
            <span class="inlinehelp">${ub:i18n("ScriptDescriptionDesc")}</span><br/>
            <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${workDirScript.description}" enabled="${canWrite}" rows="4"/>
          </td>
        </tr>

        <error:field-error field="${WebConstants.SCRIPT}" cssClass="<%=eo.getNext()%>"/>
        <tr class="<%=eo.getLast()%>" valign="top">
          <td align="left" width="20%"><span class="bold">${ub:i18n("ScriptWithColon")}&nbsp;<span class="required-text">*</span></span></td>
          <td align="left" colspan="2">
            <span class="inlinehelp">${ub:i18n("WorkDirScriptDesc")}</span><br/>
            <ucf:textarea name="${WebConstants.SCRIPT}" value="${workDirScript.pathScript}"
                          rows="4" cols="60"
                          enabled="${canWrite}"/>
          </td>
        </tr>

      </tbody>
    </table>
    <br/>

    <c:choose>
      <c:when test="${canWrite}">
        <ucf:button name="Save" label="${ub:i18n('Save')}"/>
        <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
      </c:when>
      <c:otherwise>
        <ucf:button name="Done" label="${ub:i18n('Done')}" href="${cancelUrl}"/>
      </c:otherwise>
    </c:choose>
  </form>
</div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
