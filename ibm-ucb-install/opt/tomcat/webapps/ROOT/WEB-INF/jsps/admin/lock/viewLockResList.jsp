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

<%@page import="com.urbancode.ubuild.domain.lock.*" %>
<%@page import="com.urbancode.ubuild.web.admin.lock.LockableResourceTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.services.lock.LockManagerService" %>
<%@page import="com.urbancode.commons.locking.LockManager" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.project.WorkflowCaseTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<c:url var="newUrl" value='<%=new LockableResourceTasks().methodUrl("newLock", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%
  LockableResourceFactory factory = LockableResourceFactory.getInstance();
  pageContext.setAttribute(WebConstants.LOCKABLE_RESOURCE_LIST, factory.restoreAll());
  LockManager lpm = LockManagerService.getLockManager();
%>

<c:url var="viewIconUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="resetIconUrl" value="/images/icon_reset.gif"/>
<c:url var="deleteIconUrl" value="/images/icon_delete.gif"/>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="selected" value="system"/>
  <jsp:param name="title" value="${ub:i18n('SystemLockableResources')}"/>
</jsp:include>
<div style="padding-bottom: 1em;">
<div class="tabManager" id="secondLevelTabs">
  <ucf:link label="${ub:i18n('LockableResources')}" href="" enabled="${false}" klass="selected tab"/>
</div>
<div class="contents">
  <div class="system-helpbox">${ub:i18n("LockableResourcesSystemHelpBox")}</div>

  <c:if test="${!empty error}">
    <br/>
    <div class="error">${fn:escapeXml(error)}</div>
  </c:if>
  <br/>

  <div>
    <ucf:button onclick="showPopup('${ah3:escapeJs(newUrl)}',800,400)" name="Create New" label="${ub:i18n('CreateNewLockableResource')}"/>
  </div>
  <br/>

  <div class="data-table_container">
    <table class="data-table">
      <thead>
        <tr>
          <th scope="col" valign="middle">${ub:i18n("Name")}</th>
          <th scope="col">${ub:i18n("Description")}</th>
          <th scope="col" width="10%">${ub:i18n("LockableResourcesLocksUsed")}</th>
          <th scope="col">${ub:i18n("Usage")}</th>
          <th scope="col" width="10%">${ub:i18n("Actions")}</th>
        </tr>
      </thead>
      <tbody id="lockResRows">
        <c:if test="${empty lockResList}">
          <tr bgcolor="#ffffff">
            <td colspan="5">${ub:i18n("LockableResourcesNoResourcesMessage")}</td>
          </tr>
        </c:if>
        <c:forEach var="templockres" items="${lockResList}">
          <%
            LockableResource res = (LockableResource) pageContext.findAttribute("templockres");
            pageContext.setAttribute("usedIn", factory.getActiveProjectNamesForLockRes(res));
            pageContext.setAttribute("numLocksOnRes", Long.valueOf(lpm.getNumberOfLocksOnResource(res)));
          %>
          <c:set var="currentLockList" value="${templockres.allCurrentLocks}"/>

          <c:url var='editUrlId' value='<%=new LockableResourceTasks().methodUrl("editLock", false)%>'>
            <c:param name="lockResId" value="${templockres.id}"/>
          </c:url>

          <c:url var='deleteUrlId' value='<%=new LockableResourceTasks().methodUrl("deleteLock", false)%>'>
            <c:param name="lockResId" value="${templockres.id}"/>
          </c:url>

          <c:url var='resetUrlId' value='<%=new LockableResourceTasks().methodUrl("resetLock", false)%>'>
            <c:param name="lockResId" value="${templockres.id}"/>
          </c:url>

          <tr bgcolor="#ffffff">
            <td><ucf:link href="javascript:showPopup('${editUrlId}',800,400);" label="${templockres.name}"/></td>
            <td style="white-space: pre"><c:out value="${templockres.description}"/></td>
            <td style="white-space: nowrap; text-align: center">
              <c:choose>
                <c:when test="${numLocksOnRes gt templockres.maxLockHolders}">
                  ${fn:toLowerCase(ub:i18n("LockableResourcesExclusive"))}
                </c:when>
                <c:otherwise>
                  ${numLocksOnRes} / ${templockres.maxLockHolders}
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:if test="${not empty usedIn}">
                <span class="bold">${ub:i18n("ProjectsWithColon")}</span> &nbsp;
                <c:forEach var="projectName" items="${usedIn}" varStatus="status">
                  <c:if test="${status.index != 0}"> | </c:if>
                  <c:out value="${projectName}"/>
                </c:forEach>
              </c:if>
              <c:if test="${not empty currentLockList && not empty usedIn}"><br/><br/></c:if>
              <c:if test="${not empty currentLockList}">
                <span class="bold">${ub:i18n("InUseByWithColon")}</span><br/>
                <c:forEach var="currentLock" items="${currentLockList}" varStatus="currentLockStatus">
                  <c:if test="${currentLockStatus.index != 0}"> | </c:if>
                  <c:set var="lockAcquirer" value="${currentLock.holder.acquirer}"/>
                  <c:choose>
                    <c:when test="${lockAcquirer.class.name eq 'com.urbancode.ubuild.domain.workflow.WorkflowCase'}">
                      <c:url var="workflowCaseUrl" value="${WorkflowCaseTasks.viewWorkflowCase}">
                        <c:param name="${WebConstants.WORKFLOW_CASE_ID}" value="${lockAcquirer.id}"/>
                      </c:url>
                      <c:set var="project" value="${lockAcquirer.project}"/>
                      <auth:check persistent="distributedServer" var="canViewWorkflow" action="${UBuildAction.PROJECT_VIEW}"/>
                      <ucf:link href="${workflowCaseUrl}" label="${lockAcquirer.name}" enabled="${canViewWorkflow}"/>
                    </c:when>
                    <c:otherwise>
                      <c:out value="${lockAcquirer.name}"/>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </c:if>
            </td>
            <td style="width: 10%; white-space: nowrap; text-align: center">
              <ucf:link href="javascript:showPopup('${ah3:escapeJs(editUrlId)}',800,400);" img="${viewIconUrl}"
                        label="${ub:i18n('Edit')}"/>&nbsp;
              <ucf:confirmlink href="${resetUrlId}" img="${resetIconUrl}" label="${ub:i18n('Reset')}" enabled="${numLocksOnRes gt 0}"
                               message="${ub:i18nMessage('LockableResourcesResetMessage', templockres.name)}"
                               />&nbsp;
              <ucf:deletelink href="${deleteUrlId}" label="${ub:i18n('Delete')}" img="${deleteIconUrl}"
                              name="${templockres.name}" enabled="${empty usedIn}"/>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
  <br/>
  <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
</div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
