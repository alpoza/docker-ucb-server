/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
import com.urbancode.commons.util.crypto.CryptStringUtil;
import java.util.regex.Matcher
import groovy.sql.GroovyRowResult;
import groovy.sql.Sql;
import org.apache.tools.ant.BuildException
import com.urbancode.commons.util.IO;

public class uBuildInstaller {
    /**
     * Properties copied from the installer at some point
     */
    def installer = null
    def ant = null

    def portValidator = null
    def yesNoValidator = null
    def optionalValidator = null
    def requiredValidator = null
    def numberValidator = null

    def doUpgrade = false
    def srcDir = null
    def installDir = null

    /**
     * Properties given by existing installations or by the user during install
     */
    def externalUrl = null

    def jmsPort = null
    def jmsMutualAuth = null

    def dbType = null
    def dbUsername = null
    def dbPassword = null
    def dbUrl = null
    def dbSchema = null
    def dbDriver = null
    def dbDerbyPort = null
    def isDerby = false
    def dbDoNotCreateTables = null

    def installAcceptLicense = ''

    def rclLicensePath = null

    def installDbValidationQuery = null
    def dbConnectionValidationStatements = [
        'derby':     'values(1)',
        'mysql':     'select 1',
        'oracle':    'select 1 from dual',
        'sqlserver': 'select 1'
        ];

    // Classpath used for performing database actions
    def extclasspath = null

    /**
     * Constructor - set initial values taken from the container installer
     */
    uBuildInstaller(ContainerInstaller installer) {
        this.installer = installer
        ant = installer.ant

        portValidator = installer.portValidator
        yesNoValidator = installer.yesNoValidator
        optionalValidator = installer.optionalValidator
        requiredValidator = installer.requiredValidator
        numberValidator = installer.numberValidator
    }

    /**
     * Initialize the IBM UrbanCode Build installer from existing properties if present.
     */
    void initProperties() {
        externalUrl = ant.project.properties.'install.server.external.web.url'

        jmsPort = ant.project.properties.'install.server.jms.port'
        jmsMutualAuth = ant.project.properties.'install.server.jms.mutualAuth'

        dbType = ant.project.properties.'install.server.db.type'
        dbDerbyPort = ant.project.properties.'install.server.db.derby.port'

        dbUsername = ant.project.properties.'install.server.db.user'
        dbPassword = CryptStringUtil.class.decrypt(ant.project.properties.'install.server.db.password')
        dbUrl = ant.project.properties.'install.server.db.url'
        dbSchema = ant.project.properties.'install.server.db.schema'
        dbDriver = ant.project.properties.'install.server.db.driver'
        dbDoNotCreateTables = ant.project.properties.'install.server.db.no.create.tables'

        rclLicensePath = ant.project.properties.'install.rcl.license.path'
    }

    public void init() {
        def isYes = { answer -> ["Y", "YES"].find{ it.equalsIgnoreCase(answer) } != null }

        installAcceptLicense = this.installer.nonInteractive ? 'y' : ''
        def defaultAccept = installAcceptLicense ?: ''

        ConsolePager pager = new ConsolePager()
        pager.init()
        pager.doPause = !this.installer.nonInteractive || !isYes(defaultAccept)

        def licenseFileName = "LA_" + Locale.getDefault()
        def secondaryLicenseFileName = "LA_" + Locale.getDefault().getLanguage()
        def fallbackLicenseFileName = "LA_en"

        def license = this.class.classLoader.getResourceAsStream(licenseFileName)
        if (license == null) {
            license = this.class.classLoader.getResourceAsStream(secondaryLicenseFileName)
        }
        if (license == null) {
            license = this.class.classLoader.getResourceAsStream(fallbackLicenseFileName)
        }

        if (license == null) {
            println "Error: Could not locate a license file. Expected names: " + licenseFileName + ", " +
                    secondaryLicenseFileName + ", " + fallbackLicenseFileName;
            System.exit(1);
        }

        def licenseText = IO.readText(license, "UTF-8");
        pager.printText(licenseText)

        def answer = installer.prompt(null, "Do you accept the license? [y,n]", defaultAccept, yesNoValidator)
        if (!isYes(answer)) {
            // denied
            throw new BuildException("License must be accepted to continue");
        }
    }

