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

String agentViewId = "00000000-0000-0000-0000-000000000103"
String agentManagementId = "00000000-0000-0000-0000-000000000104"
String systemTabActionId = "00000000-0000-0000-0000-000000000037"
String sraIdSelectorSql = "SELECT sec_role_id FROM sec_role_action WHERE sec_action_id = '${systemTabActionId}'"

sql.eachRow(sraIdSelectorSql) { row ->
    String roleId = row['sec_role_id']
    String insertAgentActionSql = "INSERT INTO sec_role_action(id, version, sec_role_id, sec_action_id) VALUES(?, 0, ?, ?)"
    
    String id = UUID.randomUUID()
    sql.executeUpdate(insertAgentActionSql, [id, roleId, agentViewId])
    id = UUID.randomUUID()
    sql.executeUpdate(insertAgentActionSql, [id, roleId, agentManagementId])
}

sql.commit();