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
<%@page import="com.urbancode.ubuild.domain.status.StatusFactory"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="${buildLifeTaskClass}" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="addAdditionalStatusUrl" value="${CodestationBuildLifeTasks.addAdditionalStatus}"/>
<c:url var="addStatusUrl" value="${CodestationBuildLifeTasks.addStatus}"/>
<c:url var="statusHistoryUrl" value="${CodestationBuildLifeTasks.viewStatusHistory}">
  <c:param name="codestationBuildLifeId" value="${codestationBuildLife.id}"/>
</c:url>

<%
EvenOdd eo = new EvenOdd();
pageContext.setAttribute("statusArray", StatusFactory.getInstance().restoreAll());
pageContext.setAttribute("archivedStatus", StatusFactory.getInstance().restoreArchivedStatus());
%>

<%-- CONTENT --%>

<div class="tab-content">

  <div class="system-helpbox">${ub:i18n("CodeStationBuildLifeStatusHelp")}</div>
  <br/>
  <div class="data-table_container">
    <table class="data-table">
      <thead>
        <tr>
            <th scope="col" align="left" valign="middle" width="20%">${ub:i18n("StatusName")}</th>
            <th scope="col" align="left" valign="middle" width="40%">${ub:i18n("DateAssigned")}</th>
            <th scope="col" align="left" valign="middle" width="20%">${ub:i18n("User")}</th>
            <th scope="col" align="left" valign="middle" width="20%">${ub:i18n("Actions")}</th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${fn:length(codestationBuildLife.statusArray)==0}">
          <tr bgcolor="#ffffff">
            <td colspan="4">${ub:i18n("BuildLifeNoStatusesAssigned")}</td>
          </tr>
        </c:if>
        <c:forEach var="status" items="${codestationBuildLife.statusArray}" varStatus="index">
          <c:url var="removeStatusSeqUrl" value="${CodestationBuildLifeTasks.removeStatus}">
            <c:param name="statusSeq" value="${index.index}"/>
          </c:url>

          <tr bgcolor="#ffffff">
            <td align="center" nowrap="nowrap" style="background-color: ${fn:escapeXml(status.status.color)};">${fn:escapeXml(ub:i18n(status.status.name))}</td>
            <td align="left" nowrap="nowrap">${fn:escapeXml(ah3:formatDate(longDateTimeFormat, status.dateAssigned))}</td>
            <td align="center" nowrap="nowrap">${fn:escapeXml(status.user.name)}</td>
            <td align="center" nowrap="nowrap">
            <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>

            <ucf:deletelink href="${removeStatusSeqUrl}" name="${ub:i18n(status.status.name)}" img="${iconDeleteUrl}" label="${ub:i18n('Remove')}" enabled="${param.canWrite}"/>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
  <br />
  <ul class="navlist"></ul>

  <br/><br/>
  <ucf:button name="AddStatus" label="${ub:i18n('AddStatus')}"
              href="${addAdditionalStatusUrl}"
              enabled="${param.canWrite && !addStatus}"/>

  <c:if test="${param.canWrite && addStatus}">
    <br/>

    <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
    </div>

    <form method="post" action="${fn:escapeXml(addStatusUrl)}">
      <table class="property-table">

        <tbody>
          <error:field-error field="${WebConstants.STATUS_ID}" cssClass="<%=eo.getNext() %>"/>
          <tr class="<%=eo.getLast() %>" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("StatusWithColon")} <span class="required-text">*</span></span></td>

            <td align="left" width="20%">
              <ucf:idSelector name="${WebConstants.STATUS_ID}"
                            list="${statusArray}"
                            excludedId="${archivedStatus.id}"
                            enabled="${true}"
                            />
            </td>

            <td align="left">
              <span class="inlinehelp">${ub:i18n("CodeStationBuildLifeStatusDesc")}</span>
            </td>
          </tr>

          <tr>
            <td colspan="3">
              <ucf:button name="Add" label="${ub:i18n('Add')}"/>
              <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${statusHistoryUrl}"/>
            </td>
          </tr>
        </tbody>
      </table>
    </form>
  </c:if>

</div>
