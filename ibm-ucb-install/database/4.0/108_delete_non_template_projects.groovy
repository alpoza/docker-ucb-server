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
// update

// get all projects to delete
sql.eachRow("SELECT ID, NAME FROM PROJECT WHERE PROJECT_TEMPLATE_ID IS NULL") { row ->
    Long projectId = row["ID"]
    println "Removing project ${row['NAME']}"
    sql.executeUpdate("DELETE FROM PROJECT_PROPERTY WHERE PROJECT_ID = ?", [projectId])
    sql.executeUpdate("DELETE FROM JOB_CONFIG_STEP WHERE JOB_CONFIG_ID IN (SELECT ID FROM JOB_CONFIG WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM JOB_CONFIG WHERE PROJECT_ID = ?", [projectId])
    sql.executeUpdate("DELETE FROM JOB_CONFIG WHERE PROJECT_ID = ?", [projectId])
    sql.executeUpdate("DELETE FROM WORKFLOW_DEFINITION_EDGES WHERE FROM_WF_DEF_JOB_CONFIG_ID IN (SELECT ID FROM WORKFLOW_DEFINITION_JOB_CONFIG WHERE JOB_CONFIG_ID IN (SELECT ID FROM JOB_CONFIG WHERE PROJECT_ID = ?))", [projectId])
    sql.executeUpdate("DELETE FROM WORKFLOW_DEFINITION_EDGES WHERE TO_WF_DEF_JOB_CONFIG_ID IN (SELECT ID FROM WORKFLOW_DEFINITION_JOB_CONFIG WHERE JOB_CONFIG_ID IN (SELECT ID FROM JOB_CONFIG WHERE PROJECT_ID = ?))", [projectId])
    sql.executeUpdate("DELETE FROM WORKFLOW_DEFINITION_JOB_CONFIG WHERE JOB_CONFIG_ID IN (SELECT ID FROM JOB_CONFIG WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM WORKFLOW_TRIGGER WHERE WORKFLOW_ID IN (SELECT ID FROM WORKFLOW WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM WORKFLOW_PROPERTY WHERE WORKFLOW_ID IN (SELECT ID FROM WORKFLOW WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM WORKFLOW_LOCK_RES_REF WHERE WORKFLOW_ID IN (SELECT ID FROM WORKFLOW WHERE PROJECT_ID = ?)", [projectId])
    
    sql.executeUpdate("DELETE FROM BUILD_LIFE_DEP_PLAN_RESOLUTION")
    sql.executeUpdate("DELETE FROM BUILD_LIFE_DEPENDENCY")
    sql.executeUpdate("DELETE FROM BUILD_REQUEST WHERE WORKFLOW_ID IN (SELECT ID FROM WORKFLOW WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM BUILD_LIFE_STAMP WHERE BUILD_LIFE_ID IN (SELECT ID FROM BUILD_LIFE WHERE PROFILE_ID IN (SELECT ID FROM BUILD_PROFILE WHERE PROJECT_ID = ?))", [projectId])
    sql.executeUpdate("DELETE FROM BUILD_LIFE_STATUS WHERE BUILD_LIFE_ID IN (SELECT ID FROM BUILD_LIFE WHERE PROFILE_ID IN (SELECT ID FROM BUILD_PROFILE WHERE PROJECT_ID = ?))", [projectId])
    sql.executeUpdate("DELETE FROM BUILD_LIFE WHERE PROFILE_ID IN (SELECT ID FROM BUILD_PROFILE WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM BUILD_LIFE_DEPENDENCY_PLAN WHERE ID NOT IN (SELECT DEPENDENCY_PLAN_ID FROM BUILD_LIFE)")
    sql.executeUpdate("DELETE FROM JOB_TRACE WHERE PROJECT_ID = ?", [projectId])
    
    sql.executeUpdate("DELETE FROM DEPENDENCY WHERE DEPENDENT_ANTHILL_PROFILE_ID IN (SELECT ID FROM BUILD_PROFILE WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM DEPENDENCY WHERE DEPENDENCY_ANTHILL_PROFILE_ID IN (SELECT ID FROM BUILD_PROFILE WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM SOURCE_CONFIG WHERE BUILD_PROFILE_ID IN (SELECT ID FROM BUILD_PROFILE WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM BUILD_PROFILE WHERE WORKFLOW_ID IN (SELECT ID FROM WORKFLOW WHERE PROJECT_ID = ?)", [projectId])
    sql.executeUpdate("DELETE FROM WORKFLOW WHERE PROJECT_ID = ?", [projectId])
}
sql.executeUpdate("DELETE FROM WORKFLOW_DEFINITION WHERE IS_LIBRARY = 0")
sql.executeUpdate("DELETE FROM PROJECT WHERE PROJECT_TEMPLATE_ID IS NULL")

return;