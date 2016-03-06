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
// update

def projectTemplateMap = new HashMap()
def processTemplateMap = new HashMap()
def projectMap = new HashMap()
def processMap = new HashMap()
def buildLifeMap = new HashMap()
def reportMap = new HashMap()
def dateMap = new HashMap()
def timeMap = new HashMap()

createDateDimIfNeeded = { Date date ->
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd")
    def dateId = df.format(date)
    def dateDimId = dateMap.get(dateId)
    if (!dateDimId) {
        dateDimId = UUID.randomUUID().toString()
        dateMap.put(dateId, dateDimId)
        NumberFormat nf = new DecimalFormat("00");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date)
        String year = String.valueOf(calendar.get(Calendar.YEAR));
        String month = nf.format(calendar.get(Calendar.MONTH) + 1); // month is 0-based
        String dayOfMonth = nf.format(calendar.get(Calendar.DAY_OF_MONTH)); // 1-based
        String dayOfWeek = String.valueOf(calendar.get(Calendar.DAY_OF_WEEK)); // 1-based
        sql.executeUpdate("INSERT INTO DATE_DIM (ID, DATE_VAL, YEAR_NUM, MONTH, DAY_OF_WEEK, DAY_OF_MONTH) VALUES (?, ?, ?, ?, ?, ?)",
            [dateDimId, dateId, year, month, dayOfWeek, dayOfMonth])
    }
    return dateDimId
}

createTimeDimIfNeeded = { Date time ->
    DateFormat df = new SimpleDateFormat("HH:mm:ss")
    def timeId = df.format(time)
    def timeDimId = timeMap.get(timeId)
    if (!timeDimId) {
        timeDimId = UUID.randomUUID().toString()
        timeMap.put(timeId, timeDimId)
        NumberFormat nf = new DecimalFormat("00");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(time)
        String hours = nf.format(calendar.get(Calendar.HOUR_OF_DAY));
        String minutes = nf.format(calendar.get(Calendar.MINUTE));
        String seconds = nf.format(calendar.get(Calendar.SECOND));
        sql.executeUpdate("INSERT INTO TIME_DIM (ID, TIME_VAL, HOUR_OF_DAY, MINUTE_OF_HOUR, SECOND_OF_MINUTE) VALUES (?, ?, ?, ?, ?)",
            [timeDimId, timeId, hours, minutes, seconds])
    }
    return timeDimId
}

sql.eachRow("SELECT ID, NAME FROM PROJECT_TEMPLATE") { row ->
    def id = row["ID"]
    def uuid = null
    sql.eachRow("SELECT ID FROM PROJECT_TEMPLATE_DIM WHERE TEMPLATE_ID = ?", [id]) { dimRow ->
        uuid = dimRow["ID"]
    }
    if (!uuid) {
        uuid = UUID.randomUUID().toString()
        def name = row["NAME"]
        sql.executeUpdate("INSERT INTO PROJECT_TEMPLATE_DIM (ID, TEMPLATE_ID, TEMPLATE_NAME) VALUES (?, ?, ?)", [uuid, id, name])
    }
    projectTemplateMap.put(id, uuid);
}

sql.eachRow("SELECT ID, NAME, IS_ORIGINATING, PROJECT_TEMPLATE_ID FROM WORKFLOW_TEMPLATE") { row ->
    def id = row["ID"]
    def uuid = null
    sql.eachRow("SELECT ID FROM PROCESS_TEMPLATE_DIM WHERE TEMPLATE_ID = ?", [id]) { dimRow ->
        uuid = dimRow["ID"]
    }
    if (!uuid) {
        uuid = UUID.randomUUID().toString()
        def name = row["NAME"]
        def projectTemplateId = row["PROJECT_TEMPLATE_ID"]
        def originating = row["IS_ORIGINATING"] != 0 ? "Build" : "Secondary"
        def projectTemplateDimId = projectTemplateMap.get(projectTemplateId)
        sql.executeUpdate("INSERT INTO PROCESS_TEMPLATE_DIM (ID, TEMPLATE_ID, TEMPLATE_NAME, PROJECT_TEMPLATE, PROCESS_TYPE) VALUES (?, ?, ?, ?, ?)",
            [uuid, id, name, projectTemplateDimId, originating])
    }
    processTemplateMap.put(id, uuid);
}

sql.eachRow("SELECT ID, NAME, PROJECT_TEMPLATE_ID FROM PROJECT") { row ->
    def id = row["ID"]
    def uuid = null
    sql.eachRow("SELECT ID FROM PROJECT_DIM WHERE PROJECT_ID = ?", [id]) { dimRow ->
        uuid = dimRow["ID"]
    }
    if (!uuid) {
        uuid = UUID.randomUUID().toString()
        def name = row["NAME"]
        def projectTemplateId = row["PROJECT_TEMPLATE_ID"]
        def projectTemplateDimId = projectTemplateMap.get(projectTemplateId)
        sql.executeUpdate("INSERT INTO PROJECT_DIM (ID, PROJECT_ID, PROJECT_NAME, PROJECT_TEMPLATE) VALUES (?, ?, ?, ?)",
            [uuid, id, name, projectTemplateDimId])
    }
    projectMap.put(id, uuid);
}

