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

<%@ page import="com.urbancode.codestation2.domain.project.CodestationProject" %>
<%@ page import="com.urbancode.ubuild.web.WebConstants" %>
<%@ page import="com.urbancode.ubuild.domain.security.UBuildAction" %>
<%@ page import="com.urbancode.ubuild.domain.security.Authority" %>

<%@taglib prefix="c"     uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"    uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<c:choose>
    <c:when test='${fn:escapeXml(mode) == "edit"}'>
      <c:set var="inEditMode" value="true"/>
      <c:set var="fieldAttributes" value=""/>
    </c:when>
    <c:otherwise>
      <c:set var="inViewMode" value="true"/>
      <c:set var="fieldAttributes" value="disabled class='inputdisabled'"/>
    </c:otherwise>
</c:choose>

<auth:check persistent="${WebConstants.CODESTATION_PROJECT}" var="canWrite" action="${UBuildAction.CODESTATION_EDIT}"/>

<jsp:include page="/WEB-INF/jsps/codestation2/codestationTabs.jsp">
  <jsp:param name="disabled" value="${inEditMode}"/>
  <jsp:param name="selected" value="property"/>
</jsp:include>

        <div class="system-helpbox">${ub:i18n('AddCodeStationPropertiesHelp')}</div>
        <br/>
        <br/>

        <c:import url="property/propertyList.jsp">
          <c:param name="canWrite" value="${canWrite}"/>
        </c:import>

        <br/>

        <c:if test="${csProjectProp != null}">
          <hr size="1"/>
          <c:import url="property/property.jsp"></c:import>
        </c:if>
        <br/>
  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
