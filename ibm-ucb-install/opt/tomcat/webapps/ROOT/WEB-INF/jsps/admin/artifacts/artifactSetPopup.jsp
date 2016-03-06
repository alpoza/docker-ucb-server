<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.artifacts.ArtifactSetTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>
<c:url var="saveUrl"   value="${ArtifactSetTasks.saveArtifactSet}">
    <c:param name="${WebConstants.ARTIFACT_SET_ID}" value="${artifactSet.id}"/>
</c:url>
<div>
    <div class="popup_header">
        <ul class="tabs">
            <li class="current">
                <a><c:out value="${ub:i18n(artifactSet.name)}" default="${ub:i18n('ArtifactsNewArtifactSet')}"/></a>
            </li>
        </ul>
    </div>
    <div class="contents">
        <div class="system-helpbox">${ub:i18n("ArtifactsSystemHelpBox1")}</div>
        <br/>
        <div align="right">
            <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>
        <c:if test="${not empty artifactSet}">
            <div class="translatedName"><c:out value="${ub:i18n(artifactSet.name)}"/></div>
            <c:if test="${not empty artifactSet.description}">
                <div class="translatedDescription"><c:out value="${ub:i18n(artifactSet.description)}"/></div>
            </c:if>
        </c:if>
        <form method="post" action="${fn:escapeXml(saveUrl)}">
            <table class="property-table">
                <tbody>
                    <c:set var="fieldName" value="${WebConstants.NAME}"/>
                    <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : artifactSet.name}"/>
                    <error:field-error field="${WebConstants.NAME}" cssClass="even"/>
                    <tr class="odd" valign="top">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>
                        <td align="left" width="20%">
                            <ucf:text name="${WebConstants.NAME}" value="${nameValue}"/>
                        </td>
                        <td align="left">
                            <span class="inlinehelp">${ub:i18n("ArtifactsNameDesc")}</span>
                        </td>
                    </tr>

                    <c:set var="fieldName" value="${WebConstants.DESCRIPTION}"/>
                    <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : artifactSet.description}"/>
                    <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="even"/>
                    <tr class="even" valign="top">
                        <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                        <td align="left" colspan="2">
                            <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${descriptionValue}"/>
                        </td>
                    </tr>

                </tbody>
            </table>
            <br/>
            <ucf:button name="Save" label="${ub:i18n('Save')}"/>
            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="parent.hidePopup(); return false;"/>
        </form>
    </div>
</div>
<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
