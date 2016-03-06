<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="java.util.*" %>
<%@page import="com.urbancode.ubuild.domain.jobconfig.*"%>
<%@page import="com.urbancode.ubuild.domain.jobtrace.buildlife.*"%>
<%@page import="com.urbancode.ubuild.domain.lock.LockableResourceFactory"%>
<%@page import="com.urbancode.ubuild.domain.notification.*"%>
<%@page import="com.urbancode.ubuild.domain.workflow.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="com.urbancode.commons.xml.*" %>

<%@taglib prefix="c"        uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"       uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"      tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error"    uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

    <div style="margin: 0em 0em; padding-bottom: 1em;">
        <div class="popup_header">
            <ul>
        <c:choose>
                <c:when test="${displayInsertRootJobForm == true}">
                    <c:set var="tabLabel" value="${ub:i18n('LibraryWorkflowInsertStartJob')}"/>
                </c:when>
                <c:when test="${displayInsertEndJobForm == true}">
                    <c:set var="tabLabel" value="${ub:i18n('LibraryWorkflowInsertEndJob')}"/>
                </c:when>
                <c:when test="${displayIterateJobForm == true}">
                    <c:set var="tabLabel" value="${ub:i18n('LibraryWorkflowIterationConfiguration')}"/>
                </c:when>
                <c:when test="${displayInsertJobForm == true}">
                    <c:set var="tabLabel" value="${ub:i18n('LibraryWorkflowInsertJobConfigBefore')}"/>
                </c:when>
                <c:when test="${displayAddJobForm == true}">
                    <c:set var="tabLabel" value="${ub:i18n('LibraryWorkflowInsertJobConfigAfter')}"/>
                </c:when>
                <c:when test="${displaySplitJobForm == true}">
                    <c:set var="tabLabel" value="${ub:i18n('LibraryWorkflowSplitJob')}"/>
                </c:when>
                <c:when test="${displayJobConfigForm == true}">
                    <c:set var="tabLabel" value="${ub:i18n('LibraryWorkflowEditJobConfig')}"/>
                </c:when>
                <c:when test="${displayIterationPropsForm == true}">
                    <c:set var="tabLabel" value="${ub:i18n('LibraryWorkflowIterationProperties')}"/>
                </c:when>
                <c:otherwise>
                    <%-- We should never see this ... --%>
                    <c:set var="tabLabel" value="${ub:i18n('Main')}"/>
                </c:otherwise>
            </c:choose>
                <li class="current"><a>${fn:escapeXml(tabLabel)}</a></li>
            </ul>
        </div>
        <div class="contents">
            <c:choose>
                <c:when test="${displayInsertRootJobForm == true}">
                    <jsp:include page="insertRootJob.jsp"/>
                </c:when>

                <c:when test="${displayInsertEndJobForm == true}">
                    <jsp:include page="insertEndJob.jsp"/>
                </c:when>

                <c:when test="${displayIterateJobForm == true}">
                    <jsp:include page="iterationPlan.jsp"/>
                </c:when>

                <c:when test="${displayInsertJobForm == true}">
                    <jsp:include page="insertJobConfigBefore.jsp"/>
                </c:when>

                <c:when test="${displayAddJobForm == true}">
                    <jsp:include page="insertJobConfigAfter.jsp"/>
                </c:when>

                <c:when test="${displaySplitJobForm == true}">
                    <jsp:include page="splitJob.jsp"/>
                </c:when>

                <c:when test="${displayJobConfigForm == true}">
                    <jsp:include page="editJob.jsp"/>
                </c:when>

                <c:when test="${displayIterationPropsForm == true}">
                    <c:import url="/WEB-INF/jsps/admin/library/workflow/definition/iterationProperties.jsp"/>
                </c:when>

                <c:otherwise>
                    <script type="text/javascript"><!--
                        window.parent.hidePopup();
                    --></script>
                    <noscript>
                        <strong>${ub:i18n("LibraryWorkflowPopupDisplayError")}</strong>
                    </noscript>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
