<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2015. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="com.urbancode.ubuild.runtime.scripting.helpers.*"%>
<%@page import="com.urbancode.ubuild.web.WebConstants"%>
<%@page import="com.urbancode.ubuild.web.dashboard.UserProfileTasks"%>
<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@page import="com.urbancode.ubuild.domain.security.*"%>
<%@ page import="com.urbancode.ubuild.main.server.UBuildServer" %>
<%@ page import="com.urbancode.ubuild.main.server.FeatureFlag" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.TimeZone" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>

<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib uri="error" prefix="error"%>

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<ah3:useConstants class="com.urbancode.ubuild.web.dashboard.UserProfileTasks"/>

<%
    UBuildUser user = (UBuildUser) pageContext.findAttribute(WebConstants.USER);

    EvenOdd eo = new EvenOdd();
    eo.getNext();
    pageContext.setAttribute("eo", eo);

    List<Locale> localeValues = UBuildServer.getInstance().getSupportedLocales();
    List<String> localeNames = new ArrayList<String>();
    boolean showLocales = FeatureFlag.UserProfileLocale.isEnabled();
    if (showLocales) {
        for (Locale locale : localeValues) {
            String displayName;
            if (locale == Locale.SIMPLIFIED_CHINESE) {
                byte[] simplifiedChineseByteArray = { -25, -82, -128, -28, -67, -109, -28, -72, -83, -26, -106, -121 };
                displayName = new String(simplifiedChineseByteArray, "UTF-8");
            }
            else if (locale.equals(Locale.TRADITIONAL_CHINESE)) {
                byte[] traditionalChineseByteArray = { -25, -71, -127, -28, -67, -109, -28, -72, -83, -26, -106, -121 };
                displayName = new String(traditionalChineseByteArray, "UTF-8");
            }
            else {
                displayName = locale.getDisplayName(locale);
            }
            localeNames.add(displayName);
        }
    }
    pageContext.setAttribute("showLocales", showLocales);
    pageContext.setAttribute("localeNames", localeNames);
    pageContext.setAttribute("localeValues", localeValues);
%>

<%
    List<TimeZone> timeZoneValues = Arrays.asList(UserProfileTasks.timezoneArray);
    List<String> timeZoneNames = new ArrayList<String>();
    for (TimeZone timeZone : timeZoneValues) {
        Locale userLocale = null;
        if (user != null) {
            userLocale = user.getLocale();
        }
        if (userLocale == null) {
            userLocale = Locale.getDefault();
        }
        String displayName = timeZone.getDisplayName(userLocale);
        timeZoneNames.add(displayName);
    }
    pageContext.setAttribute("timeZoneList", timeZoneValues);
    pageContext.setAttribute("timeZoneNames", timeZoneNames);
%>