    /**
     * Prompt for any values needed by the installer.
     */
    void getInput() {
        initProperties()

        doUpgrade = installer.doUpgrade

        jmsPort = installer.prompt(
                jmsPort,
                "Enter the port to use for agent communication. [Default: 7919]",
                "7919",
                portValidator)

        jmsMutualAuth = installer.prompt(
                jmsMutualAuth,
                "Do you want the Server and Agent communication to require mutual authentication?  This requires a " +
                "manual key exchange between server and each agent. See documentation for more details. y,N [Default: N]",
                "N",
                yesNoValidator)
        jmsMutualAuth = "Y".equalsIgnoreCase(jmsMutualAuth) || "YES".equalsIgnoreCase(jmsMutualAuth)

        if (!rclLicensePath || !doUpgrade) {
            rclLicensePath = installer.prompt(
                rclLicensePath,
                "Enter the port and hostname of a Rational License Key Server containing product licenses "+
                "for IBM UrbanCode Build in the form of port@hostname. "+
                "(e.g. 27000@licenses.example.com) Alternatively, you may leave this blank to begin "+
                "a 60-day evaluation period. [Default: none]",
                null,
                optionalValidator)
        }

        if (!doUpgrade) {
            def dbTypesAvailable = "[derby, mysql, oracle, sqlserver]"

            boolean promptDbType = true;
            while (promptDbType) {
                promptDbType = false;

                dbType = installer.prompt(
                        dbType,
                        "Enter the database type IBM UrbanCode Build should use. Derby is the default embedded database. " +
                        dbTypesAvailable,
                        "derby",
                        requiredValidator)

                if ("derby".equalsIgnoreCase(dbType)) {
                    dbDriver = "org.apache.derby.jdbc.ClientDriver"
                    if (dbDerbyPort == null) {
                        dbDerbyPort = "11378"
                    }
                    dbUrl = "jdbc:derby://localhost:"+dbDerbyPort+"/data"
                }
                else if ("sqlserver".equalsIgnoreCase(dbType)) {
                    dbDriver = installer.prompt(
                            dbDriver,
                            "Enter the database driver. [Default: com.microsoft.sqlserver.jdbc.SQLServerDriver]",
                            "com.microsoft.sqlserver.jdbc.SQLServerDriver",
                            requiredValidator)
                    installer.prompt('Please place the jar file containing the driver for your '+
                            'database inside the lib/ext directory in the IBM UrbanCode Build installer. '+
                            '(press enter to continue)')
                    dbUrl = installer.prompt(
                            dbUrl,
                            "Enter the database connection string. Eg. jdbc:sqlserver://localhost:1433;DatabaseName=ibm_ucb",
                            null,
                            requiredValidator)
                }
                else if ("mysql".equalsIgnoreCase(dbType)) {
                    dbDriver = installer.prompt(
                            dbDriver,
                            "Enter the database driver. [Default: com.mysql.jdbc.Driver]",
                            "com.mysql.jdbc.Driver",
                            requiredValidator)
                    installer.prompt('Please place the jar file containing the driver for your '+
                            'database inside the lib/ext directory in the IBM UrbanCode Build installer. '+
                            '(press enter to continue)')
                    dbUrl = installer.prompt(
                            dbUrl,
                            "Enter the database connection string. Eg. jdbc:mysql://localhost:3306/ibm_ucb",
                            null,
                            requiredValidator)
                }
                else if ("oracle".equalsIgnoreCase(dbType)) {
                    dbDriver = installer.prompt(
                            dbDriver,
                            "Enter the database driver. [Default: oracle.jdbc.driver.OracleDriver]",
                            "oracle.jdbc.driver.OracleDriver",
                            requiredValidator)
                    installer.prompt('Please place the jar file containing the driver for your '+
                            'database inside the lib/ext directory in the IBM UrbanCode Build installer. '+
                            '(press enter to continue)')
                    dbUrl = installer.prompt(
                            dbUrl,
                            "Enter the database connection string. Eg. jdbc:oracle:thin:@localhost:1521:sid",
                            null,
                            requiredValidator)
                    dbSchema = installer.prompt(
                            dbSchema,
                            "Enter the database schema name. (required if user has DBA role)",
                            null,
                            optionalValidator)
                    if (dbSchema != null) {
                        dbSchema = String.valueOf(dbSchema).toUpperCase()
                    }
                }
                else {
                    promptDbType = true;
                    dbType = null;
                }
            }

            dbUsername = installer.prompt(
                    dbUsername,
                    "Enter the database username. [Default: ibm_ucb]",
                    "ibm_ucb",
                    requiredValidator)
            dbPassword = installer.prompt(
                    dbPassword,
                    "Enter the database password. [Default: password]",
                    "password",
                    requiredValidator)

            if (!"derby".equalsIgnoreCase(dbType)) {
                dbDoNotCreateTables = installer.prompt(
                        dbDoNotCreateTables,
                        'Do database tables need to be created by a different user than the one entered? [y,N]',
                        'N',
                        yesNoValidator)
                if (dbDoNotCreateTables == 'Y' || dbDoNotCreateTables == 'y' || Boolean.valueOf(dbDoNotCreateTables)) {
                    installer.prompt("Please manually create the database tables with the required user. " +
                        "The script file can be found in the installer at ibm-ucb-install/database/${dbType}/schema.ddl " +
                        "and ibm-ucb-install/database/${dbType}/indexes_and_fks.ddl. (press return when complete)")
                }
            }
            else {
                dbDoNotCreateTables = 'N'
            }

            installDbValidationQuery = dbConnectionValidationStatements[dbType];
        }

        if (dbDriver.equals("org.apache.derby.jdbc.ClientDriver")) {
            isDerby = true
        }
    }

    /**
     * Perform any steps needed before the container installs.
     */
    void preContainerFileInstall() {
        installDir = installer.installServerDir;
        srcDir = installer.srcDir;

        // save off the plugin-content in webapps if it exists first
        ant.delete(dir: srcDir + "/backup/plugin-content")
        if (new File(installDir + "/opt/tomcat/webapps/ROOT/plugin-content").exists()) {
            ant.mkdir(dir: srcDir + "/backup")
            ant.move(file: installDir + "/opt/tomcat/webapps/ROOT/plugin-content", todir: srcDir + "/backup")
        }

        // copy opt before container installer because it modifies the server.xml file
        ant.copy(todir: installDir + "/opt", overwrite: true) {
            fileset(dir: srcDir + "/opt") {
                include(name: "**/*")
                exclude(name: "apache-ant*/")
                exclude(name: "groovy*/")
                exclude(name: "tomcat/**/*")
            }
        }
    }

