<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@tag body-content="empty" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@attribute name="id"              required="true"%>
<%@attribute name="currentPage"     required="true" description="The current page number. First page is 0."%>
<%@attribute name="numberOfPages"   required="true" description="The number of pages."%>
<%@attribute name="methodName"      required="true"%>
<%@attribute name="numberShown"     required="false"%>

<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>

<c:if test="${numberOfPages > 0}">
    
    <c:if test="${empty numberShown}">
        <c:set var="numberShown" value="5"/>
    </c:if>
    <c:if test="${currentPage > numberOfPages - 1}">
        <c:set var="currentPage" value="${numberOfPages - 1}"/>
    </c:if>

<script type="text/javascript">
/* <![CDATA[ */
    var handleNextButtonState${id} = function( type, args ) {
        var enabling = args[0];
        var img = args[1];
        
        if(enabling) {
            img.src = "<c:url value="/images/icon_arrow_right.gif"/>";
        } else {
            img.src = "<c:url value="/images/icon_arrow_right_disabled.gif"/>";
        }
    }
    
    var handlePrevButtonState${id} = function( type, args ) {
        var enabling = args[0];
        var img = args[1];
    
        if(enabling) {
            img.src = "<c:url value="/images/icon_arrow_left.gif"/>";
        } else {
            img.src = "<c:url value="/images/icon_arrow_left_disabled.gif"/>";
        }    
    }
    
    var ${id}nav; // for ease of debugging; globals generally not a good idea
    var ${id}LoadPage = function() 
    {        
        var list = YAHOO.util.Dom.get( "${id}nav-list" );
        var pageItems = new Array( ${numberOfPages} );

        for (var i = 1; i <= ${numberOfPages}; ++i ) {
            pageItems[i-1] = '<li id="${id}nav-item-'.concat(i).concat( '"><a href="javascript:${methodName}(').concat( (i-1) ).concat( ');">' ).concat(i).concat( '<\/a><\/li>' );
        }
        list.innerHTML = pageItems.join('');

        /* Calculate the first visible range. */
        var firstVisibleMin = 1;
        var firstVisibleMax = ${numberOfPages} - ${numberShown} + 1;
        var firstVisibleIndex = ${currentPage} + 1;
        if (firstVisibleIndex < firstVisibleMin) {
            firstVisibleIndex = 1;
        } else if (firstVisibleIndex > firstVisibleMax) {
            firstVisibleIndex = firstVisibleMax;
        }

        ${id}nav = new YAHOO.extension.Carousel("${id}nav", 
            {
                numVisible:             ${numberShown},
                firstVisible:           firstVisibleIndex,
                animationSpeed:         0.25,
                scrollInc:              ${numberShown},
                navMargin:              0,
                prevElement:            "${id}-prev-arrow",
                nextElement:            "${id}-next-arrow",
                size:                   ${numberOfPages},
                prevButtonStateHandler: handlePrevButtonState${id},
                nextButtonStateHandler: handleNextButtonState${id}
            }
        );
    };
    YAHOO.util.Event.addListener(window, 'load', ${id}LoadPage);  

    /* ]]> */ 
</script>

<div style="line-height: 15px; float: right">
    <div align="center">
        <span style="cursor: pointer;cursor: hand;" onclick="javascript:${id}nav.scrollTo(1);">${ub:i18n("First")}</span>
        &nbsp;(${currentPage+1}/${numberOfPages})&nbsp;
        <span style="cursor: pointer;cursor: hand;" onclick="javascript:${id}nav.scrollTo(${numberOfPages});">${ub:i18n("Last")}</span>
    </div>
    <div class="carousel-prev">
        <img src="<c:url value="/images/icon_arrow_left.gif"/>" id="${id}-prev-arrow" alt="${ub:i18n('Previous')}"/>
    </div>    
    <div id="${id}nav" class="carousel-component">
        <div class="carousel-clip-region">
            <ul id="${id}nav-list" class="carousel-list"><li><!-- Placeholder --></li></ul>
        </div>
    </div>
    <div class="carousel-next">
        <img src="<c:url value="/images/icon_arrow_right.gif"/>" id="${id}-next-arrow" alt="${ub:i18n('Next')}"/>
    </div>
</div>
</c:if>