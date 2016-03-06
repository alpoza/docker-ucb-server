<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>
<%@page import="com.urbancode.commons.xml.XMLUtils" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettingsFactory" %>
<%@page import="java.io.*" %>
<%@page import="com.urbancode.air.i18n.TranslateMessage" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('Error')}" />
  <jsp:param name="allowFraming" value="true" />
</jsp:include>

<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('Error')}" href="" enabled="${false}" klass="selected tab"/>
</div>
<div id="content">
  <div class="contents">
    <br/><br/>
    <h2>${ub:i18n('Error')}</h2>
<%
    boolean showError = false;
    try {
        showError = ServerSettingsFactory.getInstance().restore().isShowingErrorTracesInUI();
    }
    catch (Exception e) {}
    pageContext.setAttribute("showError", showError);

    Throwable e = (Throwable) request.getAttribute(WebConstants.EXCEPTION);
    String message = TranslateMessage.translate("UnknownError");
    if (e != null) {
        Class eClass = e.getClass();
        String eFullName = eClass.getName();
        String ePackageName = eClass.getPackage().getName();
        String eName = eFullName.substring(ePackageName.length() + 1);
        String eMessage = e.getMessage();
        if (eMessage == null) {
            eMessage = TranslateMessage.translate("DetailsUnavailable");
        }
        message = eName + ": " + eMessage;
    }

    if (showError) {
        StringWriter stackTrace = new StringWriter();
        e.printStackTrace(new PrintWriter(stackTrace));
        pageContext.setAttribute("stackTrace", stackTrace.toString());
    }
    pageContext.setAttribute("message", message);
%>
    <pre>${fn:escapeXml(message)}</pre>

    <br/>
    <c:if test="${showError}">
      <div style="font-size: xx-small;"><a onclick="$('stacktrace').toggle();">${ub:i18n("MoreInfo")}</a></div>
      <div id='stacktrace'><pre>${fn:escapeXml(stackTrace)}</pre></div>
    </c:if>
    <div id="close-popup-button">
        <br/>
        <br/>
        <ucf:button name="Close" label="${ub:i18n('Close')}" href="javascript:parent.hidePopup();"/>
    </div>

  </div>

</div>

<script type="text/javascript"><!--
    // exception occured within a popup, hide the navigation/login/etc controls
    if (top != self) {
        $('header').hide();
        $('secondLevelTabs').hide();
    }
    if (parent == self) {
        $('close-popup-button').hide();
    }
    <c:if test="${showError}">
    $('stacktrace').hide();
    </c:if>
--></script>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
