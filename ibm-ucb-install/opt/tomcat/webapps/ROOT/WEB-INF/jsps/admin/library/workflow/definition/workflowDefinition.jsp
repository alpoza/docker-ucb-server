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
<%@page import="com.urbancode.ubuild.domain.jobconfig.JobConfig" %>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@page import="com.urbancode.ubuild.domain.workflow.AgentPoolJobIterationPlan"%>
<%@page import="com.urbancode.ubuild.domain.workflow.FixedJobIterationPlan"%>
<%@page import="com.urbancode.ubuild.domain.workflow.JobIterationPlan"%>
<%@page import="com.urbancode.ubuild.domain.workflow.PropertyJobIterationPlan"%>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowDefinition"%>
<%@page import="com.urbancode.ubuild.domain.workflow.WorkflowDefinitionJobConfig"%>
<%@page import="com.urbancode.air.i18n.TranslateMessage"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="com.urbancode.commons.graph.TableDisplayableGraph"%>
<%@page import="com.urbancode.commons.graph.Vertex" %>
<%@page import="java.util.List" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.jobconfig.LibraryJobConfigTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<%
  pageContext.setAttribute( "eo", new EvenOdd() );

  WorkflowDefinitionJobConfig selectedWorkflowDefinitionJobConfig = (WorkflowDefinitionJobConfig) request.getAttribute("selectedWorkflowDefinitionJobConfig");

  WorkflowDefinition workflowDef = (WorkflowDefinition) request.getAttribute(WebConstants.WORKFLOW_DEFINITION);

  TableDisplayableGraph<WorkflowDefinitionJobConfig> jobGraph = null;
  if (workflowDef != null) {
      jobGraph = workflowDef.getWorkflowJobConfigGraph();
      pageContext.setAttribute( "jobGraph", jobGraph );
      jobGraph.calculateVertexSpacing();
  }
%>

<auth:check persistent="${WebConstants.WORKFLOW_TEMPLATE}" var="canEdit" action="${UBuildAction.PROCESS_TEMPLATE_EDIT}"/>

<c:url var="imgUrl" value="/images"/>

<c:url var="editUrl" value="${WorkflowDefinitionTasks.editWorkflowDefinition}">
    <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:url var="saveUrl" value="${WorkflowDefinitionTasks.saveWorkflowDefinition}">
    <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:url var="cancelUrl" value="${WorkflowDefinitionTasks.cancelWorkflowDefinition}">
    <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:url var="insertRootJobConfigUrl" value="${WorkflowDefinitionTasks.insertRootJobConfig}">
    <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:url var="insertEndJobConfigUrl" value="${WorkflowDefinitionTasks.insertEndJobConfig}">
    <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:set var="insertJobConfigAfterUrlBase" value="${WorkflowDefinitionTasks.insertJobConfigAfter}"/>
<c:set var="viewLibJobConfigUrlBase" value='${LibraryJobConfigTasks.viewJobConfig}'/>
<c:set var="editJobConfigUrlBase" value="${WorkflowDefinitionTasks.editJobConfig}"/>
<c:set var="jobConfigIterationPropsUrlBase" value="${WorkflowDefinitionTasks.editJobConfigIterationProps}"/>
<c:set var="insertJobConfigBeforeUrlBase" value="${WorkflowDefinitionTasks.insertJobConfigBefore}"/>
<c:set var="iterateJobConfigUrlBase" value="${WorkflowDefinitionTasks.iterateJobConfig}"/>
<c:set var="splitJobConfigUrlBase" value="${WorkflowDefinitionTasks.splitJobConfig}"/>
<c:set var="removeJobConfigUrlBase" value="${WorkflowDefinitionTasks.removeJobConfig}"/>

