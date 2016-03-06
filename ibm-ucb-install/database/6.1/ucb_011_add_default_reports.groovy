import groovy.sql.Sql;
import java.lang.*;
import java.sql.Connection;
import java.util.*;

// login information for database
// this should be modified as need be
Hashtable properties = (Hashtable) this.getBinding().getVariable("ANT_PROPERTIES");
Connection connection = (Connection) this.getBinding().getVariable("CONN");
boolean verbose = Boolean.valueOf(properties.get("verbose")).booleanValue();
Sql sql = new Sql(connection)

//------------------------------------------------------------------------------
class Report {
    public def id
    public def name
    public def description
    public def resourceId
    public def query
    public def outputConfig

    public Report(def id, def name, def description, def query, def outputConfig) {
        this.id = id
        this.name = name
        this.description = description
        this.resourceId = id
        this.query = query
        this.outputConfig = outputConfig
    }
}

//------------------------------------------------------------------------------
sql.connection.autoCommit = false;

String selectExistingReport = "SELECT * FROM REP_REPORT WHERE NAME = ?"
String insertReportSecResource = "INSERT INTO sec_resource(id, version, name, enabled, sec_resource_type_id)" +
        " VALUES(?, 0, ?, 'Y', '00000000-0000-0000-0000-000000100000')"
String insertReport = "INSERT INTO REP_REPORT(ID, NAME, DESCRIPTION, RESOURCE_ID, QUERY, OUTPUT_CONFIG) " +
        "VALUES(?, ?, ?, ?, ?, ?)"

def reports = []
reports << new Report('00000000-0000-0000-0000-000000000001', 'Builds Per Month', null, '{"table":"PROCESS_EXECUTION","criteria":[{"type":">","column":"END_DATE.YEAR_NUM + \'_\' + END_DATE.MONTH","value":"${now.addYears(-1).yearAndMonth}"},{"type":"equals","column":"PROCESS.PROCESS_TEMPLATE.PROCESS_TYPE","value":"Build"}],"order_by":[{"column":"END_DATE.YEAR_NUM + \'_\' + END_DATE.MONTH","direction":"ASC"}],"columns":[{"name":"PROCESS_ID","alias":"Builds","function":"COUNT"},{"name":"RESULT","alias":"Result"},{"name":"END_DATE.YEAR_NUM + \'_\' + END_DATE.MONTH","alias":"Month"}]}', '{"type":"COLUMN_CHART","seriesName":"Month","seriesColumn":"Month","seriesCategoryColumn":"Result","dataName":"Builds","dataColumn":"Builds"}')
reports << new Report('00000000-0000-0000-0000-000000000002', 'Most Changed Source Files','Source files with the most changes.', '{"table":"FILE_CHANGE","order_by":[{"column":"CHANGE_TYPE","direction":"DESC"}],"columns":[{"name":"CHANGE_PATH","alias":"File"},{"name":"CHANGE_TYPE","alias":"Changes","function":"COUNT"}]}', null)
reports << new Report('00000000-0000-0000-0000-000000000003', 'Process Average Duration','Graph the average duration of executions for each build process.', '{"table":"PROCESS_EXECUTION","columns":[{"name":"BUILD_LIFE.BUILD_PROCESS.PROCESS_ID","function":"COUNT"},{"name":"BUILD_LIFE.BUILD_PROCESS.PROCESS_NAME"},{"name":"BUILD_LIFE.BUILD_PROCESS.PROJECT.PROJECT_NAME"},{"name":"DURATION","function":"AVG"}],"criteria":[{"type":"equals","column":"RESULT","value":"Complete"},{"type":"equals","column":"PROCESS.PROCESS_TEMPLATE.PROCESS_TYPE","value":"Build"}]}', '{"type":"COLUMN_CHART","seriesName":"Project","seriesColumn":"BUILD_LIFE.BUILD_PROCESS.PROJECT.PROJECT_NAME","dataName":"Avg Duration","dataColumn":"AVG(DURATION)"}')
reports << new Report('00000000-0000-0000-0000-000000000004', 'Project Onboarding','Number of projects created per month.', '{"table":"OBJECT_CONFIG_AUDITING","criteria":[{"type":"equals","column":"ACTION","value":"Create"},{"type":"equals","column":"CONFIG_OBJECT.OBJECT_TYPE","value":"Project"},{"type":"like","column":"DESCRIPTION","value":"Created project%"}],"columns":[{"name":"ACTION","function":"COUNT"},{"name":"ACTION_DATE.YEAR_NUM + \'_\' + ACTION_DATE.MONTH","alias":"Month","function":"DISTINCT"}]}', '{"type":"COLUMN_CHART","seriesName":"Month","seriesColumn":"Month","dataName":"Projects Created","dataColumn":"COUNT(ACTION)"}')

reports.each { report ->
    def rows = sql.rows(selectExistingReport, [report.name])
    if (rows.isEmpty()) {
        println "Inserting new '${report.name} report."
        sql.executeUpdate(insertReportSecResource, [report.id, report.name])
        sql.executeUpdate(insertReport, [report.id, report.name, report.description, report.resourceId, report.query, report.outputConfig])
    }
    else {
        println "Report '${report.name} already exists."
    }
}
