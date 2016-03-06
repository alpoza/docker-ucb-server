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

<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.ubuild.web.util.EvenOdd"%>
<%@ page import="com.urbancode.commons.util.ssl.StoredX509Cert"%>
<%@ page import="java.security.cert.X509Certificate"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error"%>

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp"/>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.broker.BrokerTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="trustCertUrl" value="${BrokerTasks.trustCert}"/>

<c:import url="/WEB-INF/snippets/popupHeader.jsp"/>

<%
  StoredX509Cert untrustedCert = (StoredX509Cert) pageContext.findAttribute("untrustedCert");
  X509Certificate[] certChain = untrustedCert.getChain();
  X509Certificate issuedToCert = certChain[0];
  pageContext.setAttribute("issuedToCert", issuedToCert);
  pageContext.setAttribute("hashCode", untrustedCert.hashCode());
  pageContext.setAttribute("eo", new EvenOdd());
  pageContext.setAttribute("certDateFormat", new SimpleDateFormat("MM/dd/yyyy"));
%>

<form method="post" action="${fn:escapeXml(trustCertUrl)}">
  <ucf:hidden name="hashCode" value="${hashCode}"/>

  <div style="padding-bottom: 3em;">
    <div class="popup_header">
      <ul>
        <li class="current"><span>${ub:i18n("AgentCertificateManagementTrustAgentCertificate")}</span></li>
      </ul>
    </div>
    
    <div class="contents">
      <table class="property-table">
        <tbody>

          <tr class="${eo.next}">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("CertificateWithColon")}</span>
            </td>
            <td align="left" colspan="2">
              <b>${ub:i18n("AgentCertificateManagementIssuedTo")}</b> ${fn:escapeXml(issuedToCert.subjectX500Principal.name)}<br/>
              <b>${ub:i18n("AgentCertificateManagementIssuedBy")}</b> ${fn:escapeXml(issuedToCert.subjectX500Principal.name)}<br/>
              <b>${ub:i18n("AgentCertificateManagementIssuedOn")}</b> ${fn:escapeXml(ah3:formatDate(certDateFormat, issuedToCert.notBefore))}<br/>
              <b>${ub:i18n("AgentCertificateManagementExpiresOn")}</b> ${fn:escapeXml(ah3:formatDate(certDateFormat, issuedToCert.notAfter))}<br/>
              <b>SHA-1</b> ${fn:escapeXml(ah3:toHex(ah3:sha1(issuedToCert.encoded), true))}<br/>
              <b>MD5</b> ${fn:escapeXml(ah3:toHex(ah3:md5(issuedToCert.encoded), true))}<br/>
            </td>
          </tr>

          <tr class="${eo.next}">
            <td align="left" width="20%">
              <span class="bold">${ub:i18n("AliasWithColon")} <span class="required-text">*</span></span>
            </td>
            <td align="left">
              <ucf:text name="alias" value=""/>
            </td>
            <td align="left">
              <span class="inlinehelp">${ub:i18n("AgentCertificateManagementAliasDesc")}</span>
            </td>
          </tr>
          
        </tbody>
      </table>
      <br/>
      <ucf:button name="trust" label="${ub:i18n('Trust')}"/>
      <ucf:button href="#" name="Cancel" label="${ub:i18n('Cancel')}" onclick="parent.hidePopup(); return false;"/>
    </div>
  </div>
</form>

<c:import url="/WEB-INF/snippets/popupFooter.jsp" />