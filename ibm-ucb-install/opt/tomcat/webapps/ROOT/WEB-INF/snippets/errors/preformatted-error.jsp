<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ taglib uri="error" prefix="error" %>
<tr class="error <%= request.getAttribute("cssClass") %>">
  <td colspan="3">
    <span class="error <%= request.getAttribute("cssClass") %>">
      <pre>
        <error:message field='<%= (String) request.getAttribute("field") %>' />
      </pre>
    </span>
  </td>
</tr>