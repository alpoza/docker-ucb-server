<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.security.TeamTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.TeamTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.ImportExportTasks" />

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<c:url var="iconViewUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="iconEditUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconCopyUrl" value="/images/icon_job_copy.gif"/>
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
<c:url var="iconDeleteDisabledUrl" value="/images/icon_delete_disabled.gif"/>

<c:set var="disableButtons" value="${false}"/>

<auth:checkAction var="canCreateJobs" action="${UBuildAction.JOB_CREATE}"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
        <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
        <c:set var="inViewMode" value="true"/>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/jsps/admin/config/mainConfigurationTabsHeader.jsp">
  <jsp:param name="selected" value="Job"/>
</jsp:include>

<script type="text/javascript">
    /* <![CDATA[ */
    function refresh() {
        window.location.reload();
    }
    /* ]]> */
</script>

<div class="contents">
    <br/>
    <div>
      <error:field-error field="${WebConstants.JOB_CONFIG}"/>
      <div class="component-heading">
        <div style="float: right;">
          <c:url var="createJobUrl" value="${LibraryJobConfigTasks.newJobConfig}"/>
          <ucf:link label="${ub:i18n('Create')}" href="#" onclick="showPopup('${ah3:escapeJs(createJobUrl)}', 800, 400); return false;" enabled="${canCreateJobs and !disableButtons}"/>
        </div>
        ${ub:i18n('Jobs')}
      </div>
      <table id="jobTable" class="data-table">
          <tbody>
              <tr>
                  <th scope="col" align="left" valign="middle" width="40%">${ub:i18n("Name")}</th>
                  <th scope="col" align="left" valign="middle" width="50%">${ub:i18n("Description")}</th>
                  <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
              </tr>
              <c:if test="${empty jobConfigList}">
                <tr>
                  <td colspan="3">${ub:i18n("LibraryWorkflowNoJobsMessage")}</td>
                </tr>
              </c:if>
              <c:forEach var="job" items="${jobConfigList}">
                  <auth:check var="canEdit" action="${UBuildAction.JOB_EDIT}" persistent="${job}"/>
                  <c:url var="viewJobUrl" value="${LibraryJobConfigTasks.viewJobConfig}">
                      <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${job.id}"/>
                  </c:url>
                  <c:url var="copyJobUrl" value="${LibraryJobConfigTasks.duplicateJobConfig}">
                      <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${job.id}"/>
                  </c:url>
                  <c:url var="deleteJobUrl" value="${LibraryJobConfigTasks.deleteJobConfig}">
                      <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${job.id}"/>
                  </c:url>

                  <tr bgcolor="#ffffff">
                      <td align="left" nowrap="nowrap">
                          <ucf:link href="${viewJobUrl}" label="${job.name}" enabled="${!disableButtons}"/>
                       </td>
                       <td align="left">
                           ${job.description}
                       </td>

                      <td align="center" nowrap="nowrap">
                          <c:choose>
                            <c:when test="${canEdit}">
                              <ucf:link href="${viewJobUrl}" label="${ub:i18n('Edit')}" img="${iconEditUrl}" enabled="${!disableButtons}"/>&nbsp;
                              <ucf:link href="${copyJobUrl}" label="${ub:i18n('CopyVerb')}" img="${iconCopyUrl}" enabled="${!disableButtons}"/>&nbsp;
                              <ucf:confirmlink href="${deleteJobUrl}" label="${ub:i18n('Delete')}"
                                message="${ub:i18nMessage('DeleteConfirm',job.name)}"
                                img="${iconDeleteUrl}" enabled="${!disableButtons and not job.inUse}"/>
                            </c:when>
                            <c:otherwise>
                              <ucf:link href="${viewJobUrl}" label="${ub:i18n('View')}" img="${iconViewUrl}" enabled="${!disableButtons}"/>&nbsp;
                              <img src="${iconDeleteDisabledUrl}" alt="${ub:i18n('DeleteDisabled')}" />
                            </c:otherwise>
                          </c:choose>
                      </td>
                  </tr>
              </c:forEach>
          </tbody>
      </table>
    </div>
</div>
<jsp:include page="/WEB-INF/jsps/admin/config/mainConfigurationTabsFooter.jsp" />
