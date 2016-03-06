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
<%@page import="com.urbancode.ubuild.domain.schedule.*" %>
<%@page import="com.urbancode.ubuild.web.admin.schedules.interval.IntervalScheduleConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.schedules.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.schedules.ScheduleTasks" />

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="textFieldAttributes" value="disabled='disabled' class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<c:url var="doneUrl"   value="${ScheduleTasks.doneSchedule}"/>
<c:url var="editUrl"   value="${ScheduleTasks.editSchedule}"/>
<c:url var="cancelUrl" value="${ScheduleTasks.cancelSchedule}"/>
<c:url var="saveUrl"   value="${ScheduleTasks.saveSchedule}"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<jsp:useBean id="schedule" scope="request" type="com.urbancode.ubuild.domain.schedule.interval.IntervalSchedule"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<% EvenOdd eo = new EvenOdd(); %>
<div>
    <div class="tabManager" id="secondLevelTabs">
      <c:set var="scheduleName" value="${not empty schedule.name ? schedule.name : ub:i18n('NewSchedule')}"/>
      <ucf:link label="${scheduleName}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
    <div class="system-helpbox">${ub:i18n("ScheduleConfigureSystemHelpBox")}</div><br />

              <table class="property-table">
                <tbody>
<%
  DomainImpl[] typeList = (DomainImpl[]) request.getAttribute(WebConstants.SCHEDULE_TYPE_LIST);
  for (int i = 0; i < typeList.length; ++i) {
    String typeName = typeList[i].getName().replaceAll("\\s+","");
    String className = typeList[i].getImplClass().getName();
    String description = typeList[i].getDescription();
    pageContext.setAttribute("typeName", typeName);
    pageContext.setAttribute("className", className);
%>
                  <tr class="<%= eo.getLast() %>">
                      <td align="left" width="20%">
                        <c:choose>
                        <c:when test="${className == 'com.urbancode.ubuild.domain.schedule.interval.IntervalSchedule'}">
                          <c:set var="checked" value="checked='checked'"/>
                        </c:when>
                        <c:otherwise>
                          <c:set var="checked" value=""/>
                        </c:otherwise>
                      </c:choose>
                      <input type="radio" class="radio" name="<%= ScheduleConstants.SCHEDULE_TYPE %>" disabled="disabled"
                                     value="${className}"  ${checked}/> ${ub:i18n(fn:escapeXml(typeName))}
                    </td>
                    <td align="left">
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
                      <ucf:button name="Set" label="${ub:i18n('Set')}" enabled="false"/>
                    </td>
                  </tr>
                </tbody>
              </table>

      <br/>
<!--
      <jsp:include page="/WEB-INF/jsps/admin/schedules/interval/view-tabs.jsp">
        <jsp:param name="selected" value="main" />
      </jsp:include>
-->
      <% eo = new EvenOdd(); %>
      <c:if test="${not empty schedule}">
        <div class="translatedName"><c:out value="${ub:i18n(schedule.name)}"/></div>
        <c:if test="${not empty schedule.description}">
          <div class="translatedDescription"><c:out value="${ub:i18n(schedule.description)}"/></div>
        </c:if>
      </c:if>
      <form id="formX" name="formX" method="post" action="${saveUrl}">

        <div class="tab-content">
              <div style="float:right">
                 <span class="required-text">${ub:i18n("RequiredField")}</span>
              </div>
          <table class="property-table">
            <caption>
              <span class="inlinehelp">
                ${ub:i18n("ScheduleIntervalPageDesc")}
              </span>
            </caption>
            <tbody>
              <error:field-error field="<%= IntervalScheduleConstants.NAME_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("NameWithColon")}&nbsp;<span class="required-text">*</span></span>
                </td>
                <td align="left" width="20%">
                  <ucf:text name="<%= IntervalScheduleConstants.NAME_FIELD %>" value="${schedule.name}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("ScheduleNameDesc")}</span>
                </td>
              </tr>

              <error:field-error field="<%= IntervalScheduleConstants.DESCRIPTION_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
                </td>
                <td align="left" colspan="2">
                  <span class="inlinehelp">${ub:i18n("ScheduleDescriptionDesc")}</span><br/>
                  <ucf:textarea name="<%= IntervalScheduleConstants.DESCRIPTION_FIELD %>" value="${schedule.description}" enabled="${inEditMode}"/>
                </td>
              </tr>

              <error:field-error field="<%= IntervalScheduleConstants.INTERVAL_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("ScheduleBuildIntervalWithColon")}&nbsp;<span class="required-text">*</span></span>
                </td>
                <td align="left">
                  <ucf:text name="<%= IntervalScheduleConstants.INTERVAL_FIELD %>" value="${schedule.buildInterval}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("ScheduleBuildIntervalDesc")}</span>
                </td>
              </tr>

              <error:field-error field="<%= IntervalScheduleConstants.START_TIME_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("ScheduleIntervalStartTimeWithColon")}&nbsp;<span class="required-text">*</span></span>
                </td>
                <td align="left">
                  <ucf:text name="<%= IntervalScheduleConstants.START_TIME_FIELD %>" value="${schedule.startTime}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("ScheduleIntervalStartTimeDesc")}</span>
                </td>
              </tr>
              <c:if test="${not inEditMode}">
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr class="<%= eo.getNext() %>">
                  <td align="left" width="20%"><strong>${ub:i18n("ScheduledActionsWithColon")}</strong></td>
                  <td colspan="2">
                    <c:set var="schedulableArray" value="${schedule.schedulableArray}"/>
                    <c:if test="${empty schedulableArray}">
                      ${ub:i18n("ScheduleNothingScheduled")}<br/>
                      <br/>
                    </c:if>
                    <c:forEach var="s" items="${schedulableArray}" varStatus="status">
                      <c:if test="${status.first}"><ul></c:if>
                        <%
                          Schedulable s = (Schedulable)pageContext.findAttribute("s");
                          pageContext.setAttribute("sUrl", new ScheduleTasks().viewScheduleableUrl(s));
                        %>
                        <c:choose>
                          <c:when test="${!empty sUrl}">
                            <c:url var="itemViewUrl" value="${sUrl}"/>
                            <li><ucf:link label="${s.description}" href="${itemViewUrl}"/></li>
                          </c:when>
                          <c:otherwise>
                            <li>${fn:escapeXml(s.description)}</li>
                          </c:otherwise>
                        </c:choose>
                      <c:if test="${status.last}"></ul></c:if>
                    </c:forEach>
                  </td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>

        <br/>
        <c:if test="${inEditMode}">
          <ucf:button name="<%= IntervalScheduleConstants.SET_COMMAND %>" label="${ub:i18n('Save')}"/>
          <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
        </c:if>
        <c:if test="${inViewMode}">
          <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}"/>
          <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
        </c:if>

        <br/>

      </form>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
