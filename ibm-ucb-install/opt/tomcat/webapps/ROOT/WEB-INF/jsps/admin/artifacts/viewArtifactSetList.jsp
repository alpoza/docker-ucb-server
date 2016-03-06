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
<%@page import="com.urbancode.ubuild.domain.artifacts.*" %>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>
<%@ page import="com.urbancode.ubuild.domain.singleton.serversettings.*"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks"/>
<ah3:useTasks class="com.urbancode.ubuild.web.admin.artifacts.ArtifactSetTasks"/>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imgUrl" value="/images"/>

<c:url var="newArtifactSetUrl" value='${ArtifactSetTasks.newArtifactSet}'/>
<c:set var='deleteUrlBase' value='${ArtifactSetTasks.removeArtifactSet}'/>
<c:set var='viewUrlBase' value='${ArtifactSetTasks.viewArtifactSet}'/>


<%-- BEGIN PAGE --%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemArtifactSets')}" />
  <jsp:param name="selected" value="system" />
</jsp:include>

<script type="text/javascript">
  function refresh() {
     window.location.reload();
  }
</script>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<div>

    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('ArtifactSets')}" href="" enabled="${false}" klass="selected tab"/>
    </div>

    <div class="contents">
        <br/>

        <div class="system-helpbox">
            ${ub:i18n("ArtifactsSystemHelpBox1")}
            <br /><br />
            ${ub:i18n("ArtifactsSystemHelpBox2")}
        </div>
        <br/>

        <a onclick="javascript:showPopup('${ah3:escapeJs(newArtifactSetUrl)}');" class="button">${ub:i18n("CreateNewArtifactSet")}</a>
        <div class="data-table_container">
        <br />
            <table class="data-table">
                <tbody>
                    <tr>
                        <th scope="col" align="left" valign="middle">${ub:i18n("Name")}</th>
                        <th scope="col" align="left">${ub:i18n("Description")}</th>
                        <th scope="col" align="left" width="10%">${ub:i18n("Actions")}</th>
                    </tr>

                    <c:choose>
                        <c:when test="${empty artifactSetList}">
                            <tr bgcolor="#ffffff">
                                <td colspan="3">${ub:i18n("ArtifactsNoneConfiguredMessage")}</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="tempArtifactSet" items="${artifactSetList}">
                                <c:url var='deleteUrlId' value="${deleteUrlBase}">
                                    <c:param name="artifactSetId" value="${tempArtifactSet.id}"/>
                                </c:url>
                                <c:url var='viewUrlId' value="${viewUrlBase}">
                                    <c:param name="artifactSetId" value="${tempArtifactSet.id}"/>
                                </c:url>
                                <c:url var='viewSecurityUrlId' value="${viewSecurityUrlBase}">
                                    <c:param name="artifactSetId" value="${tempArtifactSet.id}"/>
                                </c:url>
                                <tr bgcolor="#ffffff">
                                    <td align="left" height="1" nowrap="nowrap">
                                      <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(viewUrlId)}');return false;"
                                          label="${ub:i18n(tempArtifactSet.name)}" title="${ub:i18n('View')}"/>
                                    </td>

                                    <td align="left" height="1">
                                        ${fn:escapeXml(ub:i18n(tempArtifactSet.description))}
                                    </td>

                                    <td align="center" height="1" nowrap="nowrap"  width="10%">
                                        <ucf:link href="#" onclick="showPopup('${ah3:escapeJs(viewUrlId)}');return false;"
                                            img="${fn:escapeXml(imgUrl)}/icon_magnifyglass.gif" label="${ub:i18n('View')}"/>&nbsp;
                                        <ucf:confirmlink href="${deleteUrlId}" img="${fn:escapeXml(imgUrl)}/icon_delete.gif"
                                            enabled="${!tempArtifactSet.inUse}" label="${ub:i18n('Delete')}"
                                            message="${ub:i18nMessage('DeleteConfirm', ub:i18n(tempArtifactSet.name))}"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
          <br/>
          <c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
          <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
