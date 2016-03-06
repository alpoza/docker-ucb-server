/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var FindingCountChart = function() {
    // New Chart
    var chart;
    
    // Colors
    var blueColor = '#51B6DA';
    var titleColor = '#1782BA';
    
    // Y-Axis Limits
    var maxFindings = -1;
    var minFindings = -1;
    
    // Chart Limits
    var width = 400;
    var height = 250;
    
    // Data Count
    var count = 0;
    
    // Maps
    var findings = {};
    var findingsArray = [];
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
            
            var findingCount = value.findings;
            findingsArray.push(findingCount);
            findings[key] = findingCount;
            
            if (findingCount > maxFindings) {
                maxFindings = findingCount;
            }
            if (findingCount < minFindings || minFindings < 0) {
                minFindings = findingCount;
            }
            
            count += 1;
        });
        
        // Offset by 10 for a minimum if any data would be at the adjusted minimum
        if (maxFindings != 0) {
            var findingDiff = maxFindings - minFindings;
            if (findingDiff > 0) {
                var adjustment = Math.ceil(findingDiff / 10);
                maxFindings += adjustment;
                minFindings -= adjustment;
            }
        }

        drawChart();
    };
    
    var drawChart = function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'findingChartContainer',
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
                text: i18n('FindingsCount'),
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
                max: maxFindings,
                min: minFindings,
                startOnTick: false,
                allowDecimals: false,
                labels: {
                    style: {
                        color: titleColor
                    }
                },
                title: {
                    text: i18n('AnalyticsNumberOfFindings'),
                    style: {
                        color: titleColor
                    }
                }
            }],
            tooltip: {
                shared: true,
                formatter: function() {
                    var key = this.x;
                    return i18n("FindingsNumberOfFor", findings[key], key, days[key]);
                }
            },
            series: [{
                name: i18n('Findings'),
                color: blueColor,
                data: findingsArray,
                showInLegend: false
            }],
            credits: {
                enabled: false
            }
        });
    };
};
