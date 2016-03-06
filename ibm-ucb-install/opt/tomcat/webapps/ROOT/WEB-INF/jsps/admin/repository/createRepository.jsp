<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page import="java.util.*" %>
<%@page import="com.urbancode.air.plugin.server.Plugin"%>
<%@page import="com.urbancode.air.plugin.server.PluginFactory"%>
<%@page import="com.urbancode.air.plugin.server.SourcePlugin"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="input" uri="http://jakarta.apache.org/taglibs/input-1.0" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="error" uri="error" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.repository.RepositoryTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<error:template page="/WEB-INF/snippets/errors/error.jsp"/>

<jsp:include page="/WEB-INF/snippets/header.jsp">
    <jsp:param name="selected" value="system" />
    <jsp:param name="title"    value="${ub:i18n('CreateRepository')}" />
    <jsp:param name="disabled" value="true"/>
</jsp:include>

<c:url var="newUrl" value="${RepositoryTasks.newRepository}"/>
<c:url var="cancelUrl" value="${RepositoryTasks.viewList}"/>

<c:set var="selectedRepo" value="${param.selected}"/>

<%!
  static public class Option implements Comparable<Option> {
    public final String label;
    public final String value;

    public Option(String label, String value) {
        this.label = label;
        this.value = value;
    }

    public int compareTo(Option option) {
        return label.compareToIgnoreCase(option.label);
    }
  }
%>

<%-- CONTENT --%>

<div>
  <div class="tabManager" id="secondLevelTabs">
    <ucf:link label="${ub:i18n('CreateRepository')}" href="" enabled="${false}" klass="selected tab"/>
  </div>

  <div class="contents">

    <c:choose>
      <c:when test="${empty selectedRepo}">
        <%
          // this is a map of the type label to the type value.
          List<Option> options = new ArrayList<Option>();

          for (Plugin plugin : PluginFactory.getInstance().getLatestPlugins()) {
              if (plugin instanceof SourcePlugin) {
                  options.add(new Option(plugin.getName(), String.valueOf(plugin.getId())));
              }
          }

          Collections.sort(options);
          List<String> labels = new ArrayList<String>();
          List<String> values = new ArrayList<String>();
          for (Option opt : options) {
              labels.add(opt.label);
              values.add(opt.value);
          }

          pageContext.setAttribute("typeLabels", labels.toArray());
          pageContext.setAttribute("typeValues", values.toArray());
        %>
        <div class="system-helpbox">
          ${ub:i18n("RepositoryCreateSystemHelpBox")}
        </div>
        <br />

        <input:form name="select-repository-form" method="post" action="${fn:escapeXml(newUrl)}">
          <table class="property-table">
            <tbody>
              <tr class="even">
                <td align="left" width="20%">
                  <span class="bold">${ub:i18n("SourcePluginWithColon")} <span class="required-text">*</span></span>
                </td>
                <td align="left">
                  <ucf:stringSelector name="${WebConstants.PLUGIN_ID}" enabled="${empty selectedRepo}"
                      list="${typeLabels}" valueList="${typeValues}" selectedValue="${selectedRepo}"/>
                </td>
                <td align="left">
                  <span class="inlinehelp">${ub:i18n("RepositoryPluginDesc")}</span>
                </td>
              </tr>
            </tbody>
          </table>
          <br/>
          <ucf:button name="Set" label="${ub:i18n('Set')}" submit="${true}" enabled="${empty selectedRepo}"/>
          <c:if test="${empty selectedRepo}">
            <ucf:button href="${cancelUrl}" name="Cancel" label="${ub:i18n('Cancel')}"/>
          </c:if>
        </input:form>
      </c:when>
      <c:otherwise>
        <br/>
        <table border="0">
          <tbody>
            <tr class="even">
              <td align="left" width="20%">
                <span class="bold">${ub:i18n("RepositoryType")}</span>
              </td>
              <td align="left" colspan="2"><c:out value="${selectedRepo}"/></td>
            </tr>
          </tbody>
        </table>
        <br/>
      </c:otherwise>
    </c:choose>

  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp"/>
