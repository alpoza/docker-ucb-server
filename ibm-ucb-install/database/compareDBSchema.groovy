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
 * Compare the schema found in the target database to that of the given DDL file(s).  If they are not equivalent,
 * then throw an exception with the details of the mismatch
 *
 * @param  ddl file path
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
def ddlFile, connString, username, password, driver, schema

for (int i=0; i<args.length; i++) {
    def argKey = args[i];
    def argValue = args[++i];

    if ('-f' == argKey) {
        ddlFile = argValue
    }
    else if ('-c' == argKey) {
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

final def actualSchema   = [:]
final def expectedSchema = [:]

//
// Connect to DB and get Active Schema
//

final def catalog = null
final def showTablesOfTypes = ['TABLE'] as String[] // Valid types are ["TABLE", "VIEW", "SYSTEM TABLE", "GLOBAL TEMPORARY", "LOCAL TEMPORARY", "ALIAS", "SYNONYM"]

def sql = Sql.newInstance(connString, username, password, driver)
def conn = sql.connection

def tables = []
def resultSet = conn.metaData.getTables(catalog, schema, "%", showTablesOfTypes);
while (resultSet.next()) {
    tables << resultSet.getString('TABLE_NAME')
}

// exclude tables prefixed with "MODULE_"
tables = tables.findAll{!(it ==~ /^(?i)(module|wf)_.*/)}


tables.each{ tableName ->
    actualSchema[tableName.toUpperCase()] = new LinkedHashSet<String>()
    def colResults = conn.metaData.getColumns(catalog, schema, tableName, "%")
    while (colResults.next()) {
        actualSchema[tableName.toUpperCase()] << colResults.getString('COLUMN_NAME').toUpperCase()
    }
}

//
// Get Expected Schema
//

// compare the schema in a database to the schema in our *.ddl file
def ddl = new File(ddlFile).text.replaceAll('(?m)--.*$', '') // script comments

def  createTableMatcher = (ddl =~ /(?is)CREATE TABLE\s+(\w+)\s*(\s*[^;]*;)/)
while (createTableMatcher.find()) {
    def tableName =  createTableMatcher.group(1)
    def columnDeclarations =  createTableMatcher.group(2)
    def columnNames = columnDeclarations.findAll(/\b(\w+)\s+[^,;]*[,;]/, {it[1]})
    columnNames.removeAll(['PRIMARY', 'CONSTRAINT'])
    expectedSchema[tableName] = new LinkedHashSet<String>(columnNames)
}

//
// Assert expectedSchema == actualSchema
//

// check table names
def actualTableNames = actualSchema.keySet()
def expectedTableNames = expectedSchema.keySet()
println "Unexpected Tables: ${actualTableNames - expectedTableNames}"
println "Missing Tables: ${expectedTableNames - actualTableNames}"
assert expectedTableNames == actualTableNames

// check column names for each table
for (def entry in expectedSchema) {
    def expectedColumns = new LinkedHashSet(entry.value.collect{it.toUpperCase()}.sort())
    def actualColumns = new LinkedHashSet(actualSchema[entry.key.toUpperCase()].collect{it.toUpperCase()}.sort())
    if (expectedColumns != actualColumns) {
        println "Unexpected columns: ${actualColumns - expectedColumns}"
        println "Missing columns: ${expectedColumns - actualColumns}"
        assert expectedColumns == actualColumns : "Table $entry.key "
    }
}

// final test (keyset matched and entries all matched, so this should pass) this produces messy output
assert expectedSchema == actualSchema

println 'DB Schema matched the expected format'
