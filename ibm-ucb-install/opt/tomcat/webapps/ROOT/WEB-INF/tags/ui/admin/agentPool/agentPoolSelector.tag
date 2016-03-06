<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag import="com.urbancode.ubuild.domain.agentpool.AgentPool"%>
<%@tag import="com.urbancode.ubuild.domain.workflow.WorkflowDefinitionJobConfig"%>
<%@tag import="com.urbancode.ubuild.domain.agentpool.AgentPoolFactory"%>
<%@tag import="com.urbancode.ubuild.domain.agentfilter.agentpool.AgentPoolFilter"%>
<%@tag import="com.urbancode.ubuild.domain.agent.AgentFactory" %>
<%@tag import="com.urbancode.ubuild.domain.agentfilter.AgentFilter" %>
<%@tag import="com.urbancode.ubuild.domain.workflow.Workflow" %>
<%@tag import="com.urbancode.ubuild.web.WebConstants"%>
<%@tag import="org.apache.commons.lang3.StringUtils"%>

<%@attribute name="disabled" type="java.lang.Boolean"%>
<%@attribute name="allowNoAgent" type="java.lang.Boolean"%>
<%@attribute name="allowParentJobAgent" type="java.lang.Boolean"%>
<%@attribute name="agentFilter" type="java.lang.Object"%>
<%@attribute name="workflow" type="java.lang.Object"%>
<%@attribute name="useRadio" type="java.lang.Boolean"%>
<%@attribute name="agentProp" type="java.lang.String" %>
<%@attribute name="agentPoolList" type="java.lang.Object" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%
    Workflow workflow = (Workflow) jspContext.getAttribute("workflow");
    AgentPool[] agentPoolList = (AgentPool[])jspContext.getAttribute("agentPoolList");

    boolean allowNoAgent = (Boolean) jspContext.getAttribute("allowNoAgent");
    boolean allowParentJobAgent = (Boolean) jspContext.getAttribute("allowParentJobAgent");

    String agentFilterType = "prev";
    String agentFilterStr = "prev";
    WorkflowDefinitionJobConfig selectedWorkflowDefinitionJobConfig =
            (WorkflowDefinitionJobConfig) request.getAttribute("selectedWorkflowDefinitionJobConfig");

    AgentFilter agentFilter = null;
    AgentPool agentPool = null;
    String agentProp = (String) jspContext.getAttribute("agentProp");

    Object agentFilterAttr = jspContext.getAttribute("agentFilter");
    if (selectedWorkflowDefinitionJobConfig != null) {
        agentFilter = selectedWorkflowDefinitionJobConfig.getJobAgentFilter();
        agentProp = selectedWorkflowDefinitionJobConfig.getAgentProp();
    }
    else {
        // It's new
        agentFilterType = "agentPool";
        agentFilterStr = null;
    }

    if (agentFilterAttr != null) {
        if (agentFilterAttr instanceof AgentFilter) {
            agentFilter = (AgentFilter) agentFilterAttr;
            if (agentFilter instanceof AgentPoolFilter) {
                agentFilterType = "agentPool";
                agentFilterStr = "pool_" + ((AgentPoolFilter) agentFilter).getAgentPool().getId();
            }
        }
        else if (agentFilterAttr instanceof AgentPool) {
            agentPool = (AgentPool) agentFilterAttr;
            agentFilterType = "agentPool";
            agentFilterStr = "pool_" + ((AgentPool) agentPool).getId();
        }
        else {
            agentFilterType = agentFilterAttr.toString();
        }
    }
    else if (agentFilter != null) {
        if (agentFilter instanceof AgentPoolFilter) {
            agentFilterType = "agentPool";
            AgentPoolFilter agentPoolFilter = (AgentPoolFilter) agentFilter;
            if (agentPoolFilter.getAgentPool() != null) {
                agentFilterStr = "pool_" + ((AgentPoolFilter) agentFilter).getAgentPool().getId();
            }
        }
    }
    else if (StringUtils.isNotBlank(agentProp)) {
        agentFilterType = "agentPoolProp";
        agentFilterStr = agentProp;
    }
    else if (selectedWorkflowDefinitionJobConfig != null && selectedWorkflowDefinitionJobConfig.isAgentless()) {
        agentFilterType = "none";
        agentFilterStr = null;
    }

    jspContext.setAttribute("agentFilterStr", agentFilterStr);
    jspContext.setAttribute("agentFilterType", agentFilterType);
%>
<c:choose>
  <c:when test='${!disabled}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="inputAttributes" value=""/>
    <c:set var="buttonAttributes" value="class='button'"/><%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="inputAttributes" value="disabled='true'"/>
    <c:set var="buttonAttributes" value="disabled='true' class='buttondisabled'"/>
  </c:otherwise>
</c:choose>

