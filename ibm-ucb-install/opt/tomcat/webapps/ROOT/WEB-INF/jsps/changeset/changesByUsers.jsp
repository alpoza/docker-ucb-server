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
<%@page import="com.urbancode.ubuild.reporting.sourcechange.BuildWithChanges" %>
<%@page import="com.urbancode.ubuild.reporting.sourcechange.Change"%>
<%@page import="com.urbancode.ubuild.reporting.sourcechange.ChangeSet"%>
<%@page import="com.urbancode.ubuild.web.*" %>
<%@page import="java.util.*" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.changeset.ChangeSetTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.PageState" />

<c:url var="imagesUrl" value="/images"/>
<c:set var="imagesUrl" value="${fn:escapeXml(imagesUrl)}"/>
<c:set var="clippedCommentWidth" value="60" />

<input type="hidden" id="changeSetsPageIndex" name="changeSetsPageIndex" value="${fn:escapeXml(changeSetsPage.index)}"/>
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
<c:url var="byUsersUrl" value="${ChangeSetTasks.viewWorkflowChangeSets}">
  <c:param name="workflowId" value="${workflow.id}"/>
</c:url>
    </c:when>
    <c:when test="${not empty(project)}">
<c:url var="byUsersUrl" value="${ChangeSetTasks.viewProjectChangeSets}">
  <c:param name="projectId" value="${project.id}"/>
</c:url>
    </c:when>
    <c:otherwise>
<c:url var="byUsersUrl" value="${ChangeSetTasks.viewChangeSets}">
</c:url>
    </c:otherwise>
</c:choose>

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
<br/><br/>
<ucf:button href="${byUsersUrl}" name="ChangesByBuildLife" label="${ub:i18n('ChangesByBuildLife')}"/>
<div style="float: right">
  <br/><br/>
  ${ub:i18n("From")} <input type="text" id="changeSetsStartDate" name="changeSetsStartDate" value="${fn:escapeXml(startDate)}" size="8"/>
  ${ub:i18n("To")} <input type="text" id="changeSetsEndDate" name="changeSetsEndDate" value="${fn:escapeXml(endDate)}" size="8"/>
  &nbsp; <ucf:button name="ShowChanges" label="${ub:i18n('ShowChanges')}"/><br/>
</div>
<h2>${ub:i18n('ChangesByUsers')}</h2>
<table class="data-table">

  <tr style="background: #87b5d6;">
    <th width="40"></th>
    <th>${ub:i18n("User")}</th>
    <th>${ub:i18n("Changes")} / ${ub:i18n("Description")}</th>
    <th>${ub:i18n("Build")}</th>
    <th>${ub:i18n("Date")}/${ub:i18n("Time")}</th>
  </tr>

  <c:if test="${fn:length(changeSetsPage.items) == 0}">
    <tr>
      <td colspan="5" align="left"><em>${ub:i18n("NoChanges")}</em></td>
    </tr>
  </c:if>
<%
// map the change sets by user
Map<String, List<ChangeSet> > user2changeSetList = new HashMap<String, List<ChangeSet> >();
PageState changeSetsPage = (PageState) request.getAttribute("changeSetsPage");
List<ChangeSet> items = (List<ChangeSet>) changeSetsPage.getItems();
for (int c=0; c<items.size(); c++) {
    ChangeSet changeSet = (ChangeSet) items.get(c);
    String user = changeSet.getRepositoryUser().getRepositoryUserName();
    List<ChangeSet> changeSetList = (List<ChangeSet>) user2changeSetList.get(user);
    if (changeSetList == null) {
        changeSetList = new LinkedList<ChangeSet>();
        user2changeSetList.put(user, changeSetList);
    }
    if (!changeSetList.contains(changeSet)) {
        changeSetList.add(changeSet);
    }
}

// get the users and order them
String[] users = (String[]) user2changeSetList.keySet().toArray(new String[0]);
Arrays.sort(users);

