<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
      <div>
        <ul class="navlist">
          <li>
            <a href="javascript:setDest('main');"
<%
    if (request.getParameter("selected").equals("main")) out.print("class=\"current\"");
%>
            >${ub:i18n("Main")}</a>
          </li>
        </ul>
      </div>
