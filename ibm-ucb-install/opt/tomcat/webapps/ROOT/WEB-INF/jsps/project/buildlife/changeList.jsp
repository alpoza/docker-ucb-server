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
<%@ page import="com.urbancode.ubuild.domain.buildlife.BuildLife"%>
<%@ page import="com.urbancode.ubuild.domain.repository.Repository"%>
<%@ page import="com.urbancode.ubuild.domain.repository.SourceViewer"%>
<%@ page import="com.urbancode.ubuild.reporting.sourcechange.Change"%>
<%@ page import="com.urbancode.ubuild.reporting.sourcechange.ChangeSetProperty"%>
<%@ page import="com.urbancode.ubuild.reporting.sourcechange.SourceChangeReportingFactory"%>
<%@ page import="com.urbancode.ubuild.reporting.sourcechange.SourceChange"%>
<%@ page import="com.urbancode.ubuild.runtime.scripting.helpers.DependencyHelper"%>
<%@ page import="com.urbancode.ubuild.runtime.scripting.helpers.DependencyHelper.DependencyChange"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Properties" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.codestation2.buildlife.CodestationBuildLifeTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imagesUrl" value="/images"/>
<c:set var="clippedCommentWidth" value="60" />

<c:import url="buildLifeHeader.jsp">
  <c:param name="selected" value="changes"/>
</c:import>

