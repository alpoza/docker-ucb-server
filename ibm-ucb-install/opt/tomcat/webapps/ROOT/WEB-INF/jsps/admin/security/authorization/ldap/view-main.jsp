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
<%@page import="com.urbancode.ubuild.web.admin.security.authorization.ldap.LDAPAuthorizationRealmTasks" %>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmTasks" />
<ah3:useConstants class="com.urbancode.security.authorization.ldap.LdapAuthorizationProperties"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.security.authorization.ldap.LDAPAuthorizationRealmTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.admin.security.authorization.AuthorizationRealmConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.AuthorizationRealmType"/>

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
        ${ub:i18n("AuthorizationLDAPSystemHelpBox")}
      </div><br />
      <div align="right">
          <span class="required-text">${ub:i18n("RequiredField")}</span>
      </div>

      <c:if test="${not empty authorizationRealm}">
        <div class="translatedName"><c:out value="${ub:i18n(authorizationRealm.name)}"/></div>
        <c:if test="${not empty authorizationRealm.description}">
          <div class="translatedDescription"><c:out value="${ub:i18n(authorizationRealm.description)}"/></div>
        </c:if>
      </c:if>
      <form id="formX" name="formX" method="post" action="${fn:escapeXml(saveUrl)}">
        <ucf:hidden name="${WebConstants.AUTHORIZATION_REALM_ID}" value="${authorizationRealm.id}"/>
        <ucf:hidden name="${AuthorizationRealmConstants.TYPE_NAME}" value="${AuthorizationRealmType.LDAP}"/>

        <div class="tab-content">
          <table class="property-table">
            <tbody>
              <c:set var="fieldName" value="${LDAPAuthorizationRealmTasks.NAME_FIELD}"/>
              <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : authorizationRealm.name}"/>
              <error:field-error field="${LDAPAuthorizationRealmTasks.NAME_FIELD}" cssClass="${eo.next}"/>
              <tr class="${eo.last}">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
                </td>
                <td align="left" width="20%">
                  <ucf:text name="${LDAPAuthorizationRealmTasks.NAME_FIELD}" value="${nameValue}" enabled="${inEditMode}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("AuthorizationNameDesc")}</span>
                </td>
              </tr>

              <c:set var="fieldName" value="${LDAPAuthorizationRealmTasks.DESCRIPTION_FIELD}"/>
              <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : authorizationRealm.description}"/>
              <error:field-error field="${LDAPAuthorizationRealmTasks.DESCRIPTION_FIELD}" cssClass="${eo.next}"/>
              <tr class="${eo.last}">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
                </td>
                <td align="left" colspan="2">
                  <span class="inlinehelp">${ub:i18n("AuthorizationDescriptionDesc")}</span><br/>
                  <ucf:textarea name="${LDAPAuthorizationRealmTasks.DESCRIPTION_FIELD}" value="${descriptionValue}" enabled="${inEditMode}" />
                </td>
              </tr>

              <c:set var="fieldName" value="${LdapAuthorizationProperties.GROUP_MAPPER_PROPERTY}"/>
              <c:set var="groupMapperValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthorizationProperties.GROUP_MAPPER_PROPERTY]}"/>
              <error:field-error field="${LdapAuthorizationProperties.GROUP_MAPPER_PROPERTY}" cssClass="${eo.next}"/>
              <tr class="${eo.last}">
                <td width="20%"><span class="bold">${ub:i18n("GroupMapper")} <span class="required-text">*</span></span></td>
                <td width="20%">
                  <ucf:idSelector name="${LdapAuthorizationProperties.GROUP_MAPPER_PROPERTY}" list="${groupMapperList}"
                      selectedId="${groupMapperValue}"
                      enabled="${inEditMode}"
                      />
                <td><span class="inlinehelp">${ub:i18n("AuthorizationLDAPMapperDesc")}</span></td>
              </tr>

            </tbody>
          </table>

          <br/>
          <p><span class="bold">${ub:i18n("AuthorizationLDAPRoleHelp")}</span></p>

