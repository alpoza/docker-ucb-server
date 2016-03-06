<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks"%>
<%@page import="com.urbancode.commons.webext.util.InstalledVersion"%>

<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="error" uri="error"%>

<ah3:useTasks class="com.urbancode.ubuild.web.admin.serversettings.ServerSettingsTasks" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.SystemTasks" />

<c:url var="viewUrl" value="${ServerSettingsTasks.viewDiagnostics}" />
<c:url var="doneUrl" value="${SystemTasks.viewIndex}" />
<c:url var="reloadi18nUrl" value="${ServerSettingsTasks.reloadInternationalizationFiles}" />

<%--  CONTENT --%>
<%
  try {
      String uBuildVersion = InstalledVersion.getInstance().getVersion();
      request.setAttribute("uBuildVersion", uBuildVersion);
      request.setAttribute("uBuildVersionIsDev", uBuildVersion != null && (uBuildVersion.endsWith("dev") ||
          uBuildVersion.endsWith("_dev")));
  }
  catch (Exception e) {
      // do nothing
  }
%>

<jsp:include page="/WEB-INF/snippets/header.jsp">
  <jsp:param name="title" value="${ub:i18n('SystemEditServerSettings')}" />
  <jsp:param name="selected" value="system" />
  <jsp:param name="disabled" value="false" />
</jsp:include>
<div style="padding-bottom: 1em;">
  <c:import url="tabs.jsp">
    <c:param name="selected" value="diagnostics" />
    <c:param name="disabled" value="false" />
  </c:import>
  <div class="contents">
    <div class="system-helpbox">${ub:i18n("SettingsDiagnosticsSystemHelpBox")}</div>
    <br />

    <span class="bold">${ub:i18n("SettingsDiagnosticsSelectMessage")}</span>
    <br/><br/>
    <form action="${viewUrl}" method="GET">
      <table class="wide-table">
        <tr style="vertical-align: top;">
          <td>
            <ucf:checkbox name="systemProperties" value="true" checked="${param.systemProperties}"/> ${ub:i18n("SystemProperties")}<br/>
            <ucf:checkbox name="threadCPUUsage" value="true" checked="${param.threadCPUUsage}"/> ${ub:i18n("ThreadCPUUsage")}<br/>
            <ucf:checkbox name="memory" value="true" checked="${param.memory}"/> ${ub:i18n("MemoryUsage")}<br/>
            <ucf:checkbox name="database" value="true" checked="${param.database}"/> ${ub:i18n("DatabaseConnections")}<br/>
            <ucf:checkbox name="uow" value="true" checked="${param.uow}"/> ${ub:i18n("UnitOfWorkUsage")}<br/>
          </td>
          <td>
            <ucf:checkbox name="requestContexts" value="true" checked="${param.requestContexts}"/> ${ub:i18n("ActiveRequestContexts")}<br/>
            <ucf:checkbox name="depCache" value="true" checked="${param.depCache}"/> ${ub:i18n("DependencyCache")}<br/>
            <ucf:checkbox name="scheduledItems" value="true" checked="${param.scheduledItems}"/> ${ub:i18n("ScheduledItems")}<br/>
            <ucf:checkbox name="eventService" value="true" checked="${param.eventService}"/> ${ub:i18n("EventServiceMetrics")}<br/>
          </td>
          <td>
            <ucf:checkbox name="patches" value="true" checked="${param.patches}"/> ${ub:i18n("Patches")}<br/>
            <ucf:checkbox name="logging" value="true" checked="${param.logging}"/> ${ub:i18n("LoggingConfiguration")}<br/>
            <ucf:checkbox name="csLocks" value="true" checked="${param.csLocks}"/> ${ub:i18n("CodeStationLocks")}<br/>
          </td>
          <c:if test="${uBuildVersionIsDev}">
            <td>
              <b>Dev Version Only:</b><br/>
              <ucf:checkbox name="activityGraphStore" value="true" checked="${param.activityGraphStore}"/> Activity Graph Cache<br/>
              <ucf:checkbox name="stepRunnableCache" value="true" checked="${param.stepRunnableCache}"/> Step Runnable Cache<br/>
              <ucf:checkbox name="colors" value="true" checked="${param.colors}"/> Colors<br/>
              <c:url var="reloadCssUrl" value="/bundles/ubuild.cssb">
                <c:param name="refreshKey">jawr.reload</c:param>
              </c:url>
              <ucf:link href="${reloadCssUrl}" label="Reload CSS"/><br/>
              <c:url var="reloadJsUrl" value="/bundles/ubuild.jsb">
                <c:param name="refreshKey">jawr.reload</c:param>
              </c:url>
              <ucf:link href="${reloadJsUrl}" label="Reload JavaScript"/><br/>
              <ucf:link href="${reloadi18nUrl}" label="Reload i18n Files"/><br/>
            </td>
          </c:if>
        </tr>
      </table>
      <br/>
      <ucf:button name="View" label="${ub:i18n('View')}"/>
    </form>

