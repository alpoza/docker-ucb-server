/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/

var nn4 = (navigator.appName.indexOf("Netscape") > -1 && navigator.appVersion.indexOf("4") > -1) ? true:false;
var ie = (document.all) ? true:false;
var nn6 = (document.getElementById) ? true:false;

/**
 *
 * @param objectName
 * @return
 */
function confirmDelete(objectName) {
  var result = window.confirm(i18n("DeleteConfirm", objectName));
  return result;
}

/**
 *
 * @param message
 * @return
 */
function basicConfirm(message) {
  var result = window.confirm(message);
  return result;
}

/**
 * @deprecated use $(id) instead (supplied by prototype)
 */
function getLayer(id){
  return $(id);
}

/**
 * @deprecated use $(layer_id).show() instead (prototype.js)
 */
function showLayer(layer_id) {
  $(layer_id).show();
}

/**
 * @deprecated use $(layer_id).visible() instead (prototype.js)
 */
function isShown(layer_id) {
  return $(layer_id).visible();
}

/**
 * @deprecated use !$(layer_id).visible() instead (prototype.js)
 */
function isHidden(layer_id) {
  return !isShown(layer_id)
}


/**
 * @deprecated use $(layer_id).hide() instead (prototype.js)
 */
function hideLayer(layer_id) {
  $(layer_id).hide();
}

/**
 * @deprecated use $(id).toggle() instead (prototype.js)
 */
function toggleLayer(id) {
    $(id).toggle();
}

function showAllWithCss(lookup) {
    $$(lookup).each(function(row) {
        row.show();
    });
}
function hideAllWithCss(lookup) {
    $$(lookup).each(function(row) {
        row.hide();
    });
}

/**
 *
 * @param form
 * @param elementname
 * @param checked
 * @return
 */
function checkOrUncheckAll(form, elementname, checked) {
  for (var i=0; i < form.elements.length; i++ ) {
    if (form.elements[i].name == elementname) {
      if (form.elements[i].disabled == false) {
        form.elements[i].checked=checked;
      }
    }
  }
}

/**
 * 
 * @param uri
 * @param title
 * @return
 */
function newHelpWindow(uri, title) {
    var serverUrl = "";
    var stringArray = location.href.split('/');
    if (stringArray.length >= 3) {
        serverUrl += stringArray[0] + "//";
        serverUrl += stringArray[2];
    }
    window.open(serverUrl + uri, title);
}

/**
 * 
 * @param uri
 * @param title
 * @param width
 * @param height
 * @return
 */
function openPopup(uri, title, width, height) {
    //alert('openPopup() start');
    if (title == null) {
        title = "_blank";
    }
    var popW = 600, popH = 360;

    if (width != null) {
        popW = width;
    }

    if (height != null) {
        popH = height;
    }
    
    var w = 800, h = 600;
    if (screen != null) {
        w = screen.availWidth;
           h = screen.availHeight;
    }
    else if (document.all) {
        w = document.body.clientWidth;
        h = document.body.clientHeight;
    }
    else if (document.layers) {
        w = window.innerWidth;
        h = window.innerHeight;
    }
    var leftPos = (w-popW)/2;
    var topPos = (h-popH)/2;

    var popupProps = "";
    popupProps += "width="+popW+",height="+popH;
    popupProps += ",top="+topPos+",left="+leftPos;
    popupProps += ",scrollbars=yes";
    popupProps += ",status=1";
    //alert('popupProps:'+popupProps);

    var popup = window.open(uri, title,  popupProps);
    popup.opener = window;
    
    //alert('openPopup() done');
}

/**
 * @deprecated use wndw.$(id) instead (prototype.js).
 */
function getWindowElementById(wndw, aID) {
       var element = null;
       
       var doc = wndw.document;

    if (doc.getElementById) { // Real Browsers
           element = doc.getElementById(aID)
    }
    else if (document.all) { // IE4
          element = doc.all[aID];
    }
    else if (document.layers) {// NN4
          element = doc.layers[aID]
    }

    return element;
}

/**
 * @deprecated use $(id) instead (prototype.js)
 */
function getElem(id){
  return $(id);
}

function getDOMElementText(elem) {
    if (elem.childNodes != null && elem.childNodes.length > 0) {
        return elem.childNodes[0].nodeValue;
    } else {
        return "";
    }
}

function getDOMFirstChildElementText(elem, child) {
    var childElems = elem.getElementsByTagName(child);
    if (childElems == null) {
        return "";
    } else {
        var childElem = childElems[0];
        if (childElem != null) {
            return getDOMElementText(childElem);
        } else {
            return "";
        }
    }
}

