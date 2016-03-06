/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/**
 * Takes an object with the following fields:
 * @param relativeLogFile
 * @param pathSeparator
 * @param linesPerPage
 * @param totalLineCount
 * @param finished
 * @param linesOfInterest
 *
 */
function LogFile(options) {
    var self = this;
    this.logContainer = $('log-container');

    
    //
    //State methods
    //

    //------------------------------------------------------------------------------
    this.getNumberOfPagesInIndex = function() {
        return self.numberOfPagesInIndex;
    };


    //------------------------------------------------------------------------------
    this.getLinesOfInterest = function() {
        return self.linesOfInterest;
    };

    this.setLinesOfInterest = function(linesOfInterest) {
        self.linesOfInterest = linesOfInterest;
        if (self.linesOfInterest && self.linesOfInterest.length > 0) {
            self.getNextLineOfInterestButton().show();
        }
        else {
            self.getNextLineOfInterestButton().hide();
        }
    };

    //------------------------------------------------------------------------------
    this.getRelativeLogFile = function() {
        return self.relativeLogFile;
    };

    //------------------------------------------------------------------------------
    this.setRelativeLogFile = function(relativeLogFile) {
        self.relativeLogFile = relativeLogFile;
    };

    //------------------------------------------------------------------------------
    this.getPathSeparator = function() {
        return self.pathSeparator;
    };

    //------------------------------------------------------------------------------
    this.setLinesPerPage = function(linesPerPage) {
        self.linesPerPage = linesPerPage;
    };

    //------------------------------------------------------------------------------
    this.getLinesPerPage = function() {
        return self.linesPerPage;
    };

    //------------------------------------------------------------------------------
    this.getTotalLineCount = function() {
        return self.totalLineCount;
    };

    //------------------------------------------------------------------------------
    this.setTotalLineCount = function(lineCount) {
        self.totalLineCount = lineCount;
        self.getLineCountMessage().update(self.totalLineCount);
        self.getPageCountMessage().update(self.getLastPage());
        self.initializePager();
    };

    this.getLogContent = function() {
        return self.logContainer.down('.log-content');
    };

    this.getLineNumberPane = function() {
        return self.logContainer.down('.log-line-numbers');
    };

    this.getLineTextPane = function() {
        return self.logContainer.down('.log-text-content');
    };

    /**
     * @param lineNumber the absolute line number
     * @return the line-number-X element
     */
    this._getLineNumberElement = function(lineNumber) {
        return $('line-number-' + self._getRelativeLineNumber(lineNumber));
    };

    /**
     * @param lineNumber the absolute line number
     * @return the line-X element
     */
    this._getLineTextElement = function(lineNumber) {
        return $('line-text-' + self._getRelativeLineNumber(lineNumber));
    };

    this.getSearchForm = function() {
        return self.logContainer.down('.searchForm');
    };

    this.getGotoLineForm = function() {
        return self.logContainer.down('.jumpToLineForm');
    };

    this.getNextLineOfInterestButton = function() {
        return self.logContainer.down('.next-line-of-interest');
    };

    this.getPager = function() {
        return self.logContainer.down('.nav-list');
    };

    this.getFirstPageLink = function() {
        return self.logContainer.down('.first_page_link');
    };

    this.getPrevPageLink = function() {
        return self.logContainer.down('.prev_page_link');
    };

    this.getNextPageLink = function() {
        return self.logContainer.down('.next_page_link');
    };

    this.getLastPageLink = function() {
        return self.logContainer.down('.last_page_link');
    };


    this.getLogWorkingElement = function() {
        return self.logContainer.down('.log-working');
    };

    this.getDownloadButton = function() {
        return $('download_button');
    };

    this.getLineCountMessage = function() {
        return self.logContainer.down('.line-count-container');
    };

    this.getPageCountMessage = function() {
        return self.logContainer.down('.last-page');
    };

    this.getCurrentPageMessage = function() {
        return self.logContainer.down('.current-page');
    };

    /**
     * Initialize or re-initialize the carousel pager.
     * This method needs to be called whenever the total number of lines changes.
     */
    this.initializePager = function() {
        var pager = self.getPager();
        var numPages = self.getLastPage();

        var oldNumPages = self.navigation ? self.navigation.getProperty('size') : 0;
        var newPages = new Array();
        for (var i = oldNumPages+1; i <= numPages; i++) {
            newPages.push('<li id="nav-item-'+i+'"><a id="nav-item-link-'+i+'">'+i+'</a></li>');
        }
        pager.insert(newPages.join(''));

    //    if (!self.naviation) {
        self.navigation = new YAHOO.extension.Carousel('nav', {
            numVisible:             self.getNumberOfPagesInIndex(),
            firstVisible:           (!self.navigation ? 1 : self.navigation.getFirstItemRevealed()),
            animationSpeed:         0.25,
            scrollInc:              self.getNumberOfPagesInIndex(),
            navMargin:              0,
            prevElement:            'prev-arrow',
            nextElement:            'next-arrow',
            size:                   numPages,
            prevButtonStateHandler: self.handlePrevButtonState,
            nextButtonStateHandler: self.handleNextButtonState
        }
    );
    //    }
    //   else {
    //        self.navigation.setProperty('size', numPages, true);
    //    }
    };

    /**
     * Update the highlighting of the selectedLine, jumpedToLine, and lines-of-interest
     */
    this.uiUpdatePageHighlighting = function() {

        // add javascript to highlight the current line.
        if (self._isLineOnCurrentPage(self.selectedLineNumber)) {
            self._getLineTextElement(self.selectedLineNumber).addClassName('line-highlight');
            self._getLineNumberElement(self.selectedLineNumber).addClassName('line-highlight');
        }

        // clear highlighting on the interest lines.
        self.getLineNumberPane().select('div.line-number-interest').each(function(it){it.removeClassName('line-interest')});
        self.getLineTextPane().select('div.line-interest').each(function(it){it.removeClassName('line-interest')});

        // highlight the lines of interest.
        var i;
        for(i = 0; i < self.linesOfInterest.length; ++i) {
            var lineOfInterest = self.linesOfInterest[i] - 1; // convert to 0-based line number
            if (self._isLineOnCurrentPage(lineOfInterest)) {
                self._getLineNumberElement(lineOfInterest).addClassName("line-interest");
                self._getLineTextElement(lineOfInterest).addClassName("line-interest");
            }
        }
    };

    /**
     * Render the current page from scratch via a call to the server for content
     */
    this.displayPage = function() {
        if (self.getTotalLineCount() <= 0) {
            /* Update the UI display of the current page. */
            self.uiUpdateCurrentPage();
            self.getLineNumberPane().update("<div id='line-number-0' class='line-number'></div>");
            self.getLineTextPane().update("<div id='line-text-0' class='line-text'>&nbsp;<span class='bold'>Log not found</span></div>");
            return;
        }

        var lineOffset = (self.getCurrentPage() - 1) * self.getLinesPerPage();
        var lineCount = lineOffset + self.getLinesPerPage();
        if (isNaN(lineOffset) || isNaN(lineCount)) {
            return;
        }

        /**
         * update the content of the log-viewer with the response text
         */
        var responseSuccess = function(resp){
            /* Update the UI display of the current page. */
            self.uiUpdateCurrentPage();

            /* Update the UI display of the line numbers. */
            /* Update the UI display of the log data. */
            var lineNumberDiv = self.getLineNumberPane();
            var content = self.getLogContent();
            var element = self.getLineTextPane();

            var firstLine = self.getShowingFirstLine();
            var startIndex = 0;
            var endIndex = 0;
            var i = 0;

            var lineArray = new Array(self.getLinesPerPage());
            var textArray = new Array(self.getLinesPerPage());

            var text = resp.responseText;
            while (endIndex !== -1) {
                endIndex = text.indexOf('\n', startIndex);
                if (endIndex !== -1) {
                    // Update the lines on the left.
                    lineArray[i] = "<div class='line-number' id='line-number-".concat(i).concat("'>").concat((firstLine + i + 1)).concat("</div>");

                    // Update the line content on the right.
                    textArray[i] = "<div id='line-text-".concat(i)
                    .concat("' class='line-text'>&nbsp;")
                    .concat(text.substring(startIndex, endIndex)
                            .replace(/&/g,"&amp;")
                            .replace(/"/g,"&quot;")
                            .replace(/</g,"&lt;")
                            .replace(/>/g,"&gt;")
                            .replace(/'/g,"&#039;")
                    )
                    .concat("</div>");

                    startIndex = endIndex + 1;
                    ++i;
                }
            }

            // Create our new content.

            var oldScrollTop = content.scrollTop;
            content.scrollTop = 0;

            lineNumberDiv.update(lineArray.join(''));
            element.update(textArray.join(''));
            self.uiUpdatePageHighlighting();

            // preserve scroll position
            if (oldScrollTop <= (content.scrollHeight - content.clientHeight)) {
                content.scrollTop = oldScrollTop;
            }

            // update total-lines if needed
            /*
            if (self.getCurrentPage() == self.getLastPage()) {
                var lastLineElement = self.getLineTextPane().immediateDescendants().last();
                var lastLineNumber = self._getAbsoluteLineNumber(lastLineElement);
                self.setTotalLineCount(lastLineNumber + 1); // line number is 0-based
            }
            */
        };

        new Ajax.Request(self.fetchLogChunkUrl, {
                'asynchronous': false,
                'method': 'post',
                'parameters': {
                    'relativeLogFile': self.getRelativeLogFile(),
                    'pathSeparator':   self.getPathSeparator(),
                    'lineOffset':      lineOffset,
                    'lineCount':       lineCount
                },
                'onSuccess':   responseSuccess,
                'onFailure':   function(resp){alert(i18n("Failure loading", url))},
                'onComplete':  function(resp){ /* perform 'finally' style cleanup */},
                'onException': function(req, e){throw e;} // propagate exceptions up to the console
            });
    };

    /**
    * Update the current-page-number display
    */
    this.uiUpdateCurrentPage = function() {
        self.getCurrentPageMessage().update(self.getCurrentPage());
    };

    /**
    * Query the server for the total number of lines in the log file and if the file is complete.
    * Update the page display if in tailing mode or if there are updates to the current page.
    */
    this.updateView = function() {
        var responseSuccess = function(o){
            // update our displayed line count.
            var responseRoot = o.responseJSON;

            // update lines of interest
            if (responseRoot.isFinished && responseRoot.linesOfInterest) {
                self.setLinesOfInterest(responseRoot.linesOfInterest);
                }

            // scroll to tail-content only if there has been an increase in the number of lines available.
            if (self.getTotalLineCount() !== responseRoot.linecount) {
                var wasLastPage = self.getCurrentPage() === self.getLastPage();
                var wasTailing = self.isTailing();

                self.setTotalLineCount(responseRoot.linecount);
                if (wasTailing) {
                    self._showTail();
                    }
                else if (wasLastPage) {
                    // re-render page due to presence of additional content
                    self.displayPage();
                }
                else {
                    // nothing to do, all new content is on pages off-screen
                }
             }

            if (responseRoot.isFinished) {
                // stop tailing and no more updates
                self.setIsFinished(true);
            }
            else {
                // set up next poll event
                setTimeout(function() { self.updateView(); }, 5000);
            }
        };

        new Ajax.Request(self.updateViewUrl, {
            'asynchronous': true,
            'method': 'post',
            'parameters': {
                'relativeLogFile': self.getRelativeLogFile(),
                'pathSeparator':   self.getPathSeparator()
            },
            'onSuccess':   responseSuccess,
            'onFailure':   function(resp){alert(i18n("Failure loading", url))},
            'onComplete':  function(resp){ /* perform 'finally' style cleanup */},
            'onException': function(req, e){throw e;} // propagate exceptions up to the console
            });
    };

    //------------------------------------------------------------------------------
    this.gotoNextPage = function() {
        self.setCurrentPage(self.getCurrentPage() + 1);
    };

    //------------------------------------------------------------------------------
    this.gotoPrevPage = function() {
      self.setCurrentPage(self.getCurrentPage() - 1);
    };

    //------------------------------------------------------------------------------
    this.gotoNextLineOfInterest = function() {
        if (self.linesOfInterest.length > 0) {
            self.currentLineOfInterest++;
            if (self.currentLineOfInterest >= self.linesOfInterest.length) {
                currentLineOfInterest = 0;
            }
            self.setSelectedLine(self.linesOfInterest[self.currentLineOfInterest] - 1);
        }
    };

    //------------------------------------------------------------------------------
    this.gotoPrevLineOfInterest = function() {
        if (self.linesOfInterest.length > 0) {
            self.currentLineOfInterest--;
            if (self.currentLineOfInterest < 0) {
                self.currentLineOfInterest = self.linesOfInterest.length - 1;
            }
            self.setSelectedLine(self.linesOfInterest[self.currentLineOfInterest] - 1);
        }
    };

    /**
     * We are considered to be 'tailing' only if all of the following:
     * 1) the log is incomplete
     * 2) we are on the last page
     * 3) the last line of the last page is visible.
     */
    this.isTailing = function() {
        //return self.tailing;

        // if !finished && on-last-page && scrolled-to-bottom
        if (self.isFinished()) {
            return false;
        }
        var lastLineNumber = self.getTotalLineCount()-1
        if (self.getCurrentPage() !== self.getLastPage()) {
            return false;
        }
        var lastLineElement = self.getLineNumberPane().immediateDescendants().last();
        var y = lastLineElement.positionedOffset().top;
        var content = self.getLogContent();

        // last line is in the bottom 24 visible pixels.
        return y < (content.scrollTop + content.getHeight() + 24);
    }

    /**
     * Scroll the visible display (if needed) such that the desired line number is visible on the screen.
     * @param lineNumber the absolute line number to which to scroll
     */
    this.scrollToLine = function(lineNumber) {
        var lineElement = self._getLineNumberElement(lineNumber);
        var y = lineElement.positionedOffset().top;
        var content = self.getLogContent();
        if (y < content.scrollTop || y > (content.scrollTop + content.getHeight() - 24)) {
            // move focus if line is not in the visible range
            content.scrollTop = Math.max(0, (y - 150));
        }
    };

    //------------------------------------------------------------------------------
    this.handleNextButtonState = function(type, args) {
        var enabling = args[0];
        var img = args[1];

        if(enabling) {
            img.src = self.imgUrl + "/icon_arrow_right.gif";
        } else {
            img.src = self.imgUrl + "/icon_arrow_right_disabled.gif";
        }
    };

    //------------------------------------------------------------------------------
    this.handlePrevButtonState = function(type, args) {
        var enabling = args[0];
        var img = args[1];

        if(enabling) {
            img.src = self.imgUrl + "/icon_arrow_left.gif";
        } else {
            img.src = self.imgUrl + "/icon_arrow_left_disabled.gif";
        }
    };

    /**
     * @return the first valid line number for #getCurrentPage()
     */
    this.getShowingFirstLine = function() {
        return Math.max(0, (self.getCurrentPage()-1) * self.getLinesPerPage());
    };

    /**
     * @return the last valid line number for #getCurrentPage()
     */
    this.getShowingLastLine = function() {
        return self.getShowingFirstLine() + self.getLinesPerPage() - 1;
    };

    /**
     * @return the 1-based current page being displayed
     */
    this.getCurrentPage = function() {
        return self.currentPage;
    };

    /**
     * This call is syncronous with getting the new content from the server (if new page is different from old page).
     *
     * @param page change the display to the given 1-based page
     */
    this.setCurrentPage = function(page) {
        var pageNumber
        if (typeof page === 'number') {
            pageNumber = page;
        }
        else {
            var chunks = ("" + page.id).split("-");
            pageNumber = parseInt(chunks[chunks.length-1]);
        }

        // clip to valid range
        pageNumber = Math.max(pageNumber, 1);
        pageNumber = Math.min(pageNumber, self.getLastPage());

        var pageChange = pageNumber !== self.currentPage;
        var viewTail = (pageNumber === self.getLastPage() && self.isTailing());
        if (pageChange || viewTail) {
            self.currentPage = pageNumber;
            self.displayPage(); // request page-content from server
        } else {
            self.uiUpdatePageHighlighting(); // update highlighting on page
        }

        // update selected-page number message in pager
        self.uiUpdateCurrentPage();

        // center pager on current page
        var leftNavEdge = self.currentPage - self._div(self.getNumberOfPagesInIndex(), 2) + 1;
        leftNavEdge = Math.max(leftNavEdge, 1);
        leftNavEdge = Math.min(leftNavEdge, self.getLastPage() - self.getNumberOfPagesInIndex()  + 1);
        self.navigation.scrollTo(leftNavEdge);
    };

    /**
     * @return the 1-based page number of the last page with content.
     */
    this.getLastPage = function() {
        return self.getPageForLine(self.getTotalLineCount());
    };

    /**
     * @param lineNumber an absolute line number
     * @return the 1-based page which the line should appear on.
     */
    this.getPageForLine = function(lineNumber) {
        return self._div(lineNumber, self.getLinesPerPage()) + 1;
    };

    //------------------------------------------------------------------------------
    this.isFinished = function() {
        return self.finished;
    };

    //------------------------------------------------------------------------------
    this.setIsFinished = function(finished) {
        if (!finished) {
            self.getLogWorkingElement().show();
            self.getDownloadButton().hide();
        }
        else {
            self.getLogWorkingElement().hide();
            self.getDownloadButton().show();

            // we are now finished, we need to stop any timer and update the display
            // and switch to finished mode.
            if (!self.finished) {
                // if we were running before, we are going to want to switch the log file
                // to be that of the zip type.  If we weren't running before assume
                // it is correct as is.
                var index = self.relativeLogFile.indexOf('text$plain$output.log');
                if (index > 0) {
                    self.setRelativeLogFile(self.getRelativeLogFile().substring(0,index) + 'application$zip$commandOutput.zip');
                }
            }
        }
        self.finished = finished;
    };

    /**
     * Starting with #selectedLineNumber, find the first occurrence of query and update the display to that line.
     * @param query
     */
    this.gotoText = function(query) {
        if (!query) {
            // no text to search
            return;
        }

        var match = null;

        var startSearchLine = self.getShowingFirstLine();
        if (self._isLineOnCurrentPage(self.selectedLineNumber)) {
            // line following the selected line on current page
            startSearchLine = self.selectedLineNumber+1;
        }

        // if search is on curren page, do that locally before attempting AJAX call
        if (self._isLineOnCurrentPage(startSearchLine)) {
            match = self.getLineTextPane().select('.line-text').find(function(line){
                var text = line.textContent || line.innerText; /* try standard first then use IE6 fallback*/
                if (text.indexOf(query) !== -1) {
                    return self._getRelativeLineNumber(line) >= self._getRelativeLineNumber(startSearchLine);
                }
                return false;
            });
        }

        // no matches on current page, check next page(s) using server call
        if (!match) {
            new Ajax.Request(self.searchLogUrl, {
                'asynchronous': false, // TODO make work asynchronously with busy-indicator
                'method': 'post',
                'parameters': {
                    'relativeLogFile': self.getRelativeLogFile(),
                    'pathSeparator':   self.getPathSeparator(),
                    'lineOffset':      self.getShowingLastLine() + 1,
                    'searchQ':         query
                },
                'onSuccess': function(resp){
                    var matches = resp.responseJSON;
                    if (matches !== null && matches.length > 0) {
                        // read first match
                        match = matches[0];
                    }
                },
                'onFailure':   function(resp){ alert(i18n('Failure during query', resp.statusText));},
                'onException': function(req, e){throw e;},
                'onComplete':  function(resp){ /* perform 'finally' style cleanup */}
            });
        }

        if (match === null) {
            alert(i18n('No matches found'));
        }
        else if (match === self.selectedLineNumber) {
            alert(i18n('No more matches found'));
        }
        else {
            self.setSelectedLine(match);
        }
    };

    /**
     * Change the page to the show the given absolute lineNumber and scroll to it.
     * @param lineNumber a absolute line number or an element corresponding to a line
     */
    this.setSelectedLine = function(lineNumber) {
        if (typeof lineNumber !== 'number') {
            lineNumber = self._getAbsoluteLineNumber(lineNumber);
        }

        if (self.selectedLineNumber === lineNumber) {
            self.clearSelectedLineNumber();
        }
        else {
            self.clearSelectedLineNumber();
            self.selectedLineNumber = lineNumber;
            var pageNumber = self.getPageForLine(self.selectedLineNumber); // get required page number
            self.setCurrentPage(pageNumber);                 // change to the desired page (if needed) and update highlighting
            self.scrollToLine(self.selectedLineNumber);      // scroll window focus to the selected line
        }
    };


    /**
     * Clears the selected line attribute and highlighting
     */
    this.clearSelectedLineNumber = function() {
        if (self._isLineOnCurrentPage(self.selectedLineNumber)) {
            self._getLineNumberElement(self.selectedLineNumber).removeClassName('line-highlight');
            self._getLineTextElement(self.selectedLineNumber).removeClassName('line-highlight');
        }
        self.selectedLineNumber = -1;
        self.uiUpdatePageHighlighting();
    };

    //
    // Utilities
    //

    /**
     * Test if the given absolute line number is on the currently displayed page.
     * @param lineNumber an absolute line number
     * @return true or false
     */
    this._isLineOnCurrentPage = function(lineNumber){
        return self.getShowingFirstLine() <= lineNumber && lineNumber <= self.getShowingLastLine();
    };


    /**
     * @param arg0 is either a line-number-X or line-X element or an absolute line-number
     * @return a number for the line number within the current page.
     */
    this._getRelativeLineNumber = function(arg0) {
        if (typeof arg0 === 'number') {
            return arg0 - self.getShowingFirstLine();
        }
        else {
            var chunks = ('' + arg0.id).split('-');
            return parseInt(chunks[chunks.length-1]);
        }
    };

    /**
     * @param arg0 is either a line-number-X or line-X element or a relative line-number
     * @return the absolute line number within entire the log file.
     */
    this._getAbsoluteLineNumber = function(arg0) {
        var relativeLineNumber = null;
        if (typeof arg0 === 'number') {
            relativeLineNumber = arg0;
        }
        else {
            var chunks = ("" + arg0.id).split("-");
            relativeLineNumber = parseInt(chunks[chunks.length-1]);
        }
        return self.getShowingFirstLine() + relativeLineNumber;
    };

    /**
     * Integer division method
     * @param op1 a number
     * @param op2 a number
     * @return the quotient of dividing op1 by op2
     */
    this._div = function(op1, op2) {
        return Math.floor(op1/op2);
    };

    this._inRange = function(value, min, max) {
      return min <= value && value <=max;
    };

    /*
     * Switch view to last page (if not on it already)
     * then scroll to the last line of the last page.
     *
     */
    this._showTail = function() {
      self.setCurrentPage(self.getLastPage());
      var lastLineElement = self.getLineTextPane().immediateDescendants().last();
      self.scrollToLine(lastLineElement);
    };
    
    

    this.navigation = null;                        // the page carousel
    this.numberOfPagesInIndex = 10;                // number of pages visible in carousel
    this.currentPage = 0;                          // current page (1-based)
    this.currentLineOfInterest = -1;               // current highlighted line of interest index in LogFile#linesOfInterest
    this.selectedLineNumber = -1;                  // current selected absolute line (0-based)
    this.fetchLogChunkUrl = options.fetchLogChunkUrl;
    this.updateViewUrl = options.updateViewUrl;
    this.searchLogUrl = options.searchLogUrl;
    this.imgUrl = options.imgUrl;
    this.relativeLogFile = options.relativeLogFile;
    this.pathSeparator = options.pathSeparator;
    this.linesPerPage = options.linesPerPage;         // number of lines shown on a page
    
    
    /* Set the page height of the log viewer */
    var contentPaneHeight = (document.viewport.getHeight() - 130);
    this.getLogContent().style.height = '' + Math.max(contentPaneHeight, 200) + 'px';

    this.setTotalLineCount(options.totalLineCount || 0);   // number of lines known to exist

    this.setIsFinished(options.finished);

    // array of the absolute line numbers (1-based) flagged as being a line-of-interest
    this.setLinesOfInterest(options.linesOfInterest || new Array());
    
    // On load, load the page we should display.
    if (this.isFinished()) {
        this.setCurrentPage(1);
    }
    else {
        // Go into tailing mode and start polling for updates
        this._showTail();
        setTimeout(function() { self.updateView(); }, 5000);
    }

    // Add our event handlers for highlighting lines and changing page numbers.
    this.getLineNumberPane().observe('click', function(e){e.stop(); self.setSelectedLine(e.element())});
    this.getLineTextPane().observe('click',   function(e){e.stop(); self.setSelectedLine(e.element())});
    this.getPager().observe('click',          function(e){e.stop(); self.setCurrentPage(e.element());});
    this.getPrevPageLink().observe('click',   function(e){e.stop(); self.gotoPrevPage();});
    this.getFirstPageLink().observe('click',  function(e){e.stop(); self.navigation.scrollTo(1);});
    this.getLastPageLink().observe('click',   function(e){e.stop(); self.navigation.scrollTo(self.getLastPage());});
    this.getNextPageLink().observe('click',   function(e){e.stop(); self.gotoNextPage();});
    this.getNextLineOfInterestButton().observe('click',  function(e){e.stop(); self.gotoNextLineOfInterest();});
    this.getGotoLineForm().observe('submit',  function(e){
        e.stop();
        var lineNumber = parseInt(this.down('input[type="text"]').value);
        if (isNaN(lineNumber)) {
            // display warning of NAN
        }
        else {
            self.setSelectedLine(lineNumber-1); // convert from to absolute line-number
        }
    });

    // add event handler for test-search form
    this.getSearchForm().observe('submit', function(e){e.stop(); self.gotoText(this.down('input[name="searchQ"]').value)});

    if (window.resize) {
        // if we are in a popup in IE6, there may be a race between the dom:loaded event for creating this control
        // and the onload attribute for the popup.  We therefore should
        window.resize();
    }
};

