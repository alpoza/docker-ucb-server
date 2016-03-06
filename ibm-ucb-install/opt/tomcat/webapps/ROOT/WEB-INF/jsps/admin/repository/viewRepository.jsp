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
<%@page import="com.urbancode.air.plugin.server.SourcePlugin"%>
<%@page import="com.urbancode.air.property.prop_value.PropValue"%>
<%@page import="com.urbancode.ubuild.domain.repository.Repository" %>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>

<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib uri="error" prefix="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.repository.RepositoryTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.ResourceTasks" />

<c:url var="iconDel" value="/images/icon_delete.gif"/>

<c:set var="canManageSecurity" value="true"/>

<%-- used for Done button (and Cancel when propSheet is new) --%>
<c:url var="viewListUrl" value="${RepositoryTasks.viewList}"></c:url>

<%-- AJAX method for saving --%>
<c:url var='saveRepositoryUrl' value='${RepositoryTasks.saveRepositoryAjax}'/>

<%-- Currently used to reload page on successful save --%>
<c:url var="viewRepositoryUrl" value="${RepositoryTasks.viewRepository}">
  <c:param name="${WebConstants.REPO_ID}" value="${repo.id}"/>
</c:url>

<c:url var="viewTriggerUrl" value="${RepositoryTasks.viewRepositoryTrigger}">
  <c:param name="${WebConstants.REPO_ID}" value="${repo.id}"/>
</c:url>

<c:if test="${empty repo or repo.new}">
  <c:set var="disabled" value="${'true'}" />
</c:if>
<c:set var="creatingRepository" value="${repo == null || repo.new}"/>

<c:choose>
  <c:when test="${param.selected == 'security'}">
    <c:set var="securityClass" value="selected"/>
  </c:when>
</c:choose>

<c:if test="${disabled == 'true'}"> <%-- If disabled, the default class is 'disabled' --%>
  <c:set var="securityClass"    value="disabled"/>
</c:if>

<c:url var="securityTabUrl" value='${ResourceTasks.viewResource}'>
  <c:param name="resourceId" value="${repo.securityResourceId}"/>
</c:url>


<%
    pageContext.setAttribute("eo", new EvenOdd());
%>

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemRepository')}"/>
  <jsp:param name="selected" value="system"/>
  <jsp:param name="disabled" value="${false}"/>
</jsp:include>

