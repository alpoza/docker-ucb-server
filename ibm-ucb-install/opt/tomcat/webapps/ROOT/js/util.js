/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/

/**
 *  This function will place focus on the first text/textarea
 */
function focusOnFirstField() {
    if (document.forms.length > 0) {
        var firstForm = $(document.forms[0]);
        // Finds the first non-hidden, non-disabled control within the form.
        var element = firstForm.findFirstElement();
        if (element) {
            // ignore buttons
            if (element.tagName.toUpperCase() === 'INPUT' && element.getAttribute("type").toUpperCase() === 'BUTTON') {
                return;
            }
            firstForm.focusFirstElement();
        }
    }
}
  
/**
 * @deprecated use $(elem).getHeight() instead (supplied by prototype library)
 */
function getElementHeight(elem) {
    return $(elem).getHeight();
}
    
/**
 * @deprecated use $(elem).getWidth() instead (supplied by prototype library)
 */
function getElementWidth(elem) {
    return $(elem).getWidth();
}

/**
 * Make a HTTP Post to the given URL with the given content. Returns the DOM object from the response.
 * @param url the URL to post to
 * @param content the string content to post
 *
 * @deprecated use (supplied by prototype js)
 *    // the repsonse from url must have mimetype application/xml
 *    new Ajax.Request(url, {
 *        asynchronous: false, 
 *        method:       'post', 
 *        contentType, 'application/x-www-form.urlencoded',
 *        postBody: content,
 *        onSuccess: function(resp){return resp.responseXML},
 *        onFailure: function(resp){alert('Failure from server '+resp.statusText);},
 *        onException: function(req, e) { throw e;}
 *    });
 */
function sendXmlMessage(url, content) {
  var xmlhttp = null;
  if (window.XMLHttpRequest) {
      xmlhttp = new XMLHttpRequest();
      if (xmlhttp.overrideMimeType) {
          xmlhttp.overrideMimeType('text/xml');
      }
  } else if (window.ActiveXObject) {
      xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
  } else {
      alert(i18n('AJAXNotSupported'));
  }

  xmlhttp.open('POST', url, false);
  xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  xmlhttp.send(content);

  return xmlhttp.responseXML;
}