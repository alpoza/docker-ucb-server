import groovy.sql.Sql
import groovy.transform.EqualsAndHashCode

import java.lang.*
import java.sql.Connection
import java.util.*

// login information for database
// this should be modified as need be
Hashtable properties = (Hashtable) this.getBinding().getVariable("ANT_PROPERTIES")
Connection connection = (Connection) this.getBinding().getVariable("CONN")
Sql sql = new Sql(connection)
sql.connection.autoCommit = false

//------------------------------------------------------------------------------
@EqualsAndHashCode
class WorkflowDefinition {
    def id
    def name
    def description

    public WorkflowDefinition(def id, def name) {
        this.id = id
        this.name = name
    }
}

class Template {
    def id
    def name

    public Template(def id, def name) {
        this.id = id
        this.name = name
    }
}

class MigratedJobConfig {
    def id
    def workflowDefId

    public MigratedJobConfig(def id, def workflowDefId) {
        this.id = id
        this.workflowDefId = workflowDefId
    }
}

Integer getHiVal(def sql, def seqName) {
    Integer hiVal = 0
    sql.query("SELECT * FROM HI_LO_SEQ WHERE SEQ_NAME = ?", [seqName]) {
        it.next()
        hiVal = it.getInt('HI_VAL')
    }
    return hiVal
}

//------------------------------------------------------------------------------
String updateHiLoSeq = "UPDATE HI_LO_SEQ SET HI_VAL=? WHERE SEQ_NAME = ?"

String getWorkflowDefSql =
'''SELECT WD.ID, WD.NAME, WT.ID AS TEMPLATE_ID, WT.NAME as TEMPLATE_NAME
     FROM WORKFLOW_DEFINITION WD
     JOIN WORKFLOW_TEMPLATE WT ON WT.WORKFLOW_DEFINITION_ID = WD.ID'''

String insertWorkflowDefSql =
'''INSERT INTO WORKFLOW_DEFINITION (
      ID,
      VERSION,
      NAME
   ) VALUES (
     ?, ?, ?
   )'''

String getWorkflowDefJobConfigsSql = "SELECT * FROM WORKFLOW_DEFINITION_JOB_CONFIG WHERE WORKFLOW_DEFINITION_ID = ?"
String insertWorkflowDefJobConfigSql =
'''INSERT INTO WORKFLOW_DEFINITION_JOB_CONFIG (
     ID,
     VERSION,
     WORKFLOW_DEFINITION_ID,
     JOB_CONFIG_ID,
     ITERATION_TYPE,
     ITERATIONS,
     IS_PARALLEL,
     MAX_PARALLEL_JOBS,
     RUN_ITR_ON_UNIQUE_AGENTS,
     ITERATION_PROPERTY_NAME,
     REQUIRE_ALL_AGENTS,
     PRE_CONDITION_SCRIPT_ID,
     AGENT_POOL_ID,
     NO_AGENT,
     AGENT_PROP,
     WORK_DIR_SCRIPT_ID,
     USE_PARENT_WORK_DIR,
     USE_SOURCE_WORK_DIR_SCRIPT,
     IS_WORKFLOW_LOCK,
     CLEANUP,
     INACTIVE
   ) VALUES (
     ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
   )'''

String getWorkflowDefJobIterProps = "SELECT * FROM WORKFLOW_DEF_JOB_ITR_PROP WHERE WORKFLOW_DEF_JOB_CONFIG_ID = ?"
String insertWorkflowDefJobIterProp =
'''INSERT INTO WORKFLOW_DEF_JOB_ITR_PROP (
     WORKFLOW_DEF_JOB_CONFIG_ID,
     ITERATION,
     PROPERTY_NAME,
     VALUE,
     LONG_VALUE
   ) VALUES (
     ?, ?, ?, ?, ?
   )'''