    /**
     * Perform the actual installation/upgrade, after the container installs.
     */
    void postContainerFileInstall() {
        installDir = installer.installServerDir;
        srcDir = installer.srcDir;

        setupI18nFiles()
        setupILMTFiles()

        if (!externalUrl) {
            externalUrl = "Y".equalsIgnoreCase(installer.installServerWebAlwaysSecure) ? "https://" : "http://"
            externalUrl += installer.installServerWebHost + ":"
            externalUrl += installer.installServerWebHttpsPort ?: installer.installServerWebPort
        }

        extclasspath = ant.path() {
            fileset(dir: installDir) {
                include(name: "lib/ext/*.jar")
                include(name: "lib/ext/*.zip")
            }
            fileset(dir: srcDir + "/lib/ext") {
                include(name: "*.jar")
                include(name: "*.zip")
            }
            fileset(dir: srcDir + "/lib/install") {
                include(name: "*.jar")
                include(name: "*.zip")
            }
            fileset(dir: srcDir + "/lib") {
                include(name: "*.jar")
                include(name: "*.zip")
            }
        }

        ant.copy(todir: installDir + "/conf/server", overwrite: true) {
            fileset(dir: srcDir + "/conf/server") {
                include(name: "*")
                exclude(name: "rsa_api.properties")
                exclude(name: "upgrade.properties")
            }
        }
        ant.copy(todir: installDir + "/conf/server", overwrite: false) {
            fileset(dir: srcDir + "/conf/server") {
                include(name: "rsa_api.properties")
                include(name: "upgrade.properties")
            }
        }

        ant.copy(todir: installDir + "/opt/tomcat/webapps/ROOT", overwrite: true) {
            fileset(dir: srcDir + "/agentupgrade") {
                include(name: "air-agentupgrade.jar")
            }
        }

        // copy back any plugin content deployed
        if (new File(srcDir + "/backup").exists()) {
            ant.move(file: srcDir + "/backup/plugin-content", todir: installDir + "/opt/tomcat/webapps/ROOT")
        }

        try {
            boolean started = true;
            if (isDerby) {
                println("Starting embedded database ...")

                if (waitForDerby(0)) {
                    throw new Exception('Embedded database is already running, please shutdown before proceeding')
                }

                startDerby()

                started = waitForDerby(60)
                if (!started) {
                    println('Could not start database')
                }
                else {
                    println("Database Started")
                }
            }

            if (started) {
                if (doUpgrade) {
                    upgradeDatabase()
                }
                else {
                    installDatabase()
                }
                resetPatches()
                loadPlugins()
            }
        }
        finally {
            if (isDerby) {
                stopDerby()
            }

            def installedPropertiesFilePath = installDir + "/conf/server/installed.properties"

            ant.propertyfile(file: installedPropertiesFilePath) {
                entry(key: "install.server.db.derby.port", value: dbDerbyPort)
                entry(key: "install.server.db.driver", value: dbDriver)
                entry(key: "install.server.db.password", value: CryptStringUtil.class.encrypt(dbPassword))
                entry(key: "install.server.db.type", value: dbType)
                entry(key: "install.server.db.url", value: dbUrl)
                entry(key: "install.server.db.user", value: dbUsername)
                entry(key: "install.server.db.validationQuery", 'default': dbConnectionValidationStatements[dbType])
                entry(key: "install.server.db.no.create.tables", value: dbDoNotCreateTables)
                entry(key: "install.server.brokerConfigUrl", 'default': "xbean:activemq.xml")
                entry(key: "install.server.brokerUrl", 'default': "failover:(ah3://localhost:" + jmsPort + "?soTimeout=60000&daemon=true)")
                entry(key: "install.server.external.web.url", value: externalUrl)
                entry(key: "install.server.jms.mutualAuth", value: jmsMutualAuth)
                entry(key: "install.server.jms.port", value: jmsPort)
                entry(key: "install.server.key.password", 'default': CryptStringUtil.class.encrypt('changeit'))
                entry(key: "install.server.keystore", 'default': '../conf/server.keystore')
                entry(key: "install.server.keystore.password", 'default': CryptStringUtil.class.encrypt('changeit'))
                entry(key: "install.server.launchBrokerProcess", 'default': 'true')
                entry(key: "install.server.startBroker", 'default': 'false')
                entry(key: "install.accept.license", value: installAcceptLicense ?: 'N')
                entry(key: "install.rcl.server", value: rclLicensePath)
            }

            if (dbSchema != null) {
                ant.propertyfile(file: installedPropertiesFilePath) {
                    entry(key: "install.server.db.schema", value: dbSchema)
                }
            }

            if (!doUpgrade && "oracle".equalsIgnoreCase(dbType) && isOracle12(dbUrl, dbUsername, dbPassword, dbDriver)) {
                ant.propertyfile(file: installedPropertiesFilePath) {
                    entry(key: "hibernate.dialect", value: "org.hibernate.dialect.Oracle10gDialect")
                }
            }

            // write the agent min version
            ant.propertyfile(file: installDir + "/conf/installed.version") {
                entry(key: "agent.min.version", value: '4')
            }

            if (!doUpgrade) {
                def upgradePropertiesFilePath = installDir + "/conf/server/upgrade.properties"
                ant.propertyfile(file: upgradePropertiesFilePath) {
                    entry(key: '5.0.1.0_DeletedBuildRequestLogCleanup', value: 'true')
                }
            }

            makeJavaLibraryPath()
        }

        println("After starting the server, you may access the web UI by pointing your web-browser at")
        println(externalUrl)
    }

