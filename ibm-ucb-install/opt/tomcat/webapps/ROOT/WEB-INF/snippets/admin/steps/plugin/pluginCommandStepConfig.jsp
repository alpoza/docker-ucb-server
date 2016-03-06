<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="error"  prefix="error" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useConstants class="com.urbancode.ubuild.web.util.SnippetBase" />


<c:set var="inEditMode" value="${mode == 'edit'}"/>
<c:set var="inViewMode" value="${!inEditMode}"/>
<c:set var="pluginCommand" value="${empty pluginCommand ? stepConfig.pluginCommand : pluginCommand}"/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>


<%-- CONTENT --%>
<script type="text/javascript">
  var StepTypeStepConfigProperties = {
      hideModuleProps: function(pluginSection){
         pluginSection = $(pluginSection);
         var heading = pluginSection.down('.component-heading');
         heading.down().show(); // show '+'
         heading.down().next().hide(); // hide '-'
         // update onclick action
         heading.onclick = function(){StepTypeStepConfigProperties.showModuleProps(pluginSection);};

         var description = pluginSection.down('.plugin-description');
         if (description != null) {
             description.hide();
         }

         pluginSection.down('*[id^=PropertyTable]').hide();
      },

      showModuleProps: function(pluginSection){
         pluginSection = $(pluginSection);
         var heading = pluginSection.down('.component-heading');
         heading.down().hide(); // hide '+'
         heading.down().next().show(); // show '-'
         // update onclick action
         heading.onclick = function(){StepTypeStepConfigProperties.hideModuleProps(pluginSection);};

         var description = pluginSection.down('.plugin-description');
         if (description != null) {
             description.show();
         }

         pluginSection.down('*[id^=PropertyTable]').show();
      }

  }

</script>

