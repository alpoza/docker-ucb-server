<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error"%>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
  EvenOdd eo = new EvenOdd();
%>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/snippets/popupHeader.jsp"/>

  <div class="contents">
    <div valign="top" align="center" width="100%" class="required-text-large">
	  <br/>
	  <br/>
      <b>${ub:i18n("RunWorkflowError")}</b>
    </div>
    <br />
    <table class="property-table">
      <tbody>
        <br/>
        <br/>
        <tr class="<%= eo.getLast() %>" valign="top">
          <td align="left" width="80%">
            <span class="large-text">${ub:i18n("WorkflowCanNotBeRunError")}</span>
          </td>
        </tr>
      </tbody>
    </table>
    <br/>
    <br/>
    <table border="0">
      <tbody>
        <tr valign="top">
          <td align="center" width="100%">
            <ucf:button name="Close" label="${ub:i18n('Close')}" submit="${false}" onclick="parent.hidePopup(); return false;"/>
          </td>
        </tr>
      </tbody>
    </table>    
  </div>
<jsp:include page="/WEB-INF/snippets/popupFooter.jsp"/>