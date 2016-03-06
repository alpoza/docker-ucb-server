<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<form method="post" action="#">
  <div class="popup_header">
      <ul>
          <li class="current"><a>${ub:i18n("Errors")}</a></li>
      </ul>
  </div>
  <div class="contents">
  <c:import url="/WEB-INF/jsps/project/errors.jsp"/>
  <br/>
  <ucf:button name="Close" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;"/>
  </div>
</form>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
