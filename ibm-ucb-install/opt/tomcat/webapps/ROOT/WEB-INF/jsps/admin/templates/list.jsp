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
<%@page import="com.urbancode.ubuild.web.admin.templates.TemplateTasks"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>


<%@page import="com.urbancode.ubuild.domain.template.Template"%><ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="newUrl"  value='<%=new TemplateTasks().methodUrl("newTemplate", false)%>'/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemTemplateList')}"/>
  <jsp:param name="selected" value="system"/>
</jsp:include>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('NotificationTemplateList')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("NotificationTemplateSystemHelpBox")}</div>
        <br />
        <form action="${fn:escapeXml(newUrl)}" method="post">
      <c:if test="${error!=null}">
      <div class="error">${fn:escapeXml(error)}</div>
      </c:if>
        <div>
          <ucf:button href="${newUrl}" name="NewTemplate" label="${ub:i18n('ProjectTemplateCreateNew')}"/>
        </div>
        <br />
        <div class="data-table_container">
          <table class="data-table">
            <tbody>
              <tr>
                <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
                <th scope="col" align="left">${ub:i18n("Description")}</th>
                <th scope="col" align="left">${ub:i18n("Operations")}</th>
              </tr>
              <c:if test="${empty template_list}">
                <tr>
                  <td colspan="3">${ub:i18n("NotificationTemplateNoneFoundMessage")}</td>
                </tr>
              </c:if>
              <c:forEach items="${template_list}" var="template">
              <c:url var='viewUrlId' value='<%=new TemplateTasks().methodUrl("viewTemplate", false)%>'>
                <c:param name="${WebConstants.TEMPLATE_ID}" value="${template.id}"/>
              </c:url>
              <c:url var='editUrlId' value='<%=new TemplateTasks().methodUrl("editTemplate", false)%>'>
                <c:param name="${WebConstants.TEMPLATE_ID}" value="${template.id}"/>
              </c:url>
              <c:url var='deleteUrlId' value='<%=new TemplateTasks().methodUrl("deleteTemplate", false)%>'>
                <c:param name="${WebConstants.TEMPLATE_ID}" value="${template.id}"/>
              </c:url>

              <c:set var="inUse" value="${template.used}"/>

                <tr bgcolor="#ffffff">
                  <td align="left" height="1" nowrap="nowrap">
                    <ucf:link href="${viewUrlId}" label="${ub:i18n(template.name)}"/>
                  </td>
                  <td align="left" height="1">
                      ${fn:escapeXml(ub:i18n(template.description))}
                  </td>
                  <td align="center" height="1" nowrap="nowrap">
                      <c:url var="iconPencilEditUrl" value="/images/icon_pencil_edit.gif"/>
                      <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
                      <ucf:link       href="${editUrlId}"   label="${ub:i18n('Edit')}" img="${iconPencilEditUrl}"/>&nbsp;
                      <ucf:deletelink href="${deleteUrlId}" label="${ub:i18n('Delete')}" name="${template.name}" img="${iconDeleteUrl}" enabled="${not inUse}"/>
                </tr>
              </c:forEach>
            </tbody>
          </table>
          <br/>
          <a href="${fn:escapeXml(doneUrl)}" class="button">${ub:i18n("Done")}</a>
        </div>
      </form>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
