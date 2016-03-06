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
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.schedules.ScheduleConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.schedules.ScheduleTasks" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.schedules.ScheduleTasks" />
<% EvenOdd eo = new EvenOdd(); %>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="true"/>
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('ChooseScheduleType')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
    <div class="system-helpbox">${ub:i18n("ScheduleConfigureSystemHelpBox")}</div>
    <br />
        <c:url var="actionUrl" value="${ScheduleTasks.newSchedule}"/>
        <input:form name="schedule-edit-form" method="post" action="${fn:escapeXml(actionUrl)}">
            <table class="property-table">
              <tbody>
<%
  DomainImpl[] typeList = (DomainImpl[]) request.getAttribute(WebConstants.SCHEDULE_TYPE_LIST);
  for (int i = 0; i < typeList.length; ++i) {
    String typeName = typeList[i].getName();
    String className = typeList[i].getImplClass().getName();
    pageContext.setAttribute("typeName", typeName);
    pageContext.setAttribute("className", className);
%>
                    <tr class="<%= eo.getLast() %>">
                        <td align="left" width="20%">
                            <c:choose>
                                <c:when test="${typeName == param.selectedType}">
                                    <c:set var="checked" value="checked"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="checked" value=""/>
                                </c:otherwise>
                            </c:choose>
                            <input type="radio" class="radio" name="<%= ScheduleConstants.SCHEDULE_TYPE %>" ${disabled}
                                 value="<c:out value="<%=className%>"/>"  ${checked}>&nbsp;
                                 <c:choose>
                                   <c:when test="${fn:containsIgnoreCase(typeName, 'Cron')}">
                                     ${ub:i18n("CronExpression")}
                                   </c:when>
                                   <c:otherwise>
                                     ${ub:i18n("IntervalSchedule")}
                                   </c:otherwise>
                                 </c:choose>
                        </td>
                        <td align="left" colspan="2">
                          <c:choose>
                            <c:when test="${fn:containsIgnoreCase(className, 'Cron')}">
                              ${ub:i18n("ScheduleCronDesc")}
                            </c:when>
                            <c:otherwise>
                              ${ub:i18n("ScheduleIntervalDesc")}
                            </c:otherwise>
                          </c:choose>
                        </td>
                    </tr>
<%}%>
                    <tr class="<%= eo.getLast() %>">
                        <td colspan="3">
                            <ucf:button name="Set" label="${ub:i18n('Set')}"/>
                            <c:url var="cancelUrl" value="${ScheduleTasks.cancelTypes}"/>
                            <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </input:form>
    </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
