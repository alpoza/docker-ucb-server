-- licensed materials - property of ibm corp.
-- ibm urbancode build
-- (c) copyright ibm corporation 2012, 2014. all rights reserved.
--
-- u.s. government users restricted rights - use, duplication or disclosure restricted by
-- gsa adp schedule contract with ibm corp.
create table pl_plugin (
    id varchar(36) binary not null primary key,
    version integer default 0 not null,
    plugin_type varchar(32) binary not null,
    name varchar(256) binary not null,
    tag varchar(256) binary not null,
    description varchar(4000) binary,
    plugin_id varchar(255) binary not null,
    plugin_version integer not null,
    release_version varchar(256) binary,
    plugin_hash varchar(256) binary not null,
    prop_sheet_group_id varchar(36) binary not null,
    constraint pl_plugin_uc unique(plugin_id, plugin_version)
) engine = innodb;
create index pl_plugin_plugin_id on pl_plugin(plugin_id);
create index pl_plugin_prop_sheet_group_id on pl_plugin(prop_sheet_group_id);

create table pl_plugin_command (
    id varchar(36) binary not null primary key,
    version integer default 0 not null,
    name varchar(255) binary not null,
    description varchar(4000) binary,
    plugin_id varchar(36) binary not null,
    command_type varchar(36) binary,
    prop_sheet_def_id varchar(36) binary not null,
    validation_script_lang varchar(32) binary,
    validation_script_content longtext,
    post_processing_script longtext,
    constraint pl_plugin_command_uc unique(plugin_id, name)
) engine = innodb;
create index pl_plg_cmd_plugin_id on pl_plugin_command(plugin_id);
create index pl_plg_cmd_prop_sheet_def_id on pl_plugin_command(prop_sheet_def_id);

create table pl_db_version (
    release_name  varchar(256) binary not null,
    ver           integer default 0 not null
) engine = innodb;
