<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.jobtrace.JobTrace"%>
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
    JobTrace jobTrace = (JobTrace) pageContext.findAttribute(WebConstants.JOB_TRACE);
    JobTraceErrorSummary jtes = ErrorHelper.getJobTraceErrorSummary(jobTrace);
    pageContext.setAttribute("jtes", jtes);
%>
<c:if test="${fn:length(jtes.logErrors) > 0 || fn:length(jtes.stepTraceErrorSummaryArray) > 0}">
    <table style="width: 100%; table-layout: fixed;"><tr><td>
        <div class="errors">
            <div class="errors_header">${ub:i18n("ErrorsWithColon")}</div>
            <div class="errors_body">
                <img src="${fn:escapeXml(imgUrl)}/icon_error_arrow.gif" alt="-">
                <c:url var="jobURL" value="${jtes.jobURL}"/>
                <b><a href="${fn:escapeXml(fn:replace(jobURL, '\\', '/'))}" title="${ub:i18n('ViewJob')}">${fn:escapeXml(jtes.jobName)}</a>&nbsp;${ub:i18n("Failed")}</b>
                <c:if test="${fn:length(jtes.logErrors) > 0}"><pre class="errors_output">${fn:escapeXml(jtes.logErrors)}</pre></c:if>
                <c:forEach var="stes" items="${jtes.stepTraceErrorSummaryArray}">
                    <div class="errors_section">
                        <img src="${fn:escapeXml(imgUrl)}/icon_error_arrow.gif"  alt="-">
                        <b>${fn:escapeXml(stes.stepName)}&nbsp;${ub:i18n("Failed")}</b>
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
        </div>
    </td></tr></table>
</c:if>