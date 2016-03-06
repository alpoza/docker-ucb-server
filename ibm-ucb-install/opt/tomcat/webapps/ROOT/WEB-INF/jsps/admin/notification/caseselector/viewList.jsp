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
<%@page import="com.urbancode.ubuild.web.admin.notification.caseselector.WorkflowCaseSelectorTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
  ScriptedWorkflowCaseSelectorFactory factory = ScriptedWorkflowCaseSelectorFactory.getInstance();
  pageContext.setAttribute(WebConstants.WORKFLOW_CASE_SELECTOR_LIST, factory.restoreAll());

%>

<c:url var="newUrl" value='<%=new WorkflowCaseSelectorTasks().methodUrl("newWorkflowCaseSelector", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%-- Begin Main CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEventSelectors')}" />
  <jsp:param name="selected" value="system" />
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('EventSelectors')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("NotificationEventSelectorSystemHelpBox")}</div>
      <c:if test="${! empty selectors}">
          <table>
            <error:field-error field="selectors" cssClass="odd"/>
        </table>
      </c:if>
      <br/>
      <div>
          <ucf:button href="${newUrl}" name="NewSelector" label="${ub:i18n('NotificationEventSelectorCreateEventSelector')}"/>
      </div>

      <br/>

      <div class="data-table_container">
        <table class="data-table">
          <tbody>
            <tr>
              <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
              <th scope="col" align="left" valign="middle">${ub:i18n("Description")}</th>
              <th scope="col" align="left" valign="middle">${ub:i18n("UsedInSchemes")}</th>
              <th scope="col" align="center" valign="middle">${ub:i18n("Actions")}</th>
            </tr>

            <c:forEach var="selector" items="${workflowCaseSelectorList}">
              <%
                ScriptedWorkflowCaseSelector generator = (ScriptedWorkflowCaseSelector)pageContext.findAttribute("selector");
                String[] schemeNameList = factory.getNotificationSchemeNamesForCaseSelector(generator);
                pageContext.setAttribute("schemeNameList", schemeNameList);
              %>

              <c:url var="viewUrlId" value='<%=new WorkflowCaseSelectorTasks().methodUrl("viewWorkflowCaseSelector", false)%>'>
                <c:param name="${WebConstants.WORKFLOW_CASE_SELECTOR_ID}" value="${selector.id}"/>
              </c:url>

              <c:url var="deleteUrlId" value='<%=new WorkflowCaseSelectorTasks().methodUrl("deleteWorkflowCaseSelector", false)%>'>
                <c:param name="${WebConstants.WORKFLOW_CASE_SELECTOR_ID}" value="${selector.id}"/>
              </c:url>

              <tr bgcolor="#ffffff">
                <td align="left" height="1" nowrap="nowrap">
                  <a href="${fn:escapeXml(viewUrlId)}"><c:out value="${ub:i18n(selector.name)}"/></a>
                </td>

                <td align="left" height="1"><c:out value="${ub:i18n(selector.description)}"/></td>

                <td align="left">
                  <c:forEach var="schemeName" items="${schemeNameList}" varStatus="status">
                    <c:if test="${status.index != 0}"> | </c:if>
                    <c:out value="${ub:i18n(schemeName)}"/>
                  </c:forEach>
                </td>

                <td align="center" height="1" nowrap="nowrap">
                  <c:url var="iconViewUrl" value="/images/icon_magnifyglass.gif"/>
                  <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
                  <ucf:link href="${viewUrlId}" img="${iconViewUrl}" label="${ub:i18n('View')}"/> &nbsp;
                  <ucf:deletelink href="${deleteUrlId}" name="${ub:i18n(selector.name)}" img="${iconDeleteUrl}" label="${ub:i18n('Delete')}"
                                  enabled="${fn:length(schemeNameList)==0}"/>
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
