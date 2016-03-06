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

final def getStringFromClob = { data ->
    def result = null

    // data is either a String or a Clob
    if (data instanceof java.lang.String) {
        result = (String) data
    }
    else {
        result = data.getCharacterStream().text
    }

    return result
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// update

sql.eachRow("SELECT OWNER_ID, NAME, OWNER_CLASS, DATA FROM PROPERTY_TEMPLATE") { row ->
    def ownerId = row["OWNER_ID"]
    def name = row["NAME"]
    def owner = row["OWNER_CLASS"]
    def data = getStringFromClob(row["DATA"])
    
    if ("com.urbancode.ubuild.domain.project.template.ProjectTemplate".equals(owner)) {
        data = data.replace("<property class=", "<property-template class=")
        data = data.replace("</property>", "</property-template>");
    }
    else if ("com.urbancode.ubuild.domain.source.template.SourceConfigTemplate".equals(owner)) {
        data = data.replace('<property-template class="com.urbancode.ubuild.domain.property.PropertyTemplate">',
            '<property-template class="com.urbancode.ubuild.domain.source.template.SourceConfigTemplateProperty">')
    }
    
    sql.executeUpdate("UPDATE PROPERTY_TEMPLATE SET DATA=? WHERE OWNER_ID=? AND NAME=?", [data, ownerId, name])
}

return;
