<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.domain.agentfilter.AgentFilter"%>
<%@page import="com.urbancode.ubuild.domain.agentfilter.agentpool.AgentPoolFilter"%>
<%@page import="com.urbancode.ubuild.domain.jobconfig.JobConfig"%>
<%@page import="com.urbancode.ubuild.domain.jobconfig.JobConfigFactory"%>
<%@page import="com.urbancode.ubuild.domain.project.template.ProjectTemplateProperty"%>
<%@page import="com.urbancode.ubuild.domain.property.PropertyInterfaceTypeEnum"%>
<%@page import="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="uiA" tagdir="/WEB-INF/tags/ui/admin/agentPool" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" />
<ah3:useTasks id="ProjectTemplateTasksNoConversation" class="com.urbancode.ubuild.web.admin.project.template.ProjectTemplateTasks" useConversation="false" />

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}" />
<c:set var="inViewMode" value="${!inEditMode}" />

<c:url var="saveUrl" value="${ProjectTemplateTasks.saveProperty}" />
<c:url var="cancelUrl" value="${ProjectTemplateTasks.cancelProperty}">
  <c:if test="${param.projectTemplatePropSeq != null}">
    <c:param name="projectTemplatePropSeq" value="${param.projectTemplatePropSeq}" />
  </c:if>
</c:url>

<c:url var="editUrl" value="${ProjectTemplateTasksNoConversation.editProperty}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}" />
  <c:if test="${param.projectTemplatePropSeq != null}">
    <c:param name="projectTemplatePropSeq" value="${param.projectTemplatePropSeq}" />
  </c:if>
</c:url>

<c:url var="viewUrl" value="${ProjectTemplateTasks.viewProperty}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}" />
</c:url>

<c:url var="viewListUrl" value="${ProjectTemplateTasks.viewPropertyList}">
  <c:param name="${WebConstants.PROJECT_TEMPLATE_ID}" value="${projectTemplate.id}" />
</c:url>

<jsp:useBean id="eo" class="com.urbancode.ubuild.web.util.EvenOdd" />

<%-- CONTENT --%>

<%
    List<PropertyInterfaceTypeEnum> enumList = PropertyInterfaceTypeEnum.getEnumList();
    Collections.sort(enumList);
    pageContext.setAttribute("enumList", enumList);
    pageContext.setAttribute("newline", "\n");

    ProjectTemplateProperty projectTemplateProp = (ProjectTemplateProperty) pageContext.findAttribute("projectTemplateProp");
    if (projectTemplateProp != null) {
        pageContext.setAttribute("inputPropString", StringUtils.join(projectTemplateProp.getInputProperties(), "\n"));
        pageContext.setAttribute("agentFilter", projectTemplateProp.getJobExecutionAgentFilter());

        pageContext.setAttribute("isDefinedProp",projectTemplateProp.isDefinedValue());
    }
%>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />


