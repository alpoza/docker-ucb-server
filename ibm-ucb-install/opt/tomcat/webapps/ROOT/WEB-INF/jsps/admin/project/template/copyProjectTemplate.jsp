<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:url var="submitUrl" value="${ProjectTemplateTasks.saveCopiedProjectTemplate}"/>
<c:url var="cancelUrl" value="${ProjectTemplateTasks.cancelCopyProjectTemplate}"/>
<c:url var="listUrl" value="${ProjectTemplateTasks.viewList}"/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp" />

<form method="post" action="${fn:escapeXml(submitUrl)}">
  <div style="padding-bottom: 3em;">
    <div class="popup_header">
      <ul>
        <li class="current"><a>${ub:i18n("CopyProjectTemplate")}</a></li>
      </ul>
    </div>

    <div class="contents">
      <div class="table_wrapper">
        <div style="text-align: right; border-top: 0px; vertical-align: bottom;">
          <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>
        <table class="property-table">
          <tbody>
            <c:set var="fieldName" value="name"/>
            <c:set var="name" value="${ub:i18nMessage('CopyNoun', projectTemplate.name)}"/>
            <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : name}"/>
            <error:field-error field="name" cssClass="${eo.next}" />
            <tr class="${eo.last}" valign="top">
              <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
              <td align="left" width="20%"><ucf:text name="name" value="${nameValue}" size="60"/></td>
              <td align="left"><span class="inlinehelp"></span></td>
            </tr>

            <c:set var="fieldName" value="description"/>
            <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : projectTemplate.description}"/>
            <error:field-error field="description" cssClass="${eo.next}" />
            <tr class="${eo.last}" valign="top">
              <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
              <td align="left" colspan="2"><ucf:textarea name="description" value="${descriptionValue}" />
              </td>
            </tr>

            <tr class="${eo.next}">
              <td colspan="3">
                <ucf:button name="Save" label="${ub:i18n('Save')}" />
                <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
              </td>
            </tr>
          </tbody>
        </table>
        <br /> <br />
      </div>
    </div>
  </div>
</form>

<c:import url="/WEB-INF/snippets/popupFooter.jsp" />
