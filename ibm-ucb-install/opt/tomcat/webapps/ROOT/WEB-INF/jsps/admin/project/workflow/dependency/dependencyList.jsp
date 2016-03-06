<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@page import="java.util.*"%>

<%@page import="com.urbancode.ubuild.domain.security.*"%>
<%@page import="com.urbancode.ubuild.domain.buildlife.*"%>
<%@page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@page import="com.urbancode.ubuild.domain.workflow.Workflow"%>
<%@page import="com.urbancode.ubuild.domain.profile.*"%>
<%@page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@page import="com.urbancode.codestation2.domain.project.AnthillProject" %>
<%@page import="com.urbancode.codestation2.domain.project.CodestationProject" %>
<%@page import="com.urbancode.ubuild.codestation.CodestationCompatibleProject" %>

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>

<ah3:useConstants class="com.urbancode.ubuild.domain.security.UBuildAction" />

<%!
    Authority auth = Authority.getInstance();

    //--------------------------------------------------------------------------
    public boolean hasReadPerm(CodestationCompatibleProject proj)
    throws PersistenceException {
        if (proj == null) {return false;}
        if (proj instanceof CodestationProject) {
            return auth.hasPermission((CodestationProject) proj, UBuildAction.PROJECT_VIEW);
        }
        else {
            return auth.hasPermission(((AnthillProject)proj).getBuildProfile().getProjectNamedHandle(), UBuildAction.PROJECT_VIEW);
       }
    }
%>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
    <c:set var="fieldAttributes" value=""/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<%
  Workflow workflow = (Workflow) pageContext.findAttribute("workflow");
  Dependency[] dependencyArray = workflow.getBuildProfile().getDependencyArray();
  Arrays.sort(dependencyArray, new Dependency.DependencyComparator());
  pageContext.setAttribute("dependencyArray", dependencyArray);
  pageContext.setAttribute("eo", new EvenOdd());
%>

<auth:check persistent="${workflow.project}" var="canEdit" action="${UBuildAction.PROJECT_EDIT}"/>
<c:set var="enableLinks" value="${inViewMode and buildProfileDependency==null and canEdit}"/>

<c:url var="imgUrl" value="/images"/>

<c:url var="newDependencyUrl"    value='<%= new WorkflowTasks().methodUrl("selectDependencyProject", false)%>'>
  <c:if test="${workflow.id != null}"><c:param name="workflowId" value="${workflow.id}"/></c:if>
</c:url>

<br/>
<ul class="navlist"></ul>
<br />

<div>
  <ucf:button name="NewDependency" label="${ub:i18n('NewDependency')}" href="${newDependencyUrl}#dependency" enabled="${enableLinks}"/>
</div>
<br/>
<table id="DependencyTable" class="data-table">
  <thead>
    <tr>
      <th scope="col" align="left" valign="middle" width="35%"  >${ub:i18n("Name")}</th>
      <th scope="col" align="left" valign="middle" width="40%" nowrap="nowrap">${ub:i18n("BuildLifeCriteria")}</th>
      <th scope="col" align="left" valign="middle" width="15%" nowrap="nowrap">${ub:i18n("Trigger")}</th>
      <th scope="col" align="center" valign="middle" width="10%">${ub:i18n("Actions")}</th>
    </tr>
  </thead>
  <tbody>
    <c:if test="${empty dependencyArray}">
      <tr bgcolor="#ffffff">
        <td colspan="4">
          ${ub:i18n("DependencyNoneConfiguredMessage")}
        </td>
      </tr>
    </c:if>

    <c:forEach var="dependency" items="${dependencyArray}" varStatus="status">
      <c:remove var="viewDependencyUrlId"/>
      <c:set var="dependencyProject" value="${dependency.dependency}"/>
      <%
        CodestationCompatibleProject proj = (CodestationCompatibleProject)pageContext.findAttribute("dependencyProject");
        boolean read = hasReadPerm(proj);
        if (read) {
      %>
      <c:url var="viewDependencyUrlId" value='<%= new WorkflowTasks().methodUrl("editDependency", false)%>'>
        <c:param name="workflowId" value="${workflow.id}"/>
        <c:param name="buildProfileDependencyId" value="${dependency.id}"/>
      </c:url>
      <% } %>
    
      <c:url var="removeDependencyUrlId" value='<%= new WorkflowTasks().methodUrl("removeDependency", false)%>'>
        <c:param name="workflowId" value="${workflow.id}"/>
        <c:param name="buildProfileDependencyId" value="${dependency.id}"/>
      </c:url>

      <tr class="${eo.next}">
        <td align="left" height="1" nowrap="nowrap" width="20%">
          ${fn:escapeXml(dependency.dependencyName)}
        </td>
        
        <td width="40%">
          <c:forEach var="labelValue" items="${dependency.labelValues}" varStatus="labelValueStatus">
            <c:choose>
              <c:when test="${labelValueStatus.first}">&nbsp;${ub:i18n("WithLabelWithColon")} </c:when>
              <c:otherwise>&nbsp;${ub:i18n("Or")} </c:otherwise>
            </c:choose>
            &quot;${fn:escapeXml(labelValue)}&quot;
          </c:forEach>
          
          <c:if test="${not empty dependency.stampValues && not empty dependency.labelValues}">,&nbsp;</c:if>
          <c:forEach var="stampValue" items="${dependency.stampValues}" varStatus="stampValueStatus">
            <c:choose>
              <c:when test="${stampValueStatus.first}">&nbsp;${ub:i18n("WithStampWithColon")} </c:when>
              <c:otherwise>&nbsp;${ub:i18n("Or")} </c:otherwise>
            </c:choose>
            &quot;${fn:escapeXml(stampValue)}&quot;
          </c:forEach>
          
          <c:if test="${dependency.status != null}">
            <c:if test="${not empty dependency.stampValues || not empty dependency.labelValues}">,&nbsp;</c:if>
            ${ub:i18n("DependencyWithStatus")} &quot;${fn:escapeXml(dependency.status.name)}&quot;
          </c:if>
        </td>

        <td nowrap="nowrap">${dependency.triggerType.description}</td>

        <td align="center" height="1" nowrap="nowrap" width="10%">
          <c:if test="${!empty viewDependencyUrlId}">
            <ucf:link href="${viewDependencyUrlId}#dependencyAnchor"
                label="${ub:i18n('View')}"
                img="${fn:escapeXml(imgUrl)}/icon_magnifyglass.gif"
                enabled="${enableLinks}"/>&nbsp;
          </c:if>
          <ucf:confirmlink href="${removeDependencyUrlId}"
                           message="${ub:i18nMessage('DependencyDeleteMessage', dependency.dependencyName)}"
                           label="${ub:i18n('Remove')}"
                           img="${fn:escapeXml(imgUrl)}/icon_delete.gif"
                           enabled="${enableLinks}"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>
