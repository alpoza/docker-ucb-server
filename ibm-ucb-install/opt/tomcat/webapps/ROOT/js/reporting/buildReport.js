/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var BuildReport = function() {
    // New Chart
    var chart;

    // Colors
    var blueColor = '#51B6DA';
    var titleColor = '#1782BA';
    var darkColor = '#517693';

    // Y-Axis Limits
    var min = 0;
    var durMax = 0;
    var buildMax = 0;

    // Chart Limits
    var width = 340;
    var height = 230;

    // Date Format Constants
    var yearStringLength = 5;

    // Maps
    var buildCountArray = [];
    var buildTimeArray = [];
    var categories = [];

    this.retrieveBuildData = function(url, params, errorMessage) {
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

            buildCountArray.push(value.count);
            // Values that are time are in milliseconds when displaying
            buildTimeArray.push(value.duration * 1000);

            if (value.duration * 1000 > durMax) {
                durMax = value.duration * 1000;
            }

            if (value.count > buildMax) {
                buildMax = value.count;
            }
        });

        drawChart();
    };

    var drawChart = function() {
        Highcharts.setOptions({
            lang: {
                resetZoom: i18n('ResetZoom'),
                resetZoomTitle: i18n('ResetZoomLevel')
            }
        });
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'buildChartContainer',
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
                text: i18n('BuildActivity'),
                style: {
                    color: titleColor
                }
            },
            xAxis: [{
                categories: categories,
                labels: {
                    rotation: -60,
                    align: 'right'
                }
            }],
            yAxis: [{ // Primary yAxis
                min: min,
                max: buildMax == 0 && durMax == 0 ? 2 : null,
                startOnTick: false,
                allowDecimals: false,
                labels: {
                    style: {
                        color: blueColor
                    }
                },
                title: {
                    text: i18n('BuildsNumberOf'),
                    style: {
                        color: blueColor
                    }
                }
            }, { // Secondary yAxis
                min: min,
                max: buildMax == 0 && durMax == 0 ? 60000 : null,
                startOnTick: false,
                type: 'datetime',
                dateTimeLabelFormats: {
                    second: '%M:%S',
                    minute: '%M:%S',
                    hour: '%H:%M:%S'
                },
                labels: {
                    style: {
                        color: darkColor
                    }
                },
                title: {
                    text: i18n('Duration'),
                    style: {
                        color: darkColor
                    }
                },
                opposite: true
            }],
            tooltip: {
                formatter: function () {
                    var result = '';
                    if (this.series.name == i18n('Builds')) {
                        result = result + i18n('BuildReportChartToolTip', this.x, this.y);
                    }
                    else {
                        var y = this.y / 1000;
                        var minute = Math.floor(y / 60);
                        if ( minute < 10 ) {
                            minute = '0' + minute;
                        }
                        var second = y % 60;
                        if ( second < 10 ) {
                            second = '0' + second;
                        }
                        result = result + this.x + ': ' +  minute + ':' + second;
                    }
                    return result;
                }
            },
            series: [{
                name: i18n('Builds'),
                color: blueColor,
                type: 'line',
                data: buildCountArray,
                showInLegend: false

            }, {
                name: i18n('Duration'),
                color: darkColor,
                type: 'line',
                yAxis: 1,
                data: buildTimeArray,
                showInLegend: false

            }],
            credits: {
                enabled: false
            }
        });
    }
};
