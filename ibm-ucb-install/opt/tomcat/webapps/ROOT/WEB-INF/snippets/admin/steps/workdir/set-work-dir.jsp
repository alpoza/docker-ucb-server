<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.workdir.*"%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.util.*" %>

<%@ taglib uri="error" prefix="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose>
  <c:when test='${mode == "edit"}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="fieldAttributes" value=""/><%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<%
  pageContext.setAttribute(WebConstants.WORK_DIR_SCRIPT_LIST, WorkDirScriptFactory.getInstance().restoreAll());
  pageContext.setAttribute("eo", new EvenOdd());
%>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

  <div class="snippet_form">
  <div class="system-helpbox">
    ${ub:i18n("SetWorkDirStepHelp")}
  </div><br />

    <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>

    <input type="hidden" name="<%= SnippetBase.SNIPPET_METHOD%>" value="saveMainTab">

    <table class="property-table" border="0">
      <tbody>

        <c:set var="fieldName" value="${WebConstants.WORK_DIR_SCRIPT_ID}"/>
        <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
        <tr class="${eo.last}">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("WorkDirScriptWithColon")} <span class="required-text">*</span></span>
          </td>
          <td align="left" width="20%">
            <c:set var="scriptValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.workDirScript.id}"/>
            <ucf:idSelector id="workdirscriptchooser"
                            name="${WebConstants.WORK_DIR_SCRIPT_ID}"
                            list="${workDirScriptList}"
                            selectedId="${scriptValue}"
                            enabled="${inEditMode}"
                            />
          </td>
          <td>
            <span class="inlinehelp"></span><br/>
            <c:set var="chooserId" value="workdirscriptchooser" scope="request"/>
            <c:import url="/WEB-INF/snippets/popup/workdir/script-links.jsp">
              <c:param name="enabled" value="${inEditMode}"/>
            </c:import>
          </td>
        </tr>

        <%--
        <c:set var="fieldName" value="clean"/>
        <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
        <tr class="${eo.last}">
          <td align="left" width="20%">
            <span class="bold">Clean Working Directory: </span>
          </td>
          <td colspan="2" align="left" width="20%">
            <c:set var="cleanValue" value="${empty stepConfig.cleanWorkDir ? param[fieldName] : stepConfig.cleanWorkDir}"/>
            <input type=CHECKBOX class="checkbox" <c:if test="${cleanValue}">checked="true"</c:if> name="clean" value="true" ${fieldAttributes}>
            <span class="inlinehelp">Erases all files in the working directory when this step runs.</span>
          </td>
        </tr>
        --%>

        <c:set var="fieldName" value="releasingPriorLocks"/>
        <tr class="${eo.next}">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("ReleasePriorWorkDirs")} </span>
          </td>
          <td colspan="2" align="left" width="20%">
            <c:set var="releaseValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.releasingPriorLocks}"/>
            <input type=CHECKBOX class="checkbox" <c:if test="${releaseValue}">checked="true"</c:if> name="releasingPriorLocks" value="true" ${fieldAttributes}>
            <span class="inlinehelp">${ub:i18n("ReleasePriorWorkDirsDesc")}</span>
          </td>
        </tr>

        <tr class="${eo.next}">
          <td colspan="3">
            <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-advanced.jsp">
              <jsp:param name="editUrl" value="${param.editUrl}"/>
              <jsp:param name="showAdvanced" value="${param.showAdvanced}"/>
            </jsp:include>
          </td>
        </tr>

      </tbody>
    </table>
    <br/>
    <c:if test="${inEditMode}">
      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
      <ucf:button href='${param.cancelUrl}' name="Cancel" label="${ub:i18n('Cancel')}"/>
    </c:if>
    <c:if test="${inViewMode}">
      <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
    </c:if>
</div>
