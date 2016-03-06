<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@tag import="java.util.concurrent.atomic.AtomicInteger"%>

<%@attribute name="name"           required="true" type="java.lang.String"%>
<%@attribute name="list"           required="true"  type="java.lang.Object"%>
<%@attribute name="labels"         required="true"  type="java.lang.Object"%>
<%@attribute name="selectedValues" required="false" type="java.lang.Object"%>
<%@attribute name="enabled"        required="false" type="java.lang.Boolean"%>
<%@attribute name="size"           required="false" type="java.lang.Integer"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:url var="imgUrl" value="/images"/>
<c:set var="enabled" value="${enabled == null || enabled}"/>
<c:if test="${empty size}"><c:set var="size" value="20"/></c:if>

<c:set var="uuid" value="${counter.andIncrement}"/> <%-- get a per-request unique value --%>

<%-- CONTENT --%>
<c:choose>
  <c:when test="${fn:length(list) lt 30}">
    <ucf:stringSelector name="${name}"
        list="${labels}"
        valueList="${list}"
        multiple="true"
        enabled="${enabled}"
        selectedValues="${selectedValues}"/>
  </c:when>
  <c:otherwise>
    <script type="text/javascript">
      /* <![CDATA[ */
        document.observe('dom:loaded', function(event) { // no need to put in the header, no JS i18n used

            // comprehensive list of suggestions
            var options = new Array(${fn:length(list)});
            options.imgUrl = ${ah3:toJson(imgUrl)};
            <c:forEach var="element" items="${list}" varStatus="loop">
            options.push({ 'label':${ah3:toJson(ub:i18n(empty labels[loop.index] ? element : labels[loop.index]))}, 'value':${ah3:toJson(element)}});
            </c:forEach>

            // intially selected values
            var selectedValues = new Array(${fn:length(selectedValues)});
            <c:forEach var="selectedValue" items="${selectedValues}">
            selectedValues.push(${ah3:toJson(selectedValue)});
            </c:forEach>

            new UC_MultiselectInput(${ah3:toJson(name)}, 'multiselect-section-${uuid}', options, selectedValues);
        });
     /* ]]> */
    </script>
    <div id="multiselect-section-${uuid}">
        <ul class="selected-values" style="list-style-type: none; white-space: nowrap; padding:0px">
            <li>&nbsp;</li>
        </ul>
        <div class="yui-skin-sam" style="width: ${size}em; padding-bottom: 2em; position: relative">
            <ucf:text name="multi-select-input-${uuid}"  value=""
                      cssClass="ignoreDirty autocomplete"
                      size="${size}"
                      enabled="${enabled}"/>
            <div class="autocomplete-display">&nbsp;</div>
        </div>
    </div>
  </c:otherwise>
</c:choose>