<div class="data-table_container">
    <br/>
    <h3>${ub:i18n("SourceChangesWithColon")} [${fn:length(buildLife.changeSetArray)}]</h3>

    <c:choose>
        <c:when test="${empty buildLife.changeSetArray}">${ub:i18n("NoChanges")}</c:when>
        <c:otherwise>
            <table class="data-table">
              <col class="buildChange" />
              <col /> <!-- repository -->
              <col class="description" />
              <col class="user" />
              <col class="date" />
              <thead>
                <tr style="background: #87b5d6;">
                  <th class="buildChange" width="20%">${ub:i18n("Change")}</th>
                  <th>${ub:i18n("Repository")}</th>
                  <th class="description">${ub:i18n("Description")}</th>
                  <th class="user">${ub:i18n("User")}</th>
                  <th class="date">${ub:i18n("Date")}/${ub:i18n("Time")}</th>
                </tr>
              </thead>
              <tbody>

            <c:forEach var="changeSet" items="${buildLife.changeSetArray}">
              <c:remove var="repository" scope="page"/>
              <c:remove var="sourceViewer" scope="page"/>
              <c:remove var="revisionLink" scope="page"/>

              <c:set var="repository" value="${changeSet.changeSet.sourceConfig.repository.dbRepository}"/>
              <c:set var="sourceViewer" value="${repository.sourceViewer}"/>

             <%
                BuildLife bl = (BuildLife)pageContext.findAttribute("buildLife");
                Repository repository = (Repository) pageContext.findAttribute("repository");
                SourceViewer sourceViewer = (SourceViewer) pageContext.findAttribute("sourceViewer");
                SourceChange changeSet = (SourceChange) pageContext.findAttribute("changeSet");
                if (sourceViewer != null && sourceViewer.hasRevisions()) {
                    String revisionLink = sourceViewer.getRevisionLink(repository, changeSet.getChangeSet().getScmId());
                    pageContext.setAttribute("revisionLink", revisionLink);
                }
              %>

              <tr class="change">
                <td class="level1 description"
                    onclick="toggleChangeDetail(this);">
                  <span class="change">
                    <span>
                      <img class="plus" src="${fn:escapeXml(imagesUrl)}/icon_plus_sign.gif" height="16" width="16" alt="+"/>
                      <img class="minus" src="${fn:escapeXml(imagesUrl)}/icon_minus_sign.gif" height="16" width="16" alt="-"/>
                    </span>
                    ${ub:i18n("Change")}&nbsp;<c:if test="${empty revisionLink && fn:length(changeSet.changeSet.scmId)<=7}">
                         <c:out value="${changeSet.changeSet.scmId}" default="-${ub:i18n('Unknown')}-"/>
                       </c:if>
                       <c:if test="${empty revisionLink && fn:length(changeSet.changeSet.scmId)>7}">
                         <span title="${changeSet.changeSet.scmId}"><c:out value="${fn:substring(changeSet.changeSet.scmId, 0, 7)}..." default="-${ub:i18n('Unknown')}-"/></span>
                       </c:if>
                       <c:if test="${!empty revisionLink && fn:length(changeSet.changeSet.scmId)<=7}">
                         <a href="${revisionLink}" target="srcviewer"><c:out value="${changeSet.changeSet.scmId}" default="-${ub:i18n('Unknown')}-"/></a>
                       </c:if>
                       <c:if test="${!empty revisionLink && fn:length(changeSet.changeSet.scmId)>7}">
                         <a href="${revisionLink}" target="srcviewer" title="${changeSet.changeSet.scmId}"><c:out value="${fn:substring(changeSet.changeSet.scmId, 0, 7)}..." default="-${ub:i18n('Unknown')}-"/></a>
                       </c:if>
                  </span>
                </td>

                <td>${fn:escapeXml(repository.name)}</td>

                <td>
                  <div class="description">
                    <c:choose>
                      <c:when test="${fn:length(changeSet.changeSet.comment) lt clippedCommentWidth}">
                        ${fn:escapeXml(changeSet.changeSet.comment)}
                      </c:when>

                      <c:otherwise>
                        ${fn:escapeXml(fn:substring(changeSet.changeSet.comment, 0, clippedCommentWidth))}&hellip;
                      </c:otherwise>
                    </c:choose>
                  </div>
                </td>

                <td class="user">${fn:escapeXml(changeSet.changeSet.repositoryUser.repositoryUserName)}</td>

                <td class="date">
                   ${fn:escapeXml(ah3:formatDate(shortDateTimeFormat, changeSet.changeSet.date))}
                </td>
              </tr>

              <tr class="changeDetail" style="display: none;">
                <td align="right"><strong>${ub:i18n("ChangeDescription")}</strong>
                  <div class="viewFileList">
                    <span class="view" onclick="toggleFileList(this);"
                      >View Files (${fn:length(changeSet.changeSet.changes)})<span
                        ><img src="${imagesUrl}/icon_arrow_down.gif" height="16" width="16"
                      /></span
                    ></span>

                    <div class="fileList">
                      <table>
                        <c:forEach var="change" varStatus="changeStatus" items="${changeSet.changeSet.changes}" >
                          <c:choose>
                            <c:when test="${changeStatus.first and changeStatus.last}">
                              <c:set var="rowClass" value="first last" />
                            </c:when>

                            <c:when test="${changeStatus.first}">
                              <c:set var="rowClass" value="first" />
                            </c:when>

                            <c:when test="${changeStatus.last}">
                              <c:set var="rowClass" value="last" />
                            </c:when>

                            <c:otherwise>
                              <c:set var="rowClass" value="" />
                            </c:otherwise>
                          </c:choose>

                          <tr class="${rowClass}">
                            <td class="change">
                              ${fn:escapeXml(change.changeType)}
                            </td>
             <%
                if (sourceViewer != null && changeSet != null) {
                    Change change = (Change) pageContext.getAttribute("change");
                    String fileRevisionLink = sourceViewer.getFileRevisionLink(
                        repository, change.getChangePath(), changeSet.getChangeSet().getScmId());
                    pageContext.setAttribute("fileRevisionLink", fileRevisionLink);
                }
              %>
                            <td>
                              <c:if test="${empty fileRevisionLink}">
                                ${fn:escapeXml(change.changePath)}
                              </c:if>
                              <c:if test="${!empty fileRevisionLink}">
                                <a href="${fileRevisionLink}" target="srcviewer">${fn:escapeXml(change.changePath)}</a>
                              </c:if>
                            </td>

                            <c:if test="${!empty change.revisionNumber}">
                                <td class="change">
                                  ${fn:escapeXml(change.revisionNumber)}
                                </td>
                            </c:if>
                          </tr>
                        </c:forEach>
                      </table>
                    </div>
                  </div>
                </td>
                <td colspan="4">${ah3:htmlBreaks(fn:escapeXml(fn:trim(changeSet.changeSet.comment)))}</td>
              </tr>

              <%
                List<ChangeSetProperty> propList = SourceChangeReportingFactory.getInstance()
                        .getChangeSetPropertiesForChangeSet(changeSet.getChangeSet());
                TreeMap<Object,Object> props = new TreeMap<Object,Object>();
                for (ChangeSetProperty prop : propList) {
                    props.put(prop.getPropertyName(), prop.getPropertyValue());
                }
                pageContext.setAttribute("props", props);
                if (props != null && !props.isEmpty()) {
              %>
              <tr class="changeDetail" style="display: none;">
                <td align="right">
                  <strong>${ub:i18n("ChangeProperties")}</strong>
                </td>
                <td colspan="4">
                  <c:forEach var="prop" items="${props}">
                    <c:out value="${prop.key}"/> = <c:out value="${prop.value}"/><br/>
                  </c:forEach>
                </td>
              </tr>
              <%
                }
              %>

            </c:forEach>
              </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <br/>
    <br/>
    <c:if test="${not empty buildLife.prevBuildLife}">
      <c:url var="viewChangeTrendsUrl" value="${BuildLifeTasks.viewChangeTrends}">
        <c:param name="buildLifeId" value="${buildLife.id}"/>
      </c:url>
      <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(viewChangeTrendsUrl)}', 1000, 600); return false;"
         title="${ub:i18n('ViewChangesSincePreviousBuildLife')}" label="${ub:i18n('ViewChangesSincePreviousBuildLife')}"/>
    </c:if>
    <br/>
    <br/>
<%
    BuildLife buildLife = (BuildLife) request.getAttribute(WebConstants.BUILD_LIFE);
    DependencyChange[] depChanges = buildLife.getDependencyChangeArray();
    pageContext.setAttribute("depChanges", depChanges);
