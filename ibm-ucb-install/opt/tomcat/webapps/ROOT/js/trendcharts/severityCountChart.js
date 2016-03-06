/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var SeverityCountChart = function() {
    // New Chart
    var chart;
    
    // Colors
    var titleColor = '#1782BA';
    
    // Y-Axis Limits
    var min = 0;
    
    // Chart Limits
    var width = 400;
    var height = 250;
    
    // Data Count
    var count = 0;
    
    // Series data
    var series;
    
    // Categories
    var categories;
    
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
        categories = json.cats;
        series = json.series;
        drawChart();
    };
    
    var drawChart = function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'severityChartContainer',
                type: 'area',
                width: width,
                height: height,
                spacingLeft: 5,
                spacingRight: 5,
                spacingTop: 5,
                spacingBottom: 5,
                plotBorderWidth: 1
            },
            title: {
                text: i18n('SeverityCount'),
                style: {
                    color: titleColor
                }
            },
            xAxis: {
                categories: categories,
                tickmarkPlacement: 'on',
                labels: {
                    step: (count < 10) ? 1 : 2,
                    rotation: -20,
                    align: 'right'
                }
            },
            yAxis: {
                min: min,
                allowDecimals: false,
                title: {
                    text: i18n('AnalyticsNumberOfFindings'),
                    style: {
                        color: titleColor
                    }
                },
                labels: {
                    style: {
                        color: titleColor
                    }
                }
            },
            tooltip: {
                headerFormat: '<table>',
                pointFormat: '<tr><td style="color:{series.color}">{series.name}: </td>' +
                    '<td align="center">{point.y}</td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            legend: {
                enabled: false,
            },
            plotOptions: {
                area: {
                    stacking: 'normal',
                    lineColor: '#000000',
                    lineWidth: 1,
                    marker: {
                        lineWidth: 1,
                        lineColor: '#000000',
                        enabled: false,
                        radius: 1,
                        symbol: 'circle'
                    }
                }
            },
            series: series,
            credits: {
                enabled: false
            }
        });
    };
};
