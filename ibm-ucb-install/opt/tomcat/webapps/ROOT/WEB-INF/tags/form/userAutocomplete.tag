<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>

<%@attribute name="name"         required="true" type="java.lang.String"%>
<%@attribute name="list"         required="true"  type="java.lang.Object"%><%-- list of items with getName and getId --%>
<%@attribute name="selectedObject" required="false" type="java.lang.Object"%><%-- items with getName and getId --%>
<%@attribute name="canUnselect"  required="false" type="java.lang.Boolean"%>
<%@attribute name="emptyMessage" required="false" type="java.lang.String"%>
<%@attribute name="enabled"      required="false" type="java.lang.Boolean"%>
<%@attribute name="id"           required="false" type="java.lang.String"%>
<%@attribute name="size"         required="false" type="java.lang.Integer"%>
<%@attribute name="selectedList" required="false" type="java.lang.Object"%><%-- list of items with getName and getId --%>
<%@attribute name="selectedText" required="false" type="java.lang.String"%><%-- string of initial selection --%>
<%@attribute name="onChange"     required="false" type="java.lang.String"%><%-- used for executing stuff when something changes --%>
<%@attribute name="autoCompleteId" required="false" type="java.lang.String"%><%-- used for overriding autocompleteId to something known instead of uuid --%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:set var="enabled" value="${enabled == null || enabled}"/>

<c:if test="${empty size}"><c:set var="size" value="20"/></c:if>
<c:if test="${empty emptyMessage}"><c:set var="emptyMessage" value="${ub:i18n('None')}"/></c:if>

<c:set var="emptyMessage" value="-- ${emptyMessage} --"/>

<%
  if(jspContext.getAttribute("autoCompleteId")==null) {
    jspContext.setAttribute("autoCompleteId", java.util.UUID.randomUUID());
  }
%>

<%-- CONTENT --%>

