import com.urbancode.vfs.store.ReferenceRebuilder
import org.apache.log4j.BasicConfigurator
import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.PatternLayout

BasicConfigurator.resetConfiguration()
Logger.getRootLogger().addAppender(new ConsoleAppender(new PatternLayout("%-5p [%t]: %m%n")))
Logger.getLogger("com.urbancode.vfs.store.ReferenceRebuilder").setLevel(Level.DEBUG)

Hashtable properties = (Hashtable) this.getBinding().getVariable("ANT_PROPERTIES")
String installServerDir = (String) properties.get("install.dir")

System.out.println("Rebuilding file references and cleaning up orphaned files. This could take a while.")
File csDir = new File(installServerDir, "/var/codestation")
ReferenceRebuilder rebuilder = new ReferenceRebuilder(csDir)
rebuilder.run()