<%-- CONTENT --%>
<script type="text/javascript">
  YAHOO.example.onDOMReady = function(p_sType) {
      var showContextMenu = function(e,elementId) {
          this.show();
          YAHOO.util.Dom.setXY(YAHOO.util.Dom.get(elementId),YAHOO.util.Event.getXY(e));
      }

      var startMenu = new YAHOO.widget.ContextMenu("startMenu", { clicktohide: true, zIndex: 2, lazyload: true });
      startMenu.render();
      YAHOO.util.Event.addListener("startImg", "click", showContextMenu, 'startMenu', startMenu);

      var stopMenu = new YAHOO.widget.ContextMenu("stopMenu", { clicktohide: true, zIndex: 2, lazyload: true });
      stopMenu.render();
      YAHOO.util.Event.addListener("stopImg", "click", showContextMenu, 'stopMenu', stopMenu);

      <c:forEach var="wfDefJobConfig" items="${workflowDef.workflowJobConfigArray}" varStatus="i">
          var jobMenu${i.count} = new YAHOO.widget.ContextMenu("jobMenu${ah3:escapeJs(wfDefJobConfig.id)}", {clicktohide: true, zIndex: 2, lazyload: true});
          jobMenu${i.count}.render();
          YAHOO.util.Event.addListener("jobImg${ah3:escapeJs(wfDefJobConfig.id)}", "click", showContextMenu, 'jobMenu${ah3:escapeJs(wfDefJobConfig.id)}', jobMenu${i.count});
      </c:forEach>
  };
  YAHOO.util.Event.onDOMReady(YAHOO.example.onDOMReady);
</script>

<br/>

<c:url var="helpUrl" value="${WorkflowDefinitionTasks.viewWorkflowHelp}">
    <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
</c:url>
<c:if test="${canEdit}">
  ${ub:i18n("LibraryWorkflowDefinitionHelpMessage")} &nbsp;
  <a href="#" onclick="showPopup('${fn:escapeXml(helpUrl)}',800,600);return false;">
    <img src="${fn:escapeXml(imgUrl)}/icon_help.gif" border="0" title="${ub:i18n('Help')}" alt="${ub:i18n('Help')}"/>
  </a>
</c:if>

<error:field-error field="workflowDef" cssClass="${eo.next}"/>