    /**
     * Upgrade an existing database
     */
    void upgradeDatabase() {
        // Provide location of install to upgrade scripts
        ant.property(name: "install.dir", value: installer.installServerDir)

        // run the upgrades
        ant.taskdef(
            name: "upgrade",
            classname: "com.urbancode.cm.db.updater.DbUpgradeTask",
            classpath: extclasspath)

        def dbUpgradeUsername = dbUsername
        def dbUpgradePassword = dbPassword
        if (dbDoNotCreateTables == 'Y' || dbDoNotCreateTables == 'y' || Boolean.valueOf(dbDoNotCreateTables)) {
            dbUpgradeUsername = installer.prompt(
                    null,
                    "Enter the database username to perform the upgrade.",
                    null,
                    requiredValidator)
            dbUpgradePassword = installer.prompt(
                null,
                "Enter the database password to perform the upgrade.",
                null,
                requiredValidator)

        }

        // change the base dir to the database directory while running the upgrade because the upgrade files reference
        // file relative to it
        def oldBaseDir = ant.project.baseDir
        try {
            // workflow schema in database/workflow to be used as a library
            // property sheet schema in database/property-sheets to be used as a library
            // plugin schema in database/plugin-server to be used as a library
            // security schema in database/security to be used as a library

            // IBM UrbanCode Build Schema
            println('Upgrading IBM UrbanCode Build Database Schema ...')
            ant.project.baseDir = new File(oldBaseDir, "database")
            ant.upgrade(
                driver:    dbDriver,
                url:       dbUrl,
                userid:    dbUpgradeUsername,
                password:  dbUpgradePassword,
                currentVersionSql: "SELECT VER FROM DB_VERSION WHERE RELEASE_NAME = ?",
                deleteVersionSql: "DELETE FROM DB_VERSION WHERE RELEASE_NAME = ?",
                updateVersionSql: "INSERT INTO DB_VERSION (RELEASE_NAME, VER) VALUES (?, ?)",
                classpath: extclasspath
            ) {
                fileset(dir: srcDir + "/database/" + dbType) {
                    include(name: "upgrade_sql_*.xml")
                }
            }
        }
        finally {
            ant.project.baseDir = oldBaseDir
        }

        println('Repairing Any Missing Permissions...')
        runGroovyScript('/database/repair_permissions.groovy',
                [dbDriver, dbUrl, dbUsername, dbPassword])
    }

    /**
     * Install a new database
     */
    void installDatabase() {
        def firstConnectUrl = dbUrl + (isDerby ? ';create=true' : '')

        if (dbType == 'sqlserver') {
            println('Checking SQL Server Database Collation ...')
            runGroovyScript('/database/check_collation.groovy',
                [dbDriver, dbUrl, dbUsername, dbPassword])
        }

        if (dbDoNotCreateTables == 'Y' || dbDoNotCreateTables == 'y' || Boolean.valueOf(dbDoNotCreateTables)) {
            println('Skipping table creation as instructed ...')
        }
        else {
            if (dbType == 'mysql') {
                initMySQL(dbUrl, dbUsername, dbPassword, dbDriver)
            }

            // create the database tables, foreign keys and indexes
            println('Creating IBM UrbanCode Build Database Schema ...')
            ant.sql(
                driver:    dbDriver,
                url:       firstConnectUrl,
                userid:    dbUsername,
                password:  dbPassword,
                classpath: extclasspath,
                delimiter: ';',
                src:       srcDir + '/database/' + dbType + '/schema.ddl'
            )
            ant.sql(
                driver:    dbDriver,
                url:       dbUrl,
                userid:    dbUsername,
                password:  dbPassword,
                classpath: extclasspath,
                delimiter: ';',
                src:       srcDir + '/database/' + dbType + '/indexes_and_fks.ddl'
            )
        }

        println('Seeding IBM UrbanCode Build Database ...')
        ant.taskdef(
            name:       'dbunit',
            classname:  'org.dbunit.ant.DbUnitTask',
            classpath: extclasspath
        )

        addSystemSettings()

        if (dbSchema) {
            ant.sql(
                    driver:    dbDriver,
                    url:       dbUrl,
                    userid:    dbUsername,
                    password:  dbPassword,
                    schema:    dbSchema,
                    classpath: extclasspath,
                    src:       srcDir + '/database/seed-data.sql',
                    delimiter: ';;'
            )
        }
        else {
            ant.sql(
                    driver:    dbDriver,
                    url:       dbUrl,
                    userid:    dbUsername,
                    password:  dbPassword,
                    classpath: extclasspath,
                    src:       srcDir + '/database/seed-data.sql',
                    delimiter: ';;'
            )
        }

        println('Seeding Workflow Engine Database ...')
        ant.sql(
            driver:    dbDriver,
            url:       dbUrl,
            userid:    dbUsername,
            password:  dbPassword,
            classpath: extclasspath,
            src:       srcDir + '/database/workflow/wf-seed-data.sql'
        )

        println('Seeding Property Sheets Database ...')
        ant.sql(
            driver:    dbDriver,
            url:       dbUrl,
            userid:    dbUsername,
            password:  dbPassword,
            classpath: extclasspath,
            src:       srcDir + '/database/property-sheets/ps-seed-data.sql'
        )

        println('Seeding Plugin Server Database ...')
        ant.sql(
            driver:    dbDriver,
            url:       dbUrl,
            userid:    dbUsername,
            password:  dbPassword,
            classpath: extclasspath,
            src:       srcDir + '/database/plugin-server/pl-seed-data.sql'
        )

        println('Seeding Security Database ...')
        ant.sql(
            driver:    dbDriver,
            url:       dbUrl,
            userid:    dbUsername,
            password:  dbPassword,
            classpath: extclasspath,
            src:       srcDir + '/database/security-seed-data.sql'
        )

        println('Seeding Reporting Database ...')
        ant.sql(
            driver:    dbDriver,
            url:       dbUrl,
            userid:    dbUsername,
            password:  dbPassword,
            classpath: extclasspath,
            src:       srcDir + '/database/reporting/seed-data.sql'
        )
        ant.sql(
            driver:    dbDriver,
            url:       dbUrl,
            userid:    dbUsername,
            password:  dbPassword,
            classpath: extclasspath,
            src:       srcDir + '/database/reporting-seed-data.sql'
        )

        println('Creating Permissions...')
        runGroovyScript('/database/install_permissions.groovy',
            [dbDriver, dbUrl, dbUsername, dbPassword])
    }

