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

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="additionalImports" scope="request">
    <c:url var="baseUrl" value="/" />
    <c:set var="libUrl" value="${baseUrl}lib" />
    <script src="${libUrl}/react/react.min.js"></script>
    <script src="${libUrl}/react-bootstrap/react-bootstrap.min.js"></script>
    <script src="${libUrl}/bootstrap/js/bootstrap.min.js"></script>
</c:set>