<script type="text/javascript">
  /* <![CDATA[ */

  /**
   *  Extracts the entered/selected value from various form-elements
   *
   *  @param field the Html field to extract the value from
   */
  function getFieldValue(field){
      var type = field.type || field.tagName; // get type or tagename if type is undefined
      var value = null;

      if (type == 'text' || type == 'textarea' || type == 'password') {
          value = field.value;
      }
      else if (type.startsWith('select')) {
          var selectedIndex = field.selectedIndex;
          value = selectedIndex == null ? null :field.options[selectedIndex].value;
      }
      else if (type == 'checkbox') {
          value = (field.checked ? field.value : null);
      }
      else if (type == 'radio') {
          // TODO ?? like checkbox, but how deal with interaction of multiple radio buttons...
      }
      else {
          // file-input, image-input, etc
      }
      return value == '' ? null : value;
  }

  /**
   *  The javascript controller for Repository HTML forms
   */
  var RepositoryForm = {

      _viewListUrl: '${ah3:escapeJs(viewListUrl)}',
      _saveRepositoryUrl: '${ah3:escapeJs(saveRepositoryUrl)}',
      _newPropCounter: 0,

      /**
       * Start editing the form (toggle buttons to Save/Cancel, from Done)
      *
      * @param form the Html form to start editing
       */
      startEditing: function(form){
          form.down('.editButtons').show();
          form.down('.doneButtons').hide();
      },

      /**
       * Cancel editing the form.  If new object, redirect page to list view,
       *  otherwise just revert form and switch buttons to Done from Save/Cancel.
       *
       * @param form the Html form to revert all changes
       */
      cancel: function(form){
          form = $(form);

          var isNew = form.serialize(true)['${WebConstants.IS_NEW}'] != null;

          if (isNew) {
              goTo(RepositoryForm._viewListUrl);
          }
          else {
              form.reset();
              form.removeClassName('changed');
              form.select('.confirmPasswordSection').each(function(div){div.hide()});
              this._attachErrors(form, null);
              form.down('.editButtons').hide();
              form.down('.doneButtons').show();
          }
      },

      /**
       * Do local-validation and if valid submit data via AJAX
       *
       * @param form the Html form to save
       */
      save: function(form){
          form = $(form);

          if (!(form.down('.editButtons').visible())) {
              return;
          }

          //
          // CLIENT-SIDE VALIDATE
          //

          var valid = RepositoryForm.validateForm(form);
          if (!valid) {
              return;
          }

          //
          // SUBMIT AND PROCESS RESPONSE
          //

          form.request({
              onSuccess: function(resp) {
                  if (resp.responseJSON) {
                      if (resp.responseJSON.error) {// errors were found!!
                          RepositoryForm._attachErrors(form, resp.responseJSON);
                      }
                      else {
                          alert(i18n("UnknownResponseFromServer"))
                      }
                  }
                  else {
                      var contentType = resp.getHeader('Content-Type').split(';')[0];
                      switch (contentType.toLowerCase()) {
                          case 'text/javascript':
                              // successfully saved!!
                              // do nothing, prototype evaluates javascript automatically
                              break;
                          case 'text/plain':
                              // successfully saved!!
                              goTo(resp.responseText);
                              break;
                          default:
                              alert(i18n("UnknownResponseFromServer") + contentType);
                      }
                  }
              },
              onFailure:   function(resp)  { alert(i18n("PropertiesSavingError")); },
              onException: function(req,e) { throw e;} // so errors show in ErrorConsole
          })
      },

      /**
       *  Client-Side validation of form.  Attaches any resultant field-errors.
       *  Similar validation is perfomed on server-side as well.
       *
       *  @param form the Html form to validate
       *  @return true if the form passes client-side validation, false otherwise
       */
      validateForm: function(form) {
          form = $(form);
          var formErrors = {message: i18n("CorrectErrors"), fields: new Array()};

          // Required fields
          form.select('input.required','textarea.required','select.required').each(function(field){
              var type = field.type || field.tagName; // get type or tagename if type is undefined
              if (getFieldValue(field) == null) {
                  formErrors.fields.push({fieldName: field.name, message: i18n("EnterAValue")});
              }
          });

          // Check password confirm fields
          form.select('input.hasConfirm').each(function(field){
              var dummyPwd = '${ah3:escapeJs(WebConstants.DUMMY_PASSWORD)}';

              var value = getFieldValue(field);

              var confirmField = field.next('.confirmPasswordSection').down('input');
              var confirmValue = getFieldValue(confirmField);

              if (value == dummyPwd && confirmValue == null) {
                  // this is OK, we maintain existing non-null password
              }
              else if (value != confirmValue) {
                  formErrors.fields.push({fieldName: field.name, message: i18n("ValueConfirmationError")});
              }
          });

          //
          // Result
          //

          if (formErrors.fields.length > 0) {
              this._attachErrors(form, formErrors);
              return false;
          }
          else {
              this._attachErrors(form, null);
              return true;
          }
      },

      /**
       * Attach the given FormErrors to given form. It will clear any previous errors prior to attaching new messages.
       *
       * @param form the html form to modify
       * @param formErrors the list of form errors to attach
       */
      _attachErrors: function(form, formErrors) {
          form = $(form);

          // remove previous errors
          form.select('span.error').each(function(err){err.remove()});
          form.down('.formError').hide();

          if (formErrors) {
              // attach new errors
              formErrors.fields.each(function(field) {
                  var fieldName = field.fieldName;
                  var message = field.message;

                  var input = form.down("*[name='"+fieldName+"']"); // input or select element with the field name
                  input.up().insert({top:new Element('span', {'class':'error'}).update(message.escapeHTML()+'<br/>')});
              });

              if (formErrors.message) {
                  // update and show the general form error element
                  var generalErrorMsg = form.down('.formError');
                  generalErrorMsg.update(formErrors.message).show();
              }
          }
      },

      /**
       * Attaches a change listener to each input of the given form. (which trigger the startEditing method)
       *
       * @param form the html form to modify
       */
      attachListenersToForm: function(form) {
          form = $(form);

          form.action = RepositoryForm._saveRepositoryUrl;
          Element.observe(form, 'submit', function(){RepositoryForm.save(form)});

          // TODO select elements (also multi select)

          form.select('input', 'select', 'textarea').each(function(input){
              var form = input.up('form');

              var type = input.type || input.tagName;

              if (type == 'text' || type == 'textarea' || type == 'password') {
                  Element.observe(input, 'keyup', function(event) {
                      var changed = (input.value != input.defaultValue);
                      if (changed && !form.hasClassName('changed')) {
                          form.addClassName('changed');
                          RepositoryForm.startEditing(form);
                      }

                      if (changed && type == 'password') {
                          var confirmSection = input.next('.confirmPasswordSection')
                          if (confirmSection) {
                              confirmSection.show(); // show the confirm section if present
                          }
                      }
                  });
              }
              else if (type.startsWith('select')) {
                Element.observe(input, 'change', function(event) {
                    var changed = (input.selectedIndex != input.defaultSelectedIndex);
                    if (changed && !form.hasClassName('changed')) {
                        form.addClassName('changed');
                        RepositoryForm.startEditing(form);
                    }
                });
              }
              else if (type == 'checkbox' || type=='radio') {
                  Element.observe(input, 'click', function(event) {
                      var changed = (input.checked != input.defaultChecked);
                      if (changed && !form.hasClassName('changed')) {
                          form.addClassName('changed');
                          RepositoryForm.startEditing(form);
                      }
                  });
              }
              else {
                  // alert('unrecognized field '+input.name+' of type '+type)
              }
          });
      }
  };

  <c:if test="${!empty saveMessage}">
  setTimeout('$("saveMessage").remove()', 5000); // remove save message after 5 seconds
  </c:if>

  Element.observe(window, 'load', function(event) {
      $$('.integrationPropForm').each(function(form){
          RepositoryForm.attachListenersToForm(form);

          // TODO we should just initialize the confirm section to be hidden
          form.select('.confirmPasswordSection').each(function(section){section.hide();});
      });
  });

  /* ]]> */
