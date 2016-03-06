import groovy.sql.Sql
import java.lang.*
import java.sql.Connection
import java.util.*

// login information for database
// this should be modified as need be
Hashtable properties = (Hashtable) this.getBinding().getVariable("ANT_PROPERTIES")
Connection connection = (Connection) this.getBinding().getVariable("CONN")
Sql sql = new Sql(connection)
sql.connection.autoCommit = false;

String getRolesWithAddManualStamp = "SELECT sec_role_id, sec_resource_role_id FROM sec_role_action WHERE sec_action_id = '00000000-0000-0000-0000-000000000070'"
String insertRoleActionSql =
        ''' INSERT INTO sec_role_action (
      id,
      version,
      sec_role_id,
      sec_action_id,
      sec_resource_role_id
    )
    VALUES (?, ?, ?, '00000000-0000-0000-0000-000000000071', ?)
'''

sql.eachRow(getRolesWithAddManualStamp) { row ->
    String roleId = row['sec_role_id']
    String resourceRoleId = row['sec_resource_role_id']
    sql.executeUpdate(insertRoleActionSql, [UUID.randomUUID().toString(), 0, roleId, resourceRoleId])
}