<script type="text/javascript">
    var textType = <%= PropertyInterfaceTypeEnum.TEXT.getId() %>;
    var textAreaType = <%= PropertyInterfaceTypeEnum.TEXT_AREA.getId() %>;
    var textSecureType = <%= PropertyInterfaceTypeEnum.TEXT_SECURE.getId() %>;
    var checkboxType = <%= PropertyInterfaceTypeEnum.CHECKBOX.getId() %>;
    var selectType = <%= PropertyInterfaceTypeEnum.SELECT.getId() %>;
    var multiSelectType = <%= PropertyInterfaceTypeEnum.MULTI_SELECT.getId() %>;
    var pluginSelectType = <%= PropertyInterfaceTypeEnum.PLUGIN.getId() %>;
    var agentPoolType = <%= PropertyInterfaceTypeEnum.AGENT_POOL.getId() %>;

    var pluginMap = {};

    function updateFieldDisplay() {
        var propertyTypeId = Number($('propertyTypeSelect').value);

        $('checkboxFields').hide();
        $('multiSelectFields').hide();
        $('textAndSelectFields').hide();
        $('textAreaFields').hide();
        $('textSecureFields').hide();
        $('pluginTypeFields').hide();
        $('propertyGroupFields').hide();
        $('agentPoolFields').hide();

        if ($('definedValue').checked) {
            //console.log("change to " + propertyTypeId);
            $('scriptedValueFields').hide();
            $('jobValueFields').hide();
            if (propertyTypeId === checkboxType) {
                $('checkboxFields').show();
            } else if (propertyTypeId === textType
                    || propertyTypeId === selectType) {
                //console.log("showing textAndSelectFields");
                $('textAndSelectFields').show();
            } else if (propertyTypeId === multiSelectType) {
                $('multiSelectFields').show();
            } else if (propertyTypeId === textAreaType) {
                $('textAreaFields').show();
            } else if (propertyTypeId === textSecureType) {
                $('textSecureFields').show();
            } else if (propertyTypeId === pluginSelectType) {
                $('pluginTypeFields').show();
                $('propertyGroupFields').show();
            } else if (propertyTypeId === agentPoolType) {
                $('agentPoolFields').show();
            }

        } else if ($('scriptedValue').checked) {
            $('scriptedValueFields').show();
            $('jobValueFields').hide();
        } else if ($('jobValue').checked) {
            $('scriptedValueFields').hide();
            $('jobValueFields').show();
        }

        if (propertyTypeId === selectType || propertyTypeId === multiSelectType) {
            if ($('jobValue').checked) {
                $('allowedValuesScriptFields').hide();
                $('allowedValuesFields').hide();
            }
            else if ($('scriptedValue').checked) {
                $('allowedValuesScriptFields').show();
                $('allowedValuesFields').hide();
            } else {
                $('allowedValuesFields').show();
                $('allowedValuesScriptFields').hide();
            }
        }
        else {
            $('allowedValuesFields').hide();
            $('allowedValuesScriptFields').hide();
        }

        if (propertyTypeId === checkboxType) {
            $('valueRequiredFields').hide();
        }
        else {
            $('valueRequiredFields').show();
        }
    }

    function populatePluginTypeList() {
        var option = null;
        var list = new Array();

        // Create a default option
        var defaultOption = document.createElement("option");
        var makeSelection = i18n("MakeSelection");
        defaultOption.text = '-- ' + makeSelection + ' --';
        defaultOption.value = '';

        // Create a default empty list for when no plugin type is selected
        list.push(defaultOption.cloneNode(true));
        pluginMap[""] = list;

        // For each plugin type, create a list of property groups to select from
        <c:forEach var="entry" items="${pluginMap}">
            list = new Array();
            list.push(defaultOption.cloneNode(true));

            <c:forEach var="propSheet" items="${entry.value}">
                option = document.createElement("option");
                option.text = '${ah3:escapeJs(propSheet.name)}';
                option.value = '${ah3:escapeJs(propSheet.id)}';
                list.push(option);
            </c:forEach>
            pluginMap["${entry.key}"] = list;
        </c:forEach>
    }

    function initPluginList() {
        var pluginType = $('pluginTypeSelect');
        var selectedIndex = pluginType.selectedIndex;
        var selectedTypeId = selectedIndex == null ? null : pluginType.options[selectedIndex].value;

        var propertyGroupSelect = $('propertyGroupSelect');
        for (var oldOption in propertyGroupSelect.options) {
            propertyGroupSelect.remove(oldOption);
        }

        for (var i = 0; i < pluginMap[selectedTypeId].length; i++) {
            propertyGroupSelect.add(pluginMap[selectedTypeId][i], null);
        }

        var selectedValue = "${ah3:escapeJs(param['propertyGroupList'] != null ? param['propertyGroupList'] : projectTemplateProp.displayValue)}";
        propertyGroupSelect.value = selectedValue;
    }

    function updatePluginList() {
        initPluginList();
        var propertyGroupSelect = $('propertyGroupSelect');
        propertyGroupSelect.value = "";
    }

    Element.observe(window, 'load', function() {
       updateFieldDisplay();
       populatePluginTypeList();
       initPluginList();
    });
</script>

<a id="property"></a>

