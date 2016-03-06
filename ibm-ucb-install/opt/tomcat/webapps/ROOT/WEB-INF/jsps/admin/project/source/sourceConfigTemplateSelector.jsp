<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.SourceConfigTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:url var="submitUrl" value="${SourceConfigTasks.selectSourceConfigTemplate}"/>
<c:url var="cancelUrl" value="${SourceConfigTasks.cancelSourceConfigPopup}"/>

<c:import url="/WEB-INF/snippets/popupHeader.jsp" />

<div style="padding-bottom: 3em;">
  <div class="popup_header">
    <ul>
      <li class="current"><a>${ub:i18n("SourceConfigNewSourcefromTemplate")}</a></li>
    </ul>
  </div>

  <div class="contents">
    <br/>

    <form method="post" action="${fn:escapeXml(submitUrl)}">
      <div style="text-align: right; border-top :0px; vertical-align: bottom;">
        <span class="required-text">${ub:i18n("RequiredField")}</span>
      </div>
      <table class="property-table">
        <tbody>
          <error:field-error field="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" />
          <tr class="even" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("SourceConfigSourceTemplateWithColon")} <span class="required-text">*</span></span></span></td>
            <td align="left" width="20%">
              <ucf:idSelector name="${WebConstants.SOURCE_CONFIG_TEMPLATE_ID}" list="${sourceConfigTemplateList}" />
            </td>
            <td align="left"><span class="inlinehelp">${ub:i18n("SourceConfigSourceTemplateDesc")}</span></td>
          </tr>
        </tbody>
      </table>
      <br/>
      <ucf:button name="Select" label="${ub:i18n('Select')}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
    </form>
  </div>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp" />
    