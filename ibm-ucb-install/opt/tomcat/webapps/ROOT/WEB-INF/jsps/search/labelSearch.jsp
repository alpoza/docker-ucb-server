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
<%@ page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@ page import="com.urbancode.ubuild.domain.project.*"%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@ page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@ page import="com.urbancode.ubuild.domain.security.SystemFunction"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks"%>
<%@ page import="com.urbancode.ubuild.dashboard.StatusSummary"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.jobs.JobTasks"%>
<%@ page import="com.urbancode.ubuild.web.project.*"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>
<%@taglib prefix="ub" uri="http://www.urbancode.com/ubuild/tags"%>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.search.SearchTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:import url="/WEB-INF/jsps/search/_header.jsp">
  <c:param name="selected" value="labelSearch" />
</c:import>

<c:url var="imgUrl" value="/images" />
<c:url var="iconAddUrl" value="/images/icon_add.gif" />
<c:url var="iconReplaceUrl" value="/images/icon_migrate.gif" />
<c:url var="iconDeleteUrl" value="/images/icon_delete.gif" />
<c:url var="iconDeleteSmallUrl" value="/images/icon_delete_small.gif" />

<%
    EvenOdd eo = new EvenOdd();
    pageContext.setAttribute("eo", eo);
    pageContext.setAttribute("canLabel", SystemFunction.hasPermission(UBuildAction.MANUALLY_ADD_STAMP));
%>

<c:if test="${canLabel}">
  <script type="text/javascript">
    /* <![CDATA[ */
    function toggleAll(checkbox) {
        var _checkbox = $(checkbox);
        var checked = _checkbox.checked;
        $$('input[name^=${WebConstants.BUILD_LIFE_ID}]').each(
                function(blcheckbox) {
                    blcheckbox.checked = checked;
                });
    }

    <c:url var="labelAssignUrl" value="${SearchTasks.assignLabels}"/>
    function assignLabel() {
        var form = $('labelActionForm');
        var label = $('newLabel').value ? $('newLabel').value
                : $('existingLabelId').value;
        if (label) {
            if (basicConfirm(util.i18n('LabelSearchAssignLabelConfirm', label))) {
                form.action = '${fn:escapeXml(labelAssignUrl)}';
                form.submit();
            }
        } else {
            alert("${ub:i18n('LabelSearchAssignLabelError')}");
        }
    }

    <c:url var="labelDeleteUrl" value="${SearchTasks.deleteLabels}"/>
    function deleteLabel() {
        var form = $('labelActionForm');
        if (basicConfirm(i18n('LabelSearchDeleteLabelConfirm', '${label.name}'))) {
            form.action = '${fn:escapeXml(labelDeleteUrl)}';
            form.submit();
        }
    }

    <c:url var="labelReplaceUrl" value="${SearchTasks.replaceLabels}"/>
    function replaceLabel() {
        var form = $('labelActionForm');
        var label = $('newLabel').value ? $('newLabel').value
                : $('existingLabelId').value;
        if (label) {
            if (basicConfirm(i18n('LabelSearchReplaceLabelConfirm', '${label.name}', label))) {
                form.action = '${fn:escapeXml(labelReplaceUrl)}';
                form.submit();
            }
        } else {
            alert(i18n('LabelSearchReplaceLabelError'));
        }
    }
    /* ]]> */
  </script>
</c:if>
<div class="system-helpbox">${ub:i18n("LabelSearchHelp")}</div>
<br />

<c:url var="searchUrl" value="${SearchTasks.viewLabels}" />
<form method="post" action="${fn:escapeXml(searchUrl)}">
  <table style="margin-bottom: 1em;" class="property-table">
    <tbody>
      <tr class="even" valign="top">
        <td align="left" width="15%"><span class="bold">${ub:i18n("LabelWithColon")} </span></td>
        <td align="left" width="20%"><ucf:idSelector name="${WebConstants.LABEL_ID}" list="${labelList}"
            selectedId="${param.labelId}" /></td>
        <td align="left"><span class="inlinehelp">&nbsp;</span></td>
      </tr>
    </tbody>
  </table>
  <ucf:button name="search" label="${ub:i18n('Search')}" />
</form>

<c:if test="${not empty sessionScope.labelSearchMessage}">
  <br />
  <div id="labelActionNote" class="note">
    <strong>${fn:escapeXml(labelSearchMessage)}</strong> &nbsp;&nbsp;
    <ucf:link href="#" label="${ub:i18n('Close')}" img="${iconDeleteSmallUrl}" onclick="$('labelActionNote').remove(); return false;" />
  </div>
  <c:remove var="labelSearchMessage" scope="session" />
