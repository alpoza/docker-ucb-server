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

final def documentAsString = { data ->
    def result = null;
    if (data != null) {
        if (data instanceof java.lang.String) {
            result = data
        }
        else {
            // it's a java.sql.Clob
            // just use getCharacterStream(), which returns a reader?
            result = data.getAsciiStream().text;
        }
    }
    return result;
}

final def replaceColumnInTableWithId = { table, pkColumn, column, isXml ->
    String query = "SELECT ${pkColumn}, ${column} FROM ${table}"
    String update = "UPDATE ${table} SET ${column} = ? WHERE ${pkColumn} = ?"
    println query
    sql.eachRow(query) { row ->
        def id = row[pkColumn]
        String value = ""
        if (isXml) {
            value = documentAsString(row[column])
            value = value?.replace('com.urbancode.anthill3', 'com.urbancode.ubuild')
        }
        else {
            value = documentAsString(row[column])
            value = value?.replace('com.urbancode.anthill3', 'com.urbancode.ubuild')
        }
        println "${update} with ${id}"
        sql.executeUpdate(update, [value, id])
    }
}

final def replaceColumnInTableWithDependentId = { table, pkColumn1, pkColumn2, column, isXml ->
    String query = "SELECT ${pkColumn1}, ${pkColumn2}, ${column} FROM ${table}"
    String update = "UPDATE ${table} SET ${column} = ? WHERE ${pkColumn1} = ? AND ${pkColumn2} = ?"
    println query
    sql.eachRow(query) { row ->
        def id1 = row[pkColumn1]
        def id2 = row[pkColumn2]
        String value = ""
        if (isXml) {
            value = documentAsString(row[column])
            value = value?.replace('com.urbancode.anthill3', 'com.urbancode.ubuild')
        }
        else {
            value = documentAsString(row[column])
            value = value?.replace('com.urbancode.anthill3', 'com.urbancode.ubuild')
        }
        println "${update} with ${id1} ${id2}"
        sql.executeUpdate(update, [value, id1, id2])
    }
}

