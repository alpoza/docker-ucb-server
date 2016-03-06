<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.SystemFunction"%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.workdir.*" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="error" prefix="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants"/>
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<auth:checkAction var="canCreateScript" action="${UBuildAction.SCRIPT_ADMINISTRATION}"/>
<auth:checkAction var="canEditScript" action="${UBuildAction.SCRIPT_ADMINISTRATION}"/>

<c:if test="${(empty param.enabled || param.enabled)}">
    <%
        String newWorkDirScriptUrl = WorkDirScriptPopup.methodUrl("newWorkDirScript", false);
        String editWorkDirScriptUrl = WorkDirScriptPopup.methodUrl("editWorkDirScript", false);
        pageContext.setAttribute("newWorkDirScriptUrl", newWorkDirScriptUrl);
        pageContext.setAttribute("editWorkDirScriptUrl", editWorkDirScriptUrl);
    %>
  <script type="text/javascript"><!--
    function newWorkDirScript() {
      openWorkDirPopup('${ah3:escapeJs(newWorkDirScriptUrl)}');
    }

    function editWorkDirScript() {
      var elem = getElem('${ah3:escapeJs(requestScope.chooserId)}');
      var index = elem.selectedIndex;
      if (index == null) {
        alert('${ah3:escapeJs(ub:i18n("SelectScriptToEdit"))}');
        return;
      }
      var option = elem.options[index];
      if (option == null || option.value == null || option.value == '') {
        alert('${ah3:escapeJs(ub:i18n("SelectScriptToEdit"))}');
        return;
      }

      var url = '${ah3:escapeJs(editWorkDirScriptUrl)}';
      if (index != null) {
        if (url.indexOf('?')==-1){
          url+='?';
        }
        else {
          url+='&';
        }
        url += '${ah3:escapeJs(WebConstants.WORK_DIR_SCRIPT_ID)}=' + option.value;
      }
      openWorkDirPopup(url);
    }

    function openWorkDirPopup(url) {
      openPopup(url, '_blank', 700, 420);
    }
  --></script>
  <c:if test="${canCreateScript}">&nbsp;<a href="javascript:newWorkDirScript();">${ub:i18n("NewScript")}</a></c:if>
  <c:if test="${canCreateScript and canEditScript}">&nbsp;&nbsp;/&nbsp;&nbsp;</c:if>
  <c:if test="${canEditScript}"><a href="javascript:editWorkDirScript();">${ub:i18n("EditScript")}</a>&nbsp;</c:if>
</c:if>
