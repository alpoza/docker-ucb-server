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
<%@page import="com.urbancode.ubuild.web.*"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@page import="com.urbancode.codestation2.domain.project.*"%>
<%@page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@page import="com.urbancode.ubuild.domain.security.Authority" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="${taskClass}" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<c:url var="saveUrl" value="${CodestationTasks.saveCodestationProject}"/>
<c:url var="editUrl" value="${CodestationTasks.editCodestationProject}">
  <c:param name="${WebConstants.CODESTATION_PROJECT_ID}" value="${codestationProject.id}"/>
</c:url>
<c:url var="cancelUrl" value="${CodestationTasks.cancelCodestationProject}"/>
<c:url var="viewUrl" value="${CodestationTasks.viewCodestationProject}"/>
<c:url var="doneUrl" value="${CodestationTasks.viewList}"/>

<auth:check persistent="${WebConstants.CODESTATION_PROJECT}" var="canWrite" action="${UBuildAction.CODESTATION_EDIT}" resultWhenNotFound="true"/>

<% EvenOdd eo = new EvenOdd(); %>

<jsp:include page="/WEB-INF/jsps/codestation2/codestationTabs.jsp">
  <jsp:param name="disabled" value="${inEditMode}"/>
  <jsp:param name="selected" value="main"/>
</jsp:include>

        <div class="system-helpbox">${ub:i18n("CodeStationProjectHelp")}</div><br />
        <c:if test="${!empty migrationError}"><br/><br/><pre class="error">${fn:escapeXml(migrationError)}</pre></c:if>
        <c:remove scope="session" var="migrationError"/>

        <div align="right">
          <span class="required-text">${ub:i18n("RequiredField")}</span>
        </div>

        <form method="post" action="${fn:escapeXml(saveUrl)}">
          <table class="property-table">

            <tbody>

              <c:set var="fieldName" value="${WebConstants.NAME}"/>
              <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : codestationProject.name}"/>
              <error:field-error field="${WebConstants.NAME}" cssClass="<%=eo.getNext() %>"/>
              <tr class="<%=eo.getLast() %>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>

                <td align="left" colspan="2">
                  <ucf:text name="${WebConstants.NAME}" value="${nameValue}" enabled="${inEditMode}" size="60"/>
                </td>
              </tr>

              <c:set var="fieldName" value="${WebConstants.DESCRIPTION}"/>
              <c:set var="descriptionValue" value="${param[fieldName] != null ? param[fieldName] : codestationProject.description}"/>
              <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="<%=eo.getNext() %>"/>
              <tr class="<%=eo.getLast() %>" valign="top">
                <td align="left" width="20%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>

                <td align="left" colspan="2">
                  <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${descriptionValue}"
                                enabled="${inEditMode}"/>
                </td>

              </tr>
              
              <c:import url="/WEB-INF/snippets/admin/security/newSecuredObjectSecurityFields.jsp"/>

              <tr>
                <td colspan="3">
                  <c:choose>
                    <c:when test="${!canWrite}">
                      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
                    </c:when>
                    <c:when test="${inEditMode}">
                      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
                      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${cancelUrl}"/>
                    </c:when>
                    <c:when test="${inViewMode}">
                      <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}"/>
                      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${doneUrl}"/>
                    </c:when>
                  </c:choose>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
        <br/>
        <br/>

        <c:if test="${errors != null}">
          <table>
            <error:field-error field="${WebConstants.CODESTATION_BUILD_LIFE_ID}" cssClass="<%=eo.getNext() %>"/>
          </table>
        </c:if>
        <c:import url="buildlife/list.jsp">
          <c:param name="enabled" value="${inViewMode}"/>
          <c:param name="canWrite" value="${canWrite}"/>
        </c:import>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
