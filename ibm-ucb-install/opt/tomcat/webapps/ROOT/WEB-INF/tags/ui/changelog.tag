<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags" %>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<%@attribute name="changeSets" required="true" type="java.util.Collection"%>

<c:url var="imagesUrl" value="/images"/>
<c:url var="plusImageUrl" value="${fn:escapeXml(imagesUrl)}/icon_plus_sign.gif"/>
<c:url var="minusImageUrl" value="${fn:escapeXml(imagesUrl)}/icon_minus_sign.gif"/>
<c:url var="arrowImageUrl" value="${fn:escapeXml(imagesUrl)}/icon_arrow_down.gif"/>
<c:set var="clippedCommentWidth" value="60" />

<table class="data-table">
  <col class="buildChange" />
  <col class="description" />
  <col class="user" />
  <col class="date" />

  <c:if test="${empty changeSets}">
    <tr class="nochange">
      <td colspan="4">${ub:i18n("NoChanges")}</td>
    </tr>
  </c:if>

  <c:if test="${not empty changeSets}">
    <tr>
      <th class="buildChange">${ub:i18n("Change")}</th>
      <th class="description">${ub:i18n("Description")}</th>
      <th class="user">${ub:i18n("User")}</th>
      <th class="date">${ub:i18n("Date")}/${ub:i18n("Time")}</th>
    </tr>
  </c:if>

  <c:forEach var="changeSet" items="${changeSets}">
    <tr class="change">
      <td class="level2" onclick="toggleChangeDetail(this);">
        <span class="change">
          <span>
            <img class="plus" src="${plusImageUrl}" height="16" width="16" alt="+"/>
            <img class="minus" src="${minusImageUrl}" height="16" width="16" alt="-"/>
          </span>
          ${ub:i18n('Change')}&nbsp;<c:out value="${changeSet.scmId}" default="-${ub:i18n('Unknown')}-"/>
        </span>
      </td>

      <td>
        <div class="description">
          ${fn:escapeXml(fn:substring(changeSet.comment, 0, clippedCommentWidth))}
          <c:if test="${fn:length(changeSet.comment) gt clippedCommentWidth}">&hellip;</c:if>
        </div>
      </td>

      <td class="user">${fn:escapeXml(changeSet.repositoryUser.repositoryUserName)}</td>

      <td class="date">
        <fmt:formatDate
          var="changeSetDate"
          value="${changeSet.date}"
          type="both"
          dateStyle="short"
          timeStyle="short"/>
        ${fn:escapeXml(changeSetDate)}
      </td>
    </tr>

    <tr class="changeDetail" style="display: none;">
      <td align="right"><strong>${ub:i18n("ChangeDescription")}</strong>
        <div class="viewFileList">
          <span class="view" onclick="toggleFileList(this);"
            >View Files (${fn:length(changeSet.changes)})<span
              ><img src="${arrowImageUrl}" height="16" width="16"
            /></span
          ></span>

          <div class="fileList">
            <table>
              <c:forEach var="change" varStatus="changeStatus" items="${changeSet.changes}" >
                <c:choose>
                  <c:when test="${changeStatus.first and changeStatus.last}">
                    <c:set var="rowClass" value="first last" />
                  </c:when>

                  <c:when test="${changeStatus.first}">
                    <c:set var="rowClass" value="first" />
                  </c:when>

                  <c:when test="${changeStatus.last}">
                    <c:set var="rowClass" value="last" />
                  </c:when>

                  <c:otherwise>
                    <c:set var="rowClass" value="" />
                  </c:otherwise>
                </c:choose>

                <tr class="${rowClass}">
                  <td class="change">
                    ${fn:escapeXml(change.changeType)}
                  </td>
                  <td>${fn:escapeXml(change.changePath)}</td>

                  <c:if test="${!empty change.revisionNumber}">
                      <td class="change">
                        ${fn:escapeXml(change.revisionNumber)}
                      </td>
                  </c:if>
                </tr>
              </c:forEach>
            </table>
          </div>
        </div>
      </td>
      <td colspan="4">${ah3:htmlBreaks(fn:escapeXml(fn:trim(changeSet.comment)))}</td>
    </tr>

    <c:if test="${not empty changeSet.properties}">
      <tr class="changeDetail" style="display: none;">
        <td align="right">
          <strong>${ub:i18n("ChangeProperties")}</strong>
        </td>
        <td>
          <c:forEach var="property" items="${changeSet.properties}">
             ${fn:escapeXml(property.key)} = ${fn:escapeXml(property.value)}<br/>
          </c:forEach>
        </td>
        <td colspan="2">&nbsp;</td>
      </tr>
    </c:if>
  </c:forEach>
</table>
