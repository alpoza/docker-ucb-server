<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>
<%@page import="java.io.File" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.logs.ViewLogTasks" />
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:set var="singleSlash" value="\\"/>
<c:set var="doubleSlash" value="\\\\"/>
<c:set var="relativeLogFile" value="${fn:replace(relativeLogFile,singleSlash,doubleSlash)}"/>

<%
  pageContext.setAttribute("pathSeparator", File.separator);

  // Required or IE will puke under HTTPS
  response.setHeader("Pragma", "public");
  response.setHeader("Cache-Control", "max-age=0");
%>

<c:url var="imgUrl" value="/images"/>
<c:url var="fetchLogChunkUrl" value="${ViewLogTasks.fetchLogChunk}"/>
<c:url var="updateViewUrl" value="${ViewLogTasks.updateView}"/>
<c:url var="searchLogUrl" value="${ViewLogTasks.searchLog}"/>
<c:url var="downloadLogUrl" value="${ViewLogTasks.downloadLog}">
    <c:param name="relativeLogFile" value="${relativeLogFile}"/>
    <c:param name="pathSeparator" value="${pathSeparator}"/>
</c:url>

<%-- CONTENT --%>
<c:set var="headContent" scope="request">
  <style type="text/css">
      .log_link {cursor: pointer;cursor: hand;}
  </style>

  <script type="text/javascript">
    /* <![CDATA[ */
    document.observe('dom:loaded', function() { // no need to put in the header, no JS i18n used
        $('close_button').observe('click', function(event) {
            event.stop();
            if (parent.screenRefresh) {
                parent.screenRefresh.setPaused( false );
            }
            parent.hidePopup();
        });

        var logViewer = new LogFile({
                'imgUrl':          '${ah3:escapeJs(imgUrl)}',
                'fetchLogChunkUrl': '${ah3:escapeJs(fetchLogChunkUrl)}',
                'updateViewUrl':   '${ah3:escapeJs(updateViewUrl)}',
                'searchLogUrl':    '${ah3:escapeJs(searchLogUrl)}',
                'downloadLogUrl':  '${ah3:escapeJs(downloadLogUrl)}',
                'relativeLogFile': '${ah3:escapeJs(relativeLogFile)}',
                'pathSeparator':   '${ah3:escapeJs(pathSeparator)}',
                'linesPerPage':    ${ah3:escapeJs(linesPerPage)},
                'totalLineCount':  ${ah3:escapeJs(totalLineCount)},
                'finished':        ${ah3:escapeJs(isFinished)},
                'linesOfInterest': ${errorLinesJson}
        });
    });
    /* ]]> */
  </script>
</c:set>
<c:import url="/WEB-INF/snippets/popupHeader.jsp">
  <c:param name="noResize" value="true"/>
  <c:param name="isLegacyYUI" value="true" />
</c:import>

<div id="log-container" class="log-container">
    <div class="log-content">
        <div class="log-line-numbers"></div>
        <div class="log-text-content"></div>
    </div>
    <div style="height: 44px;">
        <div align="center" style="height: 20px; width: 431px;">
            <span class="log_link prev_page_link">${ub:i18n("PreviousPage")}</span>&nbsp;&nbsp;&nbsp;
            <span class="log_link first_page_link">${ub:i18n("First")}</span>&nbsp;
            (<span class="current-page"></span>/<span class="last-page"></span>)&nbsp;
            <span  class="log_link last_page_link">${ub:i18n("Last")}</span>&nbsp;&nbsp;&nbsp;
            <span  class="log_link next_page_link">${ub:i18n("NextPage")}</span>
        </div>
        <div class="carousel-prev">
            <img src="${fn:escapeXml(imgUrl)}/icon_arrow_left.gif" id="prev-arrow" alt="${ub:i18n('Previous')}"/>
        </div>
        <div id="nav" class="carousel-component">
            <div class="carousel-clip-region">
                <ul class="nav-list carousel-list"></ul>
            </div>
        </div>
        <div class="carousel-next">
            <img src="${fn:escapeXml(imgUrl)}/icon_arrow_right.gif" id="next-arrow" alt="${ub:i18n('Next')}"/>
        </div>
    </div>
    <div class="log-controls">
        <div style="float:right;">&nbsp;<ucf:button id="close_button" name="Close" label="${ub:i18n('Close')}" submit="${false}" /></div>
        <div style="float:right;">&nbsp;<ucf:button id="download_button" name="Download" label="${ub:i18n('Download')}" href="${downloadLogUrl}" submit="${false}"/></div>
        <div style="margin-bottom: 0.25em;">
            <form class="jumpToLineForm" onsubmit="return false;" style="display:inline;">
                <div style="display: inline;">
                  ${ub:i18n("JumpToLine")} <input name="jumpToLineInput" type="text" size="10"/>&nbsp;<ucf:button name="Go" label="${ub:i18n('Go')}"/>&nbsp;
                </div>
            </form>
            <ucf:button cssclass="next-line-of-interest" name="NextLOI" label="${ub:i18n('NextLOI')}" style="display:none;"/>&nbsp;${ub:i18n("LineCount")} <span class="line-count-container bold"></span><span style="display:none;" class="log-working">&nbsp;&nbsp;${ub:i18n("Running")}</span>
        </div>
        <form class="searchForm" onsubmit="return false;">
            ${ub:i18n("SearchWithColon")} <input name="searchQ" type="text" size="10"/>&nbsp;<ucf:button name="Search" label="${ub:i18n('Search')}"/>
        </form>
    </div>
</div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