<c:if test="${param.requestContexts}">

  <%@page import="com.urbancode.ubuild.services.build.BuildService" %>
  <br/>
  <div class="note">
    <b>${ub:i18n("RequestContexts")}</b><br/>
    <pre><%=BuildService.getInstance().toString()%></pre>
  </div>

</c:if>

<c:if test="${param.threadCPUUsage}">
  <%@page import="java.lang.management.*" %>
  <%@page import="com.urbancode.commons.util.Duration" %>
  <%@page import="java.util.*" %>
  <br/>
  <div class="note">
    <table class="data-table">
      <tr>
        <th>${ub:i18n("Thread")}</th>
        <th>${ub:i18n("Trace")}</th>
        <th>${ub:i18n("CPUTime")}</th>
      </tr>
  <%
      ThreadMXBean threadMBean = ManagementFactory.getThreadMXBean();
        if (threadMBean.isThreadCpuTimeEnabled()) {
            long[] threadIds = threadMBean.getAllThreadIds();
            ThreadInfo[] threadInfos = threadMBean.getThreadInfo(threadIds, 10);
            Arrays.sort(threadInfos, new Comparator() {
        public int compare(Object obj1, Object obj2) {
            return ((ThreadInfo) obj1).getThreadName().compareToIgnoreCase(((ThreadInfo) obj2).getThreadName());
        }
            });
            for (int t=0; t<threadInfos.length; t++) {
              String threadDuration = new Duration(threadMBean.getThreadCpuTime(threadInfos[t].getThreadId()) / 1000000).getLeastUnit(true, true);
              pageContext.setAttribute("threadInfo", threadInfos[t]);
              pageContext.setAttribute("threadDuration", threadDuration);
  %>
      <tr class="<%=(t % 2 == 0) ? "even" : "odd"%>">
        <td style="vertical-align: top;">${fn:escapeXml(threadInfo.threadName)}</td>
        <td>${fn:escapeXml(threadInfo.threadState)}<br/>
          <small>
  <%
      StackTraceElement[] stack = threadInfos[t].getStackTrace();
        for (int s=0; s<stack.length; s++) {
          pageContext.setAttribute("stack", stack[s]);
  %>${fn:escapeXml(stack)}<br/><%
      }
  %>
            </small>
        </td>
        <td nowrap="nowrap" style="text-align: right; vertical-align: top;">${fn:escapeXml(threadDuration)}</td>
      </tr>
  <%
      }
  %>
  <%
      } else {
  %>
  <tr><td colspan="4">${ub:i18n("SettingsDiagnosticsThreadNoMonitoringMessage")}</td></tr>
  <%
      }
  %>
    </table>
  </div>
</c:if>