<div class="tab-content">

  <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>

  <div>${isSelect}</div>
  <div id="testDiv"></div>

  <form method="post" action="${fn:escapeXml(saveUrl)}#property">
    <c:if test="${param.projectTemplatePropSeq != null}">
      <input type="hidden" name="${WebConstants.PROJECT_TEMPLATE_PROP_SEQ}"
        value="${fn:escapeXml(param.projectTemplatePropSeq)}" />
    </c:if>

    <table class="property-table">
      <tbody>

        <c:set var="fieldName" value="${WebConstants.NAME}"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.name}"/>
        <error:field-error field="${WebConstants.NAME}" cssClass="${eo.next}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>

          <td width="15%"><ucf:text name="${WebConstants.NAME}" value="${value}"
              enabled="${inEditMode}" /></td>

          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyNameDesc")}</span></td>
        </tr>

        <c:set var="fieldName" value="label"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.label}"/>
        <error:field-error field="label" cssClass="${eo.next}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%"><span class="bold">${ub:i18n("LabelWithColon")} </span></td>

          <td width="15%"><ucf:text name="label" value="${value}" enabled="${inEditMode}" /></td>

          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyLabelDesc")}</span></td>
        </tr>

        <c:set var="fieldName" value="${WebConstants.DESCRIPTION}"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.description}"/>
        <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="${eo.next}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>

          <td colspan="2"><ucf:textarea name="${WebConstants.DESCRIPTION}"
              value="${value}" enabled="${inEditMode}" /></td>
        </tr>

        <c:set var="fieldName" value="${WebConstants.PROPERTY_TYPE}"/>
        <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : projectTemplateProp.interfaceType.id}"/>
        <error:field-error field="${WebConstants.PROPERTY_TYPE}" cssClass="${eo.next}" />
        <tr valign="top" class="${eo.last}">
          <td align="left" width="20%"><span class="bold">${ub:i18n("PropertyDisplayTypeWithColon")} <span
              class="required-text">*</span></span></td>
          <td align="left" width="20%"><ucf:idSelector name="${WebConstants.PROPERTY_TYPE}" id="propertyTypeSelect"
              list="${enumList}" selectedId="${value}" canUnselect="false"
              onChange="updateFieldDisplay();" /></td>
          <td align="left"><span class="inlinehelp">
              <span class="bold">${ub:i18n("Agent Pool")}</span>
              - ${ub:i18n("PropertyAgentPoolTypeDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Checkbox")}</span>
              - ${ub:i18n("PropertyCheckboxDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Integration Plugin")}</span>
              - ${ub:i18n("PropertyIntegrationPluginDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Multi-Select")}</span>
              - ${ub:i18n("PropertyMultiSelectDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Select")}</span>
              - ${ub:i18n("PropertySelectDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Text")}</span>
              - ${ub:i18n("PropertyTextDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Text (secure)")}</span>
              - ${ub:i18n("PropertyTextSecureDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Text Area")}</span>
              - ${ub:i18n("PropertyTextAreaDesc")}<br />
          </span></td>
        </tr>

        <error:field-error field="${WebConstants.PLUGIN_LIST}" cssClass="${eo.next}" />
        <tbody id="pluginTypeFields">
          <c:set var="fieldName" value="pluginTypeList"/>
          <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.pluginType}"/>
          <tr class="${fn:escapeXml(eo.last)}">
            <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PluginTypeWithColon")} </span></td>

            <td width="15%" style="border-top: 0px;">
              <ucf:idSelector list="${pluginTypeList}"
                              id="pluginTypeSelect"
                              selectedId="${value}"
                              name="pluginTypeList"
                              canUnselect="false"
                              onChange="updatePluginList();"/>
            </td>

            <td align="left" style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyPluginTypeDesc")}</span></td>
          </tr>
        </tbody>

        <tr class="${fn:escapeXml(eo.next)}">
          <td width="15%" style="border-bottom: 0px;"><span class="bold">${ub:i18n("ValueWithColon")} </span></td>

          <td colspan="2" style="border-bottom: 0px;">
            <div id="definedValueDiv"
             class="propertyValueType">

              <c:set var="fieldName" value="valueSource"/>
              <c:choose>
                <c:when test="${not empty param[fieldName]}">
                  <c:if test="${param[fieldName] == 'defined'}">
                    <c:set var="defined" value="true"/>
                  </c:if>
                  <c:if test="${param[fieldName] == 'scripted'}">
                    <c:set var="scripted" value="true"/>
                  </c:if>
                  <c:if test="${param[fieldName] == 'job'}">
                    <c:set var="job" value="true"/>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <c:if test="${!projectTemplateProp.scriptedValue}">
                    <c:set var="defined" value="true"/>
                  </c:if>
                  <c:if test="${projectTemplateProp.scriptedValue}">
                    <c:set var="scripted" value="true"/>
                  </c:if>
                  <c:if test="${projectTemplateProp.jobExecutionValue}">
                    <c:set var="job" value="true"/>
                  </c:if>
                </c:otherwise>
              </c:choose>

              <div style="float: left;">
                <input type="radio" id="definedValue" name="valueSource" value="defined" class="radio"
                  <c:if test="${defined}">checked=""</c:if> onclick="updateFieldDisplay();" />
              </div>
              <div style="position: absolute; margin-left: 25px;">
                <span class="bold">${ub:i18n("PropertyDefined")}</span>
              </div>
              <br />
              <div style="margin-top: 5px; margin-left: 25px;">${ub:i18n("PropertyDefinedDesc")}</div>
            </div>
            <div id="scriptedValueDiv"
              class="propertyValueType">
              <div style="float: left;">
                <input type="radio" id="scriptedValue" name="valueSource" value="scripted" class="radio"
                  <c:if test="${scripted}">checked=""</c:if> onclick="updateFieldDisplay();" />
              </div>
              <div style="position: absolute; margin-left: 25px;">
                <span class="bold">${ub:i18n("Scripted")}</span>
              </div>
              <br />
              <div style="margin-top: 5px; margin-left: 25px;">${ub:i18n("PropertyScriptedDesc")}</div>
            </div>
            <div id="jobValueDiv"
              class="propertyValueType">
              <div style="float: left;">
                <input type="radio" id="jobValue" name="valueSource" value="job" class="radio"
                  <c:if test="${job}">checked=""</c:if>
                  onclick="updateFieldDisplay();" />
              </div>
              <div style="position: absolute; margin-left: 25px;">
                <span class="bold">${ub:i18n("JobExecution")}</span>
              </div>
              <br />
              <div style="margin-top: 5px; margin-left: 25px;">${ub:i18n("PropertyJobExecutionDesc")}</div>
            </div>
          </td>

        </tr>
      </tbody>

      <tbody id="valueRequiredFields" ${projectTemplateProp.interfaceType.checkbox ? 'style="display:none;"' : ''}>
        <c:set var="fieldName" value="isRequired"/>
        <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : projectTemplateProp.required}"/>
        <error:field-error field="isRequired" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyValueRequiredWithColon")} </span></td>

          <td width="15%" style="border-top: 0px;"><input type="checkbox" class="checkbox" name="isRequired" value="true"<c:if test="${value}">checked="checked"</c:if>>
          </td>

          <td align="left" style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyValueRequiredDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="isSelect"
        value="${projectTemplateProp.interfaceType.select or projectTemplateProp.interfaceType.multiSelect}" />
      <c:set var="hideAllowedValues"
        value="${!isSelect or projectTemplateProp.scriptedValue or projectTemplateProp.jobExecutionValue}" />

      <tbody id="allowedValuesFields" <c:if test="${hideAllowedValues}">style="display:none;"</c:if>>
        <c:set var="fieldName" value="allowedValues"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.allowedValues}"/>
        <error:field-error field="allowedValues" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("AllowedValuesWithColon")} <span
              class="required-text">*</span></span></td>

          <td colspan="2" style="border-top: 0px;"><c:remove var="allowedValuesString" /> <c:forEach var="allowedValue"
              items="${value}">
              <c:if test="${not empty allowedValuesString}">
                <c:set var="allowedValuesString" value="${allowedValuesString}${newline}" />
              </c:if>

              <c:set var="allowedValuesString" value="${allowedValuesString}${allowedValue}" />
            </c:forEach> <ucf:textarea name="allowedValues" value="${allowedValuesString}" cols="60" rows="5"
              enabled="${inEditMode}" /><br /> <span class="inlinehelp">${ub:i18n("PropertyAllowedValuesDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="hideAllowedValuesScript" value="${!isSelect and not projectTemplateProp.scriptedValue}" />
      <tbody id="allowedValuesScriptFields" <c:if test="${hideAllowedValuesScript}">style="display:none;"</c:if>>
        <error:field-error field="allowedValuesScript" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyAllowedValuesScriptWithColon")} <span
              class="required-text">*</span></span></td>

          <td colspan="2" style="border-top: 0px;"><c:remove var="allowedValuesString" /> <c:forEach var="allowedValue"
              items="${value}">
              <c:if test="${not empty allowedValuesString}">
                <c:set var="allowedValuesString" value="${allowedValuesString}${newline}" />
              </c:if>

              <c:set var="allowedValuesString" value="${allowedValuesString}${allowedValue}" />
            </c:forEach>
            <c:set var="fieldName" value="allowedValuesScript"/>
            <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.allowedValuesScript}"/>
            <ucf:textarea name="allowedValuesScript" value="${value}" cols="80"
              rows="10" enabled="${inEditMode}" /><br />
            <div class="inlinehelp">
              ${ub:i18n("PropertyAllowedValuesScriptDesc")}
            </div></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="checkboxValue"/>
      <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : projectTemplateProp.displayValue}"/>
      <tbody id="checkboxFields" ${projectTemplateProp.interfaceType.checkbox ? '' : 'style="display: none;"'}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td style="border-top: 0px;"><ucf:checkbox name="checkboxValue" value="true"
              checked="${value == 'true'}" enabled="${inEditMode}" /></td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyDefaultValueDesc")}</span></td>
        </tr>
        <c:if test="${(not empty projectTemplateProp) && isDefinedProp}">
          <tr class="${fn:escapeXml(eo.last)}">
            <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyChangeExistingValuesWithColon")}</span></td>
            <td style="border-top: 0px;"><ucf:checkbox name="applyNewCheckboxDefaultValue" enabled="${inEditMode}" /></td>
            <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyChangeExistingValuesDesc")}</span></td>
          </tr>
        </c:if>
      </tbody>

      <c:set var="fieldName" value="textAreaValue"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.displayValue}"/>
      <tbody id="textAreaFields" ${projectTemplateProp.interfaceType.textArea ? '' : 'style="display: none;"'}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td align="left" colspan="2" style="border-top: 0px;"><ucf:textarea name="textAreaValue"
              value="${value}" cols="60" rows="5" enabled="${inEditMode}" /></td>
        </tr>
        <c:if test="${(not empty projectTemplateProp) && isDefinedProp}">
          <tr class="${fn:escapeXml(eo.last)}">
            <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyChangeExistingValuesWithColon")}</span></td>
            <td style="border-top: 0px;"><ucf:checkbox name="applyNewTextAreaDefaultValue" enabled="${inEditMode}" /></td>
            <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyChangeExistingValuesDesc")}</span></td>
          </tr>
        </c:if>
      </tbody>

      <c:set var="fieldName" value="textSecureValue"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.displayValue}"/>
      <tbody id="textSecureFields" ${projectTemplateProp.interfaceType.textSecure ? '' : 'style="display: none;"'}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td style="border-top: 0px;"><ucf:password name="secureValue" value="${value}"
              enabled="${inEditMode}" size="30" extraAttribs="onKeyUp=\"showLayer('vlConfirm'); this.onkeyup=null;\"" />
            <div id="vlConfirm" <c:if test="${!showConfirm}">style="display: none;"</c:if>>
              ${ub:i18n("Confirm")} <br />
              <ucf:password name="valueConfirm" value="" enabled="${inEditMode}" size="30" />
            </div></td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyDefaultValueDesc")}</span></td>
        </tr>
        <c:if test="${(not empty projectTemplateProp) && isDefinedProp}">
          <tr class="${fn:escapeXml(eo.last)}">
            <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyChangeExistingValuesWithColon")}</span></td>
            <td style="border-top: 0px;"><ucf:checkbox name="applyNewSecureDefaultValue" enabled="${inEditMode}" /></td>
            <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyChangeExistingValuesDesc")}</span></td>
          </tr>
        </c:if>
      </tbody>

      <c:set var="fieldName" value="value"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.displayValue}"/>
      <tbody id="textAndSelectFields" ${projectTemplateProp.interfaceType.text || projectTemplateProp.interfaceType.select ? '' : 'style="display: none;"'}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td style="border-top: 0px;"><ucf:text name="value" value="${value}"
              enabled="${inEditMode}" /></td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyDefaultValueDesc")}</span></td>
        </tr>
        <c:if test="${(not empty projectTemplateProp) && isDefinedProp}">
          <tr class="${fn:escapeXml(eo.last)}">
            <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyChangeExistingValuesWithColon")}</span></td>
            <td style="border-top: 0px;"><ucf:checkbox name="applyNewDefaultValue" enabled="${inEditMode}" /></td>
            <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyChangeExistingValuesDesc")}</span></td>
          </tr>
        </c:if>
      </tbody>

      <c:set var="fieldName" value="multiSelectValue"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.displayValue}"/>
      <tbody id="multiSelectFields" ${projectTemplateProp.interfaceType.multiSelect ? '' : 'style="display: none;"'}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td style="border-top: 0px;"><ucf:text name="multiSelectValue" value="${value}"
              enabled="${inEditMode}" /></td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyDefaultValueDescMulti")}</span></td>
        </tr>
        <c:if test="${(not empty projectTemplateProp) && isDefinedProp}">
          <tr class="${fn:escapeXml(eo.last)}">
            <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyChangeExistingValuesWithColon")}</span></td>
            <td style="border-top: 0px;"><ucf:checkbox name="applyNewMultiSelectDefaultValue" enabled="${inEditMode}" /></td>
            <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyChangeExistingValuesDesc")}</span></td>
          </tr>
        </c:if>
      </tbody>

      <c:set var="fieldName" value="propertyGroupList"/>
      <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : projectTemplateProp.displayValue}"/>
      <tbody id="propertyGroupFields" ${projectTemplateProp.interfaceType.integrationPlugin ? '' : 'style="display:none;"'}>
        <error:field-error field="${WebConstants.PLUGIN}" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyPropertyGroup")} </span></td>

          <td width="15%" style="border-top: 0px;">
            <ucf:idSelector list="${null}"
                            id="propertyGroupSelect"
                            selectedId="${value}"
                            name="propertyGroupList"
                            canUnselect="false"/>
          </td>

          <td align="left" style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyPropertyGroupDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="agentPoolList"/>
      <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : projectTemplateProp.displayValue}"/>
      <tbody id="agentPoolFields" ${projectTemplateProp.interfaceType.agentPool ? '' : 'style="display:none;"'}>
        <error:field-error field="${WebConstants.AGENT_POOL}" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("AgentPoolWithColon")} </span></td>
          <td width="15%" style="border-top: 0px;">
            <select name="agentPoolList" class="input">
              <option value="">--&nbsp;${ub:i18n("MakeSelection")}&nbsp;--</option>
                <c:forEach var="agentPool" items="${agentPoolList}">
                  <c:set var="agentPoolStr" value="${agentPool.name}" />
                  <option value="${agentPoolStr}" <c:if test="${agentPoolStr eq value}">selected=""</c:if>>
                    <c:out value="${agentPoolStr}" />
                  </option>
                </c:forEach>
            </select>
          </td>
          <td align="left" style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyAgentPoolDefaultDesc")}</span></td>
        </tr>
        <c:if test="${(not empty projectTemplateProp) && isDefinedProp}">
          <tr class="${fn:escapeXml(eo.last)}">
            <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyChangeExistingValuesWithColon")}</span></td>
            <td style="border-top: 0px;"><ucf:checkbox name="applyNewAgentPoolDefaultValue" enabled="${inEditMode}" /></td>
            <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyChangeExistingValuesDesc")}</span></td>
          </tr>
        </c:if>
      </tbody>

      <tbody id="scriptedValueFields" ${projectTemplateProp.scriptedValue ? '' : 'style="display: none;"'}>
        <error:field-error field="valueScript" cssClass="${eo.last}" />
        <error:field-error field="inputProperties" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyDefaultValueScriptWithColon")}</span></td>

          <td colspan="2" style="border-top: 0px;">
            <c:set var="fieldName" value="inputProperties"/>
            <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : inputPropString}"/>
            <%-- allow for props of type: text, textArea select, multi-select  --%> <c:if
              test="${projectTemplateProp.interfaceType.multiValued || projectTemplateProp.interfaceType.text || projectTemplateProp.interfaceType.textArea || projectTemplateProp.interfaceType.checkbox}">
              <%--
              <div style="margin: 0em 0em 2em 0em;">
                <span class="bold">${ub:i18n("PropertySourcePropertyNamesWithColon")}</span><br />
                <ucf:textarea name="inputProperties" value="${value}" cols="40" rows="5" />
                <div class="inlinehelp">${ub:i18n("PropertySourcePropertyNamesDesc")}</div>
              </div>
               --%>

              <span class="bold">${ub:i18n("PropertyBeanshellScript")} <c:if
                  test="${not projectTemplateProp.interfaceType.multiValued}">
                  <span class="required-text">*</span>
                </c:if>
              </span>
              <br />
            </c:if>

            <c:set var="fieldName" value="valueScript"/>
            <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : projectTemplateProp.valueScript}"/>
            <ucf:textarea name="valueScript" value="${value}" cols="80" rows="10"
              enabled="${inEditMode}" /><br />
            <div class="inlinehelp">
              ${ub:i18n("PropertyBeanshellScriptDesc1")}
              <ul style="margin: 0px 0px 15px 6px">
                <li>${ub:i18n("PropertyBeanshellScriptDesc2")}</li>
                <li>${ub:i18n("PropertyBeanshellScriptDesc3")}</li>
                <li>${ub:i18n("PropertyBeanshellScriptDesc4")}</li>
                <li>${ub:i18n("PropertyBeanshellScriptDesc5")}</li>
                <li>${ub:i18n("PropertyBeanshellScriptDesc6")}</li>
              </ul>
            </div>
          </td>
        </tr>
      </tbody>

      <tbody id="jobValueFields" ${projectTemplateProp.jobExecutionValue ? '' : 'style="display: none;"'}>
        <error:field-error field="${WebConstants.AGENT_POOL_ID}" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("AgentPoolWithColon")} <span class="required-text">*</span>
          </span></td>

          <c:set var="fieldName" value="${WebConstants.AGENT_POOL_ID}"/>
          <c:set var="agentFilterValue" value="${param[fieldName] != null ? param[fieldName] : agentFilter}"/>
          <td style="border-top: 0px;">
            <uiA:agentPoolSelector
                agentFilter="${agentFilterValue}"
                disabled="${inViewMode}"
                allowNoAgent="false"
                allowParentJobAgent="false"
                useRadio="false"
                agentPoolList="${agentPoolList}"
            />
          </td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyAgentPoolDesc")}</span></td>
        </tr>
        <error:field-error field="${WebConstants.JOB_CONFIG_ID}" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">
          ${ub:i18n("JobWithColon")} <span class="required-text">*</span></span></td>

          <c:set var="fieldName" value="${WebConstants.JOB_CONFIG_ID}"/>
          <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : projectTemplateProp.jobExecutionJobConfig.id}"/>
          <td style="border-top: 0px;">
            <ucf:idSelector
                name="${fn:escapeXml(WebConstants.JOB_CONFIG_ID)}"
                list="${libJobList}"
                selectedId="${value}"/>
          </td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyWorkflowJobDesc")}</span></td>
        </tr>
      </tbody>

    </table>

    <br />

    <c:if test="${inEditMode}">
      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${ah3:escapeJs(cancelUrl)}"/>
    </c:if>

    <c:if test="${inViewMode}">
      <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}#property" />
      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${viewListUrl}" />
    </c:if>
  </form>
</div>
