INSERT INTO DB_VERSION(RELEASE_NAME, VER) VALUES('4.0', 155);;
INSERT INTO DB_VERSION(RELEASE_NAME, VER) VALUES('4.1', 25);;
INSERT INTO DB_VERSION(RELEASE_NAME, VER) VALUES('4.2', 32);;
INSERT INTO DB_VERSION(RELEASE_NAME, VER) VALUES('4.3', 14);;
INSERT INTO DB_VERSION(RELEASE_NAME, VER) VALUES('5.0', 31);;
INSERT INTO DB_VERSION(RELEASE_NAME, VER) VALUES('6.1', 20);;

INSERT INTO WORK_DIR_SCRIPT(ID, NAME, DESCRIPTION, PATH, CAN_DELETE)
    VALUES(-1, 'Default Workflow Directory', '{agent}/var/work/project/{project}/{workflow}', '${env/AGENT_HOME}/var/work/project/${gvy:PathHelper.makeSafe(ProjectLookup.current.name)}/${gvy:PathHelper.makeSafe(WorkflowLookup.current.name)}', 0);;
INSERT INTO WORK_DIR_SCRIPT(ID, NAME, DESCRIPTION, PATH, CAN_DELETE)
    VALUES(-2, 'Unique Job Directory', '{agent}/var/work/job/{job_id}', '${env/AGENT_HOME}/var/work/job/${gvy:JobTraceLookup.current.id}', 0);;

INSERT INTO STATUS(ID, VERSION, LOCKED, NAME, COLOR, DESCRIPTION, SEQ)
    VALUES(-1, 0, 1, 'Success', '#90EE90', 'Build was a success', 1);;
INSERT INTO STATUS(ID, VERSION, LOCKED, NAME, COLOR, DESCRIPTION, SEQ)
    VALUES(-2, 0, 1, 'Failure', '#FFB6C1', 'Build was a failure', 2);;
INSERT INTO STATUS(ID, VERSION, LOCKED, NAME, COLOR, DESCRIPTION, SEQ)
    VALUES(-3, 0, 1, 'Archived', '#D3D3D3', 'Build is archived', 3);;

INSERT INTO AGENT_POOL(ID, VERSION, NAME, DESCRIPTION)
    VALUES(1, 1, 'All Build Agents', 'Default agent pool for all build agents.');;

INSERT INTO ARTIFACT_SET(ID, VERSION, NAME, DESCRIPTION)
    VALUES(-1, 0, 'artifacts', '');;
INSERT INTO ARTIFACT_SET(ID, VERSION, NAME, DESCRIPTION)
    VALUES(-2, 0, 'maven', 'Artifact Set for Maven published artifacts.');;

INSERT INTO CLEANUP_CONFIG(ID, NAME, DESCRIPTION, DATA)
    VALUES(-1, 'Default Cleanup', null, '<?xml version="1.0" encoding="UTF-8"?><cleanup-config></cleanup-config>');;

INSERT INTO NOTIFICATION_RECIPIENT_GEN(ID, VERSION, CLASS, NAME, DESCRIPTION, DATA)
    VALUES(0, 0, 'com.urbancode.ubuild.domain.notification.ScriptedNotificationRecipientGenerator', 'All Users', 'All users in the system.', '<?xml version="1.0" encoding="UTF-8"?><script>users.getAllUsers()</script>');;
INSERT INTO NOTIFICATION_RECIPIENT_GEN(ID, VERSION, CLASS, NAME, DESCRIPTION, DATA)
    VALUES(-1, 0, 'com.urbancode.ubuild.domain.notification.ScriptedNotificationRecipientGenerator', 'Committing Developers', 'Users retrieved from the change logs of a build.', '<?xml version="1.0" encoding="UTF-8"?><script>users.getAllContributors()</script>');;
INSERT INTO NOTIFICATION_RECIPIENT_GEN(ID, VERSION, CLASS, NAME, DESCRIPTION, DATA)
    VALUES(-2, 0, 'com.urbancode.ubuild.domain.notification.ScriptedNotificationRecipientGenerator', 'Committing and Dependent Developers', 'Users that have committed to the current project or dependency projects.', '<?xml version="1.0" encoding="UTF-8"?><script>users.getAllContributorsAndDependentContributors()</script>');;
