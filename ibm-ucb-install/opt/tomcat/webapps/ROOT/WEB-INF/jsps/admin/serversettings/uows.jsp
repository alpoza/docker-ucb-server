<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.persistence.*"%>
<%@ page import="com.urbancode.commons.util.*"%>
<%@ page import="com.urbancode.persistence.*"%>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.util.*" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<br/>
<div class="note">
  <table>
      <tr>
          <td>
<%
    UnitOfWork[] uows = UnitOfWork.getUnitOfWorkArray();
%>
<b>${ub:i18n("UnitsOfWork")} [<%= uows.length %>]:</b><br/>
<ul>
<%
    for (int u=0; u<uows.length; u++) {
        UnitOfWork uow = uows[u];
        ClassMetaData cmd = ClassMetaData.get(UnitOfWork.class);
        FieldMetaData fmd = null;

        fmd = cmd.getFieldMetaData("handle2object");
        Map handle2object = (Map) fmd.extractValue(uow);
        pageContext.setAttribute("refs", handle2object.size());

        fmd = cmd.getFieldMetaData("originalPersistentState");
        OriginalPersistentFieldState originalPersistentState = (OriginalPersistentFieldState) fmd.extractValue(uow);
        pageContext.setAttribute("cached", originalPersistentState.size());

        fmd = cmd.getFieldMetaData("newObjectList");
        List newObjectList = (List) fmd.extractValue(uow);
        pageContext.setAttribute("new", newObjectList.size());

        fmd = cmd.getFieldMetaData("dirtyObjectList");
        List dirtyObjectList = (List) fmd.extractValue(uow);
        pageContext.setAttribute("modify", dirtyObjectList.size());

        fmd = cmd.getFieldMetaData("deletedObjectList");
        List deletedObjectList = (List) fmd.extractValue(uow);
        pageContext.setAttribute("delete", deletedObjectList.size());

        fmd = cmd.getFieldMetaData("threadSet");
        Set threadSet = (Set) fmd.extractValue(uow);

        pageContext.setAttribute("uow", uow);
        pageContext.setAttribute("connection", uow.getConnection());
        pageContext.setAttribute("writerThread", uow.getBoundThreadName());
        pageContext.setAttribute("threadSet", threadSet);
%>
        <li>
          <div style="float: right;">
            <c:if test="${not empty connection}">${ub:i18n("SettingsDiagnosticsUOWConnection")} </c:if>
            ${ub:i18nMessage("SettingsDiagnosticsUOWRefs", refs)}
            ${ub:i18nMessage("SettingsDiagnosticsUOWCached", cached)}
            ${ub:i18nMessage("SettingsDiagnosticsUOWNew", new)}
            ${ub:i18nMessage("SettingsDiagnosticsUOWModified", modify)}
            ${ub:i18nMessage("SettingsDiagnosticsUOWDeleted", delete)}
          </div>
          <c:forEach var="thread" items="${threadSet}">
            <c:if test="${thread.name == writerThread}"><b></c:if>
            ${fn:escapeXml(thread.name)}
            <c:if test="${thread.name == writerThread}"></b></c:if> &nbsp;&nbsp;
          </c:forEach>
          <%--
            <pre><c:forEach var="traceElement" items="${uow.creationTraceException.stackTrace}">
            ${traceElement}<%="\n"%>
            </c:forEach></pre>
            <c:if test="${not empty connection}">
              <pre><c:forEach var="traceElement" items="${connection.creationTraceException.stackTrace}">
              ${traceElement}<%="\n"%>
              </c:forEach></pre>
            </c:if>
            <% pageContext.setAttribute("handleSet", handle2object.keySet()); %>
            <ul>
              <c:forEach var="handle" items="${handleSet}">
                <li>${handle}</li>
              </c:forEach>
            </ul>
            --%>
        </li>
<%
    }
%>
</ul>
            </td>
        </tr>
    </table>
</div>
