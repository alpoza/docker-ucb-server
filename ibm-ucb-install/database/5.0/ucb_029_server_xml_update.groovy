import java.io.*;
import java.lang.*;
import java.util.*;

import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.*


Hashtable properties = (Hashtable) this.getBinding().getVariable("ANT_PROPERTIES");
String installServerDir = (String) properties.get("install.dir");
//------------------------------------------------------------------------------
// Inject sslEnabledProtocols attribute into server.xml if it doesn't exist
// Remove sslProtocol attribute from server.xml if it does exist
//------------------------------------------------------------------------------

def serverXmlFile = new File(installServerDir + "/opt/tomcat/conf/server.xml")
DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance()
DocumentBuilder builder = docBuilderFactory.newDocumentBuilder()
Document doc = builder.parse(serverXmlFile)
Element docEl = doc.getDocumentElement()

NodeList connectorNodes = docEl.getElementsByTagName("Connector")
connectorNodes.each {
    if (it.hasAttribute("SSLEnabled")) {
        if (it.hasAttribute("sslProtocol")) {
            it.removeAttribute("sslProtocol")
        }

        it.setAttribute("algorithm", '${install.server.ssl.algorithm}')
        it.setAttribute("ciphers", '${install.server.ssl.enabledCiphers}')
        it.setAttribute("sslEnabledProtocols", '${install.server.ssl.enabledProtocols}')
    }
}

NodeList contextNodes = docEl.getElementsByTagName("Context")
contextNodes.each {
    it.setAttribute("sessionCookieName", 'JSESSIONID_${install.server.web.port}')
}

writeDocToFile(serverXmlFile, doc)

/**
 * Replace an existing xml file with the contents of an xml document
 */
private void writeDocToFile(file, doc) {
    TransformerFactory transformerFactory = TransformerFactory.newInstance()
    Transformer transformer = transformerFactory.newTransformer()
    transformer.setOutputProperty(OutputKeys.INDENT, "yes")
    transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
    transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
    transformer.setOutputProperty(OutputKeys.STANDALONE, "no");
    // preserve doctype
    DocumentType documentType = doc.getDoctype();
    if (documentType != null) {
        transformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, documentType.getSystemId());
        transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, documentType.getPublicId());
    }
    StringWriter sw = new StringWriter()
    StreamResult result = new StreamResult(sw)
    DOMSource source = new DOMSource(doc)
    transformer.transform(source,result)
    String xmlString = sw.toString()

    // Delete the file.
    file.delete()
    // Write out our modified DOM to the file with Logger elements stripped.
    file.createNewFile()
    OutputStream outputStream = new FileOutputStream(file,false)
    try {
        outputStream.write( xmlString.getBytes() )
    } finally {
        if (outputStream != null) { outputStream.close() }
    }
}
