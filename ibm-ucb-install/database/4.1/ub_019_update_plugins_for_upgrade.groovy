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
def selectCommandId = "SELECT id FROM pl_plugin_command WHERE name = ?"
def updateSteps = "UPDATE JOB_CONFIG_STEP SET PLUGIN_COMMAND_ID = ? WHERE PLUGIN_COMMAND_ID = ?"
def updatePropSheets =
"""UPDATE ps_prop_sheet SET prop_sheet_def_id = (
  SELECT prop_sheet_def_id FROM pl_plugin_command WHERE id = ?
)
WHERE prop_sheet_def_id = (
  SELECT prop_sheet_def_id FROM pl_plugin_command WHERE id = ?
)"""
def deleteAllowedValues =
"""DELETE FROM ps_prop_def_allowed_value WHERE prop_def_id IN (
  SELECT id FROM ps_prop_def WHERE prop_sheet_def_id IN (
    SELECT prop_sheet_def_id FROM pl_plugin_command WHERE id = ?
  )
)"""
def deletePropDefs =
"""DELETE FROM ps_prop_def WHERE prop_sheet_def_id IN (
  SELECT prop_sheet_def_id FROM pl_plugin_command WHERE id = ?
)"""
def deleteCommand = "DELETE FROM pl_plugin_command WHERE id = ?"
def deletePropSheetDef =
"""DELETE FROM ps_prop_sheet_def WHERE id IN (
    SELECT prop_sheet_def_id FROM pl_plugin_command WHERE id = ?
)"""
//------------------------------------------------------------------------------

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

getCommandIdByName = { name ->
    def id
    sql.eachRow(selectCommandId, [name]) { row ->
        id = String.valueOf(row['id'])
    }
    return id
}

deletePluginCommand = { oldId, newId ->
    sql.executeUpdate(updateSteps, [newId, oldId])
    sql.executeUpdate(updatePropSheets, [newId, oldId])
    sql.executeUpdate(deleteAllowedValues, [oldId])
    sql.executeUpdate(deletePropDefs, [oldId])
    sql.executeUpdate(deleteCommand, [oldId])
    sql.executeUpdate(deletePropSheetDef, [oldId])

}

def oldMonitorFileContentsId = getCommandIdByName('Monitor file contents')
def newMonitorFileContentsId = getCommandIdByName('Monitor File Contents')
def oldUntarId = getCommandIdByName('Untar tarball')
def newUntarId = getCommandIdByName('Untar Tarball')

if (oldMonitorFileContentsId && newMonitorFileContentsId) {
    deletePluginCommand(oldMonitorFileContentsId, newMonitorFileContentsId)
}
if (oldUntarId && newUntarId) {
    deletePluginCommand(oldUntarId, newUntarId)
}

return;
