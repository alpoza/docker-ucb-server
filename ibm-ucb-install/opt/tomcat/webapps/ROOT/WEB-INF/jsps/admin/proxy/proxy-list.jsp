<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.proxy.ProxySettingsTasks"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.proxy.ProxySettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<div class="data-table_container">
  <c:url var="createProxyUrl" value="${ProxySettingsTasks.newProxy}"/>
  <ucf:button href="${createProxyUrl}" name="CreateProxy" label="${ub:i18n('ProxyCreate')}" enabled="${!param.disabled}"/>
  <br/>
  <br/>

  <table class="data-table">
    <tbody>
      <tr>
        <th scope="col" align="left" valign="middle" width="25%">${ub:i18n("Name")}</th>
        <th scope="col" align="left" valign="middle" width="20%">${ub:i18n("Description")}</th>
        <th scope="col" align="left" valign="middle" width="20%">${ub:i18n("Host")}</th>
        <th scope="col" align="left" valign="middle" width="20%">${ub:i18n("Port")}</th>
        <th scope="col" align="left" valign="middle" width="15%">${ub:i18n("Actions")}</th>
      </tr>

      <error:field-error field="error"/>

      <c:choose>
        <c:when test="${fn:length(proxies) == 0}">
          <tr bgcolor="#ffffff">
            <td colspan="5">${ub:i18n("ProxyNoneConfiguredMessage")}</td>
          </tr>
        </c:when>

        <c:otherwise>
          <c:url var="iconDeleteUrl" value="/images/icon_delete.gif"/>
          
          <c:forEach var="proxy" varStatus="status" items="${proxies}">
            <c:url var="viewProxyUrl" value="${ProxySettingsTasks.viewProxy}">
              <c:param name="proxyIndex" value="${status.index}"/>
            </c:url>

            <c:url var="deleteProxyUrl" value="${ProxySettingsTasks.deleteProxy}">
              <c:param name="proxyIndex" value="${status.index}"/>
            </c:url>

            <tr bgcolor="#ffffff">
              <td align="left" height="1" nowrap="nowrap">
                <c:choose>
                  <c:when test="${!param.disabled}">
                    <a href="${fn:escapeXml(viewProxyUrl)}">${fn:escapeXml(proxy.name)}</a>
                  </c:when>
                  <c:otherwise>
                    <span style="color:gray">${fn:escapeXml(proxy.name)}</span>
                  </c:otherwise>
                </c:choose>
              </td>

              <td align="left" height="1" nowrap="nowrap">
                ${fn:escapeXml(proxy.description)}
              </td>

              <td align="left" height="1" nowrap="nowrap">
                ${fn:escapeXml(proxy.host)}
              </td>
              
              <td align="left" height="1" nowrap="nowrap">
                ${fn:escapeXml(proxy.port)}
              </td>

              <td align="center">
                <ucf:deletelink href="${deleteProxyUrl}" img="${iconDeleteUrl}" name="${proxy.name}" enabled="${!param.disabled}"/>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
  <br/>
  <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}" enabled="${!param.disabled}"/>
</div>