<c:if test="${param.systemProperties}">
  <%@ page import="java.util.*" %>
  <br/>
  <div class="note">
    <b>${ub:i18n("SystemPropertiesWithColon")}</b><br/>
  <%
      Properties props = System.getProperties();
      List propList = new ArrayList();
      propList.addAll(props.keySet());
      Collections.sort(propList);
      for (int i=0; i<propList.size(); i++) {
        String propName = (String) propList.get(i);
        String propValue = System.getProperty(propName);
        pageContext.setAttribute("propName", propName);
        pageContext.setAttribute("propValue", propValue);
  %>
  ${fn:escapeXml(propName)} = ${fn:escapeXml(propValue)}<br/>
  <%
      }
  %>
  </div>
</c:if>

<c:if test="${param.scheduledItems}">
  <br/>
  <div class="note">
    <b>${ub:i18n("Scheduler")}</b><br/>
  <%@ page import="com.urbancode.ubuild.services.scheduler.Scheduler" %>
  <%
      org.quartz.Scheduler scheduler = (org.quartz.Scheduler) Scheduler.getInstance().getImplementation();
        for (String jobGroupName : scheduler.getJobGroupNames()) {
            pageContext.setAttribute("jobGroupName", jobGroupName);
  %>
  <br/><span class="bold">${fn:toLowerCase(ub:i18n(jobGroupName))}:</span><br/>
  <%
      pageContext.removeAttribute("jobGroupName");
      for (String jobName : scheduler.getJobNames(jobGroupName)) {
  %>
  &nbsp;&nbsp;&nbsp;-&nbsp;<%=jobName%><br/>
  <%
      }
        }
  %>
  </div>
</c:if>


<c:if test="${param.eventService}">
  <%@page import="java.util.concurrent.ThreadPoolExecutor" %>
  <%@page import="java.lang.management.*" %>
  <%@page import="java.lang.reflect.*" %>
  <%@page import="java.util.*" %>

  <br/>
  <div class="note">
    <b>${ub:i18n("EventService")}</b><br/>
  <%@ page import="com.urbancode.ubuild.services.scheduler.Scheduler" %>
  <%
      com.urbancode.ubuild.services.event.EventService eService = com.urbancode.ubuild.services.event.EventService.getInstance();
        pageContext.setAttribute("eventService", eService);
        java.util.concurrent.ExecutorService exec = null;
        Field executorField = eService.getClass().getDeclaredField("executor");
        if (executorField != null) {
            executorField.setAccessible(true);
            exec = (java.util.concurrent.ExecutorService)executorField.get(eService);
        }
        pageContext.setAttribute("eventThreadPool", exec);
        if (exec instanceof java.util.concurrent.ThreadPoolExecutor) {
  %>
  <pre>
    ${ub:i18n("ListenerCount")}    ${eventService.listenerCount}
    ${ub:i18n("ActiveThreads")}    ${eventThreadPool.activeCount}
    ${ub:i18n("PoolCurrentSize")} ${eventThreadPool.poolSize}
    ${ub:i18n("PoolCoreSize")}    ${eventThreadPool.corePoolSize}
    ${ub:i18n("PoolLargestSize")} ${eventThreadPool.largestPoolSize}
    ${ub:i18n("PoolMaximumSize")} ${eventThreadPool.maximumPoolSize}
    ${ub:i18n("QueuedTasks")}      ${fn:length(eventThreadPool.queue)}
    ${ub:i18n("CompletedTasks")}   ${eventThreadPool.completedTaskCount}
    ${ub:i18n("TotalTasks")}       ${eventThreadPool.taskCount}
  </pre>
  <% } else if (exec == null) { %>
     ${ub:i18n("SettingsDiagnosticsNoExecutorMessage")}
  <% } else { %>
     ${ub:i18nMessage("SettingsDiagnosticsNoDiagnosticsMessage", eventThreadPool.class.name)}
  <% } %>
  </div>
</c:if>

