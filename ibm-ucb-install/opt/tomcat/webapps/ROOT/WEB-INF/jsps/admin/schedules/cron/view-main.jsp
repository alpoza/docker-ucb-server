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
<%@page import="com.urbancode.ubuild.web.admin.schedules.cron.CronExpressionScheduleConstants" %>
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
<% EvenOdd eo = new EvenOdd(); %>
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

<jsp:useBean id="schedule" scope="request" type="com.urbancode.ubuild.domain.schedule.cron.CronExpressionSchedule"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>


<div>
    <div class="tabManager" id="secondLevelTabs">
      <c:set var="scheduleName" value="${not empty schedule.name ? schedule.name : ub:i18n('NewSchedule')}"/>
      <ucf:link label="${scheduleName}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
      <div class="system-helpbox">${ub:i18n("ScheduleConfigureSystemHelpBox")}</div>

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
                        <c:when test="${className == 'com.urbancode.ubuild.domain.schedule.cron.CronExpressionSchedule'}">
                          <c:set var="checked" value="checked"/>
                        </c:when>
                        <c:otherwise>
                          <c:set var="checked" value=""/>
                        </c:otherwise>
                      </c:choose>
                      <input type="radio" class="radio" name="<%= ScheduleConstants.SCHEDULE_TYPE %>" disabled
                                     value="${className}"  ${checked}> ${ub:i18n(fn:escapeXml(typeName))}
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

     <!-- <jsp:include page="/WEB-INF/jsps/admin/schedules/interval/view-tabs.jsp">
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
      <form id="formX" name="formX" method="post" action="${fn:escapeXml(saveUrl)}">

        <div class="tab-content">
        <div align="right">
        <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>
          <table class="property-table">
            <caption>${ub:i18n("ScheduleCronPageDesc")}</caption>
            <tbody>
              <error:field-error field="<%= CronExpressionScheduleConstants.NAME_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <strong>${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
                </td>
                <td align="left" width="20%">
                  <ucf:text name="<%= CronExpressionScheduleConstants.NAME_FIELD %>" value="${schedule.name}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("ScheduleNameDesc")}</span>
                </td>
              </tr>

              <error:field-error field="<%= CronExpressionScheduleConstants.DESCRIPTION_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
                </td>
                <td align="left" colspan="2">
                  <span class="inlinehelp">${ub:i18n("ScheduleDescriptionDesc")}</span><br/>
                  <ucf:textarea name="<%= CronExpressionScheduleConstants.DESCRIPTION_FIELD %>" value="${schedule.description}" enabled="${inEditMode}"/>
                </td>
              </tr>
              <error:field-error field="<%= CronExpressionScheduleConstants.CRON_EXPR_FIELD %>" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <strong>${ub:i18n("CronExpressionWithColon")} </strong><span class="required-text">*</span>
                </td>
                <td align="left">
                  <ucf:text name="<%= CronExpressionScheduleConstants.CRON_EXPR_FIELD %>" value="${schedule.cronExpression}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("ScheduleCronExpressionDesc")}</span>
                </td>
              </tr>

              <tr class="<%= eo.getLast() %>">
                <td colspan="3">
                <c:if test="${inEditMode}">
                  <ucf:button name="<%= CronExpressionScheduleConstants.SET_COMMAND %>" label="${ub:i18n('Save')}"/>
                  <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
                </c:if>
                <c:if test="${inViewMode}">
                  <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}"/>
                  <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
                </c:if>
              </tr>

              <tr class="<%= eo.getLast() %>">
                <td colspan="3"><blockquote class="inlinehelp">
${ub:i18n("ScheduleCronHelp")}<br/>
 <table class="data-table">
 <tr>
 <th align="left">${ub:i18n("ScheduleFieldName")}</th>
 <th align="left">${ub:i18n("AllowedValues")}</th>
 <th align="left">${ub:i18n("ScheduleAllowedSpecialCharacters")}</th>
 </tr>
 <tr class="even">
 <td align="left"><code>${ub:i18n("Seconds")}</code></td>
 <td align="left"><code>0-59</code></td>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr class="odd">
 <td align="left"><code>${ub:i18n("Minutes")}</code></td>
 <td align="left"><code>0-59</code></td>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr class="even">
 <td align="left"><code>${ub:i18n("Hours")}</code></td>
 <td align="left"><code>0-23</code></td>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr class="odd">
 <td align="left"><code>${ub:i18n("DayOfMonth")}</code></td>
 <td align="left"><code>1-31</code></td>
 <td align="left"><code>, - * ? / L W C</code></td>
 </tr>
 <tr class="even">
 <td align="left"><code>${ub:i18n("Month")}</code></td>
 <td align="left"><code>${ub:i18n("ScheduleCronMonth")}</code></td>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr class="odd">
 <td align="left"><code>${ub:i18n("DayOfWeek")}</code></td>
 <td align="left"><code>${ub:i18n("ScheduleCronWeek")}</code></td>
 <td align="left"><code>, - * ? / L C #</code></td>
 </tr>
 <tr class="even">
 <td align="left"><code>${ub:i18n("YearOptional")}</code></td>
 <td align="left"><code>${ub:i18n("Empty")}, 1970-2099</code></td>
 <td align="left"><code>, - * /</code></td>
 </tr>
 </table>


 <p>
 <b>'*'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp1")}
 </p>

 <p>

 <b>'?'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp2")}
 </p>

 <p>
 <b>'-'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp3")}
 </p>

 <p>
 <b>','</b>&nbsp;${ub:i18n("ScheduleCronCharHelp4")}
 </p>

 <p>
 <b>'/'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp5")}
 </p>

 <p>
 <b>'L'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp6")}
 </p>

 <p>
 <b>'W'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp7")}
 </p>

 <p>
 <b>'L'&nbsp;${ub:i18n("And")}&nbsp;'W'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp8")}
 </p>

 <p>

 <b>'#'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp9")}
 </p>

 <p>
 <b>'C'</b>&nbsp;${ub:i18n("ScheduleCronCharHelp10")}
 </p>
<table class="data-table">
 <tr>
 <th align="left">${ub:i18n("CronExpression")}</th>
 <th align="left">${ub:i18n("Schedule")}</th>
 </tr>
 <tr class="odd">
 <td align="left"><code>"0 15 17 ? * *"</code></td>
 <td align="left"><code>${ub:i18n("ScheduleCronExample1")}</code></td>
 </tr>
 <tr class="even">
 <td align="left"><code>"0 0 * ? * ${ub:i18n("ScheduleCronWeekMonFri")}"</code></td>
 <td align="left"><code>${ub:i18n("ScheduleCronExample2")}</code>
 </td>
 </tr>
 </table>
                </blockquote>
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
        <br/>
      </form>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
