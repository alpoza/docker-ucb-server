<br/>

<c:url var="saveEnvironmentVariableUrl" value="${AgentEnvironmentTasks.saveEnvironmentVariable}">
  <c:param name="agent_id" value="${agent.id}" />
</c:url>

<form name="agent-edit-form" method="POST" action="${fn:escapeXml(saveEnvironmentVariableUrl)}">
  <div align="right" style="vertical-align: bottom;">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>
  <table class="property-table">
    <tbody>
      <c:if test="${not empty variableName}">
        <ucf:hidden name="variable" value="${variableName}"/>
      </c:if>

      <error:field-error field="variable"/>
      <tr>
        <td width="20%">
          <span class="bold">${ub:i18n("VariableName")} <span class="required-text">*</span></span>
        </td>
        <td width="25%">
          <ucf:text name="variable" value="${variableName}" enabled="${empty variableName}"/>
        </td>
        <td>
          <span class="inlinehelp">${ub:i18n("AgentUniqueEnvironmentVariableName")}</span>
        </td>
      </tr>

      <error:field-error field="variableValue"/>
      <tr>
        <td width="20%">
          <span class="bold">${ub:i18n("VariableValue")} <span class="required-text">*</span></span>
        </td>
        <td width="25%">
          <c:choose>
            <c:when test="${variableSecure}">
              <ucf:hidden name="variableSecure" value="true"/>
              <ucf:password name="variableValue" value="${variableValue}" size="30"
                  onPwdChange="$('secureValueConfirm').show();" />
              <div id="secureValueConfirm" <c:if test="${!showConfirm}">style="display: none;"</c:if>>
                <span class="bold">${ub:i18n("Confirm")}</span><br/>
                <ucf:password name="variableValueConfirm" value="" size="30" />
              </div>
            </c:when>
            <c:otherwise>
              <ucf:textarea name="variableValue" value="${variableValue}"/>
            </c:otherwise>
          </c:choose>
        </td>
        <td>
          <span class="inlinehelp">${ub:i18n("AgentEnvironmentVariableValueDesc")}</span>
        </td>
      </tr>

    </tbody>
  </table>
  <br/>
  <ucf:button name="Save" label="${ub:i18n('Save')}"/>

  <c:url var="cancelEditEnvironmentVariableUrl" value="${AgentEnvironmentTasks.cancelEditEnvironmentVariable}">
    <c:param name="agent_id" value="${agent.id}" />
  </c:url>

  <ucf:button href="${cancelEditEnvironmentVariableUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
</form>
<br/>
<br/>
