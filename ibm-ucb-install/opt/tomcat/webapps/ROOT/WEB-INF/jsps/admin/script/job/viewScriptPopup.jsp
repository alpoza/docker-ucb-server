<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="error" prefix="error"%>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>
<div style="padding-bottom: 1em;">
    <div class="popup_header">
        <ul>
            <li class="current">
                <a><c:out value="${ub:i18n(script.name)}" default="${ub:i18n('JobScriptNew')}"/></a>
            </li>
        </ul>
    </div>
    <div class="contents">
        <c:import url="script.jsp"/>
    </div>
</div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
