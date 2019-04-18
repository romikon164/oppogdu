import '../service.dart';

class NewsDatabaseProvider extends DatabaseProviderContract
{
    NewsDatabaseProvider() : super();

    String get table => "news";

    @override
    Future<void> createTable() async
    {
        database.execute("""
            CREATE TABLE IF NOT EXISTS $table (
                id UNSIGNED INTEGER NOT NULL,
                name VARCHAR(255) NOT NULL,
                image VARCHAR(255),
                thumb VARCHAR(255),
                content TEXT,
                created_at integer
            )
        """);
    }
}