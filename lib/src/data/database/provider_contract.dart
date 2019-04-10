part of 'service.dart';

abstract class DatabaseProviderContract
{
    Database _database;

    String get table;

    Database get database => _database;

    DatabaseProviderContract(Database database) {
        _database = database;
    }

    Future<void> createTable();

    Future<List<Map<String, dynamic>>> retrieve({
        String where,
        List<String> whereArgs,
        String orderBy,
        int limit,
        int offset
    }) async {
        return await _database.query(
            table,
            where: where,
            whereArgs: whereArgs,
            orderBy: orderBy,
            limit: limit,
            offset: offset
        );
    }

    Future<int> persists(Map<String, dynamic> row) async
    {
        return await _database.insert(table, row);
    }

    Future<List<int>> persistsAll(List<Map<String, dynamic>> rows) async
    {
        List<int> ids = List<int>();

        for(Map<String, dynamic> row in rows) {
            ids.add(
                await persists(row)
            );
        }

        return ids;
    }

    Future<void> truncate() async
    {
        await _database.delete(table);
    }
}