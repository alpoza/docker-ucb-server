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
<%@page import="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" %>
<%@page import="com.urbancode.ubuild.web.admin.security.authorization.sso.SingleSignOnAuthorizationRealmTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useConstants class="com.urbancode.ubuild.web.admin.security.authorization.sso.SingleSignOnAuthorizationRealmTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmConstants" />
<ah3:useConstants class="com.urbancode.security.authorization.sso.SingleSignOnAuthorizationProperties" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" />

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
        <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
        <c:set var="inViewMode" value="true"/>
        <c:set var="textFieldAttributes" value="disabled='disabled' class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<c:url var="doneUrl"   value="${AuthorizationRealmTasks.doneAuthorizationRealm}"/>
<c:url var="editUrl"   value='${AuthorizationRealmTasks.editAuthorizationRealm}'>
  <c:param name="${WebConstants.AUTHORIZATION_REALM_ID}" value="${authorizationRealm.id}"/>
</c:url>
<c:url var="cancelUrl" value="${AuthorizationRealmTasks.cancelAuthorizationRealm}"/>
<c:url var="saveUrl"   value='${AuthorizationRealmTasks.saveAuthorizationRealm}'/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="selected" value="system"/>
    <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<%
  EvenOdd eo = new EvenOdd();
  pageContext.setAttribute("eo", eo);
%>
<div style="padding-bottom: 1em;">
    <c:import url="/WEB-INF/jsps/admin/security/authorization/securityAuthorizationSubTabs.jsp">
        <c:param name="disabled" value="${inEditMode}"/>
    </c:import>

    <div class="contents">
      <div class="system-helpbox">
        ${ub:i18n("AuthorizationSSOSystemHelpBox")}
      </div><br />
      <div align="right" style="border-top :0px; vertical-align: bottom;" colspan="4">
        <span class="required-text">${ub:i18n("RequiredField")}</span>
      </div>
      <c:if test="${not empty authorizationRealm}">
        <div class="translatedName"><c:out value="${ub:i18n(authorizationRealm.name)}"/></div>
        <c:if test="${not empty authorizationRealm.description}">
          <div class="translatedDescription"><c:out value="${ub:i18n(authorizationRealm.description)}"/></div>
        </c:if>
      </c:if>
      <form id="formX" name="formX" method="post" action="${saveUrl}">
        <ucf:hidden name="${WebConstants.AUTHORIZATION_REALM_ID}" value="${authorizationRealm.id}"/>
        <ucf:hidden name="${AuthorizationRealmConstants.TYPE_NAME}" value="${AuthorizationRealmType.SSO}"/>
        <div class="tab-content">
          <table class="property-table">
            <tbody>
              <c:set var="fieldName" value="${SingleSignOnAuthorizationRealmTasks.NAME_FIELD}"/>
              <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : authorizationRealm.name}"/>
              <error:field-error field="${SingleSignOnAuthorizationRealmTasks.NAME_FIELD}" cssClass="${eo.next}"/>
              <tr class="${eo.last}">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span>
                </td>
                <td align="left" width="20%">
                  <ucf:text name="${SingleSignOnAuthorizationRealmTasks.NAME_FIELD}" value="${nameValue}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("AuthorizationNameDesc")}</span>
                </td>
              </tr>

              <c:set var="fieldName" value="${SingleSignOnAuthorizationRealmTasks.DESCRIPTION_FIELD}"/>
              <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : authorizationRealm.description}"/>
              <error:field-error field="${SingleSignOnAuthorizationRealmTasks.DESCRIPTION_FIELD}" cssClass="${eo.next}"/>
              <tr class="${eo.last}">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
                </td>
                <td align="left" colspan="2">
                  <span class="inlinehelp">${ub:i18n("AuthorizationDescriptionDesc")}</span><br/>
                  <ucf:textarea name="${SingleSignOnAuthorizationRealmTasks.DESCRIPTION_FIELD}" value="${descriptionValue}" enabled="${inEditMode}" />
                </td>
              </tr>

              <c:set var="fieldName" value="${SingleSignOnAuthorizationRealmTasks.GROUP_MAPPER_FIELD}"/>
              <c:set var="groupMapperValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[SingleSignOnAuthorizationProperties.GROUP_MAPPER_PROPERTY]}"/>
              <error:field-error field="${SingleSignOnAuthorizationRealmTasks.GROUP_MAPPER_FIELD}" cssClass="${eo.next}"/>
              <tr class="${eo.last}">
                <td width="20%"><span class="bold">${ub:i18n("GroupMapper")} <span class="required-text">*</span></span></td>
                <td width="20%">
                  <ucf:idSelector name="${SingleSignOnAuthorizationRealmTasks.GROUP_MAPPER_FIELD}" list="${groupMapperList}"
                      selectedId="${groupMapperValue}"
                      enabled="${inEditMode}"
                      />
                <td><span class="inlinehelp">${ub:i18n("AuthorizationLDAPMapperDesc")}</span></td>
              </tr>

              <c:set var="fieldName" value="${SingleSignOnAuthorizationRealmTasks.GROUP_HEADER_FIELD}"/>
              <c:set var="groupHeaderValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[SingleSignOnAuthorizationProperties.GROUPS_HEADER_PROPERTY]}"/>
              <error:field-error field="${SingleSignOnAuthorizationRealmTasks.GROUP_HEADER_FIELD}" cssClass="<%= eo.getNext() %>"/>
              <tr class="<%= eo.getLast() %>">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("GroupHeaderName")} <span class="required-text">*</span>
                </td>
                <td align="left" width="20%">
                  <ucf:text name="${SingleSignOnAuthorizationRealmTasks.GROUP_HEADER_FIELD}" value="${groupHeaderValue}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("AuthorizationSSOHeaderDesc")}</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <br/>
        <c:if test="${inEditMode}">
          <ucf:button name="Save" label="${ub:i18n('Save')}"/>
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
