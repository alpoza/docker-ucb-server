/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var TestReport = function() {
    // New Chart
    var chart;

    // Colors
    var blueBarColor = '#51B6DA';
    var titleColor = '#1782BA';
    var backgroundColor = '#FFFFFF';

    // Y-Axis Limits
    var maxPercent = 100;
    var minPercent = 100;

    // Chart Limits
    var width = 340;
    var height = 230;

    // Date Format Constants
    var yearStringLength = 5;

    // Maps
    var totalTests = {};
    var successes = {};
    var failures = {};
    var successPercentagesMap = {};
    var successPercentagesArray = [];
    var categories = [];

    this.retrieveTestData = function(url, params, errorMessage) {
        new Ajax.Request(url,
            {
                'method' : 'get',
                'asynchronous' : true,
                'parameters' : params,
                'onSuccess' : function(resp) {
                    parseData(resp.responseJSON.summaries);
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

            // Set up data maps with the date as the key
            totalTests[key] = value.numTests;
            successes[key] = value.numSuccess;
            failures[key] = value.numFail;

            var successPercent = value.successPercent * 100;
            successPercentagesMap[key] = successPercent.toFixed(2);
            successPercentagesArray.push(successPercent);
            // Scale the graph to the data
            if (successPercent < minPercent) {
                minPercent = successPercent;
            }
        });

        // Offset by 10 for a minimum if any data would be at the adjusted minimum
        if (minPercent % 10 == 0 && minPercent > 0) {
            minPercent -= minPercent == 100 ? 100 : 10;
        }

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
            colors: [
                     blueBarColor
            ],
            chart: {
                renderTo: 'testChartContainer',
                type: 'column',
                width: width,
                height: height,
                spacingLeft: 0,
                spacingRight: 5,
                spacingTop: 5,
                spacingBottom: 10,
                plotBorderWidth: 1
            },
            title: {
                style: {
                    color: titleColor
                },
                text: i18n('TestDailySuccessRate'),
                x: 22
            },
            xAxis: {
                categories: categories,
                labels: {
                    rotation: -60,
                    align: 'right'
                }
            },
            yAxis: {
                min: minPercent,
                max: maxPercent,
                title: {
                    style: {
                        color: blueBarColor
                    },
                    text: i18n('TestPassRate')
                }
            },
            legend: {
                // No need for a legend for this chart
            },
            tooltip: {
                formatter: function () {
                    var key = this.x;
                    return i18n("TestsRun") + " " + totalTests[key]
                        + "<br/>" + i18n("Successes") + " " + successes[key]
                        + "<br/>" + i18n("Failures") + " " + failures[key]
                        + "<br/>" + i18n("PassRate") + " " + successPercentagesMap[key] + "%";
                }
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                showInLegend: false,
                data: successPercentagesArray
            }],
            credits: {
                enabled: false
            }
        });
    }
};
