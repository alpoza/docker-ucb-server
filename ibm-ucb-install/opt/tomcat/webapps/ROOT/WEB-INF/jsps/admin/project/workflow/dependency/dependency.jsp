<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="com.urbancode.ubuild.domain.artifacts.ArtifactSetFactory"%>
<%@page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@page import="com.urbancode.ubuild.domain.profile.*"%>
<%@page import="com.urbancode.ubuild.domain.project.*"%>
<%@page import="com.urbancode.ubuild.domain.status.*"%>
<%@page import="com.urbancode.ubuild.domain.workflow.*"%>
<%@page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks"%>
<%@page import="com.urbancode.ubuild.web.*"%>
<%@page import="com.urbancode.codestation2.domain.project.*"%>
<%@page import="com.urbancode.ubuild.codestation.*"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.profile.DependencyTriggerType"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
      <c:set var="fieldAttributes" value=""/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<c:set var="project" value="${workflow.project}"/>
<c:set var="dependencyProject" value="${buildProfileDependency.dependency}"/>
<c:set var="triggerOnlyDependencies" value="${workflow.buildProfile.triggerOnlyDependencies}"/>

<c:url var="imgUrl" value="/images"/>

<c:url var="newDependencyUrl"   value="${WorkflowTasks.newDependency}"></c:url>

<c:url var="editUrl"   value='<%= new WorkflowTasks().methodUrl("editDependency", false)%>'>
  <c:param name="workflowId" value="${workflow.id}"/>
  <c:param name="buildProfileDependencyId" value="${buildProfileDependency.id}"/>
</c:url>

<c:url var="doneUrl"   value='<%= new WorkflowTasks().methodUrl("viewDependencies", false)%>'>
  <c:param name="workflowId" value="${workflow.id}"/>
  <c:param name="buildProfileDependencyId" value="${buildProfileDependency.id}"/>
</c:url>

<c:url var="saveUrl"   value="${WorkflowTasks.saveDependency}"/>
<c:url var="cancelUrl" value="${WorkflowTasks.cancelDependency}"/>

<%-- CONTENT --%>

<%
  Project project = (Project)pageContext.findAttribute("project");
  Workflow workflow = (Workflow)pageContext.findAttribute("workflow");
  BuildProfile profile = workflow.getBuildProfile();
  boolean triggerOnlyDependencies = workflow.getBuildProfile().isTriggerOnlyDependencies();
  pageContext.setAttribute("triggerOnlyDependencies", triggerOnlyDependencies);
  pageContext.setAttribute("artifactSetList", ArtifactSetFactory.getInstance().restoreAllActive());

  // create a filter for the existing dependencies
  HashSet<CodestationCompatibleProject> projectBlackSet = new HashSet<CodestationCompatibleProject>();
  Dependency dependencies[] = workflow.getBuildProfile().getDependencyArray();
  for (Dependency dependency : dependencies) {
      projectBlackSet.add(dependency.getDependency());
  }
  // add the project itself to the black list
  projectBlackSet.add(new AnthillProject(profile));
  
  Dependency dependency = (Dependency) pageContext.findAttribute("buildProfileDependency");
  if (dependency != null) {
      String curHandle = Handle.doHandle2String(new Handle((Persistent) dependency.getDependency()));
      pageContext.setAttribute("curHandle", curHandle);
  }
  
  CodestationCompatibleProject[] projectArray = null;
%>

<c:if test="${!inViewMode && show_project_list}">
<%
  // filter this project from valid dependency list
  projectArray = CodestationProjectFactory.getInstance().restoreAllActive();
  
  List<CodestationCompatibleProject> projectList = new ArrayList<CodestationCompatibleProject>();
  for (CodestationCompatibleProject depCSProject : projectArray) {
      if (projectBlackSet.contains(depCSProject)) {
          // skip existing deps
          continue;
      }

      if (triggerOnlyDependencies && depCSProject instanceof CodestationProject) {
          // skip Codestation Projects if we are only using dependencies to trigger
          continue;
      }
      
      projectList.add(depCSProject);
  }
  pageContext.setAttribute(WebConstants.PROJECT_LIST, projectList);
