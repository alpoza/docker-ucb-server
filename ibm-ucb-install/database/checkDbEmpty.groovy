#!/usr/bin/env groovy
/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*
 * Check if the database has any tables defined. If so, throw an exception containing the list of tables found.
 * 
 * @param  connString the database connection string
 * @param  username the database connection username
 * @param  password the databse connection password
 * @param  driver the database connection driver (the driver class must be on the current classpath)
 * @param  schema (Optional) the database schema
 * @param  driverClassPath (Optional) a classpath string which contains the driver class - this is loaded into the current classpath
 * @throws if any non-system tables are found
 */
import groovy.sql.Sql

//
// Parse Arguments
//
def connString, username, password, driver, schema

for (int i=0; i<args.length; i++) {
    def argKey = args[i];
    def argValue = args[++i];
    
    if ('-c' == argKey) {
        connString = argValue
    }
    else if ('-u' == argKey) {
        username = argValue
    }
    else if ('-p' == argKey) {
        password = argValue
    }
    else if ('-d' == argKey) {
        driver = argValue
    }
    else if ('-s' == argKey) {
        schema = argValue
    }
    else if ('-cp' == argKey) {
        this.class.classLoader.rootLoader.addClassPath(argValue)
    }
}

//
// Connect to DB and get table listing
//

final def catalog = null
final def showTablesOfTypes = ['TABLE'] as String[] // Valid types are ["TABLE", "VIEW", "SYSTEM TABLE", "GLOBAL TEMPORARY", "LOCAL TEMPORARY", "ALIAS", "SYNONYM"]

def sql = Sql.newInstance(connString, username, password, driver)
def conn = sql.connection

def resultSet = conn.metaData.getTables(catalog, schema, "%", showTablesOfTypes);
def tables = []
while (resultSet.next()){
    tables << resultSet.getString('TABLE_NAME') 
}

if (tables) {
    throw new Exception("Please use an empty database. The following tables were found in the target database: ${tables.sort()}")
}