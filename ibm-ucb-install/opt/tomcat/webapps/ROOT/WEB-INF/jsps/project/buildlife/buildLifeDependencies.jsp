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
<%@page import="java.util.*" %>
<%@page import="com.urbancode.codestation2.domain.buildlife.*"%>
<%@page import="com.urbancode.ubuild.domain.security.*"%>
<%@page import="com.urbancode.ubuild.domain.buildlife.*"%>
<%@page import="com.urbancode.ubuild.domain.persistent.*"%>
<%@page import="com.urbancode.ubuild.web.admin.codestation2.buildlife.*" %>
<%@page import="com.urbancode.ubuild.web.project.*" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@page import="com.urbancode.ubuild.codestation.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.codestation2.buildlife.CodestationBuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.ProjectTasks" />

<c:url var="iconPlusUrl" value="/images/icon_plus_sign.gif"/>
<c:url var="iconMinusUrl" value="/images/icon_minus_sign.gif"/>
<%!
    Authority auth = Authority.getInstance();

    //--------------------------------------------------------------------------
    public boolean hasReadPerm(CodestationCompatibleBuildLife life)
    throws PersistenceException {
        if (life instanceof CodestationBuildLife) {
            return auth.hasPermission(((CodestationBuildLife)life).getProject(), UBuildAction.PROJECT_VIEW);
        }
        else {
            return auth.hasPermission(((BuildLife)life).getProfile().getProjectNamedHandle(), UBuildAction.PROJECT_VIEW);
        }
    }
%>
<%
    BuildLife bl = (BuildLife)pageContext.findAttribute("buildLife");
    CodestationCompatibleBuildLife[] dependencyArray = new CodestationCompatibleBuildLife[0];
    CodestationCompatibleBuildLife[] usedInArray = new CodestationCompatibleBuildLife[0];
    if (bl != null) {
        dependencyArray = bl.getDependencyBuildLifeArray();
        usedInArray = bl.getParentBuildLifeArray();
    }

    Comparator comp = new CodestationCompatibleBuildLifeProjectNameComparator();

    Arrays.sort(dependencyArray, comp );
    Arrays.sort(usedInArray, comp);
    pageContext.setAttribute("dependencyArray", dependencyArray);
    pageContext.setAttribute("usedInArray", usedInArray);
    pageContext.setAttribute("eo", new EvenOdd());

    List<PersistentDependencyPlanArtifactResolve> resolvesToTransfer = new ArrayList<PersistentDependencyPlanArtifactResolve>();
    // for older, upgraded build lives, we may not have a dependency plan
    if (bl.getDependencyPlan() != null) {
        resolvesToTransfer.addAll(bl.getDependencyPlan().getResolvesToTransfer());
        Collections.sort(resolvesToTransfer, new PersistentDependencyPlanArtifactResolveNameComparator());
    }
    pageContext.setAttribute("resolvesToTransfer", resolvesToTransfer);
%>

<c:url var="projectUrl" value="${ProjectTasks.viewDashboard}">
  <c:param name="projectId" value="${project.id}"/>
</c:url>

<%-- CONTENT --%>
<c:import url="buildLifeHeader.jsp">
  <c:param name="selected" value="dependencies"/>
</c:import>

<script type="text/javascript">
<!--
function toggleResolvedDependency(link) {
    var _link = $(link);
    var tbody = _link.up('tbody');
    var img = _link.down('img');
    if (img.src.endsWith('${iconPlusUrl}')) {
        img.src = '${iconMinusUrl}';
        $(tbody.id + "-resolves").show();
    }
    else {
        img.src = '${iconPlusUrl}';
        $(tbody.id + "-resolves").hide();
    }
}

function toggleAllResolvedDependencies(link) {
    var _link = $(link);
    var table = _link.up('table');
    var img = _link.down('img');
    if (img.src.endsWith('${iconPlusUrl}')) {
        img.src = '${iconMinusUrl}';
        // show all
        $$('tbody.dependency-resolves').each(function(tbody) {
            tbody.previous().down('img').src = '${iconMinusUrl}';
            tbody.show();
        });
    }
    else {
        img.src = '${iconPlusUrl}';
        // hide all
        $$('tbody.dependency-resolves').each(function(tbody) {
            tbody.previous().down('img').src = '${iconPlusUrl}';
            tbody.hide();
        });
    }
}
//-->
</script>

