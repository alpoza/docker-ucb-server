<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks"%>
<%@ page import="com.urbancode.ubuild.web.admin.security.LoginTasks"%>
<%@ page import="com.urbancode.air.i18n.TranslateUtil" %>
<%@ page import="com.urbancode.commons.webext.util.InstalledVersion"%>
<%@ page import="com.urbancode.ubuild.main.server.ServerConstants"%>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf"   tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error"%>

<ah3:useConstants id="LoginConsts" class="com.urbancode.ubuild.web.admin.security.LoginTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.security.LoginTasks" />

<error:template page="/WEB-INF/snippets/errors/basic-error.jsp" />

<%
    String versionStr = "";
    try {
        InstalledVersion version = InstalledVersion.getInstance();
        versionStr = version.getVersion();
    }
    catch (Throwable t) {
    }
    pageContext.setAttribute("webAppVersion", versionStr);
    pageContext.setAttribute("productName", TranslateUtil.getInstance().getValue("ProductName"));

    try {
        pageContext.setAttribute("allowGuest", Boolean.valueOf(LoginTasks.isGuestAllowed()));
        pageContext.setAttribute("allowLoginCookie", Boolean.valueOf(LoginTasks.isAllowLoginCookie()));
        pageContext.setAttribute("allowAutocomplete", ServerSettingsTasks.isAllowAutoComplete());
    }
    catch (Throwable t) {
        Logger.getLogger("com.urbancode.JSP").info(t.getMessage(), t);
    }
  %>

<!DOCTYPE html>
<html class="fullHeight">
  <head>
    <title>${ub:i18n("ProductNameWithColon")}&nbsp;${ub:i18n('Login')}</title>
    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Cache-Control" content="no-cache"/>

    <c:url var="guestLoginUrl" value="${LoginTasks.authenticateGuest}"/>
    <c:url var="actionUrl" value="${LoginTasks.authenticate}"/>
    <c:url var="cssBase" value="/css"/>
    <c:url var="imagesUrl" value="/images/login"/>

    <c:import url="/WEB-INF/snippets/includeCssAndScripts.jsp"/>

    <script type="text/javascript">
      if (top != self) {
        top.location = '${ah3:escapeJs(rootPageUrl)}';
      }
      /* <![CDATA[ */
        require(["dojo/has",
                 "dojo/ready",
                 "dojo/dom-class",
                 "dojo/dom-attr",
                 "dijit/form/TextBox",
                 "dijit/form/CheckBox",
                 "dijit/form/Button"],
                function(
                        has,
                        ready,
                        domClass,
                        domAttr,
                        TextBox,
                        CheckBox,
                        Button) {
          ready(function () {
              var usernameInput = new TextBox({
                  name: "${LoginConsts.PARAM_USERNAME}"
              }, "usernameField");
              var passwordInput = new TextBox({
                  name: "${LoginConsts.PARAM_PASSWORD}",
                  type: "password"
              }, "passwordField");
              var rememberMeInput = new CheckBox({
                  name: "${LoginConsts.PARAM_REMEMBER_ME}",
                  value: "true"
              }, "rememberMe");
              var submitButton = new Button({
                  label: "${ub:i18n('Login')}",
                  type: "submit",
                  style: {
                      marginLeft: "0px"
                  }
              }, "submitButton");
              domClass.add(submitButton.domNode, "idxButtonSpecial");

              if (has("ie") < 10) {
                  usernameInput.set("placeHolder", "${ub:i18n('UserName')}");
                  passwordInput.set("placeHolder", "${ub:i18n('Password')}");
              }
              else {
                  domAttr.set(usernameInput.domNode.getElementsByTagName("input")[0], "placeholder", "${ub:i18n('UserName')}");
                  domAttr.set(passwordInput.domNode.getElementsByTagName("input")[0], "placeholder", "${ub:i18n('Password')}");
              }
          });
        });
      /* ]]> */
    </script>
  </head>

  <body class="oneui loginPage fullHeight">
    <div class="idxHeaderContainer">
      <div class="idxHeaderBlueLip"></div>
    </div>

    <div class="loginFramePositioner">
      <div class="loginFrame">

        <div class="productName">${ub:i18n('ProductName')}</div>
        <div class="productVersion">${ub:i18nMessage("ServerVersion", webAppVersion)}</div>

        <div class="formSpacer"></div>
        <div class="formSpacer"></div>

        <form method="post" action="${fn:escapeXml(actionUrl)}" <c:if test="${allowAutocomplete}">autocomplete="off"</c:if>>
          <div class="loginError"><error:field-error field="message" /></div>
          <div id="usernameField"></div>

          <div class="formSpacer"></div>
          <div class="formSpacer"></div>

          <div id="passwordField"></div>

          <div class="formSpacer"></div>
          <div class="formSpacer"></div>

          <c:if test="${allowLoginCookie}">
            <div id="rememberMe"></div>
            <label for="rememberMe">${ub:i18n("RememberMe")}</label>
            <div class="formSpacer"></div>
            <div class="formSpacer"></div>
          </c:if>
          <c:if test="${allowGuest}">
            <c:url var="guestUrl" value="${guestLoginUrl}"/>
            <div><a href="${fn:escapeXml(guestUrl)}">click here to login as guest</a></div>
            <div class="formSpacer"></div>
            <div class="formSpacer"></div>
          </c:if>

          <div id="submitButton" class="idxButtonSpecial"></div>

          <div class="formSpacer"></div>
          <div class="formSpacer"></div>
          <div class="formSpacer"></div>

          <div class="legal">
            ${ub:i18nMessage("Copyright", "2016")}
          </div>
        </form>
      </div>
    </div>
  </body>
</html>