String getWorkflowDefJobIterNames = "SELECT * FROM WORKFLOW_DEF_JOB_ITR_NAME WHERE WORKFLOW_DEF_JOB_CONFIG_ID = ?"
String insertWorkflowDefJobIterName =
'''INSERT INTO WORKFLOW_DEF_JOB_ITR_NAME (
     WORKFLOW_DEF_JOB_CONFIG_ID,
     ITERATION,
     NAME
   ) VALUES (
     ?, ?, ?
   )'''

String getWorkflowDefEdges = "SELECT * FROM WORKFLOW_DEFINITION_EDGES"
String insertWorkflowDefEdge = "INSERT INTO WORKFLOW_DEFINITION_EDGES(FROM_WF_DEF_JOB_CONFIG_ID, TO_WF_DEF_JOB_CONFIG_ID) VALUES(?, ?)"

String updateProcessTemplateSql =
'''UPDATE WORKFLOW_TEMPLATE
       SET WORKFLOW_DEFINITION_ID=?
   WHERE ID=?'''

Integer workflowDefHiVal = getHiVal(sql, "WORKFLOW_DEFINITION")
Integer workflowDefJobConfigHiVal = getHiVal(sql, "WORKFLOW_DEFINITION_JOB_CONFIG")

Map<WorkflowDefinition, List<Template>> workflowDefToProcessTemplatesMap = new HashMap<WorkflowDefinition, List<Template>>()
sql.eachRow(getWorkflowDefSql) { row ->
    String id = row['ID']
    String name = row['NAME']

    String templateId = row['TEMPLATE_ID']
    String templateName = row['TEMPLATE_NAME']

    WorkflowDefinition workflowDef = new WorkflowDefinition(id, name)
    List<Template> templates = workflowDefToProcessTemplatesMap.get(workflowDef)
    if (templates == null) {
        templates = new ArrayList<Template>()
        workflowDefToProcessTemplatesMap.put(workflowDef, templates)
    }
    Template processTemplate = new Template(templateId, templateName)
    templates.add(processTemplate)
}

