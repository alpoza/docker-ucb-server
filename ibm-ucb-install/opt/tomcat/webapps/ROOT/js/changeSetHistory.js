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
function treeFindElementByTag(root, tag) {
  assertElement(root);
  var target = null;
  
  if (root.hasChildNodes()) {
    var element = firstChildElement(root);
    
    while (element != null) {
      if (element.tagName && element.tagName.toLowerCase() != tag.toLowerCase()) {
        target = element;
        break;
      }
      
      target = treeFindElementByTag(element, tag);
      
      if (target) {
        break;
      }
      
      element = nextElement(element);
    }
  }
  
  return target;
}  

//------------------------------------------------------------------------------
function getTable(node) {
  var table = node;
  
  while (table && table.tagName.toLowerCase() != "table") {
    table = table.parentNode;
  }
  
  return table;
}

//------------------------------------------------------------------------------
function removeChildren(node) {
  if (node && node.hasChildNodes()) {
    var child = node.lastChild;
    
    while (child) {
      node.removeChild(child);
      child = node.lastChild;
    }
  }
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
function toggleChangeDetail(td) {
  assertTag(td, "td");
  
  if (td) {
    var changeRow = td.parentNode;
    assertTag(changeRow, "tr");
    assertClass(changeRow, "change");
    
    var detailRow = nextElement(changeRow);
    assertTag(detailRow, "tr");
    assertClass(detailRow, "changeDetail");

    var iconElement = firstChildElement(td);
    
    if (detailRow) {
      //alert("found 1st detail row");
      var style = getStyle(detailRow);
      
      if (style.display == "none") {
        expandChangeDetail(detailRow);  
        showChangeDetailExpandedIcon(iconElement);
      }
      else {
        shrinkChangeDetail(detailRow);
        showChangeDetailShrunkIcon(iconElement);
      }

      var detail2Row = nextElement(detailRow);

      if (detail2Row && detail2Row.className == "changeDetail") {
        //console.log("found 2nd detail row: " + detail2Row);
        //console.log(detail2Row)
        var style = getStyle(detail2Row);

        if (style.display == "none") {
          expandChangeDetail(detail2Row);
        }
        else {
          shrinkChangeDetail(detail2Row);
        }
      }
    }
  }
}

//------------------------------------------------------------------------------
function showChangeDetailExpandedIcon(element) {
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
function showChangeDetailShrunkIcon(element) {
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
function toggleFileList(span) {
  assertTag(span, "span");
  
  if (span) {
    var fileList = nextElement(span);
    assertTag(fileList, "div");
    assertClass(fileList, "fileList");
   
    if (fileList) {
      var style = getStyle(fileList);
     
      if (style.display == "none") {
        expandFileList(fileList);
      }
      else {
        shrinkFileList(fileList);
      }
    }
  }
}

//------------------------------------------------------------------------------
function expandChangeDetail(detailRow) {
  assertTag(detailRow, "tr");
  assertClass(detailRow, "changeDetail");
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
function shrinkChangeDetail(detailRow) {
  assertTag(detailRow, "tr");
  assertClass(detailRow, "changeDetail");
  detailRow.style.display = "none";
  var fileList = treeFindElementByClass(detailRow, "fileList");
  assertTag(fileList, "div");
  assertClass(fileList, "fileList");
  shrinkFileList(fileList);
}

//------------------------------------------------------------------------------
function expandFileList(fileList) {
  assertTag(fileList, "div");
  assertClass(fileList, "fileList");
  fileList.style.display = "block";  
}

//------------------------------------------------------------------------------
function shrinkFileList(fileList) {
  if (fileList) {
    assertTag(fileList, "div");
    assertClass(fileList, "fileList");
    fileList.style.display = "none";
  }
}

//------------------------------------------------------------------------------
function findChangeRowsForBuildRow(buildRow) {
  assertTag(buildRow, "tr");
  assertClass(buildRow, "build");
  
  var buildIndex = buildRow.rowIndex;
  var table = getTable(buildRow);
  var changeRows = new Array();
  
  for (var i = buildIndex + 1; i < table.rows.length; ++i) {
    var row = table.rows[i];
    assertTag(row, "tr");
    if (inClass(row, "change")) {
      changeRows.push(row);
    }  
    else if (inClass(row, "build")) {
      break;
    }
  }
  
  return changeRows;
}

//------------------------------------------------------------------------------
function findDetailRowForChangeRow(changeRow) {
  assertTag(changeRow, "tr");
  assertClass(changeRow, "change");
  
  var detailIndex = changeRow.rowIndex + 1;
  var table = getTable(changeRow);
  var detailRow = null;
  
  if (detailIndex < table.rows.length) {
    var row = table.rows[detailIndex];
    assertTag(row, "tr");
    
    if (inClass(row, "changeDetail")) {
      detailRow = row;
    }
  }  
  
  return row;
}

//------------------------------------------------------------------------------
function expandChangeRows(changeRows) {
  for (var i = 0; i < changeRows.length; ++i) {
    showRow(changeRows[i]);
  }
}

//------------------------------------------------------------------------------
function shrinkChangeRows(changeRows) {
  for (var i = 0; i < changeRows.length; ++i) {
    var changeRow = changeRows[i];
    showChangeDetailShrunkIcon(changeRow);
    changeRow.style.display = "none";
    var detailRow = findDetailRowForChangeRow(changeRow);
    
    if (detailRow) {
      shrinkChangeDetail(detailRow);
    }
  }
}

//------------------------------------------------------------------------------  
function toggleBuild(td) {
  assertTag(td, "td");
  
  var buildRow = td.parentNode;
  assertTag(buildRow, "tr");
  assertClass(buildRow, "build");
  
  var changeRows = findChangeRowsForBuildRow(buildRow);
  if (changeRows.length) {
    var hidden = isHidden(changeRows[0]);
    
    if (hidden) {
	expandChangeRows(changeRows);
    }
    else {
	shrinkChangeRows(changeRows);
    }
  }
}
