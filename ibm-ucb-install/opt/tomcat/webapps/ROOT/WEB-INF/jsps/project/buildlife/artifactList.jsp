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
<%@page import="com.urbancode.ubuild.domain.buildlife.*" %>
<%@page import="com.urbancode.ubuild.domain.profile.BuildProfile" %>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@page import="com.urbancode.ubuild.web.project.*"%>
<%@page import="com.urbancode.ubuild.web.*"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>
<ah3:useConstants class="com.urbancode.ubuild.web.project.BuildLifeTasks"/>

<c:set var="profile" value="${buildLife.profile}"/>
<c:set var="project" value="${profile.project}"/>
<c:set var="buildLifeId" value="${buildLife.id}"/>

<%
    BuildLife buildLife = (BuildLife) pageContext.findAttribute(WebConstants.BUILD_LIFE);
    BuildProfile profile = (BuildProfile) pageContext.findAttribute("profile");
    boolean canDownload = Authority.getInstance().hasPermission(buildLife.getProject(), UBuildAction.PROJECT_ARTIFACT_SET_ACCESS) ||
            Authority.getInstance().hasPermission(profile.getWorkflow(), UBuildAction.PROCESS_ARTIFACT_SET_ACCESS);
    pageContext.setAttribute("can_download", Boolean.valueOf(canDownload));
%>

<c:url var="dashboardUrl" value="${DashboardTasks.viewDashboard}"/>
<c:url var="imgUrl" value="/images"/>

<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
    <c:param name="projectId" value="${project.id}"/>
</c:url>

<%-- CONTENT --%>


<c:set var="onDocumentLoad" scope="request">
  <c:forEach var="set" items="${setList}" varStatus="loopStatus">
    isOpen${loopStatus.index}=false;
  </c:forEach>

  <c:forEach var="repo" items="${artifactRepositoryList}" varStatus="loopStatus">
    repoIsOpen${loopStatus.index}=false;
  </c:forEach>
</c:set>

<c:import url="buildLifeHeader.jsp">
    <c:param name="selected" value="artifacts"/>
</c:import>

<script type="text/javascript">
  if (navigator.appVersion.indexOf("MSIE 7.")!=-1){
    //This is an ie7 browser... fix the broken artifact tables.
    with(document) {
      write('<style type="text/css">');
      write('table{table-layout:fixed;}');
      write('</style>');
    }
  }
  if (navigator.appVersion.indexOf("MSIE 8.")!=-1){
    //This is an ie8 browser... fix the broken artifact tables.
    with(document) {
      write('<style type="text/css">');
      write('.yui-dt table{width:97%;}');
      write('</style>');
    }
  }

  isAllOpen=false;
  function expandAll() {
    if(isAllOpen) {
      document.getElementById("sign_box").src = "${fn:escapeXml(imgUrl)}/icon_plus_sign.gif";
      //hide all with foreach loop
      <c:forEach var="set" items="${setList}" varStatus="loopStatus">
        if(isOpen${loopStatus.index}) {
          toggleSet${loopStatus.index}();
        }
      </c:forEach>
      isAllOpen=false;
    }
    else {
    //show all with foreach loop
      document.getElementById("sign_box").src = "${fn:escapeXml(imgUrl)}/icon_minus_sign.gif";
      <c:forEach var="set" items="${setList}" varStatus="loopStatus">
        if(!isOpen${loopStatus.index}) {
          toggleSet${loopStatus.index}();
        }
      </c:forEach>
      isAllOpen=true;
    }
  }
</script>

