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

def updatePluginVersionSql = "update pl_plugin set plugin_version=? where plugin_id=?"

sql.eachRow("select name, plugin_id, plugin_version, release_version from pl_plugin") { row ->
    def id = row["plugin_id"]
    def name = row["name"]
    def pluginVersion = String.valueOf(row["plugin_version"])
    def releaseVersion = row["release_version"]
    
    if (releaseVersion != null && releaseVersion.contains(".")) {
        def newPluginVersion = releaseVersion.split("\\.")[0]
        
        // Only update rows that need to be updated
        if (pluginVersion != newPluginVersion) {
            println "Updating $name from version $pluginVersion to $newPluginVersion"
            sql.executeUpdate(updatePluginVersionSql, [newPluginVersion, id])
        }
    }
}

return