<div class="snippet_form">

  <input type="hidden" name="${WebConstants.PLUGIN_COMMAND_ID}" value="${pluginCommand.id}">
  <input type="hidden" name="${SnippetBase.SNIPPET_METHOD}" value="saveMainTab">

  <div class="system-helpbox">
    <c:choose>
      <c:when test="${!empty pluginCommand.description}">
        ${fn:escapeXml(ub:i18n(pluginCommand.description))}
      </c:when>
      <c:otherwise>
        ${ub:i18nMessage("ConfigureTheStep", fn:escapeXml(ub:i18n(pluginCommand.name)))}
      </c:otherwise>
    </c:choose>
  </div>
  <br/>

  <div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
  <table class="property-table" border="0" style="margin-bottom: 8px">
    <tbody>
      <c:set var="fieldName" value="${WebConstants.NAME}"/>
      <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
      <tr class="${eo.last}">
        <td align="left" width="20%">
          <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
        </td>
        <td align="left" width="20%">
          <c:set var="nameValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.name}"/>
          <ucf:text name="${WebConstants.NAME}" value="${nameValue}" enabled="${inEditMode}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("StepNameDesc")}</span>
        </td>
      </tr>

      <c:set var="fieldName" value="${WebConstants.DESCRIPTION}"/>
      <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
      <tr class="${eo.last}">
        <td align="left" width="20%">
          <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
        </td>
        <td align="left" colspan="2">
          <c:set var="descriptionValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.description}"/>
          <ucf:textarea name="${WebConstants.DESCRIPTION}" value="${descriptionValue}" enabled="${inEditMode}"/>
        </td>
      </tr>

      <c:set var="fieldName" value="workDirOffset"/>
      <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
      <tr class="${eo.last}">
        <td align="left" width="20%"><span class="bold">${ub:i18n("WorkDirOffset")} </span></td>
        <td align="left" width="20%">
          <c:set var="offsetValue" value="${not empty param[fieldName] ? param[fieldName] : stepConfig.workDirOffset}"/>
          <ucf:text name="workDirOffset" value="${offsetValue}" enabled="${inEditMode}"/>
        </td>
        <td align="left">
          <span class="inlinehelp">${ub:i18n("WorkDirOffsetDesc")}</span>
        </td>
      </tr>
    </tbody>

    <c:set var="propMap" value="${stepConfig.propSheet.propMap}"/>
    <c:if test="${!empty pluginCommand.propSheetDef}">
      <tbody>
      <c:forEach var="propDef" items="${pluginCommand.propSheetDef.propDefList}">
         <c:if test="${not propDef.hidden}">
           <c:set var="type" value="${fn:toLowerCase(propDef.type)}"/>
           <c:set var="key" value="${propDef.name}"/>
           <c:set var="fieldName" value="property:${key}"/>
           <c:set var="customValue" value="${empty propMap[key] ? propDef.defaultValue : propMap[key]}"/>
           <c:set var="customValue" value="${param[fieldName] != null ? param[fieldName] : customValue}"/>

           <error:field-error field="${fieldName}" cssClass="${eo.next}"/>
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
              <c:when test="${propDef.name == 'urbancodeReportName'}">
                <td style="width:20%">
                  <c:url var="reportsUrl" value="/rest2/reporting/reports"/>
                  <c:url var="queryUrl" value="/rest2/reporting/query"/>
                  <script type="text/javascript">
                    /* <![CDATA[ */
                    var reportBuilderOptions = {
                      reportsUrl : '${ah3:escapeJs(reportsUrl)}',
                      queryUrl : '${ah3:escapeJs(queryUrl)}',
                      paramNamePrefix : 'property:params/'
                    }
                    var reportMap = [];
                    var reportBuilder = new UC_REPORT_BUILDER(reportBuilderOptions);
                    jQuery(document).ready(function() {
                        reportBuilder.getAllSavedReports(function(reports) {
                            var reportSelect = jQuery('select[name="property:urbancodeReportName"]');
                            var options;
                            if (reportSelect.prop) {
                                options = reportSelect.prop('options');
                            }
                            else {
                                options = reportSelect.attr('options');
                            }
                            jQuery('option', reportSelect).remove();
                            jQuery.each(reports, function(index, report) {
                                reportMap[report.name] = report;
                                options[options.length] = new Option(report.name, report.name);
                            });
                            jQuery(reportSelect).change(function(e) {
                                e.preventDefault();
                                var reportName = e.currentTarget.value;
                                var report = reportMap[reportName];
                                reportBuilder.drawParameters(report.query);
                            });
                            var reportName = '${ah3:escapeJs(customValue)}';
                            jQuery(reportSelect).val(reportName);
                            var report = reportMap[reportName];
                            var paramValues = [];
                            <c:forEach var="existingPropValue" items="${stepConfig.propSheet.propValueList}">
                              <c:if test="${fn:startsWith(existingPropValue.name, 'params/')}">
                                <c:set var="paramName" value="${fn:substringAfter(existingPropValue.name, 'params/')}"/>
                            paramValues['${ah3:escapeJs(paramName)}'] = '${ah3:escapeJs(existingPropValue.value)}';
                              </c:if>
                            </c:forEach>
                            reportBuilder.drawParameters(report.query, paramValues);
                        });
                    });
                    /* ]]> */
                  </script>
                  <select name="property:${propDef.name}" required="${propDef.required}" enabled="${inEditMode}">
                  </select>
                </td>
                <td><span class="inlinehelp">${fn:escapeXml(ub:i18n(propDef.description))}</span></td>
                </tr>
                <tr>
                  <td><span class="bold">${ub:i18n("PluginCommandStepConfigReportParameters")}</span></td>
                  <td colspan="2"><div id="paramContainer">&nbsp;</div></td>
              </c:when>
              <c:when test="${type == 'textarea'}">
                <td colspan="2">
                  <span class="inlinehelp">${fn:escapeXml(ub:i18n(propDef.description))}</span><br/>
                  <ucf:propertyDefinitionField propertyDefinition="${propDef}" customValue="${customValue}" fieldPrefix="property" enabled="${inEditMode}" />
                </td>
              </c:when>
              <c:otherwise>
                <td style="width:20%">
                  <ucf:propertyDefinitionField propertyDefinition="${propDef}" customValue="${customValue}" fieldPrefix="property" enabled="${inEditMode}" />
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
    </c:if>

    <%-- Native Environment Variables --%>
    <tbody>
      <tr class="${eo.next}">
        <td width="20%" colspan="3">
          <a id="showEnvVars" onclick="$(this).hide(); $(this).next().show(); $(this).up('tr').next().show(); return false;" href="#">
            <img border="0" src="<c:url value="/images/plus.gif"/>" alt="" style="vertical-align: middle;">${ub:i18n("ShowEnvVars")}
          </a>
          <a id="hideEnvVars" style="display:none" onclick="$(this).hide(); $(this).previous().show(); $(this).up('tr').next().hide(); return false;" href="#">
            <img border="0" src="<c:url value="/images/minus.gif"/>" alt="" style="vertical-align: middle;">${ub:i18n("HideEnvVars")}
          </a>
        </td>
      </tr>
      <tr class="${eo.last}" style="display: none">
        <td width="20%">
          <span class="bold">${ub:i18n("EnvVarsWithColon")}</span>
        </td>
        <td colspan="2">
          <ucf:textarea name="env-vars"
                        cols="60"
                        rows="6"
                        enabled="${inEditMode}"
                        value="${stepConfig.environmentVariablesString}"/>

          <div class="inlinehelp">
            ${ub:i18n("EnvVarsDesc")}
          </div>
        </td>
      </tr>
    </tbody>

    <%-- Advanced Step Config Attributes --%>
    <tbody>
      <tr class="${eo.next}">
        <td colspan="3">
          <jsp:include page="/WEB-INF/snippets/admin/steps/snippet-step-advanced.jsp">
            <jsp:param name="editUrl" value="${param.editUrl}"/>
            <jsp:param name="showAdvanced" value="${param.showAdvanced}"/>
          </jsp:include>
        </td>
      </tr>
    </tbody>
  </table>


  <c:if test="${inEditMode}">
    <ucf:button name="Save" label="${ub:i18n('Save')}"/>
    <ucf:button href='${param.cancelUrl}' name="Cancel" label="${ub:i18n('Cancel')}"/>
  </c:if>
  <c:if test="${inViewMode}">
    <ucf:button href="${param.cancelUrl}" name="Done" label="${ub:i18n('Done')}"/>
  </c:if>
</div>
