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
var UC_CLIENT_SESSION = Class.create({

    /**
     * Constructor
     * 
     * @param options a map containing various flags
     *            clientSessionSetPropUrl the URL to use for setting properties on the server.
     */
    initialize: function(options) {
        this._clientSessionSetPropUrl = options && options['clientSessionSetPropUrl'];
    },

    /**
     * Set the given property to have the given value.
     * @param pname the name of the property to set
     * @param pvalue the value of the property to set
     */
    setProperty: function(pname, pvalue) {
        new Ajax.Request(this._clientSessionSetPropUrl, {method:'post', parameters:{name:pname, value:pvalue}});
    },

    /**
     * Remove the given property from the client-session.
     * @param pname the name of the property to remove or an 'iterable' of property names to remove
     */
    removeProperty: function(pname) {
    	var params = null;
    	if (pname instanceof String || typeof pname == 'string') {
    		params = {'name':pname}
    	}
    	else {
    		// need to turn into parameter string
    		params = $A(pname).collect(function(key){ return 'name='+encodeURIComponent(key)}).join('&');
    	}
    	new Ajax.Request(this._clientSessionSetPropUrl, {'method':'post', 'parameters':params});
    }
});