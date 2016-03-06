<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildUser"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="error" prefix="error"%>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
  </c:otherwise>
</c:choose>

<c:set var="saveUsrRepoUrl" value="${param.saveUsrRepoUrl}"/>
<c:set var="cancelUrl" value="${param.cancelUrl}"/>
<c:set var="addUsrRepoUrl" value="${param.addUsrRepoUrl}"/>

<div>
  <ucf:button name="AddAlias" label="${ub:i18n('UserAliasesAddUserRepoAlias')}" href="${addUsrRepoUrl}"
    enabled='${inViewMode && repository_list == null}'/>
</div>
<br/>

<table id="publisherTable" class="data-table">
  <thead>
    <tr>
      <th scope="col" align="left" valign="middle">${ub:i18n("Repository")}</th>
      <th scope="col" align="center" valign="middle">${ub:i18n("UserName")}</th>
      <th scope="col" align="center" valign="middle">${ub:i18n("Actions")}</th>
    </tr>
  </thead>
  <tbody>
    <c:if test="${fn:length(user.userRepoNameArray)==0}">
      <tr bgcolor="#ffffff">
        <td colspan="3">${ub:i18n("UserAliasesNoRepoAliases")}</td>
      </tr>
    </c:if>
    <c:url var="iconRemoveUrl" value="/images/icon_delete.gif" />
    <c:forEach var="userRepoName" items="${user.userRepoNameArray}" varStatus="status">
      <c:url var="tempRemoveUsrRepoNameUrl" value="${param.removeUsrRepoNameUrl}">
        <c:param name="${WebConstants.USER_ID}" value="${user.id}"/>
        <c:param name="repoUserNameSeq" value="${status.index}" />
      </c:url>

      <tr bgcolor="#ffffff">
        <td align="left" height="1" nowrap="nowrap"><c:out value="${userRepoName.repository.name}" /> -
          ${fn:escapeXml(userRepoName.repository.id)}</td>
        <td align="left" height="1" nowrap="nowrap"><c:out value="${userRepoName.name}" />
        </td>
        <td align="center" height="1" nowrap="nowrap"><ucf:confirmlink href="${tempRemoveUsrRepoNameUrl}"
            label="${ub:i18n('Remove')}" img="${iconRemoveUrl}"
            message="${ub:i18nMessage('UserAliasesUserAliasDeleteConfirm', userRepoName.name)}"
            enabled="${inViewMode && repository_list == null}" /></td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<br/>

<c:if test="${not empty repository_list}">
  <form method="post" action="${fn:escapeXml(saveUsrRepoUrl)}">
    <table class="property-table">
      <error:field-error field="repositoryId" cssClass="even" />
      <tr class="even" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("RepositoryWithColon")}</span></td>
        <td align="left" width="20%">
          <ucf:idSelector name="repositoryId" list="${repository_list}"
            selectedId="${param.repositoryId}" enabled="${inEditMode}" />
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("UserAliasesRespositoryDesc")}</span></td>
      </tr>

      <error:field-error field="repoUserName" cssClass="odd" />
      <tr class="odd" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("UserNameWithColon")}</span></td>
        <td align="left" width="20%">
          <ucf:text name="repoUserName" value="${param.repoUserName}" enabled="${inEditMode}"/>
        </td>
        <td align="left"><span class="inlinehelp">${ub:i18n("UserAliasesUserNameDesc")}</span></td>
      </tr>
    </table>
    <br />
    <ucf:button name="addRepoUserName" label="${ub:i18n('Add')}" />
    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}" />
  </form>
</c:if>