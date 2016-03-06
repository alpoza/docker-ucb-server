/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/**
 * Construct a new ReportGraph object for rendering a Highcharts chart from report results.
 * @param elementId The id of the element to inject the chart into.
 * @param title The display title of the chart.
 * @param chartType The type of chart: line, spline, area, areaspline, column, bar, pie and scatter.
 * @param xAxisColumn The report results column name for the series values. Periods are replaced with underscores.
 * @param yAxisColumn The report results column name for the data values. Periods are replaced with underscores.
 */
function ReportGraph(elementId, title, chartType, xAxisName, xAxisColumn, xAxisCategoryColumn, yAxisName, yAxisColumn) {
    this.elementId = elementId;
    this.title = title;
    this.chartType = chartType;
    this.yAxisName = yAxisColumn;
    this.xAxisName = xAxisName;
    this.xAxisColumn = xAxisColumn;
    this.xAxisCategoryColumn = xAxisCategoryColumn;
    this.yAxisName = yAxisName;
    this.yAxisColumn = yAxisColumn;

    // Colors
    this.blueColor = '#51B6DA';
    this.titleColor = '#1782BA';

    // Y-Axis Limits
    this.min = 0;

    // Maps
    this.series = [];
    this.categories = [];
    this.dataCategories = {};

    this.renderGraph = function(reportData) {
        var self = this;
        var xAxisColumnName = self.xAxisColumn.replace(/\./g, "_");
        var yAxisColumnName = self.yAxisColumn.replace(/\./g, "_");
        var xAxisColumnIndex = 0;
        var xAxisCategoryColumnIndex = -1;
        var yAxisColumnIndex = 0;
        jQuery.each(reportData.columns, function(columnIndex, column) {
            if (column == xAxisColumnName) {
                xAxisColumnIndex = columnIndex;
            }
            if (column == yAxisColumnName) {
                yAxisColumnIndex = columnIndex;
            }
            if (xAxisCategoryColumn && column == xAxisCategoryColumn) {
                xAxisCategoryColumnIndex = columnIndex;
            }
        });

        if (chartType !== 'pie') {
            reportData.results.each(function (reportRow) {
                var category = reportRow[xAxisColumnIndex];
                if (xAxisCategoryColumnIndex >= 0) {
                    if (jQuery.inArray(category, self.categories) < 0) {
                        self.categories.push(category);
                    }
                }
                else {
                    self.categories.push(category);
                }
                if (xAxisCategoryColumnIndex >= 0) {
                    var xAxisCategoryName = reportRow[xAxisCategoryColumnIndex];
                    var xAxisCategory = self.dataCategories[xAxisCategoryName];
                    if (!xAxisCategory) {
                        xAxisCategory = {name: xAxisCategoryName, data: []};
                        self.dataCategories[xAxisCategoryName] = xAxisCategory;
                        self.series.push(xAxisCategory);
                    }
                }
                else {
                    var xAxisCategory = self.series[0];
                    if (!xAxisCategory) {
                        xAxisCategory = {name: self.yAxisName, color: self.blueColor, data: []};
                        self.series.push(xAxisCategory);
                    }
                }
            });
            self.series.each(function (xAxisCategory) {
                self.categories.each(function (category) {
                    xAxisCategory.data.push(Number(0));
                });
            });
            reportData.results.each(function (reportRow) {
                var category = reportRow[xAxisColumnIndex];
                var categoryIndex = self.categories.indexOf(category);
                // the data is out of order if some categories do not have data points
                if (xAxisCategoryColumnIndex >= 0) {
                    var xAxisCategoryName = reportRow[xAxisCategoryColumnIndex];
                    var xAxisCategory = self.dataCategories[xAxisCategoryName];
                    xAxisCategory.data[categoryIndex] = Number(reportRow[yAxisColumnIndex]);
                }
                else {
                    var xAxisCategory = self.series[0];
                    xAxisCategory.data[categoryIndex] = Number(reportRow[yAxisColumnIndex]);
                }
            });
        }
        // Pie charts use a slightly different format for the data
        else {
            // Pie chart series is an array containing a single object that contains a data array (and optionally a name)
            var seriesObject = {
                data: []
            };
            self.series.push(seriesObject);
            reportData.results.each(function(reportRow) {
                var dataPoint = {
                    name: reportRow[1],
                    y: Number(reportRow[0])
                };
                seriesObject.data.push(dataPoint)
            });
        }
        self.drawGraph();
    };

    this.drawGraph = function() {
        var self = this;
        self.graph = new Highcharts.Chart({
            chart: {
                type: self.chartType, // line, spline, area, areaspline, column, bar, pie and scatter
                renderTo: self.elementId,
                zoomType: 'xy',
                height: jQuery('#' + elementId).height() - 10,
                width: jQuery('#' + elementId).width() - 10
            },
            title: {
                text: self.title,
                style: {
                    color: self.titleColor
                }
            },
            xAxis: [{
                categories: self.categories,
                labels: {
                    rotation: -60,
                    align: 'right'
                },
                title: {
                    text: self.xAxisName
                }
            }],
            yAxis: [{
                min: self.min,
                labels: {
                    style: {
                        color: self.blueColor
                    }
                },
                title: {
                    text: self.yAxisName,
                    style: {
                        color: self.blueColor
                    }
                }
            }],
            tooltip: {
                formatter: function() {
                    // Use the y-axis name as part of the tooltip in pie charts, otherwise just use the x-axis value
                    return (chartType !== 'pie' ? this.x : self.yAxisName) + ': ' + this.y;
                }
            },
            series: self.series,
            credits: {
                enabled: false
            }
        });
    };

    this.redraw = function() {
        var self = this;
        self.graph.redraw();
    };
}
