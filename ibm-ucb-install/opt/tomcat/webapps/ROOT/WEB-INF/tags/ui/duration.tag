<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty"%>
<%@tag import="com.urbancode.commons.util.Duration"%>
<%@attribute name="milliseconds" required="true" type="java.lang.Long"%>
<%@attribute name="abbreviated" type="java.lang.Boolean"%>
<%@attribute name="showMillis" type="java.lang.Boolean"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
boolean abbreviated = jspContext.getAttribute("abbreviated") instanceof Boolean ? (Boolean) jspContext.getAttribute("abbreviated") : false;
boolean showMillis = jspContext.getAttribute("showMillis") instanceof Boolean ? (Boolean) jspContext.getAttribute("showMillis") : false;
long milliseconds = (Long) jspContext.getAttribute("milliseconds");
jspContext.setAttribute("duration", new Duration(milliseconds).getLeastUnit(abbreviated, showMillis));
%>
${fn:escapeXml(duration)}
  