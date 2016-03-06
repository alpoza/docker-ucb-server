<c:set var="propertyPrefix" value="${Agent.ENV_PROP_PREFIX}" />

<br/>

<c:url var="addEnvironmentPropertyUrl" value="${AgentEnvironmentTasks.addEnvironmentVariable}">
  <c:param name="agent_id" value="${agent.id}" />
</c:url>
<c:url var="addSecureEnvironmentPropertyUrl" value="${AgentEnvironmentTasks.addSecureEnvironmentVariable}">
  <c:param name="agent_id" value="${agent.id}" />
</c:url>

<c:if test="${hasWritePermission}">
  <ucf:button name="Add Property" href="${addEnvironmentPropertyUrl}" label="${ub:i18n('AgentAddEnvironmentVariable')}" enabled="${inViewMode}"/>
  &nbsp;
  <ucf:button name="Add Secure Property" href="${addSecureEnvironmentPropertyUrl}" label="${ub:i18n('AgentAddSecureEnvironmentVariable')}" enabled="${inViewMode}"/>
  <br/><br/>
</c:if>

<table id="agentEnvironment" class="data-table">
  <caption>
    ${ub:i18n("EnvVars")}
  </caption>
  <tbody>
    <tr>
      <th scope="col" align="left" valign="middle" width="30%">${ub:i18n("Name")}</th>
      <th scope="col" align="left" width="60%">${ub:i18n("Value")}</th>
      <th scope="col" align="left" width="10%">${ub:i18n("Actions")}</th>
    </tr>
    <c:if test="${empty variables}">
      <tr bgcolor="#ffffff">
        <td align="left" colspan="3">
          ${ub:i18n("AgentNotConfiguredOrConnectedMessage")}
        </td>
      </tr>
    </c:if>
    <c:forEach var="variable" items="${variables}">
      <tr bgcolor="#ffffff">
        <td align="left">
          ${fn:escapeXml(propertyPrefix)}${fn:escapeXml(variable.key)}
        </td>

        <td align="left" class="wrapped monospaced">
          ${fn:escapeXml(variable.value)}
        </td>

        <td align="center" >
          <c:url var="editEnvironmentPropertyUrl" value="${AgentEnvironmentTasks.editEnvironmentVariable}">
            <c:param name="variable" value="${variable.key}"/>
            <c:param name="agent_id" value="${agent.id}" />
          </c:url>

          <c:url var="deleteEnvironmentPropertyUrl" value="${AgentEnvironmentTasks.deleteEnvironmentVariable}">
            <c:param name="variable" value="${variable.key}"/>
            <c:param name="agent_id" value="${agent.id}" />
          </c:url>
          
          <ucf:link href="${editEnvironmentPropertyUrl}" label="${ub:i18n('Edit')}" img="${iconEditUrl}" enabled="${hasWritePermission}"/>
          &nbsp;
          <ucf:deletelink href="${deleteEnvironmentPropertyUrl}" label="${ub:i18n('Delete')}" name="${property}"
          		img="${iconDeleteUrl}" enabled="${hasWritePermission and variable.serverOverride}"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>