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

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:if test="${not empty teamSpaceList}">
  <c:set var="fieldName" value="${WebConstants.TEAM_SPACE_ID}"/>
  <c:set var="teamValue" value="${param[fieldName] != null ? param[fieldName] : null}"/>
  <error:field-error field="${WebConstants.TEAM_SPACE_ID}"/>
  <tr>
      <td align="left" width="20%"><span class="bold">${ub:i18n("TeamWithColon")} <span class="required-text">*</span></span></td>
      <td align="left" width="20%">
          <ucf:idSelector
               name="${WebConstants.TEAM_SPACE_ID}"
               list="${teamSpaceList}"
               selectedId="${teamValue}"
               multiple="true"
               optimizeOne="true"
          />
      </td>
      <td align="left">
          <span class="inlinehelp">${ub:i18n("NewSecuredObjectTeamSelection")}</span>
      </td>
  </tr>
  
  <c:if test="${not empty resourceRoleList}">
    <c:set var="fieldName" value="${WebConstants.RESOURCE_ROLE_ID}"/>
    <c:set var="resourceRoleValue" value="${param[fieldName] != null ? param[fieldName] : null}"/>
    <error:field-error field="${WebConstants.RESOURCE_ROLE_ID}"/>
    <tr>
        <td align="left" width="20%"><span class="bold">${ub:i18n("ResourceRole")} </span></td>
        <td align="left" width="20%">
            <ucf:idSelector
                  name="${WebConstants.RESOURCE_ROLE_ID}"
                  list="${resourceRoleList}"
                  selectedId="${resourceRoleValue}"
              />
        </td>
        <td align="left">
            <span class="inlinehelp">${ub:i18n("NewSecuredObjectResourceTypeSelection")}</span>
        </td>
    </tr>
  </c:if>
</c:if>