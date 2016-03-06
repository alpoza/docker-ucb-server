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

final def getFirstChild = { element, childName ->
    def nodelist = element.getElementsByTagName(childName)
    return nodelist.length ? nodelist.item(0) : null // first child
}

final def getFirstChildText = { element ->
    def textNodes = element.childNodes.findAll{it.nodeType == Node.TEXT_NODE || it.nodeType == Node.CDATA_SECTION_NODE }
    return textNodes.collect{it.nodeValue}.join()
}

final def parseDocument = { data ->
    def result = null

    // data is either a String or a Clob
    Reader reader
    if (data instanceof java.lang.String) {
        reader = new StringReader((String)data)
    }
    else {
        // should we just use getCharacterStream(), which returns a reader?
        reader = data.getAsciiStream().newReader()
    }
    try {
        result = DOMBuilder.parse(reader)
    }
    finally {
        reader.close()
    }
    return result
}

final def getChildText = { element ->
    StringBuffer result = new StringBuffer();

    NodeList childNodeList = element.getChildNodes();
    Node childNode = null;
    
    if (childNodeList.getLength() > 0) {
        for (int i in 0..childNodeList.getLength()-1) {
            childNode = childNodeList.item(i);
            if (childNode != null) {
                if(childNode.getNodeType() == Node.TEXT_NODE ||
                    childNode.getNodeType() == Node.CDATA_SECTION_NODE) {
                    result.append(childNode.getNodeValue());
                }
            }
        }
    }
    return result.toString();
}

final def getFirstChildElementText = { element, childName ->
    NodeList nodeList = element.getElementsByTagName(childName);
    if (nodeList.getLength() > 0) {
        return getChildText(nodeList.item(0));
    }
    return null;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// update

sql.eachRow("SELECT ID, DATA FROM SOURCE_CONFIG WHERE PLUGIN_ID IS NULL") { row ->
    def id = row["ID"]
    def doc = parseDocument(row["DATA"])
    def docElement = doc.documentElement
    def templateElement = getFirstChild(docElement, 'template')
    def handleElement = getFirstChild(templateElement, 'handle')
    templateId = getFirstChildElementText(handleElement, 'id')
    
    sql.executeUpdate("UPDATE SOURCE_CONFIG SET TEMPLATE_ID = ? WHERE ID = ?", [templateId, id])
}

return;