<%--
    static public final String GROUP_ATTRIBUTE_PROPERTY = "group-attribute";
    static public final String GROUP_BASE_PROPERTY = "group-base";
    static public final String GROUP_SEARCH_PROPERTY = "group-search";
    static public final String GROUP_SEARCH_SUBTREE_PROPERTY = "group-search-subtree";
    static public final String GROUP_NAME_PROPERTY = "group-name";
    static public final String GROUP_MAPPER_PROPERTY = "group-mapper";
 --%>
          <table class="property-table" border="0" cellpadding="4" cellspacing="0" width="95%" align="center">
            <error:field-error field="${LdapAuthorizationProperties.GROUP_ATTRIBUTE_PROPERTY}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("GroupAttribute")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthorizationProperties.GROUP_ATTRIBUTE_PROPERTY}"/>
                <c:set var="groupAttributeValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthorizationProperties.GROUP_ATTRIBUTE_PROPERTY]}"/>
                <ucf:text name="${LdapAuthorizationProperties.GROUP_ATTRIBUTE_PROPERTY}"
                    value="${groupAttributeValue}"
                    enabled="${inEditMode}"/></td>
              <td><span class="inlinehelp">${ub:i18n("AuthorizationLDAPGroupAttributeDesc")}</span></td>
            </tr>
          </table>

          <br/>
          <p><span class="bold">${ub:i18n("AuthorizationLDAPRoleSearchHelp")}</span></p>

          <table class="property-table" border="0" cellpadding="4" cellspacing="0" width="95%" align="center">
            <error:field-error field="${LdapAuthorizationProperties.GROUP_NAME_PROPERTY}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("GroupNameWithColon")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthorizationProperties.GROUP_NAME_PROPERTY}"/>
                <c:set var="groupNameValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthorizationProperties.GROUP_NAME_PROPERTY]}"/>
                <ucf:text name="${LdapAuthorizationProperties.GROUP_NAME_PROPERTY}"
                    value="${groupNameValue}"
                    enabled="${inEditMode}"/></td>
              <td><span class="inlinehelp">${ub:i18n("AuthorizationLDAPGroupNameDesc")}</span></td>
            </tr>

            <error:field-error field="${LdapAuthorizationProperties.GROUP_BASE_PROPERTY}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("GroupBase")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthorizationProperties.GROUP_BASE_PROPERTY}"/>
                <c:set var="groupBaseValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthorizationProperties.GROUP_BASE_PROPERTY]}"/>
                <ucf:text name="${LdapAuthorizationProperties.GROUP_BASE_PROPERTY}"
                    value="${groupBaseValue}"
                    enabled="${inEditMode}"/></td>
              <td><span class="inlinehelp">${ub:i18n("AuthorizationLDAPGroupBaseDesc")}</span></td>
            </tr>

            <error:field-error field="${LdapAuthorizationProperties.GROUP_SEARCH_PROPERTY}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
              <td width="20%"><span class="bold">${ub:i18n("GroupSearch")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthorizationProperties.GROUP_SEARCH_PROPERTY}"/>
                <c:set var="groupSearchValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthorizationProperties.GROUP_SEARCH_PROPERTY]}"/>
                <ucf:text name="${LdapAuthorizationProperties.GROUP_SEARCH_PROPERTY}"
                    value="${groupSearchValue}"
                    enabled="${inEditMode}"/></td>
              <td><span class="inlinehelp">${ub:i18n("AuthorizationLDAPGroupSearchDesc")}</span></td>
            </tr>

            <tr class="${eo.next}">
              <td width="20%"><span class="bold">${ub:i18n("SearchGroupSubtree")} </span></td>
              <td width="20%">
                <c:set var="fieldName" value="${LdapAuthorizationProperties.GROUP_SEARCH_SUBTREE_PROPERTY}"/>
                <c:set var="subtreeValue" value="${param[fieldName] != null ? param[fieldName] : authRealmProps[LdapAuthorizationProperties.GROUP_SEARCH_SUBTREE_PROPERTY]}"/>
                <input type="radio" class="radio" name="${LdapAuthorizationProperties.GROUP_SEARCH_SUBTREE_PROPERTY}" value="true"
                    <c:if test="${subtreeValue}">checked="true"</c:if>
                    "${textFieldAttributes}"/> ${ub:i18n("true")}<br/>
                <input type="radio" class="radio" name="${LdapAuthorizationProperties.GROUP_SEARCH_SUBTREE_PROPERTY}" value="false"
                    <c:if test="${!subtreeValue}">checked="true"</c:if>
                    "${textFieldAttributes}"/> ${ub:i18n("false")}
              </td>
              <td><span class="inlinehelp">${ub:i18n("AuthorizationLDAPSearchDesc")}</span></td>
            </tr>
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