INSERT INTO NOTIFICATION_RECIPIENT_GEN(ID, VERSION, CLASS, NAME, DESCRIPTION, DATA)
    VALUES(-3, 0, 'com.urbancode.ubuild.domain.notification.ScriptedNotificationRecipientGenerator', 'Committing Developers (Context)', 'Users in the request context of dependency projects.', '<?xml version="1.0" encoding="UTF-8"?><script>users.getAllContributorsAndDependentContributorsInContext()</script>');;

INSERT INTO NOTIFICATION_SCHEME(ID, VERSION, NAME, DESCRIPTION)
    VALUES(0, 0, 'Default Notification Scheme', null);;
INSERT INTO NOTIFICATION_SCHEME(ID, VERSION, NAME, DESCRIPTION)
    VALUES(-1, 0, 'Default CI Notification Scheme', 'The default Continuous Integration notification scheme. Use this notification scheme to send email alerts to all repository committers upon a change in status to a CI workflow.');;

INSERT INTO NOTIFICATION_SCHEME_WHO_WHEN(SCHEME_ID, SEQ, WHO_GENERATOR_CLASS, WHO_GENERATOR_ID, WHEN_GENERATOR_CLASS, WHEN_GENERATOR_ID)
    VALUES(0, 0, 'com.urbancode.ubuild.domain.notification.ScriptedNotificationRecipientGenerator', 0, 'com.urbancode.ubuild.domain.notification.ScriptedWorkflowCaseSelector', -1);;
INSERT INTO NOTIFICATION_SCHEME_WHO_WHEN(SCHEME_ID, SEQ, WHO_GENERATOR_CLASS, WHO_GENERATOR_ID, WHEN_GENERATOR_CLASS, WHEN_GENERATOR_ID)
    VALUES(-1, 0, 'com.urbancode.ubuild.domain.notification.ScriptedNotificationRecipientGenerator', -2, 'com.urbancode.ubuild.domain.notification.ScriptedWorkflowCaseSelector', -1);;

INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-1, 0, 'Parent Job Success', 'Run if the immediate parent job(s) were successful or if there are no parent jobs.', 'javascript', 'jobStatus.parentsIn(SUCCESS)', 0, 0);;
INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-2, 0, 'All Ancestor Jobs Success', 'Run if all ancestor jobs were successful or if there are no ancestor jobs.', 'javascript', 'jobStatus.allAncestorsIn(SUCCESS)', 0, 0);;
INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-3, 0, 'Always', 'Always run the job.', 'javascript', '!jobStatus.anyIn(ABORTED, ABORTING)', 0, 0);;
INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-4, 0, 'Never', 'Never run the job.', 'javascript', 'false', 0, 0);;
INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-5, 0, 'All Completed Jobs Success', 'Run if all completed jobs in the workflow were successful.', 'javascript', 'jobStatus.allCompletedIn(SUCCESS)', 0, 0);;
INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-6, 0, 'Parent Job Success or Not Needed', 'Run if the immediate parent job(s) were success or not needed or there are no parent jobs.', 'javascript', 'jobStatus.parentsIn(SUCCESS, NOT_NEEDED)', 0, 0);;
INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-7, 0, 'All Ancestor Jobs Success or Not Needed', 'Run if the parent job(s) were success or not needed or there are no ancestor jobs.', 'javascript', 'jobStatus.allAncestorsIn(SUCCESS, NOT_NEEDED)', 0, 0);;
INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-8, 0, 'Fail Iterated Job Fast', 'Run if the ancestor job(s) were success or not needed or there are no ancestor jobs and all completed iterated jobs were not failures.', 'javascript', 'jobStatus.allAncestorsIn(SUCCESS, NOT_NEEDED) && !jobStatus.anyIteratedIn(FAILED)', 0, 0);;
INSERT INTO JOB_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-9, 0, 'Run on Any Failure', 'Run if any completed job in the workflow is a failure.', 'javascript', 'jobStatus.anyIn(FAILED)', 0, 0);;

