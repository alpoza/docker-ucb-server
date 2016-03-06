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
<%@page import="com.urbancode.ubuild.web.admin.notification.recipientgenerator.NotificationRecipientGeneratorTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%
  NotificationRecipientGeneratorFactory factory = NotificationRecipientGeneratorFactory.getInstance();
  pageContext.setAttribute(WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_LIST, factory.restoreAll());

%>

<c:url var="imgUrl" value="/images"/>

<c:url var="newUrl" value='<%=new NotificationRecipientGeneratorTasks().methodUrl("newNotificationRecipientGenerator", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%-- Begin Main CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemRecipientGenerators')}" />
  <jsp:param name="selected" value="system" />
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
        <ucf:link label="${ub:i18n('RecipientGenerators')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("NotificationRecipientGeneratorsSystemHelpBox")}</div>

      <c:if test="${error!=null}">
        <br/><div class="error">${fn:escapeXml(error)}</div>
      </c:if>
      <br/>

      <div>
        <ucf:button href="${newUrl}" name="NewRecipientGenerator" label="${ub:i18n('NotificationRecipientGeneratorsCreateRecipientGenerator')}"/>
      </div>

      <br/>

      <div class="data-table_container">
        <table class="data-table">
          <tbody>
            <tr>
              <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
              <th scope="col" align="left" valign="middle">${ub:i18n("Type")}</th>
              <th scope="col" align="left" valign="middle" width="30%">${ub:i18n("Description")}</th>
              <th scope="col" align="left" valign="middle" width="25%">${ub:i18n("UsedInSchemes")}</th>
              <th scope="col" align="center" valign="middle" width="8%">${ub:i18n("Actions")}</th>
            </tr>

            <c:forEach var="generator" items="${notificationRecipientGeneratorList}">
              <%
                NotificationRecipientGenerator generator = (NotificationRecipientGenerator) pageContext.findAttribute("generator");
                String[] schemeNameList = factory.getNotificationSchemeNamesForRecipientGenerator(generator);
                pageContext.setAttribute("schemeNameList", schemeNameList);
              %>

              <c:url var="viewUrlId" value='<%=new NotificationRecipientGeneratorTasks().methodUrl("viewNotificationRecipientGenerator", false)%>'>
                <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${generator.id}"/>
              </c:url>

              <c:url var="deleteUrlId" value='<%=new NotificationRecipientGeneratorTasks().methodUrl("deleteNotificationRecipientGenerator", false)%>'>
                <c:param name="${WebConstants.NOTIFICATION_RECIPIENT_GENERATOR_ID}" value="${generator.id}"/>
              </c:url>

              <tr bgcolor="#ffffff">
                <td align="left" height="1" nowrap="nowrap">
                  <a href="${fn:escapeXml(viewUrlId)}"><c:out value="${ub:i18n(generator.name)}"/></a>
                </td>

                <td align="left" height="1" nowrap="nowrap">
              <%
                if (generator instanceof FixedNotificationRecipientGenerator) {
                    %>${ub:i18n("Fixed")}<%
                }
                else if (generator instanceof GroupBasedNotificationRecipientGenerator) {
                    %>${ub:i18n("Group-Based")}<%
                }
                else if (generator instanceof ScriptedNotificationRecipientGenerator) {
                    %>${ub:i18n("Scripted")}<%
                }
              %>
                </td>

                <td align="left" height="1"><c:out value="${ub:i18n(generator.description)}"/></td>

                <td align="left">
                  <c:forEach var="schemeName" items="${schemeNameList}" varStatus="status">
                    <c:if test="${status.index != 0}"> | </c:if>
                    <c:out value="${ub:i18n(schemeName)}"/>
                  </c:forEach>
                </td>

                <td align="center" height="1" nowrap="nowrap">
                  <ucf:link href="${viewUrlId}" label="${ub:i18n('View')}" img="${fn:escapeXml(imgUrl)}/icon_magnifyglass.gif"/> &nbsp;
                  <ucf:deletelink href="${deleteUrlId}" name="${ub:i18n(generator.name)}" label="${ub:i18n('Delete')}" img="${fn:escapeXml(imgUrl)}/icon_delete.gif"
                                  enabled="${fn:length(schemeNameList)==0}"/>
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
