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
<%@page import="com.urbancode.ubuild.web.WebConstants"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.proxy.ProxySettingsTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
    <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
  </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemProxySettingsProxy')}" />
  <jsp:param name="selected" value="system" />
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<div>
    <div class="tabManager" id="secondLevelTabs">
        <c:set var="proxyName" value="${not empty proxy.name ? proxy.name : ub:i18n('NewProxy')}"/>
        <ucf:link label="${proxyName}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
        <c:url var="submitUrl" value="${ProxySettingsTasks.saveProxy}">
            <c:param name="proxyIndex" value="${proxyIndex}"/>
        </c:url>

        <form method="post" action="${fn:escapeXml(submitUrl)}">
            <table class="property-table">
            <td align="right" style="border-top :0px; vertical-align: bottom;" colspan="4">
                    <span class="required-text">${ub:i18n("RequiredField")}</span>
            </td>
                <tbody>
                    <error:field-error field="${WebConstants.NAME}" cssClass="even"/>

                    <tr class="even">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("ProxyName")} <span class="required-text">*</span>
                        </td>   
                        
                        <td align="left" width="20%">
                            <ucf:text name="${WebConstants.NAME}" value="${proxy.name}" enabled="${inEditMode}"/>
                        </td>
                        
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("ProxyNameDesc")}</span>
                        </td>
                    </tr>
                    
                    <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="odd"/>
                    
                    <tr class="odd">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
                        </td>
                        
                        <td align="left" colspan="2">
                            <span class="inlinehelp">${ub:i18n("ProxyDescriptionDesc")}</span><br/>
                            <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${proxy.description}" enabled="${inEditMode}"/>
                        </td>
                    </tr>
                    
                    <error:field-error field="<%=ProxySettingsTasks.HOST%>" cssClass="even"/>
                    
                    <tr class="even">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("HostWithColon")} <span class="required-text">*</span>
                        </td>
                        
                        <td align="left" width="20%">
                            <ucf:text name="<%=ProxySettingsTasks.HOST%>" value="${proxy.host}" enabled="${inEditMode}"/>
                        </td>
                        
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("ProxyHostDesc")}</span>
                        </td>
                    </tr>
                    
                    <error:field-error field="<%=ProxySettingsTasks.PORT%>" cssClass="odd"/>
                    
                    <tr class="odd">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("PortWithColon")} <span class="required-text">*</span>
                        </td>   
                        
                        <td align="left" width="20%">
                            <ucf:text name="<%=ProxySettingsTasks.PORT%>" value="${proxy.port}" enabled="${inEditMode}"/>
                        </td>
                        
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("ProxyPortDesc")}</span>
                        </td>
                    </tr>
                    
                    <error:field-error field="${WebConstants.USER_NAME}" cssClass="even"/>
                    
                    <tr class="even">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("UserNameWithColon")} </span>
                        </td>
                        
                        <td align="left" width="20%">
                            <ucf:text name="${WebConstants.USER_NAME}" value="${proxy.username}" enabled="${inEditMode}"/>
                        </td>
                        
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("ProxyUsernameDesc")}</span>
                        </td>
                    </tr>
                    
                    <error:field-error field="<%=ProxySettingsTasks.PASSWORD%>" cssClass="odd"/>
                    
                    <tr class="odd">
                        <td align="left" width="20%">
                            <span class="bold">${ub:i18n("PasswordWithColon")} </span>
                        </td>
                        
                        <td align="left" width="20%">
                            <ucf:password name="<%=ProxySettingsTasks.PASSWORD%>" value="${proxy.password}" enabled="${inEditMode}"/>
                        </td>
                        
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("ProxyPasswordDesc")}</span>
                        </td>
                    </tr>
                    
                    <tr>
                        <td align="left" width="20%" colspan="3">
                            <c:if test="${inEditMode}">
                            <ucf:button name="saveProxy" label="${ub:i18n('Save')}" />
                            <c:url var="cancelUrl" value="${ProxySettingsTasks.cancelProxy}"/>
                            <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
                            </c:if>
                            <c:if test="${inViewMode}">
                            <c:url var="editUrl" value="${ProxySettingsTasks.editProxy}"/>
                            <c:url var="doneUrl" value="${ProxySettingsTasks.doneProxy}"/>
                            <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
                            <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
                            </c:if>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
