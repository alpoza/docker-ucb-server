-- Licensed Materials - Property of IBM Corp.
-- IBM UrbanCode Build
-- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
--
-- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
-- GSA ADP Schedule Contract with IBM Corp.
INSERT INTO REPORT_DB_VERSION (RELEASE_NAME, VER) VALUES ('4.0', 10);

insert into sec_resource_type (id, version, name, enabled)
    values ('00000000-0000-0000-0000-000000100000', 0, 'Report', 'Y');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000001000000', 0, 'Report Run', 'Ability to run a report.', 'Y' , 'N', '00000000-0000-0000-0000-000000100000');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000001000001', 0, 'Report Edit', 'Ability to edit and delete a report.', 'Y', 'N', '00000000-0000-0000-0000-000000100000');

insert into sec_action (id, version, name, description, enabled, cascading, sec_resource_type_id)
    values ('00000000-0000-0000-0000-000001000002', 0, 'Report Create', 'Ability to create reports.', 'Y', 'N', '00000000-0000-0000-0000-000000100022');
