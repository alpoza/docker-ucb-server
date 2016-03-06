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

// -----------------------INSERTS-------------------------------
def getRepositoriesSql = '''
    SELECT
        R.ID AS ID,
        R.NAME AS NAME,
        P.name AS TYPE
    FROM
        REPOSITORY R
        JOIN pl_plugin P ON P.id = R.PLUGIN_ID
''';

def getRepositoryUsersSql = '''
    SELECT
        ID,
        NAME,
        REPO_ID
    FROM
        REPOSITORY_USER
''';

def getSourceConfigsSql = '''
    SELECT
        SC.ID AS ID,
        SC.NAME AS NAME,
        R.ID AS REPOSITORY_ID
    FROM
        SOURCE_CONFIG SC
        JOIN ps_prop_value PSPV ON PSPV.prop_sheet_id = SC.PROP_SHEET_ID
        JOIN REPOSITORY R ON R.PROP_SHEET_ID = PSPV.value
    WHERE
        PSPV.name = 'repo'
''';

def getChangeSetSql = '''
    SELECT
        RCS.ID AS ID,
        RCS.REPO_USER_ID AS REPO_USER_ID,
        RCS.CHANGE_ID AS CHANGE_ID,
        RCS.CHANGE_DATE AS CHANGE_DATE,
        RCS.CHANGE_COMMENT AS CHANGE_COMMENT,
        RCS.FILES_ADDED AS FILES_ADDED,
        RCS.FILES_CHANGED AS FILES_CHANGED,
        RCS.FILES_MOVED AS FILES_MOVED,
        RCS.FILES_REMOVED AS FILES_REMOVED,
        RCS.MODULE AS MODULE,
        RCS.BRANCH AS BRANCH,
        SC.ID AS SOURCE_CONFIG_ID
    FROM
        REPOSITORY_CHANGE_SET RCS
        JOIN BUILD_LIFE_CHANGE_SET BLCS ON BLCS.CHANGE_SET_ID = RCS.ID
        JOIN BUILD_LIFE BL ON BL.ID = BLCS.BUILD_LIFE_ID
        JOIN SOURCE_CONFIG SC ON SC.BUILD_PROFILE_ID = BL.PROFILE_ID
''';

def getChangeSetPropertiesSql = '''
    SELECT
        CHANGE_SET_ID,
        PROP_NAME,
        VALUE,
        LONG_VALUE
    FROM
        REPOSITORY_CHANGE_SET_PROPERTY
''';

def getChangesSql = '''
    SELECT
        CHANGE_SET_ID,
        CHANGE_PATH,
        CHANGE_TYPE,
        LINES_ADDED,
        LINES_REMOVED,
        REVISION_NUMBER
    FROM
        REPOSITORY_CHANGE
''';

def getSourceChangesSql = '''
    SELECT
        BUILD_LIFE_ID,
        CHANGE_SET_ID
    FROM
        BUILD_LIFE_CHANGE_SET
''';

def getBuildLivesSql = '''
    SELECT
        BP.WORKFLOW_ID,
        BL.START_DATE
    FROM
        BUILD_LIFE BL
        JOIN BUILD_PROFILE BP ON BP.ID = BL.PROFILE_ID
    WHERE
        BL.ID = ?
''';

def getCurrentDateDims = '''
    SELECT
        ID,
        DATE_VAL
    FROM
        DATE_DIM
''';

def getCurrentTimeDims = '''
    SELECT
        ID,
        TIME_VAL
    FROM
        TIME_DIM
''';

def getCurrentBuildLifeDims = '''
    SELECT
        ID,
        BUILD_LIFE_ID
    FROM
        BUILD_LIFE_DIM
''';

def getIssueTrackersSql = '''
    SELECT
        ID,
        NAME
    FROM
        ISSUE_TRACKER
''';

