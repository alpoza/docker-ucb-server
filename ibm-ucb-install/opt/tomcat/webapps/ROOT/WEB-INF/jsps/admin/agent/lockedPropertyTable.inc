<c:set var="propertyPrefix" value="${Agent.LOCKED_PROP_PREFIX}" />

<table id="agentLockedProperties" class="data-table">
  <caption>
    ${ub:i18n("LockedProperties")}
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
          ${ub:i18n("AgentNotConfiguredOrConnectedMessage")}
        </td>
      </tr>
    </c:if>

    <c:forEach var="property" items="${properties}">
      <tr bgcolor="#ffffff">
        <td align="left">
          ${fn:escapeXml(propertyPrefix)}${fn:escapeXml(property.key)}
        </td>

        <td align="left" class="wrapped monospaced">
          ${fn:escapeXml(property.value)}
        </td>

        <td align="center" >
          <ucf:link href="#" label="${ub:i18n('Edit')}" img="${iconEditUrl}" enabled="false"/>
          &nbsp;
          <ucf:deletelink href="#" label="${ub:i18n('Delete')}" name="${property.key}" img="${iconDeleteUrl}" enabled="false"/>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>
