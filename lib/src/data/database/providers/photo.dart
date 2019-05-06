import '../service.dart';

class PhotoDatabaseProvider extends DatabaseProviderContract
{
    PhotoDatabaseProvider() : super();

    String get table => "photos";

    @override
    Future<void> createTable() async
    {
        database.execute("""
            CREATE TABLE IF NOT EXISTS $table (
                id UNSIGNED INTEGER NOT NULL,
                album_id UNSIGNED INTEGER NOT NULL,
                name VARCHAR(255) NOT NULL,
                description TEXT,
                image VARCHAR(255),
                thumb VARCHAR(255),
                created_at integer,
                views_count UNSIGNED INTEGER NOT NULL DEFAULT 0,
                favorites_count UNSIGNED INTEGER NOT NULL DEFAULT 0,
                is_viewed BOOLEAN DEFAULT 0,
                is_favorited BOOLEAN DEFAULT 0
            )
        """);
    }
}