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

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.*;

final String driver = args[0]
final String url = args[1]
final String usr = args[2]
final String pwd = args[3]

final boolean verbose = Boolean.valueOf(properties.get("verbose")).booleanValue();

//==============================================================================
final Sql sql = Sql.newInstance(url, usr, pwd, driver);
try { // catch-rollback & finally-close
    sql.connection.autoCommit = false;

    //------------------------------------------------------------------------------
    //utility methods
    
    final def error = { message -> println('!!'+message); }
    final def warn  = { message -> println(message); }
    final def debug = { message ->
        if (verbose) {
            println(message);
        }
    }
    
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    // update
    
    debug("Validating database sequences");
    
    sql.eachRow("SELECT SEQ_NAME, HI_VAL FROM HI_LO_SEQ ORDER BY SEQ_NAME") { row ->
    
        def seqName = row['SEQ_NAME'];
        def seqVal = row['HI_VAL'];
        
        warn("Checking $seqName sequence")
        try {
            def maxIdRow = sql.firstRow("SELECT MAX(ID) AS MAX_ID FROM " + seqName)
            def maxId = maxIdRow['MAX_ID']
            
            if (maxId > seqVal) {
                warn("Table $seqName contains identifiers that are higher than the sequence value for generating them!")
                warn("Updating $seqName sequence to $maxId")
                sql.executeUpdate("UPDATE HI_LO_SEQ SET HI_VAL = ? WHERE SEQ_NAME = ?", [maxId + 1, seqName])
            }
        }
        catch (Exception e) {
            warn("Assuming table $seqName does not exist")
        }
    }
    
    debug("Finished validating database sequences");
    sql.commit();
}
catch (Exception e) {
    sql.rollback();
    throw e;
}
finally {
    sql.close();
}

return;