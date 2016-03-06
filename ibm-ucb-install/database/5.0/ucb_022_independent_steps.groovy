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
sql.connection.autoCommit = false;

long stepId = 0L
String insertJobStepSql =
''' INSERT INTO JOB_STEP_TRACE_TEMP (
      ID,
      VER,
      JOB_TRACE_ID, 
      STEP_SEQ,  
      NAME, 
      START_DATE, 
      END_DATE, 
      STATUS,
      IGNORE_FAILURES
    ) 
	SELECT JOB_TRACE_ID * ? + STEP_ID,
      0,
      JOB_TRACE_ID, 
      STEP_ID,  
      NAME, 
      START_DATE, 
      END_DATE, 
      STATUS,
      IGNORE_FAILURES
    FROM JOB_STEP_TRACE
'''
String insertJobStepPropsSql =
''' INSERT INTO JOB_STEP_TRACE_PROP_TEMP (
      STEP_ID,
      NAME,
      VALUE,
      SECURE
    )
    SELECT JOB_TRACE_ID * ? + STEP_ID,
      NAME,
      VALUE,
      SECURE
    FROM JOB_STEP_TRACE_PROP
'''
String insertJobStepSeqSql = '''INSERT INTO HI_LO_SEQ (SEQ_NAME, HI_VAL) VALUES ('JOB_STEP_TRACE', ?)'''

def maxRow = sql.firstRow('SELECT MAX(STEP_ID) FROM JOB_STEP_TRACE')
def maxStepSeq = (maxRow[0] ? maxRow[0] : 0) + 1

sql.executeUpdate(insertJobStepSql, [maxStepSeq])
sql.executeUpdate(insertJobStepPropsSql, [maxStepSeq])

def maxStepRow = sql.firstRow('SELECT MAX(ID) FROM JOB_STEP_TRACE_TEMP')
def maxStepId = maxStepRow[0] ? maxStepRow[0] : 1
sql.executeUpdate(insertJobStepSeqSql, maxStepId)
