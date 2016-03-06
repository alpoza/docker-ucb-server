<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag import="com.urbancode.ubuild.web.WebConstants"%>

<%@attribute name="sourceConfig" type="java.lang.Object" required="true"%>
<%@attribute name="disabled" type="java.lang.Boolean"%>
<%@attribute name="eo" type="com.urbancode.ubuild.web.util.EvenOdd"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="error" prefix="error"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:set var="fileExcludePattern" value="${sourceConfig.filepathExcludeString}"/>
<c:set var="userExcludePattern" value="${sourceConfig.userExcludeString}"/>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<error:field-error field="userExcludePatterns" cssClass="${eo.next}"/>
<tr class="${fn:escapeXml(eo.last)}" valign="top">
  <td align="left" width="20%">
    <span class="bold">${ub:i18n("UsersToExclude")}</span>
  </td>
  <td align="left" width="20%">
      <ucf:textarea rows="4"
                    cols="30"
                    name="userExcludePatterns"
                    value="${userExcludePattern}"
                    enabled="${!disabled}"/>
  </td>
  <td align="left">
    <span class="inlinehelp">
        ${ub:i18n("UsersToExcludeDesc")}
    </span>
  </td>
</tr>

<error:field-error field="filepathExcludeString" cssClass="${eo.next}"/>
<tr class="${fn:escapeXml(eo.last)}">
  <td align="left" width="20%">
    <span class="bold">${ub:i18n("FilePathsToExclude")}</span>
  </td>
  <td>
      <ucf:textarea rows="8" 
                    cols="30" 
                    name="filepathExcludePatterns" 
                    value="${fileExcludePattern}"
                    enabled="${!disabled}"/>
  </td>
  <td align="left">
    <span class="inlinehelp">
        ${ub:i18n("FilePathsToExcludeDesc")}
    </span>
  </td>
</tr>