    /**
     * Start derby using the given directory and port
     */
    void startDerby() {
        new File(installDir, "var/db/").mkdirs()
        ant.java(
                classname: "org.apache.derby.drda.NetworkServerControl",
                fork:      'true',
                spawn:     'true',
                dir:       "$installDir/var/db/") {
            arg(value:'start')
            arg(value:'-h')
            arg(value:'localhost')
            arg(value:'-p')
            arg(value:dbDerbyPort)
            arg(value:'-noSecurityManager')
            classpath(){
                pathelement( location: "$srcDir/lib/derbynet.jar")
                pathelement( location: "$srcDir/lib/derby.jar")
            }
        }
    }

    /**
     * Stop derby using the given directory and port
     */
    void stopDerby() {
        println('Stopping embedded database ...')
        ant.java(
            classname: 'org.apache.derby.drda.NetworkServerControl',
            fork:      'true',
            inputstring: '',
            dir:       installDir + '/var/db/') {
            arg(value:'shutdown')
            arg(value:'-h')
            arg(value:'localhost')
            arg(value:'-p')
            arg(value:dbDerbyPort)
            classpath(){
                pathelement( location: srcDir + '/lib/derbynet.jar')
                pathelement( location: srcDir + '/lib/derby.jar')
            }
        }
    }

    /**
     * Pause until Derby has started up.
     */
    boolean waitForDerby(Integer numSeconds) {
        def control = new org.apache.derby.drda.NetworkServerControl(InetAddress.getByName('localhost'), Integer.valueOf(dbDerbyPort))
        boolean started = false
        int waitSeconds = numSeconds
        while (!started && waitSeconds >= 0) {
            try {
                control.ping() // throws exception if not started
                started = true
            }
            catch (Exception e) {
            }

            if (started || waitSeconds == 0) {
                break
            }

            // sleep at most 3 seconds between database tests
            long sleepTime = Math.min(waitSeconds, 3)
            println("\twaiting for db to start - $waitSeconds seconds remaining")
            Thread.sleep(sleepTime * 1000L)
            waitSeconds -= sleepTime
        }
        return started;
    }

    /**
     * Wrapper for println to channel through ant
     */
    private void println(displayText) {
        if (displayText != null) {
            ant.echo(displayText)
        }
    }

