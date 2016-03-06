<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<%-- CONTENT --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
  <meta http-equiv="pragma" content="no-cache"/>
  <meta http-equiv="cache-control" content="no-cache"/>

  <title>${ub:i18n("PopupHeaderTitle")}</title>

  <c:import url="/WEB-INF/snippets/includeCssAndScripts.jsp">
    <c:param name="isLegacyYUI" value="${param.isLegacyYUI}" />
  </c:import>

  <c:set var="isInPopup" value="true" scope="request"/>
  
  <script type="text/javascript">
    /* <![CDATA[ */
    function resize() {
        if (parent.resizePopup) {
            var paddingElement = $("padding");
            parent.resizePopup(Math.max(paddingElement.offsetWidth, 800), paddingElement.offsetHeight);
        }
    }

    // pause the refresh page button if it exists.
    if (parent.screenRefresh && parent.screenRefresh.setPaused) {
        parent.screenRefresh.setPaused( true );
    }

    // only anthill pages should be allowed to frame other anthill pages
    <c:url var="rootPageUrl" value="/"/>
    var anthillContextUrl = self.location.protocol + '//' + self.location.host + '${ah3:escapeJs(rootPageUrl)}';
    // String.startsWith is from the prototype.js library
    if ( top != self && !top.location.href.startsWith(anthillContextUrl)) {
      //alert('caution: potential cross-site-framing exploit attempt detected, probably followed an untrustworthy link');
      top.location = anthillContextUrl;
    }
    
    document.observe("dom:loaded", function() { // no need to put in the header, no JS i18n used
      <c:if test="${not param.noResize}">resize();</c:if>
      focusOnFirstField();
    });
    /* ]]> */
  </script>

  ${requestScope.headContent}
</head>
<body class="oneui">
  <div id="padding">