<c:if test="${param.patches}">
  <%@page import="com.urbancode.commons.fileutils.FileUtils" %>
  <%@page import="java.io.*" %>
  <%@page import="java.util.*" %>
  <%@page import="java.util.zip.*" %>
<%
  Map<ZipFile, List<String>> zipMap = new HashMap<ZipFile, List<String>>();
  File patchesDir = new File("../patches");
  File[] patchFiles = patchesDir.listFiles();
  for (File patchFile : patchFiles) {
      if (patchFile.getName().endsWith(".jar")) {
          // patch file!
          ZipFile zipFile = new ZipFile(patchFile);
          List<String> entryList = new ArrayList<String>();
          for (ZipEntry zipEntry : Collections.list(zipFile.entries())) {
               if (!zipEntry.isDirectory() && !zipEntry.getName().contains("META-INF") && !zipEntry.getName().endsWith(".diff")) {
                   // its a meaningful file
                   entryList.add(zipEntry.getName());
               }
          }
          zipMap.put(zipFile, entryList);
      }
  }

  Set<ZipFile> jarsInConflict = new HashSet<ZipFile>();
  Set<String> entriesInConflict = new HashSet<String>();
  ZipFile[] zipFiles = zipMap.keySet().toArray(new ZipFile[zipMap.size()]);
  for (int i=0; i<zipFiles.length; i++) {
      ZipFile zipFile = zipFiles[i];
      List<String> zipEntries = zipMap.get(zipFile);

      for (int j=0; j<zipFiles.length; j++) {
          if (i != j) {
              ZipFile compareTo = zipFiles[j];
              List<String> compareEntries = zipMap.get(compareTo);

              List<String> dupeZipEntries = new ArrayList<String>(zipEntries);
              List<String> dupeCompareEntries = new ArrayList<String>(compareEntries);

              dupeZipEntries.retainAll(compareEntries);
              dupeCompareEntries.retainAll(zipEntries);

              if (!dupeZipEntries.isEmpty() || !dupeCompareEntries.isEmpty()) {
                  jarsInConflict.add(zipFile);
                  jarsInConflict.add(compareTo);

                  entriesInConflict.addAll(dupeZipEntries);
                  entriesInConflict.addAll(dupeCompareEntries);
              }
          }
      }
  }
  pageContext.setAttribute("jarConflictSize", jarsInConflict.size());
  pageContext.setAttribute("entryConflictSize", entriesInConflict.size());
%>
  <br/>
  <div class="note">
  <b>${ub:i18n("SettingsDiagnosticsPatchApplied")}</b><br/>
  <br/>
<%
  if (jarsInConflict.isEmpty()) {
%>
  <i>${ub:i18n("SettingsDiagnosticsPatchNoneMessage")}</i>
<%
  }
  else {
      %>
      <span class="error">${ub:i18nMessage("SettingsDiagnosticsPatchFileConflictMessage", jarConflictSize)}&nbsp;
            ${ub:i18nMessage("SettingsDiagnosticsPatchEntryConflictMessage", entryConflictSize)}</span>
    <%
  }
  pageContext.removeAttribute("jarConflictSize");
  pageContext.removeAttribute("entryConflictSize");
%>
  <br/>
  <br/>
  <table class="data-table">
<%
  Arrays.sort(zipFiles, new Comparator<ZipFile>() {
     public int compare(ZipFile zf1, ZipFile zf2) {
         return zf1.getName().compareTo(zf2.getName());
     }
  });
  for (ZipFile zipFile : zipFiles) {
      List<String> zipEntries = zipMap.get(zipFile);
      Collections.sort(zipEntries);
%>
    <tbody>
      <tr>
        <th style="text-align: left;<%= jarsInConflict.contains(zipFile) ? " background: red;" : "" %>">
          <a style="pointer: cursor;<%= jarsInConflict.contains(zipFile) ? " color: white;" : "color: black;" %>"
            title="${ub:i18n('ShowHideDetails')}" onclick="$(this).up('tbody').next('tbody').toggle(); return false;">
            ${ub:i18n("SettingsDiagnosticsPatchFile")} <%= zipFile.getName() %>
          </a>
        </th>
      </tr>
    </tbody>
    <tbody style="display: none;">
<%
      for (String zipEntry : zipEntries) {
%>
      <tr>
        <td style="padding-left: 25px;<%= jarsInConflict.contains(zipFile) ? " background: red; color: white;" : "" %>"><%= zipEntry %></td>
      </tr>
<%
      }
%>
    </tbody>
<%
  }