// display the results for each user
for (int u=0; u<users.length; u++) {
    String user = users[u];
    pageContext.setAttribute("user", user);

    List<ChangeSet> changeSets = (List<ChangeSet>) user2changeSetList.get(user);
    if (changeSets != null) {
        Collections.sort(changeSets);
        pageContext.setAttribute("changeSets", changeSets);

        int totalChanges = 0;
        for (int s=0; s<changeSets.size(); s++) {
            ChangeSet changeSet = (ChangeSet) changeSets.get(s);
            List<Change> changes = changeSet.getChanges();
            totalChanges += changes.size();
        }
%>

    <%-- User Row --%>
    <tr class="build">
      <td align="center" width="40"
          onclick="toggleBuild(this);">
          <span><img src="${imagesUrl}/icon_hammer.gif" height="16" width="30"/></span>
      </td>
      <td>
        <span class="build">
          ${fn:escapeXml(user)}
        </span>
      </td>
      <td class="changes" colspan="3">
        <c:choose>
          <c:when test="${fn:length(changeSets) == 0}">
            ${ub:i18n("None")}
          </c:when>
          <c:otherwise>
            ${fn:escapeXml(fn:length(changeSets))}&nbsp;${ub:i18n("ChangesLowercase")}
          </c:otherwise>
        </c:choose>,
        <%= totalChanges %>&nbsp;${ub:i18n("FilesChangedLowercase")}
      </td>
    </tr>

    <c:forEach var="changeSet" items="${changeSets}">
<%
        ChangeSet changeSet = (ChangeSet) pageContext.getAttribute("changeSet");
        StringBuffer buildIds = new StringBuffer();
        List builds = changeSet.getBuilds();
        for (int b=0; b<builds.size(); b++) {
            BuildWithChanges build = (BuildWithChanges) builds.get(b);
            if (b > 0) {
                buildIds.append(", ");
            }
            buildIds.append(build.getId());
        }
        pageContext.setAttribute("build", builds.get(0));
        pageContext.setAttribute("buildIds", buildIds.toString());

        SourceViewer sourceViewer = null;
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
%>
      <%-- Change Set Row --%>
      <tr class="change">
        <td>&nbsp;</td>
        <td onclick="toggleChangeDetail(this);">
          <span class="change">
            <span>
              <img class="plus" src="${imagesUrl}/icon_plus_sign.gif" height="16" width="16"/>
              <img class="minus" src="${imagesUrl}/icon_minus_sign.gif" height="16" width="16"/>
            </span>
            Change <c:if test="${empty revisionLink && fn:length(fn:escapeXml(changeSet.scmId))<=7}">
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

        <td>
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

        <td>
          ${fn:escapeXml(ub:i18nMessage('NounWithColon', build.project))} &nbsp;
          ${fn:escapeXml(build.workflow)} &nbsp;
          [${fn:escapeXml(buildIds)}]
        </td>

        <td class="date">
          ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, changeSet.date))}
        </td>
      </tr>

      <%-- Change Row --%>
      <tr class="changeDetail" style="display: none;">
        <td colspan="2" align="right">
          <strong>${ub:i18n("ChangeDescription")}</strong>
          <div class="viewFileList">
            <span class="view" onclick="toggleFileList(this);"
              >View Files (${fn:length(changeSet.changes)})<span
                ><img src="${imagesUrl}/icon_arrow_down.gif" height="16" width="16"
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
                        <a href="${fn:escapeXml(fileRevisionLink)}" target="srcviewer">${fn:escapeXml(change.path)}</a>
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
        <td colspan="3">
          ${ah3:htmlBreaks(fn:escapeXml(changeSet.comment))}
        </td>
      </tr>

    <%
      Properties props = changeSet.getProperties();
      if (props != null && !props.isEmpty()) {
        ArrayList propNameList = new ArrayList();
        propNameList.addAll(props.keySet());
        Collections.sort(propNameList);
        pageContext.setAttribute("propertyNames", propNameList);
    %>
    <tr class="changeDetail" style="display: none;">
      <td colspan="2" align="right">
        <strong>${ub:i18n("ChangeProperties")}</strong>
      </td>
      <td colspan="3">
        <c:forEach var="propName" items="${propertyNames}">
          <%
            String propName = (String) pageContext.getAttribute("propName");
            pageContext.setAttribute("propValue", props.getProperty(propName));
          %>
          <c:out value="${propName}"/> = <c:out value="${propValue}"/><br/>
        </c:forEach>
      </td>
    </tr>
    <%
      }
    %>

    </c:forEach>
<%
    }
}
%>

</table>
