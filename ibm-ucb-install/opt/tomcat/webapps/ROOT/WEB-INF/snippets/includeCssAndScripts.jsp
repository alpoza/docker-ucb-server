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

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="jwr" uri="http://jawr.net/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.WebConstantsTasks"/>

<c:url var="WebConstantsUrl" value="${WebConstantsTasks.getConstants}"/>

<%-- ======= --%>
<%-- CONTENT --%>
<%-- ======= --%>
  <meta http-equiv="Content-Script-Type" content="text/javascript"/>
  <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>

  <%-- ===================================================================== --
  <%-- CSS                                                                   --
  <%-- ===================================================================== --%>
  <c:url var="oneuiUrl" value="/lib/idx/themes/oneui/oneui.css" />

  <jwr:style src="/bundles/yui.cssb" />
  <jwr:style src="/bundles/codemirror.cssb" />
  <jwr:style src="/bundles/webext.cssb" />
  <jwr:style src="/bundles/dojo.cssb" />
  <link rel="stylesheet" type="text/css" href="${oneuiUrl}"/>
  <jwr:style src="/bundles/ubuild.cssb" />
  <%-- make the suggestion box for auto-complete scroll instead of becoming incredibly tall --%>
  <style type="text/css">
    .yui-skin-sam .yui-ac-content { max-height: 16em; overflow-y:auto; }
  </style>
  <!--[if lt IE 7]>
  <style type="text/css">
    .yui-skin-sam .yui-ac-content { height: 16em; overflow-y:auto; }
  </style>
  <![endif]-->

  <!-- This special IE comment simulates the "fixed" position for IE6. -->
  <!--[if lt IE 7]>
    <jwr:style src="/bundles/ie.cssb" />
  <![endif]-->



  <%-- ===================================================================== --
  <%-- JavaScript                                                            --
  <%-- ===================================================================== --%>
  <jwr:script src="/bundles/prototype.jsb"/>
  <jwr:script src="/bundles/yui.jsb"/>
  <jwr:script src="/bundles/codemirror.jsb"/>
  <jwr:script src="/bundles/ubuild.jsb"/>
  <script>
    $.noConflict();
  </script>

  <%-- URBANCODE CUSTOM LIBS (based on prototype) --%>
  <script type="text/javascript" src="${fn:escapeXml(WebConstantsUrl)}"></script>

  <%--
  <!--[if IE]>
    <script type="text/javascript">
      /* <![CDATA[ */
      if (document.compatMode=='BackCompat') {
        Element.observe(window, 'load', function() { window.alert('Page rendered in Quirks-mode!!')});
      }
      /* ]]> */
    </script>
  <![endif]-->
 --%>

  ${requestScope.additionalImports}
  <jsp:include page="/WEB-INF/snippets/dojo.jsp"/>