%>
  </table>
  </div>
</c:if>

<c:if test="${param.database}">
  <%@page import="com.urbancode.ubuild.spring.SpringSupport" %>
  <%@page import="com.urbancode.persistence.ClassMetaData" %>
  <%@page import="com.urbancode.persistence.FieldMetaData" %>
  <%@page import="javax.sql.DataSource" %>
  <br/>
  <div class="note">
    <b>${ub:i18n("DatabaseConnectionsWithColon")}</b><br/>
    <br/>
    <table class="data-table" style="width: 100%;">
      <tr>
        <th>${ub:i18n("Pool")}</th>
        <th width="200">${ub:i18n("Active")}</th>
        <th width="200">${ub:i18n("Idle")}</th>
      </tr>
      <%
      DataSource dataSource = (DataSource) SpringSupport.getInstance().getBean("dataSource");
      pageContext.setAttribute("dataSource", dataSource);
      %>
      <c:set var="targetDataSource" value="${dataSource.targetDataSource}"/>
      <%
      DataSource targetDataSource = (DataSource) pageContext.getAttribute("targetDataSource");
      FieldMetaData fmd = ClassMetaData.get("com.p6spy.engine.spy.P6DataSource").getFieldMetaData("rds");
      DataSource realDataSource = (DataSource) fmd.extractValue(targetDataSource);
      pageContext.setAttribute("realDataSource", realDataSource);
      %>
      <tr>
        <td>${ub:i18n("SettingsDiagnosticsDataSource")} (${realDataSource.class.name})</td>
        <td align="center">${realDataSource.numActive}</td>
        <td align="center">${realDataSource.numIdle}</td>
      </tr>
      <%-- Enable if com.urbancode.ubuild.persistence.Java6UBuildConnection logging is DEBUG --%>

      <tr>
        <td colspan="3"><pre>${realDataSource}</pre></td>
      </tr>
      <%
      DataSource identityDataSource = (DataSource) SpringSupport.getInstance().getBean("identityDataSource");
      DataSource identityRealDataSource = (DataSource) fmd.extractValue(identityDataSource);
      pageContext.setAttribute("identityRealDataSource", identityRealDataSource);
      %>
      <tr>
        <td>${ub:i18n("SettingsDiagnosticsIdentitySource")} (${identityRealDataSource.class.name})</td>
        <td align="center">${identityRealDataSource.numActive}</td>
        <td align="center">${identityRealDataSource.numIdle}</td>
      </tr>
    </table>
  </div>
</c:if>

<c:if test="${param.logging}">
  <br/>
  <div class="note">
    <b>${ub:i18n("LoggingAppenders")}</b><br/>
    <%@ page import="org.apache.log4j.Appender" %>
    <%@ page import="org.apache.log4j.Logger" %>
    <%@ page import="org.apache.log4j.LogManager" %>
    <%
    Enumeration appenderEnum = LogManager.getRootLogger().getAllAppenders();
    while (appenderEnum.hasMoreElements()) {
        Appender appender = (Appender) appenderEnum.nextElement();
        %>
        <%= appender.getName() %> - <%= appender.getClass() %><br/>
        <%
    }
    %>
    <br/>
    <b>${ub:i18n("Loggers")}</b><br/>
    <%
    List loggerList = Collections.list(LogManager.getCurrentLoggers());
    Collections.sort(loggerList, new Comparator() {
       public int compare(Object obj1, Object obj2) {
           Logger logger1 = (Logger) obj1;
           Logger logger2 = (Logger) obj2;

           return logger1.getName().compareTo(logger2.getName());
       }
    });
    pageContext.setAttribute("loggerList", loggerList);
    %>
    <c:forEach var="logger" items="${loggerList}">
      ${fn:escapeXml(logger.name)} -
      <c:if test="${logger.level ne null}"> ${ub:i18n(fn:escapeXml(logger.level))}</c:if><br/>
    </c:forEach>
  </div>
