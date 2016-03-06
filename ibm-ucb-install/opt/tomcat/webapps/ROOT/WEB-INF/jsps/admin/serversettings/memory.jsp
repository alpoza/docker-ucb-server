<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.NumberFormat"%>
<%@ page import="com.urbancode.air.i18n.TranslateMessage" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%!
    static public final double KB = 1024;
    static public final double MB = KB * KB;
    static public final double GB = KB * MB;

    static public String getBytes(double size, Locale locale) {
        NumberFormat format = NumberFormat.getInstance(locale);
        format.setMaximumFractionDigits(2);
        return TranslateMessage.translate("%s bytes", format.format(size));
    }

    static public String getKiloBytes(double size, Locale locale) {
        NumberFormat format = NumberFormat.getInstance(locale);
        format.setMaximumFractionDigits(2);
        return TranslateMessage.translate("%s KB", format.format(size / KB));
    }

    static public String getMegaBytes(double size, Locale locale) {
        NumberFormat format = NumberFormat.getInstance(locale);
        format.setMaximumFractionDigits(2);
        return TranslateMessage.translate("%s MB", format.format(size / MB));
    }

    static public String getGigaBytes(double size, Locale locale) {
        NumberFormat format = NumberFormat.getInstance(locale);
        format.setMaximumFractionDigits(2);
        return TranslateMessage.translate("%s GB", format.format(size / GB));
    }

    static public String getNearestBytes(double size) {
        if (size >= GB) {
            return getGigaBytes(size, Locale.getDefault());
        } else if (size >= MB) {
            return getMegaBytes(size, Locale.getDefault());
        } else if (size >= KB) {
            return getKiloBytes(size, Locale.getDefault());
        } else {
            return getBytes(size, Locale.getDefault());
        }
    }
%>
<br/>
<div class="note">
<b>${ub:i18n("Memory")}</b><br/>
<%
        Runtime runtime = Runtime.getRuntime();
        long tm = runtime.totalMemory();
        long fm = runtime.freeMemory();
        long mm = runtime.maxMemory();
        long um = tm - fm;
        pageContext.setAttribute("using", getNearestBytes((double) um) + " / " + getNearestBytes((double) tm));
        pageContext.setAttribute("free", getNearestBytes((double) fm));
        pageContext.setAttribute("max", getNearestBytes((double) mm));
%>
  ${ub:i18nMessage("SettingsDiagnostictsMemoryUsing", using)} <br/>
  ${ub:i18nMessage("SettingsDiagnostictsMemoryFree", free)}<br/>
  ${ub:i18nMessage("SettingsDiagnostictsMemoryMax", max)}<br/>
<%
        pageContext.removeAttribute("using");
        pageContext.removeAttribute("free");
        pageContext.removeAttribute("max");
%>
</div>