function getDOMFirstChildElement(elem, child) {
    var childElems = elem.getElementsByTagName(child);
    if (childElems == null) {
        return null;
    } else {
        return childElems[0];
    }
}

function getDOMChildElements(elem, child) {
    return elem.getElementsByTagName(child);
}

/**
 * @deprecated use document.viewport.getHeight() from prototype.js instead
 */
function windowHeight() {
    return document.viewport.getHeight();
}
    
/**
 * @deprecated use document.viewport.getWidth() from prototype.js instead
 */
function windowWidth() {
    return document.viewport.getWidth();
}

/**
 * 
 * @param txt
 * @return
 */
function createCustomAlert(txt) {

    // create the modalContainer div as a child of the BODY element
    var mObj = document.getElementsByTagName("body")[0].appendChild(document.createElement("div"));
    mObj.id = "modalContainer";
     // make sure its as tall as it needs to be to overlay all the content on the page
    mObj.style.height = document.documentElement.scrollHeight + "px";

    // create the DIV that will be the alert 
    var alertObj = mObj.appendChild(document.createElement("div"));
    alertObj.id = "alertBox";
    // MSIE doesnt treat position:fixed correctly, so this compensates for positioning the alert
    if(document.all && !window.opera) alertObj.style.top = document.documentElement.scrollTop + "px";

    // create an H1 element as the title bar
    var h1 = alertObj.appendChild(document.createElement("h1"));
    h1.appendChild(document.createTextNode(i18n("Alert")));

    // create a paragraph element to contain the txt argument
    var msg = alertObj.appendChild(document.createElement("p"));
    msg.appendChild(document.createTextNode(txt));

    // create an anchor element to use as the confirmation button.
    var btn = alertObj.appendChild(document.createElement("a"));
    btn.id = "closeBtn";
    btn.appendChild(document.createTextNode(i18n("OK")));
    btn.href = "#";
    // set up the onclick event to remove the alert when the anchor is clicked
    btn.onclick = function() { removeCustomAlert(mObj);return false; }

  resizePopup(300, 135, "alertBox");
}

/**
 * 
 * @param alertContainer
 * @return
 */
function removeCustomAlert(alertContainer) {
    document.getElementsByTagName("body")[0].removeChild(alertContainer);
}

/**
 * 
 * @param url
 * @param width
 * @param height
 * @return
 */
function showPopup(url, width, height) {
    var screenElem = document.getElementsByTagName("body")[0].appendChild(document.createElement("div"))
    screenElem.id = "fixed-screen";
    // Order matters - append iframe after mask so iframe is over mask
    var maskElem =  screenElem.appendChild(document.createElement("div"));
    maskElem.id = "maskingdiv";
    var iframe = document.createElement("iframe");
    iframe.src = url;
    var popupElem = screenElem.appendChild(iframe);
    popupElem.id = "floatingframe";
    resizePopup(width, height);
}

/**
 * 
 * @return
 */
function hidePopup() {
    var body = document.getElementsByTagName("body")[0];
    var layer = getLayer( "fixed-screen" );
    body.removeChild( layer );
}

/**
 * 
 * @return
 */
function hidePopupRefresh() {
    var body = document.getElementsByTagName("body")[0];
    var layer = getLayer( "fixed-screen" );
    body.removeChild( layer );
    window.location.reload();
}

/**
 * 
 * @return
 */
function isPopup() {
    return top != window;
}

/**
 * 
 * @param popupId
 * @return
 */
function centerPopup(popupId) {
    if (popupId == null) {
        popupId = "floatingframe";
    }

    var popupElem = getLayer(popupId);
    if (!popupElem) {
        return;
    }

    var windowH = windowHeight();
    var windowW = windowWidth();

    // center of screen
    var height = popupElem.style.height;
    if (height.indexOf("px") > 0) {
        height = height.substring(0, height.length - 2);
    }
    var width = popupElem.style.width;
    if (width.indexOf("px") > 0) {
        width = width.substring(0, width.length - 2);
    }

    var ttop = (windowH - height)/2;
    popupElem.style.top = ttop+"px";

    var lleft = (windowW - width)/2;
    popupElem.style.left = lleft+"px";
}

/**
 * 
 * @param width
 * @param height
 * @param popupId
 * @return
 */
function resizePopup(width, height, popupId) {
    width = width ? width : 800;
    height = height ? height : 800;
    popupId = popupId ? popupId : "floatingframe";
      
    var popupElem = getLayer(popupId);
    if (!popupElem) {
        // console.log('Did not find popup element '+popupId)
        return;
    }
    
    var windowH = windowHeight();
    var windowW = windowWidth();

    // enforce a 50px border
    height = Math.min(windowH-100, height);
    width = Math.min(windowW-100, width);

    var pixelWidth = (width + 0) + "px";
    var pixelHeight = (height + 0) + "px";
    popupElem.style.width = pixelWidth;
    popupElem.style.height = pixelHeight;

    // center of screen
    centerPopup(popupId);
}

