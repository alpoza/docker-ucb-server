/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var TopMetricChart = function() {
    // New Chart
    var chart;
    var div;
    
    // Colors
    var titleColor = '#1782BA';
    
    // Chart Limits
    var width = 400;
    var height = 225;
    
    // Data
    var data = [];
    
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

        json.each(function(value) {
            data.push(value);
        });
        
        drawChart();
    };
    
    var drawChart = function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: div,
                type: 'pie',
                width: width,
                height: height,
                spacingLeft: 5,
                spacingRight: 5,
                spacingTop: 5,
                spacingBottom: 5
            },
            title: {
                text: i18n('FindingsTopTen'),
                y: 10,
                style: {
                    color: titleColor
                }
            },
            tooltip: {
                enabled: true,
                borderWidth: 0,
                shadow: false,
                headerFormat: '<table>',
                pointFormat: '<tr style="font-size: 10px; font-weight: bold">' + 
                    '<td style="color:{point.color}">{point.name}: </td>' +
                    '<td align="center">{point.y}</td></tr>',
                footerFormat: '</table>',
                useHTML: true,
                positioner: function () {
                    return { x: 0, y: height-20 };
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: false,
                    startAngle: 30,
                    connectorPadding: 0,
                    //size: 120,
                    dataLabels: {
                        enabled: false,
                        color: '#000000',
                        connectorColor: '#000000',
                        connectorPadding: 10,
                        borderRadius: 3,
                        borderWidth: 1,
                        borderColor: '#000000',
                        padding: 3,
                        backgroundColor: 'rgba(252, 255, 197, 1)',
                        distance: 25,
                        y: 0,
                        style: {
                            fontSize: '12px'
                        },
                        useHTML: true,
                        formatter: function () {
                            return this.point.y;
                        }
                    }
                }
            
            },
            series: [{
                data: data
            }],
            credits: {
                enabled: false
            }
        });
    };
};
