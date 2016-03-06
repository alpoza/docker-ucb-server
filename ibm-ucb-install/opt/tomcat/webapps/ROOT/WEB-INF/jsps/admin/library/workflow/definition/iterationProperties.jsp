<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.domain.workflow.AbstractJobIterationPlan" %>
<%@page import="com.urbancode.ubuild.domain.workflow.JobIterationPlan" %>
<%@page import="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks"%>
<%@page import="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.library.workflow.WorkflowDefinitionTasks" />
<ah3:useConstants class="com.urbancode.ubuild.domain.workflow.JobIterationPlan" />

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<c:url var="imgUrl" value="/images"/>
<c:url var="saveJobConfigIterationPropsUrl" value="${WorkflowDefinitionTasks.saveJobConfigIterationProps}"/>

<%-- CONTENT --%>
<script type="text/javascript">
  /* <[CDATA[ */

function addProperty() {
    // do validation
    var propName = $('newPropertyName').value;
    var propValue = $('newPropertyValue').value;

    if (!propName) {
        alert("${ub:i18n('LibraryWorkflowIterationPropertyNameMessage')}");
    }
    else {
        var table = $('JobIterationsTable');

        table.select('thead tr').each(
            function(row) {
                var propIndex = row.cells.length - 1;
                row.insert(
                    new Element('th', { style: 'text-align: left;', nowrap: 'nowrap' })
                        .insert(
                            new Element('input', { type: 'text', size: 15, id: 'prop-name:' + propIndex,
                                name: 'prop-name:' + propIndex, value: propName })
                        )
                        .insert('&nbsp;')
                        .insert(new Element('a', { title: 'Delete Property', style: 'cursor: pointer;' })
                            .insert(new Element('img', { src: '${ah3:escapeJs(imgUrl)}/icon_delete.gif', border: '0' }))
                            .observe('click', function(event) { deleteProperty(this); })
                        )
                );
            }
        );

        table.select('tbody tr').each(
            function(row) {
                var iterationName = $('iteration-name-label:' + row.rowIndex).innerHTML;
                row.insert(
                    new Element('td')
                        .insert(
                            new Element('input', { type: 'text', value: propValue,
                                title: iterationName + ', ' + propName,
                                id: 'prop-value:' + row.rowIndex + ":" + (row.cells.length - 1),
                                name: 'prop-value:' + row.rowIndex + ":" + (row.cells.length - 1)})
                        )
                );
            }
        );

        $('newPropertyName').value = "";
        $('newPropertyValue').value = "";

        var message = $('message');
        message.classNames().each(function(className) { message.removeClassName(className); });
        message.addClassName('success');
        message.update("${ub:i18nMessage('LibraryWorkflowIterationPropertyAddedMessage', propName)}").show();
    }
}

function setProperty() {
    // do validation
    var propName = $('newPropertyName').value;
    var propValue = $('newPropertyValue').value;

    if (!propName) {
        alert("${ub:i18n('LibraryWorkflowIterationPropertyNameMessage')}");
    }
    else {
        var table = $('JobIterationsTable');

        var existingProperty = null;
        var overwriteValues = false;

        // compare the property name to existing names
        for (var p=0; p<table.rows[0].cells.length - 1; p++) {
            if ($('prop-name:' + p).value == propName) {
                existingProperty = p;
                // check if the existing property has iterations with values
                for (var i=1; i<table.rows.length; i++) {
                    if ($('prop-value:' + i + ':' + p).value) {
                        if (basicConfirm("${ub:i18nMessage('LibraryWorkflowIterationPropertyDuplicateMessage', propName)}")) {
                            // overwrite existing values
                            overwriteValues = true;
                        }
                        break;
                    }
                }
                break;
            }
        }

        if (!existingProperty) {
            addProperty();
        }
        else {
            for (var i=1; i<table.rows.length; i++) {
                var iterationPropertyValue = $('prop-value:' + i + ':' + p).value;
                if (!iterationPropertyValue || overwriteValues) {
                    $('prop-value:' + i + ':' + p).value = propValue;
                }
            }
        }
    }
}

function deleteProperty(element) {
    element = $(element);
    var table = element.up('table');
    var row = element.up('tr');
    var th = element.up('th');
    var cellIndex = th.cellIndex;
    var propIndex = cellIndex - 1;
    var propertyName = $('prop-name:' + propIndex).value;
    if (confirmDelete(propertyName)) {
        table.select('tr').each(
            function(row) {
                row.deleteCell(cellIndex);
            }
        );
        // adjust things right of it
        for (var c=cellIndex; c<row.cells.length; c++) {
            $('prop-name:' + c).name = 'prop-name:' + (c - 1);
            $('prop-name:' + c).id = 'prop-name:' + (c - 1);

            for (var i=1; i<table.rows.length; i++) {
                $('prop-value:' + i + ':' + c).name = 'prop-value:' + i + ':' + (c - 1);
                $('prop-value:' + i + ':' + c).id = 'prop-value:' + i + ':' + (c - 1);
            }
        }

        var message = $('message');
        message.classNames().each(function(className) { message.removeClassName(className); });
        message.addClassName('success');
        message.update("${ub:i18nMessage('LibraryWorkflowIterationPropertyDeletedMessage', propertyName)}").show();
    }
}

