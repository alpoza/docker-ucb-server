-- Licensed Materials - Property of IBM Corp.
-- IBM UrbanCode Build
-- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
--
-- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
-- GSA ADP Schedule Contract with IBM Corp.
create table pl_plugin (
    id varchar(36) not null primary key,
    version integer default 0 not null,
    plugin_type varchar(32) not null,
    name varchar(256) not null,
    tag varchar(256) not null,
    description varchar(4000),
    plugin_id varchar(255) not null,
    plugin_version integer not null,
    release_version varchar(256),
    plugin_hash varchar(256) not null,
    prop_sheet_group_id varchar(36) not null,
    constraint pl_plugin_uc unique(plugin_id, plugin_version)
);
create index pl_plugin_plugin_id on pl_plugin(plugin_id);
create index pl_plugin_prop_sheet_group_id on pl_plugin(prop_sheet_group_id);

create table pl_plugin_command (
    id varchar(36) not null primary key,
    version integer default 0 not null,
    name varchar(255) not null,
    description varchar(4000),
    plugin_id varchar(36) not null,
    command_type varchar(36),
    prop_sheet_def_id varchar(36) not null,
    validation_script_lang varchar(32),
    validation_script_content clob,
    post_processing_script clob,
    constraint pl_plugin_command_uc unique(plugin_id, name)
);
create index pl_plg_cmd_plugin_id on pl_plugin_command(plugin_id);
create index pl_plg_cmd_prop_sheet_def_id on pl_plugin_command(prop_sheet_def_id);

create table pl_db_version (
    release_name  varchar(256) not null,
    ver           integer default 0 not null
);