    void migrateDatabase() {
        initProperties()

        installDir = installer.installServerDir;
        srcDir = installer.srcDir;
        doUpgrade = installer.doUpgrade

        extclasspath = ant.path() {
            fileset(dir: installDir) {
                include(name: "lib/ext/*.jar")
                include(name: "lib/ext/*.zip")
            }
            fileset(dir: srcDir + "/lib/ext") {
                include(name: "*.jar")
                include(name: "*.zip")
            }
            fileset(dir: srcDir + "/lib/install") {
                include(name: "*.jar")
                include(name: "*.zip")
            }
            fileset(dir: srcDir + "/lib") {
                include(name: "*.jar")
                include(name: "*.zip")
            }
        }

        if (!doUpgrade) {
            println('Server not found to migrate')
        }
        else {
            def migrateFromDbDataFactory = "org.dbunit.dataset.datatype.DefaultDataTypeFactory"
            def migrateToDbDataFactory = "org.dbunit.dataset.datatype.DefaultDataTypeFactory"
            def migrateDbType
            def migrateDbDriver
            def migrateDerbyPort
            def migrateDbUrl
            def migrateDbSchema
            def migrateDbUser
            def migrateDbPwd

            if ('derby'.equalsIgnoreCase(dbType)) {
                dbDriver = 'org.apache.derby.jdbc.EmbeddedDriver'
                dbUrl = 'jdbc:derby:' + installDir + File.separatorChar + 'var' +
                        File.separatorChar + 'db' + File.separatorChar + 'data'
            }
            else if ('sqlserver'.equalsIgnoreCase(dbType)) {
                migrateFromDbDataFactory = "org.dbunit.ext.mssql.MsSqlDataTypeFactory"
            }
            else if ('mysql'.equalsIgnoreCase(dbType)) {
                migrateFromDbDataFactory = "org.dbunit.ext.mysql.MySqlDataTypeFactory"
            }
            else if ('oracle'.equalsIgnoreCase(dbType)) {
                migrateFromDbDataFactory = "org.dbunit.ext.oracle.Oracle10DataTypeFactory"
            }

            migrateDbType = installer.prompt(
                    migrateDbType,
                    'Enter the database type IBM UrbanCode Build should migrate to. [derby, mysql, oracle, sqlserver]',
                    'sqlserver',
                    requiredValidator)
            if ('derby'.equalsIgnoreCase(migrateDbType)) {
                migrateDbDriver = 'org.apache.derby.jdbc.ClientDriver'
                if (migrateDerbyPort == null) {
                    migrateDerbyPort = '11377'
                }
                migrateDbUrl = 'jdbc:derby://localhost:' + migrateDerbyPort + '/data'
            }
            else if ('sqlserver'.equalsIgnoreCase(migrateDbType)) {
                migrateDbDriver = installer.prompt(
                        migrateDbDriver,
                        'Enter the database driver. [Default: com.microsoft.sqlserver.jdbc.SQLServerDriver]',
                        'com.microsoft.sqlserver.jdbc.SQLServerDriver',
                        requiredValidator)
                installer.prompt('Please place the jar file containing the driver for your '+
                        'database inside the lib/ext directory in the IBM UrbanCode Build installer. '+
                        '(press enter to continue)')
                migrateDbUrl = installer.prompt(
                        migrateDbUrl,
                        'Enter the database connection string. Eg. jdbc:sqlserver://localhost:1433;DatabaseName=ubuild',
                        null,
                        requiredValidator)
                migrateToDbDataFactory = "org.dbunit.ext.mssql.MsSqlDataTypeFactory"
            }
            else if ('mysql'.equalsIgnoreCase(migrateDbType)) {
                migrateDbDriver = installer.prompt(
                        migrateDbDriver,
                        'Enter the database driver. [Default: com.mysql.jdbc.Driver]',
                        'com.mysql.jdbc.Driver',
                        requiredValidator)
                installer.prompt('Please place the jar file containing the driver for your '+
                        'database inside the lib/ext directory in the IBM UrbanCode Build installer. '+
                        '(press enter to continue)')
                migrateDbUrl = installer.prompt(
                        migrateDbUrl,
                        'Enter the database connection string. Eg. jdbc:mysql://localhost:3306/ubuild',
                        null,
                        requiredValidator)
                migrateToDbDataFactory = "org.dbunit.ext.mysql.MySqlDataTypeFactory"
            }
            else if ('oracle'.equalsIgnoreCase(migrateDbType)) {
            migrateDbDriver = installer.prompt(
                        migrateDbDriver,
                        "Enter the database driver. [Default: oracle.jdbc.driver.OracleDriver]",
                        "oracle.jdbc.driver.OracleDriver",
                        requiredValidator)
                installer.prompt('Please place the jar file containing the driver for your '+
                        'database inside the lib/ext directory in the IBM UrbanCode Build installer. '+
                        '(press enter to continue)')
                migrateDbUrl = installer.prompt(
                        migrateDbUrl,
                        "Enter the database connection string. Eg. jdbc:oracle:thin:@localhost:1521:sid",
                        null,
                        requiredValidator)
                migrateDbSchema = installer.prompt(
                        migrateDbSchema,
                        'Enter the database schema name. (required if user has DBA role)',
                        null,
                        optionalValidator)
                if (migrateDbSchema != null) {
                    migrateDbSchema = String.valueOf(migrateDbSchema).toUpperCase()
                }
                migrateToDbDataFactory = "org.dbunit.ext.oracle.Oracle10DataTypeFactory"
            }

            migrateDbUser = installer.prompt(
                    migrateDbUser,
                    "Enter the database username. [Default: ubuild]",
                    "ubuild",
                    requiredValidator)
            migrateDbPwd = installer.prompt(
                    migrateDbPwd,
                    'Enter the database password. [Default: password]',
                    'password',
                    requiredValidator)

            installDbValidationQuery = dbConnectionValidationStatements[migrateDbType];

            ant.taskdef(
                    name:       'dbunit',
                    classname:  'org.dbunit.ant.DbUnitTask',
                    classpath: extclasspath
                )

            // export the data
            println('\nExporting the current IBM UrbanCode Build database...\n')
            final def exportXmlFile = new File(srcDir + '/database/export.xml')
            if (exportXmlFile.exists()) {
                println('\nSkipping database export. Export file already exists: ' + exportXmlFile + '\n')
            }
            else {
                if (dbSchema != null && dbSchema.length() > 0) {
                    ant.dbunit(
                            driver:    dbDriver,
                            url:       dbUrl,
                            userid:    dbUsername,
                            password:  dbPassword,
                            schema:    dbSchema,
                            datatypeFactory: migrateFromDbDataFactory,
                            classpath: extclasspath) {
                                export(dest: exportXmlFile, format:'xml', ordered:true)
                            }
                } else {
                    ant.dbunit(
                            driver:    dbDriver,
                            url:       dbUrl,
                            userid:    dbUsername,
                            password:  dbPassword,
                            datatypeFactory: migrateFromDbDataFactory,
                            classpath: extclasspath) {
                                export(dest: exportXmlFile, format:'xml', ordered:true)
                            }
                }
                println('\nuBuild database exported\n')
            }

            println('Creating Database ...')
            final def firstConnectUrl = migrateDbUrl + ('derby'.equalsIgnoreCase(migrateDbType) ? ';create=true' : '')

            // create the database tables, foreign keys and indexes
            if (migrateDbType == 'mysql') {
                initMySQL(migrateDbUrl, migrateDbUser, migrateDbPwd, migrateDbDriver)
            }

            println('Creating IBM UrbanCode Build Database Schema ...')
            ant.sql(
                driver:    migrateDbDriver,
                url:       firstConnectUrl,
                userid:    migrateDbUser,
                password:  migrateDbPwd,
                classpath: extclasspath,
                src:       srcDir + '/database/' + migrateDbType + '/schema.ddl'
            )

            println('Importing Database ...')
            if (migrateDbSchema != null) {
                ant.dbunit(
                        driver:    migrateDbDriver,
                        url:       migrateDbUrl,
                        userid:    migrateDbUser,
                        password:  migrateDbPwd,
                        schema:    migrateDbSchema,
                        datatypeFactory: migrateToDbDataFactory,
                        classpath: extclasspath) {
                            operation(type: 'INSERT', src: exportXmlFile, format:'xml', ordered:true, transaction:false)
                        }
            } else {
                ant.dbunit(
                        driver:    migrateDbDriver,
                        url:       migrateDbUrl,
                        userid:    migrateDbUser,
                        password:  migrateDbPwd,
                        datatypeFactory: migrateToDbDataFactory,
                        classpath: extclasspath) {
                            operation(type: 'INSERT', src: exportXmlFile, format:'xml', ordered:true, transaction:false)
                        }
            }

            ant.sql(
                driver:    migrateDbDriver,
                url:       migrateDbUrl,
                userid:    migrateDbUser,
                password:  migrateDbPwd,
                classpath: extclasspath,
                src:       srcDir + '/database/' + migrateDbType + '/indexes_and_fks.ddl'
            )

            def installedPropertiesFilePath = installDir + "/conf/server/installed.properties"
            ant.propertyfile(file: installedPropertiesFilePath) {
                entry(key: "install.server.db.type", value: migrateDbType)
                entry(key: "install.server.db.derby.port", value: migrateDerbyPort)
                entry(key: "install.server.db.user", value: migrateDbUser)
                entry(key: "install.server.db.password", value: CryptStringUtil.class.encrypt(migrateDbPwd))
                entry(key: "install.server.db.url", value: migrateDbUrl)
                entry(key: "install.server.db.driver", value: migrateDbDriver)
                entry(key: "install.server.db.validationQuery", value: dbConnectionValidationStatements[migrateDbType])
            }
            if (migrateDbSchema != null) {
                ant.propertyfile(file: installedPropertiesFilePath) {
                    entry(key: "install.server.db.schema", value: migrateDbSchema)
                }
            }

            if ("oracle".equalsIgnoreCase(migrateDbType) && isOracle12(migrateDbUrl, migrateDbUser, migrateDbPwd, migrateDbDriver)) {
                ant.propertyfile(file: installedPropertiesFilePath) {
                    entry(key: "hibernate.dialect", value: "org.hibernate.dialect.Oracle10gDialect")
                }
            }
            else {
                ant.replace(file: installedPropertiesFilePath) {
                    replaceFilter(token: "hibernate.dialect", value: "#hibernate.dialect")
                }
            }

            ant.mkdir(dir: installDir + "/lib/ext")
            ant.copy(todir: installDir + "/lib/ext", overwrite: 'true') {
                fileset(dir: srcDir + "/lib/ext") {
                    include(name: "*.jar")
                    include(name: "*.zip")
                }
            }
        }

        println("\nuBuild database migration complete.\n")
    }