<br/>
<h3>${ub:i18n("BuildLifeDependenciesDependsOnWithColon")}</h3>

<table class="data-table">
  <thead>
    <tr>
      <th scope="col" width="50%" align="left">${ub:i18n("Project")}</th>
      <th scope="col" width="15%">${ub:i18n("Stamp")} / ${ub:i18n("ID")}</th>
      <th scope="col" width="15%">${ub:i18n("LatestStatus")}</th>
      <th scope="col" width="20%">${ub:i18n("BuildLifeDependenciesBuildDate")}</th>
    </tr>
  </thead>
  <tbody>

    <c:choose>
      <c:when test="${empty dependencyArray}">
        <tr class="${eo.next}"><td colspan="4">${ub:i18n("BuildLifeDependenciesNoDependencies")}</td></tr>
      </c:when>
      <c:otherwise>
        <c:forEach var="dependency" items="${dependencyArray}">
          <c:remove var="buildLifeUrl"/>
          <c:remove var="projectUrlId"/>
          <%
            CodestationCompatibleBuildLife dependencybuildlife = (CodestationCompatibleBuildLife)pageContext.findAttribute("dependency");

            if (!hasReadPerm(dependencybuildlife)) {
                // no links, do nothing
            }
            else if (dependencybuildlife instanceof CodestationBuildLife) {
          %>
            <c:url var="buildLifeUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}">
              <c:param name="codestationBuildLifeId" value="${dependency.id}"/>
              <c:param name="fromBuildLife" value="${buildLife.id}"/>
            </c:url>
          <%
            }
            else {
          %>
            <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
              <c:param name="buildLifeId" value="${dependency.id}"/>
            </c:url>

            <c:url var="projectUrlId" value="${ProjectTasks.viewDashboard}">
              <c:param name="projectId" value="${dependency.profile.project.id}"/>
            </c:url>
          <%
            }
          %>
          <tr class="${eo.next}">
            <td nowrap="nowrap">
              <c:choose>
                <c:when test="${!empty projectUrlId}"><ucf:link href="${projectUrlId}"
                    label="${dependency.codestationProject.name}" title="${ub:i18n('ViewDashboard')}"/></c:when>
                <c:otherwise>${fn:escapeXml(dependency.codestationProject.name)}</c:otherwise>
              </c:choose>
            </td>
            <td nowrap="nowrap" align="center">
              <c:set var="buildLifeLinkLabel"><c:out value="${fn:length(dependency.latestStampValue) > 0 ? dependency.latestStampValue : null}" default="${dependency.id}"/></c:set>
              <c:choose>
                <c:when test="${!empty buildLifeUrl}">
                  <ucf:link href="${buildLifeUrl}" label="${buildLifeLinkLabel}" title="${ub:i18n('ViewBuildLife')}"/>
                </c:when>
                <c:otherwise>${buildLifeLinkLabel}</c:otherwise>
              </c:choose>
            </td>
            <c:set var="background_color" value="style='background-color: ${dependency.latestStatus.status.color};'"/>
            <td nowrap="nowrap" align="center" ${background_color}>${fn:escapeXml(dependency.latestStatusName)}</td>
            <td nowrap="nowrap" align="center">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, dependency.startDate))}</td>
          </tr>
        </c:forEach>

      </c:otherwise>
    </c:choose>
  </tbody>
</table>

<br/>

<c:if test="${not empty buildLife.dependencyPlan}">
<%
    pageContext.setAttribute("eo", new EvenOdd());