</c:if>

<form id="labelActionForm" method="post" action="#">
  <ucf:hidden name="${WebConstants.LABEL_ID}" value="${param.labelId}"/>

  <c:if test="${buildLifeList != null}">
    <c:if test="${canLabel}">
      <div style="margin: 10px 0px;">
        <table>
          <tr>
            <td><label for="conf_filter_input"><b>${ub:i18n("NewLabel")}</b></label></td>
            <td><label for="conf_status_input"><b>${ub:i18n("ExistingLabel")}</b></label></td>
            <td><span class="bold">${ub:i18n("ActionsWithColon")}</span></td>
          </tr>
          <tr>
            <td><ucf:text id="newLabel" name="newLabel" value="" size="20" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td><ucf:idSelector id="existingLabelId" name="existingLabelId" list="${labelList}"
                excludedId="${param.labelId}" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td><ucf:link href="#" label="${ub:i18n('Assign Label')}" img="${iconAddUrl}"
                onclick="assignLabel(); return false;" /> &nbsp; <ucf:link href="#" label="${ub:i18n('ReplaceLabel')}"
                img="${iconReplaceUrl}" onclick="replaceLabel(); return false;" /> &nbsp; <ucf:link href="#"
                label="${ub:i18n('RemoveLabel')}" img="${iconDeleteUrl}" onclick="deleteLabel(); return false;" />
              &nbsp; <span id="confSelected"></span></td>
          </tr>
        </table>
      </div>
    </c:if>

    <table class="data-table" width="100%">
      <tbody>
        <tr>
          <c:if test="${canLabel}">
            <th scope="col" align="center" valign="middle"><input type="checkbox" name="checkAll"
              onchange="toggleAll(this);" /></th>
          </c:if>
          <th scope="col" align="left" valign="middle">${ub:i18n("Project")}</th>
          <th scope="col" align="left" valign="middle">${ub:i18n("Build")}</th>
          <th scope="col" align="left" valign="middle">${ub:i18n("DateCreated")}</th>
          <th scope="col" align="center" valign="middle">${ub:i18n("LatestStatus")}</th>
          <th scope="col" align="left" valign="middle">${ub:i18n("Labels")}</th>
        </tr>

        <c:forEach var="buildLife" items="${buildLifeList}">
          <c:url var="viewBuildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
            <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${buildLife.id}" />
          </c:url>

          <c:url var="viewProcessUrl" value="${WorkflowTasks.viewDashboard}">
            <c:param name="workflowId" value="${buildLife.originatingWorkflow.workflow.id}" />
          </c:url>

          <tr class="${eo.next}">
            <c:if test="${canLabel}">
              <td scope="col" align="center" valign="middle"><input type="checkbox"
                name="${WebConstants.BUILD_LIFE_ID}" value="${buildLife.id}" /></td>
            </c:if>
            <td align="left" nowrap="nowrap"><a href="${fn:escapeXml(viewProcessUrl)}"> <c:out
                  value="${buildLife.profile.projectAndWorkflowName}" default="${ub:i18n('N/A')}" />
            </a></td>
            <td align="left" nowrap="nowrap"><c:if test="${buildLife.inactive}">
                <img alt="${ub:i18n('Inactivate')}" src="${fn:escapeXml(imgUrl)}/tombstone-small.png">
              </c:if> <a href="${fn:escapeXml(viewBuildLifeUrl)}"> <c:choose>
                  <c:when test="${not empty buildLife.latestStampValue}">
                    <c:out value="${buildLife.latestStampValue}" />
                  </c:when>
                  <c:otherwise>
                    <c:out value="${buildLife.id}" />
                  </c:otherwise>
                </c:choose>
            </a></td>
            <td align="left" nowrap="nowrap">${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, buildLife.startDate))}
            </td>
            <td align="center" nowrap="nowrap" style="background: ${buildLife.latestStatus.status.color};"><c:out
                value="${ub:i18n(buildLife.latestStatusName)}" default="${ub:i18n('N/A')}" /></td>
            <td align="left" nowrap="nowrap"><c:forEach var="label" items="${buildLife.labelArray}">
                <div>
                  <c:out value="${label.label.name}" />
                </div>
              </c:forEach></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>
</form>
<c:import url="/WEB-INF/jsps/search/_footer.jsp" />
