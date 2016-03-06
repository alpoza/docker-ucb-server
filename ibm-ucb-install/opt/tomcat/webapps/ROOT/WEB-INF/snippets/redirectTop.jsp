<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <c:import url="/WEB-INF/snippets/includeCssAndScripts.jsp"/>
</head>
<body class="oneui">
<script type="text/javascript">
  /* <![CDATA[ */
    <c:if test="${!empty message}">
        alert('${ah3:escapeJs(message)}');
    </c:if>
    top.location = '${ah3:escapeJs(redirect2Url)}';
  /* ]]> */
</script>
</body>
</html>