Map<Integer, List<MigratedJobConfig>> jobConfigOldIdToNewIdListMap = new HashMap<Integer, List<MigratedJobConfig>>()
for (Map.Entry<WorkflowDefinition, List<Template>> entry : workflowDefToProcessTemplatesMap.entrySet()) {
    WorkflowDefinition workflowDef = entry.getKey()
    def originalWorkflowDefId = workflowDef.id
    List<Template> templates = entry.getValue()
    if (templates.size() > 1) {
        println "Multiple process templates using workflow template '${workflowDef.name}'. Duplicating '${workflowDef.name}'."
        for (int i = 1; i < templates.size(); i++) {
            Template processTemplate = templates.get(i)

            def newWorkflowDefId = ++workflowDefHiVal
            def workflowDefinitionName = processTemplate.name

            // Insert the new workflow definition into the database
            sql.executeUpdate(insertWorkflowDefSql, [newWorkflowDefId, 0, workflowDefinitionName])
            // Update the process template to use the new workflow definition
            sql.executeUpdate(updateProcessTemplateSql, [newWorkflowDefId, processTemplate.id])

            // Create new job configs for the workflow definition
            sql.eachRow(getWorkflowDefJobConfigsSql, [originalWorkflowDefId]) { row ->
                Integer originalWorkflowDefJobConfigId = (Integer) row['ID']
                Integer newWorkflowDefJobConfigId = ++workflowDefJobConfigHiVal

                List<MigratedJobConfig> newJobConfigIdList = jobConfigOldIdToNewIdListMap.get(originalWorkflowDefJobConfigId)
                if (newJobConfigIdList == null) {
                    newJobConfigIdList = new ArrayList<MigratedJobConfig>()
                    jobConfigOldIdToNewIdListMap.put(originalWorkflowDefJobConfigId, newJobConfigIdList)
                }
                newJobConfigIdList.add(new MigratedJobConfig(newWorkflowDefJobConfigId, newWorkflowDefId))

                def jobConfigId = row['JOB_CONFIG_ID']
                def iterationType = row['ITERATION_TYPE']
                def iterations = row['ITERATIONS']
                def isParallel = row['IS_PARALLEL']
                def maxParallelJobs = row['MAX_PARALLEL_JOBS']
                def runIterOnUniqueAgents = row['RUN_ITR_ON_UNIQUE_AGENTS']
                def iterationPropName = row['ITERATION_PROPERTY_NAME']
                def requireAllAgents = row['REQUIRE_ALL_AGENTS']
                def preConditionScript = row['PRE_CONDITION_SCRIPT_ID']
                def agentPool = row['AGENT_POOL_ID']
                def noAgent = row['NO_AGENT']
                def agentProp = row['AGENT_PROP']
                def workDirScript = row['WORK_DIR_SCRIPT_ID']
                def useParentWorkDir = row['USE_PARENT_WORK_DIR']
                def useSourceWorkDir = row['USE_SOURCE_WORK_DIR_SCRIPT']
                def workflowLock = row['IS_WORKFLOW_LOCK']
                def cleanup = row['CLEANUP']
                def inactive = row['INACTIVE']

                sql.executeUpdate(insertWorkflowDefJobConfigSql, [newWorkflowDefJobConfigId, 0, newWorkflowDefId, jobConfigId,
                                                                  iterationType, iterations, isParallel, maxParallelJobs, runIterOnUniqueAgents,
                                                                  iterationPropName, requireAllAgents, preConditionScript, agentPool,
                                                                  noAgent, agentProp, workDirScript, useParentWorkDir, useSourceWorkDir,
                                                                  workflowLock, cleanup, inactive])

                // Insert workflow def job config iteration properties for the new job config
                sql.eachRow(getWorkflowDefJobIterProps, [originalWorkflowDefJobConfigId]) { propRow ->
                    def iteration = propRow['ITERATION']
                    def propName = propRow['PROPERTY_NAME']
                    def value = propRow['VALUE']
                    def longValue = propRow['LONG_VALUE']
                    sql.executeUpdate(insertWorkflowDefJobIterProp, [newWorkflowDefJobConfigId, iteration, propName, value, longValue])
                }

                // Insert workflow def job config iteration names for the new job config
                sql.eachRow(getWorkflowDefJobIterNames, [originalWorkflowDefJobConfigId]) { iterRow ->
                    def iteration = iterRow['ITERATION']
                    def iterationName = iterRow['NAME']
                    sql.executeUpdate(insertWorkflowDefJobIterName, [newWorkflowDefJobConfigId, iteration, iterationName])
                }
            }
        }
    }
}

// Insert workflow defintion edges for the new workflow definition and its job configs
sql.eachRow(getWorkflowDefEdges) { row ->
    Integer oldFrom = (Integer) row['FROM_WF_DEF_JOB_CONFIG_ID']
    Integer oldTo = (Integer) row['TO_WF_DEF_JOB_CONFIG_ID']

    List<MigratedJobConfig> newFromJobConfigIds = jobConfigOldIdToNewIdListMap.get(oldFrom)
    List<MigratedJobConfig> newToJobConfigIds = jobConfigOldIdToNewIdListMap.get(oldTo)
    for (MigratedJobConfig from : newFromJobConfigIds) {
        for (MigratedJobConfig to : newToJobConfigIds) {
            if (from.workflowDefId == to.workflowDefId) {
                sql.executeUpdate(insertWorkflowDefEdge, [from.id, to.id])
            }
        }
    }
}

// Update the HI_LO_SEQ table with new HI_VAL values
sql.executeUpdate(updateHiLoSeq, [workflowDefHiVal, "WORKFLOW_DEFINITION"])
sql.executeUpdate(updateHiLoSeq, [workflowDefHiVal, "WORKFLOW_DEFINITION_JOB_CONFIG"])
