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
<%@page import="com.urbancode.ubuild.domain.cleanup.CleanupConfig" %>
<%@page import="com.urbancode.ubuild.domain.schedule.*" %>
<%@page import="com.urbancode.ubuild.domain.status.Status" %>
<%@page import="com.urbancode.ubuild.domain.persistent.Handle" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.cleanup.CleanupTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="submitUrl" value="${CleanupTasks.saveCleanupBuildRequestsPopup}"/>
<%
CleanupConfig cleanupConfig = (CleanupConfig) pageContext.findAttribute("cleanupConfig");
%>
<% EvenOdd eo = new EvenOdd(); %>

<%-- BEGIN PAGE --%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<div style="padding-bottom: 1em;">
    <div class="popup_header">
        <ul>
            <li class="current">
                <a>${ub:i18n("CleanupBuildRequests")}</a>
            </li>
        </ul>
    </div>
    <div class="contents">
    <div class="system-helpbox">
    ${ub:i18n("CleanupBuildRequestsPopupSystemHelpBox")}
    </div>
    <br />
        <form method="post" action="${fn:escapeXml(submitUrl)}">
            <table class="property-table">
                <tbody>
                    <%
                    if (cleanupConfig.getMiscExpire() != Integer.MAX_VALUE) {
                        pageContext.setAttribute("expirationValue", new Integer(cleanupConfig.getMiscExpire()));
                    } else {
                        pageContext.setAttribute("expirationValue", null);
                    }
                    %>
                    <error:field-error field="${WebConstants.CLEANUP_MISC_EXPIRE}" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("MiscJobsWithColon")} </span></td>
                        <td align="left" width="20%">
                            <b>${ub:i18n("CleanupDays")}</b><br/>
                            <ucf:text name="${WebConstants.CLEANUP_MISC_EXPIRE}" value="${expirationValue}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("CleanupBuildRequestsPopupMiscJobsDesc")}</span>
                        </td>
                    </tr>
                    
                    <%
                    if (cleanupConfig.getBuildRequestExpire() != Integer.MAX_VALUE) {
                        pageContext.setAttribute("expirationValue", new Integer(cleanupConfig.getBuildRequestExpire()));
                    } else {
                        pageContext.setAttribute("expirationValue", null);
                    }
                    %>
                    <error:field-error field="${WebConstants.CLEANUP_REQUEST_EXPIRE}" cssClass="<%= eo.getNext() %>"/>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("CleanupBuildRequestsWOBuildLive")} </span></td>
                        <td align="left" width="20%">
                            <b>${ub:i18n("CleanupDays")}</b><br/>
                            <ucf:text name="${WebConstants.CLEANUP_REQUEST_EXPIRE}" value="${expirationValue}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("CleanupBuildRequestsWOBuildLiveDesc")}</span>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="3">
                            <ucf:button name="save" label="${ub:i18n('Save')}"/>
                            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="parent.hidePopup(); return false;"/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>        
    </div>
</div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>