    /**
     * runs the specified script with the given arguments
     * @param script the path to the script ot run, given as relative to the src dir
     * @param args   the arguments to provide to the script
     */
    private void runGroovyScript(script, args) {
        // need groovy-all-*.jar and commons-cli.jar (and driver-class) on classpath
        ant.java(
                classname: 'groovy.lang.GroovyShell',
                fork: 'yes',
                inputstring: '',
                failonerror: true,
                dir: srcDir,
                classpath: extclasspath
                ) {
                    arg(value: new File(srcDir + '/' + script).canonicalPath)

                    for (argument in args) {
                        arg(value: argument)
                    }
                }
    }

    private void addSystemSettings() {
        Sql sql = Sql.newInstance(dbUrl, dbUsername, dbPassword, dbDriver);
        String systemSettingsClass = "com.urbancode.ubuild.domain.singleton.serversettings.ServerSettings"
        String settingsXml = genSystemSettingsXml()

        String systemSettingsInsertQuery = """INSERT INTO SINGLETON (ID, VERSION, CLASS, DATA)
            VALUES (0, 0, ?, ?)"""

        try {
            sql.connection.autoCommit = false;

            // Needs a classpath
            println "Adding Default System Settings ..."
            sql.executeUpdate(systemSettingsInsertQuery, [systemSettingsClass, settingsXml])
            sql.commit()
        }
        catch (Exception e) {
            sql.rollback()
            throw e
        }
    }

    private String genSystemSettingsXml() {
        def settingsXml

        def xmlBuilder = new groovy.xml.StreamingMarkupBuilder();
        xmlBuilder.encoding = "UTF-8"
        def xml = xmlBuilder.bind{
            mkp.xmlDeclaration()
            'server-settings' {
                'external-url'(externalUrl)
                'agent-external-url'(externalUrl)
                'cascade-props-to-deps'("false")
                'allow-dual-sessions'("true")
                'inherit-permissions'("true")
                'merge-manual-requests'("true")
                'rcl-server-url'(rclLicensePath)
            }
        }

        settingsXml = xml.toString()
    }

    private void loadPlugins() {
        // remove any plugin files still in stage directory (for any reason),
        //  prevents us loading multiple versions of a single plugin within one transaction,
        //  which may fail with strange errors.
        ant.echo("Copying Updated Plugins to Server plugin/stage ...")
        ant.delete(failonerror: false, includeEmptyDirs: true, verbose: true) {
            fileset(dir: installDir + '/plugin/stage') {
                include(name: '**/*.zip')
            }
        }

        // copy new/updated plugin files to stage
        ant.copy(todir:installDir + '/plugin/stage', overwrite:'true') {
            fileset(dir: srcDir + '/plugin/stage') {
                include(name: '*.zip')
            }
        }
    }

    private void resetPatches() {
        // disable all existing active patches
        if (doUpgrade && new File(installDir + "/patches").exists()) {
            ant.move(todir: installDir + "/patches", includeemptydirs: 'false', verbose: 'true') {
                fileset(dir: installDir + "/patches") {
                    include(name: "**/*.jar")
                }
                mapper(type: 'glob', from: '*.jar', to: '*.jar.off')
            }
        }
    }