%>
  <br/>
  <h3>${ub:i18n("BuildLifeDependenciesResolveDependencies")}</h3>

  <table class="data-table">
    <thead>
      <tr>
        <th scope="col" width="3%" align="center">
          <ucf:link href="#" label="${ub:i18n('ShowHideDetails')}" onclick="toggleAllResolvedDependencies(this); return false;" img="${iconPlusUrl}"/>
        </th>
        <th scope="col" width="47%" align="left">${ub:i18n("Project")}</th>
        <th scope="col" width="15%">${ub:i18n("Stamp")} / ${ub:i18n("ID")}</th>
        <th scope="col" width="15%">${ub:i18n("LatestStamp")}</th>
        <th scope="col" width="20%">${ub:i18n("BuildLifeDependenciesBuildDate")}</th>
      </tr>
    </thead>
    <c:set var="lastResolvedDependencyBuildLife" value=""/>
    <c:if test="${fn:length(resolvesToTransfer) == 0}">
      <tbody>
        <tr><td colspan="5">${ub:i18n("BuildLifeDependenciesNoDependencyArtifacts")}</td></tr>
      </tbody>
    </c:if>
    <c:forEach var="depResolve" items="${resolvesToTransfer}">
      <c:if test="${lastResolvedDependencyBuildLife ne depResolve.life and not empty lastResolvedDependencyBuildLife}">
        </tbody>
      </c:if>
      <c:if test="${lastResolvedDependencyBuildLife ne depResolve.life}">
        <c:remove var="buildLifeUrl"/>
        <c:remove var="projectUrlId"/>
        <%
          pageContext.setAttribute("sub_eo", new EvenOdd());
          PersistentDependencyPlanArtifactResolve depResolve = (PersistentDependencyPlanArtifactResolve) pageContext.findAttribute("depResolve");

          if (!hasReadPerm(depResolve.getLife())) {
              // no links, do nothing
          }
          else if (depResolve.getLife() instanceof CodestationBuildLife) {
        %>
          <c:set var="resolvedDepTBodyBase" value="resolved-deps-cs-${depResolve.life.id}"/>
          <c:url var="buildLifeUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}">
            <c:param name="codestationBuildLifeId" value="${depResolve.life.id}"/>
            <c:param name="fromBuildLife" value="${buildLife.id}"/>
          </c:url>
        <%
          }
          else {
        %>
          <c:set var="resolvedDepTBodyBase" value="resolved-deps-ahp-${depResolve.life.id}"/>
          <c:url var="buildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
            <c:param name="buildLifeId" value="${depResolve.life.id}"/>
          </c:url>

          <c:url var="projectUrlId" value="${ProjectTasks.viewDashboard}">
            <c:param name="projectId" value="${depResolve.life.profile.project.id}"/>
          </c:url>
        <%
          }
        %>
        <tbody id="${resolvedDepTBodyBase}">
          <tr class="${eo.next}">
            <td align="center">
              <ucf:link href="#" label="${ub:i18n('ShowHideDetails')}" onclick="toggleResolvedDependency(this); return false;" img="${iconPlusUrl}"/>
            </td>
            <td nowrap="nowrap">
              <c:choose>
                <c:when test="${!empty projectUrlId}"><ucf:link href="${projectUrlId}"
                    label="${depResolve.life.codestationProject.name}" title="${ub:i18n('ViewDashboard')}"/></c:when>
                <c:otherwise>${fn:escapeXml(depResolve.life.codestationProject.name)}</c:otherwise>
              </c:choose>
            </td>
            <td nowrap="nowrap" align="center">
              <c:set var="buildLifeLinkLabel"><c:out value="${fn:length(depResolve.life.latestStampValue) > 0 ? depResolve.life.latestStampValue : null}" default="${depResolve.life.id}"/></c:set>
              <c:choose>
                <c:when test="${!empty buildLifeUrl}">
                  <ucf:link href="${buildLifeUrl}" label="${buildLifeLinkLabel}" title="${ub:i18n('ViewBuildLife')}"/>
                </c:when>
                <c:otherwise>${buildLifeLinkLabel}</c:otherwise>
              </c:choose>
            </td>
            <c:set var="background_color" value="style='background-color: ${depResolve.life.latestStatus.status.color};'"/>
            <td nowrap="nowrap" align="center" ${background_color}>${fn:escapeXml(depResolve.life.latestStatusName)}</td>
            <td nowrap="nowrap" align="center">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, depResolve.life.startDate))}</td>
          </tr>
        </tbody>
        <tbody id="${resolvedDepTBodyBase}-resolves" class="dependency-resolves" style="display: none;">
      </c:if>

      <tr class="sub_row_${sub_eo.next}">
        <td>&nbsp;</td>
        <td nowrap="nowrap">
          <div style="padding-left: 20px;"><b>${ub:i18n("ArtifactSetWithColon")}</b> ${depResolve.set.name} <b>${ub:i18n("DirectoryWithColon")}</b> ${depResolve.directory}</div>
        </td>
        <td nowrap="nowrap" colspan="3">&nbsp;</td>
      </tr>

      <c:set var="lastResolvedDependencyBuildLife" value="${depResolve.life}"/>
    </c:forEach>
    <c:if test="${not empty lastResolvedDependencyBuildLife}">
      </tbody>
    </c:if>
  </table>
  <br/>