def getIssuesSql = '''
    SELECT
        ID,
        ISSUE_TRACKER_ID,
        ISSUE_ID,
        NAME,
        TYPE,
        STATUS,
        DESCRIPTION,
        LAST_DATE,
        ISSUE_URL
    FROM
        ISSUE
''';

def getChangeSetIssueSql = '''
    SELECT
        ISSUE_ID,
        CHANGE_SET_ID
    FROM
        CHANGE_SET_ISSUE
''';

// -----------------------INSERTS-------------------------------
def insertRepositoryDimSql = '''
    INSERT INTO REPOSITORY_DIM (
        ID,
        REPO_ID,
        REPO_NAME,
        REPO_TYPE
    ) VALUES ( ?, ?, ?, ? )
''';

def insertRepositoryUserDimSql = '''
    INSERT INTO REPO_USER_DIM (
        ID,
        REPO_USER_ID,
        REPO_USER_NAME,
        REPOSITORY
    ) VALUES ( ?, ?, ?, ? )
''';

def insertSourceConfigDimSql = '''
    INSERT INTO SOURCE_CONFIG_DIM (
        ID,
        SOURCE_CONFIG_ID,
        SOURCE_CONFIG_NAME,
        REPOSITORY
    ) VALUES ( ?, ?, ?, ? )
''';

def insertChangeSetDimSql = '''
    INSERT INTO CHANGE_SET_DIM (
        ID,
        SOURCE_CONFIG,
        CHANGE_COMMENT,
        REPO_USER,
        CHANGE_DATE,
        CHANGE_TIME,
        CHANGE_MODULE,
        CHANGE_BRANCH,
        CHANGED_FILES,
        CHANGE_SET_ID,
        SCM_ID
    ) VALUES ( ?, ?, ?,
               ?, ?, ?,
               ?, ?, ?,
               ?, ?   )
''';

def insertChangeSetPropertyFactSql = '''
    INSERT INTO CHANGE_SET_PROPERTY (
        PROP_NAME,
        PROP_VALUE,
        CHANGE_SET
    ) VALUES ( ?, ?, ? )
''';

def insertChangeFactSql = '''
    INSERT INTO FILE_CHANGE (
        CHANGE_TYPE,
        CHANGE_SET,
        CHANGE_PATH,
        REVISION_NUMBER
    ) VALUES ( ?, ?, ?, ? )
''';

def insertSourceChangeFactSql = '''
    INSERT INTO SOURCE_CHANGE (
        CHANGE_SET,
        BUILD_LIFE
    ) VALUES ( ?, ? )
''';

def insertIssueTrackerDim = '''
    INSERT INTO ISSUE_TRACKER_DIM (
        ID,
        NAME
    ) VALUES ( ?, ? )
''';

def insertIssueDim = '''
    INSERT INTO ISSUE_DIM (
        ID,
        ISSUE_ID,
        DESCRIPTION,
        URL,
        LAST_DATE,
        LAST_TIME,
        ISSUE_TRACKER,
        NAME,
        TYPE,
        STATUS
    ) VALUES ( ?, ?, ?, ?, ?,
               ?, ?, ?, ?, ? )
''';

def insertChangeSetIssueFact = '''
    INSERT INTO CHANGE_SET_ISSUE_FACT (
        CHANGE_SET,
        ISSUE
    ) VALUES ( ?, ? )
''';

//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// update

def repositoryMap = new HashMap()
def repositoryUserMap = new HashMap()
def sourceConfigMap = new HashMap()
def changeSetMap = new HashMap()
def changeSetPropertyMap = new HashMap()
def changeMap = new HashMap()
def sourceChangeMap = new HashMap()
def buildLifeMap = new HashMap()
def issueTrackerMap = new HashMap()
def issueMap = new HashMap()

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

// Populate previously existing dimensions
sql.eachRow(getCurrentDateDims) { row ->
    def dateDimId = String.valueOf(row["ID"])
    def dateId    = String.valueOf(row["DATE_VAL"])

    dateMap.put(dateId, dateDimId)
}

