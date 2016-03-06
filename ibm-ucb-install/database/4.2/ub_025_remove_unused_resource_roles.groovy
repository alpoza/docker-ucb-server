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

String srrtIdSelectorSql = "SELECT sec_resource_role_id FROM sec_resource_for_team WHERE sec_resource_role_id IS NOT NULL"
String sraIdSelectorSql = "SELECT sec_resource_role_id FROM sec_role_action WHERE sec_resource_role_id IS NOT NULL"
String deleteFromSRRTASql = "DELETE FROM sec_resource_role_to_action WHERE sec_resource_role_id NOT IN (${srrtIdSelectorSql}) AND sec_resource_role_id NOT IN (${sraIdSelectorSql})"
String deleteFromSRRSql = "DELETE FROM sec_resource_role WHERE id NOT IN (${srrtIdSelectorSql}) AND id NOT IN (${sraIdSelectorSql})"

sql.executeUpdate(deleteFromSRRTASql);
sql.executeUpdate(deleteFromSRRSql);