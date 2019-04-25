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
                intro_text VARCHAR(255),
                content TEXT,
                created_at integer,
                views_count UNSIGNED INTEGER NOT NULL DEFAULT 0,
                favorites_count UNSIGNED INTEGER NOT NULL DEFAULT 0,
                comments_count UNSIGNED INTEGER NOT NULL DEFAULT 0,
                is_viewed BOOLEAN DEFAULT 0,
                is_favorited BOOLEAN DEFAULT 0,
                shared_url VARCHAR(255) NOT NULL
            )
        """);
    }
}