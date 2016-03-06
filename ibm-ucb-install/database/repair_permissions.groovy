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
 Name       Description
ant         an instance of AntBuilder that knows about the current ant project
project     the current ant project
properties  a Map of ant properties
target      the owning target that invoked this groovy script
task        the wrapping task, can access anything needed in org.apache.tools.ant.Task
 args           command line arguments, if any
 */

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
    if (verbose) {
        println(message);
        }
    }

final def newId = {
    return UUID.randomUUID().toString()
}

Sql sql = null
def verbose = false
def manageConn = false
Hashtable properties = (Hashtable) getBindingVar("ANT_PROPERTIES");
Connection connection = (Connection) getBindingVar("CONN");
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

try {
    sql.connection.autoCommit = false;

    // GET THE USER-ROLE ID FOR SYSTEM USER
    final String adminUserId = '00000000-0000-0000-0000-000000000002';
    final String sysUserId = '00000000-0000-0000-0000-000000000003';
    final String sysTeamSpaceId = '00000000-0000-0000-0000-000000000200'
    final String sysRoleId = '00000000-0000-0000-0000-000000000100'

    //==============================================================================
    // Make sure all resources are associated with the system team
    //==============================================================================
    final String missingResourceSql = 'select * from sec_resource where id not in ' +
        '(select sec_resource_id from sec_resource_for_team where sec_team_space_id = ?)'
    sql.eachRow(missingResourceSql, [sysTeamSpaceId]) { missingResourceRow ->
        def resourceId = missingResourceRow['id']
        sql.executeUpdate(
            'insert into sec_resource_for_team (id, version, sec_team_space_id, sec_resource_id) values (?, 0, ?, ?)',
            [newId(), sysTeamSpaceId, resourceId]
        )
    }
    //==============================================================================

    //==============================================================================
    // Make sure all actions are in the administrator role
    //==============================================================================
    final String missingActionSql = 'select * from sec_action where id not in ' +
    '(select sec_action_id from sec_role_action where sec_role_id = ?)'
    sql.eachRow(missingActionSql, [sysRoleId]) { missingActionRow ->
        def actionId = missingActionRow['id']
        sql.executeUpdate(
            'insert into sec_role_action (id, version, sec_role_id, sec_action_id) values (?, 0, ?, ?)',
            [newId(), sysRoleId, actionId]
        )
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