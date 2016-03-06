<br/>

<c:url var="addAgentPropertyUrl"    value="${AgentPropertyTasks.addAgentProperty}">
  <c:param name="agent_id" value="${agent.id}" />
</c:url>

<c:url var="addSecureAgentPropertyUrl" value="${AgentPropertyTasks.addSecureAgentProperty}">
  <c:param name="agent_id" value="${agent.id}" />
</c:url>

<c:if test="${hasWritePermission}">
  <ucf:button name="Add Property" href="${addAgentPropertyUrl}" label="${ub:i18n('AddProperty')}" 
            enabled="${inViewMode and hasWritePermission}"/>
  &nbsp;
  <ucf:button name="Add Secure Property" href="${addSecureAgentPropertyUrl}" label="${ub:i18n('AgentAddSecureProperty')}" 
            enabled="${inViewMode and hasWritePermission}"/>
  <br/><br/>
</c:if>

<table id="agentProperties" class="data-table">
  <caption>
    ${ub:i18n("AgentProperties")}
  </caption>
  <tbody>
    <tr>
      <th scope="col" align="left" valign="middle" width="30%">${ub:i18n("Name")}</th>
      <th scope="col" align="left" width="60%">${ub:i18n("Value")}</th>
      <th scope="col" align="left" width="10%">${ub:i18n("Actions")}</th>
    </tr>
    <c:if test="${empty properties}">
      <tr bgcolor="#ffffff">
        <td align="left" colspan="3">
          ${ub:i18n("NoAgentPropertiesDefined")}
        </td>
      </tr>
    </c:if>
    <c:forEach var="property" items="${properties}">
      <tr bgcolor="#ffffff">
        <td align="left">
          ${fn:escapeXml(property.key)}
        </td>

        <td align="left" class="wrapped monospaced">
          ${fn:escapeXml(property.value)}
        </td>

        <td align="center" >
          <c:url var="editPropertyUrl" value="${AgentPropertyTasks.editAgentProperty}">
            <c:param name="property" value="${property.key}"/>
            <c:param name="agent_id" value="${agent.id}" />
          </c:url>
          
          <c:url var="deletePropertyUrl" value="${AgentPropertyTasks.deleteAgentProperty}">
            <c:param name="property" value="${property.key}"/>
            <c:param name="agent_id" value="${agent.id}" />
          </c:url>

          <ucf:link href="${editPropertyUrl}" label="${ub:i18n('Edit')}" img="${iconEditUrl}" enabled="${hasWritePermission}"/>
          &nbsp;
          <ucf:deletelink href="${deletePropertyUrl}" label="${ub:i18n('Delete')}" name="${property.key}"
                          img="${iconDeleteUrl}" enabled="${hasWritePermission}"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>