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
<%@page import="com.urbancode.ubuild.domain.artifacts.*" %>
<%@page import="com.urbancode.ubuild.domain.buildlife.BuildLifeFactory" %>
<%@page import="com.urbancode.ubuild.domain.persistent.Handle" %>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@page import="com.urbancode.ubuild.domain.singleton.serversettings.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@page import="com.urbancode.codestation2.domain.buildlife.CodestationBuildLife"%>
<%@page import="com.urbancode.codestation2.domain.project.CodestationProject" %>
<%@page import="com.urbancode.ubuild.codestation.CodestationCompatibleArtifactSet"%>
<%@page import="com.urbancode.ubuild.codestation.CodestationFileAccess" %>
<%@page import="java.io.File" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Date" %>
<%@page import="java.util.HashSet" %>
<%@page import="java.util.List" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${buildLifeTaskClass}" id="CodestationBuildLifeTasks"/>
<ah3:useTasks class="${buildLifeTaskClass}" useConversation="false" id="NoConvCodestationBuildLifeTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imgUrl" value="/images"/>

<c:url var="generateArtifactListUrl" value="${NoConvCodestationBuildLifeTasks.generateArtifactList}">
  <c:param name="${WebConstants.CODESTATION_BUILD_LIFE_ID}" value="${codestationBuildLife.id}"/>
</c:url>

<%
  CodestationBuildLife buildLife = (CodestationBuildLife) pageContext.findAttribute(WebConstants.CODESTATION_BUILD_LIFE);
  CodestationProject project = (CodestationProject)buildLife.getCodestationProject();

  pageContext.setAttribute("inUse", new Boolean(buildLife.isInUse()));

  // add all populated sets (active or otherwise)
  CodestationFileAccess codestation = new CodestationFileAccess();
  pageContext.setAttribute("setList", codestation.getPublishedArtifactSets(buildLife));

  EvenOdd eo = new EvenOdd();
%>
<c:choose>
  <c:when test='${fn:escapeXml(mode) == "art-edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<c:set var="inEditMode" value="true"/>
<c:set var="inViewMode" value=""/>

<c:url var="addFileUrl" value="${CodestationBuildLifeTasks.addFile}"/>
<c:url var="addManyFilesUrl" value="${CodestationBuildLifeTasks.addManyFiles}"/>

<%-- CONTENT --%>