sql.eachRow(getCurrentTimeDims) { row ->
    def timeDimId = String.valueOf(row["ID"])
    def timeId    = String.valueOf(row["TIME_VAL"])

    timeMap.put(timeId, timeDimId)
}

sql.eachRow(getCurrentBuildLifeDims) { row ->
    def buildLifeDimId = String.valueOf(row["ID"])
    def buildLifeId    = String.valueOf(row["BUILD_LIFE_ID"])

    buildLifeMap.put(buildLifeId, buildLifeDimId)
}



sql.eachRow(getRepositoriesSql) { row ->
    def id   = String.valueOf(row["ID"])
    def name = row["NAME"]
    def type = row["TYPE"]

    def uuid = UUID.randomUUID().toString()
    repositoryMap.put(id, uuid)

    sql.executeUpdate(insertRepositoryDimSql, [uuid, id, name, type])
}

sql.eachRow(getRepositoryUsersSql) { row ->
    def id     = String.valueOf(row["ID"])
    def name   = row["NAME"]
    def repoId = String.valueOf(row["REPO_ID"])

    def uuid = UUID.randomUUID().toString()
    repositoryUserMap.put(id, uuid)
    def repository = repositoryMap.get(repoId)

    sql.executeUpdate(insertRepositoryUserDimSql, [uuid, id, name, repository])
}

sql.eachRow(getSourceConfigsSql) { row ->
    def id     = String.valueOf(row["ID"])
    def name   = row["NAME"]
    def repoId = String.valueOf(row["REPOSITORY_ID"])

    def uuid = UUID.randomUUID().toString()
    sourceConfigMap.put(id, uuid)
    def repository = repositoryMap.get(repoId)

    sql.executeUpdate(insertSourceConfigDimSql, [uuid, id, name, repository])
}

sql.eachRow(getChangeSetSql) { row ->
    def id             = String.valueOf(row["ID"])
    def repoUserId     = String.valueOf(row["REPO_USER_ID"])
    def changeId       = String.valueOf(row["CHANGE_ID"])
    def changeDate     = row["CHANGE_DATE"]
    def changeComment  = row["CHANGE_COMMENT"]
    def filesAdded     = row["FILES_ADDED"]
    def filesChanged   = row["FILES_CHANGED"]
    def filesMoved     = row["FILES_MOVED"]
    def filesRemoved   = row["FILES_REMOVED"]
    def module         = row["MODULE"]
    def branch         = row["BRANCH"]
    def sourceConfigId = String.valueOf(row["SOURCE_CONFIG_ID"]);

    def changeSetId = sourceConfigId + "." + changeId
    def scmId = changeId;
    def filesModified = String.valueOf(filesAdded + filesChanged + filesMoved + filesRemoved)
    def dateDimId = createDateDimIfNeeded(changeDate);
    def timeDimId = createTimeDimIfNeeded(changeDate);


    def uuid = UUID.randomUUID().toString()
    changeSetMap.put(id, uuid)
    
    def repoUser = repositoryUserMap.get(repoUserId)
    def sourceConfig = sourceConfigMap.get(sourceConfigId)

    sql.executeUpdate(insertChangeSetDimSql, [uuid,        sourceConfig, changeComment,
                                              repoUser,    dateDimId,    timeDimId,
                                              module,      branch,       filesModified,
                                              changeSetId, scmId                       ] )
}

sql.eachRow(getChangeSetPropertiesSql) { row ->
    def changeSetId = String.valueOf(row["CHANGE_SET_ID"])
    def propName    = row["PROP_NAME"]
    def value       = row["VALUE"]
    def longValue   = row["LONG_VALUE"]

    def propValue = value ?: String.valueOf(longValue)
    def changeSet = changeSetMap.get(changeSetId)

    if (changeSet) {
        sql.executeUpdate(insertChangeSetPropertyFactSql, [propName, propValue, changeSet] )
    }
    else {
        println "Did not find change set ${changeSetId}"
    }
}

