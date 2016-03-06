<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.project.ProjectTasks"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.template.SourceConfigTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:url var="submitUrl" value="${SourceConfigTemplateTasks.selectSourceConfigType}"/>

<c:set var="inEditMode" value="true"/>

<jsp:include page="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
  <ul>
    <li class="current"><a>${ub:i18n("SourceConfigTemplateNew")}</a></li>
  </ul>
</div>

<div class="contents">
  <div class="system-helpbox">${ub:i18n("SourceConfigTemplateSelection")}</div>
  <br />
  <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>

  <form method="post" action="${fn:escapeXml(submitUrl)}">
  
    <table class="property-table">
      <tbody>
        <error:field-error field="${WebConstants.PLUGIN_ID}" />
        <tr class="even" valign="top">
          <td align="left" width="20%"><span class="bold">${ub:i18n("SourceType")} <span class="required-text">*</span></span></td>
    
          <td align="left" width="20%">
            <ucf:idSelector name="${WebConstants.PLUGIN_ID}" list="${pluginList}" />
          </td>
    
          <td align="left"><span class="inlinehelp">${ub:i18n("SourceTypeDesc")}</span></td>
        </tr>
    
        <tr class="odd">
          <td colspan="3">
            <ucf:button name="Select" label="${ub:i18n('Select')}"/>
            <c:url var="cancelUrl" value="${SourceConfigTemplateTasks.cancelSourceConfigTemplate}" />
            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</div>

<jsp:include page="/WEB-INF/snippets/popupFooter.jsp"/>