%>
  <script type="text/javascript"><!--
  
  var projects = [
    <c:forEach var="project" items="${project_list}" varStatus="projectsStatus">
    <%
      CodestationCompatibleProject tempProj = (CodestationCompatibleProject) pageContext.findAttribute("project");
      Handle handle = new Handle((Persistent)tempProj);
      String handleStr = Handle.doHandle2String(handle);
      pageContext.setAttribute("tempProj", tempProj);
      pageContext.setAttribute("handle", Handle.doHandle2String(handle));
    %>
    { name: "${fn:escapeXml(tempProj.name)}", id: "${handle}" }<c:if test="${not projectsStatus.last}">,</c:if>
    </c:forEach>
  ];
  
  YAHOO.util.Event.addListener(window, "load", function() {
      var matchProjects = function(sQuery) {
          // Case insensitive matching
          sQuery = decodeURIComponent(sQuery);
          var query = sQuery.toLowerCase(),
              matchStart = true,
              project,
              i=0,
              l=projects.length,
              matches = [];
          if (query.length > 0 && query.charAt(0) == '*') {
              matchStart = false;
              query = query.substring(1);
          }
  
          // Match against each name of each contact
          for (; i<l; i++) {
              project = projects[i];
              var matchIndex = project.name.toLowerCase().indexOf(query);
              if (matchStart && matchIndex == 0) {
                  matches[matches.length] = project;
              }
              else if (!matchStart && matchIndex > -1) {
                  matches[matches.length] = project;
              }
          }
  
          return matches;
      };
      
      var dataSource = new YAHOO.util.FunctionDataSource(matchProjects); 
      dataSource.responseSchema = { 
          fields: ["name", "id"] 
      }
          
      // Instantiate the AutoComplete
      var projectHandleAutoComplete = new YAHOO.widget.AutoComplete(
            "projectHandleAutoComplete", "projectHandleContainer", dataSource);
      projectHandleAutoComplete.resultTypeList = false;
  
      // Custom formatter to highlight the matching letters
      projectHandleAutoComplete.formatResult = function(oResultData, sQuery, sResultMatch) {
          var query = sQuery.toLowerCase(),
              name = oResultData.name;
          if (query.length > 0 && query.charAt(0) == '*') {
              query = query.substring(1);
          }
          var nameMatchIndex = name.toLowerCase().indexOf(query);
  
          return highlightMatch(name, query, nameMatchIndex);
      };
      
      // Helper function for the formatter
      var highlightMatch = function(full, snippet, matchindex) {
          return "<span title=\"" + full + "\">" + full.substring(0, matchindex) + "<b>" 
                      + full.substr(matchindex, snippet.length) + "<\/b>"
                      + full.substring(matchindex + snippet.length); + "</span>";
      };
      
      // Define an event handler to populate a hidden form field
      // when an item gets selected
      var buildLifeProjectSelectionHandler = function(sType, aArgs) {
          var myAC = aArgs[0]; // reference back to the AC instance
          var elLI = aArgs[1]; // reference to the selected LI element
          var oData = aArgs[2]; // object literal of selected item's result data
          
          // update hidden form field with the selected item's ID
          $('projectHandle').value = oData.id;
          projectSelected();
      };
      projectHandleAutoComplete.itemSelectEvent.subscribe(buildLifeProjectSelectionHandler);
      projectHandleAutoComplete.queryDelay = 0.5;
  });
  //-->
  </script>
</c:if>

<a id="dependencyAnchor"></a>
    
<c:import url="/WEB-INF/jsps/admin/project/workflow/dependency/dependencyTabs.jsp">
  <c:param name="selected" value="main"/>
  <c:param name="disabled" value="${inEditMode}"/>
</c:import>

