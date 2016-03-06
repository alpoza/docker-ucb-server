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
<%@page import="com.urbancode.ubuild.services.file.FileInfo" %>
<%@page import="com.urbancode.ubuild.services.file.FileInfoService" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.commons.fileutils.FileUtils" %>
<%@page import="com.urbancode.commons.fileutils.digest.*" %>
<%@page import="java.io.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.*" %>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<%
    FileInfo baseDirectory = (FileInfo) request.getAttribute(WebConstants.ARTIFACT_DIR_BASE);
    FileInfo directory = (FileInfo) request.getAttribute(WebConstants.ARTIFACT_DIR);
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMM d, yyyy HH:mm:ss z");
%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('ReportContents')}" />
  <jsp:param name="selected" value="Report Contents" />
  <jsp:param name="disabled" value="false" />
</jsp:include>

<div class="contents">
  <br/>
  <table class="data-table">
    <caption>${ub:i18n("DirectoryListing")}</caption>
      <%
        // list all directories
        FileInfo[] directoryFiles = directory.listFiles();
        if (directoryFiles.length == 0) {
            %>
    <tr bgcolor="#eeeeee">
      <td>
        ${ub:i18n("NoFilesInDirectory")}
      </td>
    </tr>
            <%
        }
  
        List<FileInfo> fileList = new ArrayList<FileInfo>();
        for (FileInfo file : directoryFiles) {
            if (file.isDirectory()) {
                fileList.add(file);
            }
        }
  
        if (fileList.size() > 0) {
            %>
            <tr>
              <th colspan="4">${ub:i18n("Subdirectories")}</th>
            </tr>
            <%
        }
        int i = 0;
        for (FileInfo file : fileList) {
            pageContext.setAttribute("file", file);
            %>
            <tr<% if (i % 2 != 0) out.write(" bgcolor='#eeeeee'"); %>>
              <td>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a href="${fn:escapeXml(file.name)}">${fn:escapeXml(file.name)}<%= File.separator %></a>
                &nbsp;&nbsp;
              </td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td align="right"><%= dateFormat.format(new Date(file.lastModified())) %></td>
            </tr>
            <%
            i++;
        }
  
        FileInfo digestFile = null;
        // list all files other than digest (non-directories, non-ahs.dig)
        fileList = new ArrayList<FileInfo>();
        for (FileInfo file : directoryFiles) {
            if (file.isFile()) {
                if (file.getName().equalsIgnoreCase(DigestUtil.getDigestFileName())) {
                    digestFile = file;
                } else {
                    fileList.add(file);
                }
            }
        }
  
        DigestProperties digestProps = null;
        if (digestFile != null) {
            digestProps = new DigestProperties(
                FileInfoService.getInstance().getFileInfoAsStream(digestFile),
                new File(digestFile.getPath()).getParentFile());
        }
  
        if (fileList.size() > 0) {
            %>
            <tr>
              <th width="30%">${ub:i18n("Files")}</th>
              <th width="30%">${ub:i18n("HashWithColon")}</th>
              <th width="20%">${ub:i18n("SizeWithColon")}</th>
              <th width="20%">${ub:i18n("DateWithColon")}</th>
            </tr>
            <%
        }
        i = 0;
        for (FileInfo file : fileList) {
            pageContext.setAttribute("file", file);
            
            String digestInfo = digestProps == null ? "" : digestProps.getDigestInfo(new File(file.getPath()));
            pageContext.setAttribute("digestValue", digestInfo);
            %>
            <tr<% if (i % 2 != 0) out.write(" bgcolor='#eeeeee'"); %>>
              <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="${fn:escapeXml(file.name)}">${fn:escapeXml(file.name)}</a>
                &nbsp;&nbsp;&nbsp;
              </td>
              <td>${fn:escapeXml(digestValue)}</td>
              <td align="right"><%= FileUtils.getNearestBytes(file.length()) %></td>
              <td align="right"><%= dateFormat.format(new Date(file.lastModified())) %></td>
            </tr>
            <%
            i++;
        }
      %>
  </table>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>