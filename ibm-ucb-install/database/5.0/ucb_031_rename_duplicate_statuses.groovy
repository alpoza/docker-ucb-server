import groovy.sql.Sql;

import java.lang.*;
import java.sql.Connection;
import java.util.*;

// login information for database
// this should be modified as need be
Connection connection = (Connection) this.getBinding().getVariable("CONN")
Sql sql = new Sql(connection)
//------------------------------------------------------------------------------
sql.connection.autoCommit = false

String getStatusSql = "SELECT * FROM STATUS"
String updateStatusSql = "UPDATE STATUS SET NAME = ? WHERE ID = ?"

Map<String, List<String>> nameToStatusIdListMap = new HashMap<String, List<String>>()

sql.eachRow(getStatusSql) { row ->
    String id = (String) row['ID']
    String name = (String) row['NAME']

    List<String> statusIdList = nameToStatusIdListMap.get(name)
    if (statusIdList == null) {
        statusIdList = new ArrayList<String>()
        nameToStatusIdListMap.put(name, statusIdList)
    }
    statusIdList.add(id)
}

for (Map.Entry<String, List<String>> entry : nameToStatusIdListMap.entrySet()) {
    String name = entry.getKey()
    List<String> statusIdList = entry.getValue()
    for (int i = 1; i < statusIdList.size(); i++) {
        String id = statusIdList.get(i)
        String newName = "$name-$i"
        sql.executeUpdate(updateStatusSql, [newName, id])
    }
}
