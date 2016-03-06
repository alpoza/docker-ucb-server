/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var ScreenRefresh = Class.create({

    /**
     * Constructor
     */
    initialize: function( enabled, paused, secondsUntilRefresh, pauseUrl, unpauseUrl, enableUrl, disableUrl) {
        var self = this;
        this._visible = true;
        this._enabled = enabled;
        this._paused = paused;
        this._countdownTimer = null;
        this._secondsUntilRefresh = secondsUntilRefresh;
        this._secondsUntilRefreshOriginal = 30;
        this.pauseUrl = pauseUrl;
        this.unpauseUrl = unpauseUrl;
        this.enableUrl = enableUrl;
        this.disableUrl = disableUrl;
        self._onLoad();
    },

    //==================== PUBLIC API ==========================================
    setPaused: function( value ) {
        var self = this;
        if (this.getEnabled()) {
            // we cannot pause or unpause a disabled refresh timer.
            if (this._paused != value) {
                this._paused = value;
                if (this._paused) {
                    if (this._countdownTimer != null) {
                        window.clearInterval(this._countdownTimer);
                        this._countdownTimer = null;
                    }
                } else {
                    if (this._countdownTimer == null) {
                        this._countdownTimer = window.setInterval( function() { self._refreshCountdown();}, 1000 );
                    }
                }
                self._updateDisplay();

                // update our session.
                if (this._paused) {
                    new Ajax.Request(this.pauseUrl, {method:'get'});
                } else {
                    new Ajax.Request(this.unpauseUrl, {method:'get'});
                }
            }
        }
    },

    getPaused: function() {
        return this._paused;
    },

    setEnabled: function( value ) {
        var self = this;
        if (this._enabled != value) {
            if (value) {
                if (this._countdownTimer == null) {
                    this._countdownTimer = window.setInterval( function() { self._refreshCountdown(); }, 1000 );
                }
            } else {
                this._clearTimer();
                this.setSecondsUntilRefresh( this._secondsUntilRefreshOriginal );
                this.setPaused( false );
            }
            this._enabled = value;

            // update our session.
            if (this._enabled) {
                new Ajax.Request(this.enableUrl, {method:'get'});
            } else {
                new Ajax.Request(this.disableUrl, {method:'get'});
            }
            self._updateDisplay();
        }
    },

    getEnabled: function() {
        return this._enabled;
    },

    setVisible: function( value ) {
        this._visible = value;
    },

    getVisible: function() {
        return this._visible;
    },

    setSecondsUntilRefresh: function( value ) {
        this._secondsUntilRefresh = value;
    },

    getSecondsUntilRefresh: function() {
        return this._secondsUntilRefresh;
    },

    //==================== PRIVATE API =========================================

    _onLoad: function( e, obj ) {
        this._setScrollPosition();

        var self = this;

        if (this._enabled && !this._paused) {
            this._countdownTimer = window.setInterval( function() { self._refreshCountdown(); }, 1000 );
        }

        var container = $( 'refresh-timer-container' );
        container.update('<div id="refresh-timer" class="refresh-timer"></div>'
                       + '<a id="refresh-button" class="refresh-button-enabled"></a>'
                       + '<span id="control-container">&nbsp;|&nbsp;'
                           + '<a id="pause-button" class="refresh-button-enabled">' + i18n('Pause').toUpperCase() + '</a>&nbsp;|&nbsp;'
                           + '<a id="resume-button" class="refresh-button-enabled">' + i18n('Resume').toUpperCase() + '</a>'
                       + '</span>');

        Element.observe( 'refresh-button', 'click', function( e ) { self._eventToggleRefresh( e ); });
        Element.observe( 'pause-button', 'click', function( e ) { self._eventPause( e ); });
        Element.observe( 'resume-button', 'click', function( e ) { self._eventResume( e ); });

        this._updateDisplay();
    },

    _eventToggleRefresh: function( e ) {
        this.setEnabled( !this.getEnabled() );
    },

    _eventPause: function( e ) {
        this.setPaused( true );
    },

    _eventResume: function( e ) {
        this.setPaused( false );
    },

    _refreshCountdown: function() {
        this.setSecondsUntilRefresh( this.getSecondsUntilRefresh() - 1 );
        this._updateDisplay();
        if (this.getSecondsUntilRefresh() == 0) {
            this.setSecondsUntilRefresh( this._secondsUntilRefreshOriginal );
            this._clearTimer();
            this._saveScrollPosition();
            window.location.reload();
        }
    },

    _clearTimer: function() {
        if (this._countdownTimer) {
            window.clearInterval(this._countdownTimer);
            this._countdownTimer = null;
        }
    },

    _updateDisplay: function() {
        var container = $( 'refresh-timer-container' );

        if (container) {
            if (this._visible) {
                var controlContainer = $( 'control-container' );
                var refreshTimer = $( 'refresh-timer' );
                var refreshButton = $( 'refresh-button' );
                var pauseButton = $( 'pause-button' );
                var resumeButton = $( 'resume-button' );

                refreshTimer.innerHTML = this._generateTimerElement();
                refreshButton.innerHTML = this._generateButtonElement();

                // Update our display based on whether we are paused or not.
                if (this.getPaused()) {
                    pauseButton.removeClassName( 'refresh-button-enabled' );
                    pauseButton.addClassName( 'refresh-button-disabled' );
                    resumeButton.removeClassName( 'refresh-button-disabled' );
                    resumeButton.addClassName( 'refresh-button-enabled' );
                } else {
                    pauseButton.removeClassName( 'refresh-button-disabled' );
                    pauseButton.addClassName( 'refresh-button-enabled' );
                    resumeButton.removeClassName( 'refresh-button-enabled' );
                    resumeButton.addClassName( 'refresh-button-disabled' );
                }

                // update our display based on whether we are enabled or not.
                if (this.getEnabled()) {
                    controlContainer.show();
                } else {
                    controlContainer.hide();
                }

                // Make the whole section visible.
                container.show();
            } else {
                container.hide();
            }

            container.removeClassName( 'refresh-timer-container-enabled' );
            container.removeClassName( 'refresh-timer-container-disabled' );
            if (this._enabled) {
                container.addClassName( 'refresh-timer-container-enabled' );
            } else {
                container.addClassName( 'refresh-timer-container-disabled' );
            }
        }
    },

    _generateTimerElement: function() {
        if (this.getEnabled()) {
            return '' + (this.getSecondsUntilRefresh() == 0 ? i18n('RefreshingNow') : i18n('RefreshInTimeInterval', this.getSecondsUntilRefresh()));
        }
        return '';
    },

    _generateButtonElement: function() {
        return '' + (this.getEnabled() ? i18n('DisableRefresh').toUpperCase() : i18n('EnableRefresh').toUpperCase());
    },

    _saveScrollPosition: function() {
        var offsets = document.viewport.getScrollOffsets();
        var left = offsets.left;
        var top = offsets.top;
        var expirationDate = new Date();
        expirationDate.setDate(expirationDate.getDate() + 1);

        document.cookie = "leftPageOffset=" + left + ";expires=" + expirationDate.toUTCString() + ";max-age=60*60*24";
        document.cookie = "topPageOffset=" + top + ";expires=" + expirationDate.toUTCString() + ";max-age=60*60*24";
    },

    _setScrollPosition: function() {
        var left = this._getCookie("leftPageOffset");
        var top = this._getCookie("topPageOffset");
        window.scrollTo(left, top);
    },

    // Returns the value of a cookie or 0 if the cookie is not found.
    // If the cookie is found, the cookie is removed.
    _getCookie: function(cookieName) {
        var name;
        var value;
        var cookieArray = document.cookie.split(";");

        for (var i = 0; i < cookieArray.length; i++) {
            name = cookieArray[i].substr(0, cookieArray[i].indexOf("="));
            value = cookieArray[i].substr(cookieArray[i].indexOf("=") + 1);
            name = name.replace(/^\s+|\s+$/g,"");

            if (name == cookieName) {
                var date = new Date();
                document.cookie =
                    cookieName + "=" + value + ";expires=" + date.toGMTString() + ";";

                return unescape(value);
            }
        }

        return 0;
    }
});
