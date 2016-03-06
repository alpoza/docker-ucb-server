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

import org.w3c.dom.*;

/*
 Name 	 	Description
ant 		an instance of AntBuilder that knows about the current ant project
project 	the current ant project
properties 	a Map of ant properties
target 		the owning target that invoked this groovy script
task 		the wrapping task, can access anything needed in org.apache.tools.ant.Task
args		command line arguments, if any
*/

//==============================================================================

//------------------------------------------------------------------------------
//utility methods

Hashtable properties = (Hashtable) this.getBinding().getVariable("ANT_PROPERTIES");
Connection connection = (Connection) this.getBinding().getVariable("CONN");
boolean verbose = Boolean.valueOf(properties.get("verbose")).booleanValue();
Sql sql = new Sql(connection)

final def error = { message ->
    println("!!"+message);
}

final def warn = { message ->
    println(message);
}

final def debug = { message ->
    if (verbose) {
        println(message);
    }
}

final def newId = {
    return UUID.randomUUID().toString()
}

def nextJobConfigId = null;
def nextStepId = null;

final def getNextSeq = { className ->
    debug("Getting next seq for $className");
    def row = sql.firstRow("select hi_val from hi_lo_seq where seq_name = ?", [className])
    return row['hi_val'];
}

final def setNextSeq = { className, nextVal ->
    debug("Setting next seq for $className to $nextVal");
    sql.executeUpdate("update hi_lo_seq set hi_val = ? where seq_name = ?", [nextVal, className]);
}

final def getNextJobConfigId = { 
    if(nextJobConfigId == null) {
        nextJobConfigId = getNextSeq("JOB_CONFIG");
    }
    else {
       nextJobConfigId ++;
    }
    return nextJobConfigId;
}

final def getNextStepId = { 
    if(nextStepId == null) {
        nextStepId = getNextSeq("JOB_STEP_CONFIG");
    }
    else {
       nextStepId ++;
    }
    return nextStepId;
}
    

final def getAllLibraryJobIds = { 
    debug("Getting all library jobs");
    def ids = [];
    sql.eachRow("select id from job_config where project_id is null") { row ->
       ids << row["ID"];
    }
    return ids;
}

final def getAllLibraryWorkflowDefIdsUsingJob = { jobId ->
    debug("Getting all workflows using job id : " + jobId);
    def ids = [];
    sql.eachRow("select distinct wd.id from workflow_definition_job_config wdjc" +
                " join workflow_definition wd on wdjc.workflow_definition_id = wd.id" + 
                " where wd.is_library = 1 and wdjc.job_config_id = ?" ,[jobId]) 
    { row ->
        ids << row["id"];
    }
    return ids;
}

final def getAllJobConfigStepIds = { jobId ->
    debug("Getting all job config step ids");
    def ids = [];
    sql.eachRow("select distinct id from job_config_step where job_config_id = ?",[jobId]) {
        ids << row["id"];
    }
    return ids;
} 
    

final def changeJobReference = { newJobId, workflow_definition_job_config_id, oldJobId ->
    sql.executeUpdate("update workflow_definition_job_config set job_config_id = ?" + 
                      " where workflow_definition_id = ? and job_config_id = ?", 
                      [newJobId, workflow_definition_job_config_id, oldJobId]);
}

final def copyJobConfigStep = { jobConfigStepId, newJobId ->
    def r = sql.firstRow("select * from job_config_step where id = ?", [jobConfigStepId]);
    def nextVal = getNextStepId();
    sql.executeInsert("insert into job_config_step (id, version, job_config_id, seq, " + 
                       "class, plugin_command_id, name, description, ignore_failures, " + 
                       "timeout, active, run_in_preflight, run_in_preflight_only, " + 
                       "step_pre_condition_script_id, post_process_script_id, stamp, " + 
                       "status_id, work_dir_script_id, data) values (?, ?, ?, ?, ?, ?, ?, ?, " +
                       "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [nextVal, 0, newJobId, r['SEQ'],
                       r['CLASS'], r['PLUGIN_COMMAND_ID'], r['NAME'], r['DESCRIPTION'], r['IGNORE_FAILURES'], 
                       r['TIMEOUT'], r['ACTIVE'], r['RUN_IN_PREFLIGHT'], 
                       r['RUN_IN_PREFLIGHT_ONLY'], r['STEP_PRE_CONDITION_SCRIPT_ID'],
                       r['POST_PROCESS_SCRIPT_ID'], r['STAMP'], r['STATUS_ID'], 
                       r['WORK_DIR_SCRIPT_ID'], r['DATA']]);
    return nextVal;
}

final def copyJobToLibraryWorkflow = { jobId, workflow_definition_id ->
    //create new project job
    def r = sql.firstRow("select * from job_config where id = ?", [jobId]);

    def newJobId = getNextJobConfigId();

    sql.executeInsert("insert into job_config (id, version, name, description, hidden, " + 
                      "project_id, workflow_definition_id, life_cycle_model_id, inactive, " + 
                      "resource_id) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [newJobId, 0, 
                      r['NAME'], r['DESCRIPTION'], r['HIDDEN'], null, 
                      workflow_definition_id, r['LIFE_CYCLE_MODEL_ID'], r['INACTIVE'], 
                      null]);

    getAllJobConfigStepIds(jobId).each { jobStepId ->
        copyJobConfigStep(jobStepId, newJobId);
    }
    return newJobId;
}

final def moveJobToWkfw = { jobId, wkfwId ->
    sql.executeUpdate("update job_config set workflow_definition_id = ? where id = ?", [wkfwId, jobId]);
}

final def deleteLibJob = { jobId ->
    sql.execute("delete from workflow_definition_job_config where job_config_id = ?", [jobId]);
    sql.execute("delete from job_config_step where job_config_id = ?", [jobId]);
    sql.execute("delete from job_config where id = ?", [jobId]);
}
   

def libJobIds = getAllLibraryJobIds();

libJobIds.each { jobId ->
    def wkfwIds = getAllLibraryWorkflowDefIdsUsingJob(jobId);
    if (wkfwIds.size() > 1) {
        wkfwIds.each { wkfwDefId ->
            def newJobId = copyJobToLibraryWorkflow(jobId, wkfwDefId);
            changeJobReference(newJobId, wkfwDefId, jobId);
        }
        deleteLibJob(jobId);
    } 
    else if (wkfwIds.size() == 1) {
        moveJobToWkfw(jobId, wkfwIds[0]);
    }
    else {
        deleteLibJob(jobId);
    }
}

// defensively up the hi_lo table
setNextSeq("JOB_CONFIG", getNextJobConfigId());
setNextSeq("JOB_STEP_CONFIG", getNextStepId());