<div id="artifact-set-list-page-div">
  <c:choose>
    <c:when test="${fn:length(setList) == 0 and empty artifactRepositoryList}">
      <br/>
      ${ub:i18n("NoArtifactsOnBuildLife")}
    </c:when>
    <c:otherwise>
      <c:if test="${fn:length(setList) != 0}">
        <br/>
        <table id="whole-artifact-set-table" width="100%" class="data-table">
          <tr>
            <th scope="col" width="3%">
              <img id="sign_box" alt="" onclick="expandAll()" class="clickable"
                   src="${fn:escapeXml(imgUrl)}/icon_plus_sign.gif"
              />
            </th>
            <th scope="col" width="30%" style="text-align: left;">${ub:i18n("ArtifactSet")}</th>
            <c:if test="${can_download}">
              <th scope="col" align="left">${ub:i18n("DownloadAll")}</th>
            </c:if>
          </tr>
          <c:forEach var="set" items="${setList}" varStatus="loopStatus">
            <c:url var="downloadAllUrl" value="${BuildLifeTasks.downloadAllFiles}">
              <c:param name="buildLifeId" value="${buildLife.id}"/>
              <c:param name="setName" value="${set}"/>
            </c:url>
            <c:url var="downloadFileNameUrl" value="${BuildLifeTasks.downloadFile}">
              <c:param name="buildLifeId" value="${buildLife.id}"/>
              <c:param name="setName" value="${set}"/>
            </c:url>
            <c:url var="viewFileNameUrl" value="${BuildLifeTasks.viewFile}">
              <c:param name="buildLifeId" value="${buildLife.id}"/>
              <c:param name="setName" value="${set}"/>
            </c:url>
            <tr>
              <td align="center" style="border-bottom:0">
                <script type="text/javascript">
                  function toggleSet${loopStatus.index}()
                  {
                    if(isOpen${loopStatus.index}) {
                      document.getElementById("sign_box${loopStatus.index}").src = "${fn:escapeXml(imgUrl)}/icon_plus_sign.gif";
                      $('artTable${loopStatus.index}').hide();
                      isOpen${loopStatus.index}=false;
                    }
                    else {
                      $('artTable${loopStatus.index}').style.display = "";
                      document.getElementById("sign_box${loopStatus.index}").src = "${fn:escapeXml(imgUrl)}/icon_minus_sign.gif";
                      isOpen${loopStatus.index}=true;
                    }
                  }
                </script>
                <img id="sign_box${loopStatus.index}" alt="" onclick="toggleSet${loopStatus.index}()" class="clickable"
                    src="${fn:escapeXml(imgUrl)}/icon_plus_sign.gif"
                />
              </td>
              <td style="border-bottom:0" align="left">${ub:i18n(set)}</td>
              <c:if test="${can_download}">
                <td style="border-bottom:0">
                   &nbsp;&nbsp;&nbsp;
                     <small>
                       <a href="${fn:escapeXml(downloadAllUrl)}"><img
                          src="${fn:escapeXml(imgUrl)}/icon_download.gif" alt="" border="0"
                          />&nbsp;${ub:i18n("DownloadAllZip")}</a>
                     </small>
                </td>
              </c:if>
            </tr>
            <tbody id="artTable${loopStatus.index}" style="display:none">
              <tr>
                <td colspan="${can_download ? '3' : '2'}" style="padding-left:2%; padding-right:2%; border-top:0; background:url(${fn:escapeXml(imgUrl)}/artifactset_shadow.gif) repeat-x top #eef2f6">
                  <c:set var="artifactsTableId" value="artifactTable${loopStatus.index}"/>
                  <div id="${artifactsTableId}"></div>
                  <script type="text/javascript">
                    require(["ubuild/module/UBuildApp", "ubuild/table/BuildArtifactsTable"], function(UBuildApp, BuildArtifactsTable) {
                      UBuildApp.util.i18nLoaded.then(function() {
                        var table = new BuildArtifactsTable({
                          artifactType: "artifactSets",
                          artifactSetId: "${set}",
                          buildLifeId: ${buildLife.id},
                          viewFileUrl: "${viewFileNameUrl}&filePath=",
                          downloadSingleArtifactUrl: "${downloadFileNameUrl}&filePath=",
                          downloadAllArtifactsUrl: "${downloadAllUrl}",
                          canDownload: ${can_download},
                          dateFormat: "${dateFormat}"
                        });
                        table.placeAt("${artifactsTableId}");
                      });
                    });
                  </script>
                </td>
              </tr>
            </tbody>
          </c:forEach>
        </table>
      </c:if>

      <c:if test="${not empty artifactRepositoryList}">
        <br/>
        <table id="repository-artifacts-table" width="100%" class="data-table">
          <tr>
            <th scope="col" width="3%"></th>
            <th scope="col" width="30%" style="text-align: left;">${ub:i18n("ArtifactRepository")}</th>
            <c:if test="${can_download}">
              <th scope="col" align="left">${ub:i18n("DownloadAll")}</th>
            </c:if>
          </tr>
          <c:forEach var="repo" items="${artifactRepositoryList}" varStatus="loopStatus">
            <tr>
              <td align="center" style="border-bottom:0">
                <script type="text/javascript">
                  function repoToggleSet${loopStatus.index}()
                  {
                    if(repoIsOpen${loopStatus.index}) {
                      document.getElementById("repo_sign_box${loopStatus.index}").src = "${fn:escapeXml(imgUrl)}/icon_plus_sign.gif";
                      $('repoArtTable${loopStatus.index}').hide();
                      repoIsOpen${loopStatus.index}=false;
                    }
                    else {
                      $('repoArtTable${loopStatus.index}').style.display = "";
                      document.getElementById("repo_sign_box${loopStatus.index}").src = "${fn:escapeXml(imgUrl)}/icon_minus_sign.gif";
                      repoIsOpen${loopStatus.index}=true;
                    }
                  }
                </script>
                <img id="repo_sign_box${loopStatus.index}" alt="" onclick="repoToggleSet${loopStatus.index}()" class="clickable"
                     src="${fn:escapeXml(imgUrl)}/icon_plus_sign.gif"
                />
              </td>
              <td style="border-bottom:0" align="left">${repo.name}</td>
              <c:if test="${can_download and not empty repo.downloadAllArtifactsUrl}">
                <c:url var="downloadAllUrl" value="${repo.downloadAllArtifactsUrl}"/>
                <td style="border-bottom:0">
                  &nbsp;&nbsp;&nbsp;
                  <small>
                    <a href="${fn:escapeXml(downloadAllUrl)}"><img
                        src="${fn:escapeXml(imgUrl)}/icon_download.gif" alt="" border="0"
                    />&nbsp;${ub:i18n("DownloadAllZip")}</a>
                  </small>
                </td>
              </c:if>
            </tr>
            <tbody id="repoArtTable${loopStatus.index}" style="display:none">
              <tr>
                <td colspan="${can_download ? '3' : '2'}" style="padding-left:2%; padding-right:2%; border-top:0; background:url(${fn:escapeXml(imgUrl)}/artifactset_shadow.gif) repeat-x top #eef2f6">
                  <c:set var="repoArtifactsTableId" value="${fn:escapeXml(repo.name)}-repository"/>
                  <div id="${repoArtifactsTableId}"></div>
                  <script type="text/javascript">
                    require(["ubuild/module/UBuildApp", "ubuild/table/BuildArtifactsTable"], function(UBuildApp, BuildArtifactsTable) {
                      UBuildApp.util.i18nLoaded.then(function() {
                        var table = new BuildArtifactsTable({
                          artifactType: "artifactRepositories",
                          artifactSetId: "${repo.id}",
                          buildLifeId: ${buildLife.id},
                          viewFileUrl: "${repo.downloadSingleArtifactUrl}",
                          downloadSingleArtifactUrl: "${repo.downloadSingleArtifactUrl}",
                          downloadAllArtifactsUrl: "${repo.downloadAllArtifactsUrl}",
                          canDownload: ${can_download},
                          dateFormat: "${dateFormat}"
                        });
                        table.placeAt("${repoArtifactsTableId}");
                      });
                    });
                  </script>
                </td>
              </tr>
            </tbody>
          </c:forEach>
        </table>
      </c:if>
    </c:otherwise>
  </c:choose>
  <br/>
  <br/>
</div>

<c:import url="buildLifeFooter.jsp"/>
