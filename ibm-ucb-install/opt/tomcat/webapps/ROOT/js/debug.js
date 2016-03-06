/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
// to use on a page set "var debug = true;"

//------------------------------------------------------------------------------
function debugAlert(message) {
  if (window.debug) {
    if (debugAlert.caller) {
      var name = getFunctionName(debugAlert.caller);
    
      if (name) {
        message = name + ": " + message;
      }
    }
    
    message += "\n" + getStackTrace();
    alert("DEBUG: " + message);
  }
}  

//------------------------------------------------------------------------------
function assert(test, message) {
  if (window.debug && !test) {
    if (assert.caller) {
      var name = getFunctionName(assert.caller);
    
      if (name) {
        message = name + ": " + message;
      }
    }
    
    message = "ASSERT: " + message;
    message += "\n" + getStackTrace();
    alert(message);
    
    throw message;
  }
}

//------------------------------------------------------------------------------
function assertElement(element) {
if (window.debug) {
  var message = "";
      
  if (!element || !element.nodeType || element.nodeType != 1) {
    message = "Not an element: " + element;
  }
  
  if (message != "") {
    var caller = assertClass.caller;
    
    if (caller) {
      var name = getFunctionName(caller);
    
      if (name) {
        message = name + ": " + message;
      }
    }
    
    message = "ASSERT ELEMENT: " + message;
    message += "\n" + getStackTrace(); 
    alert(message);
       
    throw message;
  }
}
}

//------------------------------------------------------------------------------
function assertClass(element, cls) {
  if (window.debug) {
    if (cls) {
      var message = "";
      
      if (!element || !element.nodeType || element.nodeType != 1) {
        message = "Not an element: " + element;
      }
      else if (!element.className) {
        message = "Element has no class";
      }
      else {
        if (!hasClass(element, cls)) {
          message = "class " + cls + " not in " + element.className;
        }
      }
        
      if (message != "") {
        var caller = assertClass.caller;
        
        if (caller) {
          var name = getFunctionName(caller);
        
          if (name) {
            message = name + ": " + message;
          }
        }
        
        
        message = "ASSERT CLASS: " + message;
        message += "\n" + getStackTrace(); 
        alert(message);
          
        throw message;
      }
    }
    else {
      debugAlert("Invalid arguments: element: " + element + "; cls: " + cls);
    }
  }
}


//--------------------------------------------------------------------------------
function getStackTrace() {
  var caller = getStackTrace.caller;
  var trace = "Stack trace:\n";
  
  while (caller) {
    trace += "  " + getFunctionName(caller) + "()\n";
    caller = caller.caller;
  }
  
  return trace;
}

//------------------------------------------------------------------------------
function assertTag(element, tag) {
  if (window.debug) {
    if (tag) {
      var message = "";
      
      if (!element || !element.nodeType || element.nodeType != 1 || !element.tagName) {
        message = "Not an element: " + element;
      }
      else {
        if (element.tagName.toLowerCase() != tag.toLowerCase()) {
          message = "element tag " + element.tagName + " is not " + tag;
        }
      }
        
      if (message != "") {
        var caller = assertTag.caller;
        
        if (caller) {
          var name = getFunctionName(caller);
        
          if (name) {
            message = name + ": " + message;
          }
        }
        
        message = "ASSERT TAG: " + message; 
        message += "\n" + getStackTrace();
        alert(message);
          
        throw message;
      }
    }
    else {
      debugAlert("Invalid arguments: element: " + element + "; tag: " + tag);
    }
  }
}

//------------------------------------------------------------------------------
function getFunctionName(fn) {
  var name = null;
  
  if (fn) {
    if (fn.name) {
      name = fn.name;
    }
    else {
      var source = fn.toString();
      
      if (source) {
        var re = /^\s*function\W+([A-Za-z_]\w*).*$/im;
        var result = re.exec(source);
        
        if (result) {
          name = result[1];  
        }
      }
    }
  }
  
  return name;
}