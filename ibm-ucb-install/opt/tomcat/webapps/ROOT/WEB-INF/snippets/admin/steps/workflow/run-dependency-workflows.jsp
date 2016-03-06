<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.workflow.RunDependencyWorkflowsStepConfig" %>
<%@ page import="com.urbancode.ubuild.web.admin.project.workflow.RunDependencyWorkflowsSnippet" %>
<%@ page import="com.urbancode.ubuild.web.*"%>
<%@ page import="com.urbancode.ubuild.web.util.*" %>

<%@ taglib uri="error" prefix="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.domain.workflow.RunDependencyWorkflowsStepConfig" />

<c:choose>
  <c:when test='${mode == "edit"}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="textFieldAttributes" value=""/><%--normal attributes for text fields--%>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="textFieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<% EvenOdd eo = new EvenOdd(); %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<div class="tab-content">
  <div class="snippet_form">
    <input type="hidden" name="<%= SnippetBase.SNIPPET_METHOD%>" value="saveMainTab">
    <div class="system-helpbox">${ub:i18n("RunDependencyWorkflowStepHelp")}</div><br />
    <div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
    <table class="property-table">

      <tbody>
        <c:set var="fieldName" value="${WebConstants.NAME}"/>
        <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
          </td>
          <td align="left" width="20%">
            <c:set var="nameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.name}"/>
            <ucf:text name="${WebConstants.NAME}" value="${nameValue}" enabled="${inEditMode}"/>
          </td>
          <td align="left">
            <span class="inlinehelp">&nbsp;</span>
          </td>
        </tr>
    
        <c:set var="fieldName" value="${WebConstants.DESCRIPTION}"/>
        <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("DescriptionWithColon")} </span>
          </td>
          <td align="left" colspan="2">
            <c:set var="descriptionValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.description}"/>
            <span class="inlinehelp">${ub:i18n("StepDescriptionDesc")}</span><br/>
            <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${descriptionValue}" enabled="${inEditMode}"/>
          </td>
        </tr>
    
        <c:set var="fieldName" value="${WebConstants.WORKFLOW_NAME}"/>
        <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("SecondaryProcessWithColon")} <span class="required-text">*</span></span>
          </td>
          <td colspan="1" align="left" width="20%">
            <c:set var="workflowNameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.workflowName}"/>
            <ucf:text  name="${WebConstants.WORKFLOW_NAME}" value="${workflowNameValue}" enabled="${inEditMode}" />
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("RunDependencyWorkflowStepSecondaryProcessDesc")}</span>
          </td>
        </tr>
        
        <c:set var="fieldName" value="strategy"/>
        <error:field-error field="${fieldName}" cssClass="<%=eo.getNext()%>"/>
        <tr class="<%=eo.getLast()%>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("ExecutionStrategy")} </span>
          </td>
    
          <c:set var="queueCheck" value="${param[fieldName] == RunDependencyWorkflowsStepConfig.QUEUE_REQUESTS}"/>
          <c:set var="waitCheck" value="${param[fieldName] == RunDependencyWorkflowsStepConfig.WAIT_FOR_WORKFLOW}"/>
          <c:set var="parallelCheck" value="${param[fieldName] == RunDependencyWorkflowsStepConfig.PARALLEL_WAIT}"/>
          <td align="left" colspan="2">
            <input type="radio"
               class="radio"
               name="strategy"
               value="${RunDependencyWorkflowsStepConfig.QUEUE_REQUESTS}"
               <c:if test="${queueCheck ? queueCheck : stepConfig.queueRequests}">checked="true"</c:if>>${ub:i18n("RunDependencyWorkflowStepQueueDesc")}</input>
            <br/><br/>
            <%--
            <input type="radio"
               class="radio"
               name="strategy"
               value="${RunDependencyWorkflowsStepConfig.WAIT_FOR_WORKFLOW}"
               <c:if test="${waitCheck ? waitCheck : stepConfig.waitForWorkflows}">checked="true"</c:if>>Run processes serially and wait for each to complete.</input>
            <br/><br/>
            --%>
            <input type="radio"
               class="radio"
               name="strategy"
               value="${RunDependencyWorkflowsStepConfig.PARALLEL_WAIT}"
               <c:if test="${parallelCheck ? parallelCheck : stepConfig.parallelWait}">checked="true"</c:if>>${ub:i18n("RunDependencyWorkflowStepParallelWaitDesc")}</input>
          </td>
        </tr>
    
        <c:set var="fieldName" value="failIfNotFound"/>
        <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("FailIfNotFound")} </span>
          </td>
          <td colspan="1" align="left" width="20%">
            <c:set var="failValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.failIfNotFound}"/>
            <ucf:checkbox  name="failIfNotFound" value="true" checked="${failValue}" enabled="${inEditMode}" />
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("RunDependencyWorkflowStepFailIfNotFoundDesc")}</span>
          </td>
        </tr>
        
        <c:set var="fieldName" value="runOnDepHierarchy"/>
        <error:field-error field="${fieldName}" cssClass="<%= eo.getNext() %>"/>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("RunOnDependencyHierarchy")} </span>
          </td>
          <td colspan="1" align="left" width="20%">
            <c:set var="runDepValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.runOnDepHierarchy}"/>
            <ucf:checkbox  name="runOnDepHierarchy" value="true" checked="${runDepValue}" enabled="${inEditMode}" />
          </td>
          <td align="left">
            <span class="inlinehelp">${ub:i18n("RunDependencyWorkflowStepRunOnDependencyHierarchyDesc")}</span>
          </td>
        </tr>
    
        <c:set var="fieldName" value="${RunDependencyWorkflowsSnippet.PROPERTY_MAP}"/>
        <%
          RunDependencyWorkflowsStepConfig stepConfig = (RunDependencyWorkflowsStepConfig)pageContext.findAttribute("stepConfig");
          String propertyString = "";
          if (stepConfig != null) {
              String[] propertyNames = stepConfig.getPropertyNames();
    
              for (int i = 0; i< propertyNames.length; i++) {
                propertyString+=propertyNames[i]+"="+stepConfig.getProperty(propertyNames[i])+"\n";
              }
              
              pageContext.setAttribute("propertyString", propertyString);
          }
        %>
        <tr class="<%= eo.getLast() %>">
          <td align="left" width="20%">
            <span class="bold">${ub:i18n("PropertiesWithColon")}</span>
          </td>
          <td colspan="2" align="left">
            <c:set var="propStringValue" value="${empty propertyString ? param[fieldName] : propertyString}"/>
            <span class="inlinehelp">${ub:i18n("RunDependencyWorkflowStepPropertiesDesc")}</span><br/>
            <ucf:textarea  name="<%=RunDependencyWorkflowsSnippet.PROPERTY_MAP %>" value="${propStringValue}" cols="60" rows="6" enabled="${inEditMode}" />
          </td>
        </tr>
    
              <tr class="<%=eo.getNext()%>">
                <td colspan="3">
                  <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-advanced.jsp">
                    <jsp:param name="editUrl" value="${param.editUrl}"/>
                    <jsp:param name="showAdvanced" value="${param.showAdvanced}"/>
                  </jsp:include>
                </td>
              </tr>
    
    
      </tbody>
    </table>
    <br/>
    <c:if test="${inEditMode}">
      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
      <ucf:button href='${param.cancelUrl}' name="Cancel" label="${ub:i18n('Cancel')}"/>
    </c:if>
    <c:if test="${inViewMode}">
      <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
    </c:if>
  
  </div>
</div>
