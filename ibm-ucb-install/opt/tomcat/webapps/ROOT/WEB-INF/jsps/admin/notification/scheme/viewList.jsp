<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.urbancode.ubuild.domain.notification.*" %>
<%@page import="com.urbancode.ubuild.web.admin.notification.scheme.NotificationSchemeTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="newUrl"  value='<%=new NotificationSchemeTasks().methodUrl("newNotificationScheme", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%
  NotificationSchemeFactory factory = NotificationSchemeFactory.getInstance();
  pageContext.setAttribute(WebConstants.NOTIFICATION_SCHEME_LIST, factory.restoreAll());
%>

<%-- Begin Main CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemNotificationSchemes')}" />
  <jsp:param name="selected" value="system" />
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
        <ucf:link label="${ub:i18n('NotificationSchemes')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("NotificationSchemeSystemHelpBox")}</div>
      <br/>
      <c:if test="${error!=null}">
        <br/><div class="error">${fn:escapeXml(error)}</div>
      </c:if>

      <div>
        <ucf:button href="${newUrl}" name="NewScheme" label="${ub:i18n('NotificationSchemeCreateNotificationScheme')}"/>
      </div>

      <br/>

      <div class="data-table_container">
        <table class="data-table">
          <tbody>
            <tr>
              <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
              <th scope="col" align="left" valign="middle" width="30%">${ub:i18n("Description")}</th>
              <th scope="col" align="left" valign="middle">${ub:i18n("UsedInProjects")}</th>
              <th scope="col" align="center" valign="middle">${ub:i18n("Actions")}</th>
            </tr>

            <c:forEach var="scheme" items="${notificationSchemeList}">
              <%
                NotificationScheme scheme = (NotificationScheme)pageContext.findAttribute("scheme");
                String[] projectNameList = factory.getActiveProjectNamesForNotificationScheme(scheme);
                pageContext.setAttribute("projectNameList", projectNameList);
              %>

              <c:url var="viewUrlId" value='<%=new NotificationSchemeTasks().methodUrl("viewNotificationScheme", false)%>'>
                <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${scheme.id}"/>
              </c:url>

              <c:url var="deleteUrlId" value='<%=new NotificationSchemeTasks().methodUrl("deleteNotificationScheme", false)%>'>
                <c:param name="${WebConstants.NOTIFICATION_SCHEME_ID}" value="${scheme.id}"/>
              </c:url>

              <tr bgcolor="#ffffff">
                <td align="left" height="1" nowrap="nowrap">
                  <a href="${fn:escapeXml(viewUrlId)}"><c:out value="${ub:i18n(scheme.name)}"/></a>
                </td>

                <td align="left" height="1"><c:out value="${ub:i18n(scheme.description)}"/></td>

                <td align="left">
                  <c:forEach var="projectName" items="${projectNameList}" varStatus="status">
                    <c:if test="${status.index != 0}"> | </c:if>
                    <c:out value="${projectName}"/>
                  </c:forEach>
                </td>

                <td align="center" height="1" nowrap="nowrap">
                    <c:url var="iconMagnifyGlassUrl" value="/images/icon_magnifyglass.gif"/>
                    <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
                    <ucf:link href="${viewUrlId}" label="${ub:i18n('ViewReport')}" title="${ub:i18n('ViewReport')}" img="${iconMagnifyGlassUrl}"/>&nbsp;
                    <ucf:deletelink href="${deleteUrlId}" label="${ub:i18n('Delete')}" name="${ub:i18n(scheme.name)}" enabled="${fn:length(projectNameList)==0 && fn:length(usedIn)==0}" img="${iconDeleteUrl}"/>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
      <br/>
      <div>
         <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
      </div>
      <br/>
    </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