    private void initMySQL(url, username, password, driver) {
        println "Checking MySQL Database Name ..."
        def dbName = url.split("//")[1]
        dbName = dbName.substring(dbName.indexOf("/") + 1)
        if (dbName.indexOf("/") != -1) {
            dbName = dbName.substring(0, dbName.indexOf("/"))
        }
        println "Found database '$dbName'"
        // Escape the database name to avoid any issues with illegal characters
        dbName = "\"${dbName}\""

        Sql sql = Sql.newInstance(url, username, password, driver);
        try {
            sql.connection.autoCommit = false;

            // Set the MySQL character escaping to use double quotes
            sql.execute("SET sql_mode='ANSI_QUOTES';");

            println "Setting MySQL Character Set and Collation to utf8 ..."
            def characterSetSql = "ALTER DATABASE " + dbName + " CHARACTER SET utf8;"
            sql.executeUpdate(characterSetSql)

            def collationSql = "ALTER DATABASE " + dbName + " COLLATE utf8_bin;"
            sql.executeUpdate(collationSql)

            sql.commit()
        }
        catch (Exception e) {
            sql.rollback()
            throw e
        }
        finally {
            if (sql) {
                sql.close();
            }
        }
    }

    private void setupI18nFiles() {
        println "Setting up internationalization files..."
        // Add a new line to the classpath.conf file for i18n files
        File classpathConf = new File(installDir + "/bin/classpath.conf")
        classpathConf.append("dir $installDir"
            + File.separator + "conf" + File.separator + "locale", "UTF-8");

        // copy new/updated i18n files to the server
        ant.copy(todir: installDir + '/conf/locale', overwrite:'true') {
            fileset(dir: srcDir + '/conf/locale') {
                include(name: '*.properties')
            }
        }

        // Set up plugin i18n classpath
        ant.mkdir(dir: installDir + '/plugin/locale')
        classpathConf.append(System.getProperty("line.separator") + "dir $installDir"
            + File.separator + "plugin" + File.separator + "locale", "UTF-8");
    }

    private void setupILMTFiles() {
        println "Setting up ILMT files..."
        ant.delete(dir: installDir + '/properties/version')
        ant.copy(todir: installDir + '/properties/version', overwrite:'true') {
            fileset(dir: srcDir + '/properties/version') {
                include(name: '*.swidtag')
            }
        }
    }

    private makeJavaLibraryPath() {
        def slash = File.separator;
        def supportedOs = [
            aix:     [x86: "aix"+slash+"32",          x64:"aix"+slash+"64"],
            linux:   [x86: "linux"+slash+"x386_32",   x64: "linux"+slash+"x386_64",   ppc: "linux-ppc"+slash+"64"],
            macosx:  [x86: "mac"+slash+"x86",         x64: "mac"+slash+"x86"],
            solaris: [x86: "solaris"+slash+"x386_32", x64: null],
            windows: [x86: "win"+slash+"x386_32",     x64: "win"+slash+"x386_64"]
        ]

        def javaLibraryPathCmd = null
        try {
            println("OS: " + installer.installOs)
            println("Architecture: " + installer.installArch)
            if (installer.installOs.equals("unknown")) {
                throw RuntimeException("Unknown OS")
            }
            def supportedArch = supportedOs.getAt(installer.installOs)
            if (supportedArch == null) {
                throw RuntimeException("OS may not be supported.")
            }
            def toUse = supportedArch.getAt(installer.installArch)
            if (toUse == null) {
                throw RuntimeException("Architecture may not be supported.")
            }

            javaLibraryPathCmd = "-Djava.library.path="

            // Sticking to filepath convention in ContainerInstaller
            def suffixUnix =  "\\\"" + installDir + "/lib/rcl/" + toUse + "\\\""
            def suffixWin = '"' + installDir + "\\lib\\rcl\\" + toUse + '"'
            def suffix = installer.isWindows ? suffixWin : suffixUnix

            def javaOptsFile = installDir+"/bin/set_env"
            if (installer.isWindows) {
                // Windows uses .cmd extension for set_env file
                javaOptsFile += ".cmd"

                // Update service files
                def serviceFile = installDir+"/bin/service/service.cmd"
                updateJavaOpts(serviceFile, ';' + javaLibraryPathCmd + suffix.substring(1, suffix.size() - 1))
                serviceFile = installDir+"/bin/service/_service.cmd"
                updateJavaOpts(serviceFile, ';' + javaLibraryPathCmd + suffix.substring(1, suffix.size() - 1))
            }

            // Update set_env file
            updateJavaOpts(javaOptsFile, javaLibraryPathCmd + suffix)
        }
        catch (RuntimeException e) {
            // Only display warning on new install
            if (!doUpgrade) {
                installer.prompt("[WARNING]  The detected operating system ("
                    + installer.installOs+") and architecture ("+installer.installArch
                    + ") may not be supported by the Rational Licensing server. You"
                    + " will need to supply the java.library.path argument and point"
                    + " it to the RCL API native library when starting your server."
                    + " You can do this by adding -Djava.library.path=\"path/to/library\""
                    + " in " + installDir + "/bin/set_env."
                    + "\n(press enter to continue)")
            }
        }
    }

    private updateJavaOpts(javaOptsFile, dswitch) {
        def javaLibPath = "-Djava.library.path"

        def setenv = new File(javaOptsFile)
        if (!setenv.getText("UTF-8").contains(javaLibPath)) {
            def replaced = setenv.getText("UTF-8").replaceAll(/(JAVA_OPTS=)(.*)/, {
                if (installer.isWindows) {
                    return it[0] + " " + dswitch
                }
                else {
                    return it[0].substring(0, it[0].size() - 1) + " " + dswitch + "\""
                }
            })
            setenv.withWriter("UTF-8") { out ->
                out.write(replaced);
            }
        }
    }

    private boolean isOracle12(String url, String username, String password, String driver) {
        boolean result = false;
        Sql sql = Sql.newInstance(url, username, password, driver);
        GroovyRowResult sqlRow = sql.firstRow('SELECT * FROM PRODUCT_COMPONENT_VERSION WHERE PRODUCT LIKE \'%Oracle%\'');
        String version = sqlRow.getProperty('VERSION');
        if (version.startsWith('12')) {
            result = true;
        }
        return result;
    }
}
