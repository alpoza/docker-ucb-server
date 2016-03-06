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
<%@page import="com.urbancode.ubuild.domain.cleanup.*"%>
<%@page import="com.urbancode.ubuild.domain.status.*"%>
<%@page import="com.urbancode.ubuild.web.admin.cleanup.CleanupTasks"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="input" %>
<%@taglib uri="error" prefix="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.cleanup.CleanupTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:url var="imgUrl" value="/images"/>

<c:url var="actionUrl" value="${CleanupTasks.saveCleanup}"/>
<c:url var="cancelUrl" value="${CleanupTasks.cancelCleanup}"/>
<c:url var="editUrl" value="${CleanupTasks.editCleanup}"/>
<c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>

<c:set var="MAX_INTEGER" value="<%= (new Integer(Integer.MAX_VALUE)).toString() %>"/>

<c:choose>
  <c:when test='${fn:escapeXml(mode) == "edit"}'>
    <c:set var="inEditMode" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="inViewMode" value="true"/>
  </c:otherwise>
</c:choose>


<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemCleanup')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${inEditMode}"/>
</jsp:include>

<script type="text/javascript">
  function refresh() {
     window.location.reload();
  }
</script>

<%
pageContext.setAttribute("eo", new EvenOdd());
pageContext.setAttribute("statusList", StatusFactory.getInstance().restoreAll());
%>

<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('Cleanup')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
      <div class="system-helpbox">${ub:i18n("CleanupSystemHelpBox")}</div>

      <br/>

      <error:template page="/WEB-INF/snippets/errors/error.jsp"/>

      <br/>
      <div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>

      <form method="post" action="${fn:escapeXml(actionUrl)}">
        <table class="property-table">
          <tbody>

            <error:field-error field="${WebConstants.SCHEDULE_ID}" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
                <td align="left" width="20%" nowrap="nowrap">
                    <span class="bold">${ub:i18n("ScheduleWithColon")}</span>
                </td>
                <td align="left" width="20%">
                  <ucf:idSelector name="${WebConstants.SCHEDULE_ID}"
                      list="${scheduleList}"
                      selectedId="${cleanup.schedule.id}"
                      enabled="${inEditMode}"
                      emptyMessage="${ub:i18n('Never')}"
                      canUnselect="true"
                      />
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("CleanupScheduleDesc")}</span>
                </td>
            </tr>

            <error:field-error field="keepLockableResources" cssClass="${eo.next}"/>
            <tr class="${eo.last}">
                <td align="left" width="20%" nowrap="nowrap">
                    <span class="bold">${ub:i18n("CleanupKeepResources")} <span class="required-text">*</span></span>
                </td>
                <td align="left" width="20%">
                    <ucf:text name="keepLockableResources" enabled="${inEditMode}" size="10" value="${cleanup.daysToKeepLockableResources}"/>
                </td>
                <td align="left">
                    <span class="inlinehelp">${ub:i18n("CleanupKeepResourcesDesc")}<br/>
                    ${ub:i18n("CleanupKeepResourcesDescDefault")}</span>
                </td>
            </tr>
          </tbody>
        </table>
        <br/>
        <c:if test="${inEditMode}">
          <ucf:button name="saveCleanup" label="${ub:i18n('Save')}"/>
          <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
        </c:if>
        <c:if test="${inViewMode}">
          <ucf:button href="${editUrl}" name="Edit" label="${ub:i18n('Edit')}"/>
          <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
        </c:if>
      </form>

        <br/>
