<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.repository.Repository" %>
<%@page import="com.urbancode.ubuild.domain.repository.SourceViewer" %>
<%@page import="com.urbancode.ubuild.domain.buildlife.BuildLife" %>
<%@page import="com.urbancode.ubuild.domain.buildlife.BuildLifeFactory" %>
<%@page import="com.urbancode.ubuild.reporting.sourcechange.Change"%>
<%@page import="com.urbancode.ubuild.reporting.sourcechange.ChangeSet"%>
<%@page import="com.urbancode.ubuild.reporting.sourcechange.BuildWithChanges" %>
<%@page import="java.util.Properties" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Collections" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Properties" %>
<%@page import="java.util.TreeMap" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:url var="imagesUrl" value="/images"/>
<c:set var="imagesUrl" value="${fn:escapeXml(imagesUrl)}"/>
<c:set var="clippedCommentWidth" value="60" />

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.changeset.ChangeSetTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<input type="hidden" id="changeSetsPageIndex" name="changeSetsPageIndex" value="${changeSetsPage.index}"/>
<input type="hidden" id="changeSetsPageDirection" name="changeSetsPageDirection" value=""/>

<script type="text/javascript">
    function toChangeSetsPage(page) {
        var form = document.getElementById("changeSetsForm");
        var buildPage = document.getElementById("changeSetsPageIndex");
        buildPage.value = page;
        form.submit();
    }
</script>

<c:choose>
    <c:when test="${not empty(workflow)}">
<c:url var="byUsersUrl" value="${ChangeSetTasks.viewWorkflowChangeSetsByUsers}">
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>
    </c:when>
    <c:when test="${not empty(project)}">
<c:url var="byUsersUrl" value="${ChangeSetTasks.viewProjectChangeSetsByUsers}">
  <c:param name="projectId" value="${project.id}"/>
</c:url>
    </c:when>
    <c:otherwise>
<c:url var="byUsersUrl" value="${ChangeSetTasks.viewChangeSetsByUsers}">
</c:url>
    </c:otherwise>
</c:choose>
<br/>
<br/>
<ucui:carousel id="changes" currentPage="${changeSetsPage.index}" numberOfPages="${changeSetsPage.count}" methodName="toChangeSetsPage"/>
<ucf:button name="ChangesByUsers" label="${ub:i18n('ChangesByUsers')}" href="${byUsersUrl}"/>
<c:set var="startDate" value="${ah3:formatDate(shortDateTimeFormat, changeSetsPage.startDate)}"/>
<c:set var="endDate" value="${ah3:formatDate(shortDateTimeFormat, changeSetsPage.endDate)}"/>
<%
    String startDate = (String) pageContext.getAttribute("startDate");
    String endDate = (String) pageContext.getAttribute("endDate");
    startDate = startDate.substring(0, startDate.indexOf(" "));
    endDate = endDate.substring(0, endDate.indexOf(" "));
    pageContext.setAttribute("startDate", startDate);
    pageContext.setAttribute("endDate", endDate);
%>
<div style="float: right">
  <br/><br/>
  ${ub:i18n("From")} <input type="text" id="changeSetsStartDate" name="changeSetsStartDate" value="${fn:escapeXml(startDate)}" size="8"/>
  ${ub:i18n("To")} <input type="text" id="changeSetsEndDate" name="changeSetsEndDate" value="${fn:escapeXml(endDate)}" size="8"/>
  &nbsp; <ucf:button name="ShowChanges" label="${ub:i18n('ShowChanges')}"/><br/>
