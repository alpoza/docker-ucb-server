/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/

//------------------------------------------------------------------------------
function inClass(element, cls) {
  assertElement(element);
  var classFound = false;

  if (element.className) {
    var classes = element.className.split(/\s+/);
     
    for (var i = 0; i < classes.length; ++i) {
      if (classes[i] == cls) {
        classFound = true;
        
        break;
      }
    }
  }

  return classFound;
}

//------------------------------------------------------------------------------
function treeFindElementByClass(root, cls) {
  var target = null;
  
  if (root && cls && root.nodeType && root.nodeType == 1) {
    if (root.hasChildNodes()) {
      var element = firstChildElement(root);
      
      while (element != null) {
        if (inClass(element, cls)) {
          target = element;
          break;
        }
        
        target = treeFindElementByClass(element, cls);
        
        if (target) {
          break;
        }
        
        element = nextElement(element);
      }
    }
  }
  else {
    debugAlert("Invalid arguments: root: " + root + "; cls: " + cls);
  }
  
  return target;
}

//------------------------------------------------------------------------------
function firstChildElement(element) {
  assertElement(element);
  var child = null;
  var nodes = element.childNodes;
  
  if (nodes) {
    for (var i = 0; i < nodes.length; ++i) {
      var node = nodes[i];
      
      if (node.nodeType == 1) {
        child = node;
        break;
      }
    }
  }
  
  return child;
}

//------------------------------------------------------------------------------
function nextElement(element) {
  assertElement(element);
  
  do {
    element = element.nextSibling;
  }
  while (element && element.nodeType != 1);

  return element;
}

//------------------------------------------------------------------------------  
function getStyle(element) {
  assertElement(element);
  var style = null;
  
  if (element.currentStyle) {
    style = element.currentStyle;
  } 
  else if (document.defaultView && document.defaultView.getComputedStyle) {
    style = document.defaultView.getComputedStyle(element,'');
  }
  else {
    style = element.style;
  }
  
  return style;
}

//------------------------------------------------------------------------------  
function toggleIssueDetail(td) {
  assertTag(td, "td");
  
  if (td) {
    var issueRow = td.parentNode;
    assertTag(issueRow, "tr");
    assertClass(issueRow, "issue");
    
    var detailRow = nextElement(issueRow);
    assertTag(detailRow, "tr");
    assertClass(detailRow, "issueDetail");

    var iconElement = firstChildElement(td);
    
    if (detailRow) {
      //alert("found 1st detail row");
      var style = getStyle(detailRow);
      
      if (style.display == "none") {
        expandIssueDetail(detailRow);  
        showIssueDetailExpandedIcon(iconElement);
      }
      else {
        shrinkIssueDetail(detailRow);
        showIssueDetailShrunkIcon(iconElement);
      }

      var detail2Row = nextElement(detailRow);

      if (detail2Row && detail2Row.className == "issueDetail") {
        //console.log("found 2nd detail row: " + detail2Row);
        //console.log(detail2Row)
        var style = getStyle(detail2Row);

        if (style.display == "none") {
          expandIssueDetail(detail2Row);
        }
        else {
          shrinkIssueDetail(detail2Row);
        }
      }
    }
  }
}

//------------------------------------------------------------------------------
function showIssueDetailExpandedIcon(element) {
  assertElement(element);
  
  if (element) {
    var plus = treeFindElementByClass(element, "plus");
    var minus = treeFindElementByClass(element, "minus");
    
    if (plus !== null) {
        plus.style.display = "none";
    }
    
    if (minus !== null) {
        minus.style.display = "inline";
    }
  }
}

//------------------------------------------------------------------------------
function showIssueDetailShrunkIcon(element) {
  assertElement(element);

  if (element) {
    var plus = treeFindElementByClass(element, "plus");
    var minus = treeFindElementByClass(element, "minus");
    if (plus !== null) {
        plus.style.display = "inline";
    }
    
    if (minus !== null) {
        minus.style.display = "none";
    }
  }
}

//------------------------------------------------------------------------------
function expandIssueDetail(detailRow) {
  assertTag(detailRow, "tr");
  assertClass(detailRow, "changeIssue");
  showRow(detailRow);
}

//------------------------------------------------------------------------------
function showRow(row) {
  assertTag(row, "tr");
  row.style.display = "";
}

//------------------------------------------------------------------------------
function hideRow(row) {
  assertTag(row, "tr");
  row.style.display = "none";
}

//------------------------------------------------------------------------------
function isHidden(element) {
  assertElement(element);
  var style = getStyle(element);
  return style.display != "none";
}

//------------------------------------------------------------------------------
function shrinkIssueDetail(detailRow) {
  assertTag(detailRow, "tr");
  assertClass(detailRow, "issueDetail");
  detailRow.style.display = "none";
}