sql.eachRow(getChangesSql) { row ->
    def changeSetId    = String.valueOf(row["CHANGE_SET_ID"])
    def changePath     = row["CHANGE_PATH"]
    def changeType     = row["CHANGE_TYPE"]
    def revisionNumber = row["REVISION_NUMBER"]

    def changeSet = changeSetMap.get(changeSetId)
    
    if (changeSet) {
        sql.executeUpdate(insertChangeFactSql, [changeType, changeSet, changePath, revisionNumber] )
    }
    else {
        println "Did not find change set ${changeSetId}"
    }
}

sql.eachRow(getSourceChangesSql) { row ->
    def buildLifeId = String.valueOf(row["BUILD_LIFE_ID"])
    def changeSetId = String.valueOf(row["CHANGE_SET_ID"])

    def buildLifeDimId = buildLifeMap.get(buildLifeId);
    if (buildLifeDimId == null) {
        sql.eachRow(getBuildLivesSql) { buildLifeRow ->
            buildLifeDimId = UUID.randomUUID().toString()
            buildLifeMap.put(buildLifeId, buildLifeDimId)
            def processId = buildLifeRow["WORKFLOW_ID"]
            def startDate = buildLifeRow["START_DATE"]
            def processDimId = processMap.get(processId);
            def dateDimId = createDateDimIfNeeded(startDate)
            def timeDimId = createTimeDimIfNeeded(startDate)
            sql.executeUpdate("INSERT INTO BUILD_LIFE_DIM (ID, BUILD_LIFE_ID, BUILD_PROCESS, CREATE_DATE, CREATE_TIME) VALUES (?, ?, ?, ?, ?)",
                [buildLifeDimId, buildLifeId, processDimId, dateDimId, timeDimId])
        }
    }

    def changeSetDimId = changeSetMap.get(changeSetId);

    if (changeSetDimId) {
        sql.executeUpdate(insertSourceChangeFactSql, [changeSetDimId, buildLifeDimId] )
    }
    else {
        println "Did not find change set ${changeSetId}"
    }
}

sql.eachRow(getIssueTrackersSql) { row ->
    def id   = String.valueOf(row["ID"])
    def name = row["NAME"]

    def uuid = UUID.randomUUID().toString()
    issueTrackerMap.put(id, uuid)
    sql.executeUpdate(insertIssueTrackerDim, [uuid, name] )
}

sql.eachRow(getIssuesSql) { row ->
    def id             = String.valueOf(row["ID"])
    def issueTrackerId = String.valueOf(row["ISSUE_TRACKER_ID"])
    def issueId        = String.valueOf(row["ISSUE_ID"])
    def name           = row["NAME"]
    def type           = row["TYPE"]
    def status         = row["STATUS"]
    def description    = row["DESCRIPTION"]
    def lastDate       = row["LAST_DATE"]
    def issueUrl       = row["ISSUE_URL"]

    def uuid = UUID.randomUUID().toString()
    issueMap.put(id, uuid)

    def issueTracker = issueTrackerMap.get(issueTrackerId)
    def dateDim      = createDateDimIfNeeded(lastDate)
    def timeDim      = createTimeDimIfNeeded(lastDate)

    sql.executeUpdate(insertIssueDim, [uuid, issueId, description, issueUrl, dateDim,
                                       timeDim, issueTracker, name, type, status] )
}

sql.eachRow(getChangeSetIssueSql) { row ->
    def issueId     = String.valueOf(row["ISSUE_ID"])
    def changeSetId = String.valueOf(row["CHANGE_SET_ID"])

    def issue = issueMap.get(issueId)
    def changeSet = changeSetMap.get(changeSetId)

    if (issue && changeSet) {
        sql.executeUpdate(insertChangeSetIssueFact, [changeSet, issue])
    }
    else {
        println "Could not tie issue ${issueId} to change ${changeSetId}"
    }
}
