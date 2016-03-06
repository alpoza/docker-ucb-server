<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.plugin.SourcePluginConstants" %>
<%@page import="com.urbancode.ubuild.domain.source.template.SourceConfigTemplate" %>
<%@page import="com.urbancode.ubuild.domain.workdir.*"%>
<%@page import="com.urbancode.ubuild.web.*"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.source.SourceConfigTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="submitUrl" value="${SourceConfigTasks.saveTemplatedSourceConfig}"/>
<c:url var="cancelUrl" value="${SourceConfigTasks.cancelSourceConfigPopup}"/>

<%
  //pageContext.setAttribute(WebConstants.WORK_DIR_SCRIPT_LIST, WorkDirScriptFactory.getInstance().restoreAll());
  pageContext.setAttribute("eo", new EvenOdd());
%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp" />

<div style="padding-bottom: 3em;">
  <div class="popup_header">
    <ul>
      <c:choose>
        <c:when test="${empty sourceConfig}">
          <li class="current"><a>${ub:i18n("SourceConfigNewSourcefromTemplate")}</a></li>
        </c:when>
        <c:otherwise>
          <li class="current"><a>${ub:i18nMessage("SourceConfigEditHeader", fn:escapeXml(sourceConfig.name))}</a></li>
        </c:otherwise>
      </c:choose>
    </ul>
  </div>

  <div class="contents">
    <br/>
    <div style="text-align: right; border-top :0px; vertical-align: bottom;">
      <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>

    <form method="post" action="${fn:escapeXml(submitUrl)}">
    
      <table class="property-table">
        <tbody>
          <tr class="${eo.next}">
            <td align="left" width="20%"><span class="bold">${ub:i18n("SourceConfigSourceTemplateWithColon")}</span></td>
            <td align="left" width="20%">
              ${fn:escapeXml(sourceConfigTemplate.name)}
            </td>
            <td align="left"><span class="inlinehelp">${ub:i18n("SourceConfigSourceTemplateDesc")}</span></td>
          </tr>
      
          <c:set var="fieldName" value="name"/>
          <c:set var="defaultValue" value="${empty sourceConfig or sourceConfig.new ? sourceConfigTemplate.name : sourceConfig.name}"/>
          <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : defaultValue}"/>
          <error:field-error field="name" cssClass="${eo.next}"/>
          <tr class="${eo.last}">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
            </td>
      
            <td align="left" width="20%">
              <ucf:text name="name" value="${nameValue}"/>
            </td>
      
            <td align="left">
              <span class="inlinehelp">${ub:i18n("SourceConfigNameDesc")}</span>
            </td>
          </tr>
          
          <c:set var="fieldName" value="${WebConstants.REPO_ID}"/>
          <c:set var="repositoryValue" value="${param[fieldName] != null ? param[fieldName] : sourceConfig.repository.id}"/>
          <error:field-error field="${WebConstants.REPO_ID}" cssClass="${eo.next}"/>
          <tr class="${eo.last}">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("RepositoryWithColon")} <span class="required-text">*</span></span>
            </td>
            <td align="left" width="20%">
              <ucf:idSelector name="${WebConstants.REPO_ID}"
                              list="${repository_list}"
                              selectedId="${repositoryValue}"/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("SourceConfigRepositoryDesc")}</span>
            </td>
          </tr>
        </tbody>
        
        <tbody>
          <jsp:include page="/WEB-INF/jsps/admin/project/source/editPropertiesFromSourceConfigTemplate.jsp"/>
        </tbody>
      </table>
      <br/>
      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
    </form>
  </div>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp" />