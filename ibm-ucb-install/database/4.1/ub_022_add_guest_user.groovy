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

def insertUBuildUserSql =
    '''INSERT INTO UBUILD_USER(ID, NAME, SEC_USER_ID, AUTH_REALM_ID, CAN_DELETE, INACTIVE)
    VALUES(5, 'guest', '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001', 0, 0)'''
def insertSecUserSql =
    '''insert into sec_user (id, version, name, enabled, password, actual_name, email, sec_authentication_realm_id, ghosted_date)
    values ('00000000-0000-0000-0000-000000000004', 0, 'guest', 1, '', null, null, '00000000-0000-0000-0000-000000000001', 0)'''

if (sql.firstRow("SELECT * FROM UBUILD_USER WHERE NAME = 'guest'") == null) {
    println "Creating 'guest' user."
    sql.executeUpdate(insertUBuildUserSql)
    sql.executeUpdate(insertSecUserSql)
}
else {
    println "'guest' user already exists."
}