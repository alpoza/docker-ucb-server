        YAHOO.widget.Paginator.ui.RowsPerPageDropdown.prototype.render=function (id_base) {
              this.select = document.createElement('select');
              this.select.id        = id_base + '-rpp';
              this.select.className = this.paginator.get('rowsPerPageDropdownClass');
              this.select.title = i18n("RowsPerPage");

              YAHOO.util.Event.on(this.select,'change',this.onChange,this,true);

              this.rebuild();

              return this.select;
          };

          YAHOO.widget.Paginator.ui.FirstPageLink.init = function (p) {
              p.setAttributeConfig('firstPageLinkLabel', {
                  value : i18n("FirstPageLabel"),
                  validator : YAHOO.lang.isString
              });

              p.setAttributeConfig('firstPageLinkClass', {
                  value : 'yui-pg-first',
                  validator : YAHOO.lang.isString
              });

             p.setAttributeConfig('firstPageLinkTitle', {
                 value : i18n("FirstPageTitle"),
                 validator : YAHOO.lang.isString
             });
         };
         YAHOO.widget.Paginator.ui.PreviousPageLink.init = function (p) {
             p.setAttributeConfig('previousPageLinkLabel', {
                 value : i18n("PrevPageLabel"),
                 validator : YAHOO.lang.isString
             });

             p.setAttributeConfig('previousPageLinkClass', {
                 value : 'yui-pg-previous',
                 validator : YAHOO.lang.isString
             });

             p.setAttributeConfig('previousPageLinkTitle', {
                 value : i18n("PreviousPage"),
                 validator : YAHOO.lang.isString
             });
         };
         YAHOO.widget.Paginator.ui.LastPageLink.init = function (p) {
             p.setAttributeConfig('lastPageLinkLabel', {
                 value : i18n("LastPageLabel"),
                 validator : YAHOO.lang.isString
             });

              p.setAttributeConfig('lastPageLinkClass', {
                  value : 'yui-pg-last',
                  validator : YAHOO.lang.isString
              });

              p.setAttributeConfig('lastPageLinkTitle', {
                  value : i18n("LastPageTitle"),
                  validator : YAHOO.lang.isString
              });
         };
         YAHOO.widget.Paginator.ui.NextPageLink.init = function (p) {
             p.setAttributeConfig('nextPageLinkLabel', {
                 value : i18n("NextPageLabel"),
                 validator : YAHOO.lang.isString
             });

             p.setAttributeConfig('nextPageLinkClass', {
                 value : 'yui-pg-next',
                 validator : YAHOO.lang.isString
             });

             p.setAttributeConfig('nextPageLinkTitle', {
                 value : i18n("NextPage"),
                 validator : YAHOO.lang.isString
             });
          };