</c:if>

<%
    pageContext.setAttribute("eo", new EvenOdd());
%>
<br/>
<h3>${ub:i18n("InUseByWithColon")}</h3>
<table class="data-table">
  <thead>
    <tr>
      <th scope="col" width="47%" align="left">${ub:i18n("Project")}</th>
      <th scope="col" width="15%">${ub:i18n("Stamp")} / ${ub:i18n("ID")}</th>
      <th scope="col" width="15%">${ub:i18n("LatestStamp")}</th>
      <th scope="col" width="20%">${ub:i18n("BuildLifeDependenciesBuildDate")}</th>
    </tr>
  </thead>

  <tbody>
  <c:if test="${empty usedInArray}">
    <tr class="${eo.next}"><td colspan="4">${ub:i18n("BuildLifeDependenciesNotInUse")}</td></tr>
  </c:if>

  <c:forEach var="parentlife" items="${usedInArray}">
    <c:remove var="buildLifeUrlId"/>
    <c:remove var="projectUrlId"/>
    <%
      CodestationCompatibleBuildLife life = (CodestationCompatibleBuildLife)pageContext.findAttribute("parentlife");
      if (!hasReadPerm(life)) {
          // no links
      }
      else if (life instanceof CodestationBuildLife) {
    %>
      <c:url var="buildLifeUrlId" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}">
        <c:param name="codestationBuildLifeId" value="${parentlife.id}"/>
        <c:param name="fromBuildLife" value="${buildLife.id}"/>
      </c:url>

    <%
      }
      else {
          // anthill buildlife
    %>
      <c:url var="buildLifeUrlId" value="${BuildLifeTasks.viewBuildLife}">
        <c:param name="buildLifeId" value="${parentlife.id}"/>
      </c:url>

      <c:url var="projectUrlId" value="${ProjectTasks.viewDashboard}">
        <c:param name="projectId" value="${parentlife.profile.project.id}"/>
      </c:url>
    <%
      }
    %>

    <tr class="${eo.next}">
      <td nowrap="nowrap">
        <c:choose>
          <c:when test="${!empty projectUrlId}"><ucf:link href="${projectUrlId}"
                label="${parentlife.codestationProject.name}" title="${ub:i18n('ViewDashboard')}"/></c:when>
          <c:otherwise>${fn:escapeXml(parentlife.codestationProject.name)}</c:otherwise>
        </c:choose>
      </td>
      <td nowrap="nowrap" align="center">
        <c:set var="buildLifeLinkLabel"><c:out value="${fn:length(parentlife.latestStampValue) > 0 ? parentlife.latestStampValue : null}" default="${parentlife.id}"/></c:set>
        <c:choose>
          <c:when test="${!empty buildLifeUrlId}">
            <ucf:link href="${buildLifeUrlId}" label="${buildLifeLinkLabel}" title="${ub:i18n('ViewBuildLife')}"/>
          </c:when>
          <c:otherwise>${buildLifeLinkLabel}</c:otherwise>
        </c:choose>
      </td>
      <c:set var="background_color" value="style='background-color: ${parentlife.latestStatus.status.color};'"/>
      <td nowrap="nowrap" align="center" ${background_color}>
        <c:out value="${parentlife.latestStatus.status.name}" default="${ub:i18n('N/A')}"/>
      </td>
      <td nowrap="nowrap" align="center">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, parentlife.startDate))}</td>
    </tr>
    </c:forEach>
  </tbody>
</table>

<br/>

<c:import url="buildLifeFooter.jsp"/>
