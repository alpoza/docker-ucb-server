<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.admin.step.StepSelectionTreeFactory"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="java.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:url var="imagesUrl" value="/images"/>

<%
    StepSelectionTreeFactory factory = new StepSelectionTreeFactory();
    pageContext.setAttribute("stepSelectionTree", factory.createTree());
%>


<script type="text/javascript">
  /* <![CDATA[ */

  var StepListTree = Class.create({

      /**
       * Constructor
       * This class relies on window#resize being a known function
       *
       * @param the selectStepConfigTable element
       */
      initialize: function(selectStepConfigTable) {
          this.selectStepConfigTable = $(selectStepConfigTable);
      },

      /**
       *
       */
      attachListeners: function() {
          var self = this;
          this.selectStepConfigTable.select('.folder').each(function(folder){
               folder.observe('click', function(){self.toggleFolder(folder); window.resize();});
          });
      },

      /**
       * Toggels a folder open or closed.
       *   A closed folder: folder content and all descendant folders (and their content) hidden
       *   An open folder:  folder content and direct child folders are visible
       */
      toggleFolder: function(folder) {
          folder = $(folder);
          var self = this;

          var folderPath = folder.id;
          var plusMinus = folder.down().down().down(); // would do ".down('img')" but safari throws strange error
          var folderIcn = plusMinus.next();

          var wasOpen = folder.hasClassName('openFolder');
          if (wasOpen) {
              folder.removeClassName('openFolder');

              plusMinus.src = '${ah3:escapeJs(imagesUrl)}/icon_plus_sign.gif';
              plusMinus.alt = '-';
              folderIcn.src = '${ah3:escapeJs(imagesUrl)}/icon_folder_view.gif';


              // hide content element if present
              if (!folder.next().hasClassName('folder')) {
                  folder.next().hide();
              }

              // hide visibility of all "child" folders and sections
              folder.up().select('tbody[id^="'+folderPath+':"]').each(function(section) {
                  section.hide();
                  if (!section.next().hasClassName('folder')) {
                      section.next().hide();
                  }
              });
          }
          else {
              folder.addClassName('openFolder');

              plusMinus.src = '${ah3:escapeJs(imagesUrl)}/icon_minus_sign.gif';
              plusMinus.alt = '+';
              folderIcn.src = '${ah3:escapeJs(imagesUrl)}/icon_folder_open.gif';

              self._fixFolderVisible(folder);
          }
      },

      /**
       * This method fixes the visiblity of the given folder as well as any child folders.
       * This needed is becuase if you close a parent folder then all (even "open") child folders will become hidden,
       * and when the parent folder is re-opened we want to ensure that all child folders are visible. It recurses in
       * order to fix all descendents.
       */
      _fixFolderVisible: function(folder) {
          folder = $(folder);
          var self = this;

          folder.show();
          if (folder.hasClassName('openFolder')) {
              // if folder is open, show contents
              if (!folder.next().hasClassName('folder')) {
                  folder.next().show();
              }

              // fix subfolders
              var prefix = folder.id;
              folder.up().select('tbody[id^="'+prefix+':"]').each(function(child) {
                  if (child.id.lastIndexOf(':')==prefix.length) {
                      self._fixFolderVisible(child);
                  }
              });
          }
      }
  });

  Element.observe(window, 'load', function(){
      var stepListTree = new StepListTree('select_step_config');
      stepListTree.attachListeners();
  });

  /* ]]> */
</script>

  <table id="select_step_config" class="select_step_config">

    <c:forEach var="tag2types" items="${stepSelectionTree.entries}">
      <c:set var="tag" value="${tag2types.key}"/>
      <c:set var="types" value="${tag2types.value}"/>

      <c:set var="absolutePath" value="${fn:replace(tag, '/', ':')}"/>
      <c:set var="depth" value="${fn:length(fn:split(absolutePath, ':')) - 1}"/>
      <c:set var="simpleName" value="${fn:split(absolutePath, ':')[depth]}"/>

      <c:set var="isRootFolder" value="${empty simpleName && depth == 0}"/>

      <c:if test="${!isRootFolder}">
        <tbody class="folder" id="folder:${absolutePath}" <c:if test="${depth > 0}">style="display:none"</c:if>>
          <tr>
            <td colspan="2" style="padding-left: ${5 + depth * 36}px">
              <img src="${fn:escapeXml(imagesUrl)}/icon_plus_sign.gif" alt="-" style="vertical-align: middle;"/>
              <img src="${fn:escapeXml(imagesUrl)}/icon_folder_view.gif" alt="" style="vertical-align: middle;"/>
              <a href="#" class="step_folder_label" onclick="return false;">${fn:escapeXml(ub:i18n(simpleName))}</a>
            </td>
          </tr>
        </tbody>
      </c:if>
      <c:if test="${!empty types}">
        <tbody class="step_type_list" id="steps:${absolutePath}" <c:if test="${!isRootFolder}">style="display:none"</c:if>>
          <c:forEach var="type" items="${types}">
            <tr>
              <td class="step_name" style="padding-left: ${(depth+1) * 36}px; white-space: nowrap" width="50%">
                <div style="float:left;">
                  <input id="step:${absolutePath}:${type.selectionName}" name="stepSelection" value="${fn:escapeXml(type.id)}"
                    style="cursor: pointer;" type="radio" class="radio"/>
                </div>
                <%-- Span makes Selenium testing easier --%>
                <span>${fn:escapeXml(ub:i18n(type.selectionName))}</span>
              </td>
              <%-- translate spaces and newlines into hard breaks and non-collapsing spaces, but escape all other chars --%>
              <td class="step_description" width="50%">${ah3:htmlBreaks(fn:escapeXml(fn:trim(ub:i18n(type.description))))}</td>
            </tr>
          </c:forEach>
        </tbody>
      </c:if>
    </c:forEach>

  </table>

  <div class="select_buttons" style="margin-top:1em;">
    <ucf:button name="Select" label="${ub:i18n('Select')}"/>
    <ucf:button href="${param.cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
  </div>
