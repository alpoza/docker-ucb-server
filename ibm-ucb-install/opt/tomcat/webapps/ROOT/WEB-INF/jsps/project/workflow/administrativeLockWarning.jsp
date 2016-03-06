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
<%@page import="com.urbancode.ubuild.domain.singleton.serversettings.ServerSettingsFactory" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%
    pageContext.setAttribute("serverSettings", ServerSettingsFactory.getInstance().restore());
%>
<c:if test="${serverSettings.serverInAdministrativeLock}">
  <tr valign="top">
    <td colspan="3">
      <span class="error">${ub:i18n("AdministrativeLockMessage")}</span>
    </td>
  </tr>
</c:if>