/**
 * 
 * @return
 */
function resizeIframe() {
    var ff = parent.getLayer("floatingframe");
    ff.style.height = (document.body.offsetHeight + 40) + "px";
    parent.centerPopup();
}

/**
 * 
 * @param iframe
 * @return
 */
function setProperSizeForIframe(iframe) {
    var ff = parent.getLayer("floatingframe");
    var parentSize =  window.parent.windowHeight();
    var frame = document.getElementById(iframe);
    var windowHeight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight;
    if (frame.offsetHeight > windowHeight) {
        ff.style.height = (parentSize - 40) + "px";
        parent.centerPopup();
    }
}
    
/**
 * This method will toggle the visibility of all elements which are marked with
 * the a provided class.
 * @deprecated use $$('.'+elementClass).each(function(elem){elem.toggle()}) instead from prototype.js
 */
function toggleDisplayForElementsWithClass(elementClass) {
    $$('.'+elementClass).each(function(element){element.toggle()});
}

/**
 * This method will assign a value, contained in a string, to the given form element. It will
 * determine the format of the string based on the type of the element.
 * @param element The form element to set the value of.
 * @param value A string containing the desired value.
 * @return
 */
function flexibleAssignValue(element, value) {
    if (element.type == "text" || element.type == "select-one" || element.type == "hidden" || element.type == "textarea" || element.type == "password") {
        element.value = value;
    }
    else if (element.type == "checkbox") {
        if (value.length == 0 || value == null || value == "false" || value == "0") {
            element.checked = false;
        }
        else {
            element.checked = true;
        }
    }
    else if (element.type == "select-multiple") {
        for (selectNr = 0; selectNr < element.options.length; selectNr++) {
            element.options[selectNr].selected = false;
        }
        valueSplit = value.split(",");
        for (valueNr = 0; valueNr < valueSplit.length; valueNr++) {
            if (valueSplit[valueNr].length > 0) {
                for (selectNr = 0; selectNr < element.options.length; selectNr++) {
                    if (valueSplit[valueNr] == element.options[selectNr].text) {
                        element.options[selectNr].selected = true;
                    }
                }
            }
        }
    }
}

/**
 * This method produces a string which contains the value of the given form element. It will
 * create a string in a format depending on the type of the form element.
 * @param element The form element to get the value from.
 * @return
 */
function flexibleGetValue(element) {
    result = "";
    if (element.type == "text" || element.type == "select-one" || element.type == "hidden" || element.type == "textarea" || element.type == "password") {
        result = element.value;
    }
    else if (element.type == "checkbox") {
        if (element.checked) {
            result = "true";
        }
        else {
            result = "false";
        }
    }
    else if (element.type == "select-multiple") {
        for (selectNr = 0; selectNr < element.options.length; selectNr++) {
            if (element.options[selectNr].selected) {
                result = result+element.options[selectNr].text+",";
            }
        }
    }
    return result;
}

function triggerEvent(element, eventName) {
    // safari, webkit, gecko
    if (document.createEvent) {
        var evt = document.createEvent('HTMLEvents');
        evt.initEvent(eventName, true, true);
        return element.dispatchEvent(evt);
    }
 
    // Internet Explorer
    if (element.fireEvent) {
        return element.fireEvent('on' + eventName);
    }
}

if (document.getElementById) {
    window.alert = function(txt) {
        createCustomAlert(txt);
    }
}

/**
 * Replace window.location setter with something IE can handle, otherwise IE <9 does not send referrer which runs
 * afoul of our anti-Csrf filter
 *
 * @param url the URL value to set
 * @param win the window to change, optional defaults to current window
 */
var goTo = (function(){

    // only IE has poorly behaved versions.
    var goodBrowser = true;
    if (Prototype.Browser.IE) {
        var version = 0;
        var majorIERegex = /MSIE (\d+)/;
        var result = navigator.userAgent.match(majorIERegex);
        if (result && result[1] && Number(result[1]) < 9) {
            // IE >9 is good
            goodBrowser = false;
        }
    }

    if (goodBrowser) {
        // this browser can do a basic url location manipulation while preserving referrer.
        return function (url, win) {
            (win || window).location = url;
        };
    }

    // IE < 9, create an 'a' element and programmatically click it.
    return function(url, win) {
        var w = win || window;
        var a = w.document.createElement("a");
        a.setAttribute("href", url);
        a.style.display = "none";
        w.document.body.appendChild(a);
        a.click();
    };
}());
