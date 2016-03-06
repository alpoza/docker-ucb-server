<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form" %>
<%@taglib prefix="error" uri="error" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerPropertiesTasks" />
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />

<c:url var="imgUrl" value="/images"/>
<c:url var="iconDel" value="/images/icon_delete.gif"/>
<c:url var="saveUrl" value='${ServerPropertiesTasks.saveProperties}'/>
<c:url var="doneUrl" value='${SystemTasks.viewIndex}'/>

<%-- CONTENT --%>

<form id="integrationPropForm" action="${saveUrl}" method="post" onsubmit="return false">
    <div class="formError" style="display:none; color: red; margin-bottom: 10px"></div>

    <c:if test="${saveServerPropsMessage}">
      <div style="color: green; margin-bottom: 10px" class="saveMessage">${ub:i18n("SuccessfullySaved")}</div>
      <c:remove var="saveServerPropsMessage" scope="session"/>
    </c:if>

    <div class="properties-section">

      <ucf:button name="AddProperty" label="${ub:i18n('AddProperty')}" submit="${false}"/>

      <table id="PropertyTable:custom" class="data-table" style="margin-top: 1em">
        <thead>
          <tr>
            <th width="30%" scope="col">${ub:i18n("PropertyName")}</th>
            <th width="30%" scope="col">${ub:i18n("Value")}</th>
            <th width="30%" scope="col">${ub:i18n("Description")}</th>
            <th width="10%" scope="col">${ub:i18n("Actions")}</th>
          </tr>
        </thead>
        <tbody>
          <tr class="no-props" <c:if test="${!empty server_settings.propertyArray}">style="display:none"</c:if>>
            <td colspan="4">${ub:i18n("SettingsPropertyNoneMessage")}</td>
          </tr>
          <c:forEach var="prop" items="${server_settings.propertyArray}" varStatus="i">
            <tr>
              <td>
                <ucf:hidden name="prop-name:${i.index}" value="${prop.name}"/>
                ${fn:escapeXml(prop.name)}
              </td>
              <td>
                <c:choose>
                  <c:when test="${!prop.secure}">
                    <ucf:textarea name="prop-value:${i.index}" value="${prop.value}" rows="1" cols="30"/>
                  </c:when>
                  <c:otherwise>
                    <ucf:password name="prop-value:${i.index}" value="${prop.value}" size="30" cssClass="hasConfirm"/>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <ucf:textarea name="prop-desc:${i.index}" value="${prop.description}" rows="1" cols="30"/>
              </td>
              <td align="center">
                <a href="#" onclick="return false;" class="removeButton" title="${ub:i18n('Remove')}"><img alt="${ub:i18n('Remove')}" style="border:none" src="${iconDel}"/></a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

    </div><!-- properties-section -->

    <div style="margin-top: 10px; display:none;" class="editButtons">
      <ucf:button name="Save" label="${ub:i18n('Save')}" submit="${true}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" submit="${false}"/>
    </div>
    <div style="margin-top: 10px;" class="doneButtons">
      <ucf:button name="Done" label="${ub:i18n('Done')}" submit="${false}" href="${doneUrl}"/>
    </div>
</form>