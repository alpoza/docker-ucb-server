/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
import groovy.sql.Sql;
import groovy.text.Template;
import groovy.text.SimpleTemplateEngine;
import groovy.xml.*;

import java.io.*;
import java.lang.*;
import java.sql.Connection;
import java.util.*;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.*;

/*
 Name 	 	Description
ant 		an instance of AntBuilder that knows about the current ant project
project 	the current ant project
properties 	a Map of ant properties
target 		the owning target that invoked this groovy script
task 		the wrapping task, can access anything needed in org.apache.tools.ant.Task
args		command line arguments, if any
*/

Sql sql = null
def verbose = false
def manageConn = false
Hashtable properties = (Hashtable) getBindingVar("ANT_PROPERTIES");
Connection connection = (Connection) getBindingVar("CONN");

//==============================================================================

def getBindingVar(String varName) {
    def b = this.getBinding();
    try {
        return b.getVariable(varName);
    }
    catch (MissingPropertyException e) {
        return null;
    }
}

//------------------------------------------------------------------------------
//utility methods

final def error = { message ->
    println("!!"+message);
}

final def warn = { message ->
    println(message);
}

final def debug = { message ->
//    if (verbose) {
        println(message);
//    }
}

final def newId = {
    return UUID.randomUUID().toString()
}

if (properties && connection) {
    println "Using connection from binding...${connection}"
    verbose = Boolean.valueOf(properties.get('verbose')).booleanValue()
    sql = new Sql(connection)
}
else {
    println "Using command line arguments..."
    final String driver = args[0]
    final String url = args[1]
    final String usr = args[2]
    final String pwd = args[3]
    sql = Sql.newInstance(url, usr, pwd, driver);
    manageConn = true
}
try { // catch-rollback & finally-close
    sql.connection.autoCommit = false;
    //==============================================================================
    
    //------------------------------------------------------------------------------
    // GET THE USER-ROLE ID FOR SYSTEM USER
    final String adminUserId = '00000000-0000-0000-0000-000000000002';
    final String sysUserId = '00000000-0000-0000-0000-000000000003';
    final String sysTeamSpaceId = '00000000-0000-0000-0000-000000000200'
    final String sysRoleId = '00000000-0000-0000-0000-000000000100'
    
    //------------------------------------------------------------------------------
    // ENSURE ALL PERMISSIONS FOR ALL SEC_RESOURCES
    final String createPermission = "insert into sec_permission (id, resource_id, role_id, users_class, users_id, can_delete) values (?, ?, ?, ?, ?, ?)"
    final String checkPermission = "select * from sec_permission where resource_id = ? and role_id = ? and users_class = ? and users_id = ?"

    //------------------------------------------------------------------------------
    // ENSURE SEC_RES EXIST FOR ALL SECURABLE OBJECTS
    // Resource Types: Project, SysFunc, Env, Workflow, CSProj, Repo, Folder
    final String createResource = "insert into sec_resource (id, version, name, enabled, sec_resource_type_id) values(?, 0, ?, 'Y', ?)";

    // create a resource does not exist for given class+id, make it (using name & type)
    final def createSecRes = { id, name, resTypeId ->
        String resourceId = UUID.randomUUID().toString()
        sql.executeUpdate(createResource, [resourceId, name, resTypeId])
        return resourceId
    }
    
    final def createSecResources = { tableName, resTypeId ->
      debug("Creating resources for table $tableName with resource type $resTypeId")
      sql.eachRow("select * from " + tableName + " where RESOURCE_ID is null") {row ->
        long id = row["ID"]
        String name = row["NAME"]
        debug("Creating resource for ${tableName}:${id} with name ${name}")
        String resourceId = createSecRes(id, name, resTypeId)
        sql.executeUpdate("update " + tableName + " set RESOURCE_ID = ? where ID = ?", [resourceId, id])
      }
    }

    final def createLibWorkflowSecResources = {
        def resTypeId = '00000000-0000-0000-0000-000000000011'
        sql.eachRow("select * from WORKFLOW_DEFINITION where RESOURCE_ID is null") {row ->
            long id = row["ID"];
            String name = row["NAME"];
            debug("Creating resource for workflow_definition:${id} with name ${name}")
            String resourceId = createSecRes(id, name, resTypeId)
            sql.executeUpdate("update WORKFLOW_DEFINITION set RESOURCE_ID = ? where ID = ?", [resourceId, id])
        }
    }
    
    final def createLibJobSecResources = {
        def resTypeId = '00000000-0000-0000-0000-000000000012'
        sql.eachRow("select * from JOB_CONFIG where RESOURCE_ID is null") {row ->
            long id = row["ID"];
            String name = row["NAME"];
            debug("Creating resource for job_config:${id} with name ${name}")
            String resourceId = createSecRes(id, name, resTypeId)
            sql.executeUpdate("update JOB_CONFIG set RESOURCE_ID = ? where ID = ?", [resourceId, id])
        }
    }

    createSecResources('PROJECT', '00000000-0000-0000-0000-000000000004');
    createSecResources('AGENT_POOL', '00000000-0000-0000-0000-000000000006');
    createSecResources('WORKFLOW', '00000000-0000-0000-0000-000000000007');
    createSecResources('CODESTATION_PROJECT', '00000000-0000-0000-0000-000000000008');
    createSecResources('REPOSITORY', '00000000-0000-0000-0000-000000000009');
    createLibWorkflowSecResources()
    createLibJobSecResources()
    createSecResources('AGENT_RELAY', '00000000-0000-0000-0000-000000000018');
    createSecResources('REQUEST_PLAN', '00000000-0000-0000-0000-000000000020');
    createSecResources('PROJECT_TEMPLATE', '00000000-0000-0000-0000-000000000021');

    
    // creating role-action mappings for sys role
    sql.eachRow('select * from sec_action') { actionRow ->
        def actionId = actionRow['id']
        sql.executeUpdate(
            'insert into sec_role_action (id, version, sec_role_id, sec_action_id) values (?, 0, ?, ?)',
            [newId(), sysRoleId, actionId]
        )
    }
    
    //insert missing sys permissions for each resource
    debug("Gathering available securable resources and ensuring system privileges.")
    

    sql.eachRow('select * from sec_resource') { resourceRow ->
        def resourceId = resourceRow['id']
        // check if the resource is connected to the system team space
        boolean addResourceToTeam = true
        sql.eachRow("select * from sec_resource_for_team where sec_team_space_id = ? and sec_resource_id = ?", [sysTeamSpaceId, resourceId]) { row ->
            addResourceToTeam = false
        }
        if (addResourceToTeam) {
            sql.executeUpdate("insert into sec_resource_for_team (id, version, sec_team_space_id, sec_resource_id) values (?, 0, ?, ?)",
                [newId(), sysTeamSpaceId, resourceId])
        }
    }
    
    if (manageConn) {
        sql.commit()
    }
}
catch (Exception e) {
    if (manageConn) {
        sql.rollback()
    }
    throw e
}
finally {
    if (manageConn) {
        sql.close()
    }
}
return
