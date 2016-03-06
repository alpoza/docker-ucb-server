/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/**
 *
 */
var UC_WORKFLOW_PROPERTY_ROW = Class.create({

    _DD_GROUP_NAME: 'workflowProps',

    /**
     * Constructor
     */
    initialize: function(row, propertyIdx, options) {
        this._row         = $(row);
        this._propertyIdx = propertyIdx;
        this._stepSeq     = this._row.previousSiblings().length;
        this._isMoving    = false;

        var t = this;

        this._onChange = options.onChange;

        this._ddproxy     = this.createRowDD(this._row);

        this._row.observe('mouseover',     function(event){ t.highlight(); });
        this._row.observe('mouseout',      function(event){ t.removeHighlight(); });
    },

    /**
     *  adds dynamic backgroung highlighting to the cells of the target row
     */
    highlight: function() {
        if(!this._isMoving) {
          this._row.addClassName('property-row-highlight');
        }
        else {
          this._row.addClassName('property-row-moving');
        }
    },

    moveHighlight: function() {
        this._row.addClassName('property-row-highlight');
    },

    /**
     *  removes the dynamic backgroung highlighting to the cells of the target row
     */
    removeHighlight: function() {
        if(!this._isMoving) {
          this._row.removeClassName('property-row-highlight');
        }
        else {
          this._row.removeClassName('property-row-moving');
        }
    },

    /**
     *
     */
    createRowDD: function(rowElem) {
      var t = this;

      var idx = parseInt(rowElem.id.replace('property-row-', ""), 10);

      var ddProxy = new YAHOO.util.DDProxy(rowElem, t._DD_GROUP_NAME);
      ddProxy.self=this;
      ddProxy.setHandleElId(rowElem.id+"-grabber");
      ddProxy.setXConstraint(0,0);


      ddProxy.startDrag = function(x, y) {
        var dragEl = ddProxy.getDragEl();
        var srcEl=ddProxy.getEl();
        // hide the YUI drag avatar
        YAHOO.util.Dom.setStyle(dragEl, "opacity", 0.00);
        YAHOO.util.Dom.setStyle(dragEl, "cursor", "move");

        // reset state
        ddProxy.proxyState = {
                startIndex: idx,
                curIndex: idx,
                goingUp: false
                // TODO lastY?
        };

        ddProxy.self._isMoving=true;
        ddProxy.self.moveHighlight();
        YAHOO.util.DragDropMgr.refreshCache();
      };
      ddProxy.endDrag = function(e) {
        var srcEl=ddProxy.getEl();
        ddProxy.self._isMoving=false;
        t._onChange(this.proxyState.startIndex, this.proxyState.curIndex);
      };
      ddProxy.onDragDrop = function(e, id) {
        var srcEl=ddProxy.getEl();
        ddProxy.self._isMoving=false;
      };
      ddProxy.onDrag = function(e) {
        var y = YAHOO.util.Event.getPageY(e);
        if (y < ddProxy.lastY) {
          this.proxyState.goingUp = true;
        } else if (y > ddProxy.lastY) {
          this.proxyState.goingUp = false;
        }
        this.lastY = y;
      };

      // animate the drag, shifting existing rows
      ddProxy.onDragOver = function(e, destId) {
        var srcEl = ddProxy.getEl();
        var destEl = YAHOO.util.Dom.get(destId);

        var orig_p = srcEl.parentNode;
        var p = destEl.parentNode;
        var destIdx = parseInt(destId.replace("property-row-",""), 10);
         if (this.proxyState.goingUp) {
           if(this.proxyState.curIndex===destIdx) {
             this.proxyState.curIndex=this.proxyState.curIndex-1;
           }
           else {
             this.proxyState.curIndex=destIdx;
           }
           p.insertBefore(srcEl, destEl); // insert above
         }
         else {
           if(this.proxyState.curIndex===destIdx) {
             this.proxyState.curIndex=this.proxyState.curIndex+1;
           }
           else {
             this.proxyState.curIndex=destIdx;
           }
           p.insertBefore(srcEl, destEl.nextSibling); // insert below
         }
         YAHOO.util.DragDropMgr.refreshCache();
       };
       return ddProxy;
     }
});