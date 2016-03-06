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

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.plugin.PluginTasks" />

<%-- CONTENT --%>

<c:set var="headContent" scope="request">
  <style type="text/css">
    .deleteSection {
      margin: 0.5em 0em
    }
  </style>
</c:set>
<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('SystemPlugin')}"/>
  <c:param name="selected" value="system"/>
  <c:param name="disabled" value="${inEditMode}"/>
</c:import>

  <div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('Main')}" href="#" enabled="${false}" klass="selected tab"/>
    </div>
 
    <div class="contents">
    
      <c:if test="${!empty error}">
        <div class="error">${fn:escapeXml(error)}</div>
      </c:if>
       
      <c:set var="inUse" value="${not empty stepList || not empty sourceConfigs || not empty repositories}"/>
      <c:if test="${inUse}">
        <div class="deleteSection">
          <div class="bold">${ub:i18n("PluginDeleteMessage")}</div>
          <div>
            <table class="layout_table">
              <tbody>
                <c:forEach var="step" items="${stepList}">
                  <tr>
                    <td>${ub:i18n("Step")} &#34;${fn:escapeXml(step.name)}&#34;</td>
                    <td>${ub:i18n("PluginInJob")} &#34;${fn:escapeXml(step.jobConfig.name)}&#34;</td>
                  </tr>
                </c:forEach>
                
                <c:forEach var="sourceConfig" items="${sourceConfigs}">
                  <tr>
                    <td>${ub:i18n("SourceConfig")} &#34;${fn:escapeXml(sourceConfig.name)}&#34;</td>
                    <td>${ub:i18n("PluginInProjectTemplate")} &#34;${fn:escapeXml(sourceConfig.name)}&#34;</td>
                  </tr>
                </c:forEach>
                
                <c:forEach var="repo" items="${repositories}">
                  <tr>
                    <td colspan="2">${ub:i18n("Repository")} &#34;${fn:escapeXml(repo.name)}&#34;</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </c:if>
        
      <c:if test="${not inUse}">
        <div class="deleteSection">${ub:i18n("PluginDeleteOkayMessage")}</div>
      </c:if>
      
      
      <c:choose>
        <c:when test="${plugin.class.simpleName == 'AutomationPlugin'}">
        </c:when>
        <c:when test="${plugin.class.simpleName == 'SourcePlugin'}">
          <div></div>
        </c:when>
        <c:otherwise>
          <%-- unknown type --%>
        </c:otherwise>
      </c:choose>
     
      <hr/>

      <c:url var="acceptUrl" value="${PluginTasks.confirmDeletePlugin}">
        <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
      </c:url>
      <ucf:button name="ConfirmDelete" label="${ub:i18n('PluginConfirmDelete')}" href="${acceptUrl}" submit="${false}" enabled="${not inUse}"/>
      <c:url var="viewPluginListUrl" value="${PluginTasks.viewPluginList}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${viewPluginListUrl}" submit="${false}"/>
    </div>
  </div>

<c:import url="/WEB-INF/snippets/footer.jsp"/>