INSERT INTO STEP_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(0, 0, 'Never', 'Never execute', 'javascript', 'false', 0, 0);;
INSERT INTO STEP_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(1, 0, 'All Prior Success', 'All prior steps are successful', 'javascript', 'stepStatus.allPriorIn(SUCCESS, SUCCESS_WARN);', 0, 0);;
INSERT INTO STEP_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(2, 0, 'Prior Success', 'Prior step was successful', 'javascript', 'stepStatus.priorIn(SUCCESS, SUCCESS_WARN);', 0, 0);;
INSERT INTO STEP_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(3, 0, 'Any Prior Failure', 'Any prior step was a failure', 'javascript', 'stepStatus.anyPriorIn(FAILED);', 0, 0);;
INSERT INTO STEP_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(4, 0, 'Always', 'Always execute', 'javascript', 'true', 0, 0);;
INSERT INTO STEP_PRE_CONDITION_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(5, 0, 'Prior Failure', 'Prior step was a failure', 'javascript', 'stepStatus.priorIn(FAILED);', 0, 0);;

INSERT INTO WORKFLOW_PRIORITY_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-1, 0, 'Low Priority', 'Assigns a Low Priority for the Workflow', 'beanshell', 'return WorkflowPriorityEnum.LOW;', 0, 0);;
INSERT INTO WORKFLOW_PRIORITY_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-2, 0, 'Normal Priority', 'Assigns a Normal Priority for the Workflow', 'beanshell', 'return WorkflowPriorityEnum.NORMAL;', 0, 0);;
INSERT INTO WORKFLOW_PRIORITY_SCRIPT(ID, VERSION, NAME, DESCRIPTION, LANGUAGE, SCRIPT, CAN_DELETE, INACTIVE)
    VALUES(-3, 0, 'High Priority', 'Assigns a High Priority for the Workflow', 'beanshell', 'return WorkflowPriorityEnum.HIGH;', 0, 0);;

INSERT INTO NOT_SCHEME_WHO_WHEN_MEDIUM(SCHEME_ID, WHO_WHEN_SEQ, SEQ, MEDIUM_NAME, TEMPLATE_ID)
    VALUES(0, 0, 0, 'Email', -1);;
INSERT INTO NOT_SCHEME_WHO_WHEN_MEDIUM(SCHEME_ID, WHO_WHEN_SEQ, SEQ, MEDIUM_NAME, TEMPLATE_ID)
    VALUES(-1, 0, 0, 'Email', -1);;

