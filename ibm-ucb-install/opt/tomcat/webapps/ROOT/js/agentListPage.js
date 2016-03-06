/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
var AgentListPage = function(config) {
    var that = this;

    var newCheckboxFormatter = function(elLiner, oRecord, oColumn, oData) {
        var id = parseInt(oRecord.getData('id'));
        if (this.selectedRows.indexOf(id) != -1) {
            oData = true;
        }
        YAHOO.widget.DataTable.formatCheckbox(elLiner, oRecord, oColumn, oData);
    }

    var defaultResponseSchema = {
            resultsList:'response.results',
            fields:[
                {key:"id",parser:YAHOO.util.DataSource.parseNumber},
                {key:"name"},
                {key:"desc"},
                {key:"version"},
                {key:"status"},
                {key:"lastOnline"},
                {key:"lastOnlineString"},
                {key:"ignored",parser:YAHOO.util.DataSource.parseBoolean},
                {key:"configured",parser:YAHOO.util.DataSource.parseBoolean}
            ],
            metaFields: {
             totalRecords: "totalRecords",
             startIndex: "startIndex"
            }
    };

    var myColumnDefs =[];
    if (config.hasWritePermission) {
        myColumnDefs.push({key:"select",label:"<div style='text-align:left'><input id='selectAll' class='yui-dt-checkbox' type='checkbox'></div>",formatter:newCheckboxFormatter,sortable:false,resizeable:false});
    }
    myColumnDefs.push({key:"name",label:"<div style='margin: 0 20px 0 20px'>" + i18n("Name") + "</div>",formatter:that.nameFormatter,sortable:true,resizeable:false},
        {key:"desc",label:i18n("Description"),formatter:that.descriptionFormatter,sortable:false,resizeable:false},
        {key:"version",label:"<div style='margin: 0 20px 0 20px'>" + i18n("Version") + "</div>",formatter:that.centerNoWrapFormatter,sortable:true,resizeable:false},
        {key:"status",label:"<div style='margin: 0 20px 0 20px'>" + i18n("Status") + "</div>",formatter:that.statusFormatter,sortable:true,resizeable:false},
        {key:"lastOnline",label:"<div style='margin: 0 20px 0 20px'>" + i18n("LastSeen") + "</div>",formatter:that.lastSeenFormatter,sortable:true,resizeable:false},
        {key:"operations",label:i18n("Operations"),formatter:that.operationsFormatter,sortable:false,resizeable:false});

    var createAgentsTable = function(dataSource, columnDefs, agentTableConf) {
       var agentTableConfigs = {
           selCountDiv:agentTableConf.selCountDiv,
           filter:agentTableConf.filter,
           initialLoad:false,
           dynamicData:true,
           sortedBy:agentTableConf.sortedBy,
           paginator : new YAHOO.widget.Paginator({
               rowsPerPage:agentTableConf.rowsPerPage,
               template:YAHOO.widget.Paginator.TEMPLATE_ROWS_PER_PAGE,
               containers:agentTableConf.paginationContainers,
               pageLinks:12,
               rowsPerPageOptions:[25, 50, 100, 200],
               recordOffset:agentTableConf.recordOffset
           }),
           MSG_EMPTY: i18n("No records found."),
           MSG_LOADING: i18n('LoadingEllipsis')
        };

       var notifyAgentPageChanged = function(oState) {
          sendXmlMessage(agentTableConf.rowsPerPageChangeUrl + "?rowsPerPage=" + oState.rowsPerPage, "");
       }
       agentTableConfigs.paginator.subscribe("changeRequest", notifyAgentPageChanged);

       var dataTable = new AnthillDataTable(agentTableConf.tableContainer, columnDefs, dataSource, agentTableConfigs).dataTable;

       if (agentTableConf.filter) {
           var statusInput = YAHOO.util.Dom.get(agentTableConf.filter.statusSelectId);
           var filterFunction = dataTable.generateFilter;
           var newFilterFunction = generateFilter = function(oState, oSelf, clear) {
               var status = statusInput.value;
               return filterFunction(oState, oSelf, clear) + "&status=" + status;
           }

           dataTable.set('generateRequest', generateFilter);

           new YAHOO.util.Element(statusInput).addListener('change', function() {dataTable.updateTable();});
       }

       dataTable.doBeforeLoadData = that.beforeLoadDataHandler;

       dataTable.imgUrl = config.imgUrl;
       dataTable.viewAgentUrl = config.viewAgentUrl;
       dataTable.testAgentUrl = config.testAgentUrl;

       var onClickCallback = function(event, elCheck) {
           dataTable.toggleSelectAll(elCheck.checked);
       }

       YAHOO.util.Event.addListener("selectAll", "click", onClickCallback, YAHOO.util.Dom.get('selectAll'));

       return {
         table: dataTable
       };
    }

    this.initializeConfiguredAgentsTable = function(oState) {
        var rowsPerPage = null;
        var sortedBy = null;
        var recordOffset = 0;

        if (oState) {
            rowsPerPage = oState.pagination.rowsPerPage;
            sortedBy = oState.sortedBy;
            recordOffset = oState.pagination.recordOffset;
        }
        else {
            rowsPerPage = config.configuredAgentRowsPerPage;
        }

        dataSource = new YAHOO.util.DataSource(config.configuredAgentListUrl);
        dataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;

        dataSource.responseSchema = defaultResponseSchema;

        var agentTableConfig = {
                paginationContainers:"configured-agents-paging",
                tableContainer:"configured-agents",
                rowsPerPage:rowsPerPage,
                rowsPerPageChangeUrl:config.setConfiguredAgentRowsPerPageUrl,
                sortedBy: sortedBy,
                recordOffset: recordOffset,
                selCountDiv:"confSelected",
                filter:{
                    fieldId:"conf_filter_input",
                    autoCompleteId:"configured_ac_container",
                    statusSelectId: "conf_status_input"
                }
        };

        var result = createAgentsTable(dataSource, myColumnDefs, agentTableConfig);

        that.configuredDataSource = dataSource;
        that.configuredDataTable = result.table;
        result.dataSource = dataSource;

        that.configuredDataTable.storeTableState = function() {
          that.configuredDataTableState = getTableState(that.configuredDataTable);
          that.configuredDataTable.getDataSource().clearAllIntervals();
          that.configuredDataTable.destroy();
          that.configuredDataTable = null;
        };

        return result;
    }

    this.initializeAvailableAgentsTable = function(oState) {
        var rowsPerPage = null;
        var sortedBy = null;
        var recordOffset = 0;

        if (oState) {
          rowsPerPage = oState.pagination.rowsPerPage;
          sortedBy = oState.sortedBy;
          recordOffset = oState.pagination.recordOffset;
        }
        else {
          rowsPerPage = config.inactiveAgentRowsPerPage;
        }

        dataSource = new YAHOO.util.DataSource(config.inactiveAgentListUrl);
        dataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;

        dataSource.responseSchema = defaultResponseSchema;

        var agentTableConfig = {
            paginationContainers:"available-agents-paging",
            tableContainer:"inactive-agents",
            rowsPerPage:rowsPerPage,
            rowsPerPageChangeUrl:config.setInactiveAgentRowsPerPageUrl,
            sortedBy: sortedBy,
            recordOffset: recordOffset,
            selCountDiv:"availSelected",
            filter:{
                fieldId:"avail_filter_input",
                autoCompleteId:"available_ac_container",
                statusSelectId: "avail_status_input"
            }
        };

        var result = createAgentsTable(dataSource, myColumnDefs, agentTableConfig);

        that.availableDataSource = dataSource;
        that.availableDataTable = result.table;
        result.dataSource = dataSource;

        that.availableDataTable.storeTableState = function() {
            that.availableDataTableState = getTableState(that.availableDataTable);
            that.availableDataTable.getDataSource().clearAllIntervals();
            that.availableDataTable.destroy();
            that.availableDataTable = null;
        };

        return result;
    }

    this.initializeIgnoredAgentsTable = function(oState) {
        var rowsPerPage = null;
        var sortedBy = null;
        var recordOffset = 0;

        if (oState) {
          rowsPerPage = oState.pagination.rowsPerPage;
          sortedBy = oState.sortedBy;
          recordOffset = oState.pagination.recordOffset;
        }
        else {
          rowsPerPage = config.ignoredAgentRowsPerPage;
        }

        dataSource = new YAHOO.util.DataSource(config.ignoredAgentListUrl);
        dataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;

        dataSource.responseSchema = defaultResponseSchema;

        var agentTableConfig = {
            paginationContainers:"ignored-agents-paging",
            tableContainer:"ignored-agents",
            rowsPerPage:rowsPerPage,
            rowsPerPageChangeUrl:config.setIgnoredAgentRowsPerPageUrl,
            sortedBy: sortedBy,
            recordOffset: recordOffset,
            selCountDiv:"ignSelected",
            filter:{
                fieldId:"ign_filter_input",
                autoCompleteId:"ignored_ac_container",
                statusSelectId: "ign_status_input"
            }
        };

        var result = createAgentsTable(dataSource, myColumnDefs, agentTableConfig);

        var dataTable = result.table;

        that.inactiveDataSource = dataSource;
        that.inactiveDataTable = result.table;
        result.dataSource = dataSource;

        that.inactiveDataTable.storeTableState = function() {
            that.inactiveDataTableState = getTableState(that.inactiveDataTable);
            that.inactiveDataTable.getDataSource().clearAllIntervals();
            that.inactiveDataTable.destroy();
            that.inactiveDataTable = null;
        };

        return result;
    }

    var getTableState = function(dataTable) {
        var state = dataTable.getState();
        state.selectedRows = dataTable.selectedRows;

        return state;
    }

    var tabChangeEvent = function(event) {
        YAHOO.log("tabChangeEvent");
        var currentClass = "current";
          var tabs = this.get('tabs');
          for (var i = 0; i < tabs.length; i++) {
              var tab = tabs[i];
              if (tab.hasClass(currentClass)) {
                  tab.removeClass(currentClass);
              }
          }
        event.newValue.addClass(currentClass);
        YAHOO.log("id:" + event.newValue.get('contentEl').id);
        var tabContentId = event.newValue.get('contentEl').id;
        YAHOO.log("tabContentId:" + tabContentId);

        var configuredDataTable = that.configuredDataTable;
        var availableDataTable = that.availableDataTable;
        var inactiveDataTable = that.inactiveDataTable;

        restoreOrShowTable = function(initializerFunction, state) {
            var result = initializerFunction(state);
            var dataTable = result.table;
            var dataSource = result.dataSource;
            var callback = {
                    success : dataTable.onDataReturnSetRows,
                    failure : dataTable.onDataReturnSetRows,
                    scope   : dataTable,
                    argument: dataTable.getState()
            };

            var generateQuery = dataTable.get('generateRequest');

            if (state) {
              dataSource.sendRequest(generateQuery(state, dataTable), callback);
              dataTable.renderSelections(state.selectedRows);
            }
            else {
              dataSource.sendRequest(generateQuery(dataTable.getState(), dataTable), callback);
            }
        }

        if (tabContentId === "configuredTab") {
            YAHOO.log("changing to configured tab");
            if (availableDataTable) {
                availableDataTable.storeTableState();
            }

            if (inactiveDataTable) {
                inactiveDataTable.storeTableState();
            }

            restoreOrShowTable(that.initializeConfiguredAgentsTable, that.configuredDataTableState);
        }
        else if (tabContentId === "availableTab") {
            YAHOO.log("changing to available tab");
            if (configuredDataTable) {
                configuredDataTable.storeTableState();
            }

            if (inactiveDataTable) {
                inactiveDataTable.storeTableState();
            }

            restoreOrShowTable(that.initializeAvailableAgentsTable, that.availableDataTableState);
        }
        else if (tabContentId === "ignoredTab") {
            YAHOO.log("changing to ignored tab");
            if (configuredDataTable) {
                configuredDataTable.storeTableState();
            }

            if (availableDataTable) {
                availableDataTable.storeTableState();
            }
            YAHOO.log("before restore or show table");
            restoreOrShowTable(that.initializeIgnoredAgentsTable, that.inactiveDataTableState);
        }
    }

    this.initializeTabs = function() {
          this.agentTabView = new YAHOO.widget.TabView("agentTabs");
          this.agentTabView.subscribe("activeTabChange", tabChangeEvent);
    }

    this.performAction = function(url, successFn) {
        var table = undefined;
        if (that.configuredDataTable) {
            table = that.configuredDataTable;
        }
        else if (that.availableDataTable) {
            table = that.availableDataTable;
        }
        else if (that.inactiveDataTable) {
            table = that.inactiveDataTable;
        }
        table.performAction(url, successFn);
    }

    this.ignoreAgents = function() {
        if (basicConfirm(i18n("AgentsIgnoreConfirmation"))) {
            var successFn = function(messages) {
                that.updateMessageDiv(messages, i18n('SuccessfullyIgnored'));
            };
            that.performAction(config.ignoreAgentsUrl, successFn);
        }
    }

    this.restartAgents = function() {
        if (basicConfirm(i18n("AgentsRestartConfirmation"))) {
            var successFn = function(messages) {
                that.updateMessageDiv(messages, i18n('AgentsRestarting'));
            };
            that.performAction(config.restartAgentsUrl, successFn);
        }
    }

    this.deleteConfiguredAgents = function() {
        if (basicConfirm(i18n("AgentsDeleteConfirmation"))) {
            var successFn = function(messages) {
                that.updateMessageDiv(messages, i18n('SuccessfullyDeleted'));
            };
            that.performAction(config.deleteAgentsUrl, successFn);
        }
    }

    this.upgradeAgents = function() {
        if (basicConfirm(i18n("AgentsUpgradeConfirmation"))) {
            var successFn = function(messages) {
                that.updateMessageDiv(messages, i18n('AgentsUpgrading'));
            };
            that.performAction(config.upgradeAgentsUrl, successFn);
        }
    }

    this.deleteIgnoredAgents = function() {
        if (basicConfirm(i18n("AgentsDeleteConfirmation"))) {
            var successFn = function(messages) {
                that.updateMessageDiv(messages, i18n('SuccessfullyDeleted'));
            };
            that.performAction(config.deleteAgentsUrl, successFn);
        }
    }

    this.activateAgents = function() {
        if (basicConfirm(i18n("AgentsActivateConfirmation"))) {
            var successFn = function(messages) {
                that.updateMessageDiv(messages, i18n('SuccessfullyActivated'));
            };
            that.performAction(config.activateIgnoredAgentsUrl, successFn);
        }
    }

    this.configureAgents = function() {
      if (basicConfirm(i18n("AgentsConfigureConfirmation"))) {
          var successFn = function(messages) {
              that.updateMessageDiv(messages, i18n('SuccessfullyConfigured'));
          };
          that.performAction(config.configureAgentsUrl, successFn);
      }
    }

    /**
     * This method gets called after Environments have been Added/Removed and
     * updates the Main Page's message div to reflect the changes that were made
     * and any errors that occurred.
     */
    this.updateMessageDiv = function(result, message) {
        var messageDiv = 'messageDiv';
        var createDiv = function(color, heading, messages, messagesPerLine) {
            var result = new Element("div", { style: "color: "+ color });

            result.insert(new Element("span")
                .addClassName("bold")
                .insert(heading)
            );
            result.insert(new Element("br"));
            for (var i = 0; i < messages.length; i++) {
              var name = messages[i];
              if ((i + 1) % messagesPerLine > 0 && i !== messages.length - 1) {
                name += ',';
              }
              result.insert(name);

              if ((i + 1) % messagesPerLine === 0) {
                result.insert(new Element("br"));
              }
              else {
                var span = new Element("span");
                span.innerHTML = "&nbsp;";
                result.insert(span);
              }
            }

            return result;
        }

        $(messageDiv).innerHTML = "";
        $(messageDiv).show();

        var closeDiv = new Element("div", { style: "float: right;" })
            .insert(new Element("a", { title: i18n("CloseMessage"), style: "cursor: pointer;" })
              .insert(new Element('img', { src: that.imgUrl + '/icon_delete.gif', border: '0' }))
              .observe('click', function(event) { $(messageDiv).hide(); })
          );
        $(messageDiv).insert(closeDiv);

        if (result.successfulNames) {
            var successDiv = createDiv("green", message + ":", result.successfulNames, 5);

            $(messageDiv).insert(successDiv);
        }

        if (result.invalidStateNames) {
            if (result.successfulNames) {
                $(messageDiv).insert(new Element("br"));
            }
            var invalidDiv = createDiv("red", i18n("RowsInvalidState"), result.invalidStateNames, 5);

            $(messageDiv).insert(invalidDiv);
        }

        if (result.errors) {
            if (result.successfulNames || result.invalidStateNames) {
                $(messageDiv).insert(new Element("br"));
            }
            var errorDiv = createDiv("red", i18n("ErrorsWithColon"), result.errors, 1);
            $(messageDiv).insert(errorDiv);
        }
    }

    this.clearMessage = function() {
        $('messageDiv').hide();
    }

    var clearSelectedAgents = function(dataTable) {
        dataTable.selectedRows = new Array();
        dataTable.resetSelections();
        dataTable.clearSelectedCountDiv();
        dataTable.render();
    }

    this.clearConfiguredSelectedAgents = function() {
        clearSelectedAgents(that.configuredDataTable);
    }

    this.clearAvailableSelectedAgents = function() {
        clearSelectedAgents(that.availableDataTable);
    }

    this.clearIgnoredSelectedAgents = function() {
        clearSelectedAgents(that.inactiveDataTable);
    }
}

AgentListPage.prototype = new AgentDataTableHolder();