<div id="dependency" class="tab-content yui-skin-sam">
  <form method="post" action="${fn:escapeXml(newDependencyUrl)}#dependency">
    <table class="property-table">
      <tbody>
        <error:field-error field="projectHandle" cssClass="odd"/>
        <error:field-error field="error" cssClass="odd"/>
        <c:choose>
          <c:when test="${inViewMode || !show_project_list}">
            <tr class="odd" valign="top">
              <td align="left" width="10%"><span class="bold">${ub:i18n("ProjectWithColon")} <span class="required-text">*</span></span></td>

              <td align="left">
                ${fn:escapeXml(buildProfileDependency.dependency.name)}
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <tr class="odd" valign="top">
              <td align="left" width="10%"><span class="bold">${ub:i18n("ProjectWithColon")} <span class="required-text">*</span></span></td>

              <td align="left">
                <div style="width: 30em; padding-bottom: 2em;">
                  <ucf:text id="projectHandleAutoComplete" name="projectHandleAutoComplete" value=""/>
                  <div id="projectHandleContainer"></div>
                </div>
                <input id="projectHandle" name="projectHandle" type="hidden">
              </td>
              <td>
                <span class="">${ub:i18n("DependencyProjectDesc")}</span>
              </td>
            </tr>
            <tr class="odd" valign="top">
              <td align="left" width="10%">&nbsp;</td>
              <td colspan="2">
                <ucf:button name="Select" label="${ub:i18n('Select')}" enabled="${show_project_list}"/>
                <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${doneUrl}" enabled="${show_project_list}"/>
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </form>
      
  <c:if test="${buildProfileDependency != null}">
    <script language="Javascript" type="text/javascript">
var newElementCount = 1000; // 1000 should be safe
    
function addTextInput(parentId, inputId) {
    var parent = $(parentId);

    var divId = "div-" + inputId + "-" + (newElementCount++);
    parent.insert(new Element('div', { id: divId, style: "white-space: nowrap; margin-top: 10px;" })
        .insert(new Element('input', { type: "text", name: inputId, size: 30 }))
        .insert(" ")
        .insert(new Element('a', { title: "${ub:i18n('Remove')}",
                                   href: "javascript:onclick=removeTextInput('" + divId + "');"
                                 })
            .insert(new Element('img', { src: "${imgUrl}/icon_delete.gif", border: 0, alt: "${ub:i18n('Remove')}" }))
        )
    );
}

var urbancode = {};

var nextStampValueDivId = ${fn:length(buildProfileDependency.stampValues)};

function addAdditionalStamp() {
  var stampValueDivId = "stampValue" + ++nextStampValueDivId;
  var stampValueDiv = new Element('div', { id: stampValueDivId, style: "padding: 0px 5px 5px 5px;" })
      .addClassName("stampValue")
      .insert(new Element('input', { type: "text", name: "stampValue", size: 30 }))
      .insert(" ")
      .insert(new Element('img', { id: stampValueDivId + "Grabber", alt: "${ub:i18n('Reorder')}", src: "${imgUrl}/icon_grabber.gif", border: 0 } ))
  ;
  var parent = $('stampValues');
  parent.insert(stampValueDiv);
  var ddList = new urbancode.DDList(stampValueDiv, "stampValues");
  ddList.setHandleElId(stampValueDivId + "Grabber");
}

var nextLabelValueDivId = ${fn:length(buildProfileDependency.labelValues)};

function addAdditionalLabel() {
  var labelValueDivId = "labelValue" + ++nextLabelValueDivId;
  var labelValueDiv = new Element('div', { id: labelValueDivId, style: "padding: 0px 5px 5px 5px;" })
      .addClassName("labelValue")
      .insert(new Element('input', { type: "text", name: "labelValue", size: 30 }))
      .insert(" ")
      .insert(new Element('img', { id: labelValueDivId + "Grabber", alt: "${ub:i18n('Reorder')}", src: "${imgUrl}/icon_grabber.gif", border: 0 } ))
  ;
  var parent = $('labelValues');
  parent.insert(labelValueDiv);
  var ddList = new urbancode.DDList(labelValueDiv, "labelValues");
  ddList.setHandleElId(labelValueDivId + "Grabber");
}

function removeTextInput(divId) {
    var div = document.getElementById(divId);
    div.parentNode.removeChild(div);
}


