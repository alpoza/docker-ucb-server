<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.agents.AgentTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose>
  <c:when test="${not workflow.usingOverrideableDynamicProperties}">
    <c:set var="actionUrl" value="${BuildLifeTasks.runNonOriginatingWorkflowStep3}" />
  </c:when>
  <c:otherwise>
    <c:set var="actionUrl" value="${BuildLifeTasks.runNonOriginatingWorkflowStep2}" />
  </c:otherwise>
</c:choose>

<c:url var="iconPlusUrl" value="/images/icon_plus_sign.gif"/>
<c:url var="iconMinusUrl" value="/images/icon_minus_sign.gif"/>

<c:url var="getEnvAgentsUrl" value="${AgentTasks.getEnvironmentConfiguredAgentList}"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%-- CONTENT --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<script type="text/javascript">
</script>

    <div class="popup_header">
      <ul>
          <li class="current"><a>${ub:i18n("Run Secondary Process")}</a></li>
      </ul>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("RunSecondaryProcessHelp")}</div>

        <%
          pageContext.setAttribute("eo", new EvenOdd());
        %>
        <br/>
        <form action="${fn:escapeXml(actionUrl)}" method="post">

          <div align="right" style="border-top :0px; vertical-align: bottom;">
            <input type="hidden" name="${fn:escapeXml(WebConstants.BUILD_LIFE_ID)}" value="${fn:escapeXml(buildLife.id)}"/>
            <span class="required-text">${ub:i18n("RequiredField")}</span>
          </div>
          <table class="property-table" border="0">
            <tbody>
              <c:import url="/WEB-INF/jsps/project/workflow/administrativeLockWarning.jsp"/>

              <error:field-error field="${WebConstants.WORKFLOW_ID}" cssClass="${eo.next}" />
              <tr class="${eo.last}" valign="top">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("ProcessWithColon")} <span class="required-text">*</span></span>
                </td>

                <td align="left" width="25%">
                  ${fn:escapeXml(workflow.name)}
                  <input type="hidden" name="${fn:escapeXml(WebConstants.WORKFLOW_ID)}" value="${fn:escapeXml(workflow.id)}" />
                </td>

                <td align="left">
                  <span class="inlinehelp">${ub:i18n("RunSecondaryProcessProcessDesc")}</span>
                </td>
              </tr>

            </tbody>

            <tbody>
              <error:field-error field="delayDateTime" cssClass="${eo.next}" />
              <tr class="${eo.last}">
                <td width="20%">
                  <span class="bold">${ub:i18n("Delay")}</span>
                </td>
                <td nowrap="nowrap">
                  <input type="checkbox" class="checkbox" name="delayed"
                    <c:if test="${screenOne}">disabled</c:if> ${delayed}
                          onclick="if (this.checked) { showLayer('delayBuild'); } else { hideLayer('delayBuild'); }">
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("RunSecondaryProcessDelayDesc")}</span>
                </td>
              </tr>
            </tbody>

            <tbody id="delayBuild" <c:if test="${delayed == null}">style="display: none;visibility: visibility;"</c:if>>
              <tr class="${eo.last}">
                <td width="20%">&nbsp;</td>
                <td colspan="2">
                  <ucf:text name="delayDateTime" value="${delayDateTime}" size="20" /> &nbsp;
                  <select name="delayMeridiem">
                    <option value="AM"<c:if test="${delayMeridiem == 'AM'}">selected</c:if>>AM</option>
                    <option value="PM"<c:if test="${delayMeridiem == 'PM'}">selected</c:if>>PM</option>
                  </select>
                  <br/>
                  <i>(mm/dd/yyyy hh:mm)</i>
                </td>
              </tr>
            </tbody>

            <c:if test="${not workflow.usingOverrideableDynamicProperties}">
              <tbody>
                <c:if test="${workflow.overriddenProperties}">
                  <tr class="${eo.next}">
                    <td colspan="3">
                      <h3>${ub:i18n("ProcessProperties")}</h3>
                    </td>
                  </tr>
                </c:if>
              </tbody>

              <tbody id="workflowPropsLayer">
                <c:import url="/WEB-INF/jsps/project/workflow/workflowProperties.jsp">
                  <c:param name="isEven" value="${eo.even}"/>
                </c:import>
              </tbody>
            </c:if>

        </table>

        <br/>
        <c:choose>
          <c:when test="${not workflow.usingOverrideableDynamicProperties}">
            <ucf:button name="Run" label="${ub:i18n('Run')}" />
          </c:when>
          <c:otherwise>
            <ucf:button name="Next" label="${ub:i18n('Next')}" />
          </c:otherwise>
        </c:choose>
        <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="javascript:parent.hidePopup();" />
      </form>
    </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
