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
import java.text.*;
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

//--------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------
// sql statements

def getAllSourceConfigTemplates = '''
    SELECT
        ID,
        NAME,
        SOURCE_CONFIG_ID
    FROM
        SOURCE_CONFIG_TEMPLATE
''';

def getRepoPropForSourceConfigId = '''
    SELECT
        SC.ID AS SC_ID,
        PSPV.id AS ID,
        PSPV.name AS NAME,
        PSPV.value AS VALUE
    FROM
        SOURCE_CONFIG SC
        JOIN ps_prop_value PSPV ON PSPV.prop_sheet_id = SC.PROP_SHEET_ID
    WHERE
        PSPV.name = 'repo'
        AND SC.ID = ?
''';

def getAllSourceConfigsForTemplateId = '''
    SELECT
        SC.ID AS ID,
        SC.PROP_SHEET_ID AS PROP_SHEET_ID,
        SC.TEMPLATE_ID AS TEMPLATE_ID
    FROM
        SOURCE_CONFIG SC
    WHERE
        SC.TEMPLATE_ID = ?
''';

def insertPropValue = '''
    INSERT INTO ps_prop_value (
        id,
        version,
        name,
        value,
        long_value,
        description,
        secure,
        prop_sheet_id
    ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )
''';

def deletePropValueById = '''
    DELETE FROM
        ps_prop_value
    WHERE
        id = ?
''';


//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// update
sql.eachRow(getAllSourceConfigTemplates) { row ->
    def id = row["ID"]
    def name = row["NAME"]
    def sourceConfigId = row["SOURCE_CONFIG_ID"]

    def propId;
    def propName;
    def propValue;

    sql.eachRow(getRepoPropForSourceConfigId, [String.valueOf(sourceConfigId)]) { propRow ->
        propId = propRow["ID"]
        propName = propRow["NAME"]
        propValue = propRow["VALUE"]
    }
    
    if (propId) {
        sql.eachRow(getAllSourceConfigsForTemplateId, [String.valueOf(id)]) { scRow ->
            def scId = scRow["ID"]
            def scPropSheetId = scRow["PROP_SHEET_ID"]
            
            def repoPropExists = false;
            sql.eachRow(getRepoPropForSourceConfigId, [String.valueOf(scId)]) { arbitraryRow ->
                repoPropExists = true;
            }
            
            if (!repoPropExists) {
                def newId = UUID.randomUUID().toString()
                def newVersion = 0
                def newName = propName
                def newValue = propValue
                def newLongValue = null
                def newDescription = null
                def newSecure = 0
                def newPropSheetId = scPropSheetId
                
                sql.executeUpdate(insertPropValue, [newId, newVersion, newName, newValue,
                                                    newLongValue, newDescription, newSecure, newPropSheetId])
            }
            
            // Remove old repo property regardless of whether one was created on the template
            sql.executeUpdate(deletePropValueById, propId)
        }
    }
}