(function() {

  var Dom = YAHOO.util.Dom;
  var Event = YAHOO.util.Event;
  var DDM = YAHOO.util.DragDropMgr;
  
  //////////////////////////////////////////////////////////////////////////////
  // example app
  //////////////////////////////////////////////////////////////////////////////
  urbancode.DDApp = {
      init: function() {
          new YAHOO.util.DDTarget("labelValues");
          new YAHOO.util.DDTarget("stampValues");

          $$("div.labelValue").each(function(labelValueDiv) {
              var ddList = new urbancode.DDList(labelValueDiv, "labelValues");
              ddList.setHandleElId(labelValueDiv.id + "Grabber");
          });

          $$("div.stampValue").each(function(stampValueDiv) {
              var ddList = new urbancode.DDList(stampValueDiv, "stampValues");
              ddList.setHandleElId(stampValueDiv.id + "Grabber");
          });
      }
  };

  //////////////////////////////////////////////////////////////////////////////
  // custom drag and drop implementation
  //////////////////////////////////////////////////////////////////////////////

  urbancode.DDList = function(element, groupDivId, sGroup, config) {

      urbancode.DDList.superclass.constructor.call(this, element.id, sGroup, config);

      this.logger = this.logger || YAHOO;
      var el = this.getDragEl();
      Dom.setStyle(el, "opacity", 0.67); // The proxy is slightly transparent

      this.goingUp = false;
      this.lastY = 0;
      this.groupDivId = groupDivId;
  };

  YAHOO.extend(urbancode.DDList, YAHOO.util.DDProxy, {

      startDrag: function(x, y) {
          this.logger.log(this.id + " startDrag");

          // make the proxy look like the source element
          var dragEl = this.getDragEl();
          var clickEl = this.getEl();
          Dom.setStyle(clickEl, "visibility", "hidden");

          dragEl.innerHTML = clickEl.innerHTML;

          Dom.setStyle(dragEl, "color", Dom.getStyle(clickEl, "color"));
          Dom.setStyle(dragEl, "backgroundColor", Dom.getStyle(clickEl, "backgroundColor"));
          Dom.setStyle(dragEl, "border", "2px solid gray");
      },

      endDrag: function(e) {

          var srcEl = this.getEl();
          var proxy = this.getDragEl();

          // Show the proxy element and animate it to the src element's location
          Dom.setStyle(proxy, "visibility", "");
          var a = new YAHOO.util.Motion( 
              proxy, { 
                  points: { 
                      to: Dom.getXY(srcEl)
                  }
              }, 
              0.2, 
              YAHOO.util.Easing.easeOut 
          )
          var proxyid = proxy.id;
          var thisid = this.id;

          // Hide the proxy and show the source element when finished with the animation
          a.onComplete.subscribe(function() {
                  Dom.setStyle(proxyid, "visibility", "hidden");
                  Dom.setStyle(thisid, "visibility", "");
              });
          a.animate();
      },

      onDragDrop: function(e, id) {

          // If there is one drop interaction, the li was dropped either on the list,
          // or it was dropped on the current location of the source element.
          if (DDM.interactionInfo.drop.length === 1) {

              // The position of the cursor at the time of the drop (YAHOO.util.Point)
              var pt = DDM.interactionInfo.point; 

              // The region occupied by the source element at the time of the drop
              var region = DDM.interactionInfo.sourceRegion; 

              // Check to see if we are over the source element's location.  We will
              // append to the bottom of the list once we are sure it was a drop in
              // the negative space (the area of the list without any list items)
              if (!region.intersect(pt)) {
                  var destEl = Dom.get(id);
                  var destDD = DDM.getDDById(id);
                  destEl.appendChild(this.getEl());
                  destDD.isEmpty = false;
                  DDM.refreshCache();
              }

          }
      },

      onDrag: function(e) {

          // Keep track of the direction of the drag for use during onDragOver
          var y = Event.getPageY(e);

          if (y < this.lastY) {
              this.goingUp = true;
          } else if (y > this.lastY) {
              this.goingUp = false;
          }

          this.lastY = y;
      },

      onDragOver: function(e, id) {
      
          var srcEl = this.getEl();
          var destEl = $(id);

          // We are only concerned with list items, we ignore the dragover
          // notifications for the list.
          if (destEl.up().id == this.groupDivId) {
              var orig_p = srcEl.parentNode;
              var p = destEl.parentNode;

              if (this.goingUp) {
                  p.insertBefore(srcEl, destEl); // insert above
              } else {
                  p.insertBefore(srcEl, destEl.nextSibling); // insert below
              }

              DDM.refreshCache();
          }
      }
  });

  Event.onDOMReady(urbancode.DDApp.init, urbancode.DDApp, true);

  })();

    </script>

    <form method="post" name="dependencyForm" id="dependencyForm" action="${fn:escapeXml(saveUrl)}#dependency">
      <input type="HIDDEN" name="projectHandle" value="${fn:escapeXml(curHandle)}"/>
      <table class="property-table">
        <tbody>
          <error:field-error field="buildCondition" cssClass="odd"/>
          <tr class="odd" valign="top">
            <td align="left" width="10%"><strong>${ub:i18n("BuildLifeCriteriaWithColon")}</strong></td>
            <td align="left" width="25%">
              <table class="radio-table">
                <c:if test="<%=!(dependency.getDependency() instanceof CodestationProject)%>">
                  <tr>
                    <td nowrap="nowrap" style="padding-top: 4px;">${ub:i18n("WithLabelWithColon")}</td>
                    <td nowrap="nowrap">
                      <div id="labelValues">
                        <c:if test="${empty buildProfileDependency.labelValues}">
                          <div class="labelValue" id="labelValue0" style="padding: 0px 5px 5px 5px;">
                            <ucf:text name="labelValue"
                              value=""
                              size="30"
                              enabled="${inEditMode}"/>
                            <img id="labelValue0Grabber" alt="${ub:i18n('Reorder')}" src="${fn:escapeXml(imgUrl)}/icon_grabber.gif"/>
                          </div>
                        </c:if>
                        <c:forEach var="labelValue" items="${buildProfileDependency.labelValues}" varStatus="labelValueStatus">
                          <div class="labelValue" id="labelValue${labelValueStatus.count}" style="padding: 0px 5px 5px 5px;">
                            <ucf:text name="labelValue"
                              value="${labelValue}"
                              size="30"
                              enabled="${inEditMode}"/>
                            <img id="labelValue${labelValueStatus.count}Grabber" alt="${ub:i18n('Reorder')}" src="${fn:escapeXml(imgUrl)}/icon_grabber.gif"/>
                          </div>
                        </c:forEach>
                      </div><%-- this is where js will add new text-inputs --%>
                    </td>
                    <td style="padding-top: 4px;">
                      <c:if test="${inEditMode}">
                        <a onclick="addAdditionalLabel()" title="${ub:i18n('AddAdditionalLabel')}">
                          <img src="${fn:escapeXml(imgUrl)}/workflow-add.gif" border="0"
                            alt="${ub:i18n('AddAdditionalLabel')}"/></a>
                      </c:if>
                    </td>
                  </tr>
                </c:if>
                <tr>
                  <td nowrap="nowrap" style="padding-top: 4px;">${ub:i18n("WithStampWithColon")}</td>
                  <td nowrap="nowrap">
                    <div id="stampValues">
                      <c:if test="${empty buildProfileDependency.stampValues}">
                        <div class="stampValue" id="stampValue0" style="padding: 0px 5px 5px 5px;">
                          <ucf:text name="stampValue"
                            value=""
                            size="30"
                            enabled="${inEditMode}"/>
                           <img id="stampValue0Grabber" alt="${ub:i18n('Reorder')}" src="${fn:escapeXml(imgUrl)}/icon_grabber.gif"/>
                        </div>
                      </c:if>
                      <c:forEach var="stampValue" items="${buildProfileDependency.stampValues}" varStatus="stampValueStatus">
                        <div class="stampValue" id="stampValue${stampValueStatus.count}" style="padding: 0px 5px 5px 5px;">
                          <ucf:text name="stampValue"
                            value="${stampValue}"
                            size="30"
                            enabled="${inEditMode}"/>
                          <img id="stampValue${stampValueStatus.count}Grabber" alt="${ub:i18n('Reorder')}" src="${fn:escapeXml(imgUrl)}/icon_grabber.gif"/>
                        </div>
                      </c:forEach>
                    </div><%-- this is where js will add new text-inputs --%>
                  </td>
                  <td style="padding-top: 4px;">
                    <c:if test="${inEditMode}">
                      <a onclick="addAdditionalStamp()" title="${ub:i18n('AddAdditionalStamp')}">
                        <img src="${fn:escapeXml(imgUrl)}/workflow-add.gif" border="0"
                          alt="${ub:i18n('AddAdditionalStamp')}"/></a>
                    </c:if>
                  </td>
                </tr>
                <tr>
                  <td nowrap="nowrap">${ub:i18n("DependencyWithStatus")}</td>
                  <td>
                    <ucf:statusSelector name="statusId"
                                    selectedId="${buildProfileDependency.status.id}"
                                    enabled="${inEditMode}"
                                    emptyMessage="${ub:i18n('Any')}"
                                    />
                  </td>
                  <td>&nbsp;</td>
                </tr>
              </table>
            </td>
            <td align="left">
              <span class="inlinehelp">
                ${ub:i18n("DependencyBuildLifeCriteriaDesc")}<br/>
                <br/>
                <c:if test="<%=!(dependency.getDependency() instanceof CodestationProject)%>">
                ${ub:i18n("BuildPreProcessCriteriaDesc2")}<br/>
                <br/>
                </c:if>
                ${ub:i18n("StampCriteriaDesc")}<br/>
                <br/>
                ${ub:i18n("DependencyWithStatusDesc")}
              </span>
            </td>
          </tr>

          <c:if test="<%=!(dependency.getDependency() instanceof CodestationProject)%>">
            <c:set var="useExisting" value="${fieldAttributes}"/>
            <c:set var="pullBuild" value="${fieldAttributes}"/>
            <c:set var="pushBuild"  value="${fieldAttributes}"/>
            <c:choose>
              <c:when test="${buildProfileDependency.triggerType == DependencyTriggerType.UseExisting}">
                <c:set var="useExisting" value="checked"/>
              </c:when>
              <c:when test="${buildProfileDependency.triggerType == DependencyTriggerType.Pull}">
                <c:set var="pullBuild" value="checked"/>
              </c:when>
              <c:when test="${buildProfileDependency.triggerType == DependencyTriggerType.Push}">
                <c:set var="pushBuild" value="checked"/>
              </c:when>
            </c:choose>

            <script type="text/javascript">
                var noneOptions = null;
                var pullOptions = null;
                var pushOptions = null;

                function showNoneOptions() {
                    noneOptions.show();
                }
                function hideNoneOptions() {
                    noneOptions.hide();
                }
                function showPullOptions() {
                    pullOptions.show();
                }
                function hidePullOptions() {
                    pullOptions.hide();
                }
                function showPushOptions() {
                    pushOptions.show();
                }
                function hidePushOptions() {
                    pushOptions.hide();
                }

                function initOptions() {
                    noneOptions = new YAHOO.widget.Module("noneOptions", { visible: <c:if test="${useExisting == 'checked'}">true</c:if><c:if test="${useExisting != 'checked'}">false</c:if> });
                    noneOptions.render();
                  
                    pullOptions = new YAHOO.widget.Module("pullOptions", { visible: <c:if test="${pullBuild == 'checked'}">true</c:if><c:if test="${pullBuild != 'checked'}">false</c:if> });
                    pullOptions.render();
                  
                    pushOptions = new YAHOO.widget.Module("pushOptions", { visible: <c:if test="${pushBuild == 'checked'}">true</c:if><c:if test="${pushBuild != 'checked'}">false</c:if> });
                    pushOptions.render();
                }

                YAHOO.util.Event.addListener(window, "load", initOptions);
            </script>

            <tr class="odd" valign="top">
              <td align="left" width="10%"><span class="bold">${ub:i18n("DependencyTrigger")} </span></td>
              <td align="left" width="25%">
                <table class="radio-table">
                  <tr>
                    <td width="5%">
                      <input type="radio" class="radio" name="buildCondition"
                        onclick="hidePullOptions();hidePushOptions();showNoneOptions();"
                        value="<%= DependencyTriggerType.UseExisting.getId() %>" ${useExisting}>
                    </td>
                    <td>${ub:i18n("None")}
                      <div id="noneOptions">
                        <table class="radio-table">
                          <tr>
                            <td width="5%">
                              <ucf:checkbox name="ignoreIfNotFound_useExisting" checked="${buildProfileDependency.ignoreIfNotFound}" value="true" enabled="${inEditMode}"/>
                            </td>
                            <td nowrap="nowrap"><span class="inlinehelp">${ub:i18n("DependencyIgnore")}</span></td>
                          </tr>
                        </table>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td width="5%">
                      <input type="radio" class="radio" name="buildCondition"
                        onclick="hideNoneOptions();hidePushOptions();showPullOptions();"
                        value="<%= DependencyTriggerType.Pull.getId() %>" ${pullBuild}>
                    </td>
                    <td>${ub:i18n("DependencyPullBuild")}
                      <div id="pullOptions">
                        <table class="radio-table">
                          <tr>
                            <td width="5%">
                              <ucf:checkbox name="usingExistingOnFail" checked="${buildProfileDependency.usingExistingOnFail}" value="true" enabled="${inEditMode}"/>
                            </td>
                            <td nowrap="nowrap"><span class="inlinehelp">${ub:i18n("DependencyPullUseExisting")}</span></td>
                          </tr>
                          <tr>
                            <td width="5%">
                              <ucf:checkbox name="alwaysForce" checked="${buildProfileDependency.alwaysForce}" value="true" enabled="${inEditMode}"/>
                            </td>
                            <td nowrap="nowrap"><span class="inlinehelp">${ub:i18n("DependencyPullAlwaysForce")}</span></td>
                          </tr>
                          <tr>
                            <td width="5%">
                              <ucf:checkbox name="cascadeForce" checked="${buildProfileDependency.cascadeForce}" value="true" enabled="${inEditMode}"/>
                            </td>
                            <td nowrap="nowrap"><span class="inlinehelp">${ub:i18n("DependencyPullCascadeForce")}</span></td>
                          </tr>
                        </table>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td width="5%">
                      <input type="radio" class="radio" name="buildCondition"
                        onclick="hideNoneOptions();hidePullOptions();showPushOptions();"
                        value="<%= DependencyTriggerType.Push.getId() %>" ${pushBuild}>
                    </td>
                    <td>${ub:i18n("DependencyPushBuild")}
                      <div id="pushOptions">
                        <table class="radio-table">
                          <tr>
                            <td width="5%">
                              <ucf:checkbox name="usingStampOnPush" checked="${buildProfileDependency.usingStampOnPush}" value="true" enabled="${inEditMode}"/>
                            </td>
                            <td nowrap="nowrap"><span class="inlinehelp">${ub:i18n("DependencyPushUseStamp")}</span></td>
                          </tr>
                          <tr>
                            <td width="5%">
                              <ucf:checkbox name="ignoreIfNotFound_push" checked="${buildProfileDependency.ignoreIfNotFound}" value="true" enabled="${inEditMode}"/>
                            </td>
                            <td nowrap="nowrap"><span class="inlinehelp">${ub:i18n("DependencyIgnore")}</span></td>
                          </tr>
                        </table>
                      </div>
                    </td>
                  </tr>
                </table>
              </td>
              <td align="left">
                <span class="inlinehelp">
                ${ub:i18n("DependencyPullDesc")}<br/>
                <br/>
                ${ub:i18n("DependencyPushDesc")}</span>
              </td>
            </tr>
          </c:if>

          <c:if test="${not triggerOnlyDependencies}">
            <error:field-error field="retrieval" cssClass="odd"/>
            <tr class="odd" valign="top">
              <td align="left" width="10%"><span class="bold">${ub:i18n("ArtifactRetrieval")}</span></td>
              <td align="left" width="25%">
          