sql.eachRow("SELECT ID, NAME, PROJECT_ID, WORKFLOW_TEMPLATE_ID FROM WORKFLOW") { row ->
    def id = String.valueOf(row["ID"])
    def uuid = null
    sql.eachRow("SELECT ID FROM PROCESS_DIM WHERE PROCESS_ID = ?", [id]) { dimRow ->
        uuid = dimRow["ID"]
    }
    if (!uuid) {
        uuid = UUID.randomUUID().toString()
        def name = row["NAME"]
        def projectId = row["PROJECT_ID"]
        def processTemplateId = row["WORKFLOW_TEMPLATE_ID"]
        def projectDimId = projectMap.get(projectId)
        def processTemplateDimId = processTemplateMap.get(processTemplateId)
        sql.executeUpdate("INSERT INTO PROCESS_DIM (ID, PROCESS_ID, PROCESS_NAME, PROJECT, PROCESS_TEMPLATE) VALUES (?, ?, ?, ?, ?)",
            [uuid, id, name, projectDimId, processTemplateDimId])
    }
    processMap.put(id, uuid);
}

def reportSql = "SELECT SAR.ID, SAR.NAME, BL.ID AS BUILD_LIFE_ID, SAR.TYPE, SAR.URL_LINK, BL.START_DATE AS REPORT_DATE " +
    "FROM SOURCE_ANALYTICS_REPORT SAR " +
    "JOIN BUILD_LIFE BL ON BL.ID = SAR.BUILD_LIFE_ID"
def buildLifeSql = "SELECT BP.WORKFLOW_ID, BL.START_DATE FROM BUILD_LIFE BL " +
    "JOIN BUILD_PROFILE BP ON BP.ID = BL.PROFILE_ID " +
    "WHERE BL.ID = ?"

sql.eachRow(reportSql) { row ->
    def id = row["ID"]
    def name = row["NAME"]
    def buildLifeId = row["BUILD_LIFE_ID"]
    def type = row["TYPE"]
    def urlLink = row["URL_LINK"]
    def reportDate = row["REPORT_DATE"]
    def reportDimId = UUID.randomUUID().toString()
    reportMap.put(id, reportDimId)
    
    def buildLifeDimId = buildLifeMap.get(buildLifeId);
    if (buildLifeDimId == null) {
        sql.eachRow(buildLifeSql, [buildLifeId]) { buildLifeRow ->
            buildLifeDimId = UUID.randomUUID().toString()
            buildLifeMap.put(buildLifeId, buildLifeDimId)
            def processId = String.valueOf(buildLifeRow["WORKFLOW_ID"])
            def startDate = buildLifeRow["START_DATE"]
            def processDimId = processMap.get(processId)
            def dateDimId = createDateDimIfNeeded(startDate)
            def timeDimId = createTimeDimIfNeeded(startDate)
            
            sql.executeUpdate("INSERT INTO BUILD_LIFE_DIM (ID, BUILD_LIFE_ID, BUILD_PROCESS, CREATE_DATE, CREATE_TIME) VALUES (?, ?, ?, ?, ?)",
                [buildLifeDimId, buildLifeId, processDimId, dateDimId, timeDimId])
        }
    }
    
    def reportName = buildLifeId + "." + name
    def reportDateDimId = createDateDimIfNeeded(reportDate)
    def reportTimeDimId = createTimeDimIfNeeded(reportDate)
    sql.executeUpdate("INSERT INTO SOURCE_ANALYTIC_REPORT_DIM (ID, REPORT_ID, REPORT_NAME, BUILD_LIFE, TYPE, URL_LINK, " +
        "REPORT_DATE, REPORT_TIME) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        [reportDimId, reportName, name, buildLifeDimId, type, urlLink, reportDateDimId, reportTimeDimId])
}

def findingSql = "SELECT SAF.ID, SAF.REPORT_ID, SAF.NAME, SAF.FILE_NAME, SAF.LINE_NUMBER, SAF.STATUS, SAF.SEVERITY, SAF.DESCRIPTION " +
    "FROM SOURCE_ANALYTICS_FINDING SAF " +
    "JOIN SOURCE_ANALYTICS_REPORT SAR ON SAR.ID = SAF.REPORT_ID"

sql.eachRow(findingSql) { row ->
    def reportId = row["REPORT_ID"]
    def findingId = row["ID"] ?: null
    def name = row["NAME"]
    def fileName = row["FILE_NAME"]
    def lineNumber = row["LINE_NUMBER"] ?: null
    def status = row["STATUS"]
    def severity = row["SEVERITY"]
    def description = row["DESCRIPTION"] ?: null
    def reportDimId = reportMap.get(reportId)
    
    sql.executeUpdate("INSERT INTO SOURCE_ANALYTIC (REPORT, FINDING_ID, NAME, FILE_NAME, LINE_NUMBER, STATUS, SEVERITY, DESCRIPTION) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        [reportDimId, findingId, name, fileName, lineNumber, status, severity, description])
}

return;
