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
// find all jobs with out of order sequences
String allJobStepsSql = "SELECT * FROM JOB_CONFIG_STEP ORDER BY JOB_CONFIG_ID, SEQ ASC"
def lastId
def expectedSeq = 0
def jobIdsToUpdate = new HashSet()
sql.eachRow(allJobStepsSql) { row ->
    def id = row['JOB_CONFIG_ID']
    def seq = row['SEQ']
    if (!id.equals(lastId)) {
        expectedSeq = 0
        lastId = id
    }
    if (seq != expectedSeq) {
        println "Found job step out of sequence: job ${id}, step ${seq} should be ${expectedSeq}"
        jobIdsToUpdate.add(id)
    }
    expectedSeq++
}

String jobStepsByIdSql = "SELECT * FROM JOB_CONFIG_STEP WHERE JOB_CONFIG_ID = ? ORDER BY SEQ ASC"
String updateStepSeqSql = "UPDATE JOB_CONFIG_STEP SET SEQ = ? WHERE JOB_CONFIG_ID = ? AND SEQ = ? AND NAME = ? AND VERSION = ?"
jobIdsToUpdate.each { jobId ->
        println "Updating job step sequences on job ${jobId}"
    def newSeq = 0
    sql.eachRow(jobStepsByIdSql, [jobId]) { row ->
        def seq = row['SEQ']
        def name = row['NAME']
        def version = row['VERSION']
        sql.executeUpdate(updateStepSeqSql, [newSeq, jobId, seq, name, version])
        newSeq++
    }
}