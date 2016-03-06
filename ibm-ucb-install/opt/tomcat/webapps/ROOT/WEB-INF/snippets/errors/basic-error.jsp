<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ taglib uri="error" prefix="error" %>
<p><span class="error">
    <error:message field='<%= (String)request.getAttribute("field") %>' />
</span></p>
