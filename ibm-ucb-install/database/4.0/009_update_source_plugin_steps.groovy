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

final def documentAsString = { data ->
    def result = null;
    if (data instanceof java.lang.String) {
        result = data
    }
    else {
        // it's a java.sql.Clob
        // just use getCharacterStream(), which returns a reader?
        result = data.getAsciiStream().text;
    }
    return result;
}

replaceStepConfigClass = {newClassName, oldClassName ->
    sql.eachRow("SELECT * FROM JOB_CONFIG_STEP WHERE CLASS = ? OR CLASS = ?", [oldClassName, newClassName]) { row ->
        Long id = row["ID"]
        String data = documentAsString(row['DATA'])
        data = data.replace(oldClassName, newClassName)
        sql.executeUpdate("UPDATE JOB_CONFIG_STEP SET DATA = ? WHERE ID = ?", [data, id])
    }
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// update

replaceStepConfigClass('com.urbancode.anthill3.domain.source.plugin.CleanupSourcePluginMetaStepConfig', 'com.urbancode.anthill3.domain.source.plugin.PluginCleanupStepConfig')
replaceStepConfigClass('com.urbancode.anthill3.domain.source.plugin.GetChangelogSourcePluginMetaStepConfig', 'com.urbancode.anthill3.domain.source.plugin.PluginGetChangelogStepConfig')
replaceStepConfigClass('com.urbancode.anthill3.domain.source.plugin.LabelSourcePluginMetaStepConfig', 'com.urbancode.anthill3.domain.source.plugin.PluginLabelpStepConfig')
replaceStepConfigClass('com.urbancode.anthill3.domain.source.plugin.PopulateWorkspaceSourcePluginMetaStepConfig', 'com.urbancode.anthill3.domain.source.plugin.PluginPopulateWorkspaceStepConfig')

return;
