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
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.codestation2.CodestationTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.codestation2.CodestationTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<c:url var="iconEditUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

<c:set var="disableButtons" value="${team != null}"/>

<auth:checkAction var="canCreateCodestationProjects" action="${UBuildAction.CODESTATION_CREATE}"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
        <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
        <c:set var="inViewMode" value="true"/>
    </c:otherwise>
</c:choose>

<c:import url="/WEB-INF/snippets/header.jsp">
    <c:param name="title"    value="${ub:i18n('CodeStation')}"/>
    <c:param name="selected" value="codestation"/>
    <c:param name="disabled" value="${disableButtons}"/>
</c:import>

<div >
    <div class="tabManager" id="secondLevelTabs">
      <c:url var="viewCodestationUrl" value="${CodestationTasks.viewList}"/>
      <ucf:link href="${viewCodestationUrl}" klass="selected tab" label="${ub:i18n('CodeStation')}" enabled="${false}"/>
    </div>
    <div class="contents">
        <c:if test="${canCreateCodestationProjects}">
          <div id="createBtnDiv" style="margin-top:1em;">
              <c:url var="createCodestationUrl" value="${CodestationTasks.newCodestationProject}"/>
              <ucf:button href="${createCodestationUrl}" name="Create" label="${ub:i18n('CreateCodeStationProject')}" enabled="${!disableButtons}"/>
          </div>
        </c:if>
        <br />
        <table id="codestationProjectTable" class="data-table">
            <tbody>
                <tr>
                    <th scope="col" align="left" valign="middle" width="40%">${ub:i18n("Name")}</th>
                    <th scope="col" align="left" valign="middle" width="50%">${ub:i18n("Description")}</th>
                    <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
                </tr>
                <c:if test="${empty codestationProjectList}">
                  <tr>
                    <td colspan="3">${ub:i18n("NoCodeStationProjects")}</td>
                  </tr>
                </c:if>
                <c:forEach var="project" items="${codestationProjectList}">
                    <auth:check persistent="project" var="canEditOrDeleteCodestation" action="${UBuildAction.PROJECT_TEMPLATE_EDIT}"/>

                    <c:url var="viewProjectUrl" value="${CodestationTasks.viewCodestationProject}">
                        <c:param name="${WebConstants.CODESTATION_PROJECT_ID}" value="${project.id}"/>
                    </c:url>

                    <tr bgcolor="#ffffff">
                        <td align="left" nowrap="nowrap">
                            <ucf:link href="${viewProjectUrl}" label="${project.name}" enabled="${!disableButtons}"/>
                         </td>
                         <td align="left">
                             ${fn:escapeXml(project.description)}
                         </td>

                        <td align="center" nowrap="nowrap">
                            <ucf:link href="${viewProjectUrl}" label="${ub:i18n('Edit')}" img="${iconEditUrl}" enabled="${!disableButtons}"/>
                            <c:if test="${canEditOrDeleteCodestation}">
                              <c:url var="deleteCodestationUrl" value="${CodestationTasks.deleteCodestationProject}">
                                  <c:param name="${WebConstants.CODESTATION_PROJECT_ID}" value="${project.id}"/>
                              </c:url>
                              &nbsp;<ucf:confirmlink href="${deleteCodestationUrl}" label="${ub:i18n('DeleteProject')}"
                                message="${ub:i18nMessage('DeleteConfirm', project.name)}"
                                img="${iconDeleteUrl}" enabled="${!disableButtons}"/>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <br/>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
