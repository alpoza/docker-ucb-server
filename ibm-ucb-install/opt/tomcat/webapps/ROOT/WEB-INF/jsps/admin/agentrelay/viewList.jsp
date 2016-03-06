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
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="auth" uri="auth" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useEnum enum="com.urbancode.ubuild.domain.security.UBuildAction" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.agentrelay.AgentRelayTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />

<c:url var="iconActiveUrl" value="/images/icon_active.gif"/>
<c:url var="iconInactiveUrl" value="/images/icon_inactive.gif"/>
<c:url var="iconEditUrl" value="/images/icon_pencil_edit.gif"/>
<c:url var="iconHelpUrl" value="/images/icon_help.gif"/>
<c:url var="iconSecurityUrl" value="/images/icon_shield.gif"/>

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}"/>
<c:set var="inViewMode" value="${not inEditMode}"/>

<jsp:useBean id="eo" class="com.urbancode.ubuild.web.util.EvenOdd" scope="page"/>

<%-- CONTENT --%>

<c:set var="headContent" scope="request">

  <style type="text/css">
    .error {
      font-weight: bold;
      color: red;
    }

    .description {
      white-space: pre
    }
  </style>

  <script type="text/javascript">
    /* <!-- <![CDATA[ */
    var AgentRelay = {
        users: new Array(),

        /**
         * Switch to edit mode
         */
        edit: function(viewRow){
          viewRow = $(viewRow);
          var editRow = viewRow.next();

          editRow.show();
          viewRow.hide();
        },

        /**
         * Reset the form and switch to view mode
         */
        cancel: function(form){
          form = $(form);
          form.reset();
          this._updateFormErrors(form, null); // clear previous form errors

          var editRow = form.up('tr');
          var viewRow = editRow.previous();
          editRow.hide();
          viewRow.show();
        },

        /**
         * save the given form (validate and show errors if needed)
         */
        save: function(form){
          form = $(form);
          var editRow = form.up('tr');
          var viewRow = editRow.previous();

          var formErrors = {message:"i18n('DistributedServersCorrectErrorsMessage')", fields: new Array()};
          var valid = true;

          //
          // Validate
          //
          this._updateFormErrors(form, null); // clear previous form errors

          /*
          form.select('input[type="text"][name^="prop-name:"]', 'input[type="text"][name^="envprop-name:"]').each(function(field){
              var noValue = (field.value == null || field.value == '');
              if (noValue) {
                  formErrors.fields.push({fieldName: field.name, message: 'enter a value'});
              }
          });
          */

          //
          // Submit/Respond
          //

          if (!valid || formErrors.fields.length > 0) {
            this._updateFormErrors(form, formErrors);
            return;
          }

          form.request({
            onSuccess: function(resp) {
              var contentType = new String(resp.getHeader('Content-Type')).toLowerCase();
              if (contentType.startsWith('text/javascript')) {
                // already performed javascript response
              }
              else if (resp.responseJSON) { // errors were found!!
                var result = resp.responseJSON;
                if (result.error != null) {
                  AgentRelay._updateFormErrors(form, result);
                }
                else if (result.success) {
                  // UPDATE PAGE
                  //   - update description view-text
                  //   - update the default states of all inputs/select to the current value
                  //   - update the active/inactive idon in the view row
                  //   - switch to view-mode

                  viewRow.down('.name').update(form.down('*[name="name"]').value.escapeHTML());
                  viewRow.down('.description').update(form.down('*[name="description"]').value.escapeHTML());

                  AgentRelay._updateFormDefaults(form);

                  var isActive = form.down('input[type="checkbox"][name="active"]').checked;
                  var activeIcn = viewRow.down('img.active_state');
                  activeIcn.src = isActive ? '${iconActiveUrl}' : '${iconInactiveUrl}';
                  activeIcn.alt = isActive ? '[active]' : '[inactive]';

                  viewRow.show();
                  editRow.hide();
                }
                else {
                  alert(i18n('DistributedServersUnknownProblemMessage'));
                }
              }
              else {
                // failure?
                var message = "$ub:i18n('DistributedServersUnknownProblemMessage')}";
                if (contentType.startsWith('text/plain')) {
                  message += ': '+resp.responseText;
                }
                alert(message);
              }
            },
            onFailure:   function(resp)  { alert(i18n('DistributedServersSavingProblemMessage')); },
            onException: function(req,e) { throw e;}
          });
        },

        /**
         * attach FormErrors directly to the form (remove any previous errors)
         */
        _updateFormErrors: function(form, formErrors) {
          form = $(form);

          // remove previous errors
          //form.select('span.error').each(function(err){err.remove()});
          form.select('tr.error').each(function(err){err.hide()});
          form.down('.formError').hide();

          if (formErrors) {
            // attach new errors
            formErrors.fields.each(function(field) {
              var fieldName = field.fieldName;
              var message = field.message;

              var input = form.down("*[name='"+fieldName+"']"); // input or select element with the field name
              input.up("tr").previous(".error").show().down().update(message.escapeHTML());
            });

            if (formErrors.message) {
              var secError = form.down('.formError');
              secError.update(formErrors.message);
              secError.show();
            }
          }
        },

        /**
         * Updates the default values for form inputs to be equal to the currently entered values
         */
        _updateFormDefaults: function(form) {
          form = $(form);

          // ignore file-upload and hidden fields
          form.getInputs('checkbox').each(function(input){ input.defaultChecked = input.checked;});
          form.getInputs('radio').each(   function(input){ input.defaultChecked = input.checked;});
          form.getInputs('text').each(    function(input){ input.defaultValue = input.value;});
          form.getInputs('password').each(function(input){ input.defaultValue = input.value;});
          form.select('textarea').each(   function(input){ input.defaultValue = input.value;});
          form.select('option').each(     function(input){ input.defaultSelected = input.selected;}); // for select
          this._updateFormErrors(form, null); // clear previous form errors
        }
    };

    /* ]]> --> */
  </script>

