-- Licensed Materials - Property of IBM Corp.
-- IBM UrbanCode Build
-- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
--
-- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
-- GSA ADP Schedule Contract with IBM Corp.
-------------------------------------------------------------------------------
-- SECURITY
-------------------------------------------------------------------------------

insert into sec_authorization_realm (id, version, name, description, authorization_module)
    values ('00000000-0000-0000-0000-000000000000', 0, 'Internal Authorization', 'Internal Authorization', 'com.urbancode.security.authorization.internal.InternalAuthorizationModule');

insert into sec_authentication_realm (id, version, name, description, sort_order, enabled, read_only, login_module, sec_authorization_realm_id, ghosted_date, allowed_attempts)
    values ('00000000-0000-0000-0000-000000000001', 0, 'Internal Authentication', 'Internal Authentication', 0, 'Y', 'N', 'com.urbancode.security.authentication.internal.InternalLoginModule', '00000000-0000-0000-0000-000000000000', 0, 0);


insert into sec_user (id, version, name, enabled, password, actual_name, email, sec_authentication_realm_id, ghosted_date, failed_attempts)
    values ('00000000-0000-0000-0000-000000000002', 0, 'admin', 'Y', 'admin', null, null, '00000000-0000-0000-0000-000000000001', 0, 0);

insert into sec_user (id, version, name, enabled, password, actual_name, email, sec_authentication_realm_id, ghosted_date, failed_attempts)
    values ('00000000-0000-0000-0000-000000000003', 0, 'ubuild', 'Y', '', null, null, '00000000-0000-0000-0000-000000000001', 0, 0);

insert into sec_user (id, version, name, enabled, password, actual_name, email, sec_authentication_realm_id, ghosted_date, failed_attempts)
    values ('00000000-0000-0000-0000-000000000004', 0, 'guest', 'Y', '', null, null, '00000000-0000-0000-0000-000000000001', 0, 0);


insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000000004', 0, 'Project', 'Y');

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000000006', 0, 'Agent Pool', 'Y');

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000000007', 0, 'Project Process', 'Y');

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000000008', 0, 'CodeStation', 'Y');

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000000009', 0, 'Repository', 'Y');

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000000018', 0, 'Agent Relay', 'Y');

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000000021', 0, 'Template', 'Y');

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000100022', 0, 'Security', 'Y');

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000000023', 0, 'Job', 'Y');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000032', 0, 'Project View', 'Ability to view a project. This is required to see the project and to see the project''s build lives and related data.', 'Y', 'N', '00000000-0000-0000-0000-000000000004');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000033', 0, 'Project Edit', 'Ability to edit and delete a project. This includes setting the configuration provided by the project''s template as well as management build configurations and secondary processes on the project.', 'Y', 'N', '00000000-0000-0000-0000-000000000004');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000035', 0, 'Process Run', 'Ability to run a build process or secondary process.', 'Y', 'N', '00000000-0000-0000-0000-000000000007');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000037', 0, 'System Administration', 'Ability to manage the system configuration of the server itself. You only need this action granted by a role. There is no resource that needs to be added to a user''s team.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000039', 0, 'Repository View', 'Ability to view and use a repository configuration in a source configuration. This is required for users to view build configurations that use the repository and for users to make a build configuration''s source configuration use the repository.', 'Y', 'N', '00000000-0000-0000-0000-000000000009');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000040', 0, 'Repository Edit', 'Ability to edit and delete a repository configuration.', 'Y', 'N', '00000000-0000-0000-0000-000000000009');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000044', 0, 'Audit Administration', 'Ability to view and report on audit information containing changes to security and configuration. You only need this action granted by a role. There is no resource that needs to be added to a user''s team.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000047', 0, 'Security Administration', 'Ability to manage security configuration such as Authentication Realms, Authorization Realms, Roles, Resources Roles, Teams and User Management. You only need this action granted by a role. There is no resource that needs to be added to a user''s team.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000102', 0, 'Scripts Administration', 'Ability to view, create, and use scripts. This is required for users to view process configurations that use scripts.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000059', 0, 'Project Artifact Download', 'Ability to download artifacts produced by a project.', 'Y', 'N', '00000000-0000-0000-0000-000000000004');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000063', 0, 'Agent Relay View', 'Ability to view a agent relay instance.', 'Y', 'N', '00000000-0000-0000-0000-000000000018');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000064', 0, 'Agent Relay Edit', 'Ability to edit a agent relay instance.', 'Y', 'N', '00000000-0000-0000-0000-000000000018');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000067', 0, 'Process Restart', 'Ability to restart build processes and secondary processes that have already completed or those that are running in certain scenarios where there are parallel activities. You only need this action granted by a role. There is no resource that needs to be added to a user''s team. A user can restart any process they can run.', 'Y', 'N', '00000000-0000-0000-0000-000000000007');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000068', 0, 'Process Prioritize', 'Ability to change the priority of running build processes and secondary processes. You only need this action granted by a role. There is no resource that needs to be added to a user''s team. A user can prioritize any process they can run.', 'Y', 'N', '00000000-0000-0000-0000-000000000007');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000069', 0, 'Delete History', 'Ability to delete records of builds and secondary processes. You only need this action granted by a role. There is no resource that needs to be added to a user''s team. A user can delete any runtime records of a project they can view.', 'Y', 'N', '00000000-0000-0000-0000-000000000007');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000070', 0, 'Add Manual Stamp', 'Ability to manually add stamps to a build life. You only need this action granted by a role. There is no resource that needs to be added to a user''s team. A user can add a stamp to a build from any project they can view.', 'Y', 'N', '00000000-0000-0000-0000-000000000007');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000071', 0, 'Add Manual Status', 'Ability to manually add statuses to a build life. You only need this action granted by a role. There is no resource that needs to be added to a user''s team. A user can add a status to a build from any project they can view.', 'Y', 'N', '00000000-0000-0000-0000-000000000007');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000072', 0, 'Agent Pool View', 'Ability to view a agent pool and the agents in it. This is required to see processes that have jobs that use the agent pool.', 'Y', 'N', '00000000-0000-0000-0000-000000000006');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000073', 0, 'Agent Pool Edit', 'Ability to edit and delete a agent pool. This is required to add and remove agents from the pool.', 'Y', 'N', '00000000-0000-0000-0000-000000000006');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000082', 0, 'Template View', 'Ability to view a project, process or source template. This is required to create a project, process or source configuration using the template.', 'Y', 'N', '00000000-0000-0000-0000-000000000021');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000083', 0, 'Template Edit', 'Ability to edit and delete a project, process or source template.', 'Y', 'N', '00000000-0000-0000-0000-000000000021');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000089', 0, 'CodeStation View', 'Ability to view a CodeStation project. This is required to see the CodeStation project and configure it as a dependency.', 'Y', 'N', '00000000-0000-0000-0000-000000000008');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000090', 0, 'CodeStation Edit', 'Ability to edit and delete a CodeStation project, manage its build lives and their artifacts.', 'Y', 'N', '00000000-0000-0000-0000-000000000008');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000091', 0, 'Project Create', 'Ability to create new projects from templates.', 'Y', 'N', '00000000-0000-0000-0000-000000000004');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000092', 0, 'CodeStation Create', 'Ability to create new CodeStation projects.', 'Y', 'N', '00000000-0000-0000-0000-000000000008');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000093', 0, 'Repository Create', 'Ability to create new repository configurations.', 'Y', 'N', '00000000-0000-0000-0000-000000000009');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000096', 0, 'Template Create', 'Ability to create new project, process and source templates.', 'Y', 'N', '00000000-0000-0000-0000-000000000021');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000097', 0, 'CodeStation Download', 'Ability to download artifacts of a CodeStation project.', 'Y', 'N', '00000000-0000-0000-0000-000000000008');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000098', 0, 'Team User Management', 'Ability to add users to teams you are in in roles that already exist on the team.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000099', 0, 'Team Resource Management', 'Ability to add resources to teams you are in in roles that already exist on the team.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000100', 0, 'User Management', 'Ability to create and edit users.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000101', 0, 'Process Abort', 'Ability to abort running build processes and secondary processes. You only need this action granted by a role. There is no resource that needs to be added to a user''s team. A user can restart any process they can run.', 'Y', 'N', '00000000-0000-0000-0000-000000000007');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000103', 0, 'Agent View', 'Ability to view agents and their configurations.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000104', 0, 'Agent Management', 'Ability to create, edit, and delete agents.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000105', 0, 'Process Artifact Download', 'Ability to download artifacts produced by a build process.', 'Y', 'N', '00000000-0000-0000-0000-000000000007');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000106', 0, 'Job View', 'Ability to view a job. This is required to use the job in a process definition. It is not required by users of projects to run build processes and secondary processes.', 'Y', 'N', '00000000-0000-0000-0000-000000000023');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000107', 0, 'Job Edit', 'Ability to edit or delete a job. This is required to edit the job''s steps.', 'Y', 'N', '00000000-0000-0000-0000-000000000023');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000000000108', 0, 'Job Create', 'Ability to create a job.', 'Y', 'N', '00000000-0000-0000-0000-000000000023');



insert into sec_role (id, version, name, description, enabled)
    values ('00000000-0000-0000-0000-000000000100', 0, 'Administrator', 'Default Administrator Role', 'Y');



insert into sec_team_space (id, version, enabled, name)
    values ('00000000-0000-0000-0000-000000000200', 0, 'N', 'System Team');

insert into sec_user_role_on_team (id, version, sec_user_id, sec_role_id, sec_team_space_id)
    values('00000000-0000-0000-0000-000000000300', 0, '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000100', '00000000-0000-0000-0000-000000000200');

insert into sec_user_role_on_team (id, version, sec_user_id, sec_role_id, sec_team_space_id)
    values('00000000-0000-0000-0000-000000000301', 0, '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000100', '00000000-0000-0000-0000-000000000200');


insert into sec_group_mapper (id, version, name)
    values ('00000000-0000-0000-0000-000000000500', 0, 'Identity Mapper');

insert into sec_group_mapping (id, version, sec_group_mapper_id, regex, replacement)
    values ('00000000-0000-0000-0000-000000000501', 0, '00000000-0000-0000-0000-000000000500', '.*', '$0');
