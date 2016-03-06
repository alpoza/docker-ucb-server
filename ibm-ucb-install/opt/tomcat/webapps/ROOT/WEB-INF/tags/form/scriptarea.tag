<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<%@attribute name="id" required="true" type="java.lang.String"%>
<%@attribute name="name" required="true" type="java.lang.String"%>
<%@attribute name="value" required="true" type="java.lang.String"%>
<%@attribute name="cols" required="true" type="java.lang.Integer"%>
<%@attribute name="rows" required="true" type="java.lang.Integer"%>
<%@attribute name="language" required="false" type="java.lang.String"%>
<%@attribute name="enabled" required="false" type="java.lang.Boolean"%>
<%@attribute name="autocomplete" required="false" type="java.lang.Boolean"%>
<%@attribute name="linenumbers" required="false" type="java.lang.Boolean"%>
<%@attribute name="langInputId" required="false" type="java.lang.String"%>

<c:set var="enabled" value="${empty enabled || enabled}"/>
<c:set var="linenumbers" value="${empty linenumbers || linenumbers}"/>

   <c:choose>
       <c:when test="${autocomplete == null || !autocomplete}">
           <c:set var="autocompleteClass" value="autocomplete-off"/>
       </c:when>
       <c:otherwise>
           <c:set var="autocompleteClass" value="autocomplete-on"/>
       </c:otherwise>
   </c:choose>

   <c:choose>
       <c:when test="${language == 'beanshell'}">
           <c:set var="language" value="text/x-java"/>
       </c:when>
       <c:when test="${language == 'class'}">
           <c:set var="language" value=""/>
       </c:when>
       <c:when test="${language == 'gvy' || language == 'groovy'}">
           <c:set var="language" value="groovy"/>
       </c:when>
       <c:when test="${language == 'javascript'}">
           <c:set var="language" value="javascript"/>
       </c:when>
       <%--
       <c:when test="${language == 'jython'}">
           <c:set var="language" value="text/x-python"/>
       </c:when>
       <c:when test="${language == 'jruby'}">
           <c:set var="language" value="text/x-ruby"/>
       </c:when>
       --%>
       <c:otherwise>
           <c:set var="language" value="text/x-java"/>
       </c:otherwise>
   </c:choose>

       <!-- altered -->
   <c:set var="textAreaId" value="scriptarea_${counter.andIncrement}"/>

   <textarea
       id="${fn:escapeXml(textAreaId)}"
       name="${fn:escapeXml(name)}"
       rows="${fn:escapeXml(rows)}"
       cols="${fn:escapeXml(cols)}"
       class=""
       >${fn:escapeXml(value)}</textarea>
       
  <!--[if gt IE 7]><!-->
  
  <script type="text/javascript">
       // create globals for the native input and codemirror objects
       var ${textAreaId} = $(${ah3:toJson(textAreaId)});
       var ${textAreaId}_codemirror = CodeMirror.fromTextArea(${textAreaId}, {
           <%--value: ${ah3:toJson(value)},--%>
           "mode":  ${ah3:toJson(language)},
           "readOnly": ${ah3:toJson(!enabled)},
           "lineNumbers": ${ah3:toJson(linenumbers)},
           "theme":"eclipse"
         });

       (function() {
           // auto-resizing height, but lock width to textarea
           ${textAreaId}_codemirror.setSize(${textAreaId}.getWidth());
           var scroller = ${textAreaId}_codemirror.getScrollerElement();
           scroller.style.minHeight = "" + (${textAreaId}.getHeight() - 20) +"px";
           scroller.style.overflowY = 'auto';
           scroller.style.maxHeight= "30em"; // max resizeable height

           var lang2Mode = {
                   "beanshell":  "text/x-java",
                   "groovy":     "groovy",
                   "javascript": "javascript",
                   "class":      "",
                   "jython":     "text/x-python",
                   "jruby":      "text/x-ruby"
           };

           document.observe("dom:loaded", function() { // no need to put in the header, no JS i18n used
               var langInput = $(${ah3:toJson(langInputId)});
               if (langInput) {
                   langInput.observe('change', function() {
                       var mode = lang2Mode[this.getValue()] || "";
                       ${textAreaId}_codemirror.setOption("mode", mode);
                   });
               }
           });
       }());
       

       //editor.setOption("mode", test ? "scheme" : "javascript");
  </script>
  <!-- <![endif]-->