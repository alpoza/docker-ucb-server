<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@ page import="com.urbancode.ubuild.web.admin.status.StatusTasks"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.status.StatusTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="viewListUrl" value='${StatusTasks.viewList}'/>
<c:set var="deleteStatusUrl" value='${StatusTasks.removeStatus}'/>
<c:set var="editStatusUrl" value='${StatusTasks.editStatus}'/>
<c:url var="newStatusUrl" value='${StatusTasks.newStatus}'/>

<c:url var="viewIconUrl" value="/images/icon_magnifyglass.gif"/>
<c:url var="deleteIconUrl" value="/images/icon_delete.gif"/>

<c:url var="upIconUrl" value="/images/icon_up_arrow.gif"/>
<c:url var="downIconUrl" value="/images/icon_down_arrow.gif"/>
<c:url var="grabberIconUrl" value="/images/icon_grabber.gif"/>

<c:url var="moveStatusUrl" value="${StatusTasks.moveStatus}"/>



<%
    EvenOdd eo = new EvenOdd();
%>

<%-- BEGIN PAGE --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="System: Statuses" />
  <jsp:param name="selected" value="system" />
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>


<style type="text/css">
    table.data-table td.status_row_even {
        color: #000000;
        background-color: #ffffff;
        border: 1px #e3e7eb solid;
        margin: 0px;
        padding: 5px;
        font-family: arial, helvetica, sans-serif;
        font-size: 12px;
        line-height: 10px;
    }
    table.data-table td.status_row_odd {
        color: #000000;
        background-color: #f9f8f7;
        border: 1px #e3e7eb solid;
        margin: 0px;
        padding: 5px;
        font-family: arial, helvetica, sans-serif;
        font-size: 12px;
        line-height: 10px;
    }
</style>

<script type="text/javascript">
    function refresh() {
        window.location.reload();
    }

    function moveStatus(moveIndex, moveToIndex) {
         goTo("${ah3:escapeJs(moveStatusUrl)}?moveIndex=" + moveIndex + "&moveToIndex=" + moveToIndex);
    }
</script>


<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<div>


    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('Statuses')}" href="" enabled="${false}" klass="selected tab"/>
    </div>

    <div class="contents">
        <br/>
        <div class="system-helpbox">
            ${ub:i18n("StatusSystemHelpBox")}
        </div>
        <br/>
        <a class="button" onclick="javascript:showPopup('${ah3:escapeJs(newStatusUrl)}');">${ub:i18n("CreateNewStatus")}</a>
        <div class="data-table_container">
         <br />
            <table class="data-table">
                <tbody>
                    <tr>
                        <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
                        <th scope="col" align="left">${ub:i18n("Description")}</th>
                        <th scope="col" align="left" valign="middle" width="5%">${ub:i18n("Color")}</th>
                        <th scope="col" align="left" width="10%">${ub:i18n("Actions")}</th>
                    </tr>

                    <c:if test="${empty statusList}">
                        <tr bgcolor="#ffffff">
                            <td colspan="4">${ub:i18n("StatusNoStatusMessage")}</td>
                        </tr>
                    </c:if>
                    <c:forEach var="tempStatus" varStatus="loopStatus" items="${statusList}">
                        <c:set var="rowStyle" value="${loopStatus.index % 2 == 0 ? 'status_row_even' : 'status_row_odd'}"/>
                        <c:url var='deleteUrlId' value="${deleteStatusUrl}">
                            <c:param name="statusId" value="${tempStatus.id}"/>
                        </c:url>

                        <c:url var='editUrlId' value="${editStatusUrl}">
                            <c:param name="statusId" value="${tempStatus.id}"/>
                        </c:url>

                        <tr bgcolor="#ffffff" id="status-row-${loopStatus.index}">
                            <td align="left" height="1" nowrap="nowrap" class="${fn:escapeXml(rowStyle)}">
                                <div style="float: right;" align="right"><img style="cursor:move;" id="grabber${loopStatus.index}"
                                    title="${ub:i18n('Reorder')}" alt="${ub:i18n('Reorder')}" src="${grabberIconUrl}"/></div>
                                <script type="text/javascript">
                                    Element.observe(window, 'load', function(event) {
                                        new UC_STATUS_ROW("status-row-${loopStatus.index}", ${tempStatus.id});
                                    });
                                </script>
                                <ucf:link href="#" onclick="showPopup(${fn:escapeXml(ah3:toJson(editUrlId))});return false;" label="${ub:i18n(tempStatus.name)}"/>
                            </td>


                            <td align="left" height="1" class="${fn:escapeXml(rowStyle)}">
                                ${fn:escapeXml(ub:i18n(tempStatus.description))}
                            </td>
                            <td align="left" height="1" nowrap="nowrap"
                                style="background-color: ${ah3:escapeJs(tempStatus.color)}" class="${fn:escapeXml(rowStyle)}">&nbsp;
                            </td>

                            <td align="center" height="1" nowrap="nowrap"  width="10%" class="${fn:escapeXml(rowStyle)}">
                                <ucf:link href="#" onclick="showPopup(${fn:escapeXml(ah3:toJson(editUrlId))});return false;" img="${viewIconUrl}" label="${ub:i18n('View')}"/>
                                &nbsp;<ucf:confirmlink href="${deleteUrlId}" img="${deleteIconUrl}" label="${ub:i18n('Delete')}"
                                    message="${ub:i18nMessage('StatusDeleteMessage', ub:i18n(tempStatus.name))}" enabled="${!tempStatus.locked}"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
          <br/>
          <c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
          <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
        </div>
   </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