function deleteIteration(element) {
    element = $(element);
    var table = element.up('table');
    var row = element.up('tr');
    var iteration = row.rowIndex;
    var iterationName = $('iteration-name-label:' + iteration).innerHTML;
    if (confirmDelete(iterationName)) {
        // delete the row
        table.rows[iteration].remove();
        // adjust things below it
        for (var i=iteration + 1; i<=table.rows.length; i++) {
            if (!$('iteration-name:' + i).value) {
                $('iteration-name-label:' + i).update(i18n("LibraryWorkflowIteration", (i-1)));
            }
            for (var c=0; c<table.rows[0].cells.length-1; c++) {
                var tempIterationName = $('iteration-name-label:' + i).innerHTML;
                var tempPropName = $('prop-name:' + c).value;
                $('prop-value:' + i + ':' + c).title = tempIterationName + ', ' + tempPropName;
                $('prop-value:' + i + ':' + c).name = 'prop-value:' + (i - 1) + ':' + c;
                $('prop-value:' + i + ':' + c).id = 'prop-value:' + (i - 1) + ':' + c;
            }
            $('iteration-name:' + i).name = 'iteration-name:' + (i - 1);
            $('iteration-name:' + i).id = 'iteration-name:' + (i - 1);
            $('iteration-name-change:' + i).name = 'iteration-name-change:' + (i - 1);
            $('iteration-name-change:' + i).id = 'iteration-name-change:' + (i - 1);
            $('iteration-name-label:' + i).id = 'iteration-name-label:' + (i - 1);
            $('iteration-name-edit:' + i).id = 'iteration-name-edit:' + (i - 1);
        }

        var message = $('message');
        message.classNames().each(function(className) { message.removeClassName(className); });
        message.addClassName('success');
        message.update("${ub:i18nMessage('LibraryWorkflowIterationDeletedMessage', iterationName)}").show();
    }
}

function addIteration() {
    var table = $('JobIterationsTable');
    if (table.rows.length <= 1) { // no rows other than the header - insert direct
        insertIteration(table.rows[0]);
    }
    else { // select a row to insert after
        insertingIteration = true;
        var message = $('message');
        message.classNames().each(function(className) { message.removeClassName(className); });
        message.addClassName('success');
        message.update("${ub:i18n('LibraryWorkflowIterationAddMessage')}").show();
    }
}

function insertIteration(element) {
    element = $(element);
    var table = $('JobIterationsTable');
    var iteration = element.rowIndex + 1;
    var newRow = new Element('tr');
    newRow.addClassName('iteration');
    newRow.observe('click', function(event) { iterationClick(this); });

    // adjust things below it
    for (var i=table.rows.length - 1; i>=iteration; i--) {
        var newIteration = i + 1;
        if (!$('iteration-name:' + i).value) {
            $('iteration-name-label:' + i).update(i18n("LibraryWorkflowIteration", newIteration));
        }
        for (var c=0; c<table.rows[0].cells.length-1; c++) {
            var iterationName = $('iteration-name-label:' + i).innerHTML;
            var propName = $('prop-name:' + c).value;
            $('prop-value:' + i + ':' + c).title = iterationName + ', ' + propName;
            $('prop-value:' + i + ':' + c).name = 'prop-value:' + newIteration + ':' + c;
            $('prop-value:' + i + ':' + c).id = 'prop-value:' + newIteration + ':' + c;
        }
        $('iteration-name:' + i).name = 'iteration-name:' + newIteration;
        $('iteration-name:' + i).id = 'iteration-name:' + newIteration;
        $('iteration-name-change:' + i).name = 'iteration-name-change:' + newIteration;
        $('iteration-name-change:' + i).id = 'iteration-name-change:' + newIteration;
        $('iteration-name-label:' + i).id = 'iteration-name-label:' + newIteration;
        $('iteration-name-edit:' + i).id = 'iteration-name-edit:' + newIteration;
    }

    // create the first cell for managing the iteration name and deletion
    var nameCell = new Element('td', { style: 'white-space:nowrap;' })
       .insert(new Element('div')
           .insert(new Element('div', { style: 'float: right; margin-left: 15px;' })
               .insert(new Element('a', { title: "${ub:i18n('LibraryWorkflowIterationDelete')}", style: 'cursor: pointer;' })
                   .insert(new Element('img', { src: '${ah3:escapeJs(imgUrl)}/icon_delete.gif', border: '0' }))
                   .observe('click', function(event) { deleteIteration(this); })
               )
           )
           .insert(new Element('input', { type: 'hidden', id: 'iteration-name:' + iteration, name: 'iteration-name:' + iteration }))
           .insert(new Element('span', { id: 'iteration-name-label:' + iteration })
               .update(i18n("LibraryWorkflowIteration", iteration))
               .observe('click', function(event) { editIterationName(this); })
           )
           .insert(new Element('span', { id: 'iteration-name-edit:' + iteration, style: "display: none;" })
               .insert(new Element('input', { type: 'text', id: 'iteration-name-change:' + iteration,
                   name: 'iteration-name-change:' + iteration })
                   .observe('blur', function(event) { editIterationName(this); })
               )
           )
           .addClassName('iterationName')
       )
    ;
    newRow.insert(nameCell);

    // create additional cells for properties
    for (var i=1; i<table.rows[0].cells.length; i++) {
        var propName = $('prop-name:' + (i-1)).value;
        var inputId = 'prop-value:' + iteration + ':' + (i-1);
        newRow.insert(new Element('td')
            .insert(new Element('div')
                 .insert(new Element('input', { type: 'text', id: inputId, name: inputId,
                      title: 'Iteration ' + iteration + ', ' + propName }))
                 .addClassName('propertyValue')
            )
        );
    }

    element.insert({ after: newRow });

    var message = $('message');
    message.classNames().each(function(className) { message.removeClassName(className); });
    message.addClassName('success');
    message.update("${ub:i18nMessage('LibraryWorkflowIterationAddedMessage', iteration)}").show();
}

