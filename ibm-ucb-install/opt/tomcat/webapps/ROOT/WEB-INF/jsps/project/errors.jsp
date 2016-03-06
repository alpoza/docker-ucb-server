<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.buildlife.BuildLife"%>
<%@page import="com.urbancode.ubuild.domain.workflow.*"%>
<%@page import="com.urbancode.ubuild.runtime.scripting.helpers.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:url var="imgUrl" value="/images"/>

<%
    WorkflowCase wcase = (WorkflowCase) request.getAttribute(WebConstants.WORKFLOW_CASE);
    if (wcase == null) {
        BuildLife buildLife = (BuildLife) request.getAttribute(WebConstants.BUILD_LIFE);
        wcase = buildLife.getOriginatingWorkflow();
    }
    WorkflowErrorSummary wes = wcase == null ? null : ErrorHelper.getWorkflowErrorSummary(wcase);
    pageContext.setAttribute("wes", wes);
%>
<c:if test="${fn:length(wes.logErrors) > 0 || fn:length(wes.jobTraceErrorSummaryArray) > 0}">
    <table style="width: 100%; table-layout: fixed;"><tr><td style="padding: 0px;">
        <div class="errors">
            <div class="errors_header">${ub:i18n("ErrorsWithColon")}</div>
            <div class="errors_body">
                <img src="${fn:escapeXml(imgUrl)}/icon_error_arrow.gif" alt="-">
                <c:url var="workflowURL" value="${wes.workflowURL}"/>
                <span class="bold"><a href="${fn:replace(workflowURL, '\\', '/')}" title="${ub:i18n('ViewProcess')}">${fn:escapeXml(workflowName)}</a>&nbsp;${ub:i18n("Failed")}</span>
                <c:if test="${fn:length(wes.logErrors) > 0}"><div class="errors_output">${fn:escapeXml(wes.logErrors)}</div></c:if>
                <c:forEach var="jtes" items="${wes.jobTraceErrorSummaryArray}">
                    <div class="errors_section">
                        <img src="${fn:escapeXml(imgUrl)}/icon_error_arrow.gif" alt="-">
                        <c:url var="jobURL" value="${jtes.jobURL}"/>
                        <span class="bold"><a href="${fn:replace(jobURL, '\\', '/')}" title="${ub:i18n('ViewJob')}">${fn:escapeXml(jtes.jobName)}</a>&nbsp;${ub:i18n("Failed")}</span>
                        <c:if test="${fn:length(jtes.logErrors) > 0}"><div class="errors_output">${fn:escapeXml(jtes.logErrors)}</div></c:if>
                        <c:forEach var="stes" items="${jtes.stepTraceErrorSummaryArray}">
                            <div class="errors_section">
                                <img src="${fn:escapeXml(imgUrl)}/icon_error_arrow.gif"  alt="-">
                                <span class="bold">${ub:i18nMessage("StepFailed", fn:escapeXml(stes.stepName))}</span>
                                
                                <c:if test="${fn:length(stes.outputErrors) > 0}">
                                    <div class="errors_section"><img src="${fn:escapeXml(imgUrl)}/icon_error_arrow.gif" alt="-">
                                        &nbsp;
                                        <c:url var="outputURL" value="${stes.outputURL}"/>
                                        <a href="javascript:showPopup('${ah3:escapeJs(fn:replace(outputURL, '\\', '/'))}', windowWidth() - 100, windowHeight() - 100);"
                                       title="${ub:i18n('ViewCommandOutput')}">${ub:i18n("ViewOutputLog")}</a></div>
                                    <pre class="errors_output">${fn:escapeXml(stes.outputErrors)}</pre>
                                </c:if>
                                <c:if test="${fn:length(stes.errorErrors) > 0}">
                                    <div class="errors_section"><img src="${fn:escapeXml(imgUrl)}/icon_error_arrow.gif" alt="-">
                                        &nbsp;
                                        <c:url var="errorURL" value="${stes.errorURL}"/>
                                        <a href="javascript:showPopup('${ah3:escapeJs(fn:replace(errorURL, '\\', '/'))}', windowWidth() - 100, windowHeight() - 100);"
                                       title="${ub:i18n('ViewCommandLog')}">${ub:i18n("ViewErrorLog")}</a></div>
                                    <pre class="errors_output">${fn:escapeXml(stes.errorErrors)}</pre>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>
    </td></tr></table>
</c:if>