%>

    <h3>${ub:i18n("DependencyChangesWithColon")} [<%= depChanges.length %>]</h3>

    <c:choose>
        <c:when test="${fn:length(depChanges) > 0}">
                <table class="data-table">
                    <col class="changeType" />
                    <col class="depName" />
                    <col class="prevDep" />
                    <col class="currentDep" />

                    <tr style="background: #87b5d6;">
                        <th>${ub:i18n("Change")}</th>
                        <th>${ub:i18n("Dependency")}</th>
                        <th>${ub:i18n("Previous")}</th>
                        <th>${ub:i18n("Current")}</th>
                    </tr>

                    <c:forEach var="depChange" items="${depChanges}">
                        <tr class="change">
                            <c:if test="${depChange.addition}">
                                <c:choose>
                                    <c:when test="${depChange.currentBuildLife.class.name == 'com.urbancode.ubuild.domain.buildlife.BuildLife'}">
                                        <c:url var="currentBuildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
                                            <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${depChange.currentBuildLife.id}"/>
                                        </c:url>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="currentBuildLifeUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}">
                                            <c:param name="${WebConstants.CODESTATION_BUILD_LIFE_ID}" value="${depChange.currentBuildLife.id}"/>
                                        </c:url>
                                    </c:otherwise>
                                </c:choose>
                                <td>${fn:toUpperCase(ub:i18n("Added"))}</td>
                                <td>${fn:escapeXml(depChange.name)}</td>
                                <td align="center">-</td>
                                <td align="center"><a href="${fn:escapeXml(currentBuildLifeUrl)}"><c:out
                                            value="${depChange.currentBuildLife.latestStampValue}"
                                        default="${depChange.currentBuildLife.id}"/></a>
                                </td>
                            </c:if>
                            <c:if test="${depChange.removal}">
                                <c:choose>
                                    <c:when test="${depChange.previousBuildLife.class.name == 'com.urbancode.ubuild.domain.buildlife.BuildLife'}">
                                        <c:url var="prevBuildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
                                            <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${depChange.previousBuildLife.id}"/>
                                        </c:url>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="prevBuildLifeUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}">
                                            <c:param name="${WebConstants.CODESTATION_BUILD_LIFE_ID}" value="${depChange.previousBuildLife.id}"/>
                                        </c:url>
                                    </c:otherwise>
                                </c:choose>
                                <td>${fn:toUpperCase(ub:i18n("Removed"))}</td>
                                <td>${fn:escapeXml(depChange.name)}</td>
                                <td align="center"><a href="${fn:escapeXml(prevBuildLifeUrl)}"><c:out
                                            value="${depChange.previousBuildLife.latestStampValue}"
                                        default="${depChange.previousBuildLife.id}"/></a>
                                </td>
                                <td align="center">-</td>
                            </c:if>
                            <c:if test="${depChange.change}">
                                <c:choose>
                                    <c:when test="${depChange.currentBuildLife.class.name == 'com.urbancode.ubuild.domain.buildlife.BuildLife'}">
                                        <c:url var="currentBuildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
                                            <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${depChange.currentBuildLife.id}"/>
                                        </c:url>
                                        <c:url var="prevBuildLifeUrl" value="${BuildLifeTasks.viewBuildLife}">
                                            <c:param name="${WebConstants.BUILD_LIFE_ID}" value="${depChange.previousBuildLife.id}"/>
                                        </c:url>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="currentBuildLifeUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}">
                                            <c:param name="${WebConstants.CODESTATION_BUILD_LIFE_ID}" value="${depChange.currentBuildLife.id}"/>
                                        </c:url>
                                        <c:url var="prevBuildLifeUrl" value="${CodestationBuildLifeTasks.viewCodestationBuildLife}">
                                            <c:param name="${WebConstants.CODESTATION_BUILD_LIFE_ID}" value="${depChange.previousBuildLife.id}"/>
                                        </c:url>
                                    </c:otherwise>
                                </c:choose>
                                <td>${fn:toUpperCase(ub:i18n("Changed"))}</td>
                                <td>${fn:escapeXml(depChange.name)}</td>
                                <td align="center"><a href="${fn:escapeXml(prevBuildLifeUrl)}"><c:out
                                            value="${depChange.previousBuildLife.latestStampValue}"
                                        default="${depChange.previousBuildLife.id}"/></a>
                                </td>
                                <td align="center"><a href="${fn:escapeXml(currentBuildLifeUrl)}"><c:out
                                            value="${depChange.currentBuildLife.latestStampValue}"
                                        default="${depChange.currentBuildLife.id}"/></a>
                                </td>
                            </c:if>
                        </tr>
                    </c:forEach>
                </table>
        </c:when>
        <c:otherwise>
            ${ub:i18n("NoChanges")}
        </c:otherwise>
    </c:choose>

</div>

<c:import url="buildLifeFooter.jsp"/>
