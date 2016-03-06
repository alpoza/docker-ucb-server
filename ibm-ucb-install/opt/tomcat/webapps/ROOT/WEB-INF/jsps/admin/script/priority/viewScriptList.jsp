<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" %>
<%@page pageEncoding="UTF-8" %>
<%@page import="com.urbancode.ubuild.domain.script.*"%>
<%@page import="com.urbancode.ubuild.domain.script.step.*"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction"%>
<%@page import="com.urbancode.ubuild.domain.security.Authority"%>
<%@page import="com.urbancode.ubuild.web.admin.script.priority.WorkflowPriorityScriptTasks"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.domain.script.priority.WorkflowPriorityScriptFactory" %>
<%@ page import="com.urbancode.ubuild.domain.script.priority.WorkflowPriorityScript" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<%@taglib uri="error" prefix="error" %>

<c:url var="newUrl"    value='<%=new WorkflowPriorityScriptTasks().methodUrl("newScript", false)%>'/>
<c:url var="deleteUrl" value='<%=new WorkflowPriorityScriptTasks().methodUrl("deleteScript", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%
  WorkflowPriorityScriptFactory factory = WorkflowPriorityScriptFactory.getInstance();
  pageContext.setAttribute(WebConstants.SCRIPT_LIST, factory.restoreAll());

  boolean canEdit = (Authority.getInstance().hasPermission(UBuildAction.SCRIPT_ADMINISTRATION));
  pageContext.setAttribute("canEdit", Boolean.valueOf(canEdit));
%>

<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemScriptableResourceList')}"/>
  <jsp:param name="selected" value="system"/>
</jsp:include>

<script type="text/javascript">
  function refresh() {
     window.location.reload();
  }
</script>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('WorkflowPriorityScripts')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
      <div class="system-helpbox">
          ${ub:i18n("WorkflowPrioritySystemHelpBox")}
      </div>
      <c:if test="${error!=null}">
        <br/><div class="error">${fn:escapeXml(error)}</div>
      </c:if>
      <br/>

      <c:if test="${canEdit}">
        <div>
          <ucf:link klass="button" href="${newUrl}" onclick="showPopup('${ah3:escapeJs(newUrl)}',800,600);return false;"
                  label="${ub:i18n('CreateNewScript')}" enabled="${script == null}"/>
        </div>
        <br/>
      </c:if>

      <div class="data-table_container">
        <table class="data-table">
          <tbody>
            <tr>
              <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
              <th scope="col" align="left">${ub:i18n("Description")}</th>
              <th scope="col" align="left">${ub:i18n("UsedIn")}</th>
              <th scope="col" align="left" width="10%">${ub:i18n("Actions")}</th>
            </tr>

            <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
            <c:url var="iconMagnifyGlass" value="/images/icon_magnifyglass.gif"/>
            <c:forEach var="script" items="${scriptList}">
              <%
                WorkflowPriorityScript script = (WorkflowPriorityScript) pageContext.findAttribute("script");
                String[] workflowNameList = factory.getActiveWorkflowNamesForWorkflowPriorityScript(script);
                pageContext.setAttribute("workflowNameList", workflowNameList);
              %>

              <c:url var='viewUrlId' value='<%=new WorkflowPriorityScriptTasks().methodUrl("editScript", false)%>'>
                <c:param name="${WebConstants.SCRIPT_ID}" value="${script.id}"/>
              </c:url>

              <c:url var='deleteUrlId' value='<%=new WorkflowPriorityScriptTasks().methodUrl("deleteScript", false)%>'>
                <c:param name="${WebConstants.SCRIPT_ID}" value="${script.id}"/>
              </c:url>

              <tr bgcolor="#ffffff">
                <td align="left" height="1" nowrap="nowrap">
                  <ucf:link href="#" onclick="showPopup('${fn:escapeXml(viewUrlId)}',800,600);return false;"
                      label="${script.name}"
                      enabled="${canEdit}"/>
                </td>

                <td align="left" height="1">
                  <c:out value="${script.description}"/>
                </td>

                <td>
                  <c:forEach var="workflowName" items="${workflowNameList}" varStatus="status">
                    <c:if test="${not status.last and status.count eq 10}"> ....<br/>
                      <div id="lessWorkflowNames">
                        <a href="#" onclick="hideLayer('lessWorkflowNames');showLayer('moreWorkflowNames');">${ub:i18n("ShowAll")}</a>
                      </div>
                      <div id="moreWorkflowNames" style="visibility: hidden; display: none;">
                        <a href="#" onclick="hideLayer('moreWorkflowNames');showLayer('lessWorkflowNames');">${ub:i18n("Hide")}</a><br/>
                    </c:if>
                    <c:if test="${not status.first and status.count != 10}"> | </c:if>
                    <c:if test="${status.first}"><span class="bold">${ub:i18n("ScriptWorkflows")}</span> </c:if>
                    ${fn:escapeXml(workflowName)}
                    <c:if test="${status.last and status.count gt 10}"></div></c:if>
                  </c:forEach>
                </td>

                <td align="center" height="1" nowrap="nowrap"  width="10%">
                    <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(viewUrlId)}',800,600);return false;" label="${ub:i18n('View')}" img="${iconMagnifyGlass}" enabled="${canEdit}"/>&nbsp;
                    <ucf:deletelink href="${deleteUrlId}" label="${ub:i18n('Delete')}" name="${script.name}" img="${iconDeleteUrl}" enabled="${script.deletable && canEdit && empty projectNameList && empty workflowDefNameList}"/>
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
    </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
