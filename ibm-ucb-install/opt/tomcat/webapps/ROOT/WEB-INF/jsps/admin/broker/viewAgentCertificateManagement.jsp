<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import="com.urbancode.ubuild.persistence.UnitOfWork"%>
<%@ page import="com.urbancode.ubuild.web.WebConstants"%>
<%@ page import="com.urbancode.commons.util.ssl.StoredX509Cert"%>
<%@ page import="java.security.cert.X509Certificate"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.broker.BrokerTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<%-- CONTENT --%>
<jsp:include page="/WEB-INF/jsps/admin/agent/mainAgentTabsHeader.jsp">
  <jsp:param name="title" value="${ub:i18n('AgentCertificateManagement')}"/>
  <jsp:param name="selected" value="AgentCertificateManagement"/>
</jsp:include>
<div class="contents">
  <div class="system-helpbox">${ub:i18n("AgentCertificateManagementSystemHelpBox")}</div>
  <table class="data-table" width="100%">
    <caption>${ub:i18n("AgentCertificateManagementWithColon")}</caption>
    <tbody>
      <tr>
        <th>${ub:i18n("Certificate")}</th>
        <th>${ub:i18n("Actions")}</th>
      </tr>
      <c:choose>
        <c:when test="${empty untrustedCerts}">
          <tr><td colspan="2">${ub:i18n("AgentCertificateManagementNoCertsFoundMessage")}</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach items="${untrustedCerts}" var="untrustedCert">
            <tr>
              <td>
                <%
                  StoredX509Cert untrustedCert = (StoredX509Cert) pageContext.findAttribute("untrustedCert");
                  X509Certificate[] certChain = untrustedCert.getChain();
                  X509Certificate issuedToCert = certChain[0];
                  pageContext.setAttribute("issuedToCert", issuedToCert);
                  pageContext.setAttribute("hashCode", untrustedCert.hashCode());
                %>
                <b>${ub:i18n("AgentCertificateManagementIssuedTo")}</b> ${fn:escapeXml(issuedToCert.subjectX500Principal.name)}<br/>
                <b>${ub:i18n("AgentCertificateManagementIssuedBy")}</b> ${fn:escapeXml(issuedToCert.subjectX500Principal.name)}<br/>
                <b>${ub:i18n("AgentCertificateManagementIssuedOn")}</b> ${fn:escapeXml(ah3:formatDate(certDateFormat, issuedToCert.notBefore))}<br/>
                <b>${ub:i18n("AgentCertificateManagementExpiresOn")}</b> ${fn:escapeXml(ah3:formatDate(certDateFormat, issuedToCert.notAfter))}<br/>
                <b>SHA-1</b> ${fn:escapeXml(ah3:toHex(ah3:sha1(issuedToCert.encoded), true))}<br/>
                <b>MD5</b> ${fn:escapeXml(ah3:toHex(ah3:md5(issuedToCert.encoded), true))}<br/>
              </td>
              <td align="center">
                <c:url var="trustCertUrl" value="${BrokerTasks.viewTrustCert}">
                  <c:param name="hashCode" value="${hashCode}"/>
                </c:url>
                <ucf:link href="#" label="${ub:i18n('Trust')}" onclick="showPopup('${ah3:escapeJs(trustCertUrl)}', 800, 640); return false;"/>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>
<jsp:include page="/WEB-INF/jsps/admin/agent/mainAgentTabsFooter.jsp" />