</div>
<h2>${ub:i18n('ChangesByBuildLife')}</h2>
<table class="data-table">
  <thead>
    <tr style="background: #87b5d6;">
      <th width="40"></th>
      <th width="10%">${ub:i18n("Build")}</th>
      <th class="result" width="10%">${ub:i18n("Result")}</th>
      <th class="description">${ub:i18n("Project")} / ${ub:i18n("Description")}</th>
      <th class="changes" width="5%">${ub:i18n("Changes")}</th>
      <th class="user">${ub:i18n("User")}</th>
      <th class="date">${ub:i18n("Date")}/${ub:i18n("Time")}</th>
    </tr>
  </thead>

  <tbody>
    <c:if test="${changeSetsPage.count == 0}">
      <tr>
        <td colspan="7" align="left"><em>${ub:i18n("NoChanges")}</em></td>
      </tr>
    </c:if>

  <c:forEach var="build" items="${changeSetsPage.items}">
    <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
      <c:param name="buildLifeId" value="${build.id}"/>
    </c:url>
    <c:set var="buildLifeUrl" value="${fn:escapeXml(buildLifeUrl)}"/>

    <tr class="build">
      <td align="center" width="40" onclick="toggleBuild(this);">
          <span><img src="${imagesUrl}/icon_hammer.gif" height="16" width="30" alt=""/></span>
      </td>
      <td>
        <span class="build">
          <a href="${fn:escapeXml(buildLifeUrl)}">${fn:escapeXml(build.stamp)}
          <c:if test="${empty build.stamp}">(ID: ${fn:escapeXml(build.id)})</c:if></a>
        </span>
      </td>
      <td nowrap="nowrap" align="center" class="result"
        style="background: ${fn:escapeXml(build.status.color)}; color: ${fn:escapeXml(build.status.secondaryColor)};">
        <c:choose>
        <c:when test="${build.status.name == 'Failed' || build.status.name == 'Error'}">
          <c:url var="errorsUrl" value="${BuildLifeTasks.viewErrors}">
            <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${build.id}"/>
          </c:url>
          <a href="javascript:showPopup('${ah3:escapeJs(errorsUrl)}', 800, 600);" title="${ub:i18n('ClickToViewErrors')}"
             style="color: black; text-decoration: underline;">${fn:escapeXml(build.status.name)}</a>
        </c:when>
        <c:otherwise>${fn:escapeXml(build.status.name)}</c:otherwise>
        </c:choose>
      </td>
      <td class="">
        ${fn:escapeXml(ub:i18nMessage('NounWithColon', build.project))} &nbsp;
        ${fn:escapeXml(build.workflow)}
      </td>

      <td class="changes" style="text-align: center;">
        <c:choose>
          <c:when test="${fn:length(build.changeSets) == 0}">
            ${ub:i18n("None")}
          </c:when>
          <c:otherwise>
            ${fn:escapeXml(fn:length(build.changeSets))}
          </c:otherwise>
        </c:choose>
      </td>
      <td></td>
      <td></td>
    </tr>

    <c:forEach var="changeSet" items="${build.changeSets}">
      <%
            SourceViewer sourceViewer = null;
            BuildWithChanges justBuild = (BuildWithChanges) pageContext.getAttribute("build");
            // BuildLife looks unused
