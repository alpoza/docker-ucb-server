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

import com.urbancode.ubuild.domain.workflow.WorkflowStatusEnum;

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
def userMap = new HashMap()
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

def buildLifeSql = "SELECT BP.WORKFLOW_ID, BL.START_DATE FROM BUILD_LIFE BL " +
    "JOIN BUILD_PROFILE BP ON BP.ID = BL.PROFILE_ID " +
    "WHERE BL.ID = ?"
def userSql = "SELECT U.NAME, U.SEC_USER_ID, U.ACTUAL_NAME, U.EMAIL, U.IM_ID, U.AUTH_REALM_ID, AR.name AS REALM_NAME " +
    "FROM UBUILD_USER U JOIN sec_authentication_realm AR ON AR.id = U.AUTH_REALM_ID WHERE U.ID = ?"
def userInsertSql = "INSERT INTO USER_DIM (ID, USER_ID, USER_NAME, ACTUAL_NAME, EMAIL, IM, AUTH_REALM_ID, AUTH_REALM_NAME) " +
    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
def processSql = "SELECT P.PROCESS_ID, T.PROCESS_TYPE FROM PROCESS_DIM P " +
    "JOIN PROCESS_TEMPLATE_DIM T ON T.ID = P.PROCESS_TEMPLATE ORDER BY P.PROCESS_ID ASC"
def processExecutionSql = "SELECT WC.ID, WC.WORKFLOW_ID, WC.BUILD_LIFE_ID, WC.START_DATE, WC.END_DATE, WC.STATUS, " +
    "BR.START_DATE AS REQUEST_DATE, BR.USER_ID, BR.REQUESTER_TYPE " +
    "FROM WORKFLOW_CASE WC JOIN BUILD_REQUEST BR ON BR.ID = WC.REQUEST_ID " +
    "WHERE WC.WORKFLOW_ID = ? AND WC.END_DATE IS NOT NULL AND BR.PREFLIGHT = 0 ORDER BY WC.ID ASC"
def processExecInsertSql = "INSERT INTO PROCESS_EXECUTION " +
    "(PROCESS_ID, PROCESS, BUILD_LIFE, REQUEST_DATE, REQUEST_TIME, START_DATE, START_TIME, END_DATE, END_TIME, " +
    "REQUEST_USER, REQUEST_SOURCE, DURATION, RESULT, RELATIVE_RESULT) " +
    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

sql.eachRow(processSql) { processRow ->
    def processId = String.valueOf(processRow["PROCESS_ID"])
    def processType = processRow["PROCESS_TYPE"]
    def lastStatus = null
    sql.eachRow(processExecutionSql, [processId]) { row ->
        def id = row["ID"]
        def buildLifeId = row["BUILD_LIFE_ID"]
        def requestDate = row["REQUEST_DATE"]
        def startDate = row["START_DATE"]
        def endDate = row["END_DATE"]
        def status = row["STATUS"]
        def userId = row["USER_ID"]
        def requestSource = row["REQUESTER_TYPE"]
        def processExecId = UUID.randomUUID().toString()
        
        def processDimId = processMap.get(processId)
        def buildLifeDimId = buildLifeMap.get(buildLifeId)
        if (buildLifeDimId == null) {
            sql.eachRow(buildLifeSql, [buildLifeId]) { buildLifeRow ->
                buildLifeDimId = UUID.randomUUID().toString()
                buildLifeMap.put(buildLifeId, buildLifeDimId)
                def buildLifeProcessId = String.valueOf(buildLifeRow["WORKFLOW_ID"])
                def buildLifeDate = buildLifeRow["START_DATE"]
                def buildLifeProcessDimId = processMap.get(buildLifeProcessId);
                def dateDimId = createDateDimIfNeeded(buildLifeDate)
                def timeDimId = createTimeDimIfNeeded(buildLifeDate)
                sql.executeUpdate("INSERT INTO BUILD_LIFE_DIM (ID, BUILD_LIFE_ID, BUILD_PROCESS, CREATE_DATE, CREATE_TIME) VALUES (?, ?, ?, ?, ?)",
                    [buildLifeDimId, buildLifeId, buildLifeProcessDimId, dateDimId, timeDimId])
            }
        }
        
        def userDimId = userMap.get(userId)
        if (userDimId == null) {
            sql.eachRow(userSql, [userId]) { userRow ->
                userDimId = UUID.randomUUID().toString()
                userMap.put(userId, userDimId)
                def userUUID = userRow["SEC_USER_ID"]
                def userName = userRow["NAME"]
                def actualName = userRow["ACTUAL_NAME"]
                def email = userRow["EMAIL"]
                def imId = userRow["IM_ID"]
                def realmId = userRow["AUTH_REALM_ID"]
                def realmName = userRow["REALM_NAME"]
                sql.executeUpdate(userInsertSql, [userDimId, userUUID, userName, actualName, email, imId, realmId, realmName])
            }
        }
        
        def relativeResult = null
        if ("Build".equals(processType) && lastStatus) {
            if ("Complete".equalsIgnoreCase(lastStatus) ||
                "Complete (Warning)".equalsIgnoreCase(lastStatus)) {
                if ("Complete".equalsIgnoreCase(status) ||
                    "Complete (Warning)".equalsIgnoreCase(status)) {
                    relativeResult = "Continued Success"
                }
                else {
                    relativeResult = "New Failure"
                }
            }
            else if ("Complete".equalsIgnoreCase(status) ||
                "Complete (Warning)".equalsIgnoreCase(status)) {
                relativeResult = "New Success"
            }
            else {
                relativeResult = "Continued Failure"
            }
        }

        def requestDateDimId = createDateDimIfNeeded(requestDate)
        def requestTimeDimId = createTimeDimIfNeeded(requestDate)
        def startDateDimId = createDateDimIfNeeded(startDate)
        def startTimeDimId = createTimeDimIfNeeded(startDate)
        def endDateDimId = createDateDimIfNeeded(endDate)
        def endTimeDimId = createTimeDimIfNeeded(endDate)
        def duration = endDate.time - startDate.time
        sql.executeUpdate(processExecInsertSql,
            [id, processDimId, buildLifeDimId, requestDateDimId, requestTimeDimId, startDateDimId, startTimeDimId,
             endDateDimId, endTimeDimId, userDimId, requestSource, duration, status, relativeResult])
        lastStatus = status
    }
}

return;