function editIterationName(element) {
    element = $(element);
    var table = element.up('table');
    var row = element.up('tr');
    var iteration = row.rowIndex;

    if ($('iteration-name-edit:' + iteration).visible()) {
        var currentIterationName = $('iteration-name:' + iteration).value;
        var iterationName = $('iteration-name-change:' + iteration).value;
        $('iteration-name:' + iteration).value = iterationName;
        if (!iterationName) {
            $('iteration-name-label:' + iteration).update(i18n("LibraryWorkflowIteration", iteration));
        }
        else {
            $('iteration-name-label:' + iteration).update(iterationName);
        }
        element.title = i18n("LibraryWorkflowIterationTitle");
        $('iteration-name-edit:' + iteration).hide();
        $('iteration-name-label:' + iteration).show();

        if (iterationName != currentIterationName) {
            var message = $('message');
            message.classNames().each(function(className) { message.removeClassName(className); });
            message.addClassName('success');
            var label = $('iteration-name-label:' + iteration).innerHTML;
            message.update("${ub:i18nMessage('LibraryWorkflowIterationEditMessage', label)}").show();
        }
    }
    else {
        $('iteration-name-label:' + iteration).hide();
        $('iteration-name-edit:' + iteration).show();
        $('iteration-name-change:' + iteration).focus();
    }
}

var insertingIteration = false;

function iterationClick(element) {
    element = $(element);
    if (insertingIteration) {
        insertingIteration = false;
        insertIteration(element);
    }
}
  /* ]]> */
</script>

<style>
div.iterationName {
  height: 15px;
}
div.propertyName {
  height: 15px;
}
div.propertyValue {
  height: 18px;
}
.highlight {
  background: #ddddcd;
}
#JobIterationsTable td {
  border-left: 1px solid #dbdbdb;
  border-right: 1px solid #dbdbdb;
}
#JobIterationsTable th input {
    background: none;
    border: none;
    height: 100%;
    color: #80807B;
    font-style: italic;
}
#JobIterationsTable td input {
    background:none;
    border:none;
    height: 100%;
    width: 100%;
}
th {
    padding-left:10px;
}
</style>

<div class="system-helpbox">
  ${ub:i18n("LibraryWorkflowIterationPropertySystemHelpBox")}
</div>

<div id="message" style="margin-top: 15px;">&nbsp;</div>

<error:field-error field="workflowDef" cssClass="${eo.next}"/>