INSERT INTO REPOSITORY_USERS(ID, VERSION, DATA)
    VALUES(1, 0, 'WWAOc1JoYlfbeXhh4F+abUtLZ1NqUUp4UV1UWXFda0pYVnlgTW5Ma3NacWZxZXpcd1xhd1V0cV10Wk9rWHVoTGxgdkxzTnZRXE9uYUxYV0hWYF1mZnhwblZ5cV1wUWlIXU5eZEpueHheamhRbWF4V2NdWXVOT0l1WE5valFsYGNSaHBRZGZUYE9qVmJRd1tUeG1vbG5sc1ZiYHV5YWhvUXl4eU53S2tsdVBmUE9cX1lNSnJyb21rbWB1eVpuXnRvYk5aY3BQZm55dkt3YUxpeW9nY2FoenNwaHFJZllydVhoU1ZhZHRLZVdYbVVtYFtyam9iU25xYF1sT2NxWVJcXXN2X2dPUmRoTmZtak5MSGt3W11qYWhhW2h5cW1baU5iWmBWa1BMbHNcZXhgcFpIWWVVYG1ld15ba1ZlSlJXZG5pbHJQaXJYWk9OS1JbWltad3NnZFBVWnRRZ0ppVk9ecmFrTWdgW29aYWZ1ZVBrc2hWXFZ4WktVdHhgYW94S3JqWUhaVlJLSUhRUXlQSHpjZE1ldFVJW2t6eGlPWUpzZWhhUlBba0xLZGV5WV1fa2FqWUhKUlZxcFRoSFxKSndfUlh1TnZwTlxxUldSVmVgcF5tSnhSYnlSb3ByUmlMdGZbVl5gUmpzdGliTmRUUnZ5bGBjeE15aHpLX1FqcHZdV1JQTmhoUWFXb29pS2pqZGphZGxdbndralptT1xWWmheTG5RXU1VdmlcYVxoSV51am9YUnpWdGtvWU5Lc01wd09vaWZeUmtiTFBockhNbVRTbndJWF1ITF5pa25RWmB6UmpZVWRRSFhSWlRua1luX1V3Vmhsb1tiVmNmUVVtaXJ1clxRcV5MeWlmV1FUYVdocWx6aFRJSVNJcXlvbXBYa2llWG5KWXRTX1JhT3BqS1h1WGZbV05WVGhnSmZranleZmxUSnByYXJ3elFTbWFWTFlva2lKeXRpUXJpb2d5WE1RSm1Wa1ZqXlNmX3VUblhUW2JtZnJOWkpOcGdxUWlcbHpOU3ZOaUhwZ3pqXk9OcU10YHFNWGlMYHRTTFpJUmt3YWtcc11KSEp1SWNwUlZbeGpOUFlUSHR4V1xUZE5mWnBhT29fUW1uSG5wc3pYeVduYGxYSGJ0TUl0ZlRNZmliUlFnamttYGlzXU9lVkpxWFVUaEpWY1pWYXdhYElWTU93c193ektaTkpWdGVsb29WZXhobXZnXnRkbGtmUGdnXnVST3NdU1hbYldkdWRVTlV6bV9VTlJucW1dUWFVWU1iYWpRZW9Jd3pST2xMXE9VSmpzUmFwYV9veWRTaXBcbVpOSmFgZUtZYWVzYGhJYkxObUxJd1hSWnF6VWxRWltwYlRxWFpXZFdrV2ZiAHAbM3m1GBXgeVTbLidwZIhn70q2kvmBZynyOcwjmq9bV9BKsd4qQFifgw1Q1gkuYjQCWZOeh84aVTvgNt6Bew==');;

