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

<%@page import="com.urbancode.ubuild.web.project.BuildLifeTasks" %>
<%@ page import="com.urbancode.ubuild.reporting.issue.IssueProperty"%>
<%@ page import="com.urbancode.ubuild.reporting.issue.IssueReportingFactory"%>
<%@ page import="com.urbancode.ubuild.reporting.issue.Issue"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Properties" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>

<ah3:useTasks class="com.urbancode.ubuild.web.project.BuildLifeTasks" />

<c:url var="imagesUrl" value="/images"/>
<c:import url="buildLifeHeader.jsp">
  <c:param name="selected" value="issues"/>
</c:import>

<div class="data-table_container">
  <br/>
  <h3>${ub:i18n("IssuesWithColon")} [${fn:length(issueArray)}]</h3>

  <table class="data-table buildlife-table">
    <thead>
      <tr>
        <th width="20%">${ub:i18n("Issue")}</th>
        <th width="50%" style="text-align: left;">${ub:i18n("Name")} / ${ub:i18n("Description")} / ${ub:i18n("Changes")}</th>
        <th width="10%">${ub:i18n("Type")}</th>
        <th width="10%">${ub:i18n("Owner")}</th>
        <th width="10%">${ub:i18n("Status")}</th>
      </tr>
    </thead>
    <tbody>
    <c:choose>
      <c:when test="${fn:length(issueArray) > 0}">
        <c:forEach var="issue" items="${issueArray}">
          <tr class="issue">
            <td class="level1 description id-column" onclick="toggleIssueDetail(this);">
              <span class="issue">
                <span>
                  <img class="plus" src="${fn:escapeXml(imagesUrl)}/icon_plus_sign.gif" height="16" width="16" alt="+"/>
                  <img class="minus" src="${fn:escapeXml(imagesUrl)}/icon_minus_sign.gif" height="16" width="16" alt="-"/>
                </span>
                  ${ub:i18n("Issue")}&nbsp;<c:choose>
                          <c:when test="${! empty issue.url}">
                            <a target="_blank" href="${fn:escapeXml(issue.url)}" title="${fn:escapeXml(issue.url)}">
                          </c:when>
                          <c:otherwise>
                            <a title="${ub:i18n('IssueConfigurationMessage')}">
                          </c:otherwise>
                        </c:choose>
                        ${fn:escapeXml(issue.issueId)}</a>
              </span>
            </td>
            <td>${fn:escapeXml(issue.name)}</td>
            <td style="text-align: center;">${fn:escapeXml(issue.type)}</td>
            <td style="text-align: center;">${fn:escapeXml(issue.owner)}</td>
            <td style="text-align: center;">${fn:escapeXml(issue.status)}</td>
          </tr>
          <c:if test="${not empty issue.description}">
            <tr class="issueDetail" style="display: none;">
              <td class="issueDetailPropName">
                <strong>${ub:i18n("IssueDescription")}</strong>
              </td>
              <td colspan="4">${fn:escapeXml(issue.description)}</td>
            </tr>
            <%
              Issue issue = (Issue) pageContext.findAttribute("issue");
              List<IssueProperty> propList = IssueReportingFactory.getInstance()
                      .getIssuePropertiesForIssue(issue.getIssueId());
              TreeMap<Object,Object> props = new TreeMap<Object,Object>();
              for (IssueProperty prop : propList) {
                  props.put(prop.getPropertyName(), prop.getPropertyValue());
              }
              pageContext.setAttribute("props", props);
              if (props != null && !props.isEmpty()) {
            %>
              <tr class="issueDetail" style="display: none;">
                <td class="issueDetailPropName">
                  <strong>${ub:i18n("IssueProperties")}</strong>
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
          </c:if>
        </c:forEach>
       </c:when>
       <c:otherwise>
         <tr>
           <td colspan="5">${ub:i18n("NoIssuesOnBuildLife")}</td>
         </tr>
       </c:otherwise>
    </c:choose>
    </tbody>
  </table>

  <br/>
  <br/>
  <c:url var="viewIssueTrendsUrl" value="${BuildLifeTasks.viewIssueTrends}">
      <c:param name="buildLifeId" value="${buildLife.id}"/>
  </c:url>
  <c:if test="${not empty buildLife.prevBuildLife}">
    <c:url var="viewChangeTrendsUrl" value="${BuildLifeTasks.viewChangeTrends}">
      <c:param name="buildLifeId" value="${buildLife.id}"/>
    </c:url>
    <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(viewIssueTrendsUrl)}', 1000, 600); return false;"
        title="${ub:i18n('ViewIssuesSincePreviousBuildLife')}" label="${ub:i18n('ViewIssuesSincePreviousBuildLife')}"/>
  </c:if>
</div>

<c:import url="buildLifeFooter.jsp"/>
