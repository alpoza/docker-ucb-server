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

<%@page import="com.urbancode.ubuild.web.util.*" %>
<%@ page import="com.urbancode.air.plugin.server.Plugin" %>
<%@ page import="com.urbancode.air.i18n.TranslateMessage" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="ucui" tagdir="/WEB-INF/tags/ui" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />

<%
  pageContext.setAttribute("eo", new EvenOdd());
%>

<table class="property-table">
  <tbody>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("NameWithColon")}</span></td>
      <td>
        ${fn:escapeXml(ub:i18n(plugin.name))}
      </td>
    </tr>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>
      <td>${fn:escapeXml(fn:trim(ub:i18n(plugin.description)))}</td>
    </tr>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("PluginId")}</span></td>
      <td>${fn:escapeXml(plugin.pluginId)}</td>
    </tr>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("PluginVersion")}</span></td>
      <td>${fn:escapeXml(plugin.releaseVersion)}</td>
    </tr>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("PluginAPIVersion")}</span></td>
      <td>${fn:escapeXml(plugin.pluginVersion)}</td>
    </tr>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("PluginTypeWithColon")}</span></td>
      <td>${fn:escapeXml(ub:i18n(plugin.class.simpleName))}</td>
    </tr>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("PluginTag")}</span></td>
      <td>
        <%
          Plugin plugin = (Plugin) pageContext.findAttribute("plugin");
          String tag = plugin.getTag();
          String[] tagParts = tag.split("/");
          for (int i = 0; i < tagParts.length; i++) {
              tagParts[i] = TranslateMessage.translate(tagParts[i]);
          }
          tag = StringUtils.join(tagParts, "/");
          pageContext.setAttribute("pluginTag", tag);
        %>
        ${fn:escapeXml(pluginTag)}
      </td>
    </tr>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("PluginHash")}</span></td>
      <td>${fn:escapeXml(plugin.pluginHash)}</td>
    </tr>

    <tr class="${eo.next}">
      <td width="10%"><span class="bold">${ub:i18n("PluginPropertyGroups")}</span></td>
      <td align="left" style="text-align: left">
        <c:forEach var="propSheetDef" items="${plugin.propSheetGroup.propSheetDefSet}">
          <table class="data-table">
            <caption style="padding-top: 0px;">${fn:escapeXml(ub:i18n(propSheetDef.name))} <c:if test="${!empty propSheetDef.description}">&nbsp;&nbsp;&nbsp;
            <span class="text">${fn:escapeXml(ub:i18n(propSheetDef.description))}</span></c:if></caption>
            <thead>
              <tr>
                <th width="15%">${ub:i18n("Label")}</th>
                <th width="15%">${ub:i18n("Name")}</th>
                <th width="20%">${ub:i18n("Type")}</th>
                <th width="50%">${ub:i18n("Description")}</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="propDef" items="${propSheetDef.propDefList}">
                <tr>
                  <td><c:out value="${ub:i18n(propDef.label)}"/></td>
                  <td><c:out value="${propDef.name}"/></td>
                  <td><c:out value="${ub:i18n(propDef.type)}"/>
                      <c:if test="${fn:length(propDef.defaultValue) > 0}">
                      <br/><small>${ub:i18n("PluginDefaultValue")}&nbsp;(<c:out value="${ub:i18n(propDef.defaultValue)}"/>)</small>
                      </c:if>
                      <c:if test="${fn:length(propDef.allowedValueStrings) > 0}">
                      <br/><small>${ub:i18n("PluginSelections")}&nbsp;(<ucui:stringList list="${propDef.allowedValueStrings}" />)</small>
                      </c:if>
                  </td>
                  <td>${fn:escapeXml(ub:i18n(propDef.description))}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table><br/>
        </c:forEach>
      </td>
    </tr>

    <tr>
      <td width="10%"><span class="bold">${ub:i18n("StepsWithColon")}</span></td>
      <td align="left" style="text-align: left">
        <c:if test="${!empty plugin.commands}">
          <c:forEach var="pluginCommand" items="${plugin.commands}">
            <table class="data-table">
              <caption style="padding-top: 0px;">${fn:escapeXml(ub:i18n(pluginCommand.name))}
              <c:if test="${!empty pluginCommand.description}">&nbsp;&nbsp;&nbsp;
              <span class="text">${fn:escapeXml(ub:i18n(pluginCommand.description))}</span></c:if>
              </caption>
              <thead>
                <tr>
                  <th width="15%">${ub:i18n("Label")}</th>
                  <th width="15%">${ub:i18n("Name")}</th>
                  <th width="20%">${ub:i18n("Type")}</th>
                  <th width="50%">${ub:i18n("Description")}</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="propDef" items="${pluginCommand.propSheetDef.propDefList}">
                  <tr>
                    <td><c:out value="${ub:i18n(propDef.label)}"/></td>
                    <td><c:out value="${propDef.name}"/></td>
                    <td><c:out value="${ub:i18n(propDef.type)}"/>
                        <c:if test="${fn:length(propDef.defaultValue) > 0}">
                        <br/><small>${ub:i18n("PluginDefaultValue")}&nbsp;(<c:out value="${ub:i18n(propDef.defaultValue)}"/>)</small>
                        </c:if>
                        <c:if test="${fn:length(propDef.allowedValueStrings) > 0}">
                        <br/><small>${ub:i18n("PluginSelections")}&nbsp;(<ucui:stringList list="${propDef.allowedValueStrings}" />)</small>
                        </c:if>
                    </td>
                    <td>${fn:escapeXml(ub:i18n(propDef.description))}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table><br/>
          </c:forEach>
        </c:if>
      </td>
    </tr>
  </tbody>
</table>
