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
args        command line arguments, if any
*/

Sql sql = null
def verbose = false
def manageConn = false
Hashtable properties = (Hashtable) getBindingVar("ANT_PROPERTIES");
Connection connection = (Connection) getBindingVar("CONN");
String url = (String) getBindingVar("URL");

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
    println("!!" + message);
}

final def warn = { message ->
    println(message);
}

final def debug = { message ->
//    if (verbose) {
        println(message);
//    }
}

if (properties && connection) {
    println "Using connection from binding...${connection}"
    verbose = Boolean.valueOf(properties.get('verbose')).booleanValue()
    sql = new Sql(connection)
}
else {
    println "Using command line arguments..."
    final String driver = args[0]
    url = args[1]
    final String usr = args[2]
    final String pwd = args[3]
    sql = Sql.newInstance(url, usr, pwd, driver);
    manageConn = true
}

try {
    String collation
    String dbName = url.find(~/DatabaseName=([^;]*)/){match, db -> return db}
    if (dbName == null || dbName.trim() == "") {
        dbName = url.find(~/Database=([^;]*)/){match, db -> return db}
    }
    
    String collationQuery = "SELECT CONVERT(VARCHAR(100), DATABASEPROPERTYEX('${dbName}', 'Collation'))"
    
    sql.eachRow(collationQuery) { value ->
        collation = value
    }
    
    println "SQL Server Collation is ${collation}"
    
    String collationTest = collation.find(~/_CI_/){match -> return match}
    if (collationTest != null && collationTest.trim() != "") {
        throw new Exception("Collation is case-insensitive. IBM UrbanCode Build requires case-sensitive collation for SQL Server.")
    }
}
finally {
    if (manageConn) {
        sql.close()
    }
}