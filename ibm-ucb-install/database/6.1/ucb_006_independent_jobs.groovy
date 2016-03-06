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

import groovy.xml.DOMBuilder;
import groovy.xml.dom.DOMCategory;

import org.w3c.dom.*;

// login information for database
// this should be modified as need be
Hashtable properties = (Hashtable) this.getBinding().getVariable("ANT_PROPERTIES");
Connection connection = (Connection) this.getBinding().getVariable("CONN");
boolean verbose = Boolean.valueOf(properties.get("verbose")).booleanValue();
Sql sql = new Sql(connection)
//------------------------------------------------------------------------------
//utility methods

error = { message ->
  println("!!"+message);
}

warn = { message ->
  println("warn - "+message);
}

debug = { message ->
  if (verbose) {
    println(message);
  }
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
sql.connection.autoCommit = false;

String getTeamResourcesSql = "SELECT sec_team_space_id, sec_resource_role_id FROM sec_resource_for_team WHERE sec_resource_id = ?"
String insertTeamResourceSql =
''' INSERT INTO sec_resource_for_team (
      id,
      version,
      sec_resource_id,
      sec_team_space_id,
      sec_resource_role_id
    )
    VALUES (?, ?, ?, ?, ?)
'''
String insertRoleActionSql = 'INSERT INTO sec_role_action (id, version, sec_role_id, sec_action_id) VALUES (?, 0, ?, ?)'
String insertResourceSql = 'INSERT INTO sec_resource (id, version, name, enabled, sec_resource_type_id) VALUES (?, ?, ?, ?, ?)'

Set<String> duplicateNames = new HashSet<String>()
sql.eachRow("SELECT NAME, COUNT(NAME) NAME_COUNT FROM JOB_CONFIG GROUP BY NAME HAVING COUNT(NAME) > 1") { row ->
    duplicateNames.add(row['NAME'])
}

sql.eachRow("SELECT * FROM JOB_CONFIG") { row ->
    String id = row['ID']
    String name = row['NAME']
    String workflowDefId = row['WORKFLOW_DEFINITION_ID']
    String resourceId = UUID.randomUUID().toString()
    def workflowDefRow = sql.firstRow("SELECT NAME, RESOURCE_ID FROM WORKFLOW_DEFINITION WHERE ID = ?", [workflowDefId])
    String workflowDefName = workflowDefRow['NAME']
    String workflowDefResourceId = workflowDefRow['RESOURCE_ID']

    boolean isDuplicateName = duplicateNames.contains(name)
    if (isDuplicateName) {
        name = workflowDefName + " : " + name
    }

    sql.executeUpdate(insertResourceSql, [resourceId, 0, name, 'Y', '00000000-0000-0000-0000-000000000023'])
    sql.executeUpdate("UPDATE JOB_CONFIG SET RESOURCE_ID = ? WHERE ID = ?", [resourceId, id])
    sql.eachRow(getTeamResourcesSql, [workflowDefResourceId]) { resTeamAssocRow ->
        String assocRowId = UUID.randomUUID().toString()
        String teamId = resTeamAssocRow['sec_team_space_id']
        String resRoleId = resTeamAssocRow['sec_resource_role_id']
        sql.executeUpdate(insertTeamResourceSql, [assocRowId, 0, resourceId, teamId, resRoleId])
    }
    if (isDuplicateName) {
        sql.executeUpdate("UPDATE JOB_CONFIG SET NAME = ? WHERE ID = ?", [name, id])
    }
}

final def copySecurityActions = { newActionId, oldActionId ->
    sql.eachRow("SELECT * FROM sec_role_action WHERE sec_action_id = ?", [oldActionId]) { row ->
        String roleActionId = UUID.randomUUID().toString()
        String roleId = row['sec_role_id']
        sql.executeUpdate(insertRoleActionSql, [roleActionId, roleId, newActionId])
    }
}

copySecurityActions('00000000-0000-0000-0000-000000000106', '00000000-0000-0000-0000-000000000028')
copySecurityActions('00000000-0000-0000-0000-000000000107', '00000000-0000-0000-0000-000000000029')
copySecurityActions('00000000-0000-0000-0000-000000000108', '00000000-0000-0000-0000-000000000094')