</c:set>
<c:import url="/WEB-INF/snippets/header.jsp">
  <c:param name="title" value="${ub:i18n('SystemAgentRelays')}"/>
  <c:param name="selected" value="system"/>
  <c:param name="disabled" value="${inEditMode}"/>

</c:import>
<div>
    <div class="tabManager" id="secondLevelTabs">
      <ucf:link label="${ub:i18n('AgentRelays')}" href="" enabled="${false}" klass="selected tab"/>
    </div>
    <div class="contents">
      <div class="system-helpbox" style="margin-bottom: 10px">${ub:i18n("DistributedServersSystemHelpBox")}</div>
      
      <c:if test="${!empty error}">
        <div class="error">${fn:escapeXml(error)}</div>
      </c:if>
      <table class="data-table" style="margin:5px 0px; width:100%">
        <caption>${ub:i18n("AgentRelays")}</caption>
        <thead>
          <tr>
            <th scope="col" style="width:25%">${ub:i18n("Name")}</th>
            <th scope="col" style="width:40%">${ub:i18n("Description")}</th>
            <th scope="col" style="width:20%">${ub:i18n("Address")}</th>
            <th scope="col" style="width:7%" >${ub:i18n("Active")}</th>
            <th scope="col" style="width:8%" >${ub:i18n("Actions")}</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty agentRelayList}">
              <tr bgcolor="#ffffff">
                <td colspan="5">${ub:i18n("DistributedServersNoAgentRelaysMessage")}</td>
              </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="agentRelay" items="${agentRelayList}">
                  <auth:check persistent="agentRelay" var="canManageAgentRelay" action="${UBuildAction.AGENT_RELAY_EDIT}"/>
                  <tr class="${eo.next}">
                    <td class="name">${fn:escapeXml(agentRelay.name)}</td>
                    <td class="description">${fn:escapeXml(agentRelay.description)}</td>
                    <td>${fn:escapeXml(agentRelay.host)}</td>

                    <td style="text-align: center">
                      <c:choose>
                        <c:when test="${agentRelay.active}">
                          <img class="image active_state" src="${iconActiveUrl}" alt="[${ub:i18n('Active')}]"/>
                        </c:when>
                        <c:otherwise>
                          <img class="image active_state" src="${iconInactiveUrl}" alt="[${ub:i18n('Inactive')}]"/>
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <td style="text-align: center" nowrap="nowrap">
                      <ucf:link label="${ub:i18n('Edit')}" href="#" img="${iconEditUrl}"
                        onclick="AgentRelay.edit($(this).up('tr')); return false;"
                        enabled="${canManageAgentRelay}"/>
                      <c:url var="viewAgentRelaySecurityUrl" value="${ResourceTasks.viewResource}">
                        <c:param name="${WebConstants.RESOURCE_ID}" value="${agentRelay.securityResourceId}"/>
                      </c:url>
                      &nbsp;
                      <ucf:link label="${ub:i18n('Security')}" href="#" img="${iconSecurityUrl}"
                        onclick="showPopup('${viewAgentRelaySecurityUrl}',800,400); return false;"
                        enabled="${canManageAgentRelay}"/>
                    </td>
                  </tr>
                  <tr style="display:none" class="${eo.last}">
                    <td colspan="5" >
                      <form onsubmit="AgentRelay.save($(this)); return false;" action="<c:url value='${AgentRelayTasks.saveAgentRelay}'/>" method="post">
                        <div style="margin: 0 auto; width: 80%; padding: 0 6px">
                          <ucf:hidden name="${WebConstants.AGENT_RELAY_ID}" value="${agentRelay.id}"/>

                          <div class="formError" style="display:none"></div>

                          <table class="layout_table" style="width: 100%">
                            <tbody>
                              <tr>
                                <td scope="row" style="text-align: right"><span class="bold">${ub:i18n("HostWithColon")}</span></td>
                                <td>${fn:escapeXml(agentRelay.host)}</td>
                              </tr>
                              <tr>
                                <td scope="row" style="text-align: right"><span class="bold">${ub:i18n("NameWithColon")}</span></td>
                                <td><ucf:text name="name" value="${agentRelay.name}"/></td>
                              </tr>
                              <tr>
                                <td scope="row" style="text-align: right"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
                                <td>
                                   <ucf:textarea
                                     name="${WebConstants.DESCRIPTION}" value="${agentRelay.description}"
                                     rows="3"
                                     enabled="${canManageAgentRelay}"/>
                                </td>
                              </tr>

                              <tr class="error" style="display:none;">
                                <td colspan="3"></td>
                              </tr>

                              <tr>
                                <td scope="row" style="text-align: right"><span class="bold">${ub:i18n("ActiveWithColon")}</span></td>
                                <td>
                                  <ucf:checkbox name="active" value="true"
                                    checked="${agentRelay.active}"
                                    enabled="${canManageAgentRelay}"/>
                                </td>
                              </tr>
                            </tbody>
                          </table>

                          <div style="margin-top: 6px; margin-bottom: 6px">
                            <ucf:button name="Save" label="${ub:i18n('Save')}"/>
                            <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="AgentRelay.cancel($(this).up('form'));" submit="${false}"/>
                          </div>

                        </div>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
        
    <br/>
    <c:url var="doneUrl" value="${SystemTasks.viewIndex}"/>
    <ucf:button href="${doneUrl}" name="Done" label="${ub:i18n('Done')}"/>
    </div><!-- contents -->

</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
