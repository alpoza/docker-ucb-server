<br/>

<c:url var="savePropertyUrl"   value="${AgentPropertyTasks.saveAgentProperty}">
  <c:param name="agent_id" value="${agent.id}" />
</c:url>

<form name="agent-edit-form" method="POST" action="${fn:escapeXml(savePropertyUrl)}">
  <div align="right" style="vertical-align: bottom;">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>
  <table class="property-table">
    <tbody>
      <c:if test="${not empty propertyName}">
        <ucf:hidden name="property" value="${propertyName}"/>
      </c:if>

      <c:set var="fieldName" value="property"/>
      <c:set var="nameValue" value="${param[fieldName] != null ? param[fieldName] : propertyName}"/>
      <error:field-error field="property"/>
      <tr>
        <td width="20%">
          <span class="bold">${ub:i18n("PropertyNameWithColon")} <span class="required-text">*</span></span>
        </td>
        <td width="25%">
          <ucf:text name="property" value="${nameValue}" enabled="${empty nameValue}"/>
        </td>
        <td>
          <span class="inlinehelp">${ub:i18n("AgentUniqueAgentPropertyName")}</span>
        </td>
      </tr>

      <c:set var="fieldName" value="propertyValue"/>
      <c:set var="propertyValueValue" value="${param[fieldName] != null ? param[fieldName] : propertyValue}"/>
      <error:field-error field="propertyValue"/>
      <tr>
        <td width="20%">
          <span class="bold">${ub:i18n("AgentPropertyValue")} <span class="required-text">*</span></span>
        </td>
        <td width="25%">
          <c:choose>
            <c:when test="${propertySecure}">
              <ucf:hidden name="propertySecure" value="true"/>
              <ucf:password name="propertyValue" value="${propertyValueValue}" size="30"
                  onPwdChange="$('secureValueConfirm').show();" />
              <div id="secureValueConfirm" <c:if test="${!showConfirm}">style="display: none;"</c:if>>
                <span class="bold">${ub:i18n("Confirm")}</span><br/>
                <ucf:password name="propertyValueConfirm" value="" size="30" />
              </div>
            </c:when>
            <c:otherwise>
              <ucf:textarea name="propertyValue" value="${propertyValueValue}"/>
            </c:otherwise>
          </c:choose>
        </td>
        <td>
          <span class="inlinehelp">${ub:i18n("AgentPropertyValueDesc")}</span>
        </td>
      </tr>

    </tbody>
  </table>
  <br/>
  <ucf:button name="Save" label="${ub:i18n('Save')}"/>

  <c:url var="cancelPropertyUrl" value="${AgentPropertyTasks.cancelEditAgentProperty}">
    <c:param name="agent_id" value="${agent.id}" />
  </c:url>

  <ucf:button href="${cancelPropertyUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
</form>
<br/>
<br/>