<script language="Javascript" type="text/javascript">
var setIdArray = new Array();
var setIndexArray = new Array();

function addDirInput(divId, inputId, setIndex) {
    var div = document.getElementById(divId);
    var nextIndex = setIndexArray[setIndex];
    var input = document.createElement('input');
    input.id = inputId + ":" + nextIndex;
    input.type = 'text';
    input.name = inputId + ":" + nextIndex;
    input.size = 20;
    document.forms["dependencyForm"].elements[document.forms["dependencyForm"].elements.length] = input;
    div.appendChild(input);
    setIndexArray[setIndex] = nextIndex + 1;
}

</script>
                    
              <table class="data-table" style="table-layout: auto;">
                <thead>
                  <tr>
                    <th nowrap="nowrap">${ub:i18n("ArtifactSet")}</th>
                    <th nowrap="nowrap">${ub:i18n("Retrieve")}</th>
                    <th nowrap="nowrap">${ub:i18n("Transitive")}</th>
                    <th nowrap="nowrap">${ub:i18n("Location")}</th>
                  </tr>
                </thead>
                
                <tbody>
                  <c:forEach var="artifactSet" items="${artifactSetList}" varStatus="setStatus">
                  <%
                    CodestationCompatibleArtifactSet set 
                      = (CodestationCompatibleArtifactSet)pageContext.findAttribute("artifactSet");
                
                    pageContext.setAttribute("dirs", dependency.getSetDirs(set));
                    pageContext.setAttribute("trans", Boolean.valueOf(dependency.isSetTransitive(set)));
                  %>
                    <tr bgcolor="#ffffff">
                      <td>
                        <%--<input name="${artifactSet.id}:dir" id="${artifactSet.id}:dir" type="hidden" value=""/>--%>
                        <c:out value="${artifactSet.name}"/>
                      </td>
                      <td align="center"><ucf:checkbox  name="artifactSetId" value="${artifactSet.id}" checked="${dirs != null}" enabled="${inEditMode}"/></td>
                      <td align="center"><ucf:checkbox  name="${artifactSet.id}:trans" value="true" checked="${trans}" enabled="${inEditMode}"/></td>
                      <td id="as${artifactSet.id}DirCell">
                        <c:if test="${dirs == null || fn:length(dirs)==0}">
                          <div style="white-space: nowrap; ${artifactSetDivStyle}">
                            <ucf:text name="as${artifactSet.id}:dir" value="" enabled="${inEditMode}"/>
                            <a onclick="addTextInput('extraDir:${ah3:escapeJs(artifactSet.id)}', 'as${ah3:escapeJs(artifactSet.id)}:dir')"
                                title="${ub:i18n('Add')}"><img src="${fn:escapeXml(imgUrl)}/workflow-add.gif"
                                border="0" alt="${ub:i18n('Add')}"/></a>
                          </div>
                        </c:if>
                        <c:set var="count" value="0" />
                        <c:set var="artifactSetDivStyle" value="" />
                        <c:forEach var="dir" items="${dirs}" varStatus="dirIndx">
                          <div id="div-as${artifactSet.id}:dir-${count}" style="white-space: nowrap; ${artifactSetDivStyle}">
                            <ucf:text name="as${artifactSet.id}:dir" value="${dir}" enabled="${inEditMode}"/>
                            <c:if test="${inEditMode && count > 0}">
                              <a onclick="removeTextInput('div-as${artifactSet.id}:dir-${count}')"
                                 title="${ub:i18n('Remove')}"><img src="${fn:escapeXml(imgUrl)}/icon_delete.gif"
                                 border="0" alt="${ub:i18n('Remove')}"/></a>
                            </c:if>
                            <c:if test="${inEditMode && count == 0}">
                              <a onclick="addTextInput('extraDir:${ah3:escapeJs(artifactSet.id)}', 'as${ah3:escapeJs(artifactSet.id)}:dir')"
                                title="${ub:i18n('Add')}"><img src="${fn:escapeXml(imgUrl)}/workflow-add.gif"
                                border="0" alt="${ub:i18n('Add')}"/></a>
                            </c:if>
                          </div>
                          <c:set var="count" value="${count + 1}" />
                          <c:set var="artifactSetDivStyle" value="margin-top: 10px" />
                        </c:forEach>
                        <div id="extraDir:${fn:escapeXml(artifactSet.id)}"></div><%-- this is where js will add new text-inputs --%>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </td>
            <td align="left">
              <span class="inlinehelp">
                  ${ub:i18n("DependencyRetrieveDesc")}<br/>
                  <br/>
                  ${ub:i18n("DependencyTransitiveDesc")}<br/>
                  <br/>
                  ${ub:i18n("DependencyLocationDesc")}<br/>
                  ${ub:i18n("DependencyRetrievalDesc")}
              </span>
            </td>
          </tr>
        </c:if>
    
        <tr>
          <td colspan="3">
            <c:if test="${inEditMode}">
              <ucf:button name="Save" label="${ub:i18n('Save')}"/>
              <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${doneUrl}" />
            </c:if>
            <c:if test="${inViewMode}">
              <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}#dependency" />
              <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}" />
            </c:if>
          </td>
        </tr>
        </tbody>
      </table>
    </form>
  </c:if>
  <br/>
</div>