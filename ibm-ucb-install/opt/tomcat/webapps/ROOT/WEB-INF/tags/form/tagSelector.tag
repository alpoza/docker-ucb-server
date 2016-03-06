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
<%@attribute name="enabled"      required="false" type="java.lang.Boolean"%>
<%@attribute name="size"         required="false" type="java.lang.Integer"%>
<%@attribute name="id" required="false" type="java.lang.String"%><%-- used for overriding autocompleteId to something known instead of uuid --%>
<%@attribute name="existingTags" required="false" type="java.lang.Object" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<%@tag import="java.util.Set" %>
<%@tag import="com.urbancode.ubuild.domain.project.ProjectFactory" %>

<c:set var="enabled" value="${enabled == null || enabled}"/>

<c:if test="${empty size or size eq 0}"><c:set var="size" value="20"/></c:if>

<c:set var="valueType" value="${empty valueType ? 'id' : valueType}"/>

<%
  if(jspContext.getAttribute("id") == null) {
    jspContext.setAttribute("id", java.util.UUID.randomUUID());
  }
  Set<String> tags = ProjectFactory.getInstance().restoreAllTags();
%>

<%-- CONTENT --%>
<c:url var="iconDeleteUrl" value="/images/icon_X.gif"/>
<c:url var="iconDeleteDisabledUrl" value="/images/icon_X_disabled.gif"/>
<script type="text/javascript">
    require(["dojo/ready", "dojo/on", "dojo/keys", "dojo/store/Memory", "dijit/form/ComboBox"], function(ready, on, keys, Memory, ComboBox) {
        var tagList = [];
        <%
           for (String tag : tags) {
               jspContext.setAttribute("tagText", tag.trim());
        %>
               tagList.push({
                   "name": "${tagText}",
                   "id": "${tagText}"
               });
       <%
           }
        %>
        var tagStore = new Memory({
            data: tagList
        });
        
        var comboBox = new ComboBox({
            id: "tagSelect",
            name: "tagSelect",
            store: tagStore,
            searchAttr: "name",
            disabled: ${!enabled}
        }, "tagSelect");
        
        function addNewTag() {
            var autocomplete = jQuery("input[name='tagSelect']");
            var tagName = autocomplete.val();
            if (tagName) {
                var encodedName = jQuery('<div/>').text(tagName).html();
                var existingElement = document.getElementById(encodedName);
                if (!existingElement) {
                    var list = document.getElementById('existingTags');
                    var divToAdd = createTagDiv(encodedName.trim());
                    list.appendChild(divToAdd);
                }
                autocomplete.val("");
            }
        }
        
        function createTagDiv(tagName) {
            var divToAdd = document.createElement("div");
            divToAdd.setAttribute("id", tagName);
            divToAdd.className = "tagBox withComboBox";
            
            var hidden = createHiddenField("tag", tagName);
            var remLink = createDeleteLink(tagName);
            var nameNode = document.createElement("div");
            nameNode.className = "tagName";
            nameNode.innerHTML = tagName;
            
            divToAdd.appendChild(hidden);
            divToAdd.appendChild(nameNode);
            if (remLink) {
                divToAdd.appendChild(remLink);
            }
            return divToAdd;
        }
          
        function removeTag(tagName) {
            var tagSpan = document.getElementById(tagName);
            if (tagSpan) {
                tagSpan.parentNode.removeChild(tagSpan);
            }
        }
        
        function createHiddenField(name, value) {
            var hidden = document.createElement("input");
            hidden.setAttribute("type", "hidden");
            hidden.setAttribute("name", name);
            hidden.setAttribute("value", value);
            
            return hidden;
        }
        
        function createDeleteLink(itemName) {
            var remLink = null;
            if ("${enabled}" == "true") {
                remLink = document.createElement("div");
                remLink.className = "tagDelete";
                var delButton = document.createTextNode("x");
                remLink.appendChild(delButton);
                on(remLink, "click", function(event) {
                    removeTag(itemName);
                });
            }
            
            return remLink;
        }
        
        function addExistingTags() {
            var list = document.getElementById('existingTags');
            <c:forEach var="element" items="${existingTags}">
                var name = "${element}";
                var divToAdd = createTagDiv(name.trim());
                list.appendChild(divToAdd);
            </c:forEach>
        }
        
        ready(function() {
            addExistingTags();
            var addLink = document.getElementById('addLink');
            if (addLink) {
                document.getElementById('existingTags').className += ' withComboBox';
                on(addLink, "click", function(event) {
                    event.preventDefault();
                    addNewTag();
                });
                on(comboBox, "keydown", function(event) {
                    if (event.keyCode == keys.ENTER) {
                        event.preventDefault();
                        addNewTag();
                        return false;
                    }
                });
            }
        });
    });
</script>

<div id="${id}">
  <c:if test="${enabled}">
    <div>
      <span style="width: ${size}em; padding-bottom: 2em;">
        <input id="tagSelect"/>
      </span>
      <ucf:link id="addLink" href="#" label="${ub:i18n('Add')}" enabled="${enabled}"/>
    </div>
  </c:if>
  <div class="tagDisplay">
    <div id="existingTags" class="tagContainer tagListLeftAlign"></div>
  </div>
</div>