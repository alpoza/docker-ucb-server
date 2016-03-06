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
<%@page import="com.urbancode.ubuild.web.admin.script.step.StepPreConditionScriptTasks"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.script.step.StepPreConditionScriptTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%@taglib prefix="error" uri="error" %>
<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<c:url var="newUrl"    value='<%=new StepPreConditionScriptTasks().methodUrl("newScript", false)%>'/>
<c:url var="deleteUrl" value='<%=new StepPreConditionScriptTasks().methodUrl("deleteScript", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<%
  StepPreConditionScriptFactory factory = StepPreConditionScriptFactory.getInstance();
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
      <ucf:link label="${ub:i18n('StepPreConditionScripts')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">
            ${ub:i18n("StepPreConditionSystemHelpBox")}
        </div>
      <c:if test="${error!=null}">
        <br/><div class="error">${fn:escapeXml(error)}</div>
      </c:if>
      <br/>

      <error:field-error field="conflict"/>
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
              <th scope="col" align="left" width="10%">${ub:i18n("Operations")}</th>
            </tr>

            <c:choose>
              <c:when test="${empty scriptList}">
                <tr bgcolor="#ffffff">
                  <td colspan="4">${ub:i18n("StepPreConditionNoneConfiguredMessage")}</td>
                </tr>
              </c:when>
              <c:otherwise>
                  <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
                  <c:url var="iconMagnifyGlass" value="/images/icon_magnifyglass.gif"/>
                  <c:url var="iconCopyUrl" value="/images/icon_copy_project.gif"/>
                  <c:forEach var="script" items="${scriptList}">
                  <%
                    StepPreConditionScript script = (StepPreConditionScript) pageContext.findAttribute("script");
                    String[] projectNameList = factory.getActiveProjectNamesForStepPreConditionScript(script);
                    pageContext.setAttribute("projectNameList", projectNameList);

                    String[] libWorkflowDefNameList = factory.getLibraryJobNamesForStepPreConditionScript(script);
                    pageContext.setAttribute("libWorkflowDefNameList", libWorkflowDefNameList);
                  %>

                  <c:url var='viewUrlId' value='<%=new StepPreConditionScriptTasks().methodUrl("editScript", false)%>'>
                    <c:param name="${WebConstants.SCRIPT_ID}" value="${script.id}"/>
                  </c:url>

                  <c:url var="copyScriptUrl" value="${StepPreConditionScriptTasks.copyScript}">
                    <c:param name="${WebConstants.SCRIPT_ID}" value="${script.id}"/>
                  </c:url>

                  <c:url var='deleteUrlId' value='<%=new StepPreConditionScriptTasks().methodUrl("deleteScript", false)%>'>
                    <c:param name="${WebConstants.SCRIPT_ID}" value="${script.id}"/>
                  </c:url>

                  <tr bgcolor="#ffffff">
                    <td align="left" height="1" nowrap="nowrap">
                      <ucf:link href="#" onclick="showPopup('${fn:escapeXml(viewUrlId)}',800,600);return false;"
                          label="${ub:i18n(script.name)}"
                          enabled="${canEdit}"/>
                    </td>

                    <td align="left" height="1">
                      <c:out value="${ub:i18n(script.description)}"/>
                    </td>

                    <td>
                      <c:forEach var="projectName" items="${projectNameList}" varStatus="status">
                        <c:if test="${status.first}"><span class="bold">${ub:i18n("ScriptProjectsWithColon")}</span> </c:if> ${fn:escapeXml(projectName)} <c:if test="${!status.last}"> | </c:if>
                      </c:forEach>
                      <c:if test="${(!empty projectNameList) && (!empty libWorkflowDefNameList)}"><br/></c:if>
                      <c:forEach var="workflowDefName" items="${libWorkflowDefNameList}" varStatus="status">
                        <c:if test="${status.first}"><span class="bold">${ub:i18n("ScriptJobsWithColon")}</span> </c:if> ${fn:escapeXml(workflowDefName)} <c:if test="${!status.last}"> | </c:if>
                      </c:forEach>
                      </td>

                      <td align="center" height="1" nowrap="nowrap"  width="10%">
                        <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(viewUrlId)}',800,600);return false;"
                            label="${ub:i18n('View')}" img="${iconMagnifyGlass}" enabled="${canEdit}"/>&nbsp;
                        <ucf:link href="${copyScriptUrl}" img="${iconCopyUrl}" label="${ub:i18n('CopyVerb')}" enabled="${canEdit}"/>&nbsp;
                        <ucf:deletelink href="${deleteUrlId}" label="${ub:i18n('Delete')}" name="${ub:i18n(script.name)}" img="${iconDeleteUrl}"
                            enabled="${script.deletable && canEdit && empty projectNameList && empty libWorkflowDefNameList}"/>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
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
