<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.workflow.*" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@page import="com.urbancode.commons.util.CollectionUtil" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>

<%@ taglib uri="error" prefix="error" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.util.SnippetBase" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

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

<%
    EvenOdd eo = new EvenOdd();
    pageContext.setAttribute("eo", eo);
    RunWorkflowStepConfig stepConfig = (RunWorkflowStepConfig)request.getAttribute("stepConfig");
%>

<%-- CONTENT --%>
<div class="tab-content">
  <div class="snippet_form">
    <input type="hidden" name="${SnippetBase.SNIPPET_METHOD}" value="saveMainTab">
    <div class="system-helpbox">${ub:i18n("RunWorkflowStepHelp")}</div><br />
    <div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
    <table class="property-table">
        <tbody>
            <c:set var="fieldName" value="${WebConstants.NAME}"/>
            <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
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
            <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
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
                <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
                <tr class="${eo.last}">
                  <td align="left" width="20%">
                    <span class="bold">${ub:i18n("SecondaryProcessWithColon")} <span class="required-text">*</span></span>
                  </td>
                  <c:set var="workflowValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.workflowName}"/>
                  <td colspan="1" align="left" width="20%" nowrap="nowrap">
                    <ucf:text name="${WebConstants.WORKFLOW_NAME}"
                              value="${workflowValue}"
                              enabled="${inEditMode}"/>
                  </td>
                  <td align="left">
                    <span class="inlinehelp">${ub:i18n("RunWorkflowStepSecondaryProcessDesc")}</span>
                  </td>
                </tr>

                <c:set var="fieldName" value="wait"/>
                <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
                <tr class="${eo.last}">
                  <td align="left" width="20%">
                    <span class="bold">${ub:i18n("WaitForProcess")}</span>
                  </td>
                  <td colspan="1" align="left" width="20%">
                    <c:set var="waitValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.waitForWorkflow}"/>
                    <ucf:checkbox  name="wait" value="true" checked="${waitValue}" enabled="${inEditMode}" />
                  </td>
                  <td align="left">
                    <span class="inlinehelp">${ub:i18n("RunWorkflowStepWaitForProcessDesc")}</span>
                  </td>
                </tr>

                <c:set var="fieldName" value="passRequestProperties"/>
                <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
                <tr class="${eo.last}">
                    <td align="left" width="20%">
                        <span class="bold">${ub:i18n("PassProperties")}</span>
                    </td>
                    <td colspan="2">
                        <c:set var="passRequestValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.passRequestProperties.name}"/>
                        <table>
                            <tr>
                                <td align="left" width="25%">
                                    <input class="radio" type="radio" name="passRequestProperties" id="<%=PassPropertiesEnum.NONE.name()%>" value="<%=PassPropertiesEnum.NONE.name()%>" <c:if test="${'NONE' == passRequestValue}">checked="true"</c:if> <c:if test="${!inEditMode}">disabled</c:if> /><label for="<%=PassPropertiesEnum.NONE.name()%>"> ${ub:i18n("PassPropertiesDoNotPass")}</label><br/>
                                </td>
                                <td align="left">
                                    <span class="inlinehelp">
                                        ${ub:i18n("RunWorkflowStepPassPropertiesDoNotPassDesc")}
                                    </span>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="1" align="left" width="25%">
                                    <input class="radio" type="radio" name="passRequestProperties" id="<%=PassPropertiesEnum.MATCHING_NAMES.name()%>" value="<%=PassPropertiesEnum.MATCHING_NAMES.name()%>" <c:if test="${'MATCHING_NAMES' == passRequestValue}">checked="true"</c:if> <c:if test="${!inEditMode}">disabled</c:if> /><label for="<%=PassPropertiesEnum.MATCHING_NAMES.name()%>"> ${ub:i18n("PassPropertiesPassOnlyMatching")}</label><br/>
                                </td>
                                <td align="left">
                                    <span class="inlinehelp">
                                        ${ub:i18n("RunWorkflowStepPassPropertiesPassOnlyMatchingDesc")}
                                    </span>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="1" align="left" width="25%">
                                    <input class="radio" type="radio" name="passRequestProperties" id="<%=PassPropertiesEnum.ALL.name()%>" value="<%=PassPropertiesEnum.ALL.name()%>" <c:if test="${'ALL' == passRequestValue}">checked="true"</c:if> <c:if test="${!inEditMode}">disabled</c:if> /><label for="<%=PassPropertiesEnum.ALL.name()%>"> ${ub:i18n("PassPropertiesPassALL")}</label>
                                </td>
                                <td align="left">
                                    <span class="inlinehelp">
                                        ${ub:i18n("RunWorkflowStepPassPropertiesPassALLDesc")}
                                    </span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <c:set var="fieldName" value="additionalProperties"/>
                <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
                <tr class="${eo.last}">
                    <td align="left" width="20%">
                        <span class="bold">${ub:i18n("AdditionalProperties")}</span>
                    </td>
                    <td colspan="2" align="left">
                      <c:set var="propsValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.additionalProperties}"/>
                      <span class="inlinehelp">${ub:i18n("RunWorkflowStepAdditionalPropertiesDesc")}</span><br/>
                      <ucf:textarea name="additionalProperties" value="${propsValue}" enabled="${inEditMode}"/>
                    </td>
                </tr>

            <tr class="${eo.next}">
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
      <ucf:button name="Save" label="${ub:i18n('Save')}" />
      <ucf:button href='${param.cancelUrl}' name="Cancel" label="${ub:i18n('Cancel')}"/>
    </c:if>
    <c:if test="${inViewMode}">
      <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
    </c:if>

  </div>
</div>
