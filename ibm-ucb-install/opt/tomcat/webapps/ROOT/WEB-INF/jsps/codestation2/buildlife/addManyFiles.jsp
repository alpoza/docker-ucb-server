<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.artifacts.*" %>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${buildLifeTaskClass}"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<error:template page="/WEB-INF/snippets/errors/error.jsp" />
<%
List<String> setList = new ArrayList<String>();
for (ArtifactSet artifactSet : ArtifactSetFactory.getInstance().restoreAllActive()) {
    setList.add(artifactSet.getName());
}
pageContext.setAttribute("setList", setList);

EvenOdd eo = new EvenOdd();
pageContext.setAttribute( "eo", eo );
%>
        <div align="right">
        <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>
<c:url var="uploadFileUrl" value="${CodestationBuildLifeTasks.uploadManyFiles}"/>
<form ENCTYPE='multipart/form-data' method='POST' action="${uploadFileUrl}">
    <table class="property-table">

        <tbody>
            <error:field-error field="${WebConstants.CODESTATION_ARTIFACT_SET}" cssClass="${eo.next}"/>
            <tr class="${fn:escapeXml(eo.last)}" valign="top">
                <td>${ub:i18n("ArtifactSetWithColon")} <span class="required-text">*</span></td>
                <td>
                    <ucf:stringSelector name="${WebConstants.CODESTATION_ARTIFACT_SET}"
                                    list="${setList}"/>
                </td>
                <td>
                    <span class="inlinehelp">${ub:i18n("CodeStationBuildLifeArtifactSetAddManyFilesDesc")}</span>
                </td>
            </tr>
            
            <error:field-error field="subdir" cssClass="${eo.next}"/>
            <tr class="${fn:escapeXml(eo.last)}" valign="top">
                <td>${ub:i18n("DirectoryPrefix")} </td>
                <td>
                    <ucf:text name="subdir" value=""/>
                </td>
                <td>
                    <span class="inlinehelp">${ub:i18n("CodeStationBuildLifeArtifactSetDirectoryPrefixDesc")}</span>
                </td>
            </tr>
            
            <error:field-error field="file" cssClass="${eo.next}"/>
            <tr class="${fn:escapeXml(eo.last)}" valign="top">
                <td>${ub:i18n("FileWithColon")} <span class="required-text">*</span></td>
                <td>
                    <input type="file" name="file">
                </td>
                <td>
                    <span class="inlinehelp">${ub:i18n("CodeStationBuildLifeArtifactSetZipFileDesc")}</span>
                </td>
            </tr>
            
            <tr>
                <td colspan="3">
                    <ucf:button name="UploadZip" label="${ub:i18n('UploadZipFile')}" enabled="true"/>
                    <c:url var="viewArtifactsUrl" value="${CodestationBuildLifeTasks.viewArtifacts}"/>
                    <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${viewArtifactsUrl}"/>
                </td>
            </tr>
        </tbody>
    </table>
</form>