<form method="post" action="${fn:escapeXml(saveJobConfigIterationPropsUrl)}">
  <input type="hidden" name="<%=WorkflowDefinitionTasks.SELECTED_WORKFLOW_DEFINITION_JOB_CONFIG_ID%>" value="${selectedWorkflowDefinitionJobConfig.id}">

  <div style="padding: 1px; overflow: auto; margin-top: 1em; width: 100%;">
    <table id="JobIterationsTable" class="data-table" style="z-index: 1;">
      <thead>
        <tr>
          <th style="text-align: left;" nowrap="nowrap">
            <div class="iterationName">${ub:i18n("LibraryWorkflowIterationName")}&nbsp;&nbsp;<a title="${ub:i18n('LibraryWorkflowIterationAdd')}"
            onclick="addIteration();" style="cursor: pointer;"><img src="${fn:escapeXml(imgUrl)}/icon_add.gif" border="0"/></a></div>
          </th>
          <c:set var="iterationPropertyNames" value="${iterationPlan.propertyNames}"/>
          <c:forEach var="propertyName" items="${iterationPropertyNames}" varStatus="i">
            <th style="text-align: left;" nowrap="nowrap">
              <ucf:text name="prop-name:${i.index}" id="prop-name:${i.index}" value="${propertyName}" size="15"
              />&nbsp;<a title="${ub:i18n('LibraryWorkflowIterationDeleteProp')}" onclick="deleteProperty(this);" style="cursor: pointer;"><img
              src="${fn:escapeXml(imgUrl)}/icon_delete.gif" border="0"/></a>
            </th>
          </c:forEach>
        </tr>
      </thead>
      <tbody>
        <%
        AbstractJobIterationPlan iterationPlan = (AbstractJobIterationPlan) pageContext.findAttribute("iterationPlan");
        int iterationDisplayLimit = Math.max(iterationPlan.getIterations(), iterationPlan.getMaxIterationWithNameOrProperties());
        for (int iteration = 1; iteration<=iterationDisplayLimit; iteration++) {
            pageContext.setAttribute("iteration", iteration);
            pageContext.setAttribute("iterationName", iterationPlan.getIterationName(iteration));
            %>
          <tr class="iteration" onclick="iterationClick(this);">
            <td nowrap="nowrap">
              <div class="iterationName">
                <div style="float: right; margin-left: 15px;">
                  <a title="${ub:i18n('LibraryWorkflowIterationDelete')}" onclick="deleteIteration(this);" style="cursor: pointer;"><img
                     src="${fn:escapeXml(imgUrl)}/icon_delete.gif" border="0"/></a>
                </div>
                <input type="hidden" id="iteration-name:${iteration}"
                       name="iteration-name:${iteration}" value="${fn:escapeXml(iterationName)}"/>
                <span id="iteration-name-label:${iteration}" onclick="editIterationName(this);">
                    <c:out value="${iterationName}" default="${ub:i18nMessage('LibraryWorkflowIteration', iteration)}"/></span>
                <span id="iteration-name-edit:${iteration}" style="display: none;">
                  <input type="text" name="iteration-name-change:${iteration}"
                     id ="iteration-name-change:${iteration}"
                     onBlur="editIterationName(this);"
                     value="${fn:escapeXml(iterationName)}"/>
                </span>
              </div>
            </td>
            <c:forEach var="propertyName" items="${iterationPropertyNames}" varStatus="i">
              <%
              String propertyName = (String) pageContext.findAttribute("propertyName");
              pageContext.setAttribute("property", iterationPlan.getIterationProperty(iteration, propertyName));
              %>
              <td>
                <input type="text" name="prop-value:${iteration}:${i.index}"
                   id="prop-value:${iteration}:${i.index}"
                   title="${fn:escapeXml(iterationName)}, ${fn:escapeXml(propertyName)}"
                   value="${fn:escapeXml(property.value)}"/>
              </td>
            </c:forEach>
          </tr>
            <%
        }
        %>
      </tbody>
    </table>
  </div>

  <br/>

  <div>
      <table class="addProperty">
      <tr>
        <td colspan="5">
          <h3>${ub:i18n("LibraryWorkflowIterationSetProp")}</h3>
        </td>
      </tr>
      <tr>
        <td style="padding-top: 10px;"><span class="bold">&nbsp;&nbsp;&nbsp;${ub:i18n("NameWithColon")}</span></td>
        <td>
          <input id="newPropertyName"  name="newPropertyName" value="" size="22" class="" type="text">
        </td>
        <td style="padding-top: 10px;"><span class="bold">&nbsp;&nbsp;&nbsp;${ub:i18n("ValueWithColon")}</span></td>
        <td>
          <input id="newPropertyValue" name="newPropertyValue" value="" size="22" class="" type="text">
        </td>
        <td>&nbsp;
          <a class="button" onclick="setProperty();"
             >${ub:i18n("Set")}</a>
          <a class="button" onclick="$('newPropertyName').value = ''; $('newPropertyValue').value = '';"
             >${ub:i18n("Cancel")}</a>
        </td>
      </tr>
    </table>
  </div>

  <br/>

  <ucf:button name="save" label="${ub:i18n('Save')}"/>
  <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" onclick="window.parent.hidePopup();" submit="false"/>
</form>
