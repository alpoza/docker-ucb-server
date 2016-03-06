<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2011, 2013. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>
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
    <h2>${fn:escapeXml(ub:i18n('CsrfTitle'))}</h2>

    <div>
      <div>
          ${fn:escapeXml(ub:i18n('CsrfMessage'))}<br/><br/>
          <div style="margin: 1em 0em">
              ${fn:escapeXml(ub:i18n("Destination"))} ${fn:escapeXml(requestedUri)}<br/>
              ${fn:escapeXml(ub:i18n("ConfirmContinueToProceed"))}<br/><br/>
              <ucf:button name="Continue" label="${ub:i18n('Continue')}" href="${requestedUri}"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          </div>

          <div style="margin: 1em 0em">
              ${fn:escapeXml(ub:i18n("GoToDashboard"))} <a href="${fn:escapeXml(baseUri)}">${fn:escapeXml(baseUri)}</a><br/>
              <ucf:button name="Go To Dashboard" label="${ub:i18n('GoToDashboardButton')}" href="${baseUri}"/>
          </div>
      </div>

    <br />
    <div id="close-popup-button">
        <br />
        <br />
        <ucf:button name="Close" label="${ub:i18n('Close')}" href="javascript:parent.hidePopup();"/>
    </div>

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
--></script>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