<table>
    <tr>
        <td style="padding: 0;">
            <table class="workflowdef-table">
                <tr>
                    <td align="center" class="workflowdef<c:if test="${displayInsertRootJobForm}">-selected</c:if>" colspan="${jobGraph.width}">
                        <c:choose>
                            <c:when test="${canEdit}">
                                <a id="startImg" style="cursor: pointer;" title="${ub:i18n('LibraryWorkflowDefinitionHoverMessage')}"><img src="<c:url value="/images/icon_workflow_start.gif"/>" alt="${ub:i18n('LibraryWorkflowStartAlt')}" border="0"></a>
                                <div id="startMenu" class="yuimenu" style="position: absolute; visibility: hidden">
                                    <div class="bd">
                                        <ul class="first-of-type">
                                            <li class="yuimenuitem">
                                                <a href="javascript:showPopup('${fn:escapeXml(insertRootJobConfigUrl)}',800,600);">${ub:i18n("LibraryWorkflowInsertJobAfter")}</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value="/images/icon_workflow_start.gif"/>" alt="${ub:i18n('LibraryWorkflowStartAlt')}" border="0" />
                            </c:otherwise>
                        </c:choose>
                        <br/>
                        ${ub:i18n("LibraryWorkflowStart")}
                        <br/>
                        <c:if test="${jobGraph.sourceVertexCount > 1}">
                            <div class="workflowdef-split">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ub:i18n("LibraryWorkflowSplit")}
                            </div>
                        </c:if>
                    </td>
                </tr>
                <%
                int maxDepth = 0;
                if (jobGraph != null) {
                    maxDepth = jobGraph.getMaxDepth();
                }
                for (int depth = 1; depth <= maxDepth; ++depth) {
                %>
                <tr>
                    <%
                    List vertexList = jobGraph.getVerticesAtDepth( depth );
                    for (int x=0; x < vertexList.size(); ++x) {
                        Vertex vertex = (Vertex)vertexList.get( x );
                        WorkflowDefinitionJobConfig wfDefJobConfig = (WorkflowDefinitionJobConfig)vertex.getData();
                        pageContext.setAttribute( "depth", new Integer(depth));
                        pageContext.setAttribute( "wfDefJobConfig", wfDefJobConfig );
                        pageContext.setAttribute( "vertex", vertex );

                        String iterationStr = "";
                        JobIterationPlan iterationPlan = wfDefJobConfig.getJobIterationPlan();
                        if (iterationPlan instanceof AgentPoolJobIterationPlan) {
                            AgentPoolJobIterationPlan agentPoolIterationPlan = (AgentPoolJobIterationPlan) iterationPlan;
                            if (agentPoolIterationPlan.isRequiringAllAgents()) {
                                iterationStr = " <span class=\"iteration\" title=\"" + TranslateMessage.translate("LibraryWorkflowIterateOnAllAgentsMessage")
                                        + "\">x " + TranslateMessage.translate("All") + "</span>";
                            }
                            else {
                                iterationStr = " <span class=\"iteration\" title=\"" + TranslateMessage.translate("LibraryWorkflowIterateOnAllOnlineMessage")
                                        + "\">x " + TranslateMessage.translate("Online") + "</span>";
                            }
                        }
                        else if (iterationPlan instanceof PropertyJobIterationPlan) {
                            PropertyJobIterationPlan propertyIterationPlan = (PropertyJobIterationPlan) iterationPlan;
                            iterationStr = " <span class=\"iteration\" title=\"" + TranslateMessage.translate("LibraryWorkflowIterateForPropertyMessage")
                                    + "'" + propertyIterationPlan.getPropertyName() + "'\"> x" + TranslateMessage.translate("Property") + "</span>";
                        }
                        else if (iterationPlan instanceof FixedJobIterationPlan) {
                            int iterations = iterationPlan.getIterations();
                            iterationStr = " <span class=\"iteration\" title=\"" + TranslateMessage.translate("LibraryWorkflowIterateOnSomeAgentsMessage", Integer.toString(iterations))
                                    +"\">x " + iterations + "</span>";
                        }
                        pageContext.setAttribute( "iterationStr", iterationStr );
                        pageContext.setAttribute( "iterationPlan", iterationPlan );
                        pageContext.setAttribute( "preConditionScript", wfDefJobConfig.getJobPreConditionScript());
                        pageContext.setAttribute( "agentFilter", wfDefJobConfig.getJobAgentFilter());
                        pageContext.setAttribute( "workDirScript", wfDefJobConfig.getJobWorkDirScript());
                        pageContext.setAttribute( "useParentWorkDir", wfDefJobConfig.isJobUsingParentWorkDir());
                        pageContext.setAttribute( "useSourceWorkDirScript", wfDefJobConfig.isJobUsingSourceWorkDirScript());
                    %>
                    <td align="center" class="<%= wfDefJobConfig.equals(selectedWorkflowDefinitionJobConfig) ? "workflowdef-selected" : "workflowdef" %>" nowrap="nowrap" colspan="${vertex.width}" rowspan="${vertex.height}">
                        <div style="display: none;" class="job-config-graph-debug-info">depth='${vertex.depth}',&nbsp;order='${vertex.order}',&nbsp;colspan='${vertex.width}',&nbsp;rowspan='${vertex.height}'</div>
                        <c:if test="${vertex.joining}">
                            <div class="workflowdef-join">
                                ${ub:i18n("LibraryWorkflowJoin")}
                            </div>
                        </c:if>
                        <c:choose>
                            <c:when test="${canEdit}">
                                <a id="jobImg${fn:escapeXml(wfDefJobConfig.id)}" style="cursor: pointer;" title="${ub:i18n('LibraryWorkflowDefinitionHoverMessage')}"><img src="<c:url value="/images/icon_workflow_gear.gif"/>" alt="${ub:i18n('LibraryWorkflowWorkflowGear')}" border="0"></a>
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value="/images/icon_workflow_gear.gif"/>" alt="${ub:i18n('LibraryWorkflowWorkflowGear')}" border="0" />
                            </c:otherwise>
                        </c:choose>
                        <c:url var="tempViewJobConfigUrl" value="${viewLibJobConfigUrlBase}">
                          <c:param name="${WebConstants.JOB_CONFIG_ID}" value="${wfDefJobConfig.jobConfig.id}"/>
                        </c:url>
                        <c:url var="tempEditJobConfigUrl" value="${editJobConfigUrlBase}">
                            <c:param name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${wfDefJobConfig.id}"/>
                            <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                        </c:url>
                        <c:url var="tempInsertJobConfigAfterUrl" value="${insertJobConfigAfterUrlBase}">
                            <c:param name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${wfDefJobConfig.id}"/>
                            <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                        </c:url>
                        <c:url var="tempInsertJobConfigBeforeUrl" value="${insertJobConfigBeforeUrlBase}">
                            <c:param name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${wfDefJobConfig.id}"/>
                            <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                        </c:url>
                        <c:url var="tempIterateJobConfigUrl" value="${iterateJobConfigUrlBase}">
                            <c:param name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${wfDefJobConfig.id}"/>
                            <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                        </c:url>
                        <c:url var="tempJobConfigIterationPropsUrl" value="${jobConfigIterationPropsUrlBase}">
                            <c:param name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${wfDefJobConfig.id}"/>
                            <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                        </c:url>
                        <c:url var="tempSplitJobConfigUrl" value="${splitJobConfigUrlBase}">
                            <c:param name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${wfDefJobConfig.id}"/>
                            <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                        </c:url>
                        <c:url var="tempRemoveJobConfigUrl" value="${removeJobConfigUrlBase}">
                            <c:param name="${WebConstants.WORKFLOW_DEFINITION_JOB_CONFIG_ID}" value="${wfDefJobConfig.id}"/>
                            <c:param name="${WebConstants.WORKFLOW_TEMPLATE_ID}" value="${workflowTemplate.id}"/>
                        </c:url>

                        <c:if test="${canEdit}">
                          <div id="jobMenu${wfDefJobConfig.id}" class="yuimenu" style="position: absolute; visibility: hidden">
                            <div class="bd">
                                <ul class="first-of-type">
                                    <li class="yuimenuitem">
                                        <a href="javascript:showPopup('${ah3:escapeJs(tempEditJobConfigUrl)}',800,600);">${ub:i18n("LibraryWorkflowEditConfiguration")}</a>
                                    </li>
                                    <li class="yuimenuitem">
                                        <a href="${tempViewJobConfigUrl}">${ub:i18n("LibraryWorkflowEditJobSteps")}</a>
                                    </li>
                                    <li class="yuimenuitem">
                                        <a href="javascript:showPopup('${ah3:escapeJs(tempInsertJobConfigBeforeUrl)}',800,600);">${ub:i18n("LibraryWorkflowInsertJobBefore")}</a>
                                    </li>
                                    <li class="yuimenuitem">
                                        <a href="javascript:showPopup('${ah3:escapeJs(tempInsertJobConfigAfterUrl)}',800,600);">${ub:i18n("LibraryWorkflowInsertJobAfter")}</a>
                                    </li>
                                    <li class="yuimenuitem">
                                        <a href="javascript:showPopup('${ah3:escapeJs(tempIterateJobConfigUrl)}',800,600);">${ub:i18n("LibraryWorkflowIterateJob")}</a>
                                    </li>
                                    <c:if test='<%= !iterationStr.equals("") && !iterationStr.contains("> x" + TranslateMessage.translate("Property") + "</span>") %>'>
                                        <li class="yuimenuitem">
                                            <a href="javascript:showPopup('${ah3:escapeJs(tempJobConfigIterationPropsUrl)}',800,600);">${ub:i18n("LibraryWorkflowIterationProperties")}</a>
                                        </li>
                                    </c:if>
                                    <c:if test="${!vertex.joining && !vertex.splitting}">
                                        <li class="yuimenuitem">
                                            <a href="javascript:showPopup('${ah3:escapeJs(tempSplitJobConfigUrl)}',800,600);">${ub:i18n("LibraryWorkflowAddParallelJob")}</a>
                                        </li>
                                    </c:if>
                                    <c:if test="${!vertex.joining || !vertex.splitting}">
                                        <li class="yuimenuitem">
                                            <ucf:deletelink href="${tempRemoveJobConfigUrl}" name="${wfDefJobConfig.jobConfig.name}"/>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>
                          </div>
                        </c:if>
                        <br/>
                        <%-- DO NOT ESCAPE iterationStr --%>
                        <div>
                          <c:out value="${wfDefJobConfig.jobConfig.name}"/> ${iterationStr}
                        </div>

                        <c:choose>
                          <c:when test="${wfDefJobConfig.agentless}">
                            <c:set var="agentOutDefaultVal" value="${ub:i18n('NoAgent')}" />
                          </c:when>
                          <c:when test="${not empty wfDefJobConfig.agentProp}">
                            <c:set var="agentOutDefaultVal" value="${wfDefJobConfig.agentProp}" />
                          </c:when>
                          <c:otherwise>
                            <c:set var="agentOutDefaultVal" value='${ub:i18n("LibraryWorkflowDefinitionAsParent")}' />
                          </c:otherwise>
                        </c:choose>

                        <div class="workflowdef-details">
                          ${ub:i18n("PreConditionWithColon")}&nbsp;<c:out value="${ub:i18n(preConditionScript.name)}" default="&lt;${ub:i18n('LibraryWorkflowDefinitionAlways')}&gt;"/><br/>
                          ${ub:i18n("AgentWithColon")}&nbsp;<c:out value="${agentFilter.name}" default="${agentOutDefaultVal}"/><br/>
                          ${ub:i18n("WorkDirWithColon")}&nbsp;
                          <c:choose>
                            <c:when test="${useSourceWorkDirScript}">${ub:i18n("LibraryWorkflowDefinitionAsSource")}</c:when>
                            <c:when test="${useParentWorkDir}">${ub:i18n("LibraryWorkflowDefinitionAsParent")}</c:when>
                            <c:otherwise><c:out value="${workDirScript.name}" default="${ub:i18n('NoneLowercaseInBrackets')}"/></c:otherwise>
                          </c:choose><br/>
                          <c:if test="${not empty workDirScript or useSourceWorkDirScript or not empty agentFilter}">
                            ${ub:i18n("LibraryWorkflowDefinitionLockDuration")}&nbsp;<%= wfDefJobConfig.isJobLockForWorkflow() ? TranslateMessage.translate("Process") : TranslateMessage.translate("Job") %>
                            <br/>
                            ${ub:i18n("LibraryWorkflowWorkingDirectoryCleanup")}&nbsp;<c:out value="${ub:i18n(wfDefJobConfig.cleanupChoice.name)}" default="${ub:i18n('Never')}"/>
                          </c:if>
                        </div>

                        <%-- Some useful table spacing debugging information. --%>
                        <%-- [${colspan},${rowspan}]<br/> --%>

                        <c:if test="${vertex.splitting}">
                            <div class="workflowdef-split">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ub:i18n("LibraryWorkflowSplit")}
                            </div>
                        </c:if>
                    </td>
                    <% } %>
                </tr>
                <% } %>
                <tr>
                    <td align="center" class="workflowdef<c:if test="${displayInsertEndJobForm}">-selected</c:if>" colspan="${jobGraph.width}">
                        <c:if test="${jobGraph.sinkVertexCount > 1}">
                            <div class="workflowdef-join">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ub:i18n("LibraryWorkflowJoin")}
                            </div>
                        </c:if>
                        <c:choose>
                            <c:when test="${canEdit}">
                                <a id="stopImg" style="cursor: pointer;" title="${ub:i18n('LibraryWorkflowDefinitionHoverMessage')}"><img src="<c:url value="/images/icon_workflow_stop.gif"/>" alt="${ub:i18n('LibraryWorkflowStopAlt')}"></a>
                                <div id="stopMenu" class="yuimenu" style="position: absolute; visibility: hidden">
                                    <div class="bd">
                                        <ul class="first-of-type">
                                            <li class="yuimenuitem">
                                                <a href="javascript:showPopup('${ah3:escapeJs(insertEndJobConfigUrl)}',800,600);">${ub:i18n("LibraryWorkflowInsertJobBefore")}</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value="/images/icon_workflow_stop.gif"/>" alt="${ub:i18n('LibraryWorkflowStopAlt')}" />
                            </c:otherwise>
                        </c:choose>
                        <br/>
                        ${ub:i18n("LibraryWorkflowStop")}
                        <br/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<br/>
