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
<%@ page import="com.urbancode.ubuild.persistence.auditing.AuditObjectType"%>
<%@ page import="com.urbancode.ubuild.persistence.auditing.AuditQueryResults"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.ubuild.web.util.WrapText"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.commons.xml.*"  %>
<%@ page import="com.urbancode.ubuild.persistence.auditing.AuditQueryResult" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.audit.AuditTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="auditUrl" value="${AuditTasks.queryAudit}"/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<c:url var="exportUrl" value="${AuditTasks.exportCSV}">
  <c:param name="configObjectType" value="${param.configObjectType}"/>
  <c:param name="${WebConstants.USER_ID}" value="${param.userId}"/>
  <c:param name="${WebConstants.START_TIME}" value="${param.startTime}"/>
  <c:param name="${WebConstants.END_TIME}" value="${param.endTime}"/>
  <c:param name="${WebConstants.TEAM_SPACE_ID}" value="${teamSpace.id}"/>
</c:url>
<%-- CONTENT --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="title" value="${ub:i18n('SystemAudit')}" />
    <jsp:param name="selected" value="system" />
</jsp:include>

<%
pageContext.setAttribute("eo", new EvenOdd());
pageContext.setAttribute("configObjectTypeList", AuditObjectType.values());
%>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <c:url var="auditingUrl" value="${AuditTasks.viewAudit}"/>
      <ucf:link label="${ub:i18n('Audit')}" href="${auditingUrl}" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("AuditSystemHelpBox")}</div>

        <form method="post" action="${fn:escapeXml(auditUrl)}">
            <br />
            <table style="margin-bottom:1em;" class="property-table">
                <tbody>
                    <tr class="${eo.next}" valign="top">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("AuditObjectType")} </span></td>
                        <td align="left" width="20%">
                            <ucf:enumSelector name="configObjectType"
                                list="${configObjectTypeList}"
                                selectedValue="${configObjectType}"
                                canUnselect="true"
                                unselectedText="-- ${ub:i18n('AuditAllObjectTypesOption')} --"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("AuditObjectTypeDesc")}</span>
                        </td>
                        <td>&nbsp;</td>
                    </tr>

                    <tr class="${eo.next}" valign="top">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("UserWithColon")} </span></td>
                        <td align="left" width="20%">
                            <ucf:idSelector name="${WebConstants.USER_ID}"
                                list="${userList}"
                                selectedId="${userId}"
                                canUnselect="true"
                                emptyMessage="${ub:i18n('All Users')}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("AuditUserOptionDesc")}</span>
                        </td>
                        <td>&nbsp;</td>
                    </tr>

                    <tr class="${eo.next}" valign="top">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("StartTimeWithColon")}</span></td>
                        <td align="left" width="20%">
                            <input type="text" name="${fn:escapeXml(WebConstants.START_TIME)}" value="${fn:escapeXml(startTime)}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("AuditExpectedDateTimeIn")}</span>
                        </td>
                        <td>&nbsp;</td>
                    </tr>

                    <tr class="${eo.next}" valign="top">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("AuditEndTime")}</span></td>
                        <td align="left" width="20%">
                            <input type="text" name="${fn:escapeXml(WebConstants.END_TIME)}" value="${fn:escapeXml(endTime)}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("AuditExpectedDateTimeEx")}</span>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </tbody>
            </table>
            <ucf:button name="Search" label="${ub:i18n('Search')}"/>
            <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
        </form>
        <br />
        <ul class="navlist"></ul>
        <br/>
        <div class="dashboard-region">
            <c:choose>
                <c:when test="${not empty queryResults}">
