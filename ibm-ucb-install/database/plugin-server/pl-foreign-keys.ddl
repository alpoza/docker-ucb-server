-- Licensed Materials - Property of IBM Corp.
-- IBM UrbanCode Build
-- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
--
-- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
-- GSA ADP Schedule Contract with IBM Corp.
alter table pl_plugin add constraint pl_plugin_2_prop_sheet_group foreign key(prop_sheet_group_id) references ps_prop_sheet_group(id);
alter table pl_plugin_command add constraint pl_plg_cmd_2_plugin foreign key(plugin_id) references pl_plugin(id);
alter table pl_plugin_command add constraint pl_plg_cmd_2_prop_sheet_def foreign key(prop_sheet_def_id) references ps_prop_sheet_def(id);