</script>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${creatingRepository ? ub:i18n('NewRepository') : fn:escapeXml(repo.name)}"
        href="${viewRepositoryUrl}" enabled="${!creatingRepository && !disabled}" klass="selected tab"/>
    <c:if test="${supportsTriggers}">
      <ucf:link label="${ub:i18n('Trigger')}" href="${viewTriggerUrl}" enabled="${!disabled}" klass="tab"/>
    </c:if>
    <ucf:link label="${ub:i18n('Security')}" href="#" onclick="showPopup('${ah3:escapeJs(securityTabUrl)}', 800, 600); return false;"
        enabled="${!disabled}" klass="tab"/>
  </div>
  <div class="contents">

    <c:if test="${!empty propSheetDef.description}">
      <div class="system-helpbox" style="margin-top: 1em; margin-bottom: 1em;">${fn:escapeXml(propSheetDef.description)}</div>
    </c:if>

    <form class="integrationPropForm" onsubmit="return false" action="#" method="post">

       <c:if test="${!empty saveMessage}">
         <div style="color: green; margin-top: 1em; margin-bottom: 1em;" id="saveMessage">${fn:escapeXml(saveMessage)}</div>
         <c:remove var="saveMessage" scope="session"/>
       </c:if>
       <div class="formError" style="display:none; color: red; margin-bottom: 10px"></div>

       <div align="right"><span class="required-text">${ub:i18n("RequiredField")}</span></div>
       <table class="property-table" style="margin-top: 10px">
         <tbody>
           <tr class="${eo.next}">
             <td style="width:20%">
               <span class="bold">${ub:i18n("TypeWithColon")}</span>
             </td>
             <td style="width:20%">
               <c:out value="${plugin.name}" default="${repo.plugin.name}"/>
             </td>
             <td><span class="inlinehelp">${ub:i18n("RepositoryTypeDesc")}</span></td>
           </tr>

           <error:field-error field="${WebConstants.NAME}" cssClass="${eo.next}"/>
           <tr class="${eo.last}">
             <td style="width:20%">
               <span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span>
             </td>
             <td style="width:20%">
               <c:if test="${empty repo}">
                 <ucf:hidden name="${WebConstants.PLUGIN_ID}" value="${plugin.id}"/>
               </c:if>
               <ucf:hidden name="${WebConstants.REPO_ID}" value="${repo.id}"/>
               <ucf:text name="name" value="${repo.name}" enabled="${true}" required="${true}" size="60"/>
             </td>
             <td><span class="inlinehelp">${ub:i18n("RepositoryNameDesc")}</span></td>
           </tr>

           <error:field-error field="description" cssClass="${eo.next}"/>
           <tr class="${eo.last}">
             <td style="width:20%">
               <span class="bold">${ub:i18n("DescriptionWithColon")}</span>
             </td>
             <td colspan="2">
               <ucf:textarea name="description" value="${repo.description}" enabled="${true}"/>
             </td>
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

           <c:import url="/WEB-INF/snippets/admin/security/newSecuredObjectSecurityFields.jsp"/>
         </tbody>
       </table>

       <div style="margin-top: 10px; <c:if test="${not empty repo}">display: none;</c:if>" class="editButtons">
         <ucf:button name="Save" label="${ub:i18n('Save')}" submit="${true}"/>
         <c:choose>
           <c:when test="${creatingRepository}">
             <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" href="${viewListUrl}"/>
           </c:when>
           <c:otherwise>
             <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}" onclick="RepositoryForm.cancel($(this).up('form')); return false"/>
           </c:otherwise>
         </c:choose>
       </div>
       <div style="margin-top: 10px; <c:if test="${empty repo}">display: none;</c:if>" class="doneButtons">
         <ucf:button name="Done" label="${ub:i18n('Done')}" submit="${false}" href="${viewListUrl}"/>
       </div>
     </form>

     </div>
  </div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
