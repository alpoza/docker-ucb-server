<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.agentfilter.agentpool.AgentPoolFilter"%>
<%@page import="com.urbancode.ubuild.web.admin.project.ProjectTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.ubuild.domain.project.template.ProjectTemplate"%>
<%@page import="com.urbancode.ubuild.domain.project.template.PreProcessConfig"%>
<%@page import="com.urbancode.ubuild.domain.script.step.StepPreConditionScriptFactory" %>
<%@page import="com.urbancode.ubuild.domain.agentfilter.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="uiA" tagdir="/WEB-INF/tags/ui/admin/agentPool" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<c:choose>
    <c:when test="${fn:escapeXml(mode) == 'edit'}">
      <c:set var="inEditMode" value="true"/>
      <c:set var="disabled" value=""/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="componentMode" value="edit"/>
      <c:set var="disabled" value="disabled='disabled'"/>
    </c:otherwise>
</c:choose>

<c:url var="submitUrl" value="${ProjectTemplateTasks.saveBuildPreProcess}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>

<c:url var="cancelUrl" value="${ProjectTemplateTasks.cancelBuildPreProcess}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>

<c:url var="editUrl" value="${ProjectTemplateTasks.editBuildPreProcess}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>

<c:url var="doneUrl" value="${ProjectTemplateTasks.viewProjectTemplate}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}"/>
</c:url>

<c:url var="imgUrl" value="/images"/>

<%
  ProjectTemplate template = (ProjectTemplate)pageContext.findAttribute(WebConstants.PROJECT_TEMPLATE);
  PreProcessConfig preProcessConfig = template.getPreProcessConfig();

  pageContext.setAttribute("stampValues", preProcessConfig.getStampValues());
  pageContext.setAttribute("labelValues", preProcessConfig.getLabelValues());
  pageContext.setAttribute("preConditionScript", preProcessConfig.getStepPreConditionScript());
  AgentFilter filter = preProcessConfig.getAgentFilter();
  if(filter != null
          && filter instanceof AgentPoolFilter
          && ((AgentPoolFilter)filter).getAgentPool() != null) {
      request.setAttribute(WebConstants.AGENT_POOL, ((AgentPoolFilter)filter).getAgentPool());
  }
  else {
      request.setAttribute(WebConstants.AGENT_POOL, preProcessConfig.getAgentFilter());
  }

  pageContext.setAttribute("preConditionScripts", StepPreConditionScriptFactory.getInstance().restoreAll());
  pageContext.setAttribute("eo", new EvenOdd());
%>

<auth:check persistent="${WebConstants.PROJECT_TEMPLATE}" var="canEdit" action="${UBuildAction.PROJECT_TEMPLATE_EDIT}"/>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/jsps/admin/project/template/projectTemplateHeader.jsp">
  <jsp:param name="disabled" value="${inEditMode}"/>
  <jsp:param name="selected" value="buildpreprocess"/>
</jsp:include>