<%
pageContext.setAttribute("eo", new EvenOdd());
AuditQueryResults queryResults = (AuditQueryResults) pageContext.findAttribute("queryResults");
// JSP EL throws a NumberFormatException if you try to access these with ${queryResults.page}
pageContext.setAttribute("page", queryResults.getPage() - 1);
pageContext.setAttribute("pageSize", queryResults.getPageSize());
pageContext.setAttribute("totalSize", queryResults.getTotalSize());
pageContext.setAttribute("totalPages", queryResults.getTotalPages());
%>
                  <c:url var="viewPageUrl" value="${AuditTasks.queryAudit}">
                      <c:param name="configObjectType" value="${param.configObjectType}"/>
                      <c:param name="${WebConstants.USER_ID}" value="${param.userId}"/>
                      <c:param name="${WebConstants.START_TIME}" value="${param.startTime}"/>
                      <c:param name="${WebConstants.END_TIME}" value="${param.endTime}"/>
                  </c:url>
                  <script type="text/javascript">
                      function searchRequest(page) {
                          var request = '${ah3:escapeJs(viewPageUrl)}';
                          request = request + "&page=" + page;
                          goTo(request);
                      }
                  </script>
                  <ucui:carousel id="pages" methodName="searchRequest" currentPage="${page}" numberOfPages="${totalPages}"/>
                  <br/><span class="bold">${ub:i18n("DownloadAs")}</span> <ucf:link href="${exportUrl}" label="${ub:i18n('CSV')}"/>
                  <br/><br/>

                  <c:set var="showButtons" value="false"/>

                  <form method="post" id="auditForm" action="${fn:escapeXml(auditUrl)}">
                    <table class="data-table" width="100%">
                      <tr>
                        <th nowrap="nowrap">${ub:i18n("Date")}</th>
                        <th nowrap="nowrap">${ub:i18n("User")}</th>
                        <th nowrap="nowrap">${ub:i18n("Action")}</th>
                        <th nowrap="nowrap">${ub:i18n("Type")}</th>
                        <th nowrap="nowrap">${ub:i18n("Name")}</th>
                        <th nowrap="nowrap">${ub:i18n("Description")}</th>
                      </tr>
                      <c:forEach var="queryResult" items="${queryResults}" varStatus="uowStatus">
                          <c:choose>
                              <c:when test="${queryResult.create}">
                                  <c:set var="auditHeaderClass" value="auditCreated"/>
                              </c:when>
                              <c:when test="${queryResult.delete}">
                                  <c:set var="auditHeaderClass" value="auditDeleted"/>
                              </c:when>
                              <c:otherwise>
                                  <c:set var="auditHeaderClass" value="auditModified"/>
                              </c:otherwise>
                          </c:choose>
                          <tr class="${eo.next}">
                            <td nowrap="nowrap">${fn:escapeXml(queryResult.dateTime)}</td>
                            <td nowrap="nowrap">${fn:escapeXml(queryResult.userName)}</td>
                            <td nowrap="nowrap">${fn:escapeXml(ub:i18n(queryResult.action))}</td>
                            <td nowrap="nowrap">${fn:escapeXml(ub:i18n(queryResult.objectType))}</td>
                            <td>${fn:escapeXml(queryResult.objectName)}</td>
                            <td>
                              <c:choose>
                                <c:when test="${queryResult.action == 'Edit'}">
                                  <c:choose>
                                    <c:when test="${not empty queryResult.newValue or not empty queryResult.oldValue}">
                                      <%
                                          boolean hasOldValue = false;
                                          AuditQueryResult queryResult = (AuditQueryResult) pageContext.getAttribute("queryResult");
                                          String oldValue = queryResult.getOldValue();
                                          String newValue = queryResult.getNewValue();
                                          StringBuilder auditValueChangedMessageBuilder = new StringBuilder();
                                          auditValueChangedMessageBuilder.append(queryResult.getDescription()).append("|");
                                          if (StringUtils.isNotEmpty(oldValue) && !"null".equals(oldValue)) {
                                              auditValueChangedMessageBuilder.append(oldValue);
                                              hasOldValue = true;
                                          }
                                          if (StringUtils.isNotEmpty(newValue) && !"null".equals(newValue)) {
                                              if (hasOldValue) {
                                                  auditValueChangedMessageBuilder.append(" >>> ");
                                              }
                                              auditValueChangedMessageBuilder.append(newValue);
                                          }
                                          pageContext.setAttribute("auditValueChangedMessage", auditValueChangedMessageBuilder.toString());
                                      %>
                                      <c:out value="${ub:i18nMessage('AuditDisplayMessage', auditValueChangedMessage)}"/>
                                    </c:when>
                                    <c:otherwise>
                                      ${fn:escapeXml(queryResult.description)}
                                    </c:otherwise>
                                  </c:choose>
                                </c:when>
                                <c:otherwise>
                                  ${fn:escapeXml(queryResult.description)}
                                </c:otherwise>
                              </c:choose>
                            </td>
                          </tr>
                      </c:forEach>
                    </table>
                  </form>
                </c:when>
                <c:otherwise>
                  <p>${ub:i18n("AuditNoDataFoundMessage")}</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