final def replaceColumnInTableWithId3 = { table, pkColumn1, pkColumn2, pkColumn3, column, isXml ->
    String query = "SELECT ${pkColumn1}, ${pkColumn2}, ${pkColumn3}, ${column} FROM ${table}"
    String update = "UPDATE ${table} SET ${column} = ? WHERE ${pkColumn1} = ? AND ${pkColumn2} = ? AND ${pkColumn3} = ?"
    println query
    sql.eachRow(query) { row ->
        def id1 = row[pkColumn1]
        def id2 = row[pkColumn2]
        def id3 = row[pkColumn3]
        String value = ""
        if (isXml) {
            value = documentAsString(row[column])
            value = value?.replace('com.urbancode.anthill3', 'com.urbancode.ubuild')
        }
        else {
            value = documentAsString(row[column])
            value = value?.replace('com.urbancode.anthill3', 'com.urbancode.ubuild')
        }
        println "${update} with ${id1} ${id2} ${id3}"
        sql.executeUpdate(update, [value, id1, id2, id3])
    }
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// update

// change com.urbancode.anthill3 to com.urbancode.ubuild
replaceColumnInTableWithId('BUILD_REQUEST', 'ID', 'REQUESTER_CLASS', false)
replaceColumnInTableWithId('BUILD_WORKFLOW_SUMMARY', 'ID', 'REQUESTER_CLASS', false)
replaceColumnInTableWithId('CLEANUP_CONFIG', 'ID', 'DATA', true)
replaceColumnInTableWithId('DEPENDENCY', 'ID', 'DATA', true)
replaceColumnInTableWithId('JOB_CONFIG_STEP', 'ID', 'CLASS', false)
replaceColumnInTableWithId('JOB_CONFIG_STEP', 'ID', 'DATA', true)
replaceColumnInTableWithId('JOB_TRACE', 'ID', 'CLASS', false)
replaceColumnInTableWithId('JOB_TRACE', 'ID', 'REQUESTER_CLASS', false)
replaceColumnInTableWithId3('JOB_STEP_CMD_TRACE', 'JOB_TRACE_ID', 'STEP_ID', 'SEQ', 'AGENT_HANDLE', true)
replaceColumnInTableWithId3('JOB_STEP_CMD_TRACE', 'JOB_TRACE_ID', 'STEP_ID', 'SEQ', 'COMMAND_HANDLE', true)
replaceColumnInTableWithId('LOCK_HOLDER', 'ID', 'HOLDER_CLASS', false)
replaceColumnInTableWithId('NOTIFICATION_RECIPIENT_GEN', 'ID', 'CLASS', false)
replaceColumnInTableWithId('NOTIFICATION_RECIPIENT_GEN', 'ID', 'DATA', true)
replaceColumnInTableWithId('NOTIFICATION_SCHEME_WHO_WHEN', 'SCHEME_ID', 'WHO_GENERATOR_CLASS', false)
replaceColumnInTableWithId('NOTIFICATION_SCHEME_WHO_WHEN', 'SCHEME_ID', 'WHO_CC_GENERATOR_CLASS', false)
replaceColumnInTableWithId('NOTIFICATION_SCHEME_WHO_WHEN', 'SCHEME_ID', 'WHO_BCC_GENERATOR_CLASS', false)
replaceColumnInTableWithId('NOTIFICATION_SCHEME_WHO_WHEN', 'SCHEME_ID', 'WHEN_GENERATOR_CLASS', false)
replaceColumnInTableWithId('POST_PROCESS_SCRIPT', 'ID', 'SCRIPT', false)
replaceColumnInTableWithId('PROJECT', 'ID', 'DATA', true)
replaceColumnInTableWithId3('PROPERTY', 'OWNER_ID', 'OWNER_CLASS', 'NAME', 'OWNER_CLASS', false)
replaceColumnInTableWithId3('PROPERTY_TEMPLATE', 'OWNER_ID', 'OWNER_CLASS', 'NAME', 'OWNER_CLASS', false)
replaceColumnInTableWithId3('PROPERTY_TEMPLATE', 'OWNER_ID', 'OWNER_CLASS', 'NAME', 'DATA', true)
replaceColumnInTableWithId('PROPERTY_VALUE_GROUP', 'ID', 'CONTAINER_CLASS', false)
replaceColumnInTableWithId('REPOSITORY_LISTENER', 'ID', 'CLASS', false)
replaceColumnInTableWithId('SCHEDULE', 'ID', 'CLASS', false)
replaceColumnInTableWithId('SCHEDULE', 'ID', 'DATA', true)
replaceColumnInTableWithId3('SCHEDULE_SCHEDULABLE', 'SCHEDULE_ID', 'TARGET_CLASS', 'TARGET_ID', 'TARGET_CLASS', false)
replaceColumnInTableWithId('SCRIPT', 'ID', 'SCRIPT', false)
replaceColumnInTableWithId('SINGLETON', 'ID', 'CLASS', false)
replaceColumnInTableWithId('SINGLETON', 'ID', 'DATA', true)
replaceColumnInTableWithId('SOURCE_CONFIG', 'ID', 'DATA', true)
replaceColumnInTableWithId('STEP_PRE_CONDITION_SCRIPT', 'ID', 'SCRIPT', false)
replaceColumnInTableWithId('TEMPLATE', 'ID', 'CLASS', false)
replaceColumnInTableWithId('TEMPLATE', 'ID', 'DATA', true)
replaceColumnInTableWithId('TRIGGER_CODE', 'ID', 'OWNER_CLASS', false)
replaceColumnInTableWithId('UBUILD_USER', 'ID', 'DATA', true)
replaceColumnInTableWithId('USER_TASK', 'ID', 'CLASS', false)
replaceColumnInTableWithId('USER_TASK', 'ID', 'DATA', true)
replaceColumnInTableWithId('WORK_DIR_SCRIPT', 'ID', 'PATH', false)
replaceColumnInTableWithId('WORKFLOW', 'ID', 'DATA', true)
replaceColumnInTableWithId('WORKFLOW_CASE_SELECTOR', 'ID', 'SCRIPT', false)
replaceColumnInTableWithDependentId('WORKFLOW_LOCK_RES_REF', 'WORKFLOW_TEMPLATE_ID', 'SEQ', 'SCRIPT', false)
replaceColumnInTableWithId('WORKFLOW_PRIORITY_SCRIPT', 'ID', 'SCRIPT', false)
replaceColumnInTableWithId('WORKFLOW_TRIGGER', 'ID', 'CLASS', false)
replaceColumnInTableWithId('WORKFLOW_TRIGGER', 'ID', 'DATA', true)

sql.executeUpdate("DELETE FROM AUTH_TOKEN_CONTEXT")
sql.executeUpdate("DELETE FROM REPOSITORY_USERS")

return;
