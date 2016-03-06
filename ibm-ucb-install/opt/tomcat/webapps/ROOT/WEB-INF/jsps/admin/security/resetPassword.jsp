<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.UserTasks" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="submitUrl" value="${UserTasks.resetPassword}"/>
<c:url var="doneUrl" value="${UserTasks.viewUserSettings}"/>

<c:set var="disableButtons" value="false"/>

<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title"    value="${ub:i18n('UsersSettings')}"/>
  <c:param name="selected" value="teams"/>
  <c:param name="disabled" value="${true}"/>
</c:import>
<div>


  <div class="tabManager" id="secondLevelTabs">
      <c:url var="usersUrl" value="${UserTasks.viewUsers}"/>
      <ucf:link href="${usersUrl}" label="${ub:i18n('Users')}" enabled="${false}" klass="selected tab"/>
  </div>

        <div class="contents">

          <div class="system-helpbox">
            ${ub:i18nMessage("ResetUserPassword", fn:escapeXml(user.name))}
          </div>

        <form method="post" action="${fn:escapeXml(submitUrl)}">
          <div id="userForm" style="margin-top:2em; margin-botton:2em;">

            <c:if test="${msg!=null}">
              <div>
                <span style="color:#0000AA;font-weight:bold;"><c:out value="${msg}"/></span>
              </div>
            </c:if>

            <table class="property-table">
            <td align="right" style="border-top :0px; vertical-align: bottom;" colspan="4">
             <span class="required-text">${ub:i18n("RequiredField")}</span>
            </td>

              <tbody>
                <error:field-error field="userPswd" cssClass="odd"/>
                <tr class="odd" valign="top">
                  <td align="left" width="20%"><span class="bold">${ub:i18n("NewPassword")} <span class="required-text">*</span></span></td>

                  <td align="left" width="20%">
                    <ucf:password name="userPswd" value=""/>
                  </td>

                  <td align="left">
                    <span class="inlinehelp">
                      ${ub:i18n("UserPassword")}
                    </span>
                  </td>
                </tr>

                <tr class="odd" valign="top">
                  <td align="left" width="20%"><span class="bold">${ub:i18n("UpdatePasswordConfirmPassword")} <span class="required-text">*</span></span></td>

                  <td align="left" width="20%">
                    <ucf:password name="userPswdConfirm" value=""/>
                  </td>

                  <td align="left">
                    <span class="inlinehelp">${ub:i18n("UpdatePasswordConfirmPasswordDesc")}</span>
                  </td>
                </tr>

                <tr class="odd">
                  <td colspan="3">
                    <ucf:button name="reset-password"  label="${ub:i18n('Reset')}"/>
                    <ucf:button href="${doneUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </form>

      </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