<script type="text/javascript">
  /* <![CDATA[ */
    document.observe('dom:loaded', function(event) { // no need to put in the header, no JS i18n used
        var section = $('autocomplete-${autoCompleteId}');
        var autoCompleteTextInput = section.down('input[type="text"]');
        var autoCompleteHiddenInput = section.down('input[type="hidden"]');
        var autoCompleteDisplay = section.down('.autocomplete-display');

        var emptyMessage = "${emptyMessage}";
        var values = [
            <c:forEach var="element" items="${list}" varStatus="loop">
            <c:choose>
              <c:when test="${not empty element.actualName}">
                <c:set var="fullName" value="${element.actualName} "/>
              </c:when>
              <c:otherwise>
                <c:set var="fullName" value=""/>
              </c:otherwise>
            </c:choose>
            <c:choose>
            <c:when test="${not empty element.emailAddress}">
              <c:set var="emailAddress" value=" - ${element.emailAddress}"/>
            </c:when>
            <c:otherwise>
              <c:set var="emailAddress" value=""/>
            </c:otherwise>
          </c:choose>
            { 'name': '${fn:escapeXml(fullName)}(${fn:escapeXml(element.name)})${fn:escapeXml(emailAddress)}', 'id': '${element.id}' }<c:if test="${not loop.last}">,</c:if>
            </c:forEach>
        ];


        /**
         * Highlight the selected snippet occuring at matchindex within the full string
         * @param full
         * @param snippet
         * @param matchindex
         */
        var highlightMatch = function(full, snippet, matchindex) {
            return full.substring(0, matchindex) +
                    "<b>" + full.substr(matchindex, snippet.length) + "<\/b>" +
                    full.substring(matchindex + snippet.length);
        };


        /**
         * return subset #values which matches the sQuery
         * @param sQuery
         */
        var matchValues = function(sQuery) {
            var matches = new Array();

            // Case insensitive matching
            sQuery = decodeURIComponent(sQuery);
            var query = sQuery.toLowerCase();
            var matchFromStart = query.length == 0 || query.charAt(0) != '*';
            if (!matchFromStart) {
                query = query.substring(1);
            }

            // Match against each name of each contact
            if (query || !matchFromStart) {
                values.each(function(value){
                    var matchIndex = value.name.toLowerCase().indexOf(query);
                    if (matchFromStart ? matchIndex == 0 : matchIndex > -1) {
                        matches.push(value);
                    }
                });
            }

            if (matches.length == 0) {
                return [{'name':emptyMessage, 'id':''}];
            }

            return matches;
        };

        var dataSource = new YAHOO.util.FunctionDataSource(matchValues);
        dataSource.responseSchema = { 'fields':["name", "id"] }

        // Instantiate the AutoComplete
        var autoComplete = new YAHOO.widget.AutoComplete(autoCompleteTextInput, autoCompleteDisplay, dataSource,
                {
                    'forceSelection': false,
                    'typeAhead': false, // setting to true messes with the '*' wildcard
                    'queryDelay': 0.5,
                    'minQueryLength': 0, // allow length 0 so we can return our '-- Any --' Field
                    'maxResultsDisplayed': 500,
                    'useIFrame' : true
                });
        autoComplete.resultTypeList = false;

        // Custom formatter to highlight the matching letters
        autoComplete.formatResult = function(oResultData, sQuery, sResultMatch) {
            var query = sQuery.toLowerCase();
            var name = oResultData.name;
            if (query.length > 0 && query.charAt(0) == '*') {
                query = query.substring(1);
            }
            var nameMatchIndex = name.toLowerCase().indexOf(query);
            return highlightMatch(name, query, nameMatchIndex);
        };
        //define on onChange event handler
        <c:if test='${! empty onChange}'>
            var changeFunc = (function(){${onChange}}).bind(autoCompleteTextInput);
            autoComplete.textboxChangeEvent.subscribe(changeFunc);
        </c:if>
        // Define an event handler to populate a hidden form field when an item gets selected
        var itemSelectionHandler = function(sType, aArgs) {
            var myAC = aArgs[0]; // reference back to the AC instance
            var elLI = aArgs[1]; // reference to the selected LI element
            var oData = aArgs[2]; // object literal of selected item's result data

            // update hidden form field with the selected item's ID
            autoCompleteHiddenInput.value = oData.id;
            //delete unneccessary hidden fields
            <c:if test='${canUnselect}'>
                nextSib = autoCompleteHiddenInput.nextSibling;
                while(nextSib) {
                    autoCompleteHiddenInput.parentNode.removeChild(nextSib);
                    nextSib = autoCompleteHiddenInput.nextSibling;
                }
            </c:if>
            <c:if test='${! empty onChange}'>
                changeFunc();
            </c:if>
        };
        autoComplete.itemSelectEvent.subscribe(itemSelectionHandler);

        <c:if test='${canUnselect}'>
            var unmatchedItemSelectHandler = function(sType, aArgs) {
                autoCompleteHiddenInput.value='';
                matchValues(autoCompleteTextInput.value).each(function(match) {
                    if(!autoCompleteHiddenInput.value) {
                        nextSib = autoCompleteHiddenInput.nextSibling;
                        while(nextSib) {
                            autoCompleteHiddenInput.parentNode.removeChild(nextSib);
                            nextSib = autoCompleteHiddenInput.nextSibling;
                        }
                        if(match.id) {
                            autoCompleteHiddenInput.value=match.id;
                        } else if(autoCompleteTextInput.value == emptyMessage) {
                            autoCompleteHiddenInput.value='';
                        } else {
                            autoCompleteHiddenInput.value='-1';
                        }
                    }
                    else {
                        newInput = document.createElement('input');
                        <c:if test="${! empty id}">
                            newInput.setAttribute('id', "${id}");
                        </c:if>
                        newInput.setAttribute('name', "${name}");
                        newInput.setAttribute('value', match.id);
                        newInput.setAttribute('type', "hidden");
                        autoCompleteHiddenInput.parentNode.insertBefore(newInput, null);
                    }
                });
            }
            autoComplete.unmatchedItemSelectEvent.subscribe(unmatchedItemSelectHandler);
        </c:if>

        autoCompleteTextInput.observe('focus', function(it){this.select()});
    });

 /* ]]> */
</script>

<div id="autocomplete-${autoCompleteId}" class="yui-skin-sam">
  <div style="width: ${size}em; padding-bottom: 2em;">
    <c:choose>
      <c:when test="${canUnselect}">
        <ucf:text name="auto-complete-${autoCompleteId}" value="${empty selectedText ? emptyMessage : selectedText}" size="${size}" enabled="${enabled}"/>
      </c:when>
      <c:otherwise>
        <ucf:text name="auto-complete-${autoCompleteId}" value="${selectedObject == null ? emptyMessage : selectedObject.name}" size="${size}" enabled="${enabled}"/>
      </c:otherwise>
    </c:choose>
    <div class="autocomplete-display"></div>
  </div>
  <c:choose>
      <c:when test="${canUnselect && (! empty selectedList)}">
          <c:forEach var="selected" items="${selectedList}">
              <input <c:if test="${!empty id}">id="${fn:escapeXml(id)}" </c:if> name="${fn:escapeXml(name)}" value="${selected.id}" type="hidden"/>
          </c:forEach>
      </c:when>
      <c:otherwise>
          <input <c:if test="${!empty id}">id="${fn:escapeXml(id)}" </c:if> name="${fn:escapeXml(name)}" value="${selectedObject.id}" type="hidden"/>
      </c:otherwise>
  </c:choose>
</div>
