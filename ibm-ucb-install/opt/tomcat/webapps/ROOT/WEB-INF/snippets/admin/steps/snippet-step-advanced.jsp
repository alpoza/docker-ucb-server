<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.script.*"%>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="inEditMode" value="${mode == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>
<c:set var="imagesUrl" value="/images"/>

<jsp:useBean id="stepConfigDefaults" class="com.urbancode.ubuild.domain.step.StepConfigDefaults"/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
  pageContext.setAttribute("scriptList", PostProcessScriptFactory.getInstance().restoreAll());
%>

<%-- CONTENT --%>
<div>

  <script type="text/javascript">
    /* <![CDATA[ */
    var UC_STEP_AVANCED_OPTIONS = Class.create({
        initialize: function(showOptions, hideOptions) {
            var t = this;
            this._showOptions = $(showOptions);
            this._hideOptions = $(hideOptions);

            Element.observe(this._showOptions, 'click', function(){t.show()});
            Element.observe(this._hideOptions, 'click', function(){t.hide()});
        },

        show: function(){
            this._showOptions.hide();
            this._hideOptions.show();
            this._showOptions.up().next().show();
            this._resizeWindow();
        },

        hide: function(){
            this._showOptions.show();
            this._hideOptions.hide();
            this._showOptions.up().next().hide();
            this._resizeWindow();
        },

        _resizeWindow: function() {
            if (window.resize) {
                window.resize();
            }
            else if (parent.resizePopup) {
                var pad = $("padding");
                parent.resizePopup(pad.offsetWidth, pad.offsetHeight);
            }
        }
    });

    Element.observe(window, 'load', function(){
        new UC_STEP_AVANCED_OPTIONS('showOptions', 'hideOptions');
    });
    /* ]]> */
  </script>

  <c:set var="plusUrl" value="${imagesUrl}/plus.gif"/>
  <c:set var="minusUrl" value="${imagesUrl}/minus.gif"/>
  <div>
    <a id="showOptions" style="cursor: pointer;"><img src="${plusUrl}" alt=""
        style="vertical-align: middle;"/>${ub:i18n('ShowAdditionalOptions')}</a>
    <a id="hideOptions" style="cursor: pointer; display:none;"><img src="${minusUrl}" alt=""
        style="vertical-align: middle;"/>${ub:i18n('HideAdditionalOptions')}</a>
  </div>

  <table id="advancedRows" class="property-table" style="display: none;">

    <c:set var="curCssClass" value="${eo.next}" scope="request"/>
    <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-active.jsp">
      <jsp:param name="is_active" value="${empty stepConfig ? stepConfigDefaults.active : stepConfig.active}"/>
    </jsp:include>

    <c:set var="curCssClass" value="${eo.next}" scope="request"/>
    <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-run-in-parallel.jsp">
      <jsp:param name="runInParallel" value="${empty stepConfig ? stepConfigDefaults.runInParallel : stepConfig.runInParallel}"/>
    </jsp:include>

    <c:set var="curCssClass" value="${eo.next}" scope="request"/>
    <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-run-in-preflight.jsp">
      <jsp:param name="runInPreflight" value="${empty stepConfig ? stepConfigDefaults.runInPreflight : stepConfig.runInPreflight}"/>
    </jsp:include>
    <c:set var="curCssClass" value="${eo.next}" scope="request"/>
    <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-run-in-preflight-only.jsp">
      <jsp:param name="runInPreflightOnly" value="${empty stepConfig ? stepConfigDefaults.runInPreflightOnly : stepConfig.runInPreflightOnly}"/>
    </jsp:include>

    <c:set var="curCssClass" value="${eo.next}" scope="request"/>
    <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-condition.jsp">
      <jsp:param name="curStepCondId" value="${empty stepConfig ? stepConfigDefaults.preConditionScript.id : stepConfig.preConditionScript.id}"/>
    </jsp:include>

    <c:set var="curCssClass" value="${eo.next}" scope="request"/>
    <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-ignore-failure.jsp">
      <jsp:param name="ignore_my_failures" value="${empty stepConfig ? stepConfigDefaults.ignoreMyFailures : stepConfig.ignoreMyFailures}"/>
    </jsp:include>

    <tr class="${eo.next}">
      <td align="left" width="20%">
        <span class="bold">${ub:i18n("SnippetStepAdvancedPostProcessingScriptWithColon")}</span>
      </td>
      <td align="left" width="20%">
        <div>
          <ucf:idSelector
               id="postprocessscriptchooser"
               name="post_process_script_id"
               emptyMessage="${ub:i18n('UsePluginDefault')}"
               list="${scriptList}"
               selectedId="${empty stepConfig ? null : stepConfig.postProcessScript.id}"
               enabled="${inEditMode}"
               entriesForAutocomplete="101"/>
        </div>
      </td>
      <td align="left">
        <c:set var="chooserId" value="postprocessscriptchooser" scope="request"/>
        <span class="inlinehelp">${ub:i18n("SnippetStepAdvancedPostProcessingScriptDesc")}</span><br/>
        <c:import url="/WEB-INF/snippets/popup/postprocess/script-links.jsp">
          <c:param name="enabled" value="${inEditMode}"/>
        </c:import>
      </td>
    </tr>

    <c:set var="curCssClass" value="${eo.next}" scope="request"/>
    <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-timeout.jsp">
      <jsp:param name="timeout" value="${empty stepConfig ? stepConfigDefaults.timeout : stepConfig.timeout}"/>
    </jsp:include>
  </table>

</div>
