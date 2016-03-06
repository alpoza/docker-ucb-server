<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.*"%>
<%@page import="com.urbancode.ubuild.web.util.*"%>
<%@page import="com.urbancode.ubuild.domain.cleanup.CleanupConfig" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.status.StatusTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="saveUrl"   value="${StatusTasks.saveStatus}">
    <c:param name="${WebConstants.STATUS_ID}" value="${status.id}"/>
</c:url>
<% pageContext.setAttribute(WebConstants.HTML_COLORS, HTMLColor.getColors()); %>
<c:set var="headContent" scope="request">
  <script type="text/javascript">
    /* <![CDATA[ */
    function changeColor() {
      $("colorTest").setStyle({'backgroundColor':$("color").value});
    }
    /* ]]> */
  </script>
</c:set>
<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div>
    <div class="popup_header">
        <ul>
            <li class="current">
                <a><c:out value="${ub:i18n(status.name)}" default="${ub:i18n('NewStatus')}"/></a>
            </li>
        </ul>
    </div>
    <div class="contents">
        <div class="system-helpbox">
             ${ub:i18n("StatusPopupSystemHelpBox")}
        </div>
        <br />
        <div align="right">
            <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>
        <c:if test="${status.locked}">
            <span class="error">${ub:i18n("StatusNoEditMessage")}</span>
        </c:if>
        <c:if test="${not empty status}">
            <div class="translatedName"><c:out value="${ub:i18n(status.name)}"/></div>
            <c:if test="${not empty status.description}">
                <div class="translatedDescription"><c:out value="${ub:i18n(status.description)}"/></div>
            </c:if>
        </c:if>
        <form method="post" action="${fn:escapeXml(saveUrl)}">
            <table class="property-table">
                   <tbody>
                    <c:set var="fieldName" value="name"/>
                    <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : status.name}"/>
                    <error:field-error field="name" cssClass="odd"/>
                    <tr class="odd" valign="top">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
                        <td align="left" width="20%">
                            <ucf:text name="name" value="${nameValue}" enabled="${!status.locked}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("StatusNameDesc")}</span>
                        </td>
                    </tr>

                    <c:set var="fieldName" value="description"/>
                    <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : status.description}"/>
                    <error:field-error field="description" cssClass="even"/>
                    <tr class="even" valign="top">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                        <td align="left" colspan="2">
                            <ucf:textarea name="description" value="${descriptionValue}" enabled="${!status.locked}"/>
                        </td>
                    </tr>

                    <tr class="odd" valign="top">
                        <c:set var="fieldName" value="color"/>
                        <c:set var="colorValue" value="${param[fieldName] != null ? param[fieldName] : status.color}"/>
                        <td align="left" width="20%"><span class="bold">${ub:i18n("ColorWithColon")}</span></td>
                        <td align="left" width="20%">
                            <select id="color" name="color" ${fieldAttributes} onkeyup="changeColor();" onchange="changeColor();" <c:if test='${status.locked}'>disabled</c:if>>
                                <option value="">-- ${ub:i18n("None")} --</option>
                                <c:forEach items="${htmlColors}" var="htmlColor">
                                <option value="${htmlColor.hexCode}"
                                        <c:if test="${colorValue == htmlColor.hexCode}">selected</c:if>>
                                    ${ub:i18n(fn:escapeXml(htmlColor.name))}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("StatusColorDesc")}</span>
                        </td>
                    </tr>

                <c:if test="${status == null}">
                    <error:field-error field="keepDays"/>
                    <tr>
                        <c:set var="fieldName" value="days"/>
                        <td align="left" width="20%"><span class="bold">${ub:i18n("KeepDaysWithColon")}</span></td>
                        <td align="left" width="20%">
                            <ucf:text name="keepDays" value="${keepDays}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("StatusKeepDaysDesc")}</span>
                        </td>
                    </tr>
                    <error:field-error field="keepYoungest"/>
                    <tr>
                        <c:set var="fieldName" value="youngest"/>
                        <td align="left" width="20%"><span class="bold">${ub:i18n("KeepLatestWithColon")}</span></td>
                        <td align="left" width="20%">
                            <ucf:text name="keepYoungest" value="${keepYoungest}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("StatusKeepLatestDesc")}</span>
                        </td>
                    </tr>
                    <error:field-error field="cleanupType"/>
                    <tr>
                        <c:set var="filedName" value="type"/>
                        <td align="left" width="20%"><span class="bold">${ub:i18n("CleanupType")}</span></td>
                        <td align="left">
                            <% pageContext.setAttribute("cleanupTypes", CleanupConfig.getCleanupTypeArray()); %>
                            <ucf:idSelector name="cleanupType" list="${cleanupTypes}" selectedId="${cleanupType}" />
                        </td>
                        <td align="left">
                            <span class="inlinehelp">
                                ${ub:i18n("CleanupTypeDesc")}<br/>
                                <b>${ub:i18n("StatusCleanupTypeDefaultDesc")}</b>
                            </span>
                        </td>
                    </tr>
                </c:if>

                    <tr class="odd" valign="top">
                        <td colspan="3">
                            <div id="colorTest" style="height: 20px;">&nbsp;</div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <c:choose>
                <c:when test="${!status.locked}">
                    <ucf:button name="Save" label="${ub:i18n('Save')}"/>
                    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="javascript:parent.hidePopup();"/>
                </c:when>
                <c:otherwise>
                    <ucf:button name="Done" label="${ub:i18n('Done')}" submit="${false}" onclick="javascript:parent.hidePopup();"/>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
