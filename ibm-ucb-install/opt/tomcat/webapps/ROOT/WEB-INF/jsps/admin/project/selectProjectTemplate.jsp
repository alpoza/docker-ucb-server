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

<%@page import="com.urbancode.ubuild.domain.project.template.ProjectTemplateFactory" %>
<%@page import="com.urbancode.ubuild.web.*" %>

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.project.ProjectTasks" id="ProjectTasksConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ProjectTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="submitUrl" value="${ProjectTasks.newProject}"/>
<c:url var="cancelUrl" value="${ProjectTasks.cancelNewProject}"/>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<form method="post" action="${fn:escapeXml(submitUrl)}">
    <div class="popup_header">
        <ul>
            <li class="current">
                <a>${ub:i18n("NewProject")}</a>
            </li>
        </ul>
    </div>

    <div class="contents">
        <div class="system-helpbox">${ub:i18n("ProjectCreationSelectTemplateSystemHelpBox")}</div>
        <br/>
        <div style="text-align: right; border-top :0px; vertical-align: bottom;">
          <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>
        <div class="table_wrapper">
          <table class="property-table">
            <tbody>
              <tr>
                <td align="left" width="15%">
                  <span class="bold">${ub:i18n("TemplateWithColon")} <span class="required-text">*</span></span>
                </td>
                <td align="left" colspan="2">
                  <% pageContext.setAttribute("projectTemplateList", ProjectTemplateFactory.getInstance().restoreAllActive()); %>
                  <ucf:idSelector name="${WebConstants.PROJECT_TEMPLATE_ID}" list="${projectTemplateList}"/>
                </td>
              </tr>
            </tbody>
          </table>
          <br/>
          <ucf:button name="Select" label="${ub:i18n('Select')}"/>
          <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
          <br/>
          <br/>
        </div>
    </div>
</form>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