//            BuildLife build = BuildLifeFactory.getInstance().restore(justBuild.getId());
            ChangeSet changeSet = (ChangeSet) pageContext.findAttribute("changeSet");
            // RepositoryChangeSet repoChangeSet = RepositoryChangeSetFactory.getInstance().restore(changeSet.getDbId());
            Repository repository = changeSet.getRepositoryUser().getRepository().getDbRepository();
            if (repository != null && repository.hasSourceViewer()) {
                sourceViewer = repository.getSourceViewer();
                if (sourceViewer.hasRevisions()) {
                    String revisionLink = sourceViewer.getRevisionLink(repository, changeSet.getChangeSetId());
                    pageContext.setAttribute("revisionLink", revisionLink);
                }
                else {
                    pageContext.setAttribute("revisionLink", null);
                }
            }
            else {
                sourceViewer = null;
                pageContext.setAttribute("revisionLink", null);
            }
            pageContext.setAttribute("repository", repository);
           %>

      <tr class="change">
        <td>&nbsp;</td>
        <td colspan="2" onclick="toggleChangeDetail(this);">
          <span class="change">
            <span>
              <img class="plus" src="${imagesUrl}/icon_plus_sign.gif" height="16" width="16" alt="+"/>
              <img class="minus" src="${imagesUrl}/icon_minus_sign.gif" height="16" width="16" alt="-"/>
            </span>
            ${fn:escapeXml(repository.name)}
            &nbsp;<c:if test="${empty revisionLink && fn:length(fn:escapeXml(changeSet.scmId))<=7}">
                 ${fn:escapeXml(changeSet.scmId)}
               </c:if>
               <c:if test="${empty revisionLink && fn:length(fn:escapeXml(changeSet.scmId))>7}">
                 <span title="${fn:escapeXml(changeSet.scmId)}">${fn:substring(fn:escapeXml(changeSet.scmId), 0, 7)}...</span>
               </c:if>
               <c:if test="${!empty revisionLink && fn:length(fn:escapeXml(changeSet.scmId))<=7}">
                 <a href="${fn:escapeXml(revisionLink)}" target="srcviewer">${fn:escapeXml(changeSet.scmId)}</a>
               </c:if>
               <c:if test="${!empty revisionLink && fn:length(fn:escapeXml(changeSet.scmId))>7}">
                 <a href="${fn:escapeXml(revisionLink)}" target="srcviewer" title="${fn:escapeXml(changeSet.scmId)}">${fn:substring(fn:escapeXml(changeSet.scmId), 0, 7)}...</a>
               </c:if>
          </span>
        </td>

        <td colspan="2">
          <div class="description">
            <c:choose>
              <c:when test="${fn:length(changeSet.comment) lt clippedCommentWidth}">
                ${fn:escapeXml(changeSet.comment)}
              </c:when>

              <c:otherwise>
                ${fn:escapeXml(fn:substring(changeSet.comment, 0, clippedCommentWidth))}&hellip;
              </c:otherwise>
            </c:choose>
          </div>
        </td>

        <td class="user">${fn:escapeXml(changeSet.repositoryUser.repositoryUserName)}</td>

        <td class="date">
          ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, changeSet.date))}
        </td>
      </tr>

      <tr class="changeDetail" style="display: none;">
        <td colspan="3" align="right">
          <strong>${ub:i18n("ChangeDescription")}</strong>
          <br/>
          <div class="viewFileList">
            <span class="view" onclick="toggleFileList(this);"
              >View Files (${fn:length(changeSet.changes)})<span><img
              src="${imagesUrl}/icon_arrow_down.gif" height="16" width="16" alt="${ub:i18n('Show')}/${ub:i18n('Hide')}"
              /></span
            ></span>

            <div class="fileList">
              <table>
                <c:forEach var="change" varStatus="changeStatus" items="${changeSet.changes}" >
                  <c:choose>
                    <c:when test="${changeStatus.first and changeStatus.last}">
                      <c:set var="rowClass" value="first last" />
                    </c:when>

                    <c:when test="${changeStatus.first}">
                      <c:set var="rowClass" value="first" />
                    </c:when>

                    <c:when test="${changeStatus.last}">
                      <c:set var="rowClass" value="last" />
                    </c:when>

                    <c:otherwise>
                      <c:set var="rowClass" value="" />
                    </c:otherwise>
                  </c:choose>

                  <tr class="${rowClass}">
                    <td class="change">
                      ${fn:escapeXml(change.changeType)}
                    </td>

                   <%
                      if (sourceViewer != null && changeSet != null) {
                          Change change = (Change) pageContext.getAttribute("change");
                          String fileRevisionLink = sourceViewer.getFileRevisionLink(repository, change.getChangePath(), changeSet.getChangeSetId());
                          pageContext.setAttribute("fileRevisionLink", fileRevisionLink);
                      }
                      else {
                          pageContext.setAttribute("fileRevisionLink", null);
                      }

                    %>
                    <td>
                      <c:if test="${empty fileRevisionLink}">
                        ${fn:escapeXml(change.changePath)}
                      </c:if>
                      <c:if test="${!empty fileRevisionLink}">
                        <a href="${fn:escapeXml(fileRevisionLink)}" target="srcviewer">${fn:escapeXml(change.changePath)}</a>
                      </c:if>
                    </td>

                    <c:if test="${!empty change.revisionNumber}">
                      <td class="change">
                        ${fn:escapeXml(change.revisionNumber)}
                      </td>
                    </c:if>
                  </tr>
                </c:forEach>
              </table>
            </div>
          </div>
        </td>
        <td colspan="4">
          ${ah3:htmlBreaks(fn:escapeXml(changeSet.comment))}
        </td>
      </tr>

     <%
        Properties props = changeSet.getProperties();
        if (props != null && !props.isEmpty()) {
          TreeMap<Object,Object> sortedProps = new TreeMap<Object,Object>();
          sortedProps.putAll(props);
          pageContext.setAttribute("map", sortedProps);
      %>
      <tr class="changeDetail" style="display: none;">
        <td colspan="3" align="right">
          <strong>${ub:i18n("ChangeProperties")}</strong>
        </td>
        <td colspan="2">
          <c:forEach var="prop" items="${map}">
            <c:out value="${prop.key}"/> = <c:out value="${prop.value}"/><br/>
          </c:forEach>
        </td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <%
        }
      %>

    </c:forEach>
  </c:forEach>
  </tbody>
</table>
