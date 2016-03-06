/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * (c) Copyright IBM Corporation 2015. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */
define([
    "dojo/_base/kernel",
    "js/webext/widgets/Config",
    "js/webext/widgets/Util"
],
function(kernel, Config, Util) {
    var uBuildApp = {};

    uBuildApp.util = new Util();

    uBuildApp.i18nData = {};

    // config is defined in Util.js, but doesn't seem to get picked up on our ResourceTypes page
    if (!kernel.global.config) {
        kernel.global.config = new Config();
    }
    kernel.global.config.data = {};

    if (!kernel.global.util) {
        kernel.global.util = uBuildApp.util;
    }

    if (!kernel.global.i18nData) {
        kernel.global.i18nData = uBuildApp.i18nData;
    }

    return uBuildApp;
});