<c:if test="${inEditMode}">
  <script language="Javascript" type="text/javascript">
  var newElementCount = 1000; // 1000 should be safe

  function addTextInput(parentId, inputId) {
      var parent = $(parentId);

      var divId = "div-" + inputId + "-" + (newElementCount++);
      parent.insert(new Element('div', { id: divId, style: "white-space: nowrap; margin-top: 10px;" })
          .insert(new Element('input', { type: "text", name: inputId, size: 30 }))
          .insert(" ")
          .insert(new Element('a', { title: "Remove Location",
                                     href: "javascript:onclick=removeTextInput('" + divId + "');"
                                   })
              .insert(new Element('img', { src: "${imgUrl}/icon_delete.gif", border: 0, alt: "-" }))
          )
      );
  }

  var urbancode = {};

  var nextStampValueDivId = ${fn:length(stampValues)};

  function addAdditionalStamp() {
    var stampValueDivId = "stampValue" + ++nextStampValueDivId;
    var stampValueDiv = new Element('div', { id: stampValueDivId, style: "padding: 0px 5px 5px 5px;" })
        .addClassName("stampValue")
        .insert(new Element('input', { type: "text", name: "stampValue", size: 30 }))
        .insert(" ")
        .insert(new Element('img', { id: stampValueDivId + "Grabber", src: "${imgUrl}/icon_grabber.gif", border: 0 } ))
    ;
    var parent = $('stampValues');
    parent.insert(stampValueDiv);
    var ddList = new urbancode.DDList(stampValueDiv, "stampValues");
    ddList.setHandleElId(stampValueDivId + "Grabber");
  }

  var nextLabelValueDivId = ${fn:length(labelValues)};

  function addAdditionalLabel() {
    var labelValueDivId = "labelValue" + ++nextLabelValueDivId;
    var labelValueDiv = new Element('div', { id: labelValueDivId, style: "padding: 0px 5px 5px 5px;" })
        .addClassName("labelValue")
        .insert(new Element('input', { type: "text", name: "labelValue", size: 30 }))
        .insert(" ")
        .insert(new Element('img', { id: labelValueDivId + "Grabber", src: "${imgUrl}/icon_grabber.gif", border: 0 } ))
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
</c:if>

<div class="system-helpbox">
  ${ub:i18n("BuildPreProcessSystemHelpBox")}
</div>
<div style="text-align:right; margin-top: 10px; vertical-align: bottom;">
  <span class="required-text">${ub:i18n("RequiredField")}</span>
</div>
<form method="post" action="${fn:escapeXml(submitUrl)}">
  <div class="project-component">
    <div class="component-heading">
      <c:out value="${ub:i18n('SourceChangeQuietPeriod')}"/>
    </div>
    <table class="property-table">
      <tbody>
        <error:field-error field="${WebConstants.QUIET_PERIOD_DURATION}" cssClass="${eo.next}"/>
        <tr class="${eo.next}" valign="top">
          <td align="left" width="15%"><span class="bold">${ub:i18n("BuildPreProcessTimePeriodWithColon")} <span class="required-text">*</span></span></td>
          <td align="left" width="25%">
            <ucf:text name="${WebConstants.QUIET_PERIOD_DURATION}" value="${projectTemplate.preProcessConfig.quietPeriod}" enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("BuildPreProcessTimePeriodDesc")}</span>
          </td>
        </tr>
      </tbody>
    </table>

    <br/><br/>
    <div class="component-heading">
      <c:out value="${ub:i18n('RepositoryTriggerMergePeriod')}"/>
    </div>
    <table class="property-table">
      <tbody>
        <error:field-error field="${WebConstants.MERGE_PERIOD_DURATION}" cssClass="${eo.next}"/>
        <tr class="${eo.next}" valign="top">
          <td align="left" width="15%"><span class="bold">${ub:i18n("BuildPreProcessMergePeriodWithColon")}  <span class="required-text">*</span></span></td>
          <td align="left" width="25%">
            <ucf:text name="${WebConstants.MERGE_PERIOD_DURATION}" value="${projectTemplate.preProcessConfig.mergePeriod}" enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("BuildPreProcessMergePeriodDesc")}</span>
          </td>
        </tr>
      </tbody>
    </table>

    <br/><br/>
    <div class="component-heading">
        <c:out value="${ub:i18n('QuietPeriodTimeout')}"/>
    </div>
    <table class="property-table">
        <tbody>
          <error:field-error field="${WebConstants.TIMEOUT_DURATION}" cssClass="${eo.next}"/>
          <tr class="${eo.next}" valign="top">
            <td align="left" width="15%"><span class="bold">${ub:i18n("TimeoutWithColon")}  <span class="required-text">*</span></span></td>
              <td align="left" width="25%">
                  <ucf:text name="${WebConstants.TIMEOUT_DURATION}" value="${projectTemplate.preProcessConfig.timeout}" enabled="${inEditMode}"/>
              </td>
              <td align="left">
                  <span class="inlinehelp">${ub:i18n("BuildPreProcessTimeoutDesc")}</span>
              </td>
          </tr>
        </tbody>
    </table>

    <br/><br/>
    <div class="component-heading">
      <c:out value="${ub:i18n('SourceDependencyChangeDetection')}"/>
    </div>
    <table class="property-table">
      <tbody id="changelog_settings">
        <tr class="${eo.last}" valign="top">
          <td align="left" width="15%"><span class="bold">${ub:i18n("BuildLifeCriteriaWithColon")}</span></td>
          <td align="left" width="25%">
            <table class="radio-table">
              <tr valign="middle">
                <td nowrap="nowrap" style="padding-top: 8px;">${ub:i18n("WithLabelWithColon")}</td>
                <td nowrap="nowrap">
                  <div id="labelValues">
                    <c:if test="${empty labelValues}">
                      <div class="labelValue" id="labelValue0" style="padding: 0px 5px 5px 5px;">
                        <ucf:text name="labelValue"
                          value=""
                          size="30"
                          enabled="${inEditMode}"/>
                        <c:if test="${inEditMode}">
                          <img id="labelValue0Grabber" src="${fn:escapeXml(imgUrl)}/icon_grabber.gif"/>
                        </c:if>
                      </div>
                    </c:if>
                    <c:forEach var="labelValue" items="${labelValues}" varStatus="labelValueStatus">
                      <div class="labelValue" id="labelValue${labelValueStatus.count}" style="padding: 0px 5px 5px 5px;">
                        <ucf:text name="labelValue"
                          value="${labelValue}"
                          size="30"
                          enabled="${inEditMode}"/>
                        <c:if test="${inEditMode}">
                          <img id="labelValue${labelValueStatus.count}Grabber" src="${fn:escapeXml(imgUrl)}/icon_grabber.gif"/>
                        </c:if>
                      </div>
                    </c:forEach>
                  </div><%-- this is where js will add new text-inputs --%>
                </td>
                <td style="padding-top: 8px;">
                  <c:if test="${inEditMode}">
                    <a onclick="addAdditionalLabel()" title="${ub:i18n('AddAdditionalLabel')}"><img src="${fn:escapeXml(imgUrl)}/workflow-add.gif" border="0" alt="${ub:i18n('AddAdditionalLabel')}"/></a>
                  </c:if>
                </td>
              </tr>
              <tr valign="middle">
                <td nowrap="nowrap" style="padding-top: 8px;">${ub:i18n("WithStampWithColon")}</td>
                <td nowrap="nowrap">
                  <div id="stampValues">
                    <c:if test="${empty stampValues}">
                      <div class="stampValue" id="stampValue0" style="padding: 0px 5px 5px 5px;">
                        <ucf:text name="stampValue"
                          value=""
                          size="30"
                          enabled="${inEditMode}"/>
                        <c:if test="${inEditMode}">
                          <img id="stampValue0Grabber" src="${fn:escapeXml(imgUrl)}/icon_grabber.gif"/>
                        </c:if>
                      </div>
                    </c:if>
                    <c:forEach var="stampValue" items="${stampValues}" varStatus="stampValueStatus">
                      <div class="stampValue" id="stampValue${stampValueStatus.count}" style="padding: 0px 5px 5px 5px;">
                        <ucf:text name="stampValue"
                          value="${stampValue}"
                          size="30"
                          enabled="${inEditMode}"/>
                        <c:if test="${inEditMode}">
                          <img id="stampValue${stampValueStatus.count}Grabber" src="${fn:escapeXml(imgUrl)}/icon_grabber.gif"/>
                        </c:if>
                      </div>
                    </c:forEach>
                  </div><%-- this is where js will add new text-inputs --%>
                </td>
                <td style="padding-top: 8px;">
                  <c:if test="${inEditMode}">
                    <a onclick="addAdditionalStamp()" title="${ub:i18n('AddAdditionalStamp')}"><img src="${fn:escapeXml(imgUrl)}/workflow-add.gif" border="0" alt="+"/></a>
                  </c:if>
                </td>
              </tr>
            </table>
          </td>
          <td>
            <span class="inlinehelp">
              ${ub:i18n("BuildPreProcessCriteriaDesc1")}<br/>
              <br/>
              ${ub:i18n("BuildPreProcessCriteriaDesc2")}<br/>
              <br/>
              ${ub:i18n("StampCriteriaDesc")}
            </span>
          </td>
        </tr>
        <%-- ----------------- BEGIN POOL TYPE CODE --------------------------------------------------------------- --%>

        <error:field-error field="${WebConstants.AGENT_POOL_ID}" cssClass="${eo.last}"/>
        <tr class="${eo.next}" valign="top">
          <td align="left" width="15%"><span class="bold">${ub:i18n("AgentPoolWithColon")} <span class="required-text">*</span></span></td>
          <td align="left" width="25%">
              <uiA:agentPoolSelector
                  agentFilter="${agentPool}"
                  disabled="${inViewMode}"
                  allowNoAgent="false"
                  allowParentJobAgent="false"
                  useRadio="true"
                  agentProp="${projectTemplate.preProcessConfig.agentProp}"
                  agentPoolList="${agentPoolList}"
              />
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("BuildPreProcessAgentPoolDesc")}</span>
          </td>
        </tr>
        <%-- ----------------- END FILTER TYPE CODE --------------------------------------------------------------- --%>
        <tr class="${eo.next}">
          <td align="left" width="15%"><span class="bold">${ub:i18n("BuildPreProcessShouldCleanupWithColon")}</span></td>
          <td width="25%">
            <c:set var="yes"  value="${textFieldAttributes}"/>
            <c:set var="no"   value="${textFieldAttributes}"/>
            <c:choose>
              <c:when test="${projectTemplate.preProcessConfig.shouldCleanup}">
                <c:set var="yes" value="checked='checked'"/>
              </c:when>
              <c:otherwise>
                <c:set var="no" value="checked='checked'"/>
              </c:otherwise>
            </c:choose>

            <input ${disabled} type="radio" class="radio" name="shouldCleanup" value="true" ${yes}/>${ub:i18n("Yes")}<br/>
            <input ${disabled} type="radio" class="radio" name="shouldCleanup" value="false" ${no}/>${ub:i18n("No")}<br/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("BuildPreProcessShouldCleanupDesc")}</span>
          </td>
        </tr>
        <tr class="${eo.next}">
          <td align="left" width="15%"><span class="bold">${ub:i18n("StepPreConditionScriptWithColon")}</span></td>
          <td width="25%">
            <ucf:idSelector
              id="preconditionscriptchooser"
              name="${WebConstants.STEP_PRECONDITION_SCRIPT_ID}"
              list="${preConditionScripts}"
              canUnselect="${true}"
              selectedObject="${preConditionScript}"
              enabled="${inEditMode}"
              style="vertical-align: middle;"/>
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("BuildPreProcessStepScriptDesc")}</span>
          </td>
        </tr>
      </tbody>
    </table>

  </div>
  <br/><br/>
  <c:if test="${inEditMode}">
    <ucf:button name="Save" label="${ub:i18n('Save')}"/>
    <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
  </c:if>
  <c:if test="${inViewMode}">
    <c:if test="${canEdit}">
      <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
    </c:if>
    <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </c:if>
  </form>

<jsp:include page="/WEB-INF/jsps/admin/project/projectFooter.jsp"/>
