-- licensed materials - property of ibm corp.
-- ibm urbancode build
-- (c) copyright ibm corporation 2012, 2014. all rights reserved.
--
-- u.s. government users restricted rights - use, duplication or disclosure restricted by
-- gsa adp schedule contract with ibm corp.
create table pl_plugin (
    id nvarchar(36) not null primary key,
    version integer default 0 not null,
    plugin_type nvarchar(32) not null,
    name nvarchar(256) not null,
    tag nvarchar(256) not null,
    description nvarchar(4000),
    plugin_id nvarchar(255) not null,
    plugin_version integer not null,
    release_version nvarchar(256),
    plugin_hash nvarchar(256) not null,
    prop_sheet_group_id nvarchar(36) not null,
    constraint pl_plugin_uc unique(plugin_id, plugin_version)
);
create index pl_plugin_plugin_id on pl_plugin(plugin_id);
create index pl_plugin_prop_sheet_group_id on pl_plugin(prop_sheet_group_id);

create table pl_plugin_command (
    id nvarchar(36) not null primary key,
    version integer default 0 not null,
    name nvarchar(255) not null,
    description nvarchar(4000),
    plugin_id nvarchar(36) not null,
    command_type nvarchar(36),
    prop_sheet_def_id nvarchar(36) not null,
    validation_script_lang nvarchar(32),
    validation_script_content ntext,
    post_processing_script ntext,
    constraint pl_plugin_command_uc unique(plugin_id, name)
);
create index pl_plg_cmd_plugin_id on pl_plugin_command(plugin_id);
create index pl_plg_cmd_prop_sheet_def_id on pl_plugin_command(prop_sheet_def_id);

create table pl_db_version (
    release_name  nvarchar(256) not null,
    ver           integer default 0 not null
);