<table class="property-table" width="100%">
    <tbody>
        <tr align="center" valign="top">
            <td width="39%" style="padding: 10px 20px;">
                <div style="text-align: left;">
                  <span class="bold">${ub:i18n("CleanupBuildRequestsWithColon")}</span>
                </div>
                <br/>
                <table class="data-table">
                    <thead>
                      <tr>
                        <th>${ub:i18n("Edit")}</th>
                        <th>${ub:i18n("CleanupRequests")}</th>
                        <th>${ub:i18n("KeepLatest")}</th>
                      </tr>
                    </thead>
                    <tbody>
                        <tr class="odd">
                          <td rowspan="2" align="center">
                            <c:url var="editCleanupBuildRequestsUrl" value="${CleanupTasks.editCleanupBuildRequestsPopup}"/>
                            <ucf:link label="${ub:i18n('Edit')}" img="${fn:escapeXml(imgUrl)}/icon_pencil_edit.gif"
                                href="#" enabled="${inViewMode}"
                                onclick="showPopup('${ah3:escapeJs(editCleanupBuildRequestsUrl)}');return false;"/>
                          </td>
                          <td>${ub:i18n("MiscellaneousJobs")}</td>
                          <td align="center">
                            <c:choose>
                              <c:when test="${cleanupConfig.miscExpire == MAX_INTEGER}">
                              ${ub:i18n("Never")}
                              </c:when>
                              <c:otherwise>
                              ${fn:escapeXml(cleanupConfig.miscExpire)}
                              </c:otherwise>
                            </c:choose>
                          </td>
                        </tr>
                        <tr class="odd">
                            <td>${ub:i18n("CleanupBuildRequestsNoBuildLives")}</td>
                            <td align="center">
                                <c:choose>
                                <c:when test="${cleanupConfig.buildRequestExpire == MAX_INTEGER}">
                                ${ub:i18n("Never")}
                                </c:when>
                                <c:otherwise>
                                ${fn:escapeXml(cleanupConfig.buildRequestExpire)}
                                </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <br/>
                <div style="text-align: left;">
                <span class="bold">'${ub:i18n("MiscellaneousJobs")}'</span>
                    ${ub:i18n("CleanupMiscellaneousJobsDesc")}
                </div>
                <br/>
                <div style="text-align: left;">
                <span class="bold">'${ub:i18n("CleanupBuildRequestsNoBuildLives")}'</span>
                    ${ub:i18n("CleanupBuildRequestsNoBuildLivesDesc")}
                </div>
            </td>
            <td style="border: none;" width="2%">&nbsp;</td>
            <td width="59%" style="padding: 10px 20px;">
                <div style="text-align: left;">
                  <span class="bold">${ub:i18n("CleanupBuildLives")}</span>
                </div>
                <br/>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>${ub:i18n("Edit")}</th>
                            <th>${ub:i18n("CleanupBuildLivesStatus")}</th>
                            <th>${ub:i18n("KeepDays")}</th>
                            <th>${ub:i18n("KeepLatest")}</th>
                            <th>${ub:i18n("Type")}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="odd">
                          <c:url var="editBuildLivesUrl" value="${CleanupTasks.editCleanupBuildLivesPopup}"/>
                          <td align="center">
                            <ucf:link onclick="showPopup('${ah3:escapeJs(editBuildLivesUrl)}');return false;"
                                label="${ub:i18n('Edit')}" img="${fn:escapeXml(imgUrl)}/icon_pencil_edit.gif"
                                href="#" enabled="${inViewMode}"/></td>
                          <td>${ub:i18n("AllBuildLives")}</td>
                          <td align="center">
                            <c:choose>
                              <c:when test="${cleanupConfig.baseExpiration == MAX_INTEGER}">
                                <c:set var="noCleanupCanOccur" value="true"/>
                                ${ub:i18n("CleanupForever")}
                              </c:when>
                              <c:otherwise>
                                ${fn:escapeXml(cleanupConfig.baseExpiration)}
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td align="center">
                            <c:choose>
                              <c:when test="${cleanupConfig.baseMinKeep == MAX_INTEGER}">
                                <c:set var="noCleanupCanOccur" value="true"/>
                                ${ub:i18n("CleanupForever")}
                              </c:when>
                              <c:otherwise>
                                ${fn:escapeXml(cleanupConfig.baseMinKeep)}
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td align="center">
                            ${fn:escapeXml(ub:i18n(cleanupConfig.baseCleanupType.name))}
                          </td>
                        </tr>
                        <tr class="odd">
                          <c:url var="editBuildLivesUrl" value="${CleanupTasks.editCleanupBuildLivesPopup}">
                            <c:param name="deactiveSettings" value="true"/>
                          </c:url>
                          <td align="center">
                            <ucf:link onclick="showPopup('${ah3:escapeJs(editBuildLivesUrl)}');return false;"
                                label="${ub:i18n('Edit')}" img="${fn:escapeXml(imgUrl)}/icon_pencil_edit.gif"
                                href="#" enabled="${inViewMode}"/></td>
                          <td>${ub:i18n("DeactivatedBuildLives")}</td>
                          <td align="center">
                            <c:choose>
                              <c:when test="${cleanupConfig.deactiveExpiration == MAX_INTEGER}">
                                ${ub:i18n("CleanupForever")}
                              </c:when>
                              <c:otherwise>
                                ${fn:escapeXml(cleanupConfig.deactiveExpiration)}
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td align="center">
                            <c:choose>
                              <c:when test="${cleanupConfig.deactiveMinKeep == MAX_INTEGER}">
                                ${ub:i18n("CleanupForever")}
                              </c:when>
                              <c:otherwise>
                                ${fn:escapeXml(cleanupConfig.deactiveMinKeep)}
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td align="center">
                              ${ub:i18n(fn:escapeXml(cleanupConfig.deactiveCleanupType.name))}
                          </td>
                        </tr>
                        <c:forEach var="status" varStatus="loopStatus" items="${statusList}">
                        <c:url var="editBuildLivesUrl" value="${CleanupTasks.editCleanupBuildLivesPopup}">
                            <c:param name="${WebConstants.STATUS_ID}" value="${status.id}"/>
                        </c:url>
                        <%
                        CleanupConfig cleanupConfig = (CleanupConfig)pageContext.findAttribute("cleanupConfig");
                        Status status = (Status)pageContext.findAttribute("status");
                        Integer exp = new Integer( cleanupConfig.getStatusExpiration( status ) );
                        pageContext.setAttribute("expirationValue", exp);
                        pageContext.setAttribute("minKeep", new Integer(cleanupConfig.getStatusMinKeep(status)));
                        pageContext.setAttribute("cleanupType", cleanupConfig.getStatusCleanupType(status).getName());
                        %>
                        <tr class="odd">
                            <td align="center">
                              <ucf:link onclick="showPopup('${ah3:escapeJs(editBuildLivesUrl)}');return false;"
                                label="${ub:i18n('Edit')}" img="${fn:escapeXml(imgUrl)}/icon_pencil_edit.gif"
                                href="#" enabled="${inViewMode}"/></td>
                            <td><c:out value="${ub:i18n(status.name)}"/></td>
                            <td align="center">
                              <c:choose>
                                <c:when test="${expirationValue == MAX_INTEGER}">
                                  ${ub:i18n("CleanupForever")}
                                </c:when>
                                <c:otherwise>
                                  ${fn:escapeXml(expirationValue)}
                                </c:otherwise>
                              </c:choose>
                            </td>
                            <td align="center">
                                <c:choose>
                                <c:when test="${minKeep == MAX_INTEGER}">
                                ${ub:i18n("Never")}
                                </c:when>
                                <c:otherwise>
                                ${fn:escapeXml(minKeep)}
                                </c:otherwise>
                                </c:choose>
                            </td>
                            <td align="center">${ub:i18n(fn:escapeXml(cleanupType))}</td>
                          </tr>
                          </c:forEach>
                        </tbody>
                    </table>
                    <br/>
                    <div style="text-align: left;">
                      <div>${ub:i18n("CleanupBuildLivesDesc")}</div>
                      <br/>
                      <div>${ub:i18n("CleanupKeepDesc")}</div>
                      <br/>
                      <div><span class="bold">${ub:i18n("Delete")}</span> - ${ub:i18n("CleanupDeleteDesc")}</div>
                      <br/>
                      <div><span class="bold">${ub:i18n("Deactivate and Delete Logs")}</span> - ${ub:i18n("CleanupDeactivateAndDeleteLogsDesc")}</div>
                      <br/>
                      <div><span class="bold">${ub:i18n("Inactivate")}</span> - ${ub:i18n("CleanupInactivateDesc")}</div>
                      <br/>
                      <div><span class="bold">${ub:i18n("Archive")}</span> - ${ub:i18n("CleanupArchiveDesc")}</div>
                      <c:if test="${noCleanupCanOccur}">
                        <br/>
                        <div><span class="error">*** ${ub:i18n("CleanupNoCleanupOccurMessage")}</span></div>
                      </c:if>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
      <br/><br/>
    </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