</c:if>

<c:if test="${param.csLocks}">
  <br/>
  <div class="note">
    <b>${ub:i18nMessage("SettingsDiagnosticsCodestationLocks", "Codestation")}</b><br/>
  <%@ page import="com.urbancode.ubuild.domain.buildlife.*" %>
  <%@ page import="com.urbancode.codestation2.server.*" %>
  <%@ page import="com.urbancode.codestation2.server.locking.*" %>
  <%
  pageContext.setAttribute("csLocks", CodestationRepositoryLockManagerFactory.getLockManager().getAllLocks());
  %>
  <c:forEach var="csLock" items="${csLocks}">
    ${fn:escapeXml(csLock.holder.acquirer)} - ${fn:escapeXml(csLock)}<br/>
  </c:forEach>
  <%
  %>
  </div>
</c:if>

<c:if test="${param.depCache}">
  <%@page import="com.urbancode.ubuild.domain.profile.BuildProfile" %>
  <%@page import="com.urbancode.ubuild.domain.profile.BuildProfileFactory" %>
  <%@page import="com.urbancode.ubuild.services.build.*" %>
  <br/>
  <div class="note">
    <b>${ub:i18n("DependencyCacheWithColon")}</b>
    <table class="data-table">
      <tr>
        <th>${ub:i18n("Project")}</th>
        <th>${ub:i18n("DepType")}</th>
        <th>${ub:i18n("BuildLifeDependenciesDependsOn")}</th>
      </tr>
      <%
      pageContext.setAttribute("buildProfiles", BuildProfileFactory.getInstance().restoreAll());
      %>
      <c:forEach var="profile" items="${buildProfiles}">
        <%
        BuildProfile profile = (BuildProfile) pageContext.getAttribute("profile");
        ProfileDependencyCache depCache = ProfileDependencyCache.getCache(profile);

        Set<ProfileDependencyCache> pullSet = new HashSet<ProfileDependencyCache>();
        depCache.getDirectCachesToPull(pullSet);
        pageContext.setAttribute("pullSet", pullSet);

        Set<ProfileDependencyCache> pushSet = new HashSet<ProfileDependencyCache>();
        depCache.getDirectPushingCaches(pushSet);
        pageContext.setAttribute("pushSet", pushSet);
        %>
        <c:forEach var="pullCache" items="${pullSet}">
          <%
          ProfileDependencyCache pullCache = (ProfileDependencyCache) pageContext.getAttribute("pullCache");
          BuildProfile depProfile = (BuildProfile) pullCache.getProcessHandle().dereference();
          pageContext.setAttribute("depProfile", depProfile);
          %>
          <tr>
            <td>${profile.projectAndWorkflowName}</td>
            <td>${fn:toUpperCase(ub:i18n("Pull"))}</td>
            <td>${depProfile.projectAndWorkflowName}</td>
          </tr>
        </c:forEach>
        <c:forEach var="pushCache" items="${pushSet}">
          <%
          ProfileDependencyCache pushCache = (ProfileDependencyCache) pageContext.getAttribute("pushCache");
          BuildProfile depProfile = (BuildProfile) pushCache.getProcessHandle().dereference();
          pageContext.setAttribute("depProfile", depProfile);
          %>
          <tr>
            <td>${profile.projectAndWorkflowName}</td>
            <td>${fn:toUpperCase(ub:i18n("Push"))}</td>
            <td>${depProfile.projectAndWorkflowName}</td>
          </tr>
        </c:forEach>
      </c:forEach>
    </table>
  </div>
