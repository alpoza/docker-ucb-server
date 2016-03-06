/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var CoverageChart = function() {
    // New Chart
    var chart;
    
    // Colors
    var blueColor = '#51B6DA';
    var titleColor = '#1782BA';
    var darkColor = '#517693';
    
    // Y-Axis Limits
    var min = -1;
    var max = 103;
    
    // Chart Limits
    var width = 925;
    var height = 250;
    
    // Data Count
    var count = 0;
    
    // Maps
    var linePercentagesArray = [];
    var linePercentages = {};
    var methodPercentagesArray = [];
    var methodPercentages = {};
    var branchPercentagesArray = [];
    var branchPercentages = {};
    var days = {};
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
            var key = value.life;
            categories.push(key);
            
            days[key] = value.day;
            
            var linePercent = (value.line * 100).toFixed(1);
            linePercentagesArray.push(parseFloat(linePercent));
            linePercentages[key] = linePercent;
            
            var methodPercent = (value.method * 100).toFixed(1);
            methodPercentagesArray.push(parseFloat(methodPercent));
            methodPercentages[key] = methodPercent;
            
            var branchPercent = (value.branch * 100).toFixed(1);
            branchPercentagesArray.push(parseFloat(branchPercent));
            branchPercentages[key] = branchPercent;
            
            count += 1;
        });
        
        drawChart();
    };
    
    var drawChart = function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'coverageChartContainer',
                type: 'line',
                width: width,
                height: height,
                spacingLeft: 5,
                spacingRight: 5,
                spacingTop: 5,
                spacingBottom: 5,
                plotBorderWidth: 1
            },
            title: {
                text: i18n('CoverageRate'),
                style: {
                    color: titleColor
                }
            },
            xAxis: {
                categories: categories, 
                labels: {
                    step: (count < 10 ) ? 1 : 2,
                    rotation: -20,
                    align: 'right'
                }
            },
            yAxis: [{
                min: min,
                max: max,
                startOnTick: false,
                endOnTick: false,
                tickInterval: 25,
                allowDecimals: false,
                labels: {
                    style: {
                        color: titleColor
                    }
                },
                title: {
                    text: i18n('CoveragePercentage'),
                    style: {
                        color: titleColor
                    }
                }
            }],
            tooltip: {
                shared: true,
                formatter: function() {
                    var key = this.x;
                    return i18n("CoverageLine", linePercentages[key], key, days[key]) + "<br/>" +
                           i18n("CoverageMethod", methodPercentages[key], key, days[key]) + "<br/>" +
                           i18n("CoverageBranch", branchPercentages[key], key, days[key]);
                }
            },
            series: [{
                name: i18n('Line'),
                color: blueColor,
                data: linePercentagesArray
            }, {
                name: i18n('Method'),
                color: titleColor,
                data: methodPercentagesArray
            }, {
                name: i18n('Branch'),
                color: darkColor,
                data: branchPercentagesArray
            }],
            credits: {
                enabled: false
            }
        });
    };
};
