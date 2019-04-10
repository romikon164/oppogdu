import '../service.dart';
import 'package:sqflite/sqflite.dart';

class NewsDatabaseProvider extends DatabaseProviderContract
{
    NewsDatabaseProvider(Database database) : super(database);

    String get table => "news";

    @override
    Future<void> createTable() async
    {
        database.execute("""
            CREATE TABLE IF NOT EXISTS $table (
                name VARCHAR(255) NOT NULL,
                image VARCHAR(255) NOT NULL,
                thumb VARCHAR(255) NOT NULL,
                content TEXT,
                created_at integer
            )
        """);
    }
}