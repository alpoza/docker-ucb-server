-- licensed materials - property of ibm corp.
-- ibm urbancode build
-- (c) copyright ibm corporation 2012, 2014. all rights reserved.
--
-- u.s. government users restricted rights - use, duplication or disclosure restricted by
-- gsa adp schedule contract with ibm corp.
create table pl_plugin (
    id varchar2(36) not null primary key,
    version integer default 0 not null,
    plugin_type varchar2(32) not null,
    name varchar2(256) not null,
    tag varchar2(256) not null,
    description varchar2(4000),
    plugin_id varchar2(255) not null,
    plugin_version integer not null,
    release_version varchar2(256),
    plugin_hash varchar2(256) not null,
    prop_sheet_group_id varchar2(36) not null,
    constraint pl_plugin_uc unique(plugin_id, plugin_version)
);
create index pl_plugin_plugin_id on pl_plugin(plugin_id);
create index pl_plugin_prop_sheet_group_id on pl_plugin(prop_sheet_group_id);

create table pl_plugin_command (
    id varchar2(36) not null primary key,
    version integer default 0 not null,
    name varchar2(255) not null,
    description varchar2(4000),
    plugin_id varchar2(36) not null,
    command_type varchar2(36),
    prop_sheet_def_id varchar2(36) not null,
    validation_script_lang varchar2(32),
    validation_script_content clob,
    post_processing_script clob,
    constraint pl_plugin_command_uc unique(plugin_id, name)
) lob (validation_script_content) store as ppc_vsc_lob,
 lob (post_processing_script) store as ppc_pps_lob;
create index pl_plg_cmd_plugin_id on pl_plugin_command(plugin_id);
create index pl_plg_cmd_prop_sheet_def_id on pl_plugin_command(prop_sheet_def_id);

create table pl_db_version (
    release_name  varchar2(256) not null,
    ver           integer default 0 not null
);
