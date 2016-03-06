<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.integration.maven.MavenSettingsTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.integration.maven.MavenSettingsTasks" id="MavenConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="saveUrl" value="${MavenSettingsTasks.saveRepository}"/>

<c:url var="doneUrl" value="${MavenSettingsTasks.doneRepository}">
  <c:param name="repoId" value="${repo.id}"/>
</c:url>

<%
  EvenOdd eo = new EvenOdd();
  pageContext.setAttribute("eo", eo);
%>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

  <div style="padding-bottom: 1em;">

    <div class="popup_header">
        <ul>
            <li class="current"><a><c:out value="${repo.name}" default="${ub:i18n('MavenNewMavenRepository')}"/></a></li>
        </ul>
    </div>
    <div class="contents">

      <form method="post" action="${fn:escapeXml(saveUrl)}">
        <div style="text-align: right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
        
        <table class="property-table">
          <tbody>

            <error:field-error field="${WebConstants.NAME}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="25%"><span class="bold">${ub:i18n("MavenRepositoryName")} <span class="required-text">*</span></span></td>
              <td width="20%">
                <ucf:hidden name="repoIndex"/><%-- need this? --%>
                <ucf:text name="${WebConstants.NAME}" value="${repo.name}"/>
              </td>
              <td><span class="inlinehelp">${ub:i18n("MavenRepositoryNameDesc")}</span></td>
            </tr>

            <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
              <td colspan="2">
                <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${repo.description}"/>
              </td>
            </tr>

            <error:field-error field="${MavenConstants.URL}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("URLWithColon")} <span class="required-text">*</span></span></td>
              <td colspan="2">
                <ucf:text name="${MavenConstants.URL}" value="${repo.url}" size="40"/>
              </td>
            </tr>
            
            <error:field-error field="${MavenConstants.USERNAME}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("UserNameWithColon")} </span></td>
              <td colspan="2">
                <ucf:text name="${MavenConstants.USERNAME}" value="${repo.username}" size="40"/>
              </td>
            </tr>
            
            <error:field-error field="${MavenConstants.PASSWORD}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("PasswordWithColon")} </span></td>
              <td colspan="2">
                <ucf:password name="${MavenConstants.PASSWORD}" value="${repo.password}" size="40"/>
              </td>
            </tr>
              
            <error:field-error field="${MavenConstants.PROXY_ID}" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
              <td width="20%"><span class="bold">${ub:i18n("Proxy")} </span></td>
              <td width="20%">
                <ucf:idSelector
                        name="${MavenConstants.PROXY_ID}"
                        list="${proxies}"
                        canUnselect="true"
                        selectedId="${repo.proxy.id}"/>
              </td>
              <td><span class="inlinehelp">${ub:i18n("MavenProxyDesc")}</span></td>
            </tr>
            
            <error:field-error field="verifyHashes" cssClass="${eo.next}"/>
            <tr class="${eo.last}" valign="top">
              <td width="20%"><span class="bold">${ub:i18n("MavenVerifyHashes")} </span></td>
              <td width="20%">
                <ucf:checkbox name="verifyHashes" checked="${repo.verifyHashes}"/>
              </td>
              <td><span class="inlinehelp">${ub:i18n("MavenVerifyHashesDesc")}</span></td>
            </tr>
            
          </tbody>
        </table>
          
        <div style="margin: 5px 0px;">
          <ucf:button name="Save" label="${ub:i18n('Save')}"/>
          <ucf:button href="${doneUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
        </div>
        
      </form>
    </div>
  </div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