INSERT INTO SCHEDULE(ID, VERSION, CLASS, DATA, NAME, DESCRIPTION)
    VALUES(1, 31, 'com.urbancode.ubuild.domain.schedule.interval.IntervalSchedule', '<?xml version="1.0" encoding="UTF-8"?>
<schedule>
<build-interval>60</build-interval>
<start-time>00:00</start-time>
</schedule>
', 'hourly', '');;
INSERT INTO SCHEDULE(ID, VERSION, CLASS, DATA, NAME, DESCRIPTION)
    VALUES(0, 0, 'com.urbancode.ubuild.domain.schedule.cron.CronExpressionSchedule', '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <schedule><cron-expr>0 0/15 * * * ?</cron-expr></schedule>
      ', 'Every 15 minutes', 'A schedule which fires every 15 minutes.');;
INSERT INTO SCHEDULE(ID, VERSION, CLASS, DATA, NAME, DESCRIPTION)
    VALUES(2, 0, 'com.urbancode.ubuild.domain.schedule.cron.CronExpressionSchedule', '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <schedule><cron-expr>0 0 0 ? * *</cron-expr></schedule>
      ', 'Every night at 12:00 AM', 'A schedule which fires every night at 12:00 AM.');;

INSERT INTO UBUILD_USER(ID, NAME, CAN_DELETE, SEC_USER_ID, AUTH_REALM_ID)
    VALUES(3, 'admin', 0, '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001');;
INSERT INTO UBUILD_USER(ID, NAME, CAN_DELETE, SEC_USER_ID, AUTH_REALM_ID)
    VALUES(4, 'ubuild', 0, '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001');;
INSERT INTO UBUILD_USER(ID, NAME, CAN_DELETE, SEC_USER_ID, AUTH_REALM_ID)
    VALUES(5, 'guest', 0, '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001');;

INSERT INTO SINGLETON(ID, VERSION, CLASS, DATA)
    VALUES(1, 0, 'com.urbancode.ubuild.domain.singleton.mailserver.MailServer', '<?xml version="1.0" encoding="UTF-8"?>
<mail-server>
<name><![CDATA[Mail Server Configuration]]></name>
<host><![CDATA[mail.domain.com]]></host>
<sender><![CDATA[build@domain.com]]></sender>
<user-name><![CDATA[build@domain.com]]></user-name>
<password><![CDATA[password]]></password>
</mail-server>
');;
INSERT INTO SINGLETON(ID, VERSION, CLASS, DATA)
    VALUES(2, 0, 'com.urbancode.ubuild.domain.singleton.cleanup.Cleanup', '<?xml version="1.0" encoding="UTF-8"?><cleanup><active>true</active></cleanup>');;

INSERT INTO TEMPLATE(ID, VERSION, CLASS, DATA)
    VALUES(-1, 0, 'com.urbancode.ubuild.domain.template.Template', '<?xml version="1.0" encoding="UTF-8"?>
<template>
<name>Simple Process Email Template</name>
<template-text><![CDATA[## BEGIN SECTION Subject

#set($project = $workflow.Project)
#set($stamp = $workflow.BuildLife.latestStamp())

Process:
#if($stamp != "")
  $project.Name - $workflow.Name ($stamp):
#else
  $project.Name - $workflow.Name:
#end

#if($workflow.Status.equalsIgnoreCase("Complete"))
  Success
#else
  $workflow.Status
#end

## END SECTION Subject

## BEGIN SECTION Body
## PROPERTY Content-Type: text/html
## PROPERTY X-Priority: 3

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<head>
<title>Process</title>
<STYLE TYPE="text/css">
<!--
table.data-table td {
    vertical-align: top;
}

table.data-table
{
    font-family: arial, helvetica, sans-serif;
    font-size: 12px;
    background-color: #567596;
}

table.data-table caption
{
    padding-top: 10px;
    padding-bottom: 10px;
    text-align: left;
}

table.data-table th
{
    text-align: center;
    background-color: #cfdbef;
    height: 25px;
}

table.data-table td
{
    vertical-align: top;
}

table.data-table tr.odd
{
    background-color: #ffffff;
}

table.data-table tr.even
{
    background-color: #f6f6f6;
}

.data-table-button-bar
{
    padding-top: 10px;
    padding-bottom: 10px;
}

.data-table-container
{
    padding-top: 10px;
    padding-bottom: 10px;
}
-->
</STYLE>
</head>
<body>

<h1> Process: $workflow.Name
</h1>


<div class="data-table-container">
<table class="data-table" cellpadding="4" cellspacing="1" width="100%">
 <table-body>
  <tr class="data-table-head">
    <th scope="col" align="left" valign="middle"><strong>Job Name</strong></th>
    <th scope="col" align="left" valign="middle"><strong>Agent Name</strong></th>
    <th scope="col" align="left" valign="middle">Status</strong></th>
  </tr>
  #foreach($trace in $workflow.JobTraceList)
    <tr bgcolor="#ffffff">
      <td>$trace.getName()</td>
      <td align="center">$trace.Agent</td>
      #set($status = $trace.Status)
      <td align="center">
        #if($trace.statusIsSuccess())
          <strong style="color: green">
        #elseif($trace.statusIsFailure())
          <strong style="color: red">
        #else
          <strong style="color: blue">
        #end
        $status</strong>
      </td>
    </tr>
  #end
 </table-body>
</table>
</div>

<a href="$workflow.Url">Build details</a> | <a href="$util.UserSubscriptionsUrl">Update subscriptions</a>

</body>
</html>

## END SECTION Body]]></template-text>
<description>A simple example of a velocity template for creating notification emails for notification service.</description>
</template>
');;
INSERT INTO TEMPLATE(ID, VERSION, CLASS, DATA)
    VALUES(-2, 0, 'com.urbancode.ubuild.domain.template.Template', '<?xml version="1.0" encoding="UTF-8"?>
<template>
<name>Build Request Failed Template</name>
<template-text><![CDATA[## BEGIN SECTION Subject

#set($trace = $request.JobTrace)
#set($project = $trace.Project)

Request Failed: $project.Name - $request.Workflow.Name

## END SECTION Subject

## BEGIN SECTION Body
## PROPERTY Content-Type: text/html
## PROPERTY X-Priority: 3

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

#set($trace = $request.JobTrace)
#set($project = $trace.Project)

<html>

<head>
<title>Process</title>
</head>
<body>

Request Failed: $project.Name - $request.Workflow.Name
<p>

<a href="$request.Url">Request information</a> | <a href="$util.UserSubscriptionsUrl">Update subscriptions</a>

</body>
</html>

## END SECTION Body]]></template-text>
<description>A simple example template to notify users of a failed build request</description>
</template>
');;
INSERT INTO TEMPLATE(ID, VERSION, CLASS, DATA)
    VALUES(-3, 0, 'com.urbancode.ubuild.domain.template.Template', '<?xml version="1.0" encoding="UTF-8" standalone="no"?><template><name>Simple IM Template</name>
<template-text><![CDATA[## BEGIN SECTION Subject

#set($project = $workflow.Project)
#set($stamp = $workflow.BuildLife.latestStamp())

Process:
#if($stamp != "")
  $project.Name - $workflow.Name ($stamp):
#else
  $project.Name - $workflow.Name:
#end

#if($workflow.Status.equalsIgnoreCase("Complete"))
  Success
#else
  $workflow.Status
#end

## END SECTION Subject

## BEGIN SECTION Body

#if ( !$workflow )
#set($workflow = $request.WorkflowCase)
#end
#if($workflow.Status.equalsIgnoreCase("Complete"))
  Success
#else
  $workflow.Status
#end
#set($project = $workflow.Project)
#set($stamp = $workflow.BuildLife.latestStamp())
$project.Name - $workflow.Name #if($stamp != "") ($stamp) #end

Additional information: $workflow.Url

Update subscription preferences: $util.UserSubscriptionsUrl

## END SECTION Body]]></template-text>
<description>A simple example of a velocity template for creating notification IMs for notification service.</description>
</template>
');;
INSERT INTO TEMPLATE(ID, VERSION, CLASS, DATA)
    VALUES(-4, 0, 'com.urbancode.ubuild.domain.template.Template', '<?xml version="1.0" encoding="UTF-8"?>
<template>
<name>Process Email Template With Steps</name>
<template-text><![CDATA[## BEGIN SECTION Subject

#set($project = $workflow.Project)
#set($stamp = $workflow.BuildLife.latestStamp())

Process:
#if($stamp != "")
  $project.Name - $workflow.Name ($stamp):
#else
  $project.Name - $workflow.Name:
#end

#if($workflow.Status.equalsIgnoreCase("Complete"))
  Success
#else
  $workflow.Status
#end

## END SECTION Subject

## BEGIN SECTION Body
## PROPERTY Content-Type: text/html
## PROPERTY X-Priority: 3

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<head>
<title>Process</title>
<STYLE TYPE="text/css">
<!--
table.data-table td {
    vertical-align: top;
}

table.data-table
{
    font-family: arial, helvetica, sans-serif;
    font-size: 12px;
    background-color: #567596;
}

table.data-table caption
{
    padding-top: 10px;
    padding-bottom: 10px;
    text-align: left;
}

table.data-table th
{
    text-align: center;
    background-color: #cfdbef;
    height: 25px;
}

table.data-table td
{
    vertical-align: top;
}

table.data-table tr.odd
{
    background-color: #ffffff;
}

table.data-table tr.even
{
    background-color: #f6f6f6;
}

.data-table-button-bar
{
    padding-top: 10px;
    padding-bottom: 10px;
}

.data-table-container
{
    padding-top: 10px;
    padding-bottom: 10px;
}
-->
</STYLE>
</head>
<body>

<h1> Process: $workflow.Name
</h1>


<div class="data-table-container">
<table class="data-table" cellpadding="4" cellspacing="1" width="100%">
 <table-body>
  <tr class="data-table-head">
    <th scope="col" align="left" valign="middle"><strong>Job Name</strong></th>
    <th scope="col" align="left" valign="middle"><strong>Agent Name</strong></th>
    <th scope="col" align="left" valign="middle">Status</strong></th>
  </tr>
  #foreach($trace in $workflow.JobTraceList)
    <tr bgcolor="#ffffff">
      <td>$trace.Name</td>
      <td align="center">$trace.Agent</td>
      #set($status = $trace.Status)
      <td align="center">
        #if($trace.statusIsSuccess())
          <strong style="color: green">
        #elseif($trace.statusIsFailure())
          <strong style="color: red">
        #else
          <strong style="color: blue">
        #end
        $status</strong>
      </td>
    </tr>

    #foreach($step in $trace.StepList)
      <tr bgcolor="#ffffff">
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Step - $step.Name</td>
        <td align="center">$trace.Agent</td>
        #set($stepStatus = $step.Status)
        <td align="center">
          #if($step.statusIsSuccess())
            <strong style="color: green">
          #elseif($step.statusIsFailure())
            <strong style="color: red">
          #else
            <strong style="color: blue">
          #end
          $stepStatus</strong>
        </td>
      </tr>
    #end
  #end
 </table-body>
</table>
</div>

<a href="$workflow.Url">Build details</a> | <a href="$util.UserSubscriptionsUrl">Update subscriptions</a>

</body>
</html>

## END SECTION Body]]></template-text>
<description>A simple example of a velocity template for creating notification emails for notification service. This template also includes a listing of steps for each job.</description>
</template>
');;

INSERT INTO WORKFLOW_CASE_SELECTOR(ID, VERSION, NAME, DESCRIPTION, TYPE, SCRIPT)
    VALUES(0, 0, 'Workflow Success', 'Notifies when a workflow completes with success', 'WORKFLOW_END_EVENT', 'workflow.statusIsSuccess()');;
INSERT INTO WORKFLOW_CASE_SELECTOR(ID, VERSION, NAME, DESCRIPTION, TYPE, SCRIPT)
    VALUES(-1, 0, 'Workflow Fails', 'Notifies when a workflow terminates with a failed status', 'WORKFLOW_END_EVENT', '!workflow.statusIsSuccess()');;
INSERT INTO WORKFLOW_CASE_SELECTOR(ID, VERSION, NAME, DESCRIPTION, TYPE, SCRIPT)
    VALUES(-2, 0, 'Workflow Success or Failure', 'Notifies when a workflow completes regardless of status', 'WORKFLOW_END_EVENT', 'true');;
INSERT INTO WORKFLOW_CASE_SELECTOR(ID, VERSION, NAME, DESCRIPTION, TYPE, SCRIPT)
    VALUES(-3, 0, 'Build Request Failed', 'Notifies when a workflow request fails', 'BUILD_REQUEST_FAILED_EVENT', 'true');;
INSERT INTO WORKFLOW_CASE_SELECTOR(ID, VERSION, NAME, DESCRIPTION, TYPE, SCRIPT)
    VALUES(-8, 0, 'Failure or First Success After Failure', 'Notifies when a workflow terminates with a failed status or when it terminates with a success status after a failed workflow.', 'WORKFLOW_END_EVENT', 'var result = false
if (!workflow.statusIsSuccess()) {
    result = true
}
else {
    var prevBuildLife = workflow.getBuildLife().getPrevious()
    if (prevBuildLife != null) {
        var prevWorkflowCase = prevBuildLife.getWorkflow()
        if (prevWorkflowCase != null && prevWorkflowCase.isComplete() && !prevWorkflowCase.statusIsSuccess() && workflow.statusIsSuccess()) {
            result = true
        }
    }
}

result');;
INSERT INTO WORKFLOW_CASE_SELECTOR(ID, VERSION, NAME, DESCRIPTION, TYPE, SCRIPT)
    VALUES(-9, 0, 'Workflow Status Change', 'Notifies when a workflow terminates successfully when the previous invocation failed or when it fails and the previous invocation was successful.', 'WORKFLOW_END_EVENT', 'var result = false;
var prevBuildLife = workflow.getBuildLife().getPrevious()
if (prevBuildLife == null) {
    result = true
}
else {
    var prevWorkflowCase = prevBuildLife.getWorkflow()
    if (prevWorkflowCase == null || !prevWorkflowCase.isComplete() || prevWorkflowCase.statusIsSuccess() != workflow.statusIsSuccess()) {
        result = true
    }
}

result');;
INSERT INTO WORKFLOW_CASE_SELECTOR(ID, VERSION, NAME, DESCRIPTION, TYPE, SCRIPT)
    VALUES(-10, 0, 'Buildlife Status Applied Event', 'Notifies when a buildlife has a status applied to it', 'BUILD_LIFE_STATUS_APPLIED_EVENT', 'true');;

INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('ACTIVITY_FILTER', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('AGENT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('AGENT_FILTER_SCRIPT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('AGENT_POOL', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('AGENT_RELAY', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('ANNOUNCEMENT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('ARTIFACT_SET', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('AUDIT_ETY', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('AUDIT_FLD', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('AUDIT_TRX', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('AUDIT_UOW', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('BUILD_CONFIGURATION', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('BUILD_LIFE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('BUILD_LIFE_DEPENDENCY_PLAN', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('BUILD_PROFILE', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('BUILD_REQUEST', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('BUILD_WORKFLOW_SUMMARY', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('CLEANUP_CONFIG', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('CODESTATION_PROJECT', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('CODESTATION_BUILD_LIFE', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('COVERAGE_REPORT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('CUSTOM_OBJECT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('DASHBOARD_COLUMN', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('DASHBOARD_VIEW', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('DASHBOARD_WIDGET', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('DATABASE_HISTORY', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('DEPENDENCY', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('ISSUE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('ISSUE_TRACKER', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('JOB_CONFIG', 20);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('JOB_STEP_CONFIG', 20);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('JOB_PRE_CONDITION_SCRIPT', 20);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('JOB_TRACE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('JOB_STEP_TRACE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('LABEL', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('LOCK_HOLDER', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('LOCK_RES', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('MAVEN_REPOSITORY', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('NOTIFICATION_RECIPIENT_GEN', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('NOTIFICATION_SCHEME', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('NOTIFICATION_SUBSCRIPTION', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('POST_PROCESS_SCRIPT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('PROJECT', 20);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('PROJECT_TEMPLATE', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('PROPERTY_TEMPLATE', 100);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('PROXY', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REPORT', 100);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REPOSITORY', 20);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REPOSITORY_CHANGE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REPOSITORY_CHANGE_SET', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REPOSITORY_LISTENER', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REPOSITORY_TRIGGER', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REPOSITORY_USERS', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REPOSITORY_USER', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('REQUEST_PLAN', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('SCHEDULE', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('SINGLETON', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('SOURCE_ANALYTICS_REPORT', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('SOURCE_CONFIG', 20);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('SOURCE_CONFIG_TEMPLATE', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('STATUS', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('STEP_PRE_CONDITION_SCRIPT', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('TEMPLATE', 20);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('TEST_CASE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('TEST_REPORT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('TEST_SUITE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('TRIGGER_CODE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('UBUILD_USER', 100);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('USER_ANNOUNCEMENT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('USER_TASK', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORK_DIR_SCRIPT', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW', 50);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_ARTIFACT_DELIVER', 10);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_CASE', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_CASE_SELECTOR', 0);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_DEFINITION', 100);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_DEFINITION_JOB_CONFIG', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_JOB_CONFIG', 100);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_PRIORITY_SCRIPT', 1);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_TEMPLATE', 20);;
INSERT INTO HI_LO_SEQ(SEQ_NAME, HI_VAL) VALUES('WORKFLOW_TRIGGER', 10);;