<script type="text/javascript">
<!--

var preconditionScriptHash = new Hash();
<c:forEach var="preconditionScript" items="${jobPreConditionList}">
<c:if test="${fn:length(preconditionScript.description) > 0}">
preconditionScriptHash.set('<c:out value="${preconditionScript.id}"/>', '<c:out value="${ah3:escapeJs(preconditionScript.description)}"/>');
</c:if>
</c:forEach>

var agentFilterHash = new Hash();
<c:if test="${allowParentJobAgent}">
agentFilterHash.set('prev', "${ub:i18n('AgentPoolSelectorSameAgentAsParent')}");
</c:if>
<c:forEach var="agentPoolFilter" items="${agentPoolList}">
<c:if test="${fn:length(agentPoolFilter.description) > 0}">
agentFilterHash.set('<c:out value="pool_${agentPoolFilter.id}"/>', '<c:out value="${ah3:escapeJs(agentPoolFilter.description)}"/>');
</c:if>
</c:forEach>

var workDirScriptHash = new Hash();
workDirScriptHash.set('prev', "${ub:i18n('AgentPoolSelectorSameWorkDirAsParent')}");
workDirScriptHash.set('source', "${ub:i18n('AgentPoolSelectorSameWorkDirAsSourceConfig')}");
<c:forEach var="tmpWorkDirScript" items="${workDirScriptList}">
<c:if test="${fn:length(tmpWorkDirScript.description) > 0}">
workDirScriptHash.set('<c:out value="script_${tmpWorkDirScript.id}"/>', '<c:out value="${ah3:escapeJs(tmpWorkDirScript.description)}"/>');
</c:if>
</c:forEach>

function preconditionScriptChanged() {
    var selectedIndex = $('${WebConstants.JOB_PRE_CONDITION_ID}').selectedIndex;
    var selectedFilter = selectedIndex == null ? null : $('${WebConstants.JOB_PRE_CONDITION_ID}').options[selectedIndex].value;
    var description = preconditionScriptHash.get(selectedFilter);
    updateField('preconditionScriptDescription', description);
}

function agentFilterTypeChanged() {
  var agentPoolRadio = $('agentPoolRadio');
  var agentPoolPropertyRadio = $('agentPoolPropertyRadio');
  var noAgentFilterRadio = $('noAgentFilterRadio');
  if (agentPoolRadio != null && agentPoolPropertyRadio != null && noAgentFilterRadio != null) {
    var enable_agentPoolFilter = agentPoolRadio.checked;
    var enable_agentPoolProp = agentPoolPropertyRadio.checked;
    var hide_agentPoolFields = noAgentFilterRadio.checked;

    $$('.agentPoolFilter').each(function(element) {
        toggleElement(element, enable_agentPoolFilter);
    });
    $$('.agentPoolPropFilter').each(function(element) {
        toggleElement(element, enable_agentPoolProp);
    });
    $$('#agentBasedJobFields').each(function(element) {
        hideElement(element, hide_agentPoolFields);
    });
  }
  else if (agentPoolRadio != null && agentPoolPropertyRadio != null) {
      var enable_agentPoolFilter = agentPoolRadio.checked;
      var enable_agentPoolProp = agentPoolPropertyRadio.checked;

      $$('.agentPoolFilter').each(function(element) {
          toggleElement(element, enable_agentPoolFilter);
      });
      $$('.agentPoolPropFilter').each(function(element) {
          toggleElement(element, enable_agentPoolProp);
      });
    }
}

function hideElement(element, hide) {
    if (hide) {
        element.hide();
    }
    else {
        element.show();
    }
}

function toggleElement(element, enabled) {
    if (element.nodeName == 'SELECT' || element.nodeName == 'INPUT') {
        if (enabled) {
          enableInput(element);
        }
        else {
            disableInput(element);
        }
    }
    else {
        element.disabled = !enabled;
    }
}

function enableInput(input) {
    var pInput = $(input);
    pInput.removeClassName('inputdisabled');
    pInput.disabled = false;
}

function disableInput(input) {
    var pInput = $(input);
    pInput.addClassName('inputdisabled');
    pInput.disabled = true;
}

function agentPoolChanged() {
    var select = $('agentPoolFilterSelect');
    var selectedIndex = select.selectedIndex;
    var selectedFilter = selectedIndex == null ? null : select.options[selectedIndex].value;
    var description = agentFilterHash.get(selectedFilter);
    updateField('agentFilterDescription', description);
}

function workDirScriptChanged() {
    var selectedIndex = $('${WebConstants.WORK_DIR_SCRIPT_ID}').selectedIndex;
    var selectedFilter = selectedIndex == null ? null : $('${WebConstants.WORK_DIR_SCRIPT_ID}').options[selectedIndex].value;
    var description = workDirScriptHash.get(selectedFilter);
    updateField('workDirScriptDescription', description);
}