</c:if>

<c:if test="${param.memory}">
  <c:import url="memory.jsp"/>
</c:if>

<c:if test="${param.uow}">
  <c:import url="uows.jsp"/>
</c:if>

<c:if test="${param.colors}">
  <%@page import="com.urbancode.ubuild.domain.buildrequest.BuildRequestStatusEnum" %>
  <%@page import="com.urbancode.ubuild.services.jobs.JobStatusEnum" %>
  <%@page import="com.urbancode.ubuild.domain.workflow.WorkflowStatusEnum" %>
<%
  pageContext.setAttribute("requestStatuses", BuildRequestStatusEnum.values());
%>
  <table style="width: 400px;">
    <caption>${ub:i18n("RequestStatuses")}</caption>
    <c:forEach var="status" items="${requestStatuses}">
      <tr>
        <td style="color: ${status.secondaryColor}; background: ${status.color};">${status.name}</td>
      </tr>
    </c:forEach>
  </table>
<%
  pageContext.setAttribute("jobStatuses", JobStatusEnum.values());
%>
  <table style="width: 400px;">
    <caption>${ub:i18n("JobStatuses")}</caption>
    <c:forEach var="status" items="${jobStatuses}">
      <tr>
        <td style="color: ${status.secondaryColor}; background: ${status.color};">${status.name}</td>
      </tr>
    </c:forEach>
  </table>
<%
  pageContext.setAttribute("workflowStatuses", WorkflowStatusEnum.values());
%>
  <table style="width: 400px;">
    <caption>${ub:i18n("WorkflowStatuses")}</caption>
    <c:forEach var="status" items="${workflowStatuses}">
      <tr>
        <td style="color: ${status.secondaryColor}; background: ${status.color};">${status.name}</td>
      </tr>
    </c:forEach>
  </table>
</c:if>

<c:if test="${param.activityGraphStore}">
  <%@page import="com.urbancode.commons.service.ServiceRegistry" %>
  <%@page import="com.urbancode.air.workflow.ActivityGraph" %>
  <%@page import="com.urbancode.air.workflow.WorkflowRuntime" %>
  <%@page import="com.urbancode.air.workflow.persistence.InMemoryActivityGraphPersistenceService" %>
  <%
  WorkflowRuntime workflowRuntime = ServiceRegistry.getInstance().getInstance(WorkflowRuntime.class);
  InMemoryActivityGraphPersistenceService graphService =
          (InMemoryActivityGraphPersistenceService) workflowRuntime.getActivityGraphPersistenceService();
  Field id2graphField = graphService.getClass().getDeclaredField("id2graph");
  id2graphField.setAccessible(true);
  pageContext.setAttribute("id2graph", id2graphField.get(graphService));
  %>
  <div style="margin: 10px 0px;"><b class="bold">Number of Activity Graphs Cached:</b> ${fn:length(id2graph)}</div>
</c:if>

<c:if test="${param.stepRunnableCache}">
  <%@page import="com.urbancode.ubuild.services.steps.StepExecutorService" %>
  <%
  StepExecutorService stepExecutor = ServiceRegistry.getInstance().getInstance(StepExecutorService.class);
  Field jobTraceIdStepRunnableMapField = stepExecutor.getClass().getDeclaredField("jobTraceIdStepRunnableMap");
  jobTraceIdStepRunnableMapField.setAccessible(true);
  pageContext.setAttribute("jobTraceIdStepRunnableMap", jobTraceIdStepRunnableMapField.get(stepExecutor));
  %>
  <div style="margin: 10px 0px;"><b class="bold">Number of Step Runnables Cached:</b> ${fn:length(jobTraceIdStepRunnableMap)}</div>
</c:if>

  </div>
</div>
<jsp:include page="/WEB-INF/snippets/footer.jsp" />
