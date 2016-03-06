/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var UC_REALM_ROW = Class.create({

    /**
     * Constructor
     */
    initialize: function(row,realmId) {
        this._row         = $(row);
        this._realmId = realmId;
        this._realmSeq     = this._row.previousSiblings().length;
        this._isMoving    = false;

        var t = this;

        this._ddproxy     = this.RealmRowDD(this._row);
        this._row.observe('mouseover',     function(event){ t.highlight(); });
        this._row.observe('mouseout',      function(event){ t.removeHighlight(); });
    },

    /**
     *  adds dynamic backgroung highlighting to the cells of the target row
     */
    highlight: function() {
        if(!this._isMoving) {
          this._row.select('td').each(function(cell){cell.style.backgroundColor='#dee8ef'});
        }
        else {
          this._row.select('td').each(function(cell){cell.style.backgroundColor='#cbd37c'});
        }
    },
    
    moveHighlight: function() {
        this._row.select('td').each(function(cell){cell.style.backgroundColor='#cbd37c'});
    },

    /**
     *  removes the dynamic backgroung highlighting to the cells of the target row
     */
    removeHighlight: function() {
        if(!this._isMoving) {
          this._row.select('td').each(function(cell){cell.style.backgroundColor=''});
        }
        else {
          this._row.select('td').each(function(cell){cell.style.backgroundColor='#cbd37c'});
        }
    },
    
    
    
    RealmRowDD: function(id) {
      var that = new YAHOO.util.DDProxy(id, "Realms");
      that.self=this;
      that.setHandleElId("grabber"+that.id.replace("realm-row-",""));
      
      that.startDrag = function(x, y) { 
        var dragEl = that.getDragEl();
        var srcEl=that.getEl();
        YAHOO.util.Dom.setStyle(dragEl, "opacity", 0.00);
        YAHOO.util.Dom.setStyle(dragEl, "cursor", "move");
        
        
        this.startIndex=parseInt(that.id.replace("realm-row-", ""));
        this.curIndex=this.startIndex;
        that.self._isMoving=true;
        that.self.moveHighlight();
        YAHOO.util.DragDropMgr.refreshCache();
      }
      that.endDrag = function(e) {
        var srcEl=that.getEl();
        that.self._isMoving=false;
        YAHOO.util.Dom.setStyle(srcEl, "visibility", "");
        if(this.curIndex != this.startIndex) {
          if(confirm(i18n("RealmMoveConfirmation"))) {
            moveRealm(this.startIndex, this.curIndex);
          }
          else {
            refresh();
          }
        }
        else {
          refresh();
        }
      }
      that.onDragDrop = function(e, id) {
        var srcEl=that.getEl();
        that.self._isMoving=false;
        YAHOO.util.Dom.setStyle(srcEl, "visibility", "");
        if(confirm(i18n("RealmMoveConfirmation"))) {
          moveRealm(this.startIndex, this.curIndex);
        }
        else {
          refresh();
        }
      }
      that.onDrag = function(e) {
        var y = YAHOO.util.Event.getPageY(e);
        if (y < that.lastY) {
          this.goingUp = true;
        } else if (y > that.lastY) {
          this.goingUp = false;
        }
        this.lastY = y;
      }
      that.onDragOver = function(e, id) {
        var srcEl = that.getEl();
        var destEl = YAHOO.util.Dom.get(id);

        var orig_p = srcEl.parentNode;
        var p = destEl.parentNode;
         if (this.goingUp) {
           if(this.curIndex==parseInt(id.replace("realm-row-",""))) {
             this.curIndex=this.curIndex-1;
           }
           else {
             this.curIndex=parseInt(id.replace("realm-row-", ""));
           }
           p.insertBefore(srcEl, destEl); // insert above
         } 
         else {
           if(this.curIndex==parseInt(id.replace("realm-row-",""))) {
             this.curIndex=this.curIndex+1;
           }
           else {
             this.curIndex=parseInt(id.replace("realm-row-", ""));
           }
           p.insertBefore(srcEl, destEl.nextSibling); // insert below
         }
         YAHOO.util.DragDropMgr.refreshCache();
       }
       return that;
     }
});