// I'd like to find a better way to guarantee that i18n has loaded the data. This seems to be a bit slow because we're loading i18n every time we make a change
function updateField(selector, description) {
  util.i18nLoaded.then(function() {
    $(selector).update(i18n('SelectedItem', i18n(description)));
    if (description) {
      $(selector).show();
    }
    else {
      $(selector).hide();
    }
  });
}

<c:if test="${inEditMode}">
Event.observe(window, 'load', function() { agentFilterTypeChanged(); agentPoolChanged(); });
</c:if>
//-->
</script>

<c:if test="${not empty param.agentPoolTypeRadio}">
  <c:set var="agentFilterType" value="${param.agentPoolTypeRadio}"/>
</c:if>
<c:if test="${not empty param[WebConstants.AGENT_POOL_ID]}">
  <c:set var="agentFilterStr" value="${param[WebConstants.AGENT_POOL_ID]}"/>
</c:if>

<c:if test="${useRadio}">
  <input id="agentPoolRadio"
      type="radio"
      name="agentPoolTypeRadio"
      value="agentPool"
      onchange="agentFilterTypeChanged();"
      ${inputAttributes}
    <c:if test="${agentFilterType eq 'agentPool'}">checked=checked</c:if>
  /> ${ub:i18n("TagAgentPoolSelectorSelection")}
  <div class="inlinehelp" style="margin: 5px 25px 10px 25px;">${ub:i18n("TagAgentPoolSelectorSelectionDesc")}
  </div>
  <div style="margin: 5px 25px 10px 25px;">
</c:if>

<div id="agentPoolSelectionDiv">
  <select id="agentPoolFilterSelect"
        name = "${WebConstants.AGENT_POOL_ID}"
        class="input agentPoolFilter"
        onchange="agentPoolChanged(this);"
        ${inputAttributes}>
    <option value="">--&nbsp;${ub:i18n("MakeSelection")}&nbsp;--</option>
    <c:forEach var="curAgentPool" items="${agentPoolList}">
      <c:set var="agentPoolStr" value="pool_${curAgentPool.id}"/>
      <option value="${agentPoolStr}" <c:if test="${agentPoolStr eq agentFilterStr}">selected=""</c:if>><c:out value="${ub:i18n(curAgentPool.name)}"/></option>
    </c:forEach>
  </select>
</div>
<c:if test="${useRadio}">
</div>
</c:if>

<c:if test="${useRadio}">
  <input id="agentPoolPropertyRadio"
      type="radio"
      name="agentPoolTypeRadio"
      value="prop"
      onchange="agentFilterTypeChanged();"
      ${inputAttributes}
    <c:if test="${agentFilterType eq 'agentPoolProp'}">checked=checked</c:if>
  /> ${ub:i18n("AgentPoolProperty")}
  <div class="inlinehelp" style="margin: 5px 25px 10px 25px;">${ub:i18n("TagAgentPoolSelectorPropertyDesc")}</div>
  <div id="agentPoolPropDiv" style="margin: 5px 25px 10px 25px;">
    <c:if test="${agentFilterType eq 'agentPoolProp'}"><c:set var="propName" value="${agentFilterStr}"/></c:if>
    <input type="text" class="input agentPoolPropFilter" name="${WebConstants.PROPERTY}" size="30" value="${propName}" ${inputAttributes}/>
  </div>
</c:if>

<c:if test="${allowParentJobAgent and useRadio}">
  <input id="parentAgentFilterRadio"
      type="radio"
      name="agentPoolTypeRadio"
      value="prev"
      onchange="agentFilterTypeChanged();"
      ${inputAttributes}
    <c:if test="${agentFilterType eq 'prev'}">checked=checked</c:if>
  /> ${ub:i18n("TagAgentPoolSelectorParent")}
  <div class="inlinehelp" style="margin: 5px 25px 10px 25px;">${ub:i18n("TagAgentPoolSelectorParentDesc")}
  </div>
</c:if>

<c:if test="${allowNoAgent and useRadio}">
  <input id="noAgentFilterRadio"
      type="radio"
      name="agentPoolTypeRadio"
      value="none"
      onchange="agentFilterTypeChanged();"
      ${inputAttributes}
   <c:if test="${agentFilterType eq 'none'}">checked=checked</c:if>
  /> ${ub:i18n("TagAgentPoolSelectorNoAgent")}
  <div class="inlinehelp" style="margin: 5px 25px 10px 25px;">${ub:i18n("TagAgentPoolSelectorNoAgentDesc")}
  </div>
</c:if>

<div id="agentFilterDescription" class="inlinehelp" style="display: none; font-style: italic; margin: 5px 25px 10px 25px;"></div>
