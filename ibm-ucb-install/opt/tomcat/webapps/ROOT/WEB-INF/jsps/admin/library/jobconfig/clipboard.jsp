<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.admin.clipboard.ClipboardTasks" %>
<%@ page import="com.urbancode.ubuild.web.clipboard.Clipboard" %>
<%@ page import="com.urbancode.ubuild.web.clipboard.EntryGroup" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.clipboard.ClipboardTasks" useConversation="false"/>

<c:url var="imagesUrl" value="/images"/>

<%
  Clipboard clipboard = new ClipboardTasks().getClipboard(request);
  if (!clipboard.isEmpty()) {
      // get requested groups
      String[] requestedClipboardNamePrefixes = request.getParameterValues(WebConstants.CLIPBOARD_PARAM_SHOW_FOR_PASTE_NAME_PREFIX);
      List<EntryGroup> requestedEntryGroups = new ArrayList<com.urbancode.ubuild.web.clipboard.EntryGroup>();
      if (requestedClipboardNamePrefixes != null) {
          for (String requestedClipboardNamePrefix : requestedClipboardNamePrefixes) {
              requestedEntryGroups.addAll(clipboard.getGroups(requestedClipboardNamePrefix, true));
          }
      }
      pageContext.setAttribute("requestedEntryGroups", requestedEntryGroups);
  }
%>

<c:if test="${!empty requestedEntryGroups}">
  <c:set var="groupIndex" value="1" />
  <div id="clipboard">
    <div id="clipboard-header">
      <label>${ub:i18n("LibraryJobClipboard")}</label> &nbsp;&nbsp;&nbsp;
      <a id="clipboard-header-expand-enabled" href="javascript:void(0);" onclick="expandClipboard();">
          <img src="${fn:escapeXml(imagesUrl)}/icon_down_arrow.gif" border="0" alt="${ub:i18n('Show')}" title="${ub:i18n('Show')}"/>
      </a>
      <img id="clipboard-header-expand-disabled" src="${fn:escapeXml(imagesUrl)}/icon_down_arrow_disabled.gif" border="0" alt="${ub:i18n('Show')}" />
      <a id="clipboard-header-collapse-enabled" href="javascript:void(0);" onclick="collapseClipboard();">
          <img src="${fn:escapeXml(imagesUrl)}/icon_up_arrow.gif" border="0" alt="${ub:i18n('Hide')}" title="${ub:i18n('Hide')}"/>
      </a>
      <img id="clipboard-header-collapse-disabled" src="${fn:escapeXml(imagesUrl)}/icon_up_arrow_disabled.gif" border="0" alt="${ub:i18n('Hide')}" />
    </div>
    <div id="clipboard-contents">
      <table width="100%">
        <c:forEach var="entryGroup" items="${requestedEntryGroups}">
          <c:set var="nameString" value="&nbsp;&nbsp;&nbsp;${entryGroup.objectDisplayNameString}" />
          <c:set var="groupDetailsId" value="groupDetails-${groupIndex}" />

          <tr>
            <td><label>${entryGroup}</label></td>
            <td align="right">
              <a href="javascript:void(0);" onclick="pasteFromClipboard('${entryGroup.uniqueName}');"><img
                src="${fn:escapeXml(imagesUrl)}/icon_clipboard_paste.gif" border="0" alt="${ub:i18n('LibraryJobPaste')}"
                title="${ub:i18n('LibraryJobPaste')}"/></a>&nbsp;
              <a href="javascript:void(0);" onclick="pasteAndRemoveFromClipboard('${entryGroup.uniqueName}');"><img
                src="${fn:escapeXml(imagesUrl)}/icon_clipboard_paste_and_remove.gif" border="0" alt="${ub:i18n('LibraryJobPasteRemove')}"
                title="${ub:i18n('LibraryJobPasteRemove')}"/></a>&nbsp;
              <a href="javascript:void(0);" onclick="removeFromClipboard('${entryGroup.uniqueName}');"><img
                src="${fn:escapeXml(imagesUrl)}/icon_delete.gif" border="0" alt="${ub:i18n('Remove')}"
                  title="${ub:i18n('Remove')}"/></a>
            </td>
          </tr>
          <tr>
            <td id="${groupDetailsId}" colspan="2">
              <i>${nameString}</i>
            </td>
          </tr>

          <c:set var="groupIndex" value="${groupIndex + 1}" />
        </c:forEach>
      </table>
    </div>
  </div>

  <c:url var="removeFromClipboardUrl" value='${ClipboardTasks.removeFromClipboardAjax}' />

  <script type="text/javascript">
    function expandClipboard() {
      $("clipboard-header-expand-enabled").style.display = "none";
      $("clipboard-header-expand-disabled").style.display = "inline";
      $("clipboard-header-collapse-enabled").style.display = "inline";
      $("clipboard-header-collapse-disabled").style.display = "none";

      $("clipboard-contents").style.display = "block";
    }

    function collapseClipboard() {
      $("clipboard-header-expand-enabled").style.display = "inline";
      $("clipboard-header-expand-disabled").style.display = "none";
      $("clipboard-header-collapse-enabled").style.display = "none";
      $("clipboard-header-collapse-disabled").style.display = "inline";

      $("clipboard-contents").style.display = "none";
    }

    function removeFromClipboard(groupName) {
      var url = removeFromClipboardUrl;
      var postContent = groupParamName + "=" + groupName;
      var xmlhttp = null;
      if (window.XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();
        if ( typeof xmlhttp.overrideMimeType != 'undefined') {
            xmlhttp.overrideMimeType('text/xml');
        }
      } else if (window.ActiveXObject) {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
      } else {
        alert('Your browser does not support AJAX');
      }

      xmlhttp.open('POST', url, false);
      xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      xmlhttp.send(postContent);

      window.location.reload(false);
    }  
    var removeFromClipboardUrl = "${removeFromClipboardUrl}";
    var groupParamName = "${WebConstants.CLIPBOARD_PARAM_GROUP_NAME}";
  </script>

  <c:if test="${!empty requestedEntryGroups}">
    <script type="text/javascript">
    expandClipboard();
    </script>
  </c:if>

  <c:if test="${empty requestedEntryGroups}">
    <script type="text/javascript">
    collapseClipboard();
    </script>
  </c:if>
</c:if>
