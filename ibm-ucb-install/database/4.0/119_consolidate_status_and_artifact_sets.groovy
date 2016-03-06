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

sql.eachRow("SELECT NAME, COUNT(*) AS ARTIFACT_SET_COUNT FROM ARTIFACT_SET GROUP BY NAME") { row ->
    if (row["ARTIFACT_SET_COUNT"] > 1) {
        def artifactSetName = row['NAME']
        println "Consolidating artifact sets named '${artifactSetName}'"
        def consolidatedArtifactSetId
        sql.eachRow("SELECT ID FROM ARTIFACT_SET WHERE NAME = ? ORDER BY ID ASC", [artifactSetName]) { artifactSetRow ->
            if (consolidatedArtifactSetId) {
                def artifactSetId = artifactSetRow['ID']
                println "Converting artifact set ${artifactSetId} to ${consolidatedArtifactSetId}"
                sql.executeUpdate("UPDATE BUILD_PROFILE_ARTIFACT_DELIVER SET ARTIFACT_SET_ID = ? WHERE ARTIFACT_SET_ID = ?",
                    [consolidatedArtifactSetId, artifactSetId])
                sql.executeUpdate("UPDATE BUILD_LIFE_DEP_PLAN_RESOLUTION SET SET_ID = ? WHERE SET_ID = ?",
                    [consolidatedArtifactSetId, artifactSetId])
                // ignoring dependency configurations, they are in XML
                sql.executeUpdate("DELETE FROM ARTIFACT_SET WHERE ID = ?", [artifactSetId])
            }
            else {
                consolidatedArtifactSetId = artifactSetRow['ID']
            }
        }
    }
}

sql.eachRow("SELECT NAME, COUNT(*) AS STATUS_COUNT FROM STATUS GROUP BY NAME") { row ->
    if (row["STATUS_COUNT"] > 1) {
        def statusName = row['NAME']
        println "Consolidating statuses named '${statusName}'"
        def consolidatedStatusId
        sql.eachRow("SELECT ID FROM STATUS WHERE NAME = ? ORDER BY ID ASC", [statusName]) { statusRow ->
            if (consolidatedStatusId) {
                def statusId = statusRow['ID']
                println "Converting status ${statusId} to ${consolidatedStatusId}"
                sql.executeUpdate("UPDATE BUILD_LIFE SET LATEST_STATUS_ID = ? WHERE LATEST_STATUS_ID = ?",
                    [consolidatedStatusId, statusId])
                sql.executeUpdate("UPDATE BUILD_LIFE_STATUS SET STATUS_ID = ? WHERE STATUS_ID = ?",
                    [consolidatedStatusId, statusId])
                sql.executeUpdate("UPDATE CODESTATION_BUILD_LIFE_STATUS SET STATUS_ID = ? WHERE STATUS_ID = ?",
                    [consolidatedStatusId, statusId])
                sql.executeUpdate("UPDATE DEPENDENCY SET STATUS_ID = ? WHERE STATUS_ID = ?",
                    [consolidatedStatusId, statusId])
                sql.executeUpdate("UPDATE JOB_CONFIG_STEP SET STATUS_ID = ? WHERE STATUS_ID = ?",
                    [consolidatedStatusId, statusId])
                sql.executeUpdate("DELETE FROM STATUS WHERE ID = ?", [statusId])
            }
            else {
                consolidatedStatusId = statusRow['ID']
            }
        }
    }
}

sql.executeUpdate("UPDATE STATUS SET LOCKED = 1 WHERE NAME IN ('Success', 'Failure', 'Archived')")

return;