<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@tag import="com.urbancode.ubuild.reporting.issue.IssueProperty"%>
<%@tag import="com.urbancode.ubuild.reporting.issue.IssueReportingFactory"%>
<%@tag import="com.urbancode.ubuild.reporting.issue.Issue"%>
<%@tag import="java.util.*" %>
<%@tag import="java.util.Collections" %>
<%@tag import="java.util.Properties" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<%@attribute name="issueList" required="true" type="java.util.Collection"%>
<%@attribute name="since" required="true" type="java.lang.String" %>
<%@attribute name="buildLife" required="true" type="java.lang.String" %>
<%@attribute name="project" required="true" type="java.lang.String" %>
<%@attribute name="workflow" required="true" type="java.lang.String" %>

<c:url var="imagesUrl" value="/images"/>
<c:set var="clippedCommentWidth" value="60" />

<div class="system-helpbox">
  <%
    String params = since + "|" + buildLife + "|" + project + "|" + workflow;
    jspContext.setAttribute("params", params);
  %>
  ${ub:i18nMessage("IssueTrendMessage", params)}
  <br/>
</div>
<br/>

<table class="data-table buildlife-table">
  <thead>
    <tr>
      <th width="20%">${ub:i18n("Issue")}</th>
      <th width="60%" style="text-align: left;">${ub:i18n("Name")} / ${ub:i18n("Description")} / ${ub:i18n("Changes")}</th>
      <th width="10%">${ub:i18n("Type")}</th>
      <th width="10%">${ub:i18n("Status")}</th>
    </tr>
  </thead>

  <c:if test="${empty issueList}">
    <tr><td colspan="4">${ub:i18n("NoIssues")}</td></tr>
  </c:if>
  <c:forEach var="issue" items="${issueList}">
    <tr class="issue">
      <td class="id-column" onclick="toggleIssueDetail(this);">
        <span class="issue">
          <span>
            <img class="plus" src="${fn:escapeXml(imagesUrl)}/icon_plus_sign.gif" height="16" width="16" alt="+"/>
            <img class="minus" src="${fn:escapeXml(imagesUrl)}/icon_minus_sign.gif" height="16" width="16" alt="-"/>
          </span>
            Issue <c:choose>
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
      <td style="text-align: center;">${fn:escapeXml(issue.status)}</td>
    </tr>
    <c:if test="${not empty issue.description}">
      <tr class="issueDetail" style="display: none;">
        <td class="issueDetailPropName">
          <strong>${ub:i18n("IssueDescription")}</strong>
        </td>
        <td colspan="3">${fn:escapeXml(issue.description)}</td>
      </tr>
      <%
        Issue issue = (Issue) jspContext.findAttribute("issue");
        List<IssueProperty> propList = IssueReportingFactory.getInstance()
                .getIssuePropertiesForIssue(issue.getIssueId());
        TreeMap<Object,Object> props = new TreeMap<Object,Object>();
        for (IssueProperty prop : propList) {
            props.put(prop.getPropertyName(), prop.getPropertyValue());
        }
        jspContext.setAttribute("props", props);
        if (props != null && !props.isEmpty()) {
      %>
            <tr class="issueDetail" style="display: none;">
              <td class="issueDetailPropName">
                <strong>${ub:i18n("IssueProperties")}</strong>
              </td>
              <td colspan="3">
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
</table>
