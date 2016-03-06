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
sql.connection.autoCommit = false;

String insertSecAuthTokenSql = "INSERT INTO sec_auth_token(id, version, sec_user_id, token, expiration, description, os_user)"+
    " VALUES(?, 0, ?, ?, ?, ?, ?)"
String getOldTokenSql = "SELECT UU.SEC_USER_ID, TOK.TOKEN, TOK.EXPIRATION,"+
    " TOK.DESCRIPTION, UU.NAME FROM AUTH_TOKEN TOK INNER JOIN  UBUILD_USER UU ON TOK.USER_ID = UU.ID "

sql.eachRow(getOldTokenSql) { row ->
    String tokenId = UUID.randomUUID()
    String secUserId = row['SEC_USER_ID']
    String token = row['TOKEN']
    def    expiration = row['EXPIRATION']
    String desc = row['DESCRIPTION']
    String name = row['NAME']

    sql.executeUpdate(insertSecAuthTokenSql, [tokenId, secUserId, token, expiration, desc, name])
    println "Migrating token ${token}"
}
