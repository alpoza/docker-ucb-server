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
<%@page import="java.util.*" %>
<%@page import="com.urbancode.ubuild.domain.plugin.*" %>
<%@page import="com.urbancode.ubuild.domain.property.*" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd" %>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="error" prefix="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.plugin.automation.AutomationPluginTasks" />


<%-- URLs --%>
<c:url var="viewListUrl" value="${AutomationPluginTasks.viewPluginList}">
  <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
</c:url>

<c:url var='savePluginUrl' value='${AutomationPluginTasks.savePluginAjax}'>
  <c:param name="${WebConstants.PROP_SHEET_ID}" value="${propSheet.id}"/>
  <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
</c:url>
<c:url var="viewPluginUrl" value="${AutomationPluginTasks.viewPlugin}">
  <c:param name="${WebConstants.PROP_SHEET_ID}" value="${propSheet.id}"/>
  <c:param name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
</c:url>

<%
    pageContext.setAttribute("eo", new EvenOdd());
%>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemIntegrations')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${false}"/>
</jsp:include>

<script type="text/javascript">
  /* <![CDATA[ */

  Element.observe(window, 'load', function(event) {

      new UC_PVGForm('integrationPropForm', {
          'onCancelNew': function(){
                goTo('${ah3:escapeJs(viewListUrl)}');
           }
      });

      <c:if test="${!empty saveMessage}">
          setTimeout('$("saveMessage").remove()', 5000);
      </c:if>
  });

  /* ]]> */
</script>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <c:set var="propSheetName" value="${ub:i18nMessage('PluginPropSheetNewPlugin', plugin.name)}"/>
    <ucf:link href="${viewPluginUrl}" label="${not empty propSheet ? propSheet.name : propSheetName}" enabled="${false}" klass="selected tab "/>
  </div>

  <div class="contents">

    <c:set var="description" value="${propSheet.propSheetDef.description}"/>
    <c:if test="${empty description}">
      <c:set var="description" value="${plugin.description}"/>
    </c:if>

    <c:if test="${!empty description}">
      <div class="system-helpbox" style="margin-bottom: 1em">${fn:escapeXml(ub:i18n(description))}</div>
    </c:if>

    <form id="integrationPropForm" onsubmit="return false" action="${ah3:escapeJs(savePluginUrl)}" method="post">
       <c:if test="${empty propSheet}">
            <ucf:hidden name="${WebConstants.IS_NEW}" value="true"/>
       </c:if>

       <c:if test="${!empty saveMessage}">
         <div style="color: green; margin-bottom: 10px" id="saveMessage">${fn:escapeXml(saveMessage)}</div>
         <c:remove var="saveMessage" scope="session"/>
       </c:if>
       <div class="formError" style="display:none; color: red; margin-bottom: 10px"></div>

       <div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
       <table class="property-table" style="margin-top: 10px">
         <tbody>
           <error:field-error field="name" cssClass="${eo.next}"/>
           <tr class="${eo.last}">
             <td style="width:20%">
               <span class="bold">${ub:i18n("NameWithColon")}&nbsp;<span class="required-text">*</span></span>
             </td>
             <td style="width:20%">
               <ucf:text name="name" value="${propSheet.name}" enabled="${true}" required="${true}"/>
             </td>
             <td><span class="inlinehelp"></span></td>
           </tr>

           <c:forEach var="propDef" items="${propSheetDef.propDefList}">
             <c:if test="${not propDef.hidden}">
               <c:set var="type" value="${fn:toLowerCase(propDef.type)}"/>
               <c:set var="key" value="${propDef.name}"/>
               <c:set var="customValue" value="${empty propLookup[key] ? propDef.defaultValue : propLookup[key]}"/>

               <error:field-error field="property:${key}" cssClass="${eo.next}"/>
               <tr class="${eo.last}">
                 <td style="width:20%">
                   <span class="bold">
                     <c:choose>
                       <c:when test="${not empty propDef.label}">
                         ${ub:i18nMessage('NounWithColon', ub:i18n(propDef.label))}
                       </c:when>
                       <c:otherwise>
                         ${ub:i18nMessage('NounWithColon', propDef.name)}
                       </c:otherwise>
                     </c:choose>
                     <c:if test="${propDef.required}">&nbsp;<span class="required-text">*</span></c:if>
                   </span>
                 </td>
                <c:choose>
                  <c:when test="${type == 'textarea'}">
                    <td colspan="2">
                      <span class="inlinehelp">${fn:escapeXml(ub:i18n(propDef.description))}</span><br/>
                      <ucf:propertyDefinitionField propertyDefinition="${propDef}" customValue="${customValue}" fieldPrefix="property" />
                    </td>
                  </c:when>
                  <c:otherwise>
                    <td style="width:20%">
                      <ucf:propertyDefinitionField propertyDefinition="${propDef}" customValue="${customValue}" fieldPrefix="property" />
                    </td>
                    <td><span class="inlinehelp">${fn:escapeXml(ub:i18n(propDef.description))}</span></td>
                  </c:otherwise>
                </c:choose>
               </tr>

               <c:remove var="type"/>
               <c:remove var="key"/>
               <c:remove var="customValue"/>
             </c:if>
           </c:forEach>
         </tbody>
       </table>

       <div style="margin-top: 10px; <c:if test="${!empty propSheet}">display: none;</c:if>" class="editButtons">
         <ucf:button name="Save" label="${ub:i18n('Save')}" submit="${true}"/>
         <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}"/>
       </div>
       <div style="margin-top: 10px; <c:if test="${empty propSheet}">display: none;</c:if>" class="doneButtons">
         <ucf:button name="Done" label="${ub:i18n('Done')}" submit="${false}" href="${viewListUrl}"/>
       </div>
     </form>

     </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