<c:set var="inEditMode" value='${fn:escapeXml(mode) == "edit"}'/>
<c:set var="inViewMode" value="${!inEditMode}"/>


    <error:field-error field="actualName" cssClass="${eo.next}"/>
    <tr class="${eo.last}" valign="top">
      <td align="left" width="20%">
        <ucf:hidden name="userProfileId" value="${user.id}"/>
        <span class="bold">${ub:i18n("UserProfileActualNameWithColon")} </span>
      </td>
      <td align="left" width="20%">
        <ucf:text name="actualName" value="${user.actualName}" enabled="${inEditMode}"/>
      </td>
      <td align="left">
        <span class="inlinehelp">${ub:i18n("UserProfileActualNameDesc")}</span>
      </td>
    </tr>

    <error:field-error field="emailAddress" cssClass="${eo.next}"/>
    <tr class="${eo.last}" valign="top">
      <td align="left" width="20%"><span class="bold">${ub:i18n("UserProfileEmailAddress")} </span></td>
      <td align="left" width="20%">
        <ucf:text name="emailAddress" value="${user.emailAddress}" enabled="${inEditMode}"/>
      </td>
      <td align="left">
        <span class="inlinehelp">${ub:i18n("UserProfileEmailAddressDesc")}</span>
      </td>
    </tr>

    <error:field-error field="imId" cssClass="${eo.next}"/>
    <tr class="${eo.last}" valign="top">
      <td align="left" width="20%"><span class="bold">${ub:i18n("UserProfileIMId")} </span></td>
      <td align="left" width="20%">
        <ucf:text name="imId" value="${user.imId}" enabled='${inEditMode}'/>
      </td>
      <td align="left">
        <span class="inlinehelp">&nbsp;${ub:i18n("UserProfileIMIdDesc")}</span>
      </td>
    </tr>

    <error:field-error field="shortDateTimeFormat" cssClass="${eo.next}"/>
    <tr class="${eo.last}" valign="top">
      <td align="left" width="20%"><span class="bold">${ub:i18n("UserProfileDateTimeFormat")}</span></td>
      <td align="left" width="20%">

        <script type="text/javascript">
          /* <![CDATA[ */

          // attach the listeners to the date time input
          var dateTimeInput = null;
          Element.observe(window, 'load', function(event) {
        	  dateTimeInput = new UCDateTimeInput('shortDateFormat');
          });

          /* ]]> */
        </script>

        <c:set var="use24"  value="${user.use24HourTime}"/>
        <ucf:stringSelector   id="shortDateFormat"
                              name="shortDateFormat"
                              list="${UserProfileTasks.SHORT_DATE_TIME_FORMATS}"
                              selectedValue="${user.shortDateFormat}"
                              canUnselect="${true}"
                              emptyMessage="${ub:i18n('Default')}"
                              enabled="${inEditMode}"
                              />
         <div style="${!empty user.shortDateFormat ? '' : 'display: none;'}">${ub:i18n("Use24HourClock")}<ucf:checkbox name="use24Clock"
             checked="${use24}"
             enabled="${inEditMode}"/></div>
      </td>
      <td align="left">
        <span class="inlinehelp">
          ${ub:i18n("UserProfileDateTimeFormatDesc")}
        </span>
      </td>
    </tr>

    <error:field-error field="timeZone" cssClass="${eo.next}"/>
    <tr class="${eo.last}" valign="top">
      <td align="left" width="20%"><span class="bold">${ub:i18n("UserProfileTimeZone")}</span></td>
      <td align="left" width="20%">
        <ucf:timezoneSelector name="timeZone"
                              list="${timeZoneNames}"
                              valueList="${timeZoneList}"
                              canUnselect="${true}"
                              selectedZone="${user.timeZone}" enabled="${inEditMode}"/>
      </td>
      <td align="left">
        <span class="inlinehelp">${ub:i18n("UserProfileTimeZoneDesc")}</span>
      </td>
    </tr>

    <c:if test="${showLocales}">
        <error:field-error field="locale" cssClass="${eo.next}"/>
        <tr class="${eo.last}" valign="top">
            <td align="left" width="20%"><span class="bold">${ub:i18n("UserLocale")}</span></td>
            <td align="left" width="20%" colspan="2">
                <ucf:stringSelector   name="locale"
                                      id="locale"
                                      list="${localeNames}"
                                      valueList="${localeValues}"
                                      selectedValue="${user.locale}"
                                      canUnselect="${true}"
                                      emptyMessage="${ub:i18n('Default')}"
                                      enabled="${inEditMode}"
                                      autocomplete="${false}"/>
            </td>
        </tr>
    </c:if>

    <error:field-error field="numDashRows" cssClass="${eo.next}"/>
    <tr class="${eo.last}" valign="top">
      <td align="left" width="20%"><span class="bold">${ub:i18n("UserProfileDashboardRows")} </span></td>
      <td align="left" width="20%">
        <ucf:text name="numDashRows" value="${user.numDashRows}" enabled="${inEditMode}" size="6"/>
      </td>
      <td align="left">
        <span class="inlinehelp">${ub:i18n("UserProfileDashboardRowsDesc")}</span>
      </td>
    </tr>

    <error:field-error field="receiveNotifications" cssClass="${eo.next}"/>
    <tr class="${eo.last}" valign="top">
        <td align="left" width="20%"><span class="bold">${ub:i18n("UserProfileReceiveNotifications")} </span></td>
        <td align="left" width="20%">
            <ucf:checkbox name="receiveNotifications" checked="${user.receiveNotifications}" enabled="${inEditMode}"/>
        </td>
        <td align="left">
            <span class="inlinehelp">${ub:i18n("UserProfileReceiveNotificationsDesc")}</span>
        </td>
    </tr>
