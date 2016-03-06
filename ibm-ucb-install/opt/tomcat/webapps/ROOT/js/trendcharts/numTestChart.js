/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var NumTestChart = function() {
    // New Chart
    var chart;
    
    // Colors
    var blueColor = '#51B6DA';
    var titleColor = '#1782BA';
    var darkColor = '#517693';
    
    // Y-Axis Limits
    var min = 100;
    var max = 100;
    var testMax = 0;
    var testMin = Number.MAX_VALUE;
    
    // Chart Limits
    var width = 800;
    var height = 250;
    
    // Data Count
    var count = 0;
    
    // Maps
    var successes = {};
    var successPercentages = {};
    var successPercentagesArray = [];
    var days = {};
    var totalTests = {};
    var totalTestsArray = [];
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
            
            successes[key] = value.numSuccess;
            days[key] = value.day;
            
            var successPercent = (value.successPercent * 100).toFixed(2);
            successPercentagesArray.push(parseFloat(successPercent));
            successPercentages[key] = successPercent;
            if (successPercent < min) {
                min = successPercent;
            }
            
            var numTests = value.numTests;
            totalTests[key] = numTests;
            totalTestsArray.push(numTests);
            
            if (testMax < numTests) {
                testMax = numTests;
            }
            if (testMin > numTests) {
                testMin = numTests;
            }
            
            count += 1;
        });
        
        // Offset by 10 for a minimum if any data would be at the adjusted minimum
        if (min % 10 == 0 && min > 0) {
            min -= min == 100 ? 100 : 10;
        }
        
        // reset testMin to be testMin - 1/10th of the difference in max and min
        testMin = testMin - Math.floor((testMax - testMin) / 10);
        testMin = testMin < 0 ? 0 : testMin;
        
        max += 1;
        drawChart();
    };
    
    var drawChart = function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'numTestContainer',
                type: 'line',
                width: width,
                height: height,
                alignTicks: false,
                spacingLeft: 5,
                spacingRight: 5,
                spacingTop: 5,
                spacingBottom: 5,
                plotBorderWidth: 1
            },
            title: {
                text: i18n('TestsNumberOf'),
                style: {
                    color: titleColor
                }
            },
            xAxis: {
                categories: categories, 
                labels: {
                    step: (count < 15) ? 1 : 2,
                    rotation: -20,
                    align: 'right'
                }
            },
            yAxis: [{
                min: min,
                max: max,
                endOnTick: false,
                allowDecimals: false,
                labels: {
                    style: {
                        color: blueColor
                    }
                },
                title: {
                    text: i18n('SuccessPercent'),
                    style: {
                        color: blueColor
                    }
                }
            }, {
                min: testMin,
                max: testMax,
                allowDecimals: false,
                labels: {
                    style: {
                        color: darkColor
                    }
                },
                title: {
                    text: i18n('TestsNumber'),
                    style: {
                        color: darkColor
                    }
                },
                opposite: 1
            }],
            tooltip: {
                shared: true,
                formatter: function() {
                    var key = this.x;
                    var input = successes[key] + "/" + totalTests[key] + " (" + successPercentages[key] + "%)"
                    return i18n("TestTrendsChartHelp", input, key, days[key]);
                }
            },
            series: [{
                name: i18n('Success'),
                color: blueColor,
                data: successPercentagesArray,
                showInLegend: false
            }, {
                name: i18n('Tests'),
                color: darkColor,
                data: totalTestsArray,
                showInLegend: false,
                yAxis: 1
            }],
            credits: {
                enabled: false
            }
        });
    };
};
