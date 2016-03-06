/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var CoverageReportChart = function() {
    // New Chart
    var chart;
    var div;
    
    // Colors
    var blueColor = '#51B6DA';
    var titleColor = '#1782BA';
    var darkColor = '#517693';
    
    // Y-Axis Limits
    var min = 0;
    var max = 100;
    
    // Chart Limits
    var width = 200;
    var height = 125;
    
    // Data Arrays
    var lineArray = [];
    var methodArray = [];
    var branchArray = [];
    
    this.retrieveCommitData = function(url, params, errorMessage, divName) {
        new Ajax.Request(url,
            {
                'method' : 'get',
                'asynchronous' : true,
                'parameters' : params,
                'onSuccess' : function(resp) {
                    parseData(resp.responseJSON, divName);
                },
                'onFailure' : function(resp) {
                    errorAlert(resp, errorMessage);
                },
                'onException' : function(req, e) {
                    throw e;
                }
            });
    };
    
    var parseData = function(json, divName) {
        div = divName;

        var linePercent = (json.line * 100).toFixed(1);
        lineArray.push(parseFloat(linePercent));
        var methodPercent = (json.method * 100).toFixed(1);
        methodArray.push(parseFloat(methodPercent));
        var branchPercent = (json.branch * 100).toFixed(1);
        branchArray.push(parseFloat(branchPercent));
        
        drawChart();
    };
    
    var drawChart = function() {
        chart = new Highcharts.Chart({
            chart: {
                type: 'column',
                renderTo: div,
                width: width,
                height: height,
                spacingLeft: 5,
                spacingRight: 5,
                spacingTop: 5,
                spacingBottom: 5,
                plotBorderWidth: 1
            },
            title: {
                text: null
            },
            xAxis: {
                labels: {
                    enabled: false
                }
            },
            yAxis: {
                min: min,
                max: max,
                tickInterval: 20,
                title: {
                    text: i18n('CoveragePercentage'),
                    align: 'low',
                    style: {
                        color: titleColor
                    }
                }
            },
            tooltip: {
                headerFormat: '<table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0"><b>{series.name}: </b></td>' +
                    '<td style="padding:0"><b>{point.y}%</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            legend: {
                padding: 4,
                itemMarginBottom: 1
            },
            series: [{
                name: i18n('Line'),
                data: lineArray,
                color: blueColor
            }, {
                name: i18n('Method'),
                data: methodArray,
                color: titleColor
            }, {
                name: i18n('Branch'),
                data: branchArray,
                color: darkColor
            }],
            credits: {
                enabled: false
            }
        });
    };
};