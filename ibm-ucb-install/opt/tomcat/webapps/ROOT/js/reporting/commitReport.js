/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var CommitReport = function() {
    // New Chart
    var chart;

    // Colors
    var blueColor = '#51B6DA';
    var titleColor = '#1782BA';
    var darkColor = '#517693';

    // Y-Axis Limits
    var min = -0.05;
    var commitMax = 0;
    var changeMax = 0;

    // Chart Limits
    var width = 340;
    var height = 230;

    // Date Format Constants
    var yearStringLength = 5;

    // Maps
    var commitArray = [];
    var changeArray = [];
    var categories = [];

    this.retrieveCommitData = function(url, params, errorMessage) {
        new Ajax.Request(url,
            {
                'method' : 'get',
                'asynchronous' : true,
                'parameters' : params,
                'onSuccess' : function(resp) {
                    parseData(resp.responseJSON);
                },
                'onFailure' : function(resp) {
                    errorAlert(resp, errorMessage);
                },
                'onException' : function(req, e) {
                    throw e;
                }
            });
    };

    var parseData = function(json) {
        json.each(function(value) {
            // Truncate the day string to remove the year
            var key = value.day.substring(yearStringLength);
            categories.push(key);

            if (value.commit > commitMax) {
                commitMax = value.commit;
            }

            if (value.change > changeMax) {
                changeMax = value.change;
            }

            commitArray.push(value.commit);
            changeArray.push(value.change);
        });

        drawChart();
    }

    var drawChart = function() {
        Highcharts.setOptions({
            lang: {
                resetZoom: i18n('ResetZoom'),
                resetZoomTitle: i18n('ResetZoomLevel')
            }
        });
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'commitChartContainer',
                zoomType: 'xy',
                width: width,
                height: height,
                spacingLeft: 0,
                spacingRight: 0,
                spacingTop: 5,
                spacingBottom: 10,
                plotBorderWidth: 1
            },
            title: {
                text: i18n('TotalSourceActivity'),
                style: {
                color: titleColor
                }
            },
            xAxis: [{
                categories: categories,
                labels: {
                    rotation: -60,
                    align: 'right'
                },
                style: {
                    fontSize: '5px'
                }
            }],
            yAxis: [{ // Primary yAxis
                min: min,
                max: commitMax == 0 && changeMax == 0 ? 2 : null,
                startOnTick: false,
                allowDecimals: false,
                labels: {
                    style: {
                        color: blueColor
                    }
                },
                title: {
                    text: i18n('CommitsNumberOf'),
                    style: {
                        color: blueColor
                    }
                }
            }, { // Secondary yAxis
                min: min,
                startOnTick: false,
                allowDecimals: false,
                labels: {
                    style: {
                        color: darkColor
                    }
                },
                title: {
                    text: i18n('ChangesNumberOf'),
                    style: {
                        color: darkColor
                    }
                },
                opposite: true
            }],
            tooltip: {
                formatter: function() {
                    return '' +
                        this.x + ': '+ this.y + ' ' +
                        (this.series.name == i18n('Commits') ? i18n('CommitsLowercase') : i18n('ChangesLowercase'));
                }
            },
            series: [{
                name: i18n('Commits'),
                color: blueColor,
                type: 'line',
                data: commitArray,
                showInLegend: false

            }, {
                name: i18n('Changes'),
                color: darkColor,
                type: 'line',
                yAxis: 1,
                data: changeArray,
                showInLegend: false

            }],
            credits: {
                enabled: false
            }
        });
    }
};
