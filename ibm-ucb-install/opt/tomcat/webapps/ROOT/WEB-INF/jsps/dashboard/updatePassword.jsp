<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page contentType="text/html" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.admin.security.*"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.UserProfileTasks"%>
<%@ page import="com.urbancode.ubuild.web.dashboard.DashboardTasks"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.DashboardTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.dashboard.UserProfileTasks" />

<%
request.setAttribute(WebConstants.USER, LoginTasks.getCurrentUser(request));
%>

<c:url var="submitUrl" value="${UserProfileTasks.updatePassword}"/>
<c:url var="doneUrl" value="${DashboardTasks.viewDashboard}"/>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

    <form method="post" action="${fn:escapeXml(submitUrl)}">
        <div style="padding-bottom: 1em;">

            <div class="popup_header">
                <ul>
                    <li class="current"><a>${ub:i18n("UpdatePassword")}</a></li>
                </ul>
            </div>
            
            <div class="contents">
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
                      <error:field-error field="name" cssClass="odd"/>
                      
                      <error:field-error field="userPswdOld" cssClass="odd"/>
                      
                      <tr class="odd" valign="top">
                          <td align="left" width="20%">
                              <span class="bold">
                                  ${ub:i18n("UpdatePasswordOldPassword")} <span class="required-text">*</span>
                          </td>
                          
                          <td align="left" width="20%">
                              <ucf:password name="userPswdOld" value=""/>
                          </td>
                          
                          <td align="left">
                              <span class="inlinehelp">
                                  ${ub:i18n("UpdatePasswordOldPasswordDesc")}
                              </span>
                          </td>
                      </tr>
                      
                      <error:field-error field="userPswd" cssClass="odd"/>
                      
                      <tr class="odd" valign="top">
                          <td align="left" width="20%"><span class="bold">${ub:i18n("PasswordWithColon")} <span class="required-text">*</span></span></td>
                          
                          <td align="left" width="20%">
                              <ucf:password name="userPswd" value=""/>
                          </td>
                          
                          <td align="left">
                              <span class="inlinehelp">
                                  ${ub:i18n("UpdatePasswordNewPasswordDesc")}
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
                              <ucf:button name="update-password"  label="${ub:i18n('Update')}"/>
                              <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="window.parent.hidePopup(); return false;"/>
                          </td>
                      </tr>
                  </tbody>
              </table>
          </div>
        </div>
    </form>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
