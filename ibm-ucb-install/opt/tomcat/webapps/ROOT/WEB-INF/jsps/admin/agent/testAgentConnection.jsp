<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error"%>

<%@ page import="com.urbancode.ubuild.domain.agent.Agent" %>

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.agent.AgentTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="testAgentConnectionInsetUrl" value="${AgentTasks.testAgentConnectionAjax}">
  <c:param name="${WebConstants.AGENT_ID}" value="${agent.id}"/>
</c:url>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<div class="popup_header">
  <ul><li class="current"><a>${ub:i18n("Test")}</a></li></ul>
</div>

<div class="contents" style="height:200px;">
  <br/>
  <div class="bold">${ub:i18nMessage("AgentCommunicationTestResultforAgent", agent.name)}</div>
  <br/>
  ${ub:i18n("AgentTestingAgentConnection")}
  <br/>
  <p id=pingResult>${ub:i18n("WaitingOnAgent")}</p>

  <script type="text/javascript">
    new Ajax.Request(${ah3:toJson(testAgentConnectionInsetUrl)},
        { // putting in a 'map'
          'method': 'post',
          'onSuccess': function(resp) {
            var response = resp.responseText;
              document.getElementById('pingResult').innerHTML = response.replace("\n", "<br/>");
          }
        }
      );
  </script>
  <br/>

  <ucf:button name="Close" label="${ub:i18n('Close')}" onclick="parent.hidePopup();"/>

  <br/>
</div>

<c:import url="/WEB-INF/snippets/popupFooter.jsp"/>
