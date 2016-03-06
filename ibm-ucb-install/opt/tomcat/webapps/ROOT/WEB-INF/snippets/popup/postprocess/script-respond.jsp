<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.web.WebConstants" %>
<%@page import="com.urbancode.ubuild.web.admin.workdir.*" %>
<%@page import="com.urbancode.ubuild.web.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>

<script language="JavaScript" type="text/javascript">
  /* <![CDATA[ */
    function respond() {
    <c:if test="${script.id != null}">
            var origWindow = window.opener;
            if (origWindow != null ) {
                var selectorElement = getWindowElementById(origWindow, 'postprocessscriptchooser');
                if (selectorElement != null) {
                    var text = '${ah3:escapeJs(script.name)}';
                    var value = '${ah3:escapeJs(script.id)}';

                    // search to see if it is an existing item in the list
                    //  if so, ensure it is selected and has current name
                    var found = false;
                    for (i=0; i<selectorElement.options.length && !found; i+=1) {
                        if (selectorElement.options[i].value == value) {
                            selectorElement.options[i].text = text;
                            selectorElement.selectedIndex = i;
                            found=true;
                        }
                    }

                    // if it is a new item (not in list), add to list and select
                    if (!found) {
                        var newIndex = selectorElement.options.length;
                        selectorElement.options.length = newIndex+1;
                        selectorElement.options[newIndex].text = text;
                        selectorElement.options[newIndex].value = value;
                        selectorElement.selectedIndex = newIndex;
                    }
                }
                else {
                    alert('did not find element for postprocessscriptchooser');
                }
      <%-- scan for other options perhaps: radio, checkbox, etc --%>
              }
              else {
                  alert('opener window not found: null');
              }
    </c:if>
            window.close();
        }
  /* ]]> */
</script>