<div class="tab-content">
  <c:choose>
    <c:when test="${inUse}">
     <div class="system-helpbox">${ub:i18n("CodeStationBuildLifeInUseArtifactsHelp")}</div>
    </c:when>
    <c:otherwise>
      <div class="system-helpbox">${ub:i18n("CodeStationBuildLifeArtifactsHelp")}</div>
    </c:otherwise>
  </c:choose>
  <script type="text/javascript">
    isAllOpen=false;
    function expandAll() {
      if(isAllOpen) {
        document.getElementById("sign_box").src = "${imgUrl}/icon_plus_sign.gif";
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
        document.getElementById("sign_box").src = "${imgUrl}/icon_minus_sign.gif";
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
      <c:when test="${fn:length(setList) == 0}">
        <br/>
        ${ub:i18n("CodeStationBuildLifeNoArtifacts")}
      </c:when>
      <c:otherwise>
        <br/>
        <table id="whole-artifact-set-table" width="100%" class="data-table">
          <tr>
            <th scope="col" width="3%">
              <img id="sign_box" alt="" onclick="expandAll()" class="clickable"
                  src="${fn:escapeXml(imgUrl)}/icon_plus_sign.gif"
              />
            </th>
            <th scope="col" style="text-align: left;">${ub:i18n("ArtifactSet")}</th>
            <th scope="col" align="left">${ub:i18n("DownloadAll")}</th>
          </tr>
          <c:forEach var="set" items="${setList}" varStatus="loopStatus">
            <%
              if (buildLife != null && buildLife.getId() != null) {
                boolean canDownload = Authority.getInstance().hasPermission(project, UBuildAction.CODESTATION_DOWNLOAD);
                pageContext.setAttribute("can_download", Boolean.valueOf(canDownload));
                pageContext.setAttribute("generateList", Boolean.TRUE);
              }
              else {
                pageContext.setAttribute("can_download", Boolean.FALSE);
                pageContext.setAttribute("generateList", Boolean.FALSE);
              }
            %>

            <c:url var="removeFileNameUrl" value="${CodestationBuildLifeTasks.removeFile}">
              <c:param name="codestationArtifactSet" value="${set}"/>
            </c:url>
            <c:url var="downloadFileNameUrl" value="${CodestationBuildLifeTasks.downloadFile}">
              <c:param name="codestationArtifactSet" value="${set}"/>
            </c:url>
            <c:url var="downloadAllUrl" value="${CodestationBuildLifeTasks.downloadAllFiles}">
              <c:param name="codestationArtifactSet" value="${set}"/>
            </c:url>
            <c:url var="viewFileNameUrl" value="${CodestationBuildLifeTasks.viewFile}">
              <c:param name="codestationArtifactSet" value="${set}"/>
            </c:url>
            <tr>
              <td align="center" style="border-bottom:0">
                <script type="text/javascript">
                  var artifactListPage${loopStatus.index} = {
                    dataSource : null,
                    artifactDataTable : null,
                    nameFormatter : function(elLiner, oRecord, oColumn, oData) {
                      if (${can_download}) {
                        elLiner.innerHTML = "<a href=\"${ah3:escapeJs(downloadFileNameUrl)}&filePath=" + oData + "\">" + oData +  "</a>";
                      }
                      else {
                        elLiner.innerHTML = oData;
                      }
                    },
                    removeFormatter : function(elLiner, oRecord, oColumn, oData) {
                      if(!${inUse}) {
                          elLiner.innerHTML = "<div align=\"center\"><a href=\"${ah3:escapeJs(removeFileNameUrl)}&filePath=" + oRecord.getData("file_name") + "\" onclick=\"return confirmDelete('" + oRecord.getData("file_name") + "');\"><img title=\"${ub:i18n('Delete')}\" alt=\"${ub:i18n('Delete')}\" border=\"0\" src=\"${imgUrl}/icon_delete.gif\"/></a></div>";
                      }
                      else {
                          elLiner.innerHTML = "<div align=\"center\"><img title=\"Delete\" alt=\"${ub:i18n('Delete')}\" border=\"0\" src=\"${imgUrl}/icon_delete_disabled.gif\"/></div>";
                      }
                    },
                    sizeFormatter : function(elLiner, oRecord, oColumn, oData) {
                      if(${can_download}) {
                        elLiner.innerHTML = oData + "<small><a href=\"${ah3:escapeJs(viewFileNameUrl)}&filePath=" + oRecord.getData("file_name") + "\">" + " ${ub:i18n('ArtifactsDownloadLowercase')} " +  "</a></small>";
                      }
                      else {
                        elLiner.innerHTML = oData;
                      }
                    },
                    hashesFormatter : function(elLiner, oRecord, oColumn, oData) {
                      elLiner.innerHTML = oData.join("<br/>");
                    },
                    buildPageLabel : function(oState, oSelf, clear) {
                      var startIndex = (oState.pagination) ? oState.pagination.recordOffset : 0;
                      var results = (oState.pagination) ? oState.pagination.rowsPerPage : null;
                      var label = "setName=${ah3:escapeJs(set)}&startIndex=" + startIndex + "&results=" + results;
                      return label;
                    },
                    createDataSource : function(datasource) {
                      this.dataSource = new YAHOO.util.DataSource(datasource);
                    },
                    DynamicTable : function () {
                      var pagconfig = {
                          rowsPerPage:25,
                          rowsPerPageOptions:[25, 50, 100, 200],
                          containers  : ['topPag${loopStatus.index}'],
                          template:YAHOO.widget.Paginator.TEMPLATE_ROWS_PER_PAGE,
                          initialPage : 1,
                          alwaysVisible : false,
                          pageLinks               : 12,
                          firstPageLinkLabel : "<img src=\"${imgUrl}/YUI_first.gif\"/>",
                          lastPageLinkLabel : "<img src=\"${imgUrl}/YUI_last.gif\"/>",
                          previousPageLinkLabel : "<img src=\"${imgUrl}/YUI_previous.gif\"/>",
                          nextPageLinkLabel : "<img src=\"${imgUrl}/YUI_next.gif\"/>"
                      };
                      var myColumnDefs=[
                          {key:"file_name", label:"<div style='margin: 0 20px  0 20px'>${ub:i18n('FileName')}</div>", sortable:false, formatter: this.nameFormatter},
                          {key:"size", label:"<div style='margin: 0 20px 0 20px'>${ub:i18n('Size')}</div>", sortable:false, formatter: this.sizeFormatter},
                          {key:"hashes", label:"<div style='margin: 0 20px 0 20px'>${ub:i18n('Hash')}</div>", sortable:false, formatter: this.hashesFormatter },
                          {key:"last_modified", label:"<div style='margin: 0 20px 0 20px'>${ub:i18n('LastModified')}</div>"},
                          {key:"operations", label:"<div style='margin: 0 20px 0 20px'>${ub:i18n('Actions')}</div>", formatter: this.removeFormatter}
                      ];
                      var createArtifactsTable = function() {
                        artifactListPage${loopStatus.index}.dataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;
                        artifactListPage${loopStatus.index}.dataSource.responseSchema = {
                            resultsList:'results',
                            fields:[
                                {key:"file_name"},
                                {key:"size"},
                                {key:"hashes"},
                                {key:"last_modified"}
                            ],
                            metaFields: {
                                totalRecords: "totalRecords",
                                startIndex: "startIndex"
                            }
                        };
                      }
                      createArtifactsTable();
                      var artifactTableConf = {
                          initialLoad:true,
                          initialRequest:"startIndex=0&results=25&setName=${ah3:escapeJs(set)}",
                          dynamicData:true,
                          generateRequest:this.buildPageLabel,
                          paginator:new YAHOO.widget.Paginator(pagconfig)
                      };
                      artifactListPage${loopStatus.index}.artifactDataTable = new YAHOO.widget.DataTable("artifactTable${loopStatus.index}", myColumnDefs, artifactListPage${loopStatus.index}.dataSource, artifactTableConf);
                      artifactListPage${loopStatus.index}.artifactDataTable.handleDataReturnPayload = function(oRequest, oResponse, oPayload) {
                        oPayload.totalRecords = oResponse.meta.totalRecords;
                        YAHOO.log("in handleReturnPayload method", "debug", this.toString());
                        return oPayload;
                      }
                    }
                  }
                  isOpen${loopStatus.index}=false;
                  function toggleSet${loopStatus.index}()
                  {
                    if(isOpen${loopStatus.index}) {
                      document.getElementById("sign_box${loopStatus.index}").src = "${imgUrl}/icon_plus_sign.gif";
                      if(${generateList}) {
                        $('artTable${loopStatus.index}').hide();
                      }
                      isOpen${loopStatus.index}=false;
                    }
                    else {
                      if(${generateList}) {
                        $('artTable${loopStatus.index}').style.display = "";
                      }
                      document.getElementById("sign_box${loopStatus.index}").src = "${imgUrl}/icon_minus_sign.gif";
                      isOpen${loopStatus.index}=true;
                    }
                  }
                </script>
                <img id="sign_box${loopStatus.index}" alt="" onclick="toggleSet${loopStatus.index}()" class="clickable"
                    src="${fn:escapeXml(imgUrl)}/icon_plus_sign.gif"
                />
              </td>
              <td align="left" style="border-bottom:0">${set}</td>
              <td style="border-bottom:0">
                 &nbsp;&nbsp;&nbsp;
                 <small>
                   <a href="${fn:escapeXml(downloadAllUrl)}"><img
                      src="${fn:escapeXml(imgUrl)}/icon_download.gif" alt="" border="0"
                      />&nbsp;${ub:i18n("DownloadAllZip")}</a>
                 </small>
              </td>
            </tr>
            <tbody id="artTable${loopStatus.index}" style="display:none" >
              <tr>
                <td colspan="3" style="padding-left:3%; border-top:0; background:url(${imgUrl}/artifactset_shadow.gif) repeat-x top #eef2f6">
                  <div id="topPag${loopStatus.index}" class="yui-skin-sam" align="left"></div><div id="artifactTable${loopStatus.index}"></div>
                </td>
              </tr>
            </tbody>
          </c:forEach>
        </table>
        <c:forEach var="set" items="${setList}" varStatus="loopStatus">
          <script type="text/javascript">
            if (${generateList}) {
              artifactListPage${loopStatus.index}.createDataSource("${generateArtifactListUrl}&");
              artifactListPage${loopStatus.index}.DynamicTable();
            }
          </script>
        </c:forEach>
      </c:otherwise>
    </c:choose>
    <br/>
    <br/>
  </div>
  <c:if test="${param.canWrite && !inUse}">
    <ucf:button name="UploadFile" label="${ub:i18n('UploadFile')}" href="${addFileUrl}" enabled="${param.enabled && !addFile}"/>&nbsp;
    <ucf:button name="UploadManyFiles" label="${ub:i18n('UploadManyFiles')}" href="${addManyFilesUrl}" enabled="${param.enabled && !addFile}"/>
    <br/><br/>
  </c:if>

  <c:if test="${param.canWrite && !inUse}">
    <c:if test="${addManyFiles}">
      <c:import url="addManyFiles.jsp"/>
    </c:if>
    <c:if test="${addFile}">
      <c:import url="addFile.jsp"/>
    </c:if>
  </c:if>
</div>
