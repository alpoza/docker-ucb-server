<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>

<c:url var="baseUrl" value="/"/>
<c:set var="libBase" value="${baseUrl}lib"/>
<c:set var="imageBase" value="${baseUrl}images"/>
<c:set var="ubuildBase" value="${libBase}/ubuild"/>
<c:set var="webextBase" value="${libBase}/webext"/>
<c:set var="dojoBase" value="${libBase}/dojo"/>
<c:set var="restBase" value="${baseUrl}rest2"/>
<c:set var="i18nBase" value="${restBase}/"/>
<c:set var="language" value="${pageContext.response.locale}"/>

<script type="text/javascript">
    var appState = {};
    var navBar = null;

    dojoConfig = {
        "async": true,
        "baseUrl": ${ah3:toJson(dojoBase)} + "/dojo",
        "defaultDuration": 1, // animation length
        "parseOnLoad": true,
        "paths": {
            // mappings of module locations
            "js": ${ah3:toJson(webextBase)} + "/js",
            "idx": ${ah3:toJson(libBase)} + "/idx",
            "ubuild": ${ah3:toJson(ubuildBase)} + "/widgets"
        },
        "transparentColor": [255,255,255],
        "require": [
                    "dojo/uacss"
        ]
    };

    // Legacy support for webext
    bootstrap = {
        baseUrl: ${ah3:toJson(baseUrl)},
        imagesUrl: ${ah3:toJson(imageBase)},
        restUrl: ${ah3:toJson(restBase)},
        contentUrl: ${ah3:toJson(i18nBase)}
    };
</script>

<script src="${dojoBase}/dojo/dojo.js"></script>
<script type="text/javascript">
    require(["ubuild/module/UBuildApp"], function (UBuildApp) {
        UBuildApp.util.loadI18n(${ah3:toJson(language)}, function () {
            ${requestScope.onDocumentLoad}
        });
    });
</script>
